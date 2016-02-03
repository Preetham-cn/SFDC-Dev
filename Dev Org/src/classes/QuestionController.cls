/* This controller is used to create new Questions for MIG   */

public with sharing class QuestionController
{

    public Question__c ques {get; set;}
    public Boolean type {get;set;}
    public Boolean Mandatory {get;set;}
    public Map<String,String> fieldAPI{get;set;}
    
    public QuestionController(ApexPages.StandardController controller) {
        this.ques = (Question__c)Controller.getRecord();
        type = false;
        Mandatory= true;
        fieldAPI = new Map<String,String>();
    }
   
  // to render the section after JS call
    public void findQuestion(){

                
    } 
 
  
    public PageReference SaveMethod(){
    
   // Question__c quesav = new Question__c(Type__c =ques.Type__c , Status__c =ques.Status__c ,Question__c =ques.Question__c  ,Please_provide_length_of_Number__c =ques.Please_provide_length_of_Number__c );
    //insert quesav;
   system.debug('QUESTION TYPE:'+ques);
   
   try{
    
    if(ques.Source_Field__c!=null)
    {
    ques.Source_Field_API__c = fieldAPI.get(ques.Source_Field__c);
    }
    
    
    if(ques.Table_Fields__c!=null)
    
    {
      String tableAPIField;
      String tableFields='';
      String labelFields='';
      system.debug('@@TableFields'+ques.Table_Fields__c);
      
      List<SelectOption> options = new List<SelectOption>();
      ques.Table_Fields__c.removeStart ('[');
      ques.Table_Fields__c.removeEnd(']');
      system.debug('***selected table values'+ques.Table_Fields__c);    
      for(String s: ques.Table_Fields__c.split(','))
      {
          
          
          system.debug('@@inside'+s.trim()+'@@Map'+fieldAPI);
          
          if(s!=null && s!='')
          {
                if(s.startsWith('['))
                {
                s=s.remove('[');
                }
                else if(s.endsWith(']'))
                {
                s=s.remove(']');
                }
                tableAPIField = fieldAPI.get(s.trim());
                labelFields += s.trim()+';';
                system.debug('@@Table Fields'+tableAPIField);
                
                if(tableAPIField!=null)
                {
                tableFields +=tableAPIField+';';
                }
             
        }
       }

         ques.Source_Field_API__c = tableFields;   
         ques.Table_Fields__c =  labelFields;    
    }
        insert ques;
        PageReference QPage = new PageReference('/' + ques.id);
        system.debug('@@Page'+Qpage);
        QPage.setRedirect(true);
        return QPage;
    }
    catch(Exception e)
    {
           
            ApexPages.addMessages(e);
            return null;
    }
  }
   
   public static PageReference listView(Schema.sObjectType destinationSObject) {
   Schema.DescribeSObjectResult destination = destinationSObject.getDescribe();
   PageReference pageRef = new PageReference('/' + destination.getKeyPrefix() );
   pageRef.setRedirect(true);
   return pageRef;
    }
    public PageReference Cancel(){
    Mandatory=false;
    system.debug(Mandatory + ' Mandatory ');
    return listView(Question__c.sObjectType); 
    }
    
  public List<SelectOption> getObjs()

    {

  List<SelectOption> options = new List<SelectOption>();

   Schema.DescribeFieldResult fieldResult = Question__c.Source_Object__c.getDescribe();

   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
     options.add(new SelectOption('', '--None--'));

        

   for( Schema.PicklistEntry f : ple)

   {

      options.add(new SelectOption(f.getLabel(), f.getValue()));

   }       

   return options;

 }  
 
   public List<SelectOption> getFields() {
        List<SelectOption> fields = new List<SelectOption>();
        
        fields.add(new SelectOption('', '--None--'));
        if(ques.Source_Object__c!=null)
        {
            system.debug('Source Object'+ques.Source_Object__c);
            fieldAPI = Utility.showFields(ques.Source_Object__c);
            system.debug('FieldMap'+fieldAPI);
            for(String s : fieldAPI.keySet())
            {
                fields.add(new SelectOption(s, s));

            }
         }
         
         return fields;

    }


}