/* Utility Class with method to return the fields for an object */

public with sharing class Utility
{
 
 public static Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
 
 public static Map<String,String> showFields(String selectedObject) 
    {
    Map<String,String> labelAPIMap = new Map<String,String>();
    
    Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values())
        {
        schema.describefieldresult dfield = sfield.getDescribe();
           if(dfield.isAccessible())
            {
              labelAPIMap.put(dfield.getLabel(),dfield.getname());
            }
        }
        
        return labelAPIMap;
        
     }
     
     
   /*public static map<string,ID> getFieldMetaData(string objName,string fieldName)
    {
        list<map<string,object>> results = new list<map<string,object>>();
        Map<String,ID> CFnameID = new Map<String,ID>(); 
        
        String full = ObjName+'.'+fieldName;

        fieldName = fieldName.replace('__c','');
        objName = objName.replace('__c','');

                string instanceURL = System.URL.getSalesforceBaseUrl().getHost().remove('-api' );
        
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        
        String toolingendpoint = 'https://'+instanceURL+'/services/data/v34.0/tooling/query?q=';
        
        //query for custom fields
        toolingendpoint += 'Select+id,DeveloperName,FullName,TableEnumOrId+from+CustomField+where+DeveloperName+=+\''+fieldName+'\'';
        req.setEndpoint(toolingendpoint);
        req.setMethod('GET');
        
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        //convert the original data structure into a map of objects. The data we want is in the records property of this object
        map<string,object> reqData = (map<string,object>) json.deserializeUntyped(res.getBody());
        
        //now create a list of objects from the records property. This serialize/deserialize trick is the only way I know to convert a generic object
        //into something else when the source data is 'salesforce Map encoded' (no quotes around field names or values, parenthesis to denote open and close, etc)
        list<object> fieldData = (list<object>) JSON.deserializeUntyped(JSON.serialize(reqData.get('records')));    
                system.debug('@@FieldData'+fieldData);
        //iterate over each object in the list and create a map of string to object out of it and add it to the list
        for(object thisObj : fieldData)
        {
            map<string, object> thisFieldData =  (map<string, object>) json.deserializeUntyped(JSON.serialize(thisObj));
            String ObjName2 = String.ValueOf(thisFieldData.get('FullName'));
            String IDvalue = String.ValueOf(thisFieldData.get('Id'));
            
            
            if(full.equalsIgnoreCase(ObjName2))
            {
                CFnameID.put(ObjName2,IDvalue);
                
            }
            
            
        }
        return CFnameID;
    }*/

}