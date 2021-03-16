@isTest
public class SogiShiryoSofuSofuzumiProcessingT {

    @isTest
    static void testMethod_case1(){

        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );

        //取引先のデータ作成
        Account acc=new Account();
        acc.name='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        Database.SaveResult lsracc = Database.insert(acc);

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
        opp.recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
        Database.SaveResult lsropp = Database.insert(opp);

        Test.startTest();
        
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
            InsatsuNichiji__c = Datetime.valueOf('2020-06-30 20:04:00')              // 印刷日時
        );
        insert shiryo;
        
        shiryo.SofuJokyo__c = '送付済';
        update shiryo;
        
        Test.stopTest();
    }
}