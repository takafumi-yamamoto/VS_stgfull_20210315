public class SpfyOppName {

    public class OnOppBeforeUpdate{

        public void appendShopifyOrderNo_To_OppName( List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){
            for(Opportunity aNewOne : pNewOnes){
                Opportunity aOldOne = pOldOnes.get(aNewOne.Id);

                Boolean toProcess = false;
                if( aNewOne.Name != aOldOne.Name) toProcess = true;
                if( aNewOne.AccountId != aOldOne.AccountId) toProcess = true;

                if(toProcess){
                    if( String.isBlank(aNewOne.SpfyOrderName__c) ) continue;
                    if( aNewOne.Name.contains( aNewOne.SpfyOrderName__c ) ) continue;
                    aNewOne.Name = aNewOne.Name + ' ' + aNewOne.SpfyOrderName__c;
                }
            }
        }
    }
}