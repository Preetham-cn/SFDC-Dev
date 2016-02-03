global class SearcDisplayRecordsCls{
    webservice static String SearcDisplayRecords(String accName){
    string output='';
    
     // List<Account> accList =[Select a.Name, a.Id,a.phone, (Select Id, CaseNumber, SuppliedName, Status From Cases) From Account a where a.Name =:accName];
       string qry='Select Name,phone from Account where name !=null';
        if(accName!=''){
        qry +=' AND Name Like ' +'\''+'%'+accName+'%'+'\'';
        }
        System.debug('qry is:'+qry);
        List<Account> accList = Database.Query(qry);
      

    output= JSON.serialize(accList);
    return output;
    }
    webservice static String DisplayRecords(){
    string output='';
       List<Case> CasesList =[Select Id, IsDeleted, CaseNumber, ContactId, AccountId, AssetId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, Status, Reason, Origin, Subject, Priority, Description, IsClosed, ClosedDate, IsEscalated, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, EngineeringReqNumber__c, SLAViolation__c, Product__c, PotentialLiability__c FROM Case ];
       output= JSON.serialize(CasesList);
    return output;
    }
   
}