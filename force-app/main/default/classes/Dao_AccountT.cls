@isTest
public class Dao_AccountT {

	@isTest
	static void Test(){

		Account acc = new Account(
				RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(),
				FirstName = '相談者', LastName = '_',
				MemberTourokuZumi__c = true,
				JizenJizenSheetTeishutsuzumi__c = true
				);
		Database.SaveResult lsracc = Database.insert(acc);

		List<String> phoneNumerNoHyphenList = new List<String>();
		phoneNumerNoHyphenList.add('09000000000');
		Set<Id> whereParams = new Set<Id>();
		whereParams.add(lsracc.getId());
		List<Id> pIds = new List<Id>();
		pIds.add(lsracc.getId());
		String strWhereParam = ' Where Id = \'' + lsracc.getId() + '\' ';
		String strOrderByParam = ' Order By Name';
		Account accSelect = [Select 
								Id, 
								TorihikisakiBango__c
							From Account
							Where Id = :lsracc.getId()];

		List<Account> ListgetAccountListByPhoneNumber = Dao_Account.getAccountListByPhoneNumber(strWhereParam,phoneNumerNoHyphenList,strOrderByParam);
		List<Account> ListSearchAccount = Dao_Account.SearchAccount(strWhereParam,whereParams,strOrderByParam);
		List<Account> ListSelectByRecordTypeDevName = Dao_Account.getInstance().SelectByRecordTypeDevName('Customer');
		Account SselectByTorihikisakiBango = Dao_Account.getInstance().selectByTorihikisakiBango(accSelect.TorihikisakiBango__c);
		Account SselectById = Dao_Account.getInstance().selectById(lsracc.getId());
		List<Account> ListselectByIds = Dao_Account.getInstance().selectByIds(pIds);
		List<Account> ListgetAccountContactListByAccountId = Dao_Account.getAccountContactListByAccountId(pIds);
		Map<ID, Account> MapgetAccountContactKeiyakuMapByAccountSet = Dao_Account.getAccountContactKeiyakuMapByAccountSet(whereParams);
		Map<ID, Account> MapgetAccountContactMapByAccountSet = Dao_Account.getAccountContactMapByAccountSet(whereParams);
		List<Account> ListgetAccountKeiyakuListByAccountId = Dao_Account.getAccountKeiyakuListByAccountId(whereParams);
		
	}
}