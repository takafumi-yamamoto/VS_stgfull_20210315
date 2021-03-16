@isTest
public class ObHokoSmT {
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
    public static void createAcrtSmsSenderReq() {
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
                MemorialServicePlan__c = '_'
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

        ObHokoSm.Req theReq = new ObHokoSm.Req();
        theReq.account_id = theAccounts.get('客').Id;
        theReq.account_name = '_';
        theReq.telno = '99999999999';
        theReq.opp_id = theOpps.get('お坊').Id;
        theReq.pdf_url = '_';
        theReq.pdf_password = '_';
        endSetUp();

        Test.startTest();
        new ObHokoSm( new ObHokoSm.OppDataPvdr()).createAcrtSmsSenderReq(theReq);
        Test.stopTest();
    }

    @isTest static void DlrHdlr_handleAcrtDrResult(){
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
                MemorialServicePlan__c = '_'
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

        Map<String, AcrtDrTack__c> theAcrtDrTacks = new Map<String,AcrtDrTack__c>{
            '1' => new AcrtDrTack__c(
                delivery_id__c = '1',
                AccountRef__c = theAccounts.get('客').Id,
                telno__c = '99999999999',
                text_long__c = 'sample-message',
                send_dt__c = Datetime.newInstance(2020,1,1),
                OppRef__c = theOpps.get('お坊').Id
                )
        };
        INSERT theAcrtDrTacks.values();

        AcrtDrResultQms.Data theData = new AcrtDrResultQms.Data();
        theData.AcrtDrTack_Id = theAcrtDrTacks.get('1').Id;
        theData.AcrtDrTack_MsgType = 'sample_msg_type';
        theData.Result_Code = AcrtApiSmsDr.result_code_undelivered;
        theData.isExpired = false;
        endSetUp();

        Test.startTest();
        new ObHokoSm.DlrHdlr().handleAcrtDrResult(theData);
        Test.stopTest();

    }
}