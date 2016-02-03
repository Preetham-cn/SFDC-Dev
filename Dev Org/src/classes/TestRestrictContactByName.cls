@isTest
private class TestRestrictContactByName
{

static testMethod void RestrictContByNameTest()
{
    Contact cont = new Contact();
    cont.FirstName = 'Test';
    cont.LastName = 'INVALIDNAME';
    
    Test.startTest();
    Database.SaveResult result = Database.insert(cont, false);

    Test.stopTest();
    
    System.assert(!result.isSuccess());

    

 }

}