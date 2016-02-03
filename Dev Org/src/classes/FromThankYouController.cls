/* Class used to show Thank You message and redirect user to case record after they submit IG */
public class FromThankYouController{

public ID accId{get;set;}
public FromThankYouController(){

accId = ApexPages.currentPage().getParameters().get('id');

}
public pageReference gotoAccount()
{
PageReference pg = new pageReference('/'+accId);

pg.setRedirect(true); 
return pg;
}

}