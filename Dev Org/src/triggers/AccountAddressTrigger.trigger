trigger AccountAddressTrigger on Account (before insert, before update) {

if(trigger.isBefore)
{
 if(trigger.isInsert || trigger.isUpdate)
 {
     
     for(Account acc : Trigger.New)
     {
      if(acc.BillingPostalCode!=null && acc.Match_Billing_Address__c)
     {
         acc.ShippingPostalCode=acc.BillingPostalCode;
     
     }
 }
 
  }
 } 
}

/*if(trigger.isBefore)
{
   if(trigger.isInsert)
 {
 
 }
 
 if(trigger.isUpdate)
 {
 
 } 
}*/