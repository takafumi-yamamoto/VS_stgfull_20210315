@isTest
public class ObIraiMlT {
    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
    }
    @isTest
    public static void createMail() {
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, Obosanbin__c> theObos = new Map<String, Obosanbin__c>{
			'お坊' => new Obosanbin__c(
                MemorialServicePlan__c = '一般葬',
                TsuyaDateTime_Inp__c = Datetime.newInstance(2020,1,1),
                KokubetsushikiNichiji__c = Datetime.newInstance(2020,1,1),
                KasoDateTime_Inp__c = Datetime.newInstance(2020,1,1),
                KokubetsuDateTime_Inp__c = Datetime.newInstance(2020,1,1)
            )
		};
        INSERT theObos.values();

        Map<String, Opportunity> theOpps = new Map<String, Opportunity>{
            'お坊' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin'),
                Name = '_',
                AccountId = theAccounts.get('客').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1),
                ObosanbinRef__c = theObos.get('お坊').Id
            )
        };
        INSERT theOpps.values();

        ObIraiMl.Req theReq = new ObIraiMl.Req();
        theReq.account_name =  '_';
        theReq.mailaddress = 'this-is-test@yoriso.com';
        theReq.opp_id = theOpps.get('お坊').Id;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';
        endSetUp();

        Test.startTest();
        new ObIraiMl( new ObIraiMl.OppDataPvdr() ).createMail(theReq);
        Test.stopTest();
    }
}