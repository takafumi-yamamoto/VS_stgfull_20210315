public class JizenWariPlanCachedDaos{
    private static IJizenWariPlanCachedDao f_JizenWariPlanCachedDao;

    public static IJizenWariPlanCachedDao getInstance(){
        if(f_JizenWariPlanCachedDao == null){
            f_JizenWariPlanCachedDao = new JizenWariPlanCachedDao(new JizenWariPlanDao());
        }
        return f_JizenWariPlanCachedDao;
    }

    public interface IJizenWariPlanCachedDao{
        JizenWariPlan__c SelectJizenWariPlanByCode(String code);
    }

    public class JizenWariPlanCachedDao Implements IJizenWariPlanCachedDao{

        private JizenWariPlanDao f_jizenWariPlanDao;
        private Map<String,JizenWariPlan__c> f_mapOfjizenWariPlanByCode = new Map<String,JizenWariPlan__c>();
        private Boolean f_isLoaded = false;

        public JizenWariPlanCachedDao(JizenWariPlanDao jizenWariPlanDao){
            this.f_jizenWariPlanDao = jizenWariPlanDao;
        }

        private void Load(){
            this.f_mapOfjizenWariPlanByCode = this.f_jizenWariPlanDao.selectAllAsMap();
            this.f_isLoaded = true;
        }

        public JizenWariPlan__c SelectJizenWariPlanByCode(String code){
            if(!this.f_isLoaded){this.Load();}

            JizenWariPlan__c theJizenWariPlanByCode = this.f_mapOfjizenWariPlanByCode.get(code);
            if(theJizenWariPlanByCode == null){ return null; }

            return theJizenWariPlanByCode;
        }
    }
}