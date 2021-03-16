@isTest public class TerapSgSkD3wKobetsuSvcT {
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

    @isTest public static void create_d3w_task(){
        beginSetUp();
        TerapSgSeik__c a_TerapSgSeik = new TerapSgSeik__c(
            BillingTargetYearMonth__c = Date.newInstance(2021,1,1),
            ToTorihikiSakiBango__c = '-', ToName__c = '-',
            Email_Shitei__c = 'test@yoriso.com',
            ToAddrZipCode__c = '-', ToAddrState__c = '-', City__c = '-', Street__c = '-',
            ZeinukiKingaku__c = 100, Tax__c = 100, ZeikomiKingaku__c = 100,
            ShiharaiKijitsu__c = Date.newInstance(2021,1,1), 
            FriKzGinkoName__c = '-', FriKzGinkoCode__c = '-',
            FriKzShitenName__c = '-', FriKzShitenCode__c = '-',
            FriKzKouzaType__c = '-', FriKzKouzaBango__c = '-', 
            FriKzMeigiName__c = '-',
            TesuryoRate__c = 0, TesuryoRateNextMonth__c = 0,
            Biko__c = '-',
            DocStatus__c = 'Closed'
        );
        INSERT a_TerapSgSeik;

        INSERT new TerapSgSeikLine__c(
            TerapSgSeikRef__c = a_TerapSgSeik.Id, 
            Descr__c = '-', UnitPrice__c = 100, Quantity__c = 1, Price__c = 100
        );
        INSERT new TerapSgSeikSekoLine__c(
            TerapSgSeikRef__c = a_TerapSgSeik.Id,
            ShodanBango__c = '-', SekoDate__c = Date.newInstance(2021,1,1), HoyoShubetsu__c = '-', Seshu__c = ''
        );
        INSERT new TerapSgSeikCallLine__c(
            TerapSgSeikRef__c = a_TerapSgSeik.Id,
            ShodanBango__c = '-', ToiawaseDate__c = Date.newInstance(2021,1,1), HoyoShubetsu__c = '-', Seshu__c = ''
        );

        String a_seikyu_no = [SELECT Id, Name FROM TerapSgSeik__c WHERE Id = : a_TerapSgSeik.Id LIMIT 1].get(0).Name;
        endSetUp();

        Test.startTest();
        TerapSgSkD3wKobetsuSvc.create_d3w_task_req a_req = new TerapSgSkD3wKobetsuSvc.create_d3w_task_req();
        a_req.terap_sg_seik_no = a_seikyu_no;
        a_req.is_preview_mode = true;
        TerapSgSkD3wKobetsuSvc.create_d3w_task(a_req);
        Test.stopTest();
    }

    @isTest public static void create_d3w_task_seikyu_no_error(){
        Test.startTest();
        TerapSgSkD3wKobetsuSvc.create_d3w_task_req a_req = new TerapSgSkD3wKobetsuSvc.create_d3w_task_req();
        a_req.terap_sg_seik_no = null;
        a_req.is_preview_mode = true;
        TerapSgSkD3wKobetsuSvc.create_d3w_task(a_req);
        Test.stopTest();
    }
    @isTest public static void create_d3w_task_no_record_error(){
        Test.startTest();
        TerapSgSkD3wKobetsuSvc.create_d3w_task_req a_req = new TerapSgSkD3wKobetsuSvc.create_d3w_task_req();
        a_req.terap_sg_seik_no = 'xxx';
        a_req.is_preview_mode = true;
        TerapSgSkD3wKobetsuSvc.create_d3w_task(a_req);
        Test.stopTest();
    }
}