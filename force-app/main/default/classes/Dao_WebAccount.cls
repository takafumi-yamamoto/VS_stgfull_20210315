public class Dao_WebAccount {

    public static IWebAccountDao GetInstance(){
        return new WebAccountDao();
    }

    public interface IWebAccountDao{
        Map<Id, WebAccount__c> SelectByIds(List<String> ids);
        List<WebAccount__c> SelectByEmailsOrTelNumbers(List<String> emailsOrtelNumbers);
        List<WebAccount__c> getWebAccountByAccountIds(List<String> accountIds);
        WebAccount__c getWebAccountByAccountId(String accountId, String ninshoHouhou);
    }

    public class WebAccountDao implements IWebAccountDao{

        private String GetSelectBody(){
            return 
            'SELECT Name, NinshoHouhou__c, TourokuChi__c, TorihikiSakiRef__c ' 
            + ' FROM WebAccount__c Where Id != null ';
        }

        public Map<Id, WebAccount__c> SelectByIds(List<String> ids){
            List<WebAccount__c> objList = Database.query( 
                this.GetSelectBody() 
                + ' And id in :ids' 
                );
            return new Map<Id, WebAccount__c>(objList);
        }
        
        
        public List<WebAccount__c> SelectByEmailsOrTelNumbers(List<String> emailsOrtelNumbers){
            return Database.query( 
                this.GetSelectBody() 
                + ' And TourokuChi__c in :emailsOrtelNumbers' 
                );
        }

        public List<WebAccount__c> getWebAccountByAccountIds(List<String> accountIds){
            return Database.query( 
                this.GetSelectBody() 
                + ' And TorihikiSakiRef__c in :accountIds' 
                );
        }

        public WebAccount__c getWebAccountByAccountId(String accountId, String ninshoHouhou){
            if(String.isBlank(accountId)) return null;

            List<WebAccount__c> webAccountList = Database.query( 
                this.GetSelectBody() 
                + ' And TorihikiSakiRef__c = :accountId' 
                + ' And NinshoHouhou__c = :ninshoHouhou' 
                );
            if(webAccountList.size() > 0 ) return webAccountList[0];
            else return null;
        }
    }

}