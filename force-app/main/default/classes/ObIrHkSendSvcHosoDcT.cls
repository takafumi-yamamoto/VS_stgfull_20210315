@isTest
public class ObIrHkSendSvcHosoDcT {
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

    private class ObHokoDc_TehaiSogi_Stub implements ObHokoDc_TehaiSogi.IObHokoDc_TehaiSogi{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
    }
    private class ObHokoDc_TehaiKaimyo_Stub implements ObHokoDc_TehaiKaimyo.IObHokoDc_TehaiKaimyo{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
    }
    private class ObHokoDc_TehaiHoyo_Stub implements ObHokoDc_TehaiHoyo.IObHokoDc_TehaiHoyo{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
    }
    private class ObIrHkShoryuProvider_Stub implements ObIrHkShoryu.IProvider{
        public ObIrHkShoryu.Kubuns getKubun(String pRyunyumotoService){return ObIrHkShoryu.Kubuns.SogiTenkan;}
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

        ObIrHkSendSvcHosoDc.mObHokoDc_TehaiSogi = new ObHokoDc_TehaiSogi_Stub();
        ObIrHkSendSvcHosoDc.mObHokoDc_TehaiKaimyo = new ObHokoDc_TehaiKaimyo_Stub();
        ObIrHkSendSvcHosoDc.mObHokoDc_TehaiHoyo = new ObHokoDc_TehaiHoyo_Stub();
        ObIrHkSendSvcHosoDc.mObIrHkShoryuProvider = new ObIrHkShoryuProvider_Stub();

        ObIrHkSendSvcHosoDc.Req theReq = new ObIrHkSendSvcHosoDc.Req();
        theReq.opp_id = theOpps.get('お坊').Id;

        endSetUp();

        Test.startTest();
        ObIrHkSendSvcHosoDc.getDoc(theReq);
        Test.stopTest();
    }
}