public class Szsd_Shiiragiku {

    public static IOppList_For_Shiragiku get_IOppList_For_Shiragiku_instance(){
        return new OppList_For_Shiragiku();
    }
    public interface IOppList_For_Shiragiku{
        List<Opportunity> select_opps(List<String> p_opp_ids);
        Boolean isMatch(Opportunity p_opp);
        Boolean isMatch(String p_opp_id);
    }
    public class OppList_For_Shiragiku implements IOppList_For_Shiragiku{
		// レポート：白菊用_顧客リスト全国（北海道／沖縄除く）の条件
		// https://minrevi.lightning.force.com/lightning/r/Report/00O2v0000099UpFEAU/view?queryScope=userFolders

        public List<Opportunity> select_opps(List<String> p_opp_ids){
            return [
                SELECT Id, RecordType.DeveloperName,
                Account.BillingState,
                Account.TelemarketingNG__pc,
                Account.KoukokuDmNg__c,
                Account.ClaimAllNum__c,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,
                (
                    SELECT Id, 
                    Product2.Name,
                    Product2.k_ShohinSyubetsu_Id_exp__c,
                    Product2.k_ShohinSyubetsu_Name_exp__c
                    FROM OpportunityLineItems
                )
                FROM Opportunity 
                WHERE Id IN :p_opp_ids
            ];
        }
        public Boolean isMatch(Opportunity p_opp){

			Boolean has_line_item_to_match = false;
			for( OpportunityLineItem aLineItem : p_opp.OpportunityLineItems ){
				Boolean is_line_item_match = 
					(
						aLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '1'
						||
						aLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '2'
					)
					&&
					aLineItem.Product2.k_ShohinSyubetsu_Name_exp__c == '本体（委託）'
					&&
					!( aLineItem.Product2.Name.contains('火葬') );

				if( is_line_item_match ) has_line_item_to_match = true;
			}

			return 
			p_opp.RecordType.DeveloperName == 'SimpleYasugo'
			&&
			!( new List<String>{'北海道','沖縄県'}.contains(p_opp.Account.BillingState) )
			&&
			p_opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c != null
			&&
			has_line_item_to_match
			&&
			p_opp.Account.TelemarketingNG__pc == false
			&&
			p_opp.Account.ClaimAllNum__c != null
			&&
			p_opp.Account.KoukokuDmNg__c == false
			;
        }

        public Boolean isMatch(String p_opp_id){
			Opportunity a_opp = (Opportunity)SobjectsExtension.firstOrNull(
				this.select_opps(new List<String>{ p_opp_id } )
			);
            if(a_opp == null) return false;
            
            return this.isMatch(a_opp);
        }
	}
}