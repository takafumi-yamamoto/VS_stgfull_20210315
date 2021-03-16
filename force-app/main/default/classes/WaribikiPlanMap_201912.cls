public class WaribikiPlanMap_201912 {

	public Map<String, Map<String, Map<String, String>>> planWaribikiMap;
	public Map<String, String> jizenJunbiWaribikiMap;
	public Map<String, String> anketoWaribikiMap;
	public Map<String, String> kakakuComWaribikiMap;
	public Map<String, String> benefitWaribikiMap;
	public Map<String, String> atobaraiShohinMap;
	
	public WaribikiPlanMap_201912(){
		planWaribikiMap = setPlanWaribikiMap();
		jizenJunbiWaribikiMap = setJizenJunbiWaribikiMap();
		anketoWaribikiMap = setAnketoWaribikiMap();
		kakakuComWaribikiMap = setKakakuComWaribikiMap();
		benefitWaribikiMap = setBenefitWaribikiMap();
		atobaraiShohinMap = setAtobaraiShohinMap();
	}

	private Map<String, Map<String, Map<String, String>>> setPlanWaribikiMap(){
		return new Map<String, Map<String, Map<String, String>>>{
	        'Jizenwari' => new Map<String, Map<String, String>>{
				'SBG-0003001' => new Map<String, String>{'D0' => 'SBG-0003500',	'D30' => 'SBG-0003500',	'Y1' => 'SBG-0003500', 'Y2' => 'SBG-0003500'},
				'SBG-0004001' => new Map<String, String>{'D0' => 'SBG-0003500',	'D30' => 'SBG-0003500',	'Y1' => 'SBG-0003500', 'Y2' => 'SBG-0003500'},
	            'SBG-0003002' => new Map<String, String>{'D0' => 'SBG-0003501',	'D30' => 'SBG-0003502',	'Y1' => 'SBG-0003503', 'Y2' => 'SBG-0003504'},
				'SBG-0003003' => new Map<String, String>{'D0' => 'SBG-0003501', 'D30' => 'SBG-0003502',	'Y1' => 'SBG-0003503', 'Y2' => 'SBG-0003504'},
				'SBG-0003004' => new Map<String, String>{'D0' => 'SBG-0003501', 'D30' => 'SBG-0003502', 'Y1' => 'SBG-0003503', 'Y2' => 'SBG-0003504'},
				'SBG-0003005' => new Map<String, String>{'D0' => 'SBG-0003505', 'D30' => 'SBG-0003506',	'Y1' => 'SBG-0003507', 'Y2' => 'SBG-0003508'},
	            'SBG-0003006' => new Map<String, String>{'D0' => 'SBG-0003505', 'D30' => 'SBG-0003506', 'Y1' => 'SBG-0003507', 'Y2' => 'SBG-0003508'},
				'SBG-0003007' => new Map<String, String>{'D0' => 'SBG-0003505',	'D30' => 'SBG-0003506',	'Y1' => 'SBG-0003507', 'Y2' => 'SBG-0003508'},
				'SBG-0003008' => new Map<String, String>{'D0' => 'SBG-0003509',	'D30' => 'SBG-0003510',	'Y1' => 'SBG-0003511', 'Y2' => 'SBG-0003512'},
	            'SBG-0003009' => new Map<String, String>{'D0' => 'SBG-0003509',	'D30' => 'SBG-0003510',	'Y1' => 'SBG-0003511', 'Y2' => 'SBG-0003512'},
				'SBG-0003010' => new Map<String, String>{'D0' => 'SBG-0003509', 'D30' => 'SBG-0003510', 'Y1' => 'SBG-0003511', 'Y2' => 'SBG-0003512'},
				'SBG-0003011' => new Map<String, String>{'D0' => 'SBG-0003513', 'D30' => 'SBG-0003514',	'Y1' => 'SBG-0003515', 'Y2' => 'SBG-0003516'},
				'SBG-0003012' => new Map<String, String>{'D0' => 'SBG-0003513', 'D30' => 'SBG-0003514',	'Y1' => 'SBG-0003515', 'Y2' => 'SBG-0003516'},
				'SBG-0003013' => new Map<String, String>{'D0' => 'SBG-0003513', 'D30' => 'SBG-0003514',	'Y1' => 'SBG-0003515', 'Y2' => 'SBG-0003516'},
				'SBG-0003103' => new Map<String, String>{'D0' => 'SBG-0003519', 'D30' => 'SBG-0003520',	'Y1' => 'SBG-0003521', 'Y2' => 'SBG-0003522'},
				'SBG-0003104' => new Map<String, String>{'D0' => 'SBG-0003519', 'D30' => 'SBG-0003520',	'Y1' => 'SBG-0003521', 'Y2' => 'SBG-0003522'},
				'SBG-0003105' => new Map<String, String>{'D0' => 'SBG-0003519',	'D30' => 'SBG-0003520', 'Y1' => 'SBG-0003521', 'Y2' => 'SBG-0003522'},
				'SBG-0003106' => new Map<String, String>{'D0' => 'SBG-0003523',	'D30' => 'SBG-0003524', 'Y1' => 'SBG-0003525', 'Y2' => 'SBG-0003526'},
				'SBG-0003107' => new Map<String, String>{'D0' => 'SBG-0003523',	'D30' => 'SBG-0003524',	'Y1' => 'SBG-0003525', 'Y2' => 'SBG-0003526'},
				'SBG-0003108' => new Map<String, String>{'D0' => 'SBG-0003523',	'D30' => 'SBG-0003524',	'Y1' => 'SBG-0003525', 'Y2' => 'SBG-0003526'}
			},
			'OsoshikiYoyaku' => new Map<String, Map<String, String>>{
				'SBG-0003002' => new Map<String, String>{'' => 'SBG-0003196'},
				'SBG-0003003' => new Map<String, String>{'' => 'SBG-0003196'},
				'SBG-0003004' => new Map<String, String>{'' => 'SBG-0003196'},
				'SBG-0003005' => new Map<String, String>{'' => 'SBG-0003197'},
	            'SBG-0003006' => new Map<String, String>{'' => 'SBG-0003197'},
				'SBG-0003007' => new Map<String, String>{'' => 'SBG-0003197'},
				'SBG-0003008' => new Map<String, String>{'' => 'SBG-0003198'},
	            'SBG-0003009' => new Map<String, String>{'' => 'SBG-0003198'},
				'SBG-0003010' => new Map<String, String>{'' => 'SBG-0003198'},
				'SBG-0003011' => new Map<String, String>{'' => 'SBG-0003199'},
				'SBG-0003012' => new Map<String, String>{'' => 'SBG-0003199'},
				'SBG-0003013' => new Map<String, String>{'' => 'SBG-0003199'},
				'SBG-0003103' => new Map<String, String>{'' => 'SBG-0003517'},
				'SBG-0003104' => new Map<String, String>{'' => 'SBG-0003517'},
				'SBG-0003105' => new Map<String, String>{'' => 'SBG-0003517'},
				'SBG-0003106' => new Map<String, String>{'' => 'SBG-0003518'},
				'SBG-0003107' => new Map<String, String>{'' => 'SBG-0003518'},
				'SBG-0003108' => new Map<String, String>{'' => 'SBG-0003518'}
			}
		};
	}

	private Map<String, String> setJizenJunbiWaribikiMap(){
		return new Map<String, String>{
			'SBG-0003001' => 'SBG-0003529',
			'SBG-0004001' => 'SBG-0003529',
			'SBG-0003002' => 'SBG-0003529',
			'SBG-0003003' => 'SBG-0003529',
			'SBG-0003004' => 'SBG-0003529',
			'SBG-0003005' => 'SBG-0003529',
			'SBG-0003006' => 'SBG-0003529',
			'SBG-0003007' => 'SBG-0003529',
			'SBG-0003008' => 'SBG-0003529',
			'SBG-0003009' => 'SBG-0003529',
			'SBG-0003010' => 'SBG-0003529',
			'SBG-0003011' => 'SBG-0003529',
			'SBG-0003012' => 'SBG-0003529',
			'SBG-0003013' => 'SBG-0003529',
			'SBG-0003103' => 'SBG-0003530',
			'SBG-0003104' => 'SBG-0003530',
			'SBG-0003105' => 'SBG-0003530',
			'SBG-0003106' => 'SBG-0003530',
			'SBG-0003107' => 'SBG-0003530',
			'SBG-0003108' => 'SBG-0003530'
		};
	}

	private Map<String, String> setAnketoWaribikiMap(){
		return new Map<String, String>{
			'SBG-0003001' => 'SBG-0003527',
			'SBG-0004001' => 'SBG-0003527',
			'SBG-0003002' => 'SBG-0003527',
			'SBG-0003003' => 'SBG-0003527',
			'SBG-0003004' => 'SBG-0003527',
			'SBG-0003005' => 'SBG-0003527',
			'SBG-0003006' => 'SBG-0003527',
			'SBG-0003007' => 'SBG-0003527',
			'SBG-0003008' => 'SBG-0003527',
			'SBG-0003009' => 'SBG-0003527',
			'SBG-0003010' => 'SBG-0003527',
			'SBG-0003011' => 'SBG-0003527',
			'SBG-0003012' => 'SBG-0003527',
			'SBG-0003013' => 'SBG-0003527',
			'SBG-0003103' => 'SBG-0003528',
			'SBG-0003104' => 'SBG-0003528',
			'SBG-0003105' => 'SBG-0003528',
			'SBG-0003106' => 'SBG-0003528',
			'SBG-0003107' => 'SBG-0003528',
			'SBG-0003108' => 'SBG-0003528'
		};
	}

	private Map<String, String> setKakakuComWaribikiMap(){
		return new Map<String, String>{
			'SBG-0003001' => 'SBG-0003537',
			'SBG-0004001' => 'SBG-0003537',
			'SBG-0003002' => 'SBG-0003537',
			'SBG-0003003' => 'SBG-0003537',
			'SBG-0003004' => 'SBG-0003537',
			'SBG-0003005' => 'SBG-0003537',
			'SBG-0003006' => 'SBG-0003537',
			'SBG-0003007' => 'SBG-0003537',
			'SBG-0003008' => 'SBG-0003537',
			'SBG-0003009' => 'SBG-0003537',
			'SBG-0003010' => 'SBG-0003537',
			'SBG-0003011' => 'SBG-0003537',
			'SBG-0003012' => 'SBG-0003537',
			'SBG-0003013' => 'SBG-0003537',
			'SBG-0003103' => 'SBG-0003538',
			'SBG-0003104' => 'SBG-0003538',
			'SBG-0003105' => 'SBG-0003538',
			'SBG-0003106' => 'SBG-0003538',
			'SBG-0003107' => 'SBG-0003538',
			'SBG-0003108' => 'SBG-0003538'
		};
	}

	private Map<String, String> setBenefitWaribikiMap(){
		return new Map<String, String>{
			'SBG-0003002' => 'SBG-0003620',
			'SBG-0003003' => 'SBG-0003620',
			'SBG-0003004' => 'SBG-0003620',
			'SBG-0003005' => 'SBG-0003620',
			'SBG-0003006' => 'SBG-0003620',
			'SBG-0003007' => 'SBG-0003620',
			'SBG-0003008' => 'SBG-0003620',
			'SBG-0003009' => 'SBG-0003620',
			'SBG-0003010' => 'SBG-0003620',
			'SBG-0003011' => 'SBG-0003620',
			'SBG-0003012' => 'SBG-0003620',
			'SBG-0003013' => 'SBG-0003620'
		};
	}

	private Map<String, String> setAtobaraiShohinMap(){
		return new Map<String, String>{
			'SBG-0003001' => 'SBG-0002010',
			'SBG-0004001' => 'SBG-0002010',
			'SBG-0003002' => 'SBG-0002010',
			'SBG-0003003' => 'SBG-0002010',
			'SBG-0003004' => 'SBG-0002010',
			'SBG-0003005' => 'SBG-0002010',
			'SBG-0003006' => 'SBG-0002010',
			'SBG-0003007' => 'SBG-0002010',
			'SBG-0003008' => 'SBG-0002010',
			'SBG-0003009' => 'SBG-0002010',
			'SBG-0003010' => 'SBG-0002010',
			'SBG-0003011' => 'SBG-0002010',
			'SBG-0003012' => 'SBG-0002010',
			'SBG-0003013' => 'SBG-0002010',
			'SBG-0003103' => 'SBG-0002011',
			'SBG-0003104' => 'SBG-0002011',
			'SBG-0003105' => 'SBG-0002011',
			'SBG-0003106' => 'SBG-0002011',
			'SBG-0003107' => 'SBG-0002011',
			'SBG-0003108' => 'SBG-0002011'
		};
	}

	public String getPlanWaribikiShohinBango(String memberKubun, String planShohinBango, String jizenwariKeikaKikan){
		String planWaribikiShohinBango = '';
		if(planWaribikiMap.containskey(memberKubun)){
			Map<String, Map<String, String>> tempPlanShohinMap = planWaribikiMap.get(memberKubun);
			if(tempPlanShohinMap.containskey(planShohinBango)){
				Map<String, String> tempJizenwariKeikaKikanMap = tempPlanShohinMap.get(planShohinBango);
				if(tempJizenwariKeikaKikanMap.containskey(jizenwariKeikaKikan)){
					planWaribikiShohinBango = tempJizenwariKeikaKikanMap.get(jizenwariKeikaKikan);
				}
			}
		}
		return planWaribikiShohinBango;
	}

	public String getJizenJunbiWaribikiShohinBango(String planShohinBango){

		String jizenJunbiWaribikiShohinBango = '';
		
		if(jizenJunbiWaribikiMap.containskey(planShohinBango)){
			jizenJunbiWaribikiShohinBango = jizenJunbiWaribikiMap.get(planShohinBango);
		}
		return jizenJunbiWaribikiShohinBango;
	}

	public String getAnkenWaribikiShohinBango(String planShohinBango){

		String ankenWaribikiShohinBango = '';
		
		if(anketoWaribikiMap.containskey(planShohinBango)){
			ankenWaribikiShohinBango = anketoWaribikiMap.get(planShohinBango);
		}
		return ankenWaribikiShohinBango;
	}

	public String getKakakuComWaribikiShohinBango(String planShohinBango){

		String kakakuComWaribikiShohinBango = '';
		
		if(kakakuComWaribikiMap.containskey(planShohinBango)){
			kakakuComWaribikiShohinBango = kakakuComWaribikiMap.get(planShohinBango);
		}
		return kakakuComWaribikiShohinBango;
	}

	public String getBenefitWaribikiShohinBango(String planShohinBango){

		String benefitWaribikiShohinBango = '';
		
		if(benefitWaribikiMap.containskey(planShohinBango)){
			benefitWaribikiShohinBango = benefitWaribikiMap.get(planShohinBango);
		}
		return benefitWaribikiShohinBango;
	}

	public String getAtobaraiShohinBango(String planShohinBango){

		String atobaraiShohinBango = '';
		
		if(atobaraiShohinMap.containskey(planShohinBango)){
			atobaraiShohinBango = atobaraiShohinMap.get(planShohinBango);
		}
		return atobaraiShohinBango;
	}
}