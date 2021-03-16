public class Dao_JizenwariShodans{
    
    private static Dao_JizenwariShodan instance;
    public static Dao_JizenwariShodan getInstance(){
        return new Dao_JizenwariShodan(
            Dao_Opportunity.getInstance(),
            Dao_Jizenwari.getInstance(),
            RecordTypeCachedDaos.getInstance()
        );
    }

    public class Dao_JizenwariShodan{

        private Dao_Opportunity f_Dao_Opportunity;
        private Dao_Jizenwari f_Dao_Jizenwari;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_IRecordTypeCachedDao;
        private Dao_JizenwariShodan(
            Dao_Opportunity pDao_Opportunity,Dao_Jizenwari pDao_Jizenwari,
            RecordTypeCachedDaos.IRecordTypeCachedDao pIRecordTypeCachedDao){
            this.f_Dao_Opportunity = pDao_Opportunity;
            this.f_Dao_Jizenwari = pDao_Jizenwari;
            this.f_IRecordTypeCachedDao = pIRecordTypeCachedDao;
        }

        public List<JizenwariShodan> selectByKeiyakuTorihikisakiId(Id pKeiyakuTorihikisakiId){
            List<Jizenwari__c> theJizenwaris 
                = this.f_Dao_Jizenwari
                    .selectByKeiyakuTorihikisakiId(pKeiyakuTorihikisakiId);
            return this.selectByjizenwariIds(
                SobjectsExtension.collectIds(theJizenwaris)
            );
        }

        public List<JizenwariShodan> selectByjizenwariIds(List<Id> pJizenwariIds){
            List<Jizenwari__c> theJizenwaris 
                = this.f_Dao_Jizenwari.selectByIds(pJizenwariIds);
            List<Opportunity> theOpps 
                = this.f_Dao_Opportunity
                    .selectByJizenwariIds(SobjectsExtension.collectIds(theJizenwaris));
            return this.createJizenwariShodans(theOpps,theJizenwaris);
        }

        private List<JizenwariShodan> createJizenwariShodans(
            List<Opportunity> pOpps, List<Jizenwari__c> pJizenwaris){
            Map<Id,SObject> theJizenwarisById = SobjectsExtension.listToMap(pJizenwaris);

            List<JizenwariShodan> theJizenwariShodans = new List<JizenwariShodan>();
            Id theJizenwariOppRTypeId 
                = this.f_IRecordTypeCachedDao
                    .SelectIdByObjectTypeNameAndDevName('Opportunity','Simple_Jizenwari');
            for(Opportunity aOpp : pOpps){
                Jizenwari__c theJizenwari = (Jizenwari__c)theJizenwarisById.get(aOpp.JizenwariRef__c);
                if(aOpp.RecordTypeId == theJizenwariOppRTypeId && theJizenwari != null) {
                    theJizenwariShodans.add( JizenwariShodan.create(aOpp, theJizenwari) );
                }
            }
            return theJizenwariShodans;
        }
    }
}