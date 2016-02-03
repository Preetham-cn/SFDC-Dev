trigger ClosedOpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {

List<Task> tskList = new List<Task>();

if(trigger.isAfter)
{
    

    
    for(Opportunity opp:Trigger.New)
    {
        if(opp.StageName == 'Closed Won')
        {
         Task newTask = new Task();
         
         newTask.WhatId = opp.Id;
         newTask.Subject = 'Follow Up Test Task';
         tskList.add(newTask);
        }
    
    }
    
}

if(tskList.size()>0)
{
insert tskList;
}

 
}