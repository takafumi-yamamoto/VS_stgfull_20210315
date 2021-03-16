public class Dao_ObosanbinShodans{

    private static Dao_ObosanbinShodan instance;
    public static Dao_ObosanbinShodan getInstance(){
        return new Dao_ObosanbinShodan(
            Dao_Opportunity.getInstance(),
            Dao_Obosanbin.getInstance(),
            RecordTypeCachedDaos.getInstance()
        );
    }

    public class Dao_ObosanbinShodan{

        private Dao_Opportunity f_Dao_Opportunity;
        private Dao_Obosanbin f_Dao_Obosanbin;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_IRecordTypeCachedDao;
        private Dao_ObosanbinShodan(
            Dao_Opportunity pDao_Opportunity,Dao_Obosanbin pDao_Obosanbin,
            RecordTypeCachedDaos.IRecordTypeCachedDao pIRecordTypeCachedDao){
            this.f_Dao_Opportunity = pDao_Opportunity;
            this.f_Dao_Obosanbin = pDao_Obosanbin;
            this.f_IRecordTypeCachedDao = pIRecordTypeCachedDao;
        }

        public List<ObosanbinShodan> selectByOpportunityIds(List<Id> pOpportunityIds){
            List<Opportunity> theOpps 
                = this.f_Dao_Opportunity
                    .selectByIds(pOpportunityIds);
            return this.createObosanbinShodans(theOpps);
        }

        public List<ObosanbinShodan> selectByObosanbinIds(List<Id> pObosanbinIds){
            List<Obosanbin__c> theObosanbins 
                = this.f_Dao_Obosanbin.selectByIds(pObosanbinIds);
            List<Opportunity> theOpps 
                = this.f_Dao_Opportunity
                    .selectByObosanbinIds(SobjectsExtension.collectIds(theObosanbins));
            return this.createObosanbinShodans(theOpps,theObosanbins);
        }

        private List<ObosanbinShodan> createObosanbinShodans(
            List<Opportunity> pOpps, List<Obosanbin__c> pObosanbins){
            Map<Id,SObject> theObosanbinsById = SobjectsExtension.listToMap(pObosanbins);

            List<ObosanbinShodan> theObosanbinShodans = new List<ObosanbinShodan>();
            Id theObosanbinOppRTypeId 
                = this.f_IRecordTypeCachedDao
                    .SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
            for(Opportunity aOpp : pOpps){
                Obosanbin__c theObosanbin = (Obosanbin__c)theObosanbinsById.get(aOpp.ObosanbinRef__c);
                if(aOpp.RecordTypeId == theObosanbinOppRTypeId && theObosanbin != null) {
                    theObosanbinShodans.add( ObosanbinShodan.create(aOpp, theObosanbin) );
                }
            }
            return theObosanbinShodans;
        }

        private List<ObosanbinShodan> createObosanbinShodans(
            List<Opportunity> pOpps){

            List<ObosanbinShodan> theObosanbinShodans = new List<ObosanbinShodan>();
            Id theObosanbinOppRTypeId 
                = this.f_IRecordTypeCachedDao
                    .SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');
            for(Opportunity aOpp : pOpps){
                if(aOpp.RecordTypeId == theObosanbinOppRTypeId){
                    Obosanbin__c theObosanbin = aOpp.ObosanbinRef__r;
                    if(theObosanbin != null) {
                        theObosanbinShodans.add( ObosanbinShodan.create(aOpp, theObosanbin) );
                    }
                }
            }
            return theObosanbinShodans;
        }
    }

}