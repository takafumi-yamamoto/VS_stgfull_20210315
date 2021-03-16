@isTest
private class Api_V1_WebAccountServiceTest {

  static testMethod void test_WebAccountService_ERROR() {
        Api_V1_WebAccountService.RequestBean req = new Api_V1_WebAccountService.RequestBean();
        //req.Iraibango = 'test';

        String reqJson = JSON.serialize(req);
        System.debug(reqJson);

        Test.startTest();
        
        RestRequest  req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        
        req1.requestURI = '/services/apexrest/WebAccountService/';
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueof(reqJson);

        RestContext.request = req1;
        RestContext.response= res1;

        Api_V1_WebAccountService.doPost();

        Test.stopTest();
    }


  //static testMethod void test_WebAccountService() {
  //      String settingName = 'dev';
  //      if(Environments.isSandbox())
  //          settingName = 'dev';
  //      else settingName = 'prod';


  //      TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
  //      TriggerIsActive.name='default';
  //      TriggerIsActive.isActive__c=true;
  //      insert TriggerIsActive;

  //      KaiinkibanSetting__c KaiinkibanSetting = new KaiinkibanSetting__c();
  //      KaiinkibanSetting.name=settingName;
  //      KaiinkibanSetting.isActive__c = true;
  //      KaiinkibanSetting.timeOutPeriod__c = 600000;
  //      KaiinkibanSetting.Endpoint__c = 'http://www.minrevi.jp.test';
  //      insert KaiinkibanSetting;
        
  //      Account acc = new Account( Name = 'アカウントtest');
  //      insert acc;

  //      List<WebAccountTourokuIrai__c> webaccounttourokuiraiList = new List<WebAccountTourokuIrai__c>();

  //      WebAccountTourokuIrai__c webaccounttourokuirai = new WebAccountTourokuIrai__c();
  //      webaccounttourokuirai.TorihikiSakiRef__c = acc.id;    //取引先
  //      webaccounttourokuirai.NinshoHouhou__c = 'メールアドレス';    //認証方法
  //      webaccounttourokuirai.TourokuChi__c = 'abcd@ggggtest12390ds.com';    //登録値
  //      //webaccounttourokuirai.TourokuChiHenkouMae__c = 'ZfiGBDV@ggggtest12390ds.com' ;    //登録値(変更前)
  //      //webaccounttourokuirai.ShoriStatus__c = 'Closed_Error';    //処理ステータス
  //      webaccounttourokuirai.WebAccountRequestTryCount__c = 1 ;    //Webアカウント依頼試行回数
  //      webaccounttourokuirai.WebAccountRequestTryLimit__c = 4;    //Webアカウント依頼試行最大回数
  //      webaccounttourokuirai.ShoriKubun__c = 'New';    //処理区分
  //      webaccounttourokuiraiList.add(webaccounttourokuirai);
  //      insert webaccounttourokuiraiList;
  //      webaccounttourokuirai.ShoriStatus__c = 'Processing_WebAccountRequested';
  //      update webaccounttourokuirai;

  //      WebAccountTourokuIrai__c aWebaccounttourokuirai = [Select Name FROM WebAccountTourokuIrai__c WHERE id = : webaccounttourokuirai.Id limit 1];
  //      System.debug('>>>>>>');
  //      System.debug(aWebaccounttourokuirai);

  //      //WebAccountTourokuIrai__c irai = Dao_WebAccountTourokuIrai.GetInstance().getWebAccountTourokuIraiListByIraibango(aWebaccounttourokuirai.Name);
  //      //System.debug('>>>>irai');
  //      //System.debug(irai);

  //      Api_V1_WebAccountService.RequestBean req = new Api_V1_WebAccountService.RequestBean();
  //      req.Iraibango = aWebaccounttourokuirai.Name;

  //      String reqJson = JSON.serialize(req);

  //      Test.startTest();
        
  //      RestRequest  req1 = new RestRequest();
  //      RestResponse res1 = new RestResponse();
        
  //      req1.requestURI = '/services/apexrest/WebAccountService/';
  //      req1.httpMethod = 'POST';
  //      req1.requestBody = Blob.valueof(reqJson);

  //      RestContext.request = req1;
  //      RestContext.response= res1;

  //      Api_V1_WebAccountService.doPost();

  //      Test.stopTest();
  //  }



  //static testMethod void test_WebAccountService_update() {
  //      String settingName = 'dev';
  //      if(Environments.isSandbox())
  //          settingName = 'dev';
  //      else settingName = 'prod';

  //      TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
  //      TriggerIsActive.name='default';
  //      TriggerIsActive.isActive__c=true;
  //      insert TriggerIsActive;

  //      KaiinkibanSetting__c KaiinkibanSetting = new KaiinkibanSetting__c();
  //      KaiinkibanSetting.name=settingName;
  //      KaiinkibanSetting.isActive__c = true;
  //      KaiinkibanSetting.timeOutPeriod__c = 600000;
  //      KaiinkibanSetting.Endpoint__c = 'http://www.minrevi.jp.test';
  //      insert KaiinkibanSetting;
        
  //      Account acc = new Account( Name = 'アカウントtest');
  //      insert acc;

  //      List<WebAccountTourokuIrai__c> webaccounttourokuiraiList = new List<WebAccountTourokuIrai__c>();

  //      WebAccountTourokuIrai__c webaccounttourokuirai = new WebAccountTourokuIrai__c();
  //      webaccounttourokuirai.TorihikiSakiRef__c = acc.id;    //取引先
  //      webaccounttourokuirai.NinshoHouhou__c = 'メールアドレス';    //認証方法
  //      webaccounttourokuirai.TourokuChi__c = 'abcd@ggggtest12390ds.com';    //登録値
  //      webaccounttourokuirai.TourokuChiHenkouMae__c = 'ZfiGBDV@ggggtest12390ds.com' ;    //登録値(変更前)
  //      //webaccounttourokuirai.ShoriStatus__c = 'Closed_Error';    //処理ステータス
  //      webaccounttourokuirai.WebAccountRequestTryCount__c = 1 ;    //Webアカウント依頼試行回数
  //      webaccounttourokuirai.WebAccountRequestTryLimit__c = 4;    //Webアカウント依頼試行最大回数
  //      webaccounttourokuirai.ShoriKubun__c = 'Modify';    //処理区分
  //      webaccounttourokuiraiList.add(webaccounttourokuirai);
  //      insert webaccounttourokuiraiList;
  //      webaccounttourokuirai.ShoriStatus__c = 'Processing_WebAccountRequested';
  //      update webaccounttourokuirai;

  //      WebAccountTourokuIrai__c aWebaccounttourokuirai = [Select Name FROM WebAccountTourokuIrai__c WHERE id = : webaccounttourokuirai.Id limit 1];
  //      System.debug('>>>>>>');
  //      System.debug(aWebaccounttourokuirai);

  //      //WebAccountTourokuIrai__c irai = Dao_WebAccountTourokuIrai.GetInstance().getWebAccountTourokuIraiListByIraibango(aWebaccounttourokuirai.Name);
  //      //System.debug('>>>>irai');
  //      //System.debug(irai);

  //      Api_V1_WebAccountService.RequestBean req = new Api_V1_WebAccountService.RequestBean();
  //      req.Iraibango = aWebaccounttourokuirai.Name;

  //      String reqJson = JSON.serialize(req);

  //      Test.startTest();
        
  //      RestRequest  req1 = new RestRequest();
  //      RestResponse res1 = new RestResponse();
        
  //      req1.requestURI = '/services/apexrest/WebAccountService/';
  //      req1.httpMethod = 'POST';
  //      req1.requestBody = Blob.valueof(reqJson);

  //      RestContext.request = req1;
  //      RestContext.response= res1;

  //      Api_V1_WebAccountService.doPost();

  //      Test.stopTest();
  //  }
}