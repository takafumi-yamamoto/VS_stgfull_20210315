public class SogiShiharaitsuchisyo implements ISogiShiharaitsuchisyo{

    public interface ISogiShiharaitsuchisyo {
        void updateShiharaitsuchisyo (List<PatnerUriage__c> pEntries);
    }
    public void updateShiharaitsuchisyo (List<PatnerUriage__c> pEntries) {
        Set<Id> theOppIds = new Set<Id>();
        for(PatnerUriage__c aEntry : pEntries){ 
            theOppIds.add( aEntry.Syodan__c ); 
        }

        for( Opportunity aOpp : [
            SELECT Id, SimpleYasugoRef__c 
            FROM Opportunity WHERE Id = :theOppIds
            AND RecordType.DeveloperName = 'SimpleYasugo'
        ]){
            SogiShiharaitsuchisyoWaribikiKeisan.ResultSogiwaribiki WaribikiData = new SogiShiharaitsuchisyoWaribikiKeisan().waribikiTotalization(aOpp.id);
            UPDATE new SimpleYasugo__c(
                Id = aOpp.SimpleYasugoRef__c,
                kishafutankingaku__c = WaribikiData.kishafutan,
                Yorisofutankingaku__c = WaribikiData.yorisofutan
            );
        }
    }

}