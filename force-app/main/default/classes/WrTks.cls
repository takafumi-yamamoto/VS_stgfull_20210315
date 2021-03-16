public class WrTks {

	public Set<String> getWaribikiShohinBangos(WrTkCtxs.ContextData pCtx, String pShohinBango){

		Set<String> theWaribikiShohinCodes = new Set<String>();
		for(WrTkSds.IWrTkSeido aWaribikiSeido : getWaribikiSeidoToTekiyo(pCtx, pShohinBango) ){
			theWaribikiShohinCodes.addAll( aWaribikiSeido.getWaribikiShohinBangos(pShohinBango) );
		}	

		return theWaribikiShohinCodes;
	}

	public List<WrTkSds.IWrTkSeido> getWaribikiSeidoToTekiyo(WrTkCtxs.ContextData pCtx, String pShohinBango){
		List<WrTkSds.IWrTkSeido> theWaribikiSeidos_ContextMatch = new List<WrTkSds.IWrTkSeido>();
		List<WrTkSds.WaribikiSeidoCodes> theWaribikiSeidoCodes_ContextMatch = new List<WrTkSds.WaribikiSeidoCodes>();
		for( WrTkSds.IWrTkSeido aWaribikiSeido : this.getWaribikiSeidos() ){
			if( aWaribikiSeido.isContextMatch(pCtx, pShohinBango) ){
				theWaribikiSeidos_ContextMatch.add( aWaribikiSeido );
				theWaribikiSeidoCodes_ContextMatch.add( aWaribikiSeido.waribikiSeidoCode() );
			}
		}

		List<WrTkSds.IWrTkSeido> theWaribikiSeidos_toTekiyo = new List<WrTkSds.IWrTkSeido>();
		for(WrTkSds.IWrTkSeido aWaribikiSeido : theWaribikiSeidos_ContextMatch){
			if( !aWaribikiSeido.existsHeiyoRiyoNg( theWaribikiSeidoCodes_ContextMatch ) ){
				theWaribikiSeidos_toTekiyo.add(aWaribikiSeido);
			}
		}
		return theWaribikiSeidos_toTekiyo;
	}

	private List<WrTkSds.IWrTkSeido> getWaribikiSeidos(){
		return new List<WrTkSds.IWrTkSeido>{
			new WrTkSdOsoshikiYoyaku(),
			new WrTkSdPostalClub(),
			new WrTkSdBenefit(),
			new WrTkSdKakakuCom(),
			new WrTkSdAtobarai(),
			new WrTkSdShikigoAnkeito(),
			new WrTkSdJizenAnkeito(),
			new WrTkSdButsuguNashi(),
			new WrTkSdCampaignSogiyoBouquet(),
			new WrTkSdCampaignSogiyoBouquetTaioFuka(),
			new WrTkSdKazoku1nichiTokubetsuKakaku(),
			new WrTkSdYorisoKaiin(),
			new WrTkSdOldYorisoKaiin()
		};
	}
}