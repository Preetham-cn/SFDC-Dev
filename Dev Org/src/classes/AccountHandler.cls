public class AccountHandler {

public String img{get;set;}

public AccountHandler()
{

img = 'Koala';
}

public static Account insertNewAccount(String accntName)
{
Account acc;
try
{
acc= new Account(Name =accntName);
insert acc;

}

catch(Exception e)
{
system.debug('DML Exception'+e);
return null;
}
return acc;
}

}