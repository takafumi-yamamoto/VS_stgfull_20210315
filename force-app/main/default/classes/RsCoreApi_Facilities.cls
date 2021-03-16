public class RsCoreApi_Facilities {

    private class Access{
        public String accessTrain { get; private set; }
        public String accessBus { get; private set; }
        public String accessCar { get; private set; }
        public String accessOther { get; private set; }
    }

    private class FacilityInfoSaijo{
        public Long facilityId { get; private set; }
        public String facilityKind { get; private set; }
        public Long areaCode { get; private set; }
        public Long prefectureId { get; private set; }
        public String name { get; private set; }
        public String tel1 { get; private set; }
        public String streetAddress { get; private set; }
        public Long zipCode { get; private set; }
        public String title { get; private set; }
        public String description { get; private set; }
        public Integer parkingLots { get; private set; }
        public Integer isAnchi { get; private set; }
        public Integer isShinzokuHikae { get; private set; }
        public Access access { get; private set; }
        public Integer isZenShuha { get; private set; }
        public Integer isShowerRoom { get; private set; }
        public Integer isStayRoom { get; private set; }
        public Integer isBarrierFree { get; private set; }
        public String closeDay { get; private set; }
        public String organiser { get; private set; }
        public Integer management { get; private set; }
        public Integer isAnchiMenkai { get; private set; }
        public Integer isSaijoTsukisoi { get; private set; }
        public Integer isKidsRoom { get; private set; }
        public Integer isBabyRoom { get; private set; }
        public Integer isHoyo { get; private set; }
        public Integer planKaso { get; private set; }
        public Integer planOneDay { get; private set; }
        public Integer planKazoku { get; private set; }
        public Integer planIppan { get; private set; }
        public String simpleStatus { get; private set; }
        public Decimal latitude { get; private set; }
        public Decimal longitude { get; private set; }
    }

    private class FacilityInfoKasoba{
        public Long facilityId { get; private set; }
        public String facilityKind { get; private set; }
        public Long areaCode { get; private set; }
        public Long prefectureId { get; private set; }
        public String name { get; private set; }
        public String tel1 { get; private set; }
        public String streetAddress { get; private set; }
        public Long zipCode { get; private set; }
        public String title { get; private set; }
        public String description { get; private set; }
        public Integer parkingLots { get; private set; }
        public Integer isAnchi { get; private set; }
        public Integer isShinzokuHikae { get; private set; }
        public Access access { get; private set; }
        public String simpleStatus { get; private set; }
        public Decimal latitude { get; private set; }
        public Decimal longitude { get; private set; }
        public Integer isSaijoHeisetsu { get; private set; }
    }

    public String createFacilityInfoSaijoJson(Shisetsu__c s, Boolean pIsDelete){
        FacilityInfoSaijo theEntity = this.createFacilityInfoSaijo(s);
        if(pIsDelete) theEntity.simpleStatus = 'disable';
        return JSON.serializePretty( theEntity );
    }

    public String createFacilityInfoKasobaJson(Shisetsu__c s, Boolean pIsDelete){
        FacilityInfoKasoba theEntity = this.createFacilityInfoKasoba(s);
        if(pIsDelete) theEntity.simpleStatus = 'disable';
        return JSON.serializePretty( theEntity );
    }

    private FacilityInfoSaijo createFacilityInfoSaijo(Shisetsu__c s){
        FacilityInfoSaijo it = new FacilityInfoSaijo();
        it.facilityId = Long.valueOf(s.SaijoKeisaiJohoId__c);
        it.facilityKind = 'saijo';
        it.areaCode = String.isEmpty(s.AreaCode__c) ? 0 : Long.valueOf(s.AreaCode__c);
        it.prefectureId = String.isEmpty(s.TodoufukenCodeExp__c) ? 0 : Long.valueOf(s.TodoufukenCodeExp__c);
        it.name = s.name;
        it.tel1 = String.isEmpty(s.Phone1__c) ? '' : TelNos.toNumber(s.Phone1__c);
        it.streetAddress = String.isEmpty(s.Street__c) ? '' : s.Street__c;
        it.zipCode = String.isEmpty(s.PostalCode__c) ? 0 : Long.valueOf(PostalCodes.toNumber(s.PostalCode__c));
        it.title = String.isEmpty(s.TitleSaijo__c) ? '' : s.TitleSaijo__c;
        it.description = String.isEmpty(s.TokuchoSaijo__c) ? '' : s.TokuchoSaijo__c;
        it.parkingLots = s.Chushadaisu__c == null ? 0 : (Integer)s.Chushadaisu__c;
        it.isAnchi = s.AnchiKa__c ? 1 : 0;
        it.isShinzokuHikae = s.ShinzokuHikaeshitsuAri__c ? 1 : 0;
        it.access = this.createAccess(s);
        it.isZenShuha = s.ZenShuhaTaioKa__c ? 1 : 0;
        it.isShowerRoom = s.ShawaRoomAri__c ? 1 : 0;
        it.isStayRoom = s.ShukuhakuKa__c ? 1 : 0;
        it.isBarrierFree = s.Bariafuri__c ? 1 : 0;
        it.closeDay = String.isEmpty(s.CloseDay__c) ? '' : s.CloseDay__c;
        it.organiser = String.isEmpty(s.Organiser__c) ? '' : s.Organiser__c;
        it.management = this.resolveManagement(s.KoeiMinei__c);
        it.isAnchiMenkai = s.AnchiMenkaiKa__c ? 1 : 0;
        it.isSaijoTsukisoi = s.TsukisoiAnchiKa__c ? 1 : 0;
        it.isKidsRoom = s.KizzuRoomAri__c ? 1 : 0;
        it.isBabyRoom = s.BebiRoomAri__c ? 1 : 0;
        it.isHoyo = s.HoyoKa__c ? 1 : 0;
        it.planKaso = s.KasoshikiKa__c ? 1 : 0;
        it.planOneDay = s.IchinichisoKa__c ? 1 : 0;
        it.planKazoku = s.KazokusoKa__c ? 1 : 0;
        it.planIppan = s.IppansoKa__c ? 1 : 0;
        it.simpleStatus = s.IsSaijoSimpleKeisaiExp__c ? 'enable' : 'disable';
        it.latitude = s.IdoKedo__latitude__s == null ? 0 : s.IdoKedo__latitude__s;
        it.longitude = s.IdoKedo__longitude__s == null ? 0 : s.IdoKedo__longitude__s;
        return it;
    }
    private FacilityInfoKasoba createFacilityInfoKasoba(Shisetsu__c s){
        FacilityInfoKasoba it = new FacilityInfoKasoba();
        it.facilityId = Long.valueOf(s.KasobaKeisaiJohoId__c);
        it.facilityKind = 'kasoba';
        it.areaCode = String.isEmpty(s.AreaCode__c) ? 0 : Long.valueOf(s.AreaCode__c);
        it.prefectureId = String.isEmpty(s.TodoufukenCodeExp__c) ? 0 : Long.valueOf(s.TodoufukenCodeExp__c);
        it.name = s.name;
        it.tel1 = String.isEmpty(s.Phone1__c) ? '' : TelNos.toNumber(s.Phone1__c);
        it.streetAddress = String.isEmpty(s.Street__c) ? '' : s.Street__c;
        it.zipCode = String.isEmpty(s.PostalCode__c) ? 0 : Long.valueOf(PostalCodes.toNumber(s.PostalCode__c));
        it.title = String.isEmpty(s.TitleKasoba__c) ? '' : s.TitleKasoba__c;
        it.description = String.isEmpty(s.TokuchoKasoba__c) ? '' : s.TokuchoKasoba__c;
        it.parkingLots = s.Chushadaisu__c == null ? 0 : (Integer)s.Chushadaisu__c;
        it.isAnchi = s.AnchiKa__c ? 1 : 0;
        it.isShinzokuHikae = s.KasoMachiaiShitsuAri__c ? 1 : 0;
        it.access = this.createAccess(s);
        it.simpleStatus = s.IsKasobaSimpleKeisaiExp__c ? 'enable' : 'disable';
        it.latitude = s.IdoKedo__latitude__s == null ? 0 : s.IdoKedo__latitude__s;
        it.longitude = s.IdoKedo__longitude__s == null ? 0 : s.IdoKedo__longitude__s;

        it.isSaijoHeisetsu = -1;
        if(s.HeisetsuKubun__c == '非併設') it.isSaijoHeisetsu = 0;
        if(s.HeisetsuKubun__c == '併設') it.isSaijoHeisetsu = 1;
        
        return it;
    }
    private Access createAccess(Shisetsu__c s){
        Access it = new Access();
        it.accessCar = String.isEmpty( s.AccessHohoKuruma__c ) ? '' : s.AccessHohoKuruma__c;
        it.accessBus = String.isEmpty( s.AccessHohoBasu__c ) ? '' : s.AccessHohoBasu__c;
        it.accessTrain = String.isEmpty( s.AccessHouhouDensha__c ) ? '' : s.AccessHouhouDensha__c;
        it.accessOther = String.isEmpty( s.AccessHohoSonota__c ) ? '' : s.AccessHohoSonota__c;
        return it;
    }
    private Integer resolveManagement(String pKoueiMinei){
        if(pKoueiMinei == '公営') return 0;
        if(pKoueiMinei == '民営') return 1;
        if(pKoueiMinei == '自社') return 1;
        if(pKoueiMinei == '寺院') return 2;
        return -1;
    }
}