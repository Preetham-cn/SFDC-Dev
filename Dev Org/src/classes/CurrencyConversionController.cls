public with sharing class CurrencyConversionController {

    public String currencyTo { get; set; }

   public String currencyFrom { get; set; }
 public Double message {get; private set;}

  public PageReference hello() {    
  CurrencyConversionDefault.CurrencyConvertorSoap  stub = new CurrencyConversionDefault.CurrencyConvertorSoap();
    message = stub.ConversionRate(currencyFrom ,currencyTo );
        return null;
    }

}