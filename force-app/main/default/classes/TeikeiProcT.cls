@isTest
public class TeikeiProcT {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
    }

    @isTest
    public static void whenSouryoTeikeiLead_thenCreteNewTeikeiProcess(){
        setUp();

        Map<String, Lead> theLeads = new Map<String, Lead>{
            'a' => new Lead(
                FirstName = 'TestFirstName201810091104',
                LastName = 'TestLastName201810091104',
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Lead','Teikeisaki_Soryo')
            )
        };
        Insert theLeads.values();

        //convert-lead begin
        Database.LeadConvert theLeadConvert = new database.LeadConvert();
        theLeadConvert.setLeadId( theLeads.get('a').Id );
        theLeadConvert.doNotCreateOpportunity = true;
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        theLeadConvert.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult theLeadConvertResult = Database.convertLead(theLeadConvert);
 
        System.assertEquals(true, theLeadConvertResult.isSuccess() );
        //convert-lead end

        //assertion begin
        Lead theConvertedLead = [select Id, ConvertedAccountId from Lead where Id = :theLeads.get('a').Id limit 1];
        Account theConvertedAccount = [
            select 
            Id, RecordTypeId, Name,
            (select Id, Stage__c from TeikeiProcess__r)
            from Account 
            where Id = :theConvertedLead.ConvertedAccountId 
            limit 1
            ];

        System.assertEquals('SoryoAccount', RecordTypeCachedDaos.getInstance().SelectDeveloperNameById(theConvertedAccount.RecordTypeId) );
        System.assertEquals(1, theConvertedAccount.TeikeiProcess__r.size() );

        TeikeiProcess__c theTeikeiProcess = theConvertedAccount.TeikeiProcess__r.get(0);
        System.assertEquals( 'メール返信', theTeikeiProcess.Stage__c);
        //assertion end
    }
}