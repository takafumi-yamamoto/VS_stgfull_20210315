@isTest
public class ObIrHkSendSvcIraiSendT {
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
    private class ObIraiMl_Stub implements ObIraiMl.IObIraiMl{
        public MailAlert__c createMail(ObIraiMl.Req pReq){ 
            return new MailAlert__c(TemplateName__c = '_', ToAddress__c = 'this-is-test@yoriso.com', Title__c = '_', Body__c = '_');
        }
    }

    @isTest
    public static void sendIraishoMessage(){
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
                TehaiHokoForCustMethod__c = '郵送'
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

        ObIrHkSendSvcIraiSend.mObIraiMl = new ObIraiMl_Stub();

        ObIrHkSendSvcIraiSend.Req theReq = new ObIrHkSendSvcIraiSend.Req();
        theReq.method = 'mail';
        theReq.account_name = '_';
        theReq.address = 'this-is-test@yoriso.com';
        theReq.opp_id = theOpps.get('お坊').Id;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';
        endSetUp();

        Test.startTest();
        ObIrHkSendSvcIraiSend.sendIraishoMessage(theReq);
        Test.stopTest();
    }

    @isTest
    public static void logSendHistoryOnly(){

        ObIrHkSendSvcIraiSend.Req theReq = new ObIrHkSendSvcIraiSend.Req();
        theReq.method = 'mail';
        theReq.account_name = '_';
        theReq.address = 'this-is-test@yoriso.com';
        theReq.opp_id = null;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';

        Test.startTest();
        ObIrHkSendSvcIraiSend.logSendHistoryOnly(theReq);
        Test.stopTest();

    }

    @isTest
    public static void logSendHistoryOnly_Err(){

        ObIrHkSendSvcIraiSend.Req theReq = new ObIrHkSendSvcIraiSend.Req();
        theReq.method = 'mail';
        theReq.account_name = '_';
        theReq.address = 'this-is-test@yoriso.com';
        theReq.opp_id = 'invalid id';
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';

        Test.startTest();
        try{
            ObIrHkSendSvcIraiSend.logSendHistoryOnly(theReq);
        }catch(Exception ex){ }
        
        Test.stopTest();

    }
}