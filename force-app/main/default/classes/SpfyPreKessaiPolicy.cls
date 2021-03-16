public class SpfyPreKessaiPolicy {
    public class PreKessaiPolicy {
        public Boolean isKessaiOk(String pGateway, String pFinancialStatus ){
            
            if(pFinancialStatus == 'pending'){
                if(pGateway == 'Epsilon代引き決済') return true;
            }
            if(pFinancialStatus == 'authorized') return true;
            if(pFinancialStatus == 'paid') return true;
            
            return false;
        }
    }
}