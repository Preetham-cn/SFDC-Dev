public class SoapGetAccListCls{
    public String welcomemsg{get;set;}
    public String output{get;set;}
    public String search{get;set;}
    public string sessonid1{get;set;} 
   // public List<SoapAccountLST> resultlst{get;set;}
    Public List<Account> accList{get;set;}
    Public List<Account> accList2{get;set;}
    Public List<Cases> caseList{get;set;}
    public Integer searchResultsCount{get;set;}
    
    public SoapGetAccListCls(){
        searchResultsCount =0;
        caseList = new List<Cases>();
        accList = new List<Account>();
        accList2 = new List<Account>();
       // resultlst = new List<SoapAccountLST>();
         partnerSoapSforceCom.Soap stub = new partnerSoapSforceCom.Soap();
            partnerSoapSforceCom.LoginResult loginResult = stub.login('preetham.cn@tcs.com','Summer#13');
            stub.endpoint_x = loginResult.serverUrl;
            stub.SessionHeader = new partnerSoapSforceCom.SessionHeader_element();
            stub.SessionHeader.sessionId = loginResult.sessionId;
           // partnerSoapSforceCom.DeleteResult[] deleteResults =stub.delete_x(ids);
    
            sessonid1 =stub.SessionHeader.sessionId;
        
    }
    public pageReference accListMethod(){
           
        soapSforceComSchemasClassSearcdispl.SearcDisplayRecordsCls sobj= new soapSforceComSchemasClassSearcdispl.SearcDisplayRecordsCls();
                
        soapSforceComSchemasClassSearcdispl.SessionHeader_element ssid= new soapSforceComSchemasClassSearcdispl.SessionHeader_element();
        ssid.sessionId=sessonid1; 
        sobj.SessionHeader = ssid;
        
       // Start Get Records  Through JSON 
       System.debug('Json string:'+sobj.SearcDisplayRecords(search)); 
        JSONParser parser = JSON.createParser(sobj.SearcDisplayRecords(search));
        while (parser.nextToken() != null) {
            // Start at the List of Accounts.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next Account  object.
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire Acc object, including its List of line items.
                        Account acc = (Account)parser.readValueAs(Account.class);
                        System.debug('acc values:'+acc.Cases);
                        accList.add(acc);
                        searchResultsCount =accList.size();
                       // for(Cases cs:acc.Cases){
                         //   caseList.add(cs);
                        //}
                        //Cases cs=(Cases)acc.Cases;
                        //System.debug('Cases object is:'+cs);
                        //caseList.addAll((Cases)acc.Cases);
                        System.debug('caseList is:'+caseList.size());
                        system.debug('Acc Namr Is: ' + acc.Name);
                        system.debug('Acc id is: ' + acc.Id);
                    }
                }
            }
        }
     // End get records
            
       
    return null;
    }
    /**
  public pageReference DidplayCases(){
           
        soapSforceComSchemasClassSearcdispl.SearcDisplayRecordsCls sobj= new soapSforceComSchemasClassSearcdispl.SearcDisplayRecordsCls();
                
        soapSforceComSchemasClassSearcdispl.SessionHeader_element ssid= new soapSforceComSchemasClassSearcdispl.SessionHeader_element();
        ssid.sessionId=sessonid1; 
        sobj.SessionHeader = ssid;

       // Start Get Records  Through JSON  
        JSONParser parser = JSON.createParser(sobj.DisplayRecords());
        while (parser.nextToken() != null) {
            // Start at the List of Accounts.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next Account  object.
                    //if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire Acc object, including its List of line items.
                        case cs = (case)parser.readValueAs(case.class);
                        caseList.add(cs);
                        system.debug('Acc Namr Is: ' + cs.Name);
                        system.debug('Acc id is: ' + cs.Id);
                    //}
                }
            }
        }
     // End get records
        return null;    
}**/
}