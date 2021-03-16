/*
下記のクラスをテストします
WebAccountTourokuIraiTrigger
Trg_WebAccountTourokuIrai
Ctl_WebAccountTourokuIrai
WebAccountTourokuIraiService
*/
@isTest
private class WebAccountTourokuIraiTriggerTest {

    // webアカウントを登録
    static testMethod void test_new_webaccount() {

        /*TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        KaiinkibanSetting__c KaiinkibanSetting = new KaiinkibanSetting__c();
        KaiinkibanSetting.name='dev';
        KaiinkibanSetting.isActive__c = true;
        KaiinkibanSetting.timeOutPeriod__c = 600000;
        KaiinkibanSetting.Endpoint__c = 'http://www.minrevi.jp.test';
        insert KaiinkibanSetting;
        
        Account acc = new Account( LastName = 'アカウントtest');
        insert acc;

        List<WebAccountTourokuIrai__c> webaccounttourokuiraiList = new List<WebAccountTourokuIrai__c>();

        WebAccountTourokuIrai__c webaccounttourokuirai = new WebAccountTourokuIrai__c();
        webaccounttourokuirai.TorihikiSakiRef__c = acc.id;    //取引先
        webaccounttourokuirai.NinshoHouhou__c = 'メールアドレス';    //認証方法
        webaccounttourokuirai.TourokuChi__c = 'abcd@ggggtest12390ds.com';    //登録値
        //webaccounttourokuirai.TourokuChiHenkouMae__c = 'ZfiGBDV@ggggtest12390ds.com' ;    //登録値(変更前)
        //webaccounttourokuirai.ShoriStatus__c = 'Closed_Error';    //処理ステータス
        webaccounttourokuirai.WebAccountRequestTryCount__c = 1 ;    //Webアカウント依頼試行回数
        webaccounttourokuirai.WebAccountRequestTryLimit__c = 4;    //Webアカウント依頼試行最大回数
        webaccounttourokuirai.ShoriKubun__c = 'New';    //処理区分
        webaccounttourokuiraiList.add(webaccounttourokuirai);
        insert webaccounttourokuiraiList;*/
        
    }

	// webアカウントを登録
    static testMethod void test_update_webaccount() {

        /*TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        KaiinkibanSetting__c KaiinkibanSetting = new KaiinkibanSetting__c();
        KaiinkibanSetting.name='dev';
        KaiinkibanSetting.isActive__c = true;
        KaiinkibanSetting.timeOutPeriod__c = 600000;
        KaiinkibanSetting.Endpoint__c = 'http://www.minrevi.jp.test';
        insert KaiinkibanSetting;
        
		Account acc = new Account( Name = 'アカウントtest');
	    insert acc;

	    List<WebAccountTourokuIrai__c> webaccounttourokuiraiList = new List<WebAccountTourokuIrai__c>();

    	WebAccountTourokuIrai__c webaccounttourokuirai = new WebAccountTourokuIrai__c();
    	webaccounttourokuirai.TorihikiSakiRef__c = acc.id;    //取引先
    	webaccounttourokuirai.NinshoHouhou__c = 'メールアドレス';    //認証方法
    	webaccounttourokuirai.TourokuChi__c = 'abcd@ggggtest12390ds.com';    //登録値
    	webaccounttourokuirai.TourokuChiHenkouMae__c = 'ZfiGBDV@ggggtest12390ds.com' ;    //登録値(変更前)
    	//webaccounttourokuirai.ShoriStatus__c = 'Closed_Error';    //処理ステータス
    	webaccounttourokuirai.WebAccountRequestTryCount__c = 1 ;    //Webアカウント依頼試行回数
    	webaccounttourokuirai.WebAccountRequestTryLimit__c = 4;    //Webアカウント依頼試行最大回数
    	webaccounttourokuiraiList.add(webaccounttourokuirai);
	    insert webaccounttourokuiraiList;*/
	    
    }
}