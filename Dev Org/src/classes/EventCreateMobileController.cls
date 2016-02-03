public class EventCreateMobileController {
   
   
   
   
  
 
  
  //public list<prodWrapper> prodList;

 
  
 
  
  public static List<SelectOption> materialNameList{get;set;} 
  public static boolean countryExists = false ;
  public static boolean countryAvailable = false;
  public static boolean initialized = false;
  public static boolean eventCreated = true;
  //public Account acc ;
  //public static string countryName {get; set}
  public static string countryStr {get;set;}
  public static string countryName {get;set;}
  public static string selectProductStr {get;set;}
  public static string selectMaterialStr {get;set;}
  public string localeStr{get;set;}
 


    
    
    
    @RemoteAction
    public static List<Contact> searchContacts(String contName) {
        // support * search like salesforce lookups
           
           
           
           contName = '%'+contName+'%';
            List<Contact> cont= [select  Name, Account.Name from 
             Contact where Name LIKE :contName  Order By Name LIMIT 5];
             system.debug('Preetham contact'+cont);
             return cont;

        
    }   
 //********************************* This method gets the picklist values fro all dropdowns during page load. Object is class name of the element and field is id attribute of the element which is passed to the controller.
 @RemoteAction
 public static list<SelectOption> getPicklistValues(String obj, String fld){
 
 

  list<SelectOption> options = new list<SelectOption>();
  // Get the object type of the SObject.
  Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
  Schema.sObjectType objType = objTypeMap.get(obj); 
  // Describe the SObject using its object type.
  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
  // Get a map of fields for the SObject
  map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
  // Get the list of picklist values for this field.
  list<Schema.PicklistEntry> values =
     fieldMap.get(fld).getDescribe().getPickListValues();
  // Add these values to the selectoption list.
  for (Schema.PicklistEntry a : values)
  { 
     options.add(new SelectOption(a.getLabel(), a.getValue())); 
  }
  return options;
 }

    
//********************************* to get the sub-region of the logged in user. This is to get products and materials based on user sub-region
     
     
    
    
    
    // This method is to get the Product based on user sub region from custom settings
    
    
 
    // This method saves Event first based on details and upon successfull insertion it saves Product Activity detail
    @RemoteAction
    public static Boolean saveEvent(String detail, List<String> conts) {
       
        String eventDetails;
        String startdate;
        String enddate;
        Event evnt = new Event();
        Savepoint sp;
       
        try 
          {
          
          JSONParser parser =     JSON.createParser(detail);
          parser.skipChildren(); 
        
          while (parser.nextToken() != null) 
          {
           
         
          if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'Subject') {
          parser.nextValue();
         
          evnt.Subject = parser.getText();
          
          
          }
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'type') 
          {           
          parser.nextValue();         
          evnt.Type = parser.getText();
          system.debug('Type '+evnt.Type);
          
          }
          
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'start') { 
          
          parser.nextValue();          
          startdate = parser.getText();
          system.debug('startdate1 '+startdate);
          
          }
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'starttime') { 
          
          parser.nextValue();          
          startdate  = startdate+' '+ parser.getText()+':00';
          system.debug('starttimeb4 '+startdate);
          Datetime strtDttime = datetime.valueOf(startdate);
          system.debug('starttime '+strtDttime);
          evnt.StartDateTime = strtDttime;
          
          }
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'Description') { 
          
          parser.nextValue();          
          evnt.Description = parser.getText();
          system.debug('Description '+evnt.Description);
          
          }
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'status') { 
          
          parser.nextValue();
          
          evnt.Status__c = parser.getText();
          system.debug('Status '+evnt.Status__c);
          }
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'subtype') { 
          
          parser.nextValue();
          
          evnt.Sub_Type__c = parser.getText();
          system.debug('SubType '+evnt.Sub_Type__c );
          }
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'end') { 
          
          parser.nextValue();          
          enddate = parser.getText();
          
          
          }
          
          else if(parser.getCurrentToken()== JSONToken.VALUE_STRING && parser.getText()== 'endtime') { 
          
          parser.nextValue();    
          enddate = enddate+' '+ parser.getText()+':00'; 
           Datetime endDttime = datetime.valueOf(enddate);
           evnt.EndDateTime=endDttime;
           
           
          
          }
           
          
          
           
          evnt.WhoId = conts[0];
          
          }
         sp = Database.setSavepoint(); 
          insert evnt;
          
         //get shadow activity id for the event that is inserted.
          
          //shadowEvent = [select id, Shadow_Activity_Id__c from Event where id =:evnt.id Limit 1];
          
          // insert contact activity detail
          
          
            
         
          }
       
          catch(Exception e)
          {
          system.debug('Exception Caught' + e);
          eventCreated = false;
          Database.rollback(sp);
          } 
         // parse the products  and assign the data to specific field on Product Activity Detail 
        
              
         
          return eventCreated;
    }   
    
    
   
  


}