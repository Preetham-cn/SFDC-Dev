@isTest
private class TestVerifyDate
{
   static testMethod void CheckDatesTest()
  
  {
    Date d1 = System.Today();
    Date d2 = d1.addDays(31);
    

    test.StartTest();
        VerifyDate.CheckDates(d1,d2);
    test.StopTest();
    
  
  }
  
  static testMethod void CheckDatesTest1()
    {
    Date d1 = System.Today();
    Date d2 = d1.addDays(5);
    

    test.StartTest();
        VerifyDate.CheckDates(d1,d2);
    test.StopTest();
    
    }

}