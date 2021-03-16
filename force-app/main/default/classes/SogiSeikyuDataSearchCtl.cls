public class SogiSeikyuDataSearchCtl {
    public List<ResultWrapper> resWrapList {get; set;}
    public List<ResultWrapper> tarWrapList {get; set;}
    public String seikyuHeaderId {get; set;}
    public List<MiSeikyuHeaderWrapper> miSeikyuHeaderWrapList {get; set;}
    public List<ResultWrapper> miSeikyuDetailWrapList {get; set;}
    public SearchJokenWrapper searchJokenWrapper {get;set;}
    private String oppSimpleRtId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
    private String searchText1 = 'select Id, ' + 
                                'ShodanBango__c, ' + 
                                'Utiagebi__c, ' + 
                                'Amount, ' + 
                                'NyukinSimekiriBiPartner__c, ' + 
                                'SeikyushoHassoubiPartner__c, ' + 
                                'SimpleYasugoRef__r.PlanNaiyo__c, ' + 
                                'SimpleYasugoRef__r.TaishoshaRef__r.LastName, ' +  
                                'SimpleYasugoRef__r.TaishoshaRef__r.FirstName, ' + 
                                'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, ' + 
                                'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id, ' + 
                                'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, ' + 
                                'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c, ' + 
                                'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.Id, ' + 
                                'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c, ' + 
                                '( ' + 
                                'select Id, ' + 
                                'Name, ' + 
                                'PartnerSeikyuSogishaRef__r.Id, ' + 
                                'PartnerSeikyuSogishaRef__r.Name, ' + 
                                'PartnerSeikyuSogishaRef__r.KokyakuId__c, ' + 
                                'PartnerSeikyuSogishaRef__r.SeikyuStatus__c, ' + 
                                'PartnerSeikyuSogishaRef__r.SeikyuSakuseiShaRef__r.LastName, ' + 
                                'PartnerSeikyuSogishaRef__r.SeikyuKakuninShaRef__r.LastName, ' + 
                                'PartnerSeikyuSogishaRef__r.SashimodoshiRiyu__c ' + 
                                'from ' + 
                                'OpportunityPartnerSeikyuMeisaiSogishas__r ' + 
                                'where id != null ';

    private String searchText2 = 'order by CreatedDate desc ' + 
                                'limit 1 ' +
                                ') ';

    private String searchText3 = ' from Opportunity ' + 
                                ' where RecordTypeId = :oppSimpleRtId' + 
                                ' and StageName = \'商談クローズ\' ' + 
                                ' and SeikyuYoteiGakuPartnerExp__c > 0 ';

    public class ResultWrapper {
        public Boolean isSelected {get; set;}
        public Opportunity opp {get; set;}
        public String keiyakuId {get; set;}
        public String sogishaId {get;set;}
        public String sogishaName {get;set;}
        public Boolean isPWebSokyakushoRenkei {get; set;}
        public Boolean isPWebSeikyushoRenkei {get; set;}
        public String seikyuStatus {get;set;}
        public String seikyuId {get;set;}
        public String seikyuName {get;set;}
        public String seikyuBango {get;set;}
        public String seikyuMeisaiId {get;set;}
        public String seikyuMeisaiBango {get;set;}
        public String seikyuSashimodoshiRiryu {get;set;}
        public String seikyuSakuseiSha {get;set;}
        public String seikyuKakuninSha {get;set;}
        public Boolean verified {get;set;}

        public ResultWrapper() {
            isSelected = false;
            opp = new Opportunity();
            keiyakuId = '';
            sogishaId = '';
            sogishaName = '';
            isPWebSokyakushoRenkei = false;
            isPWebSeikyushoRenkei = false;
            seikyuStatus = '';
            seikyuId = '';
            seikyuName = '';
            seikyuBango = '';
            seikyuMeisaiId = '';
            seikyuMeisaiBango = '';
            seikyuSashimodoshiRiryu = '';
            seikyuSakuseiSha = '';
            seikyuKakuninSha = '';
            verified = false;
        }
    }

    public class MiSeikyuHeaderWrapper {
        public PartnerSeikyuSogisha__c miSeikyuHeader {get; set;}

        public MiSeikyuHeaderWrapper() {
            miSeikyuHeader = new PartnerSeikyuSogisha__c();
        }
    }

    private Integer grDisplaySize = 200;
    public Integer grAllSize {get;set;}
    public Integer grPageSize {get;set;}
    public Integer grPageVal {get;set;}
    public Integer grPageFrom {get;set;}
    public Integer grPageTo {get;set;}
    public Integer grPageMax {get;set;}
    public List<SelectOption> grPageOpt {get;set;}
    public Boolean grFirstFlg {get;set;}
    public Boolean grBackFlg {get;set;}
    public Boolean grNextFlg {get;set;}
    public Boolean grLastFlg {get;set;}
    public Integer resWrapAllListSize {get;set;}

    public String ptWebEndPoint {get;set;}

    public class SearchJokenWrapper {

        public PartnerSeikyuSogisha__c partnerSeikyuJoken {get; set;}

        public String searchJokenSeikyuBango {get; set;}
        public String searchJokenSeikyushoSofuHohoValue {get; set;}
        public List<SelectOption> getSearchJokenSeikyushoSofuHohoOptions(){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--なし--'));
            options.add(new SelectOption('PWeb', 'PWeb'));
            options.add(new SelectOption('Fax', 'Fax'));
            return options;
        }

        public SearchJokenWrapper() {
            partnerSeikyuJoken = new PartnerSeikyuSogisha__c();
            searchJokenSeikyuBango = '';
            searchJokenSeikyushoSofuHohoValue = '';
        }
    }

    public SogiSeikyuDataSearchCtl () {}

    public void init(){
        resWrapList = new List<ResultWrapper>();
        tarWrapList = new List<ResultWrapper>();
        miSeikyuHeaderWrapList = new List<MiSeikyuHeaderWrapper>();
        miSeikyuDetailWrapList = new List<ResultWrapper>();
        searchJokenWrapper = new SearchJokenWrapper();
        seikyuHeaderId = '';
        
        Date kyo = Date.today();
        searchJokenWrapper.partnerSeikyuJoken.KensakuyoUriagebiFrom__c = Date.newInstance(kyo.year(), kyo.month(), 1);
        searchJokenWrapper.partnerSeikyuJoken.KensakuyoUriagebiTo__c = Date.newInstance(kyo.year(), kyo.month(), 31);

        grAllSize = 0;
        grPageSize = 0;
        grPageVal = 0;
        grPageFrom = 0;
        grPageTo = 0;
        grPageMax = 0;
        grFirstFlg = true;
        grBackFlg = true;
        grNextFlg = true;
        grLastFlg = true;

        resWrapAllListSize = 0;

        ptWebEndPoint = PtWebApi_Configs.getConfig().BaseEndPoint__c;
    }

    public String pSortItem{get;set;}
    public String pSortKey{get;set;}

    public void searchData(){
        errorMessage1 = '';
        List<ResultWrapper> allResWrapList = new List<ResultWrapper>();
        resWrapList = new List<ResultWrapper>();
        
        Date uriagebiFrom = searchJokenWrapper.partnerSeikyuJoken.KensakuyoUriagebiFrom__c;
        Date uriagebiTo = searchJokenWrapper.partnerSeikyuJoken.KensakuyoUriagebiTo__c;
        String sogishaId = searchJokenWrapper.partnerSeikyuJoken.PartnerKeiyakuRef__c;
        String seikyuStatus = searchJokenWrapper.partnerSeikyuJoken.SeikyuStatus__c;
        String seikyuBango = searchJokenWrapper.searchJokenSeikyuBango;
        Date seikyushoHassobi = searchJokenWrapper.partnerSeikyuJoken.KensakuyoSeikyushoHassobi__c;
        String seikyuHoho = searchJokenWrapper.searchJokenSeikyushoSofuHohoValue;

        if(pSortItem == null || pSortItem == ''){
            pSortItem = 'SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c';
        }

        String tempSortItem = Apexpages.currentPage().getParameters().get('pSortItem');
        if(tempSortItem != null && tempSortItem != ''){
            pSortItem = tempSortItem;
        }
        
        if(pSortKey == null || pSortKey == ''){
            pSortKey = 'asc';
        }

        String tempSortKey = Apexpages.currentPage().getParameters().get('pSortKey');
        if(tempSortKey != null && tempSortKey != ''){
            pSortKey = tempSortKey;
        }

        String tempSearchText1 = searchText1;
        if(String.isNotEmpty(seikyuBango) && seikyuBango != null && seikyuBango != 'null'){
            tempSearchText1 += 'and PartnerSeikyuSogishaRef__r.KokyakuId__c = :seikyuBango ';
        }

        String tempSearchText3 = searchText3;
        if(String.isNotEmpty(sogishaId) && sogishaId != null && sogishaId != 'null'){
            tempSearchText3 += 'and SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c = :sogishaId ';
        }

        if(uriagebiFrom != null){
            tempSearchText3 += ' and Utiagebi__c >= :uriagebiFrom ';
        }

        if(uriagebiTo != null){
            tempSearchText3 += ' and Utiagebi__c <= :uriagebiTo ';
        }

        if(String.isNotBlank(seikyuHoho)){
        System.debug('seikyuHoho:' + seikyuHoho);
            tempSearchText3 += ' and SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c includes (:seikyuHoho) ';
        }

        if(seikyushoHassobi != null){
            tempSearchText3 += ' and SeikyushoHassoubiPartner__c = :seikyushoHassobi ';
        }

        String offSetNum = Apexpages.currentPage().getParameters().get('pGrPageVal');
        if(offSetNum == null || offSetNum == ''){
            offSetNum = '0';
        }
        else{
            Integer iOffSetNum = Integer.valueOf(offSetNum);
            if(iOffSetNum > 0) iOffSetNum = iOffSetNum - 1;
            offSetNum = String.valueOf(iOffSetNum * grDisplaySize);
        }

        for(Opportunity sltOpp : Database.query(tempSearchText1 + searchText2 + tempSearchText3 + ' order by ' + pSortItem + ' ' + pSortKey + ' limit 2000')){

            ResultWrapper rw = new ResultWrapper();
            rw.opp = sltOpp;
            rw.keiyakuId = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c;
            rw.sogishaId = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id;
            rw.sogishaName = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name;
            rw.isPWebSokyakushoRenkei = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.Id != null ? true : false;
            rw.isPWebSeikyushoRenkei = false;
            if(String.isNotBlank(sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c)){
                if(sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c.indexOf('PWeb') > -1){
                    rw.isPWebSeikyushoRenkei = true;
                }
            }
            if(sltOpp.OpportunityPartnerSeikyuMeisaiSogishas__r.size() > 0){
                PartnerSeikyuMeisaiSogisha__c psms = sltOpp.OpportunityPartnerSeikyuMeisaiSogishas__r.get(0);
                rw.seikyuStatus = psms.PartnerSeikyuSogishaRef__r.SeikyuStatus__c;
                rw.seikyuId = psms.PartnerSeikyuSogishaRef__r.Id;
                rw.seikyuName = psms.PartnerSeikyuSogishaRef__r.Name;
                rw.seikyuBango = psms.PartnerSeikyuSogishaRef__r.KokyakuId__c;
                rw.seikyuMeisaiId = psms.Id;
                rw.seikyuMeisaiBango = psms.Name;
                rw.seikyuSashimodoshiRiryu = psms.PartnerSeikyuSogishaRef__r.SashimodoshiRiyu__c;
                rw.seikyuSakuseiSha = psms.PartnerSeikyuSogishaRef__r.SeikyuSakuseiShaRef__r.LastName;
                rw.seikyuKakuninSha = psms.PartnerSeikyuSogishaRef__r.SeikyuKakuninShaRef__r.LastName;
            }
            else{
                rw.seikyuStatus = '未作成';
            }

            if((String.isNotEmpty(seikyuStatus) && String.isNotEmpty(seikyuBango) && seikyuStatus == rw.seikyuStatus && seikyuBango == rw.seikyuBango) || 
                (String.isEmpty(seikyuStatus) && String.isNotEmpty(seikyuBango) && seikyuBango == rw.seikyuBango) || 
                (String.isNotEmpty(seikyuStatus) && String.isEmpty(seikyuBango) && seikyuStatus == rw.seikyuStatus) || 
                (String.isEmpty(seikyuStatus) && String.isEmpty(seikyuBango))){

                allResWrapList.add(rw);
            }
        }

        resWrapAllListSize = allResWrapList.size();

        List<Id> removeOppIdList = new List<Id>();
        for(ResultWrapper tarWrap : tarWrapList){
            removeOppIdList.add(tarWrap.opp.Id);
        }
        List<PartnerSeikyuMeisaiSogisha__c> removePSMSList = [select Id, 
                                                                    OpportunityRef__c  
                                                                from PartnerSeikyuMeisaiSogisha__c 
                                                                where PartnerSeikyuSogishaRef__r.SeikyuStatus__c in ('確認中', '請求済') and 
                                                                    OpportunityRef__c = :removeOppIdList];

        for(Integer i=0; i<tarWrapList.size(); i++){
            ResultWrapper tarWrap = tarWrapList.get(i);
            for(PartnerSeikyuMeisaiSogisha__c removePSMS : removePSMSList ){
                if(tarWrap.opp.Id == removePSMS.OpportunityRef__c){
                    tarWrapList.remove(i);
                    i--;
                }
            }
        }

        grFirstFlg = false;
        grBackFlg = false;
        grNextFlg = false;
        grLastFlg = false;

        String pGrPageVal = Apexpages.currentPage().getParameters().get('pGrPageVal');
        if(pGrPageVal == null || pGrPageVal == ''){
            pGrPageVal = '1';
        }

        resWrapList = new List<ResultWrapper>();
        Integer iGrPageVal = Integer.valueOf(pGrPageVal);
        Integer iFirst = (iGrPageVal - 1) * 200;
        Integer iLast = iFirst + 200;
        for(Integer i = iFirst; i < iLast; i++){
            if(allResWrapList.size() < i+1) break;
            resWrapList.add(allResWrapList.get(i));
        }

        grAllSize = resWrapAllListSize;
        grPageSize = grAllSize / grDisplaySize;
        grPageMax = grPageSize;
        if(grAllSize > grDisplaySize * grPageSize){
            grPageMax++;
        }
        grPageVal = iGrPageVal;
        grPageOpt = new List<SelectOption>();
        for(Integer i = 1; i <= grPageMax; i++){
            grPageOpt.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        grPageFrom = grAllSize == 0 ? 0 : (grPageVal - 1) * grDisplaySize + 1;
        grPageTo = grPageVal * grDisplaySize;

        if(grPageTo >  grAllSize) grPageTo = grAllSize;
        if(grPageMax <= iGrPageVal) grNextFlg = true;
        if(grPageMax == iGrPageVal) grLastFlg = true;
        if(1 >= iGrPageVal) grBackFlg = true;
        if(1 == iGrPageVal) grFirstFlg = true;
    }

    public void chkAccountNumberTargetWrapList(){
        
        alertMessage1 = '';
        String tempAccontNumber = '';
        for(ResultWrapper tarWrap : tarWrapList){
            if(tempAccontNumber == ''){
                tempAccontNumber = tarWrap.opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c;
                continue;
            }
            
            if(tempAccontNumber != tarWrap.opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c){
                alertMessage1 = '複数の葬儀社が選択されています。';
            }
        }
    }

    public void chkAccountNumberMiSeikyuDetailWrapList(){
        
        alertMessage2 = '';
        String tempAccontNumber = '';
        for(ResultWrapper miSeikyuDetailWrap : miSeikyuDetailWrapList){
            if(tempAccontNumber == ''){
                tempAccontNumber = miSeikyuDetailWrap.opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c;
                continue;
            }
            
            if(tempAccontNumber != miSeikyuDetailWrap.opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c){
                alertMessage2 = '複数の葬儀社が選択されています。';
            }
        }
    }

    public void addTargetList(){
        
        errorMessage1 = '';
        for(ResultWrapper resWrap : resWrapList){
            if(resWrap.isSelected){
                Boolean addFlg = true;
                for(ResultWrapper tarWrap : tarWrapList){
                    if(resWrap.opp.ShodanBango__c == tarWrap.opp.ShodanBango__c){
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ResultWrapper tarWrap = resWrap;
                    tarWrap.isSelected = false;
                    tarWrapList.add(resWrap);
                }
            }
        }
        
        sltSeikyuSakiSogishaList();
    }

    public void delTargetList(){

        errorMessage1 = '';
        seikyuHeaderId = '';
        for(Integer i=0; i<tarWrapList.size(); i++){
            ResultWrapper tarWrap = tarWrapList.get(i);
            if(tarWrap.isSelected){
                tarWrapList.remove(i);
                i--;
            }
        }

        sltSeikyuSakiSogishaList();
    }

    public String errorMessage1{get;set;}
    public String alertMessage1{get;set;}
    public String alertMessage2{get;set;}
    public void checkSeikyuKakuninIrai(){

        errorMessage1 = '';

        List<Id> targetIdList = new List<Id>();
        for(ResultWrapper tarWrap : tarWrapList){
            targetIdList.add(tarWrap.opp.Id);
        }

        List<Opportunity> chkOppList = [select Id, 
                                                ShodanBango__c, 
                                            (
                                            select Id 
                                            from OpportunityPartnerSeikyuMeisaiSogishas__r 
                                            where PartnerSeikyuSogishaRef__r.SeikyuStatus__c in ('確認中', '請求済')
                                            ) 
                                        from Opportunity 
                                        where Id = :targetIdList];
        Boolean isSubmission = false;
        String ngShodanBango = '';
        for(Opportunity chkOpp : chkOppList){
            if(chkOpp.OpportunityPartnerSeikyuMeisaiSogishas__r.size() > 0){
                isSubmission = true;
                ngShodanBango += chkOpp.ShodanBango__c + ' ';
            }
        }

        if(isSubmission){
            errorMessage1 = ngShodanBango + 'は請求済または確認中です。';
        }
    }

    public void checkAddSeikyuKakuninIrai(){

    }

    private void sltSeikyusakiSogishaList(){

        seikyuHeaderId = '';
        miSeikyuHeaderWrapList = new List<MiSeikyuHeaderWrapper>();
        miSeikyuDetailWrapList = new List<ResultWrapper>();

        if(tarWrapList.size() == 0) return;

        Set<String> keiyakuIdSet = new Set<String>();
        for(ResultWrapper tarWrap : tarWrapList) keiyakuIdSet.add(tarWrap.keiyakuId);

        for(PartnerSeikyuSogisha__c header : [select Id, 
                                                SeikyuStatus__c,
                                                KokyakuId__c,
                                                SeikyuKingaku__c,
                                                ShiharaiKijitsu__c,
                                                Seikyubi__c,
                                                NyukinShimekiribi__c,
                                                PartnerKeiyakuRef__r.Teikeisaki__c,
                                                PartnerKeiyakuRef__r.Teikeisaki__r.Name,
                                                PartnerKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c 
                                                from PartnerSeikyuSogisha__c 
                                                where PartnerKeiyakuRef__c = :keiyakuIdSet 
                                                and SeikyuStatus__c = '確認中'
                                                order by CreatedDate desc]){
            MiSeikyuHeaderWrapper wrap = new MiSeikyuHeaderWrapper();
            wrap.miSeikyuHeader = header;
            miSeikyuHeaderWrapList.add(wrap);
        }
    }

    public void displaySeikyuSogishaDetail(){
        seikyuHeaderId = Apexpages.currentPage().getParameters().get('seikyuHeaderId');
        Set<Id> oppIdSet = new Set<Id>();
        Set<Id> detailIdSet = new Set<Id>();
        for(PartnerSeikyuMeisaiSogisha__c detail : [select Id, OpportunityRef__c 
                                                    from PartnerSeikyuMeisaiSogisha__c 
                                                    where PartnerSeikyuSogishaRef__c = :seikyuHeaderId]){
            oppIdSet.add(detail.OpportunityRef__c);
            detailIdSet.add(detail.Id);
        }

        miSeikyuDetailWrapList = new List<ResultWrapper>();
        for(Opportunity sltOpp : [select 
                                        Id, 
                                        ShodanBango__c, 
                                        Utiagebi__c, 
                                        Amount, 
                                        NyukinSimekiriBiPartner__c, 
                                        SeikyushoHassoubiPartner__c, 
                                        SimpleYasugoRef__r.PlanNaiyo__c, 
                                        SimpleYasugoRef__r.TaishoshaRef__r.LastName, 
                                        SimpleYasugoRef__r.TaishoshaRef__r.FirstName, 
                                        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                                        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id, 
                                        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, 
                                        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBangoF__c, 
                                        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.Id, 
                                        SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c, 
                                        (
                                            select 
                                                Id, 
                                                Name, 
                                                Verified__c, 
                                                PartnerSeikyuSogishaRef__r.Id, 
                                                PartnerSeikyuSogishaRef__r.Name, 
                                                PartnerSeikyuSogishaRef__r.KokyakuId__c, 
                                                PartnerSeikyuSogishaRef__r.SeikyuStatus__c, 
                                                PartnerSeikyuSogishaRef__r.SeikyuSakuseiShaRef__r.LastName, 
                                                PartnerSeikyuSogishaRef__r.SeikyuKakuninShaRef__r.LastName, 
                                                PartnerSeikyuSogishaRef__r.SashimodoshiRiyu__c 
                                            from OpportunityPartnerSeikyuMeisaiSogishas__r 
                                            where id = :detailIdSet 
                                        ) 
                                    from Opportunity 
                                    where Id = :oppIdSet]){
            ResultWrapper rw = new ResultWrapper();
            rw.opp = sltOpp;
            rw.keiyakuId = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c;
            rw.sogishaId = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id;
            rw.sogishaName = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name;
            rw.isPWebSokyakushoRenkei = sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.PtWebAccountRef__r.Id != null ? true : false;
            rw.isPWebSeikyushoRenkei = false;
            if(String.isNotBlank(sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c)){
                if(sltOpp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.SogiSeikyushoSoshinKubun__c.indexOf('PWeb') > -1){
                    rw.isPWebSeikyushoRenkei = true;
                }
            }
            PartnerSeikyuMeisaiSogisha__c psms = sltOpp.OpportunityPartnerSeikyuMeisaiSogishas__r.get(0);
            rw.seikyuStatus = psms.PartnerSeikyuSogishaRef__r.SeikyuStatus__c;
            rw.seikyuId = psms.PartnerSeikyuSogishaRef__r.Id;
            rw.seikyuName = psms.PartnerSeikyuSogishaRef__r.Name;
            rw.seikyuBango = psms.PartnerSeikyuSogishaRef__r.KokyakuId__c;
            rw.seikyuMeisaiId = psms.Id;
            rw.seikyuMeisaiBango = psms.Name;
            rw.seikyuSashimodoshiRiryu = psms.PartnerSeikyuSogishaRef__r.SashimodoshiRiyu__c;
            rw.seikyuSakuseiSha = psms.PartnerSeikyuSogishaRef__r.SeikyuSakuseiShaRef__r.LastName;
            rw.seikyuKakuninSha = psms.PartnerSeikyuSogishaRef__r.SeikyuKakuninShaRef__r.LastName;
            rw.verified = psms.Verified__c;
            miSeikyuDetailWrapList.add(rw);
        }
    }
    
    public void addMiSeikyuDetailList(){

        errorMessage1 = '';
        
        for(ResultWrapper tarWrap : tarWrapList){
            if(tarWrap.isSelected){
                Boolean addFlg = true;
                for(ResultWrapper miSeikyu : miSeikyuDetailWrapList){
                    if(tarWrap.opp.ShodanBango__c == miSeikyu.opp.ShodanBango__c){
                        addFlg = false;
                        break;
                    }
                    if(tarWrap.seikyuStatus == '請求済' || tarWrap.seikyuStatus == '確認中'){
                        errorMessage1 = tarWrap.opp.ShodanBango__c + 'は請求済または確認中です。';
                        addFlg = false;
                        break;
                    }
                    if(tarWrap.opp.SeikyushoHassoubiPartner__c != miSeikyu.opp.SeikyushoHassoubiPartner__c){
                        errorMessage1 = tarWrap.opp.ShodanBango__c + 'は請求発送日が異なります。';
                        addFlg = false;
                        break;
                    }
                }

                if(addFlg){
                    ResultWrapper miSeikyuWrap = tarWrap.clone();
                    miSeikyuWrap.isSelected = false;
                    miSeikyuDetailWrapList.add(miSeikyuWrap);
                }
            }
        }
    }

    public void delMiseikyuDetailgetList(){
        for(Integer i=0; i<miSeikyuDetailWrapList.size(); i++){
            ResultWrapper miSeikyuDetailWrap = miSeikyuDetailWrapList.get(i);
            if(miSeikyuDetailWrap.isSelected){
                miSeikyuDetailWrapList.remove(i);
                i--;
            }
        }
    }
}