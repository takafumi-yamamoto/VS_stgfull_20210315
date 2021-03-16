public class RsCoreApi_Saijo {

    private class Access{
        public String accessTrain { get; private set; }
        public String accessBus { get; private set; }
        public String accessCar { get; private set; }
        public String accessOther { get; private set; }
    }

    private class FacilityInfoSaijo{
        public String saijoId { get; private set; }
        public String simpleStatus { get; private set; }
        public String saijoName { get; private set; }
        public String saijoNameKana { get; private set; }
        public String description { get; private set; }
        public String zipCode { get; private set; }
        public String prefectureId { get; private set; }
        public String streetAddress { get; private set; }
        public String addressKana { get; private set; }
        public Decimal latitude { get; private set; }
        public Decimal longitude { get; private set; }
        public String areaCode { get; private set; }
        public Access access { get; private set; }
        public Integer management { get; private set; }
        public Integer kasobaHeisetsu { get; private set; }
        public String organiser { get; private set; }
        public Integer taioShuha { get; private set; }
        public Integer shiminRyokinKubun { get; private set; }
		public String closeDay { get; private set; }
		public Integer isAnchi { get; private set; }
        public Integer kaminshisetsuUmuKokubetsu { get; private set; }
        public Integer kaminKanoNinzu { get; private set; }
        public Integer kurumaisuTaio { get; private set; }
		public Integer isShinzokuHikae { get; private set; }
		public Integer parkingLots { get; private set; }
        public Integer isElevator { get; private set; }
		public Integer isKidsRoom { get; private set; }
        public Integer isJunyushitsu { get; private set; }
        public Integer isWheelchair { get; private set; }
        public Integer isDiaperChangingTable { get; private set; }
        public Integer isRecommendedSaijo { get; private set; }
    }

    public String createFacilityInfoSaijoJson(Saijo__c s){
    	FacilityInfoSaijo it = new FacilityInfoSaijo();
        it.saijoId = s.SaijoKeisaiJohoId__c;
        it.simpleStatus = s.SimpleHPKeisaiAri__c ? 'enable' : 'disable';
		it.saijoName = s.Name;
		it.saijoNameKana = String.isEmpty(s.KeisaiSaijoMeiKana__c) ? '' : s.KeisaiSaijoMeiKana__c;
		it.description = String.isEmpty(s.TokuchoSaijo__c) ? '' : s.TokuchoSaijo__c;
		it.zipCode = String.isEmpty(s.PostalCode__c) ? '0' : PostalCodes.toNumber(s.PostalCode__c);
		it.prefectureId = String.isEmpty(s.TodoufukenCodeExp__c) ? '0' : s.TodoufukenCodeExp__c;
		it.streetAddress = String.isEmpty(s.Street__c) ? '' : s.Street__c;
        it.addressKana = String.isEmpty(s.JushoKana__c) ? '' : s.JushoKana__c;
        it.latitude = s.IdoKedo__latitude__s == null ? null : s.IdoKedo__Latitude__s.setScale(6, RoundingMode.HALF_UP);
        it.longitude = s.IdoKedo__longitude__s == null ? null : s.IdoKedo__longitude__s.setScale(6, RoundingMode.HALF_UP);
        it.areaCode = String.isEmpty(s.AreaCode__c) ? '0' : s.AreaCode__c;
        it.access = this.createAccess(s);
		it.management = this.resolveManagement(s.ShisetsuKubun__c);
		it.kasobaHeisetsu = this.resolveIsKasobaHeisetsu(s.KasobaHeisetsuList__c);
		it.organiser = String.isEmpty(s.UneimotoYago__c) ? '' : s.UneimotoYago__c;
		it.taioShuha = this.resolveTaioShuha(s.TaioShuha__c);
		it.shiminRyokinKubun = this.resolveShiminRyokinKubun(s.ShiminRyokinKubun__c);
		it.closeDay = String.isEmpty(s.Kyukanbi__c) ? '' : s.Kyukanbi__c;
		it.isAnchi = this.resolveIsAnchi(s.AnchiShisetsu__c);
		it.kaminshisetsuUmuKokubetsu = this.resolveKaminshisetsuUmuKokubetsu(s.KaminShisetsuUmuKokubetsushikiZenjitsu__c);
		it.kaminKanoNinzu = s.KaminKanoNinzu__c == null ? 0 : (Integer)s.KaminKanoNinzu__c;
		it.kurumaisuTaio = this.resolveKurumaisuTaio(s.KurumaisuTaio__c);
		it.isShinzokuHikae = this.resolveIsShinzokuHikae(s.ShinzokuHikaeshitsu__c);
        it.parkingLots = s.ChushaDaisu__c == null ? 0 : (Integer)s.Chushadaisu__c;
		it.isElevator = this.resolveIsElevator(s.ElevatorUmu__c);
        it.isKidsRoom = this.resolveIsKidsRoom(s.KidsRoomList__c);
        it.isJunyushitsu = this.resolveIsJunyushitsu(s.JunyushitsuList__c);
        it.isWheelchair = this.resolveIsKurumaisuKashidashi(s.KurumaisuKashidashiList__c);
        it.isDiaperChangingTable = this.resolveIsDiaperChangingTable(s.OmutsuKokandaiList__c);
        it.isRecommendedSaijo = this.resolveIsRecommendedSaijo(s.SuishoSaijo__c);
        return JSON.serializePretty( it );
    }

    private Access createAccess(Saijo__c s){
        Access it = new Access();
        it.accessCar = String.isEmpty( s.AccessHohoKuruma__c ) ? '' : s.AccessHohoKuruma__c;
        it.accessBus = String.isEmpty( s.AccessHohoBasu__c ) ? '' : s.AccessHohoBasu__c;
        it.accessTrain = String.isEmpty( s.AccessHouhouDensha__c ) ? '' : s.AccessHouhouDensha__c;
        it.accessOther = String.isEmpty( s.AccessHohoBiko__c ) ? '' : s.AccessHohoBiko__c;
        return it;
    }

    private Integer resolveManagement(String val){
        if(val == '自社') return 0;
        if(val == '公営') return 1;
        if(val == '民営') return 2;
        if(val == '寺院') return 3;
        if(val == '寺院（本堂のみ）') return 4;
        return -1;
    }

    private Integer resolveTaioShuha(String val){
        if(val == '全宗派可') return 0;
        if(val == '全宗派可(新興宗教除く)') return -1;
        if(val == 'NG宗派あり') return -1;
        if(val == '自宗派のみ可(寺院斎場)') return -1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveShiminRyokinKubun(String val){
        if(val == '設定なし(一律同額)') return 0;
        if(val == '設定あり(2段階)') return 1;
        if(val == '設定あり(3段階)') return 2;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsAnchi(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveKaminshisetsuUmuKokubetsu(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '条件付き') return 2;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveKurumaisuTaio(String val){
        if(val == '不可') return 0;
        if(val == '可') return 1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsShinzokuHikae(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsElevator(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '不要') return 2;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsKasobaHeisetsu(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsKidsRoom(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsJunyushitsu(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsKurumaisuKashidashi(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '連絡あれば可') return 2;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsDiaperChangingTable(String val){
        if(val == '無') return 0;
        if(val == '有') return 1;
        if(val == '不明') return -1;
        return -1;
    }

    private Integer resolveIsRecommendedSaijo(boolean val){
        if(val == true) return 1;
        return 0;
    }
}