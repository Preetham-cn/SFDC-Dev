public class NewCaseListController
{

public List<Case> getNewCases()
{
    string query ='SELECT Id, CaseNumber, Subject, Priority FROM Case WHERE status=';
     query +='\'';
     query +='New';
     query +='\'';
    List<Case> results = Database.query(query);
    return results;

}


}