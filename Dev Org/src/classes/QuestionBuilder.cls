/* 

This class is to generate the question under section and pages as per the select form. This controller is used to display content for Review Page.


*/

public class QuestionBuilder
{
                     
                        
    public string recID {get;set;} 
    public Map<Id,Template_Page__c> tempPageMap{get;set;}
    public Map<Id,List<Page_Section__c>> pageSectionMap{get;set;}
    public Map<Id,List<Section_Question__c>> secQuestionMap{get;set;}
    public Map<String,Object> fieldObjMap{get;set;}
    public String QID{get;set;}
    public Map<ID,Question__c> questionMap{get;set;}  
    public Boolean formComplete{get;set;}  
    public Map<String,Form_Answer__c> answerMap{get;set;}
    public Set<ID> qIDs{get;set;}
    public list<SelectOption> options{get;set;} 
    public Map<Id,List<SelectOption>> optionsMap{get;set;}
    public Map<Id,List<sObject>> ObjectList {get; set;}  
    public string tableFields{get;set;}
    public Map<Id,List<String>> fieldsList{get;set;} 
    public ID tblQID{get;set;}
    public String pageName{get;set;}
    public ID pageIdQ {get;set;}
    public Set<ID> secquesIDs{get;set;}
    public List<Question__c> ques{get;set;} 
     
    public List<Question__c> qList{get;set;}
    public List<Page_Section__c>secList{get;set;}  
    public Id qReviewId{get;set;}
    public List<Section_Question__c> secQuesList{get;set;}
    public List<SelectOption> opts {get;set;}   
    public Map<String,List<Question_Section_Branching__c>> qnBranchMap{get;set;}
    public List<SelectOption> selectedOptions{ get; set; }
    public set<ID> dependantids{get;set;}
    public Boolean fetchAnsMap{get;set;}
    public ID pageID {get;set;}    
    public String type {get;set;}
    public List<Template__c> templateInfo{get;set;}
    public ID templateID{get;set;}
    public Account accInfo{get;set;}
    public Boolean formNotStarted{get;set;}
    public Boolean answeredForm{get;set;}
    public ID caseId{get;set;}
    public Form__c igform{get;set;}
    public Map <string, List <String>> SelectedOptsMap {get;set;}
    public List <string> selectedCheck {get;set;}
    //public Map<String, IGCaseFieldMapping__c> casefieldMap {get;set;}
    public String userType{get;set;}
    

    
   public QuestionBuilder()
   {
     
     userType = UserInfo.getUserType();
     //casefieldMap = IGCaseFieldMapping__c.getAll();
     selectedCheck = new List <String> ();
     SelectedOptsMap = new Map<string,List<String>> ();
     fetchAnsMap=true;
     formComplete = true;
     formNotStarted= true;

     dependantids = new set<ID>();
     qnBranchMap = new Map<String,List<Question_Section_Branching__c>> ();
     templateInfo = new List<Template__c>();     
     options = new list<SelectOption>();  
     fieldsList = new Map<Id,List<String>> (); 
     ObjectList = new Map<Id,List<sObject>>();
     optionsMap = new Map<Id,List<SelectOption>>();    
     qIDs = new Set<ID>();
     secquesIDs = new Set<ID>();
     tableFields ='';
     questionMap = new Map<ID,Question__c>();    
     answerMap = new Map<String,Form_Answer__c>();
     fieldObjMap = new Map<String,Object> ();
     recID = ApexPages.currentPage().getParameters().get('id');
     type = ApexPages.currentPage().getParameters().get('type');
     tempPageMap = new Map<ID,Template_Page__c>();
     pageSectionMap= new Map<Id,List<Page_Section__c>>();
     secQuestionMap = new Map<Id,List<Section_Question__c>>();
     selectedOptions = new List<SelectOption>();          
     qReviewId = ApexPages.currentPage().getParameters().get('reviewId');
     system.debug('##qReviewId: '+qReviewId+'@@userType'+userType);
     
     if(qReviewId==null)
     {
         for (Template_Page__c tempPage :[Select Id, Name, Status__c, Display_Name__c,Form__c,Sort_Order__c, Page__c,Template__c From Template_Page__c WHERE Form__c=:recID ORDER BY Sort_Order__c])
         {
             tempPageMap.put(tempPage.Page__c,tempPage);
             templateID = tempPage.Template__c;
             if(tempPage.Status__c!='Completed')
             {
                formComplete=false;
             }
             if(temppage.Status__c!='Not Started')
             {
                 formNotStarted=false;
             }
         }
          system.debug('##For tempPageMap: '+tempPageMap);
     }
       
      
     
          
     // query only if review id is not null, Review ID is the template page id to display the Review Page.     
     if(qReviewId!=null)
     {
         for (Template_Page__c tempPage :[Select Id, Name, Status__c, Display_Name__c,Form__c,Sort_Order__c, Page__c From Template_Page__c WHERE Id=:qReviewId  LIMIT 1])
         {
              pageID=tempPage.Page__c;
              recID =tempPage.Form__c;
              pageName = tempPage.Display_Name__c;              
         }
         system.debug('##pageID: '+pageID);
     }
    
    if(recId!=null)
     {
         igform=[Select Id, Name, Account__c,Status__c,Template__c,Version__c FROM Form__c WHERE id=:recID LIMIT 1];
        
         //caseId = igform.Case__c;
     }
              
    if(type=='pdf' || formComplete && qReviewId==null)
     {
        templateInfo = [Select Id,Name,Description__c,Header__c,Status__c FROM Template__c WHERE id=:igform.Template__c];
        
     }
     
     List<Page_Section__c> pageSectionList = new List <Page_Section__c>();
     List<Section_Question__c> secQuestionList = new List<Section_Question__c>(); 
     Set<Id> sectionIds = new Set<Id>();
     set<ID> tempgKeys = new set<ID>();       
     tempgKeys = tempPageMap.keySet();    
     String pgsecQuery;
     
     //Query the Page section for Review Page or Question Builder Page separately.
     if(qReviewId!=null)
     {
     
         pgsecQuery = 'Select Id, Name,Display_Name__c,Section__c,Page__c,Sort_Order__c From Page_Section__c WHERE Page__c =';
         pgsecQuery += '\'';
         pgsecQuery += pageID;
         pgsecQuery += '\'';
         pgsecQuery +=' AND Form__c =';
         pgsecQuery +='\'';
         pgsecQuery += recID;
         pgsecQuery +='\'';         
         pgsecQuery +=' ORDER BY Sort_Order__c';

     }
     else      
     {
         pgsecQuery = 'Select Id, Name,Display_Name__c,Section__c,Page__c,Sort_Order__c From Page_Section__c WHERE Page__c IN:tempgKeys';                          
         pgsecQuery +=' AND Form__c =';
         pgsecQuery +='\'';
         pgsecQuery += recID;
         pgsecQuery +='\'';
         pgsecQuery +=' ORDER BY Sort_Order__c';

     }
     
       system.debug('##pgsecQuery: '+pgsecQuery);
  
     for(Page_Section__c pageSec:Database.Query(pgsecQuery))
     {
   
        if(!pageSectionMap.containsKey(pageSec.Page__c) )
         {
    
              sectionIds.add(pageSec.Section__c);
              pageSectionMap.put(pageSec.Page__c,new List<Page_Section__c>{pageSec});        
         }
         else
         {
    
             sectionIds.add(pageSec.Section__c);         
             pageSectionList = pageSectionMap.get(pageSec.Page__c);
             pageSectionList.add(pageSec); 
             pageSectionMap.put(pageSec.Page__c,pageSectionList);
    
         }
      }
  
          
     //Fetch the Section Question
     for(Section_Question__c secQuestion:[Select Id, Name,Required__c,Section__c,Question__c,Sort_Order__c  From Section_Question__c WHERE Section__c IN:sectionIds AND Form__c =:recID ORDER BY Sort_Order__c])
     {
        qIDs.add(secQuestion.Question__c); 
        secquesIDs.add(secQuestion.id);
          if(!secQuestionMap.containsKey(secQuestion.Section__c))
          {
    
              secQuestionMap.put(secQuestion.Section__c,new List<Section_Question__c>{secQuestion});

          }
         else
           {
             secQuestionList = secQuestionMap.get(secQuestion.Section__c);
             secQuestionList.add(secQuestion);
             secQuestionMap.put(secQuestion.Section__c,secQuestionList);        
          }
             
     }
    
    // Get the list of dependant question for the driver from Question Section Branching. This Map drives the Branching Logic.    
    /*for(Question_Section_Branching__c secQNBranch:[Select Id, Name,Comparison_Operator__c,Driver__c,Section_Question__c,Dependant_Key__c,Driver_Section__c,Dependant_QuestionID__c ,Question_to_Enable__c,Status__c,Numeric_Comparison_Value__c,Text_Comparison_Value__c FROM Question_Section_Branching__c WHERE Form__c =:recID AND Status__c='Active'])
    {
          List<Question_Section_Branching__c> childLst = new  List<Question_Section_Branching__c>();
          String unique;
          unique =  secQNBranch.Driver_Section__c;
          unique += secQNBranch.Section_Question__c;        
          dependantids.add(secQNBranch.Question_to_Enable__c);        
          
          
        if(!qnBranchMap.containsKey(unique))
        {
            qnBranchMap.put(unique,new List<Question_Section_Branching__c>{secQNBranch});             
        }
        else if(qnBranchMap.containsKey(unique))
        {
            childLst = qnBranchMap.get(unique);
            childLst.add(secQNBranch);
            qnBranchMap.put(unique,childLst);
        }
        
    }*/
       
                           
             
    if(recId!=null && qReviewId==null)
    {
        for(Form_Answer__c answer: [SELECT id,Page_Section__r.Display_Name__c,Name,Question_Number__c,Direction__c,Required__c,Enabled__c,Type__c,Template_Page__c,Page_Section__c,Section_Question__c,Text__c,Numeric__c,Date__c,Currency__c,Email__c,Check_Box__c,Text_Area__c,Form__c FROM Form_Answer__c WHERE Form__c=:recID])
        {
            String unique;
            unique=answer.Page_Section__c;
            unique +=answer.Section_Question__c;
            if (answer.Type__c == 'Multi Select Check Box' && answer.Text__c != null)
            {
               for (String s : answer.Text__c.split (';'))
               {
                  selectedCheck.add(s);
                  system.debug('selectedCheck: '+selectedCheck);
               }                                      
             }
            SelectedOptsMap.put(unique,selectedCheck);
            answerMap.put(unique, answer);

        }
        system.debug('@@AnswerMap'+answerMap);
    }   
        
    if(qReviewId!=null)
    {
        for(Form_Answer__c answer: [SELECT id,Page_Section__r.Display_Name__c,Name,Question_Number__c,Direction__c,Required__c,Enabled__c,Type__c,Template_Page__c,Page_Section__c,Section_Question__c,Text__c,Numeric__c,Date__c,Currency__c,Email__c,Check_Box__c,Text_Area__c,Form__c FROM Form_Answer__c WHERE Template_Page__c=:qReviewId])
        {
            String unique;
            unique=answer.Page_Section__c;
            unique +=answer.Section_Question__c;
            answerMap.put(unique, answer);
        }  
                
    }
    
    if(answerMap.size()>0)
    {                       
       fetchAnsMap = false;        
    }
       
    if(questionMap.isEmpty())
    {
        ques = [ SELECT id,Name,All_Records__c ,Static__c,Question_Text__c,List_of_Options__c,Help_Text__c,Source_Field_API__c,Table_Fields__c,Source_Field__c,Source_Object__c,Display__c,Question_Type__c,Note__c FROM Question__c Where ID IN:qIDs];    
    }
    else
    {
        ques =  questionMap.values();      
    }
     
    String accFields;
    String fields;
    Map<String,String>   sObjFieldMap = new  Map<String,String>();
    Map<String,List<Sobject>> sObjMap = new  Map<String,list<Sobject>>();
    Map<String,Boolean> caseAssociated = new Map<String,Boolean>();
    Set<ID> qnids = new Set<ID>();
    accFields ='SELECT Id,OwnerId,CreatedDate,Owner.Name,Type,Name,';  
    // Prepare query to get Case Info and fields list for question which are having All records or Records Associated with Case.           
    for(Question__c qsCsFlds: ques)
    {
        
        if(qsCsFlds.Static__c  && qsCsFlds.Source_Object__c == 'Account' && qsCsFlds.Source_Field_API__c!=null)
        {
            
            if(qsCsFlds.Source_Field_API__c!='Id' || qsCsFlds.Source_Field_API__c!='Name' ||  qsCsFlds.Source_Field_API__c!='OwnerId' || qsCsFlds.Source_Field_API__c!='Type' ||  qsCsFlds.Source_Field_API__c!='CreatedDate')
            {
                accFields +=qsCsFlds.Source_Field_API__c+',';
            }

        }
         
                      
        if(!sObjFieldMap.containsKey(qsCsFlds.Source_Object__c) && qsCsFlds.Source_Object__c!=null && qsCsFlds.Source_Field_API__c!=null && qsCsFlds.All_Records__c )
        {
            fields = '';
            fields = qsCsFlds.Source_Field_API__c;
            sObjFieldMap.put(qsCsFlds.Source_Object__c,fields);
            
        }
        else if(sObjFieldMap.containsKey(qsCsFlds.Source_Object__c) && qsCsFlds.Source_Field_API__c!=null && qsCsFlds.All_Records__c )
        {
            fields = '';
            fields = sObjFieldMap.get(qsCsFlds.Source_Object__c);                                    
            String [] splitFields;
            splitFields = fields.split(',');
            system.debug('@@Split'+splitFields);
            for(String spl:splitFields)
            {
                
                if(spl!=qsCsFlds.Source_Field_API__c)
                {
                fields +=','+qsCsFlds.Source_Field_API__c;
                sObjFieldMap.put(qsCsFlds.Source_Object__c,fields);
                }
            } 
            qnids.add(qsCsFlds.id);
            system.debug('@@sobj fields'+fields);
            
                                                         
        }
    system.debug('@@ sobjMap2'+sObjFieldMap); 
    }
    
    accFields = accFields.substring(0,accFields.length()-1);     
    accFields +=' FROM Account WHERE id=';
    accFields += '\'';
    accFields += igform.Account__c;
    accFields += '\'';
    accFields += ' LIMIT 1 '; 
    system.debug('@@Case Fields Query'+ accFields);      
    accInfo = Database.Query(accFields);
    
    
    for(String sobj:sObjFieldMap.keySet())
    {
        List<sObject> sobLst = new List<sObject>();

        String formQuery;
        formQuery ='Select ';
        formQuery += sObjFieldMap.get(sobj);
        formQuery += ' FROM '+sobj;
        formQuery +=' LIMIT 400';
        system.debug('@@formQuery'+formQuery);
        if(Limits.getQueries() < 90) // run the queries only if query already run is less than 90
        {  
            try
            {
              sobLst = Database.Query(formQuery);
            }
            catch(Exception e)
            {
                system.debug('@@Catch Exception'+e);
            }
               sObjMap.put(sobj,sobLst);
            }
     }      
    
        
    for(Question__c qs:ques)
    {                               
    if(qs.Question_Type__c == 'Picklist' || qs.Question_Type__c=='Radio' || qs.Question_Type__c=='Multi Check Box')
     {
       opts = new List<SelectOption>();
       
              
       if(qs.Question_Type__c == 'Picklist' )
       {
            opts.add(new SelectOption('None','None'));
       }
       
       if(qs.List_of_Options__c!=null)
       {
           
           for(String s : qs.List_of_Options__c.split(';'))
           {
              opts.add(new SelectOption(s,s));
           }
           optionsMap.put(qs.Id,opts); 
           
               
       }
       else if(qs.Source_Object__c!=null && qs.Source_Field_API__c !=null && !qs.All_Records__c )
       {

           opts.addAll(getOptions(qs.Source_Object__c,qs.Source_Field_API__c));       
           optionsMap.put(qs.Id,opts); 
               
       }
 
     }
     
   // If the Question Type is Table , then form the query dynamically and query it. User wil be informed to use minimum table question since the query has to be rund ynamically inside for loop.       
    if(qs.Question_Type__c == 'Table' && qs.Source_Field_API__c!=null && !ObjectList.ContainsKey(qs.id) )
    {
       tableFields ='';
       tableFields = qs.Source_Field_API__c.replace(';',',');       
       tableFields= qs.Source_Field_API__c.remove('[');
       tableFields = qs.Source_Field_API__c.remove(']');
       tableFields = tableFields.replace(';',',');
       tableFields= tableFields.removeEnd(',');
        
        fieldsList.put(qs.id,tableFields.split(',')); 
        
        List<sObject> sobLst = new List<sObject>();
        String query;
        query ='Select ';
        query +=tableFields;
        query +=' FROM ';
        query +=qs.Source_Object__c;                     
        if(qs.Source_Object__c=='Account')
        {
            query +=' WHERE Id=';
            query += '\'';
            query +=igform.Account__c; 
            query += '\'';  
        }
        else
        {
            query +=' WHERE AccountId=';
            query += '\'';
            query +=igform.Account__c; 
            query += '\''; 
        }                 
        query +=' LIMIT 50 ';
        system.debug('Â£Â£Table query'+query);
        if(Limits.getQueries() < 95)
        {
            sobLst= Database.query(query) ; 
        }
        if(sobLst!=null)
        {  
            ObjectList.put(qs.id,sobLst); 
        }
    }
      
   if(qs.All_Records__c  && sObjMap.containsKey(qs.Source_Object__c) && !optionsMap.containsKey(qs.id))
    {
        opts = new List<SelectOption>();
        opts.add(new SelectOption('None','None'));   
        List<sObject> records = new List<sobject>();

        records=sObjMap.get(qs.Source_Object__c);
        
        for(sObject rec:records)
         {
             String s='';
             s=(String) rec.get(qs.Source_Field_API__c);
             

             if(s!=null && s!='')
             {
             
                 opts.add(new SelectOption(s,s));
             }                 
          } 
          
          if(opts.size()>0)
          {
             optionsMap.put(qs.Id,opts);      
          }
            
    
        }
                             
       questionMap.put(qs.Id,qs); 
               
 }
 
           
     //getting records of Rule
     system.debug('@@Section Question'+secquesIDs);
     //quesRules = [Select id, Name,Number_Comparison_Value__c,Text_Comparison_Value__c,Comparison_Operator__c,Error_Message__c, Section_Question__c, Rule__c, Rule__r.Method_Name__c from Rule_Question_Junction__c where Section_Question__c IN : secquesIDs];         


         
 }

// Run the mthod when event for Branching Logic.
 public PageReference assignID()
 {
    fetchAnsMap = false; // Don't fetch values again
    /*if(qnBranchMap.containsKey(QID))
    {
        qnBranchMap.get(QID);
        for(Question_Section_Branching__c child:qnBranchMap.get(QID))
        {
            Form_Answer__c igs = new Form_Answer__c();
            igs = answerMap.get(child.Dependant_Key__c);
            if(answerMap.get(QID).Text__c == child.Text_Comparison_Value__c)
            {
                igs.Enabled__c = true; // set enabled is true, so that it shows next time and also in pdf.
            }
            else
            {
                igs.Enabled__c = false; // set enabled is false
            }

            answerMap.put(child.Dependant_Key__c,igs);
        }
    }*/
    return null;
 }
 
 /* Wrapper class which returns the page, section and questions to displayed on the screen */
 
 public class Wrapper{
        public Id Id{get;set;}
        public ID junctionId{get;set;}
        public String Name{get;set;}
        public String className{get;set;}
        public String iconName{get;set;}
        public String tabName{get;set;}
        public String tabId{get;set;}
        public String formStatus{get;set;}
        public List<Wrapper> children{get;set;}
        public boolean dependant{get;set;}
        public boolean driver{get;set;}
        public string key{get;set;}
    }
// This Wrapper methods returns the list of Pages, Section and Questions. These are looped in a apex:repat in the Vf page.    
    public List<Wrapper> pages{
        get
        {
            List<Wrapper> pages = new List<Wrapper>();
            Integer i=0;


            String [] tabs = new List<String> {'bin', 'clearing', 'keys',  'authorisation','settlement','services'}; // Tabs are limted to 6, it cannot take more than 6.
            List<Wrapper> sectList = new List<Wrapper>();
            for(Template_Page__c pg : tempPageMap.values())
            {
                Wrapper page = new Wrapper();
                page.Id = pg.Page__c;
                page.Name = pg.Display_Name__c;
                page.junctionId=pg.Id;
                page.formStatus = pg.Status__c;
                                
                if(i<6)
                {
                page.tabName = tabs[i]+'DivId';  
                page.tabId  =  tabs[i];   
                }     
                else
                {
                 page.tabName ='noDiv';
                }
                if(i==0)
                {
                   
                   page.className = 'ui-btn-active';  // Make one of the tab Active if its Not Started or In Prog

                }
                                
                if(page.formStatus == 'Completed')
                {
                    page.iconName = 'check'; // this drives the icon on tab, check icon

                }
                else
                {
                page.iconName = 'delete'; //this drives the icon on tab, close icon

                }
                
                i++;
                page.children = new List<Wrapper>();
                pages.add(page);
                               
               if(pageSectionMap.containsKey(pg.Page__c))
               {
                for(Page_Section__c pgSec :pageSectionMap.get(pg.Page__c))
                {
                    Wrapper section = new Wrapper();
                    section.Id = pgSec.Section__c;                     
                    section.Name = pgSec.Display_Name__c;
                    section.junctionId = pgsec.Id;
                    section.children = new List<Wrapper>();
                    page.children.add(section);
                    
                }

               }
             }
            
            for(Wrapper page : pages)
            {                
               for(Wrapper section : page.children)
                {                    
                    if(secQuestionMap.containsKey(section.id))
                    {
                      for(Section_Question__c secQn :secQuestionMap.get(section.id))
                        {
                           Wrapper question = new Wrapper();
                           Form_Answer__c ans = new Form_Answer__c();
                           String unique = section.junctionId;
                           unique += secQn.Id;   // Combination of Page Section ID and Section Question ID make unique key.               

                           if(fetchAnsMap) // to stop fetch values when there is already data in IG Answer for this form.
                           {                            
                            system.debug('@@Inside fetch');
                            ans.Question_Number__c = String.valueOf(secQn.Sort_Order__c)+'. ';
                            ans.Section_Question__c = secQn.Id;
                            ans.Required__c = secQn.Required__c;
                            ans.Template_Page__c = page.junctionId;
                            ans.Page_Section__c = section.junctionId;
                            ans.Type__c = questionMap.get(secQn.Question__c).Question_Type__c;
                            ans.Enabled__c = true;
                            //ans.Question_Type__c ='Independent'; 
                            if(questionMap.get(secQn.Question__c).Display__c=='Vertical' && (ans.Type__c=='Radio' || ans.Type__c =='Multi Check Box'))
                            {
                                    ans.Direction__c='pageDirection';
                            }
                            else if(ans.Type__c=='Radio' || ans.Type__c =='Multi Check Box')
                            {
                                ans.Direction__c='lineDirection';
                            }
                                                                                                                                                                                                   
                            if(dependantids.contains(secQn.id))
                            {

                                ans.Enabled__c =false; // Set the dependant question not enabled, so that it doesn't show on screen until some event makes it appear.

                            }
                                ans.Form__c = recID;
                                answerMap.put(unique,ans); 
                            
                          }
                                                        
                            question.Id = secQn.Question__c;
                            question.junctionId = secQn.Id;
                            question.Name = secQn.Question__c;
                            question.dependant=false;
                            question.driver=false;
                            question.key = unique;


                            if(dependantids.contains(secQn.id))
                            {
                                question.dependant=true;

                            }
                            if(qnBranchMap.containsKey(unique))
                            {
                                question.driver=true;
                            }
                            section.children.add(question);
                        }
                   }                 

              }
             
             }

            return pages;
        }
    }
    
    

   
   //This method is returns the section and question under it. It is used in for Review Page.
   public List<Wrapper> sections{
       
       get{
           
           List<Wrapper> sections = new List<Wrapper>();
           if(qReviewId!=null && pageSectionMap.containsKey(pageID))
           {
           for(Page_Section__c pgSec :pageSectionMap.get(pageID))
           {
                    String unique;
                    system.debug('&&&Page Section Junc&&'+pgSec);
                    Wrapper section = new Wrapper();
                    section.Id = pgSec.Section__c; 
                    section.tabName =                    
                    section.Name = pgSec.Display_Name__c;
                    section.junctionId = pgsec.Id;
                    sections.add(section);
                    section.children = new List<Wrapper>();
           
           
            for(Section_Question__c secQn :secQuestionMap.get(pgSec.Section__c))
             {
                    system.debug('&&&Section question Junc&&'+secQn);
                    unique=pgsec.Id;
                    unique +=secQn.Id;
                    Wrapper question = new Wrapper();
                    question.Id = secQn.Question__c;
                    question.junctionId = secQn.Id;
                    question.Name = secQn.Question__c; 
                    question.key =  unique;                          
                    section.children.add(question);
         } 
              
         } 
        
        }       
           return sections;
      }
   
       
   }
   
   //Method to return the list of options from picklist field
   public List<SelectOption> getOptions(String objName, String fld)
   {

       list<SelectOption> listoptions = new list<SelectOption>();
       Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
       Schema.SObjectType objType = gd.get(objName);
    
      
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();     
      list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
      
      for (Schema.PicklistEntry a : values)
      { 
         listoptions.add(new SelectOption(a.getLabel(), a.getValue())); 
      }
        return listoptions;
  }
  
  // This method is used to save the record in IG Answer object. It validates the answer before upserting.     
  
  public pageReference save()
  {
       PageReference pageRef = new PageReference('/apex/QuestionBuilder?Id='+recId);                     
       List<Form_Answer__c> igList = new List<Form_Answer__c>();  
       ID temPageId;
       temPageId = tempPageMap.get(pageIdQ).Id; //Get the Template Page Junction ID
       Set<ID> pgSecIds = new Set<ID>(); 
             
       for(Form_Answer__c iga:answerMap.values())
       {
           if(temPageId==iga.Template_Page__c && iga.Enabled__c )
               {                  
                  igList.add(iga);
                  system.debug('@@Inside IG'+iga);
                  pgSecIds.add(iga.Page_Section__c);                           
               } 
         
       }
      
       buildCheckBoxAns();
       //system.debug ('@@IGList'+igList+'@@Rules'+quesRules);
        system.debug ('##save AnswerMap: '+answerMap);
      //MIGRulesController mrc = new MIGRulesController();
      Boolean flag = false;
      /*List<List<String>> ListofListofMsg = mrc.validate(igList,quesRules,pgSecIds);  
      for(List<String> msgListTemp: ListofListofMsg){
            if(msgListTemp != null && msgListTemp.size() != 0){
                flag = true;
                break; 
            }    
      }*/
      system.debug('@Flag'+flag);    
          
       try
       {
        if(answerMap.size()>0 && !flag)
          {
              if(formNotStarted)
              {
                 upsert answerMap.values();
              }
              else if(igList.size()>0)
              {
                  update igList;
              }
              
            // Update the status of the page to In Progress when its saved
           Template_Page__c tempJunc = new Template_Page__c(id=temPageId);
           tempJunc.Status__c = 'In Progress';
           update tempJunc;
          
          }
          
       
       
        //If the user is saving form for first time, then update the status on the form to be Locked, so that user cannot make any changes to the form.
       if(formNotStarted)
       {
         Form__c igForm = new Form__c(id=recId);
         igForm.Status__c='Locked';

         update igForm;
       }

  
       }
       catch(exception e)
       {
          String error = e.getMessage();
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,error));     
       } 
                                
        pageRef.setRedirect(true);
 
       if(flag){
            return null;
        }
        else{
             return pageRef;
        }
  }
    
 //This method is mark the page as Complete 
  public pageReference markComplete()
   {        
      PageReference pageRef = new PageReference('/apex/QuestionBuilder?Id='+recId);         
      List<Form_Answer__c> igList = new List<Form_Answer__c>();  
      ID temPageId;
      temPageId=tempPageMap.get(pageIdQ).Id;
      Set<ID> pgSecIds = new Set<ID>();  
      for(Form_Answer__c iga:answerMap.values())
      {
         if(temPageId==iga.Template_Page__c && iga.Enabled__c)
             {                  
               igList.add(iga); 
               pgSecIds.add(iga.Page_Section__c);                           
             }
      }
       buildCheckBoxAns ();
       system.debug ('##mark answermap: '+answerMap);
       
      //MIGRulesController mrc = new MIGRulesController();
      Boolean flag = false;
      /*List<List<String>> ListofListofMsg = mrc.validate(igList,quesRules,pgSecIds);  
 
      for(List<String> msgListTemp: ListofListofMsg){

            if(msgListTemp != null && msgListTemp.size() != 0){
                flag = true;
                break; 
            }    
      }*/
    
    
      try
      {
          if(answerMap.size()>0 && !flag)
          {
              update answerMap.values();
          
          // Update the Template Page status to Completed once user Mark it Complete. These status are used set icons on the page.  
          Template_Page__c tempJunc = new Template_Page__c(id=temPageId);
          tempJunc.Status__c = 'Completed';
          update tempJunc;
          }            
      
      }
      catch(exception e)
      {
          String error = e.getMessage();
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,error));     
      } 
      pageRef.setRedirect(true); 
       if(flag){

            return null;
        }
        else{

            return pageRef;
        }
   
  } 
  
  public pageReference submit()
  {
      
    PageReference pdf = Page.CompletedFormPdf;
    // add parent id to the parameters for standardcontroller
    pdf.getParameters().put('id',recId);
    // create the new attachment
    //Attachment attach = new Attachment();

    // the contents of the attachment from the pdf
    Blob body;

    try 
    {
    // returns the output of the page as a PDF
        body = pdf.getContent();
    } catch (VisualforceException e) 
    {
        body = Blob.valueOf('Exception for Template'+igform.Name);
    }
    
    try
    {
    /*attach.Body = body;
    attach.Name = igform.Display_Name__c;
    attach.IsPrivate = false;
    attach.ParentId = caseId; // attach it to the Case Record.
    insert attach;*/
    
    FeedItem post = new FeedItem();
    post.ParentId = igform.Account__c; //eg. Opportunity id, custom object id..
    post.Body = 'IG Attachment-'+accInfo.Name+'-'+igform.Name;
    post.ContentData = body;
    post.ContentFileName = igform.Name+'.pdf';
    post.Visibility = 'AllUsers';
    post.Type='ContentPost';
    post.NetworkScope = 'AllNetworks';
    insert post;

    system.debug('@@FeedPost'+ post);
    
    //Create a task for the owner of Case to alert that Member User has submitted the form.
    Task tsk = new Task();
    DateTime dt = system.now();
    //ID RecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('CI Task').getRecordTypeId();
    tsk.OwnerId= accInfo.OwnerId;
    //tsk.RecordTypeId  = RecTypeId;
    tsk.Subject = igform.Name;
    tsk.Priority = 'Medium';
    tsk.Status ='Open';

    tsk.ActivityDate =  system.today().adddays(1);  
    tsk.WhatId = igform.Account__c;
    system.debug('@@Task'+tsk);
    insert tsk;
    
    igform.Status__c = 'Submitted';
    update igform;
    
    }
    catch(Exception e)
    {
        system.debug('Caught Exception when submitting the form'+e);
    }
    // send the user to the account to view results
    return new PageReference('/apex/FormThankYou?id='+accInfo.Id);
      
      
  } 
        
  //This method updates the records on the Table
  public pageReference saveTable()
  {                  
      update ObjectList.get(tblQID);
      return null;
  }
    
   public void buildCheckBoxAns ()
   {
     for (string stAns : answerMap.keySet() )
      {
          Form_Answer__c objAns = new Form_Answer__c ();
          objAns = answerMap.get(stAns);
          if (objAns.Type__c == 'Multi Select Check Box' && SelectedOptsMap.size() != 0 )
          {
              objAns.Text__c = '';          
              List <string> selectAnsCheck = new List <string> ();
              for (string unqId : SelectedOptsMap.keySet())
              {
                  if (stAns == unqId)
                  {
                      selectAnsCheck = SelectedOptsMap.get(unqId);
                      system.debug('##selectAnsCheck: '+ selectAnsCheck);
                      for (integer i =0; i< selectAnsCheck.size(); i++)
                      {
                          objAns.Text__c += selectAnsCheck.get(i) ;
                          if (i != selectAnsCheck.size()-1)
                          {
                              objAns.Text__c += ';';
                          }                      
                      }
                  }
                  system.debug('##objAns.Text__c: '+ objAns.Text__c);
              }
          }
      }
  }
  
      


}