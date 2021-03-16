public class ShiragikuTaios {

    public static ICanShiragikuTaio_Judger get_ICanShiragikuTaio_Judger_instance(){
        return new CanShiragikuTaio_Judger();
    }
    public interface ICanShiragikuTaio_Judger {
        Boolean can_taio(String p_opp_id);
    }
    public class CanShiragikuTaio_Judger implements ICanShiragikuTaio_Judger{
        public List<Opportunity> select_opps(List<String> p_opp_ids){
            return [
                SELECT Id, RecordType.DeveloperName,
                Account.BillingState,
                (
                    SELECT Id, 
                    Product2.Name, Product2.SougiPlan__c
                    FROM OpportunityLineItems
                )
                FROM Opportunity 
                WHERE Id IN :p_opp_ids
            ];
        }
        public Boolean can_taio(String p_opp_id){
            Opportunity a_app = this.select_opps( new List<String>{p_opp_id} ).get(0);

            if( new List<String>{'北海道','沖縄県'}.contains(a_app.Account.BillingState) ){ 
                return false; 
            }

            Boolean any_plan_cant_taio = false;
            for(OpportunityLineItem a_line_item : a_app.OpportunityLineItems ){
                if( a_line_item.Product2.SougiPlan__c && a_line_item.Product2.Name.contains('火葬') ){
                    any_plan_cant_taio = true;
                }
            }
            if( any_plan_cant_taio ) {
                return false;
            }

            return true;
        }
    }
}