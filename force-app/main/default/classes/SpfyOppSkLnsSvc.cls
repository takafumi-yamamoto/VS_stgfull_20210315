public without sharing class SpfyOppSkLnsSvc {

    @AuraEnabled(cacheable=true)
    public static List<SeikyuLine> getSeikyuLines( String pOppId ){

        List<SeikyuLine> theSeikyuLines = new List<SeikyuLine>();
        if( String.isBlank(pOppId) ) return theSeikyuLines;


        for(OkyakusamaSeikyuMeisai__c aRecord : [
            SELECT Id, Name, SeikyuHouhou__c, SeikyuKingaku__c
            FROM OkyakusamaSeikyuMeisai__c
            WHERE OpportunityRef__c = :pOppId      
        ]){
            SeikyuLine aSeikyuLine = new SeikyuLine();
            aSeikyuLine.id = aRecord.Id;
            aSeikyuLine.name = aRecord.Name;
            aSeikyuLine.seikyu_houhou = aRecord.SeikyuHouhou__c;
            aSeikyuLine.seikyu_houhou_label = 
                sche_Pickls.tryGetLabel('OkyakusamaSeikyuMeisai__c', 'SeikyuHouhou__c', aRecord.SeikyuHouhou__c, '');
            aSeikyuLine.seikyu_kingaku = aRecord.SeikyuKingaku__c;
            theSeikyuLines.add( aSeikyuLine );
        }
        return theSeikyuLines;
    }

    public class SeikyuLine{
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String seikyu_houhou;
        @AuraEnabled public String seikyu_houhou_label;
        @AuraEnabled public Decimal seikyu_kingaku;
    }
}