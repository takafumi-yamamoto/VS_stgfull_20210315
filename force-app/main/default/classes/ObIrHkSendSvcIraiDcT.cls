@isTest
public class ObIrHkSendSvcIraiDcT {
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

    private class ObIraiDc_IraiSogi_Stub implements ObIraiDc_IraiSogi.IObIraiDc_IraiSogi{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
    }
    private class ObIraiDc_IraiHoyo_Stub implements ObIraiDc_IraiHoyo.IObIraiDc_IraiHoyo{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
    }
    private class ObIraiDc_IraiKaimyo_Stub implements ObIraiDc_IraiKaimyo.IObIraiDc_IraiKaimyo{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
    }
    private class ObIraiDc_Terapass_Stub implements ObIraiDc_Terapass.IObIraiDc_Terapass{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
    }

    private class SendMethodDecision_Stub implements ObIrHkSendSvcIraiDc.ISendMethodDecision{
        public String returnValue = 'mail';
        public String getMethod(String pOpp_Iraisyosofuhouhou){ return returnValue; }
    }

    @isTest
    public static void getDoc(){
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

        ObIrHkSendSvcIraiDc.mObIraiDc_IraiSogi = new ObIraiDc_IraiSogi_Stub();
        ObIrHkSendSvcIraiDc.mObIraiDc_IraiHoyo = new ObIraiDc_IraiHoyo_Stub();
        ObIrHkSendSvcIraiDc.mObIraiDc_IraiKaimyo = new ObIraiDc_IraiKaimyo_Stub();
        ObIrHkSendSvcIraiDc.mObIraiDc_Terapass = new ObIraiDc_Terapass_Stub();

        SendMethodDecision_Stub the_SendMethodDecision_Stub = new SendMethodDecision_Stub();
        ObIrHkSendSvcIraiDc.mSendMethodDecision = the_SendMethodDecision_Stub;

        ObIrHkSendSvcIraiDc.Req theReq = new ObIrHkSendSvcIraiDc.Req();
        theReq.opp_id = theOpps.get('お坊').Id;

        endSetUp();

        Test.startTest();
        the_SendMethodDecision_Stub.returnValue = 'mail';
        ObIrHkSendSvcIraiDc.getDoc(theReq);

        the_SendMethodDecision_Stub.returnValue = 'fax';
        ObIrHkSendSvcIraiDc.getDoc(theReq);

        the_SendMethodDecision_Stub.returnValue = 'fax_and_mail';
        ObIrHkSendSvcIraiDc.getDoc(theReq);
        Test.stopTest();
    }

    @isTest
    public static void SendMethodDecision_getMethod(){
        Test.startTest();
        new ObIrHkSendSvcIraiDc.SendMethodDecision().getMethod(null);
        Test.stopTest();
    }
}