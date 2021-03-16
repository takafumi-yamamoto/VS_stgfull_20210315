@isTest
public class WaribikiSummaryT {

	private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	@isTest
	static void test_method_one() {
		
		beginSetUp();
		endSetUp();
		
		Account aDefo = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(), FirstName = '_', LastName = '_');
        Account a1 = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '相談者', LastName = '_',
                			MemberTourokuZumi__c = true,
                			JizenJizenSheetTeishutsuzumi__c = true
            			);
        Account a2 = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '対象者', LastName = '_',
                			MemberTourokuZumi__c = true
            			);
        Account aSogi = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Default'),
                			Name = '葬儀社'
            			);

        List<Account> aList = new List<Account>();
        aList.add(aDefo);
        aList.add(a1);
        aList.add(a2);
        aList.add(aSogi);
		insert aList;

		Keiyaku__c k = new Keiyaku__c(
							RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Alliance').getRecordTypeId(),
							Teikeisaki__c = aSogi.Id,
							NyukinSimekiriJouken__c = 'DUMMY',
							Keiyakukaishibi__c = system.today(),
							KeiyakuJokyo__c = '契約中'
						);
		insert k;

		Case c = new Case(AccountId = aDefo.id,
							Status = '対応中',
							RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawaseWebForm').getRecordTypeId()
							);
		insert c;
        
        Opportunity sltO = [select Id, SimpleYasugoRef__c,AccountId from Opportunity where CaseRef__c = :c.Id];

        Id oppId = sltO.Id;
        Id simpleId = sltO.SimpleYasugoRef__c;
        Opportunity o = new Opportunity(
        								Id = oppId,
        								AccountId = a1.Id,
        								SurveyDiscountAgreeStatus__c = '同意済',
        								AllianceRef__c = k.Id
        	);
        update o;

        SimpleYasugo__c s = new SimpleYasugo__c(
        								Id = simpleId,
        								TaishoshaRef__c = a2.Id);
        update s;

        WaribikiSummary.getDataContext(o.Id);
        WaribikiSummary.WaribikiSummaryEntry Entry = new WaribikiSummary.WaribikiSummaryEntry();
        Entry.name = 'a';
        String StrName = Entry.name;
        Entry.descr = 'a';
        String Strdescr = Entry.descr;
        Entry.refId = 'a';
        String StrrefId = Entry.refId;
        Entry.refNo = 'a';
        String StrrefNo = Entry.refNo;
        

	}
	@isTest
	static void test_method_two() {
		
		beginSetUp();
		endSetUp();
		
		Account aDefo = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(), FirstName = '_', LastName = '_');
        Account a1 = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '相談者', LastName = '_',
                			MemberTourokuZumi__c = true,
                			JizenJizenSheetTeishutsuzumi__c = true
            			);
        Account a2 = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '対象者', LastName = '_',
                			MemberTourokuZumi__c = true
            			);
        Account aSogi = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Default'),
                			Name = '葬儀社'
            			);

        List<Account> aList = new List<Account>();
        aList.add(aDefo);
        aList.add(a1);
        aList.add(a2);
        aList.add(aSogi);
		insert aList;

		Keiyaku__c k = new Keiyaku__c(
							RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Alliance').getRecordTypeId(),
							Teikeisaki__c = aSogi.Id,
							NyukinSimekiriJouken__c = 'DUMMY',
							Keiyakukaishibi__c = system.today(),
							KeiyakuJokyo__c = '契約中'
						);
		insert k;

		Case c = new Case(AccountId = aDefo.id,
							RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawaseWebForm').getRecordTypeId()
							);
		insert c;
        
        Opportunity sltO = [select Id, SimpleYasugoRef__c,AccountId from Opportunity where CaseRef__c = :c.Id];

        Id oppId = sltO.Id;
        Id simpleId = sltO.SimpleYasugoRef__c;
        Opportunity o = new Opportunity(
        								Id = oppId,
        								AccountId = a1.Id,
        								SurveyDiscountAgreeStatus__c = '同意済',
        								AllianceRef__c = k.Id
        	);
        update o;

        SimpleYasugo__c s = new SimpleYasugo__c(
        								Id = simpleId,
        								TaishoshaRef__c = a2.Id);
        update s;
        WaribikiSummary.DataCtxProvider Provider = new WaribikiSummary.DataCtxProvider();
        Provider.KaiinSwitchingControlFlg = false;
        Provider.getDataCtx(o.Id);

	}
	@isTest
	static void test_method_three() {
		
		beginSetUp();
		endSetUp();
		
		Account aDefo = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(), FirstName = '_', LastName = '_');
        Account a1 = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '相談者', LastName = '_',
                			MemberTourokuZumi__c = true,
                			JizenJizenSheetTeishutsuzumi__c = true
            			);
        Account a2 = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                			FirstName = '対象者', LastName = '_',
                			MemberTourokuZumi__c = true
            			);
        Account aSogi = new Account(
        			        RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Default'),
                			Name = '葬儀社'
            			);

        List<Account> aList = new List<Account>();
        aList.add(aDefo);
        aList.add(a1);
        aList.add(a2);
        aList.add(aSogi);
		insert aList;

		Keiyaku__c k = new Keiyaku__c(
							RecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('Alliance').getRecordTypeId(),
							Teikeisaki__c = aSogi.Id,
							NyukinSimekiriJouken__c = 'DUMMY',
							Keiyakukaishibi__c = system.today(),
							KeiyakuJokyo__c = '契約中'
						);
		insert k;

		Case c = new Case(AccountId = aDefo.id,
							RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawaseWebForm').getRecordTypeId()
							);
		insert c;
        
        Opportunity sltO = [select Id, SimpleYasugoRef__c,AccountId from Opportunity where CaseRef__c = :c.Id];

        Id oppId = sltO.Id;
        Id simpleId = sltO.SimpleYasugoRef__c;
        Opportunity o = new Opportunity(
        								Id = oppId,
        								AccountId = a1.Id,
        								SurveyDiscountAgreeStatus__c = '同意済',
        								AllianceRef__c = k.Id
        	);
        update o;

        SimpleYasugo__c s = new SimpleYasugo__c(
        								Id = simpleId,
        								TaishoshaRef__c = a2.Id);
        update s;
        WaribikiSummary.DataCtxProvider Provider = new WaribikiSummary.DataCtxProvider();
        Provider.KaiinSwitchingControlFlg = true;
        Provider.getDataCtx(o.Id);

	}
}