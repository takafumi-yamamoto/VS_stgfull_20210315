public class SzsdAssign {

    @TestVisible
    private static Date seko_date_ncp_start = Date.newInstance(2021, 3, 1); //2021.3,1施行分以降NCPにも送客

    public static IAssinger get_IAssinger_instance(){
        return new Assinger();
    }
    public enum Asigneees{
        Kurashiki,
        Ncp
    }

    public interface IAssinger {
        Asigneees resolve_asignnee(String p_opp_id);
    }
    public class Assinger implements IAssinger{
        public Asigneees resolve_asignnee(String p_opp_id){
            return this.resolve_asignnee(
                this.select_opps( new List<String>{ p_opp_id } ).get(0)
            );
        }
        private Asigneees resolve_asignnee(Opportunity p_opp){
            if( p_opp.Utiagebi__c < seko_date_ncp_start){
                return Asigneees.Kurashiki;
            }
            if( new List<String>{'東京都','千葉県','群馬県'}.contains( p_opp.Account.BillingState ) ){
                return Asigneees.Ncp;
            }
            return Asigneees.Kurashiki;
        }
        private List<Opportunity> select_opps(List<String> p_opp_ids){
            return [
                SELECT Id, Utiagebi__c,
                Account.BillingState
                FROM Opportunity
                WHERE Id IN :p_opp_ids
            ];
        }
    }
}