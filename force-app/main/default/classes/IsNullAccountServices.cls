public class IsNullAccountServices {

	private static IIsNullAccountService f_IsNullAccountService;

	public static IIsNullAccountService GetInstance(){
		if(f_IsNullAccountService == null){
			f_IsNullAccountService = new IsNullAccountService(
				new Dao_Account(RecordTypeCachedDaos.getInstance())
				);
		}
		return f_IsNullAccountService;
	}

	public interface IIsNullAccountService{
		Boolean isNullOrNullObj(Id pAccountId);
	}

	public class IsNullAccountService implements IIsNullAccountService{

		private Dao_Account f_Dao_Account;
		private Map<Id, Account> f_NullAccountMap = new Map<Id, Account>();
		private Boolean f_IsLoaded = false;

		public IsNullAccountService(Dao_Account pDao_Account){
			this.f_Dao_Account = pDao_Account;
		}

		public Boolean isNullOrNullObj(Id pAccountId){
			if(pAccountId == null) return true;
			if(String.isBlank(pAccountId)) return true;

			if( !this.f_IsLoaded){ this.load(); }
			if(f_NullAccountMap.containsKey(pAccountId)){
				return true;
			}
			return false;
		}		

		private void load(){
			this.f_NullAccountMap = AccountLinqs.ListToMapById(this.f_Dao_Account.SelectByRecordTypeDevName('null'));
		}
	}

}