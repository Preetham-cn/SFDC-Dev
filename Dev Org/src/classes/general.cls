public class general
{

    public string encoded ;
    
    public void test1 () {
    
    encoded = 'Preetham';
    encoded += '\'';
    encoded += 's';

    
    encoded = encoded.replaceAll('[|,|.|\\,||"||:|~|!|@|#|$|%|^|&|*|_|+|=|<|>|?|\\(|\\)|\\{|\\}|\\;|\\\'"]', '');
    }
}