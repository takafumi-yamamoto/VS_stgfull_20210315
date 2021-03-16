@isTest
public class ObosanbinOppKakuteibiSetT {

    static testMethod void testMethod1() {

        TriggerIsActive__c TriggerIsActive=new TriggerIsActive__c();
        TriggerIsActive.name='default';
        TriggerIsActive.isActive__c=true;
        insert TriggerIsActive;

        JizenWariPlan__c JizenWariPlan=new JizenWariPlan__c();
        JizenWariPlan.Code__c='Yoriso';
        insert JizenWariPlan;

        Account acc = new Account(RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
                                lastname='新規');
        insert acc;

        //お坊さん便-資料請求
        case c = new case(RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('ObousanbinShiryoSeikyu').getRecordTypeId(),
                            Firstname__c='Firstname',
                            Lastname__c='Lastnametest',
                            FirstNameKana__c='ファストカナ',
                            LastNameKana__c='ラストカナ',
                            TelNo__c='080-3727-7779',
                            KiboAreaState__c='東京都',
                            KiboAreaCity__c='中央区',
                            MailAddress__c='test@i.ss.com');
        insert c;


        Account soryo = new Account(Name = 'Account',
                                BillingState = '東京都',
                                Syushi__c = '仏教',
                                Syuha__c = '真言宗',
                                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId());
        insert soryo;

        Keiyaku__c keiyaku = new Keiyaku__c(Teikeisaki__c = soryo.Id,
                                            HomutaiokanoArea__c = '北海道',
                                            RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId());
        insert keiyaku;

        Opportunity opp = [SELECT Id, ObosanbinRef__c, StageName, KakuteibiSyodan__c, Utiagebi__c, Iriguchi__c FROM Opportunity WHERE CaseRef__c = :c.Id];

        Obosanbin__c obosanbin = new Obosanbin__c(
            Id=opp.ObosanbinRef__c,
            ObosanbinKeiyakuMadoguchi__c = keiyaku.Id,
            MemorialServicePlan__c = '四十九日法要', 
            KokubetsuDateTime_Inp__c = Datetime.now()
        );
        update obosanbin;

        opp.Iriguchi__c = '_';
        update opp;

        Map<String, Product2> theProds = new Map<String, Product2>{
            '1' => new Product2(
                Name = '_',
                IsActive = true
            )
        };
        Insert theProds.values();

        Map<String, PricebookEntry> theProdEntries = new Map<String, PricebookEntry>{
            '1' => new PricebookEntry(
                Pricebook2Id = Test.getStandardPricebookId(),
                Product2Id = theProds.get('1').Id,
                UnitPrice = 1000,
                IsActive = true
            )
        };
        Insert theProdEntries.values();

            Map<String, OpportunityLineItem> theOppItems = new Map<String, OpportunityLineItem>{
            '1' => new OpportunityLineItem(
                OpportunityId = opp.Id,
                Product2Id = theProds.get('1').Id,
                TotalPrice = 1000
            )
        };

        Insert theOppItems.values();

        Test.startTest();

        opp.StageName = '施行待ち';
        update opp;

        opp.StageName = '除外';
        update opp;

        Test.stopTest();

        
    }
}