public class FormTriggerHandler {

      // This method is used to clone the Page, sections, question junctions object from tempalte and associate to form
     public void cloneTemplate(List<Form__c> igforms)
     {
         Map<ID,Form__c> tempIdFormMap = new Map<ID,Form__c>();
         List<Template_Page__c> tempPageList = new List<Template_Page__c>();
         List<Page_Section__c> pageSecList = new List<Page_Section__c>();
         List<Section_Question__c> secQNList = new List<Section_Question__c>();                  
         //List<Question_Section_Branching__c> qnSecBranchList = new List<Question_Section_Branching__c>();
         Set<ID> pageIds = new Set<ID>();
         Set<ID> sectionIds = new Set<ID>();
         Map<ID,ID> pageSecOldNewmap = new Map<ID,ID>();
         Map<ID,ID> temPageOldNewmap = new Map<ID,ID>();
         Map<ID,ID> secQuesOldNewmap = new Map<ID,ID>();
         ID formID;
         

                                    
         if( igforms.size()>0)       
         {         
         Savepoint sp = Database.setSavepoint(); // Roll back if any of the dml operation fails
         try {
         formID = igforms[0].id;
         
                             
         //ID RecTypeId = Schema.SObjectType.Template_Page__c.getRecordTypeInfosByName().get('Template Page').getRecordTypeId();
         
         for (Template_Page__c tempPage :[Select Id, Form__c,Root__c,Template__c, Status__c, Name, Display_Name__c,Sort_Order__c, Page__c From Template_Page__c WHERE Template__c=:igforms[0].Template__c AND Form__c=null ORDER BY Sort_Order__c])
         {
             Template_Page__c tpj = tempPage.Clone(false,true);
             //tpj.RecordTypeId = Schema.SObjectType.Template_Page__c.getRecordTypeInfosByName().get('Form Page').getRecordTypeId();
             tpj.Status__c = 'Not Started';
             tpj.Root__c = tempPage.id;
             tpj.Form__c = formID;             
             pageIds.add(tempPage.Page__c);
             tempPageList.add(tpj);                                   
         }
                           
         if(tempPageList.size()>0)
         {
             system.debug ('##tempPageList: '+tempPageList);
             insert tempPageList;
         }
         
         for (Template_Page__c tempPageInserted :[Select Id, Form__c, Root__c,Template__c, Name, Display_Name__c,Sort_Order__c, Page__c From Template_Page__c WHERE Form__c=:formID  ORDER BY Sort_Order__c])
         {
             temPageOldNewmap.put(tempPageInserted.Root__c,tempPageInserted.Id);
         }

         
         for(Page_Section__c pageSec:[Select Id, Sort_Order__c, Root__c,Name,Display_Name__c,Section__c,Page__c From Page_Section__c WHERE Page__c IN:pageIds AND Form__c=null ORDER BY Sort_Order__c])
         {
             Page_Section__c psj = pageSec.Clone(false,true);
             //psj.RecordTypeId = Schema.SObjectType.Page_Section__c.getRecordTypeInfosByName().get('Form Page Section').getRecordTypeId();
             psj.Form__c = formID;  
             psj.Root__c =  pageSec.Id;         
             sectionIds.add(pageSec.Section__c);
             pageSecList.add(psj);                     
         }
         
         if(pageSecList.size()>0)
         {
             insert pageSecList;
         }
         
         
         for(Page_Section__c pageSecInserted:[Select Id, Sort_Order__c,Root__c, Name,Display_Name__c,Section__c,Page__c From Page_Section__c WHERE Form__c =:formID ORDER BY Sort_Order__c])
         {
             pageSecOldNewmap.put(pageSecInserted.Root__c,pageSecInserted.Id);
         }
                           
         
         for(Section_Question__c secQuestion:[Select Id, Sort_Order__c,Root__c,Required__c,Name,Section__c,Question__r.Question_Text__c,Question__c From Section_Question__c WHERE Form__c =null AND Section__c IN:sectionIds  ORDER BY Sort_Order__c])
         {
             Section_Question__c secQn = secQuestion.Clone(false,true);
             secQn.Form__c = formID;
             secQn.Root__c =  secQuestion.Id;            
             secQNList.add(secQn);
         }         
         
         if(secQNList.size()>0)
         {
             system.debug ('##secQNList: '+secQNList);
             insert secQNList;
         }
                  
         for(Section_Question__c secQuestion:[Select Id, Name, Sort_Order__c,Root__c,Section__c,Question__r.Question_Text__c,Question__c From Section_Question__c WHERE Form__c =:formID ORDER BY Sort_Order__c])
         {
             secQuesOldNewmap.put(secQuestion.Root__c,secQuestion.Id);             
         }
         
      // This is required to put replace the old section question with new section question for the form
         /*for(Question_Section_Branching__c qnSecBranch:[Select Id, Name,Comparison_Operator__c,Driver__c,Section_Question__c,Driver_Section__c,Question_to_Enable__c,Status__c,Numeric_Comparison_Value__c,Text_Comparison_Value__c FROM Question_Section_Branching__c WHERE Section_Question__c IN:secQuesOldNewmap.keySet() AND Status__c ='Active'])
         {
             Question_Section_Branching__c qsb = qnSecBranch.Clone(false,true);
             qsb.Form__c=formID;
             qsb.Driver_Section__c = pageSecOldNewmap.get(qnSecBranch.Driver_Section__c);

             if(qsb.Driver_Section__c!=null)
             {
             qsb.Section_Question__c = secQuesOldNewmap.get(qnSecBranch.Section_Question__c);
             qsb.Question_to_Enable__c = secQuesOldNewmap.get(qnSecBranch.Question_to_Enable__c); 
             qnSecBranchList.add(qsb);
             }
         }
         
         if(qnSecBranchList.size()>0)
         {
             system.debug ('##qnSecBranchList: '+qnSecBranchList);
             insert qnSecBranchList;
         }*/
       
       }
       
       catch(Exception e)        
       {
           system.debug('Exception '+e);
           Database.rollback(sp);
       }
      } 
     }
    }