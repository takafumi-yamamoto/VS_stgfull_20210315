@isTest
public class ObIrHkSendSvcHokoDcT {
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

    private class ObHokoDc_Sofujo_Stub implements ObHokoDc_Sofujo.IObHokoDc_Sofujo{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, Boolean p_NoPanf){ 
            return new OpFcReq.TemplateData().setTemplateName('_'); 
        }
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
    private class ObHokoDc_Cyuin_Stub implements ObHokoDc_Cyuin.IObHokoDc_Cyuin{
        public OpFcReq.TemplateData getOpFcTemplateData(String pOppId){ 
            return new OpFcReq.TemplateData() .setTemplateName('_'); 
        }
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

        ObIrHkSendSvcHokoDc.mObHokoDc_Sofujo = new ObHokoDc_Sofujo_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_TehaiSogi = new ObHokoDc_TehaiSogi_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_TehaiKaimyo = new ObHokoDc_TehaiKaimyo_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_TehaiHoyo = new ObHokoDc_TehaiHoyo_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_Cyuin = new ObHokoDc_Cyuin_Stub();

        ObIrHkSendSvcHokoDc.Req theReq = new ObIrHkSendSvcHokoDc.Req();
        theReq.opp_id = theOpps.get('お坊').Id;

        endSetUp();

        Test.startTest();
        ObIrHkSendSvcHokoDc.getDoc(theReq);
        Test.stopTest();
    }

    @isTest
    public static void getDoc_ShoryoSofuSaki_Specified(){
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
                ObosanbinRef__c = theObos.get('お坊').Id,
                ShiryoSoufuSakiAtena__c = 'test',
                ShiryoSoufuSakiPostalCode__c = '1410031',
                ShiryoSoufuSakiState__c = 'test',
                ShiryoSoufuSakiCity__c = 'test',
                ShiryoSoufuSakiStreet__c = 'test'
            )
        };
        INSERT theOpps.values();

        ObIrHkSendSvcHokoDc.mObHokoDc_Sofujo = new ObHokoDc_Sofujo_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_TehaiSogi = new ObHokoDc_TehaiSogi_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_TehaiKaimyo = new ObHokoDc_TehaiKaimyo_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_TehaiHoyo = new ObHokoDc_TehaiHoyo_Stub();
        ObIrHkSendSvcHokoDc.mObHokoDc_Cyuin = new ObHokoDc_Cyuin_Stub();

        ObIrHkSendSvcHokoDc.Req theReq = new ObIrHkSendSvcHokoDc.Req();
        theReq.opp_id = theOpps.get('お坊').Id;

        endSetUp();

        Test.startTest();
        ObIrHkSendSvcHokoDc.getDoc(theReq);
        Test.stopTest();
    }
}