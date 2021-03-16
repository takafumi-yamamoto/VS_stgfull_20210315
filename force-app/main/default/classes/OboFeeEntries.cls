public class OboFeeEntries {
	public static GetUnitPriceRes getUnitPrice(GetUnitPriceReq pReq){
		Set<String> theShohinBangos = new Set<String>();
		for(String aShohinBango : pReq.shohinBangos){ theShohinBangos.add(aShohinBango); }

		Map<String, Decimal> theShohinBangoToUnitPriceMap = new Map<String, Decimal>();
		for(OboFeeEntry__c aOboFeeEntry : 
			[
				SELECT 
				ShohinBango__c, UnitPrice__c
				FROM OboFeeEntry__c
				WHERE ShohinBango__c IN :theShohinBangos
				AND TekiyoKaishiBi__c <= :pReq.baseDate
				AND CoreTesuryoPlanId__c = :pReq.coreTesuryoPlanId
				ORDER BY ShohinBango__c, TekiyoKaishiBi__c DESC
			]
		){
			if( !theShohinBangoToUnitPriceMap.containsKey(aOboFeeEntry.ShohinBango__c) ) {
				theShohinBangoToUnitPriceMap.put(aOboFeeEntry.ShohinBango__c, aOboFeeEntry.UnitPrice__c);
			}
		}

		GetUnitPriceRes theRes = new GetUnitPriceRes();
		theRes.shohinBangoToUnitPriceMap = theShohinBangoToUnitPriceMap;
		return theRes;
	}
	public class GetUnitPriceReq{
		public Date baseDate = Date.today();
		public Decimal coreTesuryoPlanId = 0;
		public List<String> shohinBangos = new List<String>();
	}
	public class GetUnitPriceRes{
		public Map<String, Decimal> shohinBangoToUnitPriceMap = new Map<String, Decimal>();
	}
}