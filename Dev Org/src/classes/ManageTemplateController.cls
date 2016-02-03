/* This class is used Manage the Template and Manage Form. It is used display the pages, section and question in a tree structure. 
This same controller is used for both Manage Template and Manage Form VF Pages */

public with sharing class ManageTemplateController
{
    public string recID {get;set;} 
    public Map<ID,List<Wrapper>> pageSection {get;set;}
    public Boolean refreshPage {get; set;}
    public Map<Id,Template_Page__c> tempPageMap{get;set;}
    public Map<Id,List<Page_Section__c>> pageSectionMap{get;set;}
    public Map<Id,List<Section_Question__c>> secQuestionMap{get;set;}
    public Map<String,Object> fieldObjMap{get;set;}
    public String sectionID{get;set;}
    public String requestType{get;set;}
    public String tempPagRecType{get;set;}
    public String pageSecRecType{get;set;}
    public String secQuesRecType{get;set;}
    public Boolean locked{get;set;}
      
    public ManageTemplateController(ApexPages.StandardController controller)
    {
         
     fieldObjMap = new Map<String,Object> ();   
     requestType = ApexPages.currentPage().getParameters().get('type'); 
     locked=false;
     
     if(requestType == 'form')
     {
         recID = ApexPages.currentPage().getParameters().get('id');  
         String status =    ApexPages.currentPage().getParameters().get('status'); 
         if(status=='Locked' || status=='Submitted' || status=='Completed')
         {
             locked = true;
         }
              
         
     }
     else if(requestType == 'template')
     {
         recID = ApexPages.currentPage().getParameters().get('id');
         
     }
     

     
     tempPageMap = new Map<ID,Template_Page__c>();
     pageSectionMap= new Map<Id,List<Page_Section__c>>();
     secQuestionMap = new Map<Id,List<Section_Question__c>>();
     String query;
     Set<ID> pgIds = new Set<ID>();
     // differently if the request is from template and from Form
     
     query='Select Id, Name, Page__r.Name, Display_Name__c,Sort_Order__c, Page__c From Template_Page__c WHERE ';
     
     if(requestType == 'form')
     {
         query +=' IG_Form__c =';
         query +='\'';
         query += recID;
         query +='\'';
         query +=' ORDER BY Sort_Order__c';


     }
     else if(requestType == 'template')
     {
         query +=' Template__c =';
         query +='\'';
         query += recID;
         query +='\'';
         query +=' ORDER BY Sort_Order__c';

     }
      
     
     for (Template_Page__c tempPage :Database.Query(query))
     {
         tempPageMap.put(tempPage.Page__c,tempPage);
         pgIds.add(tempPage.Page__c);
     }
     
     
     List<Page_Section__c> pageSectionList = new List <Page_Section__c>();
     List<Section_Question__c> secQuestionList = new List<Section_Question__c>(); 
     Set<Id> sectionIds = new Set<Id>();
          
     

     String pgsecQuery;
     pgsecQuery = 'Select Id, Name,Display_Name__c,Section__c,Page__c From Page_Section__c WHERE Page__c IN:pgIds';
     
     if(requestType == 'form')
     {
         pgsecQuery +=' AND RecordType.Name=';
         pgsecQuery +='\'';
         pgsecQuery +='Form Page Section';
         pgsecQuery +='\'';
         pgsecQuery +=' AND IG_Form__c =';
         pgsecQuery +='\'';
         pgsecQuery += recID;
         pgsecQuery +='\'';
         pgsecQuery +=' AND Status__c=';
         pgsecQuery +='\'';
         pgsecQuery +='Active';
         pgsecQuery +='\'';
         pgsecQuery +=' ORDER BY Sort_Order__c';


     }
     else if(requestType == 'template')
     {
         
         /*pgsecQuery +=' AND Status__c=';
         pgsecQuery +='\'';
         pgsecQuery +='Active';
         pgsecQuery +='\'';*/
         pgsecQuery +=' ORDER BY Sort_Order__c';
     }


     for(Page_Section__c pageSec:Database.Query(pgsecQuery))
     {   
    if(!pageSectionMap.containsKey(pageSec.Page__c) )
     {

          sectionIds.add(pageSec.Section__c);
          pageSectionMap.put(pageSec.Page__c,new List<Page_Section__c>{pageSec});        

     }
     else
     {

         sectionIds.add(pageSec.Section__c);         
         pageSectionList = pageSectionMap.get(pageSec.Page__c);
         pageSectionList.add(pageSec); 
         pageSectionMap.put(pageSec.Page__c,pageSectionList);


     }
   }
  
  String secQuesQuery;
  secQuesQuery ='Select Id, Name,Section__c,Question__r.Question_Text__c,Question__c From Section_Question__c WHERE Section__c IN:sectionIds';
  
  if(requestType == 'form')
     {
         secQuesQuery +=' AND RecordType.Name=';
         secQuesQuery +='\'';
         secQuesQuery +='Form Section Question';
         secQuesQuery +='\'';
         secQuesQuery +=' AND IG_Form__c =';
         secQuesQuery +='\'';
         secQuesQuery += recID;
         secQuesQuery +='\'';
         secQuesQuery +=' AND Status__c=';
         secQuesQuery +='\'';
         secQuesQuery +='Active';
         secQuesQuery +='\'';
         secQuesQuery +=' ORDER BY Sort_Order__c';


     }
     else if(requestType == 'template')
     {
         
         /*secQuesQuery +=' AND Status__c=';
         secQuesQuery +='\'';
         secQuesQuery +='Active';
         secQuesQuery +='\'';*/
         secQuesQuery +=' ORDER BY Sort_Order__c';
     }


 for(Section_Question__c secQuestion:Database.Query(secQuesQuery))
 {
 if(!secQuestionMap.containsKey(secQuestion.Section__c))
  {

      secQuestionMap.put(secQuestion.Section__c,new List<Section_Question__c>{secQuestion});
  }
 else
   {
     secQuestionList = secQuestionMap.get(secQuestion.Section__c);
     secQuestionList.add(secQuestion);
     secQuestionMap.put(secQuestion.Section__c,secQuestionList);

  }
     
 }

 pageSection = new Map<ID,List<Wrapper>>();
 refreshPage = false;
 
 }

 // Warppe to display pages, section and questions in tree format.
 public class Wrapper{
        public Id Id{get;set;}
        public ID junctionId{get;set;}
        public String Name{get;set;}
        public String DisplayName{get;set;}


        public List<Wrapper> children{get;set;}
    }
    public List<Wrapper> pages{
        get
        {
            List<Wrapper> pages = new List<Wrapper>();
            List<Id> pageIds = new List<Id>();
            
            List<Wrapper> sectList = new List<Wrapper>();
            for(Template_Page__c pg : tempPageMap.values())
            {
                Wrapper page = new Wrapper();
                page.Id = pg.Page__c;
                page.DisplayName = pg.Display_Name__c;
                page.Name = pg.Page__r.Name;
                page.junctionId=pg.Id;
                page.children = new List<Wrapper>();
                pages.add(page);
                pageIds.add(pg.Page__c);
               
               if(pageSectionMap.containsKey(pg.Page__c))
               {
                for(Page_Section__c pgSec :pageSectionMap.get(pg.Page__c))
                {
                    Wrapper section = new Wrapper();
                    section.Id = pgSec.Section__c;
                    section.DisplayName = pgSec.Display_Name__c;
                    section.Name = pgSec.Name;
                    section.junctionId = pgsec.Id;
                    section.children = new List<Wrapper>();
                    page.children.add(section);
                    
                }
               }
             }
            
            for(Wrapper page : pages)
            {
                
               for(Wrapper section : page.children)
                {
                    if(secQuestionMap.containsKey(section.id))
                    {
                      for(Section_Question__c secQn :secQuestionMap.get(section.id))
                        {
                            Wrapper question = new Wrapper();
                            question.Id = secQn.Question__c;
                            question.junctionId = secQn.Id;
                            question.DisplayName = secQn.Question__r.Question_Text__c;
                            question.Name = secQn.Name;
                            section.children.add(question);
                        }
                   }
                 
              }
            }
            return pages;
        }
    }
    
   public void doRefresh()
   
   {
     refreshPage = true;  
     
   }

}