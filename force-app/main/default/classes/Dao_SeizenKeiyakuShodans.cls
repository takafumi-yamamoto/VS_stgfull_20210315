public class Dao_SeizenKeiyakuShodans{

    private static Dao_SeizenKeiyakuShodan instance;
    public static Dao_SeizenKeiyakuShodan getInstance(){
        return new Dao_SeizenKeiyakuShodan(
            Dao_Opportunity.getInstance(),
            Dao_SeizenKeiyaku.getInstance(),
            RecordTypeCachedDaos.getInstance()
        );
    }

    public class Dao_SeizenKeiyakuShodan{

        private Dao_Opportunity f_Dao_Opportunity;
        private Dao_SeizenKeiyaku f_Dao_SeizenKeiyaku;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_IRecordTypeCachedDao;
        private Dao_SeizenKeiyakuShodan(
            Dao_Opportunity pDao_Opportunity,Dao_SeizenKeiyaku pDao_SeizenKeiyaku,
            RecordTypeCachedDaos.IRecordTypeCachedDao pIRecordTypeCachedDao){
            this.f_Dao_Opportunity = pDao_Opportunity;
            this.f_Dao_SeizenKeiyaku = pDao_SeizenKeiyaku;
            this.f_IRecordTypeCachedDao = pIRecordTypeCachedDao;
        }

        public List<SeizenKeiyakuShodan> selectBySeizenKeiyakuIds(List<Id> pSeizenKeiyakuIds){
            List<SeizenKeiyaku__c> theSeizenKeiyakus 
                = this.f_Dao_SeizenKeiyaku.selectByIds(pSeizenKeiyakuIds);
            List<Opportunity> theOpps 
                = this.f_Dao_Opportunity
                    .selectBySeizenKeiyakuIds(SobjectsExtension.collectIds(theSeizenKeiyakus));
            return this.createSeizenKeiyakuShodans(theOpps,theSeizenKeiyakus);
        }

        private List<SeizenKeiyakuShodan> createSeizenKeiyakuShodans(
            List<Opportunity> pOpps, List<SeizenKeiyaku__c> pSeizenKeiyakus){
            Map<Id,SObject> theSeizenKeiyakusById = SobjectsExtension.listToMap(pSeizenKeiyakus);

            List<SeizenKeiyakuShodan> theSeizenKeiyakuShodans = new List<SeizenKeiyakuShodan>();
            Id theSeizenKeiyakuOppRTypeId 
                = this.f_IRecordTypeCachedDao
                    .SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku');
            for(Opportunity aOpp : pOpps){
                SeizenKeiyaku__c theSeizenKeiyaku = (SeizenKeiyaku__c)theSeizenKeiyakusById.get(aOpp.SeizenKeiyakuRef__c);
                if(aOpp.RecordTypeId == theSeizenKeiyakuOppRTypeId && theSeizenKeiyaku != null) {
                    theSeizenKeiyakuShodans.add( SeizenKeiyakuShodan.create(aOpp, theSeizenKeiyaku) );
                }
            }
            return theSeizenKeiyakuShodans;
        }

    }

}