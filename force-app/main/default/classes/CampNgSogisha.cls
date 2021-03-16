public class CampNgSogisha {

	public class OppLineItemValidator{

		public Boolean any_invalids(String p_opp_id){

			Opportunity a_opp = [
				SELECT Id, 
				SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.campaign_sougi_bouquet__c,
				(
					SELECT Id, Product2.ShohinBango__c FROM OpportunityLineItems
				)
				FROM Opportunity 
				WHERE id = :p_opp_id
				Limit 1
			]
			.get(0);

			String shohin_code_of_CampaignSougiBouquet = 'SBG-0005420';	//【20.11】よりそうオプション 葬儀用ブーケ (2020年11月開始キャンペーン)
			String shohin_code_of_nebiki = 'SBG-0000214'; //その他お客様向け割引（CS起因）
			
			Boolean is_campain_bouquet = false;
			Boolean is_sogisha_campain_bouquet_ng = a_opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.campaign_sougi_bouquet__c == '対応不可';
			Boolean is_nebiki = false;
			for( OpportunityLineItem a_line_item : a_opp.OpportunityLineItems ){
				if( a_line_item.Product2.ShohinBango__c == shohin_code_of_CampaignSougiBouquet ){ is_campain_bouquet = true; }
				if( a_line_item.Product2.ShohinBango__c == shohin_code_of_nebiki ){ is_nebiki = true; }
			}
			Boolean is_invalid = is_campain_bouquet && is_sogisha_campain_bouquet_ng && !(is_nebiki);

			return is_invalid;
		}
	}
}