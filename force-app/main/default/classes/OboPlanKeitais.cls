public class OboPlanKeitais {

	public enum Keitais{
		SOGI,
		HOYO,
		KAIMYO,
		OTHERS,
		UNDEFINED
	}

	public static Set<String> getPlans(Keitais pKeitai){
		Set<String> thePlans = new Set<String>();
		if(pKeitai == Keitais.SOGI){ for(String aPlan : sogis){ thePlans.add(aPlan); } }
		if(pKeitai == Keitais.HOYO){ for(String aPlan : hoyos){ thePlans.add(aPlan); } }
		if(pKeitai == Keitais.KAIMYO){ for(String aPlan : kaimyos){ thePlans.add(aPlan); } }
		if(pKeitai == Keitais.OTHERS){ for(String aPlan : others){ thePlans.add(aPlan); } }
		return thePlans;
	}

	public static Boolean isSogi(String pOboPlan){ return sogis.contains(pOboPlan); }
	public static Boolean isHoyo(String pOboPlan){ return hoyos.contains(pOboPlan); }
	public static Boolean isKaimyo(String pOboPlan){ return kaimyos.contains(pOboPlan); }

	private static Set<String> sogis = new Set<String>{
		'火葬式','一日葬','一般葬'
	};

	private static Set<String> hoyos = new Set<String>{
		'初七日法要',
		'二七日法要',
		'三七日法要',
		'四七日法要',
		'五七日法要',
		'六七日法要',
		'四十九日法要',
		'百ヶ日法要',
		'一周忌法要',
		'三回忌法要',
		'七回忌法要',
		'十三回忌法要',
		'十七回忌法要',
		'二十三回忌法要',
		'二十七回忌法要',
		'三十三回忌法要',
		'三十七回忌法要',
		'四十三回忌法要',
		'四十七回忌法要',
		'五十回忌法要',
		'初盆・新盆',
		'お盆',
		'お盆（先祖供養）',
		'お盆（故人1名のみ）',
		'お彼岸',
		'納骨法要',
		'開眼法要',
		'墓石開眼',
		'仏壇開眼',
		'位牌開眼',
		'墓石閉眼',
		'仏壇閉眼',
		'位牌閉眼',
		'追善供養',
		'仏壇開眼+仏壇閉眼',
		'遷座法要',
		'その他の法要'
	};

	private static Set<String> kaimyos = new Set<String>{
		'戒名・法名のみ'
	};

	private static Set<String> others = new Set<String>{
		'法事・法要は希望しない',
		'どの法要を選べばよいのかわからない',
		'プラン未確定'
	};
	
}