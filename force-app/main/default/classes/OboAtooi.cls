public class OboAtooi {

    public static void subscriveOnObosanbinBeforeUpdated(List<Obosanbin__c> newOnes, Map<Id, Obosanbin__c> oldOnes){

        for(Obosanbin__c aNewOne : newOnes){
            Obosanbin__c aOldOne = oldOnes.get(aNewOne.Id);
            
            if(aNewOne.AtooiKekka__c == aOldOne.AtooiKekka__c) continue;

            if( !String.isBlank(aNewOne.AtooiKekka__c) ){
                aNewOne.AtooiJissiNichiji__c = aNewOne.AtooiJissiNichiji__c == null ? DateTime.now() : aNewOne.AtooiJissiNichiji__c;
                aNewOne.AtooiJissiSha__c = aNewOne.AtooiJissiSha__c == null ? userInfo.getUserId() : aNewOne.AtooiJissiSha__c;
            }
        }

        for(Obosanbin__c aNewOne : newOnes){
            Obosanbin__c aOldOne = oldOnes.get(aNewOne.Id);
            
            if(aNewOne.AtooiKekka2__c == aOldOne.AtooiKekka2__c) continue;

            if( !String.isBlank(aNewOne.AtooiKekka2__c) ){
                aNewOne.AtooiJissiNichiji2__c = aNewOne.AtooiJissiNichiji2__c == null ? DateTime.now() : aNewOne.AtooiJissiNichiji2__c;
                aNewOne.AtooiJissiSha2__c = aNewOne.AtooiJissiSha2__c == null ? userInfo.getUserId() : aNewOne.AtooiJissiSha2__c;
            }
        }

        for(Obosanbin__c aNewOne : newOnes){
            Obosanbin__c aOldOne = oldOnes.get(aNewOne.Id);
            
            if(aNewOne.AtooiKekka3__c == aOldOne.AtooiKekka3__c) continue;

            if( !String.isBlank(aNewOne.AtooiKekka3__c) ){
                aNewOne.AtooiJissiNichiji3__c = aNewOne.AtooiJissiNichiji3__c == null ? DateTime.now() : aNewOne.AtooiJissiNichiji3__c;
                aNewOne.AtooiJissiSha3__c = aNewOne.AtooiJissiSha3__c == null ? userInfo.getUserId() : aNewOne.AtooiJissiSha3__c;
            }
        }                
    }
}