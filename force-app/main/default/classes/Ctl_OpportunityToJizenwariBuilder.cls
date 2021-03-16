/**
 * 事前割のサービスビルダー
 */
public class Ctl_OpportunityToJizenwariBuilder implements Ctl_IOpportunityToServiceBuilder{

    public List<Opportunity> opps;
    public Ctl_OpportunityToJizenwariBuilder () {
        opps = new List<Opportunity>();
    }   
    public void addOpp(Opportunity opp) {
        opps.add(opp);
    }    
    
    public List<Dto_OpportunityServicePair> getOpportunityServicePairList() {
        List<Dto_OpportunityServicePair> pairList = new List<Dto_OpportunityServicePair>();
        set<id> caseIdset = new set<id>();
        for(Opportunity opp : opps) {
            caseIdset.add(opp.CaseRef__c);
        }
        map<id,case> caseMap=new map<id,case>([select id,
                                                      KiboAreaState__c,
                                                      KiboAreaCity__c,
                                                      TaishoushaJokyo__c,
                                                      KiboPlan__c,
                                                      ShiryoHoyu__c,
                                                      SId__c,
                                                      Description
                                                 from case 
                                                where id in :caseIdset]);

        JizenWariPlan__c theJizenWariPlan = [SELECT Id FROM JizenWariPlan__c WHERE Code__c = 'Yoriso' LIMIT 1];

        for(Opportunity opp : opps) {
            Case theCase=caseMap.get(opp.CaseRef__c);
            Dto_OpportunityServicePair theOppServicePair = this.createDto_OpportunityServicePair(opp, theCase,theJizenWariPlan);
            pairList.add(theOppServicePair); 
        }
        return pairList;
    }

    @TestVisible
    private Dto_OpportunityServicePair createDto_OpportunityServicePair(Opportunity pOpportunity, Case pCase, JizenWariPlan__c pJizenWariPlan){
        Case c = pCase; 
        Opportunity opp = pOpportunity;
        Jizenwari__c service = new Jizenwari__c();

        if (c!=null){
            Ctl_JizenwariJson2Apex j2Ap  = Ctl_JizenwariJson2Apex.parse(c.Description);

            service.KiboAreaRef__c       = getKiboAreaId(c.KiboAreaState__c, c.KiboAreaCity__c);
            service.SogiPlan__c          = c.KiboPlan__c;
            service.Owns_material__c     = c.ShiryoHoyu__c;
            service.JizenWariPlanRef__c  = pJizenWariPlan.Id;
            opp.TaishoushaJokyo__c       = c.TaishoushaJokyo__c;
            opp.StageName                = '申込';
            opp.SubPhase__c = this.resolveSubPhaseByJsonData(j2Ap);
            opp.ShiryoSoufuSakiAtena__c = this.resolveAtena(j2Ap);
            opp.ShiryoSoufuSakiAtenaKana__c = this.resolveAtenaKana(j2Ap);
            opp.ShiryoSoufuSakiPostalCode__c = String.isBlank(j2Ap.address_post) ? '' : j2Ap.address_post.left(255);
            opp.ShiryoSoufuSakiState__c = String.isBlank(j2Ap.address_state) ? '' : j2Ap.address_state.left(255);
            opp.ShiryoSoufuSakiCity__c = String.isBlank(j2Ap.address_city) ? '' : j2Ap.address_city.left(255);
            opp.ShiryoSoufuSakiStreet__c = String.isBlank(j2Ap.address_street) ? '' : j2Ap.address_street.left(255);
            opp.ShiryoSoufuSakiMailAddress__c = String.isBlank(j2Ap.email) ? '' : j2Ap.email;
        }
        service.KeiyakuSha__c = opp.AccountId;
        return new Dto_OpportunityServicePair(opp, service);
    }

    private String resolveSubPhaseByJsonData(Ctl_JizenwariJson2Apex pJsonData){
        if(pJsonData.payment_type == 'コンビニ払い（伝票払い）') return '申込完了（伝票発送待ち）-jizenwari';
        if(pJsonData.payment_type == 'クレジットカード決済') return '事前割-申込完了（決済完了待ち）-jizenwari';
        if(pJsonData.payment_type == 'コンビニ払い（コンビニ端末操作）') return '事前割-申込完了（決済完了待ち）-jizenwari';
        return '';
    }
    private String resolveAtena(Ctl_JizenwariJson2Apex pJsonData){
        List<String> theNames = new List<String>();
        if( !String.isBlank(pJsonData.last_name) ) theNames.add(pJsonData.last_name);
        if( !String.isBlank(pJsonData.first_name) ) theNames.add(pJsonData.first_name);
        return String.join(theNames, ' ').left(255);
    }
    private String resolveAtenaKana(Ctl_JizenwariJson2Apex pJsonData){
        List<String> theNames = new List<String>();
        if( !String.isBlank(pJsonData.last_name_kana) ) theNames.add(pJsonData.last_name_kana);
        if( !String.isBlank(pJsonData.first_name_kana) ) theNames.add(pJsonData.first_name_kana);
        return  String.join(theNames, ' ').left(255);
    }
    /**
     * 希望エリアID取得
     * @param  state 都道府県
     * @param  city  市区群(+町名、市区群Name項目形式)
     * @return       市区群ID
     */ 
    private Id getKiboAreaId(String state, String city) {
        List<Shikugun__c> kiboAreaList = Dao_Shikugun.SearchShikugunByFullName(state + city);
        if(!kiboAreaList.isEmpty()) {
            return kiboAreaList[0].id;
        }
        return null;
    }   
}