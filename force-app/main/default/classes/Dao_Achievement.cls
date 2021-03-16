public class Dao_Achievement {

	public static IAchievementDao GetInstance(){
		return new AchievementDao();
	}

	public interface IAchievementDao{
		List<Achievement__c> SelectByOppIdsAndSyubetsu(Set<Id> oppIds, String syubetsu);
		List<Achievement__c> SelectByCaseIdsAndSyubetsu(Set<Id> caseIds, String syubetsu);
	}

	public class AchievementDao implements IAchievementDao{

		private String GetSelectBody(){
			return 
			'SELECT Id, Syubetsu__c , YukoKaishiBi__c ,  YukoFlag__c , SourceShodanRef__c ,TorihikiSakiRef__c' 
			+ ' FROM Achievement__c Where Id != null ';
		}

		public List<Achievement__c> SelectByOppIdsAndSyubetsu(Set<Id> oppIds, String syubetsu){
			return Database.query( 
				this.GetSelectBody() 
				+ ' And SourceShodanRef__c in :oppIds' 
				+ ' And Syubetsu__c =: syubetsu' 
				);
		}

		public List<Achievement__c> SelectByCaseIdsAndSyubetsu(Set<Id> caseIds, String syubetsu){
			return Database.query( 
				this.GetSelectBody() 
				+ ' And SourceCaseRef__c in :caseIds' 
				+ ' And Syubetsu__c =: syubetsu' 
				);
		}
	}
}