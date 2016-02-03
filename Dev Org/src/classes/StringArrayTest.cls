public class StringArrayTest
{

    public static List<String> generateStringArray(Integer len) {
    
    List<String> testStrings = new List<String>();
    
    for(Integer i=0; i< len;i++)
    {
    
    String arr;
    arr='Test '+i;
    testStrings.add(arr);
    
    }
    
    return testStrings;
    }


}