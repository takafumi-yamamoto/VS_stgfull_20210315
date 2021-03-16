@isTest
public class MakeSMSTelephoneInflowSogiFollowHaishinT {

    @isTest static void doTest_bat1(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','0');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }
    @isTest static void doTest_bat2(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','A');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }
    @isTest static void doTest_bat3(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','B');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat4(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','0');
        updateOpptunity(NewOpp,'フェーズ');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat5(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','0');
        updateOpptunity(NewOpp,'対象者状態');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }


    @isTest static void doTest_bat6(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','0');
        updateOpptunity(NewOpp,'SMSフォローNG');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat7(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','0');
        updateOpptunity(NewOpp,'SMSNG');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat8(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','A');
        updateOpptunity(NewOpp,'メンバー制度登録拒否');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat9(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','A');
        updateOpptunity(NewOpp,'事前割メンバー登録済True');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat10(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','B');
        updateOpptunity(NewOpp,'事前割メンバー登録済False');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat11(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','B');
        updateOpptunity(NewOpp,'事前準備シート登録拒否');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat12(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','B');
        updateOpptunity(NewOpp,'事前準備シート提出済');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat13(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','P');
        Database.SaveResult NewAchievement = NewAchievement(NewAcc,NewOpp);
        updateOpptunity(NewOpp,'事前割メンバー登録済True');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    @isTest static void doTest_bat14(){
        Test.startTest();
        Database.SaveResult NewAcc = NewAccDate('xxxdefualt','mail@yoriso.com','080-0000-0001');
        Database.SaveResult NewOpp = NewOppSMSDate(NewAcc,'フォロー','P');
        updateOpptunity(NewOpp,'事前割メンバー登録済False');
        MockAccreteSmsApi mock = new MockAccreteSmsApi();
		mock.setStatusCodeSmsReg(200);
        Test.setMock(HttpCalloutMock.class, mock);
        MakeSMSTelephoneInflowSogiFollowHaishin batchable = new MakeSMSTelephoneInflowSogiFollowHaishin();
        Database.executeBatch(batchable);
        Test.stopTest();
    }

    private static Database.SaveResult NewAchievement (Database.SaveResult NewAcc,Database.SaveResult NewOpp) {
        Achievement__c achivement = new Achievement__c(
            TorihikiSakiRef__c = NewAcc.getid(),
            SourceShodanRef__c = NewOpp.getid(),
            Syubetsu__c = 'YorisoJizenWari',
            YukoFlag__c = true, 
            JizenwariMemberKisanbi__c = Date.today(),
            YukoKaishiBi__c = Date.today()
        );
        Database.SaveResult achiveResult = Database.insert(achivement);
        return achiveResult;
    }


    private static Database.SaveResult NewAccDate(String StrFirstName, String StrMailAddress, String StrMobilePhone){
        Account acc = new Account(
			LastName ='TEST',
			FirstName =StrFirstName,
            PermissionFlag__pc = '受け取る',
            Tel_Sogifollow_SmsPermission__c = True,
			MemberTourokuZumi__c = True,
			JizenJizenSheetTeishutsuzumi__c = false,
			MailAddress__c = StrMailAddress,
			YusenMailAddressKubun__c = 'メールアドレス1',
			MobilePhone__c =StrMobilePhone,
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'null')
		);
        Database.SaveResult lsracc = Database.insert(acc);
        return lsracc;
    }

    private static Database.SaveResult NewOppSMSDate(Database.SaveResult lsracc, String StrStageName , String phase) {
		
		Date DateNow = Date.today();
		Date InDate = DateNow.addDays(-5);
		Time FromTime = Time.newInstance(7, 0, 0, 0);
        DateTime InDateTime = DateTime.newInstance(InDate, FromTime);
        
        SimpleYasugo__c simpleobj = new SimpleYasugo__c (
            JizenJunbiSheetGoannaiJokyo__c = null
        );
        Database.SaveResult srobj = Database.insert(simpleobj);

		//商談のデータ作成
		opportunity opp1 = new opportunity(
			AccountId = lsracc.getId(),
			RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId(),
			Name = 'xxxdefualt',
			StageName = StrStageName,
			SubPhase__c = '',
			TaishoushaJokyo__c = '健在', 
            CloseDate = Date.today(),
            SimpleYasugoRef__c = srobj.getId(),
			Req_Day__c = InDateTime
		);

        Database.SaveResult lsropp = Database.insert(opp1);

        TelSogiFollowSMSDeliveryMember__c sobj = new TelSogiFollowSMSDeliveryMember__c (
            Tel_SendSogiSmsStatus__c = '未送信',
            Tel_SendSogiSmsResultMessage__c = '',
            Tel_SendSogiSmsNumber__c = '09011112222',
            Tel_SendSogiSmsDatetime__c = null,
            Tel_SendSogiSmsSchedule__c = Date.today(),
            Account__c = lsracc.getId(),
            Opportunity__c = lsropp.getId(),
            AccountID__c = lsracc.getId(),
            Tel_SendSogiSmsPhase__c = phase,
            Tel_SendSogiSmsYorisoMemberDay__c = null,
            Tel_SendSogiSmsMessage__c = null
        );

        Database.SaveResult lsrsobj = Database.insert(sobj);


		return lsropp;
    }

    private static void updateOpptunity (Database.SaveResult lsropp ,String updatePattern) {
        Opportunity opp = [SELECT Id , StageName , AccountId , SimpleYasugoRef__c FROM Opportunity WHERE Id = :lsropp.getId() limit 1];
        Account test = [SELECT Id,Name From Account Where Id = :opp.AccountId ];
        Opportunity updateData = null;
        Account updateAccountData = null;
        SimpleYasugo__c updateyasugo = null;

        switch on updatePattern {
            when 'フェーズ' {
                updateData = new Opportunity (
                    Id  = opp.Id,
                    StageName = 'お亡くなり対応'
                );                
            }
            when '対象者状態' {
                updateData = new Opportunity (
                    Id  = opp.Id,
                    TaishoushaJokyoGenzai__c = '死亡'
                );     
            }
            when 'SMSNG' {
                updateAccountData = new Account(
                    Id =opp.AccountId,
                    KoukokuSmsNg__c = True
                );
            }
            when 'SMSフォローNG' {
                updateAccountData = new Account(
                    Id =opp.AccountId,
                    Tel_Sogifollow_SmsPermission__c = False
                );
            }
            when 'メンバー制度登録拒否' {
                updateAccountData = new Account(
                    Id =opp.AccountId,
                    MemberSeidoGoannaiJokyo__c = '提出拒否'
                );
            }
            when '事前割メンバー登録済False' {
                updateAccountData = new Account(
                    Id =opp.AccountId,
                    MemberTourokuZumi__c = false
                );
            }
            when '事前割メンバー登録済True' {
                updateAccountData = new Account(
                    Id =opp.AccountId,
                    MemberTourokuZumi__c = True
                );
            }
            when '事前準備シート登録拒否' {
                updateyasugo = new SimpleYasugo__c(
                    Id = opp.SimpleYasugoRef__c,
                    JizenJunbiSheetGoannaiJokyo__c = '提出拒否'
                );
            }
            when '事前準備シート提出済' {
                updateAccountData = new Account(
                    Id =opp.AccountId,
                    JizenJizenSheetTeishutsuzumi__c = True
                );
            }
        }
        if(updateData != null){
            update updateData;
        }
        if(updateAccountData != null){
            update updateAccountData;
        }
        if(updateyasugo != null){
            update updateyasugo;
        }
    
    }    
}