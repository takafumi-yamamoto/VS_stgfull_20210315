@isTest
public class ObIrHkSendSvcHokoSendT {
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
    private class ObHokoMl_Stub implements ObHokoMl.IObHokoMl{
        public MailAlert__c createMail(ObHokoMl.Req pReq){ 
            return new MailAlert__c(TemplateName__c = '_', ToAddress__c = 'this-is-test@yoriso.com', Title__c = '_', Body__c = '_');
        }
    }
    private class ObHokoSm_Stub implements ObHokoSm.IObHokoSm{
        public AcrtSmsSender.Req createAcrtSmsSenderReq(ObHokoSm.Req pReq){return null;}
    }
    public class AcrtSmsSenderClient_Stub implements AcrtSmsSender.IClient{
        public AcrtSmsSender.Result sendSms(AcrtSmsSender.Req pReq){return null;}
    }
    private class AcrtDrTackRegister_Stub implements AcrtDrTackRegister.IRegister{
        public void InsertEntrries( List<AcrtSmsSender.Result> pAcrtSmsSenderResults){return;}
        public void InsertEntry(AcrtSmsSender.Result pAcrtSmsSenderResult){return;}
    }

    private class IAcrtSmsSendHistLogr_Stub implements AcrtSmsSendHistLogr.IAcrtSmsSendHistLogr{
        public void logSmsHistory(AcrtSmsSender.Result pAcrtSmsSenderResult){return;}
    }

    @isTest
    public static void sendHokokushoMessage_sms(){
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

        ObIrHkSendSvcHokoSend.mObHokoMl = new ObHokoMl_Stub();
        ObIrHkSendSvcHokoSend.mObHokoSm = new ObHokoSm_Stub();
        ObIrHkSendSvcHokoSend.mAcrtSmsSenderClient = new AcrtSmsSenderClient_Stub();
        ObIrHkSendSvcHokoSend.mAcrtDrTackRegister = new AcrtDrTackRegister_Stub();
        ObIrHkSendSvcHokoSend.mIAcrtSmsSendHistLogr = new IAcrtSmsSendHistLogr_Stub();

        ObIrHkSendSvcHokoSend.Req theReq = new ObIrHkSendSvcHokoSend.Req();
        theReq.method = 'sms';
        theReq.account_id = theAccounts.get('客').Id;
        theReq.account_name = '_';
        theReq.address = '99999999999';
        theReq.opp_id = theOpps.get('お坊').Id;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';
        endSetUp();

        Test.startTest();
        ObIrHkSendSvcHokoSend.sendHokokushoMessage(theReq);
        Test.stopTest();
    }

    @isTest
    public static void sendHokokushoMessage_mail(){
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

        ObIrHkSendSvcHokoSend.mObHokoMl = new ObHokoMl_Stub();
        ObIrHkSendSvcHokoSend.mObHokoSm = new ObHokoSm_Stub();
        ObIrHkSendSvcHokoSend.mAcrtSmsSenderClient = new AcrtSmsSenderClient_Stub();
        ObIrHkSendSvcHokoSend.mAcrtDrTackRegister = new AcrtDrTackRegister_Stub();
        ObIrHkSendSvcHokoSend.mIAcrtSmsSendHistLogr = new IAcrtSmsSendHistLogr_Stub();

        ObIrHkSendSvcHokoSend.Req theReq = new ObIrHkSendSvcHokoSend.Req();
        theReq.method = 'mail';
        theReq.account_id = theAccounts.get('客').Id;
        theReq.account_name = '_';
        theReq.address = 'this-is-test@yoriso.com';
        theReq.opp_id = theOpps.get('お坊').Id;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';
        endSetUp();

        Test.startTest();
        ObIrHkSendSvcHokoSend.sendHokokushoMessage(theReq);
        Test.stopTest();
    }

    @isTest
    public static void logSendHistoryOnly(){
        ObIrHkSendSvcHokoSend.Req theReq = new ObIrHkSendSvcHokoSend.Req();
        theReq.method = 'sms';
        theReq.account_id = null;
        theReq.account_name = '_';
        theReq.address = '99999999999';
        theReq.opp_id = null;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';

        Test.startTest();
        ObIrHkSendSvcHokoSend.logSendHistoryOnly(theReq);
        Test.stopTest();
    }
}