@isTest
public class Tes_Case {
    //WebToCaseのテスト
    static testMethod void testCase1(){
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
        
        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;
        
        id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
        Account acc=new Account();
        acc.lastname='新規';
        acc.LastNameFurigana__pc ='defualt';
        acc.FirstNameFurigana__pc ='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        acc.recordtypeid=redtpId;
        insert acc;
        list<case> cases=new list<case>();        
       
        //ベスト仏壇
        id RecordTypeId1 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KakuyasuButsudan');
        //永代供養
        id RecordTypeId2 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','EtaikuyoShiryoseikyuWebForm');
        //墓ピタ
        id RecordTypeId3 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Hakapita');
        //事前割-Web申込
        id RecordTypeId4 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','JizenwariWebMoshikomi');
        //供花配達レビ
        id RecordTypeId5 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Kyouka');
        //宇宙葬
        id RecordTypeId6 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SpaceFuneral');
        //格安の墓石
        id RecordTypeId7 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KakuyasuBoseki');
        //海洋散骨
        id RecordTypeId8 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','KaiyoUmie');
        //生前契約
        id RecordTypeId9 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Seizenkeiyaku');
        //葬儀レビ
        id RecordTypeId10 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SougiRev');

        string prex='g';
        case c1=new case(accountid=acc.id,RecordTypeId=RecordTypeId1,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ1'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c2=new case(accountid=acc.id,RecordTypeId=RecordTypeId2,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ2'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c3=new case(accountid=acc.id,RecordTypeId=RecordTypeId3,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ3'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c4=new case(accountid=acc.id,RecordTypeId=RecordTypeId4,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ4'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com',Description='{ "address_state":"John","address_city":"John" }');      
        case c5=new case(accountid=acc.id,RecordTypeId=RecordTypeId5,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ5'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c6=new case(accountid=acc.id,RecordTypeId=RecordTypeId6,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ6'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c7=new case(accountid=acc.id,RecordTypeId=RecordTypeId7,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ7'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c8=new case(accountid=acc.id,RecordTypeId=RecordTypeId8,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ8'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c9=new case(accountid=acc.id,RecordTypeId=RecordTypeId9,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c10=new case(accountid=acc.id,RecordTypeId=RecordTypeId10,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ10'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');

        cases.add(c1);
        cases.add(c2);
        cases.add(c3);
        cases.add(c4);
        cases.add(c5);
        cases.add(c6);
        cases.add(c7);
        cases.add(c8);
        cases.add(c9);
        cases.add(c10);     
       
        Test.startTest();       
        insert cases;
        list<case> updCases=new list<case>();
        for (case c:cases){
            case updCase=new case();
            updCase.id=c.id;
            updCase.Firstname__c=c.Firstname__c+'update';
            updCases.add(updCase);
        }
        update updCases;
        Test.stopTest();
        
    }

    //WebToCaseのテスト
    static testMethod void testCase2(){
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;        
        id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
        Account acc=new Account();
        acc.lastname='新規';
        acc.LastNameFurigana__pc ='defualt';
        acc.FirstNameFurigana__pc ='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        acc.recordtypeid=redtpId;
        insert acc;
        list<case> cases=new list<case>();

        //シンプル安豪-資料請求Webフォーム
        id RecordTypeId11 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm');
        //シンプル安豪-お問い合わせWebフォーム
        id RecordTypeId12 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoEndingnoteWebForm');
        //シンプル安豪-エンディングノート請求Webフォーム
        id RecordTypeId13 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm');
        //お坊さん便-資料請求
        id RecordTypeId14 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinShiryoSeikyu');
        //お坊さん便-ネット予約
        id RecordTypeId15 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku');
        //お坊さん便-手配代行
        id RecordTypeId16 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinTehaidaikou');
        //お迎えフリー
        //id RecordTypeId17 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','OmukaeFree');
        //パートナー支援
        id RecordTypeId18 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','PS');
        //シンプル安豪-お問合せ
        id RecordTypeId19 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawase');
        //お坊さん便
        id RecordTypeId20 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Obosanbin');
                                
        string prex='g';
        case c11=new case(accountid=acc.id,RecordTypeId=RecordTypeId11,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ1'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c12=new case(accountid=acc.id,RecordTypeId=RecordTypeId12,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ2'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c13=new case(accountid=acc.id,RecordTypeId=RecordTypeId13,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ3'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c14=new case(accountid=acc.id,RecordTypeId=RecordTypeId14,HoyoKiboDate1__c=date.valueof('2017-01-01'),HoyoKiboTime1__c='21',HoyoKiboMinute1__c ='10',HoyoKiboDate2__c=date.valueof('2017-01-01'),HoyoKiboTime2__c='21',HoyoKiboMinute2__c ='10',HoyoKiboDate3__c=date.valueof('2017-01-01'),HoyoKiboTime3__c='21',HoyoKiboMinute3__c ='10',Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ4'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c15=new case(accountid=acc.id,RecordTypeId=RecordTypeId15,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ5'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c16=new case(accountid=acc.id,RecordTypeId=RecordTypeId16,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ6'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        //case c17=new case(accountid=acc.id,RecordTypeId=RecordTypeId17,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c18=new case(accountid=acc.id,RecordTypeId=RecordTypeId18,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ7'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c19=new case(accountid=acc.id,RecordTypeId=RecordTypeId19,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ8'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        case c20=new case(accountid=acc.id,RecordTypeId=RecordTypeId20,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
    
        cases.add(c11);
        cases.add(c12);
        cases.add(c13);
        cases.add(c14);
        cases.add(c15);
        cases.add(c16);
        //cases.add(c17);
        cases.add(c18);
        cases.add(c19);
        cases.add(c20);
        Test.startTest();       
        insert cases;
        list<case> updCases=new list<case>();
        for (case c:cases){
            case updCase=new case();
            updCase.id=c.id;
            updCase.Firstname__c=c.Firstname__c+'update';
            updCases.add(updCase);
        }
        update updCases;
        Test.stopTest();
        
    }   
    //WebToCaseのテスト
    static testMethod void testCase3(){
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;        
        id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
        Account acc=new Account();
        acc.lastname='新規';
        acc.LastNameFurigana__pc ='defualt';
        acc.FirstNameFurigana__pc ='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        acc.recordtypeid=redtpId;
        insert acc;
        list<case> cases=new list<case>();
        
        DataHakapita oDataHakapita = new DataHakapita();
        oDataHakapita.uniq_id='1';

        //墓ピタ
        id RecordTypeId21 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','HakapitaWebForm');
        string prex='g';
        case c21=new case(accountid=acc.id,description=json.serialize(oDataHakapita),RecordTypeId=RecordTypeId21,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        DataHokatsutoiawase oDataHokatsutoiawase = new DataHokatsutoiawase();
        oDataHokatsutoiawase.uniq_id='1';
        //墓ピタ
        id RecordTypeId22 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','HakapitaHokatsutoiawase');
        prex='g22';
        case c22=new case(accountid=acc.id,description=json.serialize(oDataHokatsutoiawase),RecordTypeId=RecordTypeId22,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');


        // 喪主代行
        //id RecordTypeId23 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','MosyuDaiko');
        // prex='g23';
        //case c23=new case(accountid=acc.id,RecordTypeId=RecordTypeId23,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');
        // お迎えフリー
        //id RecordTypeId24 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','OmukaeFree');
       // prex='g24';
        //case c24=new case(accountid=acc.id,RecordTypeId=RecordTypeId24,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');

        // 対面相談
       // id RecordTypeId25 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','TaimenSodan');
       // prex='g25';
       // case c25=new case(accountid=acc.id,RecordTypeId=RecordTypeId25,Firstname__c=prex+'Firstname' + prex,Lastname__c='Lastnametest9'+prex,FirstNameKana__c='ファストカナ9'+prex,LastNameKana__c='ラストカナ9'+prex,TelNo__c='080-3727-7779',KiboAreaState__c='東京都',KiboAreaCity__c='中央区',MailAddress__c='test@i.ss.com');

        cases.add(c21);
        cases.add(c22);
        //cases.add(c23);
        //cases.add(c24);
        //cases.add(c25);
        Test.startTest();       
        insert cases;
        list<case> updCases=new list<case>();
        for (case c:cases){
            case updCase=new case();
            updCase.id=c.id;
            updCase.Firstname__c=c.Firstname__c+'update';
            updCases.add(updCase);
        }
        update updCases;
        Test.stopTest();
        
    } 
    static testMethod void testCase4(){
        
        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;
        
        id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
        Account acc=new Account();
        acc.lastname='新規';
        acc.LastNameFurigana__pc ='defualt';
        acc.FirstNameFurigana__pc ='defualt';
        acc.Phone='080-0000-0001';
        acc.MobilePhone__c='080-0000-0001';
        acc.recordtypeid=redtpId;
        insert acc;
        
        Case newCase = new Case();
        newCase.RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','Mail');
        newCase.Status = '新規';
        newCase.accountid=acc.id;        
        insert newCase;
        
        Test.startTest();
        newCase.Status = '対応中';
        update newCase;

        Case resultCase = [SELECT ID,OwnerId,LastModifiedById FROM Case WHERE Id = :newCase.Id];

        System.assertEquals(resultCase.LastModifiedById, resultCase.OwnerId);

        List<User> sinsoshikiUserList = [SELECT Id FROM User Where Username like 'system-admin@minrevi.jp%'];
        if(sinsoshikiUserList.size() > 0){
            newCase.Status = '新規';
            update newCase;
        
            Case resultCase2 = [SELECT ID,OwnerId,LastModifiedById FROM Case WHERE Id = :newCase.Id];

            System.assertEquals(sinsoshikiUserList.get(0).Id, resultCase2.OwnerId);
        }
        
        Test.stopTest();
    }      
    // //MailToCaseのテスト
    // static testMethod void testCase4(){
    //     TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
    //     TriggerIsActive.name='default';
    //     TriggerIsActive.isActive__c=true;
    //     insert TriggerIsActive;
        
    //     JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
    //     JizenWariPlan.Code__c='Yoriso';
    //     insert JizenWariPlan;        
        
    //     id redtpId=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'); 
    //     Account acc=new Account();
    //     acc.lastname='新規';
    //     acc.LastNameFurigana__pc ='defualt';
    //     acc.FirstNameFurigana__pc ='defualt';
    //     acc.Phone='080-0000-0001';
    //     acc.MobilePhone__c='080-0000-0001';
    //     acc.recordtypeid=redtpId;
    //     insert acc;
        
    //     // First, set up test price book entries.
    //     // Insert a test product.
    //     Product2 prod = new Product2(Name = 'ベスト仏壇', 
    //         Family = 'Hardware');
    //     insert prod;
        
        
    //     Pricebook2 standardPricebook = new Pricebook2(
    //         Id = Test.getStandardPricebookId(),
    //         IsActive = true
    //     );
    //     update standardPricebook;
        
    //     standardPricebook = [SELECT IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
    //     system.debug('***standardPricebook='+standardPricebook);
        
    //     // Get standard price book ID.
    //     // This is available irrespective of the state of SeeAllData.
    //     Id pricebookId = Test.getStandardPricebookId();
        
    //     // 1. Insert a price book entry for the standard price book.
    //     // Standard price book entries require the standard price book ID we got earlier.
    //     PricebookEntry standardPrice = new PricebookEntry(
    //         Pricebook2Id = pricebookId, Product2Id = prod.Id,
    //         UnitPrice = 10000, IsActive = true);
    //     insert standardPrice;
        
    //     // Create a custom price book
    //     Pricebook2 customPB = new Pricebook2(Name='CS', isActive=true);
    //     insert customPB;
        
    //     // 2. Insert a price book entry with a custom price.
    //     PricebookEntry customPrice = new PricebookEntry(
    //         Pricebook2Id = customPB.Id, Product2Id = prod.Id,
    //         UnitPrice = 12000, IsActive = true);
    //     insert customPrice;
        
    //     list<case> cases=new list<case>();
    //     // サービス特定用レコードID定義取得
        
    //     //ベスト仏壇
    //     id RecordTypeId1 = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','BestButsudanOtoiawase');
    //     string MailTitle='【株式会社みんれび(ベスト仏壇)】 注文番号786： ご注文を承りました';
    //     string MailBody='テスト 龍一　様\n';
    //     MailBody=MailBody+'テラサカ リュウイチ　様\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'ありがとうございます。\n';
    //     MailBody=MailBody+'お振込みは下記のとおりになります。\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'【決済情報】\n';
    //     MailBody=MailBody+'■ 銀行振込 (お振込み先 : 三菱東京UFJ銀行　高田馬場支店　普通口座0055680 株式会社みんれび)\n';
    //     MailBody=MailBody+'【ベスト仏壇の商品をご注文で、銀行振込(後払い)を選択された方へ】\n';
    //     MailBody=MailBody+'※ご注文日より5営業日以内に必ずお振込みください。\n';
    //     MailBody=MailBody+'※銀行振込でご注文の方は、本メール記載のご注文番号を必ずご記入ください。\n';
    //     MailBody=MailBody+'例:1234 ミンレビタロウ\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'※領収書または請求書の発行が必要な場合は、【運営母体】株式会社みんれび宛にご連絡をお願いいたします。\n';
    //     MailBody=MailBody+'また以下の通りご注文を承りました。\n';
    //     MailBody=MailBody+'※ただいまから在庫を確認いたします。万が一在庫が確認できない場合は、お電話にてご連絡いたします。\n';
    //     MailBody=MailBody+'ご了承くださいませ。\n';
    //     MailBody=MailBody+'※ご注文後の返品またはキャンセルに関しまして\n';
    //     MailBody=MailBody+'一切お受けできませんので、予めご了承ください。\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'注文情報\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'ご注文番号 ： 786\n';
    //     MailBody=MailBody+'ご注文ステータス ： 注文受付\n';
    //     MailBody=MailBody+'ご注文日時 ： 2017/06/05 14:11\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'お買い上げ商品\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'1. モダン仏壇・ゾスト (BDM-1241450-10001)\n';
    //     MailBody=MailBody+'オプション - サイズ : 16号, カラー : 紫檀調, 仏具セット : 付けない, 宗派 : 浄土宗\n';
    //     MailBody=MailBody+'1 × 60,800円 = 60,800円\n';
    //     MailBody=MailBody+'http://butudan-ec-dev.minrevi.jp/butsudan/modan/butudan-zosuto/\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'小計 : 12,400円\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'総額 : 12,400円\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'お届け先\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'お客様名 : テスト 龍一様\n';
    //     MailBody=MailBody+'郵便番号 : 169-0075\n';
    //     MailBody=MailBody+'住所 : 東京都新宿区高田馬場 4-40-12\n';
    //     MailBody=MailBody+'電話番号 : 353486051\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'支払方法・ご住所\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'支払方法 : 銀行振込\n';
    //     MailBody=MailBody+'お客様名 : テスト 龍一様\n';
    //     MailBody=MailBody+'郵便番号 : 169-0075\n';
    //     MailBody=MailBody+'住所 : 東京都新宿区高田馬場 4-40-12\n';
    //     MailBody=MailBody+'電話番号 : 353486051\n';
    //     MailBody=MailBody+'\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'コメント\n';
    //     MailBody=MailBody+'----------------------------------------\n';
    //     MailBody=MailBody+'\n';

    //     case c1=new case(accountid=acc.id,RecordTypeId=RecordTypeId1,subject=MailTitle,description=MailBody,Origin='メール');
    //     cases.add(c1);

    //     Test.startTest();       
    //     insert cases;

    //     Test.stopTest();
        
    // }
     private class DataHakapita{
    	//メール処理Id
        public String uniq_id { get;  set; }
        //問合せ日
        public String req_day { get;  set; }
        //入口
        public String entrance	{ get;  set; }
        //管理画面URL
        public String manage_screen_url	{ get;  set; } 
        //最終見学日
        public String last_tour_day	{ get;  set; } 
        //申込者姓
        public String last_name	{ get;  set; } 
        //申込者名
        public String first_name	{ get;  set; } 
        //申込者姓(カナ)
        public String last_name_kana	{ get;  set; } 
        //申込者名(カナ)
        public String first_name_kana	{ get;  set; } 
        //申込者電話番号
        public String mobile	{ get;  set; } 
        //申込者メールアドレス
        public String email	{ get;  set; } 
        //申込者住所.郵便番号
        public String address_zip_code	{ get;  set; } 
        //申込者住所.都道府県
        public String address_state	{ get;  set; }  
        //申込者住所.市区郡      
        public String address_city	{ get;  set; } 
        //申込者住所.町名番地
        public String address_street	{ get;  set; } 
        //資料請求_依頼先霊園01
        public String siryoseikyu_requestcemetery01	{ get;  set; } 
        //資料請求_依頼先霊園02
        public String siryoseikyu_requestcemetery02	{ get;  set; } 
        //資料請求_依頼先霊園03
        public String siryoseikyu_requestcemetery03	{ get;  set; } 
        //資料請求_依頼先霊園04
        public String siryoseikyu_requestcemetery04	{ get;  set; } 
        //資料請求_依頼先霊園05
        public String siryoseikyu_requestcemetery05	{ get;  set; } 
        //資料請求_依頼先霊園06
        public String siryoseikyu_requestcemetery06	{ get;  set; } 
        //資料請求_依頼先霊園07
        public String siryoseikyu_requestcemetery07	{ get;  set; } 
        //資料請求_依頼先霊園08
        public String siryoseikyu_requestcemetery08	{ get;  set; } 
        //資料請求_依頼先霊園09
        public String siryoseikyu_requestcemetery09	{ get;  set; } 
        //資料請求_依頼先霊園10
        public String siryoseikyu_requestcemetery10	{ get;  set; } 
        //資料請求_依頼先霊園11
        public String siryoseikyu_requestcemetery11	{ get;  set; }
        //資料請求_依頼先霊園12 
        public String siryoseikyu_requestcemetery12	{ get;  set; } 
        //資料請求_依頼先霊園13
        public String siryoseikyu_requestcemetery13	{ get;  set; } 
        //資料請求_依頼先霊園14
        public String siryoseikyu_requestcemetery14	{ get;  set; } 
        //資料請求_依頼先霊園15
        public String siryoseikyu_requestcemetery15	{ get;  set; } 
        //資料請求_依頼先霊園16
        public String siryoseikyu_requestcemetery16	{ get;  set; } 
        //資料請求_依頼先霊園17
        public String siryoseikyu_requestcemetery17	{ get;  set; } 
        //資料請求_依頼先霊園18
        public String siryoseikyu_requestcemetery18	{ get;  set; }    
        //資料請求_依頼先霊園19    
        public String siryoseikyu_requestcemetery19	{ get;  set; } 
        //資料請求_依頼先霊園20
        public String siryoseikyu_requestcemetery20	{ get;  set; } 
        //資料請求_依頼先霊園21
        public String siryoseikyu_requestcemetery21	{ get;  set; } 
        //資料請求_依頼先霊園22        
        public String siryoseikyu_requestcemetery22	{ get;  set; } 
        //資料請求_依頼先霊園23
        public String siryoseikyu_requestcemetery23	{ get;  set; } 
        //資料請求_依頼先霊園24
        public String siryoseikyu_requestcemetery24	{ get;  set; } 
        //資料請求_依頼先霊園25
        public String siryoseikyu_requestcemetery25	{ get;  set; } 
        //資料請求_依頼先霊園26
        public String siryoseikyu_requestcemetery26	{ get;  set; } 
        //資料請求_依頼先霊園27
        public String siryoseikyu_requestcemetery27	{ get;  set; } 
        //資料請求_依頼先霊園28
        public String siryoseikyu_requestcemetery28	{ get;  set; }
        //資料請求_依頼先霊園29
        public String siryoseikyu_requestcemetery29	{ get;  set; }
        //資料請求_依頼先霊園30
        public String siryoseikyu_requestcemetery30	{ get;  set; } 
        //資料請求_対応石材店01
        public String siryoseikyu_requestStoneShop01	{ get;  set; } 
        //資料請求_対応石材店02
        public String siryoseikyu_requestStoneShop02	{ get;  set; } 
        //資料請求_対応石材店03
        public String siryoseikyu_requestStoneShop03	{ get;  set; } 
        //資料請求_対応石材店04
        public String siryoseikyu_requestStoneShop04	{ get;  set; } 
        //資料請求_対応石材店05
        public String siryoseikyu_requestStoneShop05	{ get;  set; } 
        //資料請求_対応石材店06
        public String siryoseikyu_requestStoneShop06	{ get;  set; } 
        //資料請求_対応石材店07
        public String siryoseikyu_requestStoneShop07	{ get;  set; } 
        //資料請求_対応石材店08
        public String siryoseikyu_requestStoneShop08	{ get;  set; } 
        //資料請求_対応石材店09
        public String siryoseikyu_requestStoneShop09	{ get;  set; }    
        //資料請求_対応石材店10  
        public String siryoseikyu_requestStoneShop10	{ get;  set; } 
        //資料請求_対応石材店11
        public String siryoseikyu_requestStoneShop11	{ get;  set; } 
        //資料請求_対応石材店12
        public String siryoseikyu_requestStoneShop12	{ get;  set; } 
        //資料請求_対応石材店13
        public String siryoseikyu_requestStoneShop13	{ get;  set; } 
        //資料請求_対応石材店14
        public String siryoseikyu_requestStoneShop14	{ get;  set; } 
        //資料請求_対応石材店15
        public String siryoseikyu_requestStoneShop15	{ get;  set; } 
        //資料請求_対応石材店16
        public String siryoseikyu_requestStoneShop16	{ get;  set; } 
        //資料請求_対応石材店17
        public String siryoseikyu_requestStoneShop17	{ get;  set; } 
        //資料請求_対応石材店18
        public String siryoseikyu_requestStoneShop18	{ get;  set; } 
        //資料請求_対応石材店19
        public String siryoseikyu_requestStoneShop19	{ get;  set; } 
        //資料請求_対応石材店20
        public String siryoseikyu_requestStoneShop20	{ get;  set; } 
        //資料請求_対応石材店21
        public String siryoseikyu_requestStoneShop21	{ get;  set; } 
        //資料請求_対応石材店22
        public String siryoseikyu_requestStoneShop22	{ get;  set; } 
        //資料請求_対応石材店23
        public String siryoseikyu_requestStoneShop23	{ get;  set; } 
        //資料請求_対応石材店24
        public String siryoseikyu_requestStoneShop24	{ get;  set; } 
        //資料請求_対応石材店25
        public String siryoseikyu_requestStoneShop25	{ get;  set; } 
        //資料請求_対応石材店26
        public String siryoseikyu_requestStoneShop26	{ get;  set; } 
        //資料請求_対応石材店27
        public String siryoseikyu_requestStoneShop27	{ get;  set; } 
        //資料請求_対応石材店28
        public String siryoseikyu_requestStoneShop28	{ get;  set; } 
        //資料請求_対応石材店29
        public String siryoseikyu_requestStoneShop29	{ get;  set; }  
        //資料請求_対応石材店30      
        public String siryoseikyu_requestStoneShop30	{ get;  set; } 
        //見学申込_依頼先霊園01
        public String tour_requestcemetery01	{ get;  set; } 
        //見学申込_依頼先霊園02
        public String tour_requestcemetery02	{ get;  set; } 
        //見学申込_依頼先霊園03
        public String tour_requestcemetery03	{ get;  set; } 
        //見学申込_依頼先霊園04
        public String tour_requestcemetery04	{ get;  set; } 
        //見学申込_依頼先霊園05
        public String tour_requestcemetery05	{ get;  set; } 
        //見学申込_依頼先霊園06
        public String tour_requestcemetery06	{ get;  set; } 
        //見学申込_依頼先霊園07
        public String tour_requestcemetery07	{ get;  set; } 
        //見学申込_依頼先霊園08
        public String tour_requestcemetery08	{ get;  set; } 
        //見学申込_依頼先霊園09
        public String tour_requestcemetery09	{ get;  set; } 
        //見学申込_依頼先霊園10
        public String tour_requestcemetery10	{ get;  set; }
        //見学申込_依頼先霊園11
        public String tour_requestcemetery11	{ get;  set; } 
        //見学申込_依頼先霊園12
        public String tour_requestcemetery12	{ get;  set; } 
        //見学申込_依頼先霊園13
        public String tour_requestcemetery13	{ get;  set; } 
        //見学申込_依頼先霊園14
        public String tour_requestcemetery14	{ get;  set; } 
        //見学申込_依頼先霊園15
        public String tour_requestcemetery15	{ get;  set; } 
        //見学申込_依頼先霊園16
        public String tour_requestcemetery16	{ get;  set; } 
        //見学申込_依頼先霊園17
        public String tour_requestcemetery17	{ get;  set; } 
        //見学申込_依頼先霊園18
        public String tour_requestcemetery18	{ get;  set; } 
        //見学申込_依頼先霊園19
        public String tour_requestcemetery19	{ get;  set; } 
        //見学申込_依頼先霊園20
        public String tour_requestcemetery20	{ get;  set; }  
        //見学申込_対応石材店01      
        public String tour_requestStoneShop01	{ get;  set; } 
        //見学申込_対応石材店02
        public String tour_requestStoneShop02	{ get;  set; } 
        //見学申込_対応石材店03
        public String tour_requestStoneShop03	{ get;  set; } 
        //見学申込_対応石材店04
        public String tour_requestStoneShop04	{ get;  set; } 
        //見学申込_対応石材店05
        public String tour_requestStoneShop05	{ get;  set; } 
        //見学申込_対応石材店06
        public String tour_requestStoneShop06	{ get;  set; } 
        //見学申込_対応石材店07
        public String tour_requestStoneShop07	{ get;  set; } 
        //見学申込_対応石材店08
        public String tour_requestStoneShop08	{ get;  set; } 
        //見学申込_対応石材店09
        public String tour_requestStoneShop09	{ get;  set; } 
        //見学申込_対応石材店10
        public String tour_requestStoneShop10	{ get;  set; } 
        //見学申込_対応石材店11
        public String tour_requestStoneShop11	{ get;  set; } 
        //見学申込_対応石材店12
        public String tour_requestStoneShop12	{ get;  set; } 
        //見学申込_対応石材店13
        public String tour_requestStoneShop13	{ get;  set; } 
        //見学申込_対応石材店14
        public String tour_requestStoneShop14	{ get;  set; } 
        //見学申込_対応石材店15
        public String tour_requestStoneShop15	{ get;  set; } 
        //見学申込_対応石材店16
        public String tour_requestStoneShop16	{ get;  set; } 
        //見学申込_対応石材店17
        public String tour_requestStoneShop17	{ get;  set; } 
        //見学申込_対応石材店18
        public String tour_requestStoneShop18	{ get;  set; } 
        //見学申込_対応石材店19
        public String tour_requestStoneShop19	{ get;  set; } 
        //見学申込_対応石材店20
        public String tour_requestStoneShop20	{ get;  set; }                                     
    }  
    private class DataHokatsutoiawase{
    	//メール処理Id
        public String uniq_id { get;  set; }
        //問合せ日
        public String req_day { get;  set; }
        //入口
        public String entrance	{ get;  set; }
        //お墓の種類
        public String GraveType	{ get;  set; }
        //ご遺骨の場所
        public String LocationOfRemains	{ get;  set; }
        //宗旨・宗派
        public String Religion	{ get;  set; }
        //こだわり条件
        public String AttentionCondition	{ get;  set; }
        //ご予算
        public String Budget	{ get;  set; }
        //備考
        public String Remarks	{ get;  set; }
        //お墓を建てる場所
        public String BuildGraveArea	{ get;  set; }
        //申込者姓
        public String last_name	{ get;  set; } 
        //申込者名
        public String first_name	{ get;  set; } 
        //申込者姓(カナ)
        public String last_name_kana	{ get;  set; } 
        //申込者名(カナ)
        public String first_name_kana	{ get;  set; } 
        //申込者電話番号
        public String mobile	{ get;  set; } 
        //申込者メールアドレス
        public String email	{ get;  set; } 
        //申込者住所.郵便番号
        public String address_zip_code	{ get;  set; } 
        //申込者住所.都道府県
        public String address_state	{ get;  set; }  
        //申込者住所.市区郡      
        public String address_city	{ get;  set; } 
        //申込者住所.町名番地
        public String address_street	{ get;  set; } 
        //資料請求_依頼先霊園01
        public String siryoseikyu_requestcemetery01	{ get;  set; } 
        //資料請求_依頼先霊園02
        public String siryoseikyu_requestcemetery02	{ get;  set; } 
        //資料請求_依頼先霊園03
        public String siryoseikyu_requestcemetery03	{ get;  set; } 
        //資料請求_依頼先霊園04
        public String siryoseikyu_requestcemetery04	{ get;  set; } 
        //資料請求_依頼先霊園05
        public String siryoseikyu_requestcemetery05	{ get;  set; } 
        //資料請求_依頼先霊園06
        public String siryoseikyu_requestcemetery06	{ get;  set; } 
        //資料請求_依頼先霊園07
        public String siryoseikyu_requestcemetery07	{ get;  set; } 
        //資料請求_依頼先霊園08
        public String siryoseikyu_requestcemetery08	{ get;  set; } 
        //資料請求_依頼先霊園09
        public String siryoseikyu_requestcemetery09	{ get;  set; } 
        //資料請求_依頼先霊園10
        public String siryoseikyu_requestcemetery10	{ get;  set; } 
        //資料請求_依頼先霊園11
        public String siryoseikyu_requestcemetery11	{ get;  set; }
        //資料請求_依頼先霊園12 
        public String siryoseikyu_requestcemetery12	{ get;  set; } 
        //資料請求_依頼先霊園13
        public String siryoseikyu_requestcemetery13	{ get;  set; } 
        //資料請求_依頼先霊園14
        public String siryoseikyu_requestcemetery14	{ get;  set; } 
        //資料請求_依頼先霊園15
        public String siryoseikyu_requestcemetery15	{ get;  set; } 
        //資料請求_依頼先霊園16
        public String siryoseikyu_requestcemetery16	{ get;  set; } 
        //資料請求_依頼先霊園17
        public String siryoseikyu_requestcemetery17	{ get;  set; } 
        //資料請求_依頼先霊園18
        public String siryoseikyu_requestcemetery18	{ get;  set; }    
        //資料請求_依頼先霊園19    
        public String siryoseikyu_requestcemetery19	{ get;  set; } 
        //資料請求_依頼先霊園20
        public String siryoseikyu_requestcemetery20	{ get;  set; }       
        //資料請求_対応石材店01
        public String siryoseikyu_requestStoneShop01	{ get;  set; } 
        //資料請求_対応石材店02
        public String siryoseikyu_requestStoneShop02	{ get;  set; } 
        //資料請求_対応石材店03
        public String siryoseikyu_requestStoneShop03	{ get;  set; } 
        //資料請求_対応石材店04
        public String siryoseikyu_requestStoneShop04	{ get;  set; } 
        //資料請求_対応石材店05
        public String siryoseikyu_requestStoneShop05	{ get;  set; } 
        //資料請求_対応石材店06
        public String siryoseikyu_requestStoneShop06	{ get;  set; } 
        //資料請求_対応石材店07
        public String siryoseikyu_requestStoneShop07	{ get;  set; } 
        //資料請求_対応石材店08
        public String siryoseikyu_requestStoneShop08	{ get;  set; } 
        //資料請求_対応石材店09
        public String siryoseikyu_requestStoneShop09	{ get;  set; }    
        //資料請求_対応石材店10  
        public String siryoseikyu_requestStoneShop10	{ get;  set; } 
        //資料請求_対応石材店11
        public String siryoseikyu_requestStoneShop11	{ get;  set; } 
        //資料請求_対応石材店12
        public String siryoseikyu_requestStoneShop12	{ get;  set; } 
        //資料請求_対応石材店13
        public String siryoseikyu_requestStoneShop13	{ get;  set; } 
        //資料請求_対応石材店14
        public String siryoseikyu_requestStoneShop14	{ get;  set; } 
        //資料請求_対応石材店15
        public String siryoseikyu_requestStoneShop15	{ get;  set; } 
        //資料請求_対応石材店16
        public String siryoseikyu_requestStoneShop16	{ get;  set; } 
        //資料請求_対応石材店17
        public String siryoseikyu_requestStoneShop17	{ get;  set; } 
        //資料請求_対応石材店18
        public String siryoseikyu_requestStoneShop18	{ get;  set; } 
        //資料請求_対応石材店19
        public String siryoseikyu_requestStoneShop19	{ get;  set; } 
        //資料請求_対応石材店20
        public String siryoseikyu_requestStoneShop20	{ get;  set; }                                      
    }   
}