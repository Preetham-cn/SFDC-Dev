public class ContactAndLeadSearch
{
    public static List<List<sObject>> searchContactsAndLeads(String searchWord)
    {
        
        String queryString = 'FIND '+ '\''+searchWord+'\'' +' IN NAME FIELDS RETURNING Lead(FirstName,LastName),Contact(FirstName,LastName)';
        List<List<sObject>> searchList = search.query(queryString);
    
    
      return searchList;
    }

}