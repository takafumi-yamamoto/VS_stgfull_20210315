public class Dao_WebAccountTourokuIrai {

	public static IWebAccountTourokuIraiDao GetInstance(){
		return new WebAccountTourokuIraiDao();
	}

	public interface IWebAccountTourokuIraiDao{
		Map<Id, WebAccountTourokuIrai__c> SelectByIds(List<String> ids);
		List<WebAccountTourokuIrai__c> getWebAccountTourokuIraiListByIds(List<String> ids);
		List<WebAccountTourokuIrai__c> getWebAccountTourokuIraiListByIds(Set<Id> ids);
		List<WebAccountTourokuIrai__c> getWebAccountTourokuIraiListByAccountIds(List<Id> ids);
		WebAccountTourokuIrai__c getWebAccountTourokuIraiListById(String id);
		WebAccountTourokuIrai__c getWebAccountTourokuIraiListByIraibango(String Iraibango);
	}

	public class WebAccountTourokuIraiDao implements IWebAccountTourokuIraiDao{

		private String GetSelectBody(){
			return 
			'SELECT Id, Name, Context__c, RecordType.DeveloperName, TorihikiSakiRef__c, NinshoHouhou__c, TourokuChi__c, ShoriStatus__c, TorihikisakiBango__c, ShoriStatusKubun__c, WebAccountRequestTryCount__c, WebAccountRequestTryLimit__c,  ShoriStatusBiko__c, CreatedDate ' 
			+ ' FROM WebAccountTourokuIrai__c Where Id != null ';
		}

		public Map<Id, WebAccountTourokuIrai__c> SelectByIds(List<String> ids){
			List<WebAccountTourokuIrai__c> objList = Database.query( 
				this.GetSelectBody() 
				+ ' And id in :ids' 
				);
			return new Map<Id, WebAccountTourokuIrai__c>(objList);
		}

		public List<WebAccountTourokuIrai__c> getWebAccountTourokuIraiListByIds(List<String> ids){
			return Database.query( 
				this.GetSelectBody() 
				+ ' And id in :ids' 
				);
		}

		public List<WebAccountTourokuIrai__c> getWebAccountTourokuIraiListByAccountIds(List<String> accIds){
			return Database.query( 
				this.GetSelectBody() 
				+ ' And TorihikiSakiRef__c in :accIds' 
				);
		}

		public List<WebAccountTourokuIrai__c> getWebAccountTourokuIraiListByIds(Set<Id> ids){
			return Database.query( 
				this.GetSelectBody() 
				+ ' And id in :ids' 
				);
		}

		public WebAccountTourokuIrai__c getWebAccountTourokuIraiListById(String id){
			List<WebAccountTourokuIrai__c> dataList =  Database.query( 
				this.GetSelectBody() 
				+ ' And id = :id' 
				);
			if(dataList.size() > 0 ) return dataList[0];
			else return null;
		}

		public WebAccountTourokuIrai__c getWebAccountTourokuIraiListByIraibango(String Iraibango){
			List<WebAccountTourokuIrai__c> dataList =  Database.query( 
				this.GetSelectBody() 
				+ ' And Name = :Iraibango' 
				);
			if(dataList.size() > 0 ) return dataList[0];
			else return null;
		}

	}
}