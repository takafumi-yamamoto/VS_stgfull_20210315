public class RsCoreApi_SaijoHall {

    private class FacilityInfoSaijoHall{
        public String saijoId { get; private set; }
        public String hallId { get; private set; }
        public String hallName { get; private set; }
        public String hallNameKana { get; private set; }
        public String isIchinichi { get; private set; }
        public String isKazoku { get; private set; }
        public String isIppan { get; private set; }
        public Integer sekisu { get; private set; }
        public Integer jogenKaisoshasu { get; private set; }
        public Integer X1ShiyoRyokinIppan { get; private set; }
        public Integer X1ShiyoRyokinShimin { get; private set; }
        public Integer X1ShiyoRyokinShimingai { get; private set; }
		public Integer X2ShiyoRyokinIppan { get; private set; }
		public Integer X2ShiyoRyokinShimin { get; private set; }
        public Integer X2ShiyoRyokinShimingai { get; private set; }
        public String shiyoRyokinBiko { get; private set; }
    }

    public String createFacilityInfoSaijoHallJson(SaijoHall__c s){
    	FacilityInfoSaijoHall it = new FacilityInfoSaijoHall();
        it.saijoId = s.SaijoKeisaiJohoId__c;
        it.hallId = s.HallKeisaiJohoId__c;
		it.hallName = s.Name;
		it.hallNameKana = String.isEmpty(s.SaijoHallKana__c) ? '' : s.SaijoHallKana__c;
		it.isIchinichi = this.resolveIchinichisoTaio(s.TaioShikishubetsu__c);
		it.isKazoku = this.resolveKazokusoTaio(s.TaioShikishubetsu__c);
		it.isIppan = this.resolveIppansoTaio(s.TaioShikishubetsu__c);
		it.sekisu = s.Sekisu__c == null ? null : Integer.valueOf(s.Sekisu__c);
        it.jogenKaisoshasu = s.JogenKaisoshasu__c == null ? null : Integer.valueOf(s.JogenKaisoshasu__c);
        it.X1ShiyoRyokinIppan = s.X1ShiyoRyokinIppan__c == null ? null : Integer.valueOf(s.X1ShiyoRyokinIppan__c);
        it.X1ShiyoRyokinShimin = s.X1ShiyoRyokinShimin__c == null ? null : Integer.valueOf(s.X1ShiyoRyokinShimin__c);
        it.X1ShiyoRyokinShimingai = s.X1ShiyoRyokinSonota__c == null ? null : Integer.valueOf(s.X1ShiyoRyokinSonota__c);
        it.X2ShiyoRyokinIppan = s.X2ShiyoRyokinIppan__c == null ? null : Integer.valueOf(s.X2ShiyoRyokinIppan__c);
		it.X2ShiyoRyokinShimin = s.X2ShiyoRyokinShimin__c == null ? null : Integer.valueOf(s.X2ShiyoRyokinShimin__c);
		it.X2ShiyoRyokinShimingai = s.X2ShiyoRyokinSonota__c == null ? null : Integer.valueOf(s.X2ShiyoRyokinSonota__c);
		it.shiyoRyokinBiko = String.isEmpty(s.ShiyoRyokinBiko__c) ? '' : s.ShiyoRyokinBiko__c;
        return JSON.serializePretty( it );
    }

    private String resolveIchinichisoTaio(String val){
        if(val.contains('一日葬')) return '1';
        return '0';
    }

    private String resolveKazokusoTaio(String val){
        if(val.contains('家族葬')) return '1';
        return '0';
    }

    private String resolveIppansoTaio(String val){
        if(val.contains('一般葬')) return '1';
        return '0';
    }
}