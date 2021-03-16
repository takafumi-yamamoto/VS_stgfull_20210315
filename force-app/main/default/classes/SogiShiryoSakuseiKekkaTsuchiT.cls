@isTest
public class SogiShiryoSakuseiKekkaTsuchiT {

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
    static void testMethod_case1(){

        beginSetUp();

        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        Database.SaveResult lsrdacc = Database.insert(dacc);

        //取引先のデータ作成
        Account acc=new Account();
        acc.name='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        Database.SaveResult lsracc = Database.insert(acc);

        Case c = new case(
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId(),
                        Lastname__c = '鈴木',
                        Firstname__c = '一郎',
                        FirstNameKana__c = 'スズキ',
                        LastNameKana__c = 'イチロウ',
                        TelNo__c = '080-0000-0001',
                        KiboAreaState__c = '東京都',
                        KiboAreaCity__c = '品川区',
                        MailAddress__c = 'test@yoriso.com',
                        Origin = 'Web',
                        ShiryoSoufuHoho__c = 'メール',
                        TaishoushaJokyo__c = '健在',
                        uniq_id__c = 'test'
                    );
        insert c;

        opportunity opp=new opportunity();
        opp.accountid=lsracc.getid();
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        opp.accountid=acc.id;
        opp.TesuryoPartner__c = 5000;
        opp.TaishoushaJokyo__c = '_';
        opp.CaseRef__c = c.Id;
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Database.SaveResult lsropp = Database.insert(opp);

        SogiShiryoSakuseiKekka__c kekka = new SogiShiryoSakuseiKekka__c();
        insert kekka;

        SogiShiryoSofu__c shiryo = new SogiShiryoSofu__c(
            OpportunityRef__c = lsropp.getid(),                                      // 商談
            SofuJokyo__c = '印刷待ち',                                               // 送付状況
            SofuShubetsu__c = '郵便',                                                // 送付種別
            YusoShubetsu__c = '速達',                                                // 郵送種別
            Atena__c = 'AAAA',                                                       // 宛名
            PostalCode__c = '141-0031',                                              // 郵便番号
            State__c = '東京都',                                                     // 都道府県
            City__c = '品川区',                                                      // 市区郡
            Street__c = '西五反田',                                                  // 町名・番地
            InsatsubutsuIchiran__c = '送付状; 斎場資料; 見積書; 事前割証書',         // 印刷物一覧
            PamphletYohi__c = '要',                                                  // パンフレット要否
            SofuNichiji__c = Datetime.valueOf('2020-06-30 19:18:00'),                // 送付日時
            TaSofubutsu1__c = 'ベス仏カタログ',                                      // 他送付物1
            IsogiTaio__c = true,                                                     // 急ぎ対応
            SofuShiryoURL__c = 'https://opro.dev.yoriso.com/AAA.pdf',                // 送付資料URL
            HikitsugiJiko__c = '',                                                   // 引継事項
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00'),             // 印刷日時
            Mail__c = 'test@yoriso.com',
            PassWord__c = 'test',
            AutoShiryoSofuMailSend__c = false,
            SogiShiryoSakuseiKekkaRef__c = kekka.Id
        );
        insert shiryo;

        endSetUp();

        Test.startTest();
        
        SogiShiryoSakuseiKekka__c sltKekka = [select Id, StatusCode__c from SogiShiryoSakuseiKekka__c where Id = :kekka.Id];
        sltKekka.StatusCode__c = '200';
        update sltKekka;

        SogiShiryoSakuseiKekkaTsuchi.sendMailShiryoSofuAdmin([select Id, 
                                                                            AutoShiryoSofuMailSend__c, 
                                                                            SofuJokyo__c, 
                                                                            SofuNichiji__c, 
                                                                            Atena__c, 
                                                                            Mail__c, 
                                                                            PassWord__c, 
                                                                            SofuShiryoURL__c, 
                                                                            PdfAutoCreateErrMsg__c, 
                                                                            InsatsubutsuIchiran__c, 
                                                                            OpportunityRef__r.RecordType.DeveloperName, 
                                                                            OpportunityRef__c, 
                                                                            OpportunityRef__r.AccountId, 
                                                                            OpportunityRef__r.Account.PersonContactId, 
                                                                            OpportunityRef__r.CaseRef__r.RecordType.DeveloperName, 
                                                                            OpportunityRef__r.CaseRef__r.Lastname__c, 
                                                                            OpportunityRef__r.CaseRef__r.Firstname__c, 
                                                                            OpportunityRef__r.CaseRef__r.LastNameKana__c, 
                                                                            OpportunityRef__r.CaseRef__r.FirstNameKana__c, 
                                                                            OpportunityRef__r.CaseRef__r.KeitaiDenwa__c, 
                                                                            OpportunityRef__r.CaseRef__r.TelNo__c, 
                                                                            OpportunityRef__r.CaseRef__r.Jusho__c, 
                                                                            OpportunityRef__r.CaseRef__r.ShiryoSoufuHoho__c, 
                                                                            OpportunityRef__r.CaseRef__r.MailAddress__c, 
                                                                            OpportunityRef__r.CaseRef__r.SalesforceOrgURL__c, 
                                                                            OpportunityRef__r.CaseRef__r.DuplicationCheckAccountUrl__c, 
                                                                            OpportunityRef__r.CaseRef__r.AddressConfirmInfo__c, 
                                                                            OpportunityRef__r.CaseRef__r.uniq_id__c, 
                                                                            OpportunityRef__r.CaseRef__r.KiboAreaState__c, 
                                                                            OpportunityRef__r.CaseRef__r.KiboAreaCity__c, 
                                                                            OpportunityRef__r.CaseRef__r.TaishoshaKyojuKeitai__c, 
                                                                            OpportunityRef__r.CaseRef__r.WebShiryoSeikyuTaishoushaJokyo__c, 
                                                                            OpportunityRef__r.CaseRef__r.TaishoshaYomeiKikan__c, 
                                                                            OpportunityRef__r.CaseRef__r.ToiawaseKiinsha__c, 
                                                                            OpportunityRef__r.CaseRef__r.EndingNoteFlg__c, 
                                                                            OpportunityRef__r.CaseRef__r.ToiawaseDate__c, 
                                                                            OpportunityRef__r.CaseRef__r.MailArrivalTime__c, 
                                                                            OpportunityRef__r.CaseRef__r.PostalCode__c, 
                                                                            OpportunityRef__r.CaseRef__r.State__c, 
                                                                            OpportunityRef__r.CaseRef__r.City__c, 
                                                                            OpportunityRef__r.CaseRef__r.Street__c, 
                                                                            OpportunityRef__r.CaseRef__r.RecordTypeId, 
                                                                            OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c, 
                                                                            LastModifiedById 
                                                                        from SogiShiryoSofu__c
                                                                        where Id = :shiryo.Id]);
        
        Test.stopTest();
    }

    @isTest
    static void testMethod_case2(){

        beginSetUp();

        Account dacc=new Account();
        dacc.LastName='xxxdefualt';
        dacc.Phone='088-0000-0001';
        dacc.MobilePhone__c='888-0000-0001';
        dacc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId();
        Database.SaveResult lsrdacc = Database.insert(dacc);

        //取引先のデータ作成
        Account acc=new Account();
        acc.name='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        Database.SaveResult lsracc = Database.insert(acc);

        Case c = new case(
                        RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoEndingnoteWebForm').getRecordTypeId(),
                        Lastname__c = '鈴木',
                        Firstname__c = '一郎',
                        FirstNameKana__c = 'スズキ',
                        LastNameKana__c = 'イチロウ',
                        TelNo__c = '080-0000-0001',
                        KiboAreaState__c = '東京都',
                        KiboAreaCity__c = '品川区',
                        MailAddress__c = 'test@yoriso.com',
                        Origin = 'Web',
                        ShiryoSoufuHoho__c = 'メール',
                        TaishoushaJokyo__c = '健在',
                        uniq_id__c = 'test'
                    );
        insert c;

        opportunity opp=new opportunity();
        opp.accountid=lsracc.getid();
        opp.Name='test';
        opp.StageName='商談開始';
        opp.Req_Day__c = Date.today();
        opp.CloseDate = Date.today();
        opp.KakuteibiSyodan__c = Date.today();
        opp.Utiagebi__c = Date.today();
        opp.accountid=acc.id;
        opp.TesuryoPartner__c = 5000;
        opp.TaishoushaJokyo__c = '_';
        opp.CaseRef__c = c.Id;
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Database.SaveResult lsropp = Database.insert(opp);

        SogiShiryoSakuseiKekka__c kekka = new SogiShiryoSakuseiKekka__c();
        insert kekka;

        SogiShiryoSofu__c shiryo = new SogiShiryoSofu__c(
            OpportunityRef__c = lsropp.getid(),                                      // 商談
            SofuJokyo__c = '印刷待ち',                                               // 送付状況
            SofuShubetsu__c = '郵便',                                                // 送付種別
            YusoShubetsu__c = '速達',                                                // 郵送種別
            Atena__c = 'AAAA',                                                       // 宛名
            PostalCode__c = '141-0031',                                              // 郵便番号
            State__c = '東京都',                                                     // 都道府県
            City__c = '品川区',                                                      // 市区郡
            Street__c = '西五反田',                                                  // 町名・番地
            InsatsubutsuIchiran__c = '送付状; 斎場資料; 見積書; 事前割証書',         // 印刷物一覧
            PamphletYohi__c = '要',                                                  // パンフレット要否
            SofuNichiji__c = Datetime.valueOf('2020-06-30 19:18:00'),                // 送付日時
            TaSofubutsu1__c = 'ベス仏カタログ',                                      // 他送付物1
            IsogiTaio__c = true,                                                     // 急ぎ対応
            SofuShiryoURL__c = 'https://opro.dev.yoriso.com/AAA.pdf',                // 送付資料URL
            HikitsugiJiko__c = '',                                                   // 引継事項
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00'),             // 印刷日時
            Mail__c = 'test@yoriso.com',
            PassWord__c = 'test',
            AutoShiryoSofuMailSend__c = false,
            SogiShiryoSakuseiKekkaRef__c = kekka.Id
        );
        insert shiryo;

        endSetUp();

        Test.startTest();
        
        SogiShiryoSakuseiKekka__c sltKekka = [select Id, StatusCode__c from SogiShiryoSakuseiKekka__c where Id = :kekka.Id];
        sltKekka.StatusCode__c = '200';
        update sltKekka;

        SogiShiryoSakuseiKekkaTsuchi.sendMailShiryoSofuAdmin([select Id, 
                                                                            AutoShiryoSofuMailSend__c, 
                                                                            SofuJokyo__c, 
                                                                            SofuNichiji__c, 
                                                                            Atena__c, 
                                                                            Mail__c, 
                                                                            PassWord__c, 
                                                                            SofuShiryoURL__c, 
                                                                            PdfAutoCreateErrMsg__c, 
                                                                            InsatsubutsuIchiran__c, 
                                                                            OpportunityRef__r.RecordType.DeveloperName, 
                                                                            OpportunityRef__c, 
                                                                            OpportunityRef__r.AccountId, 
                                                                            OpportunityRef__r.Account.PersonContactId, 
                                                                            OpportunityRef__r.CaseRef__r.RecordType.DeveloperName, 
                                                                            OpportunityRef__r.CaseRef__r.Lastname__c, 
                                                                            OpportunityRef__r.CaseRef__r.Firstname__c, 
                                                                            OpportunityRef__r.CaseRef__r.LastNameKana__c, 
                                                                            OpportunityRef__r.CaseRef__r.FirstNameKana__c, 
                                                                            OpportunityRef__r.CaseRef__r.KeitaiDenwa__c, 
                                                                            OpportunityRef__r.CaseRef__r.TelNo__c, 
                                                                            OpportunityRef__r.CaseRef__r.Jusho__c, 
                                                                            OpportunityRef__r.CaseRef__r.ShiryoSoufuHoho__c, 
                                                                            OpportunityRef__r.CaseRef__r.MailAddress__c, 
                                                                            OpportunityRef__r.CaseRef__r.SalesforceOrgURL__c, 
                                                                            OpportunityRef__r.CaseRef__r.DuplicationCheckAccountUrl__c, 
                                                                            OpportunityRef__r.CaseRef__r.AddressConfirmInfo__c, 
                                                                            OpportunityRef__r.CaseRef__r.uniq_id__c, 
                                                                            OpportunityRef__r.CaseRef__r.KiboAreaState__c, 
                                                                            OpportunityRef__r.CaseRef__r.KiboAreaCity__c, 
                                                                            OpportunityRef__r.CaseRef__r.TaishoshaKyojuKeitai__c, 
                                                                            OpportunityRef__r.CaseRef__r.WebShiryoSeikyuTaishoushaJokyo__c, 
                                                                            OpportunityRef__r.CaseRef__r.TaishoshaYomeiKikan__c, 
                                                                            OpportunityRef__r.CaseRef__r.ToiawaseKiinsha__c, 
                                                                            OpportunityRef__r.CaseRef__r.EndingNoteFlg__c, 
                                                                            OpportunityRef__r.CaseRef__r.ToiawaseDate__c, 
                                                                            OpportunityRef__r.CaseRef__r.MailArrivalTime__c, 
                                                                            OpportunityRef__r.CaseRef__r.PostalCode__c, 
                                                                            OpportunityRef__r.CaseRef__r.State__c, 
                                                                            OpportunityRef__r.CaseRef__r.City__c, 
                                                                            OpportunityRef__r.CaseRef__r.Street__c, 
                                                                            OpportunityRef__r.CaseRef__r.RecordTypeId, 
                                                                            OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c, 
                                                                            LastModifiedById 
                                                                        from SogiShiryoSofu__c
                                                                        where Id = :shiryo.Id]);
        
        Test.stopTest();
    }
}