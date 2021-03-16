// SgTgAnSms->SogiTehaigoAnnaiSMS
public class SgTgAnSms{

	public static String m_MsgType_PlanAri = 'SgTgAnSms_PlanAri';
	private static SmsTemplates.Template m_Template_PlanAri = new SmsTemplates().getTemplate(m_MsgType_PlanAri);

	public static String m_MsgType_PlanNashi = 'SgTgAnSms_PlanNashi';
	private static SmsTemplates.Template m_Template_PlanNashi = new SmsTemplates().getTemplate(m_MsgType_PlanNashi);

	public interface IMessageCreater{
		String createMsg(String p_opp_id);
	}
	public class MessageCreater implements IMessageCreater{

		private IOppLineItemDataPvdr m_IOppLineItemDataPvdr;
		public MessageCreater(
			IOppLineItemDataPvdr p_IOppLineItemDataPvdr
		){
			this.m_IOppLineItemDataPvdr = p_IOppLineItemDataPvdr;
		}

		public String createMsg(String p_opp_id){
			OppLineItemData theOppLineItemData = this.m_IOppLineItemDataPvdr.getOppLineItemData(p_opp_id);
			String theBody = '';
			if( String.isNotBlank(theOppLineItemData.MainPlan)) {
				theBody =m_Template_PlanAri.getBody()
					.replace('{MainPlan}', theOppLineItemData.MainPlan)
					.replace('{WaribikiPlan}', theOppLineItemData.WaribikiPlan)
					;
			} else {
				theBody =m_Template_PlanNashi.getBody();
			}
			return theBody;
		}
	}

	public class OppLineItemData{
		public String MainPlan = '';
		public String WaribikiPlan = '';
	}

	public interface IOppLineItemDataPvdr {
		OppLineItemData getOppLineItemData(String pOppId);
	}

	public class OppLineItemDataPvdr implements IOppLineItemDataPvdr{
		public OppLineItemData getOppLineItemData(String pOppId){
			List<OpportunityLineItem> theOpportunityLineItem = [SELECT Product2.NameForCustomer__c , Product2.SougiPlan__c , Product2.DataKubun__c 
																FROM OpportunityLineItem 
																WHERE OpportunityId = :pOppId 
																AND (Product2.SougiPlan__c = True 
																OR Product2.DataKubun__c in ('2:割引プラン','3:クーポン'))]
																;

			String the_main_plan_text = '';
			String the_waribiki_naiyo_text = '';
			List<String> the_tekiyo_waribikis = new List<String>();

			for(OpportunityLineItem aOpportunityLineItem :theOpportunityLineItem){

				if( aOpportunityLineItem.Product2.SougiPlan__c ){
					the_main_plan_text = aOpportunityLineItem.Product2.NameForCustomer__c;
				}
				if((aOpportunityLineItem.Product2.DataKubun__c == '2:割引プラン') || (aOpportunityLineItem.Product2.DataKubun__c == '3:クーポン')){
					the_tekiyo_waribikis.add(  aOpportunityLineItem.Product2.NameForCustomer__c );
				}
			}

			if( the_tekiyo_waribikis.size() == 0){
				the_waribiki_naiyo_text = '';
			}
			else if( the_tekiyo_waribikis.size() == 1 ){
				the_waribiki_naiyo_text = '割引：' + the_tekiyo_waribikis.get(0);
			}
			else{
				the_waribiki_naiyo_text = '割引：\n';
				for( String a_waribiki : the_tekiyo_waribikis){
					the_waribiki_naiyo_text += String.format('・ {0}\n', new List<String>{a_waribiki} );
				}
			}
			
			OppLineItemData theOppLineItemData = new OppLineItemData();
			theOppLineItemData.MainPlan = the_main_plan_text;
			theOppLineItemData.WaribikiPlan = the_waribiki_naiyo_text;
			return theOppLineItemData;
		}
	}
}