public class KeiyakuCachedDaos{
    private static IKeiyakuCachedDao f_KeiyakuCachedDao;

    public static IKeiyakuCachedDao getInstance(){
        if(f_KeiyakuCachedDao == null){
            f_KeiyakuCachedDao = new KeiyakuCachedDao(new KeiyakuDao());
        }
        return f_KeiyakuCachedDao;
    }

    public interface IKeiyakuCachedDao{
    	Map<Id,Keiyaku__c> SelectAlliance();
    }

    public class KeiyakuCachedDao Implements IKeiyakuCachedDao{

        private KeiyakuDao f_keiyakuDao;
        private Map<Id,Keiyaku__c> f_mapOfKeiyakusById = new Map<Id,Keiyaku__c>();
        private Boolean f_isLoaded = false;

        public KeiyakuCachedDao(KeiyakuDao keiyakuDao){
            this.f_keiyakuDao = keiyakuDao;
        }

        private void Load(){
            this.f_mapOfKeiyakusById = this.f_keiyakuDao.selectAllianceAllAsMap();
            this.f_isLoaded = true;
        }

        public Map<Id,Keiyaku__c> SelectAlliance(){
            if(!this.f_isLoaded){this.Load();}
            return f_mapOfKeiyakusById;
        }
    }
}