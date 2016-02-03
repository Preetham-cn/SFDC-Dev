<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Lead_Created</fullName>
        <description>New Lead Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>preetham.cn@tcs.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SupportCaseCreatedPhoneInquiries</template>
    </alerts>
    <rules>
        <fullName>New Lead</fullName>
        <actions>
            <name>New_Lead_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>11/1/2014 12:30 PM</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
