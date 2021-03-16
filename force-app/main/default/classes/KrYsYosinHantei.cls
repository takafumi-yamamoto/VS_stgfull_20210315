public class KrYsYosinHantei {

    public static IYosinHantei get_IYosinHantei_instance(){
        return new YosinHantei();
    }
    public interface IYosinHantei {
        void on_KrysYosin_before_insert(List<KrYsYosin__c> pNewOnes);
        void on_KrysYosin_before_update(List<KrYsYosin__c> pNewOnes, Map<Id, KrYsYosin__c> pOldOnes);
    }
    public class YosinHantei implements IYosinHantei {
        public void on_KrysYosin_before_insert(List<KrYsYosin__c> pNewOnes){
            for(KrYsYosin__c aNewOne : pNewOnes){
                aNewOne.YosinHantei__c = this.getYosinHantei(aNewOne);
            }
        }
        public void on_KrysYosin_before_update(List<KrYsYosin__c> pNewOnes, Map<Id, KrYsYosin__c> pOldOnes){

            for(KrYsYosin__c aNewOne : pNewOnes){
                KrYsYosin__c aOldOne = pOldOnes.get(aNewOne.Id);

                Boolean to_recalculate_yosin_hantei = 
                    aNewOne.YosinGendoGaku__c != aOldOne.YosinGendoGaku__c
                    || aNewOne.SaikenZandaka__c != aOldOne.SaikenZandaka__c
                    || aNewOne.YosinZandakaAlert__c != aOldOne.YosinZandakaAlert__c;

                if(to_recalculate_yosin_hantei){
                    aNewOne.YosinHantei__c = this.getYosinHantei(aNewOne);
                    if(aNewOne.YosinHantei__c != aOldOne.YosinHantei__c){
                        aNewOne.YosinHantei_VerLastest__c = Datetime.now().format('yyyyMMddHHmmssSSS');
                    }
                }
            }
        }

        private String getYosinHantei(KrYsYosin__c pKrYsYosin){
            String the_yosin_hantei = null;

            if( 
                pKrYsYosin.SaikenZandaka__c != null && pKrYsYosin.YosinGendoGaku__c != null
                && pKrYsYosin.SaikenZandaka__c <= pKrYsYosin.YosinGendoGaku__c
            ){
                the_yosin_hantei = 'OK';
            }

            if( pKrYsYosin.YosinGendoGaku__c != null && pKrYsYosin.YosinZandakaAlert__c != null
                && (pKrYsYosin.YosinGendoGaku__c - pKrYsYosin.SaikenZandaka__c) <= pKrYsYosin.YosinZandakaAlert__c
            ){
                the_yosin_hantei = 'ALERT-与信残高警告';
            }
            
            if( 
                pKrYsYosin.SaikenZandaka__c != null && pKrYsYosin.YosinGendoGaku__c != null
                && pKrYsYosin.SaikenZandaka__c > pKrYsYosin.YosinGendoGaku__c
            ){
                the_yosin_hantei = 'NG-与信限度額Over';
            }
            
            return the_yosin_hantei;
        }
    }

}