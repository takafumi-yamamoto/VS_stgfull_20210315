public class OboZidoSiryoSofu {

    public static void onOpportunityBeforeUpdated(list<Opportunity> newOnes, Map<ID, Opportunity> oldOnes, Map<Id, Obosanbin__c> pObosanbins){

        List<Opportunity> theTargets = new List<Opportunity>();
        for( Opportunity aNewOne : newOnes ){
            Opportunity aOldOne = oldOnes.get(aNewOne.Id);

            if( !(aOldOne.StageName == '決定' && aOldOne.SubPhase__c == '依頼書・手配報告書送付') ) continue;
            if( !(aNewOne.StageName == '施行待ち' || aNewOne.StageName == '施行完了') ) continue;
            if( aNewOne.RecordTypeId != Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId() ) continue;
            if( aNewOne.ObosanbinRef__c == null ) continue;

            theTargets.add(aNewOne);
        }

        List<Obosanbin__c> theObosanbinsToBeUpdated = new List<Obosanbin__c>();
        for(Opportunity aOpp : theTargets){
            Obosanbin__c aObosanbin = pObosanbins.get(aOpp.ObosanbinRef__c);
            if(aObosanbin.IraiTehaiDate__c == null){
                aObosanbin.IraiTehaiDate__c = Datetime.now().date();
                theObosanbinsToBeUpdated.add(aObosanbin);
            }
        }

        Update theObosanbinsToBeUpdated;
    }
}