@isTest
public class ObosanbinOppUriagebiSetT {

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

        Opportunity opp = [SELECT Id, ObosanbinRef__c, StageName, KakuteibiSyodan__c, Utiagebi__c FROM Opportunity WHERE CaseRef__c = :c.Id];
        
        Obosanbin__c obosanbin = new Obosanbin__c(Id=opp.ObosanbinRef__c,
                                                    MemorialServicePlan__c='火葬式',
                                                    IraiTehaiDate__c=system.today(),
                                                    KasoDateTime_Inp__c=system.now(),
                                                    KokubetsuDateTime_Inp__c=system.now(),
                                                    KokubetsushikiNichiji__c=system.now(),
                                                    ObosanbinKeiyakuMadoguchi__c = keiyaku.Id);

        Test.startTest();

        update obosanbin;

        Test.stopTest();
    }
}