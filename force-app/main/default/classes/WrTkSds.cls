public class WrTkSds {

	public interface IWrTkSeido {
		WaribikiSeidoCodes waribikiSeidoCode();
		Boolean isContextMatch(WrTkCtxs.ContextData pContextData, String pShohinBango);
		Boolean existsHeiyoRiyoNg(List<WaribikiSeidoCodes> pWaribikiSeidoCodes);
		Set<String> getWaribikiShohinBangos(String pShohinBango);
	}

	public Enum WaribikiSeidoCodes{
		OsoshikiYoyaku,
		Jizenwari0day,
		Jizenwari30day,
		Jizenwari1year,
		Jizenwari2Year,
		JizenJunbi,
		SekogoAncate,
		PostalClub,
		Benifit,
		KakakuCom,
		Kazoku1nichi,
		Kazoku2nichi,
		KazokuHanayaka,
		KasoChokuso,
		KasoHyojun,
		Atobarai,
		ShikigoAnkeito,
		JizenAnkeito,
		ButsugiNashi,
		OldKazoku1nichi,
		OldKazoku2nichi,
		OldKazokuHanayaka,
		OldKasoChokuso,
		OldKasoHyojun,
		CampaignSogiyoBouquet,
		CampaignSogiyoBouquetTaioFuka,
		KasoChokusoTokubetsuKakaku,
		Kazoku1nichiTokubetsuKakaku,
		YorisoKaiin,
		OldYorisoKaiin
	}
}