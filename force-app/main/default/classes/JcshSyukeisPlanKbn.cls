public class JcshSyukeisPlanKbn {

    public static IPlanKbn_By_OppLine_Mapper get_IPlanKbn_By_OppLine_Mapper_instance(){
        return new PlanKbn_By_OppLine_Mapper();
    }

    public interface IPlanKbn_By_OppLine_Mapper{
        String get_plan_kubun(Opportunity pOpp);
    }
    public class PlanKbn_By_OppLine_Mapper implements IPlanKbn_By_OppLine_Mapper{
        public String get_plan_kubun(Opportunity pOpp){

            String the_plan_kubun = '未分類';
            for(OpportunityLineItem aLineItem : pOpp.OpportunityLineItems){
                if( !aLineItem.Product2.SougiPlan__c ) continue;
                the_plan_kubun = this.get_plan_kubun(aLineItem.Product2.ShohinBango__c);
            }
            return the_plan_kubun;
        }

        @TestVisible
        public String get_plan_kubun(String pShohinBango){

            if(pShohinBango == 'SBG-0005013'){ return '火葬式-シンプル'; }//SBG-0005013	【21.04】よりそう火葬式 シンプルプラン
            if(pShohinBango == 'SBG-0005014'){ return '火葬式-基本'; }//SBG-0005014	【21.04】よりそう火葬式 基本プラン
            if(pShohinBango == 'SBG-0005015'){ return '火葬式-仏具セット'; }//SBG-0005015	【21.04】よりそう火葬式 仏具セットプラン
            if(pShohinBango == 'SBG-0005016'){ return '火葬式-お花セット'; }//SBG-0005016	【21.04】よりそう火葬式 お花セットプラン
            if(pShohinBango == 'SBG-0005010'){ return '一日'; }//SBG-0005010	【21.04】よりそう家族葬 一日プラン
            if(pShohinBango == 'SBG-0005011'){ return '二日'; }//SBG-0005011	【21.04】よりそう家族葬 二日プラン
            if(pShohinBango == 'SBG-0005012'){ return '華やか'; }//SBG-0005012	【21.04】よりそう家族葬 華やかプラン
            
            return '未分類';
        }
    }

}