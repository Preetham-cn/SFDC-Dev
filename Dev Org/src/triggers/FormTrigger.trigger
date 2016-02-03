trigger FormTrigger on Form__c (before insert, after insert, before update, after update) {

    if(trigger.isInsert && trigger.isAfter)
    {
        FormTriggerHandler fth = new FormTriggerHandler();
        fth.cloneTemplate(trigger.new);
    }
    
}