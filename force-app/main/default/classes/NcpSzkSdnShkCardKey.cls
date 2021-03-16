public class NcpSzkSdnShkCardKey {
    public static IRecordKyeAssigner get_IRecordKyeAssigner_instance(){
        return new RecordKyeAssigner();
    }

    public interface IRecordKyeAssigner {
        void assignIfNotAssigned(List<NcpSzkSdnShkCard__c> pNewOnes);
    }
    public class RecordKyeAssigner implements IRecordKyeAssigner{
        public void assignIfNotAssigned(List<NcpSzkSdnShkCard__c> pNewOnes){

            List<NcpSzkSdnShkCardKey__c> theKeyEntries = new List<NcpSzkSdnShkCardKey__c>();
            for(NcpSzkSdnShkCard__c aNewOne : pNewOnes){
                theKeyEntries.add( new NcpSzkSdnShkCardKey__c() );
            }
            INSERT theKeyEntries;
    
            List<String> theKeys = new List<String>();
            for( NcpSzkSdnShkCardKey__c aKeyEntry : [
                SELECT Id, Name
                FROM NcpSzkSdnShkCardKey__c 
                WHERE Id IN :SobjectsExtension.collectIds(theKeyEntries)
            ] ){
                theKeys.add( aKeyEntry.Name );
            }
    
            Integer theIdx = 0;
            for(NcpSzkSdnShkCard__c aNewOne : pNewOnes){
                if( String.isBlank(aNewOne.Key__c) ){
                    aNewOne.Key__c = theKeys.get(theIdx);
                }
                theIdx ++;
            }
            DELETE theKeyEntries;
        }
    }

}