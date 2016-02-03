1) Currency restriction validation rule to be added in deployment tracker.

2) Region__c field created on Quote/Proposal and Product Configuration Objects

3) Below components as part of DE5

Classes
a) APTS_Clone_Deal_Ctrl
b) APTS_ValidateQuote
c) APTS_PushtoContractController
d) Label: PROP_Deal_approval_status_message

4) US 587

TotalTenderPrice__c

5) Bhaumik components

Workflow Rule :
PRDCNFG:Update POS Result Field on object Apttus_Config2__ProductConfiguration__c
 
Field Update :
PRDCNFG_Update_POS_Result_Field on object Apttus_Config2__ProductConfiguration__c


6) DE 384- Can be closed after Product Master fix.

7) Create Product Master field on the Opportunity which gets value from Opportunity Product

Copy the same Product Master from Opty to Child Quote and put in Product Filter

Only one version of quote will be In Process, so always add the new opportunity only to the new version.

8) New version changes

New Custom Field CHnages
Version_Created__c
APTPS_Clone_Parent_With_All_Child__c

Classes
APTS_Clone_Deal_Ctrl



305012978
305023537
305028782
305025786