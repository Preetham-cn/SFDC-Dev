trigger LeadBefore on Lead (before insert, before update) {

List<Lead> leadList= new List<Lead>();
Map<String, String> mapnames = new Map<String, String>();
leadList = Trigger.New;

If(Trigger.isInsert)
for(Lead l : leadList)
{
 //if(l.LastName != Trigger.oldMap(l.ID).LastName)
 //l.LastName=Trigger.oldMap(l.ID).LastName;  Not allowing Lastname feild to change..
 //leadList.add(l);
 
}



}