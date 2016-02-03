public class ContactSearch
{

public static List<Contact> searchForContacts(String lastName, String postCode)
{
List<contact> contList = [Select id, Name from Contact where LastName=:lastName AND MailingPostalCode=:postCode];

return contList;
}



}