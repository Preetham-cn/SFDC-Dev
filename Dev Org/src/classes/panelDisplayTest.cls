public class panelDisplayTest
{
    
    public List<Case> caseList{get;set;}
    public Boolean showPanel{get;set;}
    
    public panelDisplayTest(ApexPages.StandardController controller)
    {
        caseList = new List<Case>();
        showPanel=false;
        caseList = [Select id, CaseNumber, Subject from CASE LIMIT 10];
        
    } 

    public void check()
    {
        showPanel=true;    
        
    }
    
     public void save()
    {
        //nothing
        
    }
}