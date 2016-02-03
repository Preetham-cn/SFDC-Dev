public class RandomContactFactory
{
    public static List<Contact> generateRandomContacts(Integer nContacts, String lName)
    {
        List<Contact> contList = new List<Contact>();
        
        for(Integer i=1;i<=nContacts;i++)
        {
            Contact cont = new Contact();
            cont.FirstName = 'Test '+i;
            cont.LastName = lName;
            
            contList.add(cont);
            
            
        }
    
     return contList;
    
    }

}