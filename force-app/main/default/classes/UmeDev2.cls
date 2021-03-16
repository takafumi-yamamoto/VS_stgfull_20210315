public class UmeDev2 {

    public static void doAnonymous(){
        //UmeDev2.do_AcntCustRslvr();
        //DELETE New Account(Id = '0011s00000MWbgPAAT');

        //UmeDev2.SogiShiryoSofuCreator_createSogiShiryoSofu();
        //UmeDev2.do_dev();
        UmeDev2.TaioRerekiImporter_run_import();
    }

    public static void SogiShiryoSofuCreator_createSogiShiryoSofu(){
        // TcmsTaioRkImpData__c theTcmsTaioRkImpData = 
        //     new TcmsTaioRkImp.TcmsTaioRkImpDataSelector().selectTcmsTaioRkImpData('a5e1s0000005AUjAAM');
        // new TcmsTaioRkImpSogiShiryo.SogiShiryoSofuCreator().createSogiShiryoSofu('0061s000004gg7mAAA', theTcmsTaioRkImpData);
    }
    public static void TaioRerekiImporter_run_import(){
        TcmsTaioRkImpData__c theData = new TcmsTaioRkImp.TcmsTaioRkImpDataSelector().selectTcmsTaioRkImpData('a5e1s0000005AXsAAM');
        TcmsTaioRkImpOpp.get_IOppCreator_instance().createOpp(theData);
    }
    public static void TaioRerekiImporter_import(){
        // String the_opp_id = new TcmsTaioRkImp.TaioRerekiImporter().import('a5e1s0000005AUjAAM');
        // System.Debug(the_opp_id);
    }
    
    public static void OppCreator_createOpp(){
        // String the_opp_id = new TcmsTaioRkImpOpp.OppCreator().createOpp('a5e1s0000005AUjAAM');
        // System.Debug(the_opp_id);
    }
    public static void do_AcntCustRslvr() {
        AcntCustRslvr.IAccountRelver the_AcntCustRslvr = new AcntCustRslvr.AccountRelver();

        AcntCustRslvr.Req the_req = 
            new AcntCustRslvr.Req()
            .set_last_name('テスト梅崎')
            .set_first_name('自動登録001')
            .set_last_name_kana('テストウメザキ')
            .set_first_name_kana('ジドウトウロク001')
           .set_email('takeharu-umezaki+202009181641@yoriso.com')
           .set_phone('00099999999')
            .set_mobile('08099999999')
            .set_postal_code('1410031')
            .set_state('東京都')
            .set_city('品川区')
            .set_street('テスト町1-1');
        
        AcntCustRslvr.Result the_result = the_AcntCustRslvr.try_insert(the_req);
        
        System.Debug(the_result);
    }

    public static void do_ins_task(){
        Task insTask = new Task();
        insTask.WhatId = '0061s000004gd7pAAA';
        //insTask.WhoId = toOpportunityByCrossCellMap.get(crossteian.Id).Account.PersonContactId;
        insTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId();
        insTask.Status = '完了';
        insTask.ShiborikomiJoken__c = 'トランスコスモスコメント';
        insTask.Description = 'this is test';
        insTask.TaskSubtype = 'Call';
        insTask.Kijitsu__c = Datetime.newInstance(2020,1,1,12,33,00);
        INSERT insTask;
    }
}