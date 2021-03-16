public class SogiShiryoIkkatuInsatuSearchCtl {
    
    //検索条件表示用の変数
    public SearchJokenWrapper searchJokenWrapper {get;set;}

    //検索結果一覧表示用の変数
    public List<ResultWrapper> resWrapList {get; set;}

    //送付状況更新時選択項目用の変数
    public String SoufujoukyoSelect {get; set;}

    //送付状況更新時選択項目用のオプション
    public List<SelectOption> SoufujoukyoOpt {get; set;}

    //検索結果、1ページに表示する件数
    public Integer grDisplaySize = 200;

    //検索結果「全て」のチェックボックス用のサイズ変数
    public Integer resWrapAllListSize {get;set;}

    //検索結果　ページ内の開始件数
    public Integer grPageFrom {get;set;}
    //検索結果　ページ内の終了件数
    public Integer grPageTo {get;set;}
    //検索結果最大MAX件数
    public Integer grAllSize {get;set;}
    //検索結果の表示可能ページ数の初期値
    public Integer grPageVal {get;set;}
    //検索結果の表示可能ページ数のリスト
    public List<SelectOption> grPageOpt {get;set;}
    //検索結果の最大表示ページ数
    public Integer grPageMax {get;set;}
    //検索結果　最初のページに移動するフラグ
    public Boolean grFirstFlg {get;set;}
    //検索結果　前ページの移動するフラグ
    public Boolean grBackFlg {get;set;}
    //検索結果　後ページの移動するフラグ
    public Boolean grNextFlg {get;set;}
    //検索結果　最後のページの移動するフラグ
    public Boolean grLastFlg {get;set;}
    
    //検索結果の表示ページ数
    public Integer grPageSize {get;set;}

    //検索結果のヘッター項目でソートする際の項目格納用変数
    public String pSortItem{get;set;}

    //検索結果のヘッター項目でソートする際の降順・昇順の設定
    public String pSortKey{get;set;}

    private String searchText1 = 'Id, ' + 
                                'Name , ' + 
                                'PamphletYohi__c, ' + 
                                'Atena__c, ' + 
                                'InsatsubutsuIchiran__c, ' + 
                                'SearchAddress__c, ' + 
                                'SearchSofubi__c, ' + 
                                'SearchInsatsubi__c, ' + 
                                'SearchSofuShiryoURLUmu__c, ' + 
                                'SearchKiboArea__c, ' + 
                                'HikitsugiJiko__c, ' + 
                                'IsogiTaio__c, ' + 
                                'Kinkyudo__c, ' + 
                                'City__c, ' + 
                                'OpportunityRef__c, ' + 
                                'OpportunityRef__r.id, ' + 
                                'OpportunityRef__r.name, ' + 
                                'OpportunityRef__r.ShodanBango__c, ' + 
                                'OpportunityRef__r.StageName, ' + 
                                'SofuShubetsu__c, ' + 
                                'SofuJokyo__c, ' + 
                                'SofuNichiji__c, ' + 
                                'InsatsuNichiji__c, ' + 
                                'TaSofubutsu__c, ' + 
                                'TaSofubutsu1__c, ' + 
                                'TaSofubutsu2__c, ' + 
                                'TaSofubutsu3__c, ' + 
                                'Street__c, ' + 
                                'State__c, ' + 
                                'YusoShubetsu__c, ' + 
                                'PostalCode__c, ' + 
                                'SofuShiryoURL__c, ' + 
                                'MitumorishoUmu__c, ' + 
                                'Insatsusha__c, ' +
                                'SogiShiryoSakuseiKekkaRef__c ';

    private String searchText2 = 'from ' + 
                                'SogiShiryoSofu__c ';

    public SogiShiryoIkkatuInsatuSearchCtl () {
        
    }

    //初期表示処理
    public void init(){ 
        resWrapList = new List<ResultWrapper>();
        searchJokenWrapper = new SearchJokenWrapper();
        searchJokenWrapper.SogiShiryoSofuJoken.SofuJokyo__c = '印刷待ち';
        searchJokenWrapper.SogiShiryoSofuJoken.SofuShubetsu__c = '郵便';

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
        
        SoufujoukyoSelect = '';
        SoufujoukyoOpt = new List<SelectOption>();
        List<Schema.PicklistEntry> SoufujoukyoPicklist = getPicklist('SogiShiryoSofu__c','SofuJokyo__c');
        for(Schema.PicklistEntry SoufujoukyoPicklis :SoufujoukyoPicklist){
            SoufujoukyoOpt.add(new SelectOption(String.valueOf(SoufujoukyoPicklis.getValue()),String.valueOf(SoufujoukyoPicklis.getLabel())));
        }
        
        

    }

    //検索条件用のクラス
    public class SearchJokenWrapper {

        //検索条件用の項目
        public SogiShiryoSofu__c SogiShiryoSofuJoken {get; set;}

        //検索条件用の商談
        public Opportunity SearchOpp {get; set;}

        //検索条件_送付物内容用のselectList
        public List<String> InsatsubutsuIchiranSelect {get; set;}
        //検索条件_送付物内容用のselectOptions
        public List<SelectOption> InsatsubutsuIchiranOpt {get;set;}

        //検索条件_フリーワード検索用
        public String SearchFreeWordNyuryoku {get; set;}

        //検索条件_葬儀資料送付名検索用
        public String SearchNameNyuryoku {get; set;}

        //検索条件_商談番号検索用
        public String SearchShodanBangoNyuryoku {get; set;}

        public List<SelectOption> SearchPdfSakusei {get; set;}

        public String SerchPdfKey {get; set;}

        public SearchJokenWrapper() {
            SogiShiryoSofuJoken = new SogiShiryoSofu__c();

            SearchOpp = new Opportunity(recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId());

            InsatsubutsuIchiranSelect = new List<String>();
            InsatsubutsuIchiranOpt = new List<SelectOption>();
            SearchPdfSakusei = new List<SelectOption>();
            List<Schema.PicklistEntry> InsatsubutsuIchiranPicklist = getPicklist('SogiShiryoSofu__c','InsatsubutsuIchiran__c');
            for(Schema.PicklistEntry sPicklis :InsatsubutsuIchiranPicklist){
                InsatsubutsuIchiranOpt.add(new SelectOption(String.valueOf(sPicklis.getValue()),String.valueOf(sPicklis.getLabel())));
            }
            SerchPdfKey = '作成済';
            SearchPdfSakusei.add(new SelectOption('','--なし--'));
            SearchPdfSakusei.add(new SelectOption('作成済','作成済'));
            SearchPdfSakusei.add(new SelectOption('未作成','未作成'));

        SearchFreeWordNyuryoku = '';
        SearchNameNyuryoku = '';
        SearchShodanBangoNyuryoku = '';

        }
    }

    //検索結果表示用のクラス
    public class ResultWrapper {
    
        //検索条件用のチェックボックス
        public Boolean isSelected {get; set;}

        //検索条件用の項目
        public SogiShiryoSofu__c SogiShiryoSofu {get; set;}

        public ResultWrapper() {
            isSelected = false;
            SogiShiryoSofu = new SogiShiryoSofu__c();
        }
    }

    //条件クリアボタン処理
    public void searchClear(){
        //一括印刷検索用_印刷開始日From項目のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.SearchKaishibiFrom__c = null;
        //一括印刷検索用_印刷開始日To項目のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.SearchKaishibiTo__c = null;
        //郵送種別項目のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.YusoShubetsu__c = '';
        //パンフレット要否のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.PamphletYohi__c = '';
        //送付状況のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.SofuJokyo__c = '印刷待ち';
        //送付種別のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.SofuShubetsu__c = '郵便';
        //送付物内容のクリア
        searchJokenWrapper.InsatsubutsuIchiranSelect = null;
        //引き継ぎ事項有無のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.SearchHikitsugiJikoUmu__c = '';
        //緊急度のクリア
        searchJokenWrapper.SogiShiryoSofuJoken.SearchKinkyudo__c = '';
        //フリーワードのクリア
        searchJokenWrapper.SearchFreeWordNyuryoku = '';
        //商談番号のクリア
        searchJokenWrapper.SearchShodanBangoNyuryoku = '';
        //葬儀資料送付名のクリア
        searchJokenWrapper.SearchNameNyuryoku = '';
        //希望エリアのクリア
        searchJokenWrapper.SogiShiryoSofuJoken.SearchKiboAreaKensaku__c = null;
        //商談のフェーズのクリア
        searchJokenWrapper.SearchOpp.StageName = '';
    }

    //検索ボタン処理
    public void searchData(){

        //検索結果変数の初期化
        resWrapList = new List<ResultWrapper>();
        
        //一括印刷検索用_印刷開始日From項目の取得
        Date SearchKaishibiFrom = searchJokenWrapper.SogiShiryoSofuJoken.SearchKaishibiFrom__c;
        //一括印刷検索用_印刷開始日To項目の取得
        Date SearchKaishibiTo = searchJokenWrapper.SogiShiryoSofuJoken.SearchKaishibiTo__c;
        //郵送種別項目の取得
        String YusoShubetsu = searchJokenWrapper.SogiShiryoSofuJoken.YusoShubetsu__c;
        //パンフレット要否の取得
        String PamphletYohi = searchJokenWrapper.SogiShiryoSofuJoken.PamphletYohi__c;
        //送付状況の取得
        String SofuJokyo = searchJokenWrapper.SogiShiryoSofuJoken.SofuJokyo__c;
        //送付種別の取得
        String SofuShubetsu = searchJokenWrapper.SogiShiryoSofuJoken.SofuShubetsu__c;
        //送付物内容の取得
        List<String> InsatsubutsuIchiran = new List<String>();
        InsatsubutsuIchiran = searchJokenWrapper.InsatsubutsuIchiranSelect;
        //引き継ぎ事項有無の取得
        String HikitsugiJikoUmu = searchJokenWrapper.SogiShiryoSofuJoken.SearchHikitsugiJikoUmu__c;
        //緊急度の取得
        String SearchKinkyudo = searchJokenWrapper.SogiShiryoSofuJoken.SearchKinkyudo__c;
        //フリーワードの取得
        String SearchFreeWord = searchJokenWrapper.SearchFreeWordNyuryoku;
        //商談番号の取得
        String SearchShodanBango = searchJokenWrapper.SearchShodanBangoNyuryoku;
        //葬儀資料送付名の取得
        String SearchSearchName = searchJokenWrapper.SearchNameNyuryoku;
        //希望エリアの取得
        String SearchSearchKiboAreaKensaku = (String)searchJokenWrapper.SogiShiryoSofuJoken.SearchKiboAreaKensaku__c;
        //商談のフェーズの取得
        String SearchOppStageName = searchJokenWrapper.SearchOpp.StageName;
        //PDF作成結果条件
        String SearchPdfSakusei = searchJokenWrapper.SerchPdfKey;
        
        Boolean SofuJokyoFlag = false; 
        //WHERE句設定処理
        String tempSearchText3 =' WHERE OpportunityRef__r.Account.RecordType.name != \'NULL\' ';
        // PDF作成完了コード
        List<String> sakuseiCode = new List<String>();
        sakuseiCode.add('200');
        sakuseiCode.add('402');

        if(String.isNotBlank(String.valueOf(SearchKaishibiFrom)) || 
            String.isNotBlank(String.valueOf(SearchKaishibiTo)) || 
            String.isNotBlank(YusoShubetsu) || String.isNotBlank(PamphletYohi) || 
            String.isNotBlank(SofuJokyo) || String.isNotBlank(SofuShubetsu) || 
            (InsatsubutsuIchiran.size() > 0) || String.isNotBlank(HikitsugiJikoUmu) || 
            String.isNotBlank(SearchKinkyudo) || String.isNotBlank(SearchShodanBango) ||
            String.isNotBlank(SearchSearchName) || String.isNotBlank(SearchSearchKiboAreaKensaku) || 
            String.isNotBlank(SearchOppStageName)){
            

            if(String.isNotBlank(String.valueOf(SearchKaishibiFrom))){
                Time FromTime = Time.newInstance(0, 0, 0, 0);
                DateTime Fromdt = DateTime.newInstance(SearchKaishibiFrom, FromTime);
                tempSearchText3 += ' and InsatsuNichiji__c >= :Fromdt ';
            }

            if(String.isNotBlank(String.valueOf(SearchKaishibiTo))){
                Time ToTime = Time.newInstance(23, 59, 59, 999);
                DateTime Todt = DateTime.newInstance(SearchKaishibiTo, ToTime);
                tempSearchText3 += ' and InsatsuNichiji__c <= :Todt ';
            }

            if(String.isNotBlank(YusoShubetsu)){
                tempSearchText3 += ' and YusoShubetsu__c = :YusoShubetsu ';
            }

            if(String.isNotBlank(PamphletYohi)){
                tempSearchText3 += ' and PamphletYohi__c = :PamphletYohi ';
            }

            if(String.isNotBlank(SofuJokyo)){
                tempSearchText3 += ' and SofuJokyo__c = :SofuJokyo ';
            }
            List<String> pdfSakuseiCondition = new List<String>();

            if(SearchPdfSakusei != null && SearchPdfSakusei == '未作成' ){
                pdfSakuseiCondition.add('未作成');
                pdfSakuseiCondition.add('作成中');
            }else{
                pdfSakuseiCondition.add(SearchPdfSakusei);
            }

            if(SofuJokyo == '印刷待ち' && SearchPdfSakusei != null ){
                System.debug('SearchPdfSakusei : '+ SearchPdfSakusei);
                tempSearchText3 += ' and PdfSakuseiJokyo__c IN :pdfSakuseiCondition ';
            }

            if(String.isNotBlank(SofuShubetsu)){
                tempSearchText3 += ' and SofuShubetsu__c = :SofuShubetsu ';
            }

            if(InsatsubutsuIchiran.size() > 0){
                String InsatsubutsuIchiranOptions = '(';
                Integer countMax = InsatsubutsuIchiran.size();
                for(Integer i = 0, j = 0; i < countMax; i++){
                    InsatsubutsuIchiranOptions += '\'' + InsatsubutsuIchiran.get(i) + '\'' ;
                    if(i < countMax-1){
                        InsatsubutsuIchiranOptions += ',' ;
                    }
                }
                InsatsubutsuIchiranOptions += ')' ;
                tempSearchText3 += ' and InsatsubutsuIchiran__c includes ' + InsatsubutsuIchiranOptions;
                
            
            }

            if(String.isNotBlank(HikitsugiJikoUmu)){
                tempSearchText3 += ' and SearchHikitsugiJikoUmu__c = :HikitsugiJikoUmu ';
            }

            if(String.isNotBlank(SearchKinkyudo)){
                tempSearchText3 += ' and Kinkyudo__c = :SearchKinkyudo ';
            }

            if(String.isNotBlank(SearchShodanBango)){
                tempSearchText3 += ' and OpportunityRef__r.ShodanBango__c = :SearchShodanBango ';
            }

            if(String.isNotBlank(SearchSearchName)){
                tempSearchText3 += ' and Name = :SearchSearchName ';
            }

            if(String.isNotBlank(SearchSearchKiboAreaKensaku)){
                tempSearchText3 += ' and (OpportunityRef__r.SimpleYasugoRef__r.KiboAreaRef__c = :SearchSearchKiboAreaKensaku ';
                tempSearchText3 += ' or OpportunityRef__r.SimpleYasugoRef__r.KiboArea2Ref__c = :SearchSearchKiboAreaKensaku ';
                tempSearchText3 += ' or OpportunityRef__r.SimpleYasugoRef__r.KiboArea3Ref__c = :SearchSearchKiboAreaKensaku ';
                tempSearchText3 += ' or OpportunityRef__r.SimpleYasugoRef__r.KiboArea4Ref__c = :SearchSearchKiboAreaKensaku ) ';
            }

            if(String.isNotBlank(SearchOppStageName)){
                tempSearchText3 += ' and OpportunityRef__r.StageName = :SearchOppStageName ';
            }

        }

        //ソート設定処理
        if(pSortItem == null || pSortItem == ''){
            pSortItem = 'SearchInsatsubi__c';
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

        String offSetNum = Apexpages.currentPage().getParameters().get('pGrPageVal');
        if(offSetNum == null || offSetNum == ''){
            offSetNum = '0';
        }
        else{
            Integer iOffSetNum = Integer.valueOf(offSetNum);
            if(iOffSetNum > 0) iOffSetNum = iOffSetNum - 1;
            offSetNum = String.valueOf(iOffSetNum * grDisplaySize);
        }

        Integer QuerycountSize = 0;
        List<SogiShiryoSofu__c> KekkaSogiShiryoSofu = new List<SogiShiryoSofu__c>();
        

        if(String.isNotBlank(SearchFreeWord)){
            String countSoslquery = 'FIND\'*';
            countSoslquery += SearchFreeWord;
            countSoslquery += '*\'IN ALL FIELDS RETURNING SogiShiryoSofu__c(';
            countSoslquery += searchText1;
            if(String.isNotBlank(tempSearchText3)){
                countSoslquery += tempSearchText3;
            }
            countSoslquery += ' limit 2000 ';
            countSoslquery += ')';

            String searchSoslquery = 'FIND\'*';
            searchSoslquery += SearchFreeWord;
            searchSoslquery += '*\'IN ALL FIELDS RETURNING SogiShiryoSofu__c(';
            searchSoslquery += searchText1;
            if(String.isNotBlank(tempSearchText3)){
                searchSoslquery += tempSearchText3;
            }
            searchSoslquery += ' order by ' + pSortItem + ' ' + pSortKey + ' NULLS LAST limit ' + grDisplaySize + ' offset ' + offSetNum;
            searchSoslquery += ')';
            
            List<List<SObject>>countSoslList=search.query(countSoslquery);
            List<SogiShiryoSofu__c> countList = countSoslList[0];
            QuerycountSize = countList.size();

            List<List<SObject>>searchList=search.query(searchSoslquery);
            List<SogiShiryoSofu__c> SOSLList = searchList[0];
            KekkaSogiShiryoSofu = SOSLList;
        
        }else{
            String searchquery = 'select ' + searchText1 + searchText2 + tempSearchText3 + ' order by ' + pSortItem + ' ' + pSortKey + ' NULLS LAST limit ' + grDisplaySize + ' offset ' + offSetNum;

            QuerycountSize = Database.countQuery('select COUNT() ' + searchText2  + tempSearchText3 + ' limit 2000');
            KekkaSogiShiryoSofu = Database.query(searchquery);
        }
        
        resWrapAllListSize =QuerycountSize;
        for(SogiShiryoSofu__c sltSogiShiryoSofu :KekkaSogiShiryoSofu){
            String StrAddress = '';
            ResultWrapper rw = new ResultWrapper();
            rw.SogiShiryoSofu = sltSogiShiryoSofu;
            resWrapList.add(rw);
        }

        pageChange();
    }

    //ページ情報表示処理
    public void pageChange(){
        grFirstFlg = false;
        grBackFlg = false;
        grNextFlg = false;
        grLastFlg = false;

        String pGrPageVal = Apexpages.currentPage().getParameters().get('pGrPageVal');
        if(pGrPageVal == null || pGrPageVal == ''){
            pGrPageVal = '1';
        }

        Integer iGrPageVal = Integer.valueOf(pGrPageVal);

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

    //送付済ボタン処理
    public void doSoufuZumiapex(){
        Datetime now = Datetime.now();
        updateSofuzumi(now);
    }
    // 翌日送付済
    public void doYokujitsuSofuZumiapex(){
        Datetime now = Datetime.now();
        updateSofuzumi(now.addDays(1));
    }

    public void updateSofuzumi (Datetime soufuDate){
        List<SogiShiryoSofu__c> SoufuZumiList = new List<SogiShiryoSofu__c>();
        Set<String> SoufuZumiListId = new Set<String>();
        for(ResultWrapper sWrapper :resWrapList){
            if(sWrapper.isSelected && sWrapper.SogiShiryoSofu.SofuJokyo__c == '印刷済'){
                SogiShiryoSofu__c sSoufuZumi = new SogiShiryoSofu__c(
                    id = sWrapper.SogiShiryoSofu.id,
                    SofuJokyo__c = '送付済',
                    SofuNichiji__c = soufuDate);
                    SoufuZumiList.add(sSoufuZumi);
            }
            if(sWrapper.SogiShiryoSofu.InsatsubutsuIchiran__c.indexOf('事前割証書') != -1){
                SoufuZumiListId.add(sWrapper.SogiShiryoSofu.id);
            }
            if(sWrapper.SogiShiryoSofu.InsatsubutsuIchiran__c.indexOf('会員案内') != -1){
                SoufuZumiListId.add(sWrapper.SogiShiryoSofu.id);
            }
        }
        List<SogiShiryoSofu__c >soufujyouList = [ select Id , OpportunityRef__r.Account.id,
        OpportunityRef__r.Account.JizenwariShoshoHassoDate__c from SogiShiryoSofu__c 
        where Id IN :SoufuZumiListId];
        Set<Account> jizenwariUpdateList = new Set<Account>();
        for(SogiShiryoSofu__c sofu : soufujyouList ){
            Account jizenwariUser = new Account(
                id = sofu.OpportunityRef__r.Account.id,
                JizenwariShoshoHassoDate__c = soufuDate.date()
            );
            jizenwariUpdateList.add(jizenwariUser);
        }
        List<Account>updateAccount = new List<Account>(jizenwariUpdateList);
        if(updateAccount.size() > 0){
            update updateAccount;
        }
        if(SoufuZumiList.size() > 0){
            update SoufuZumiList;
            searchData();
        }
    }

    //印刷ボタン処理
    public void doInsatsuapex(){
        List<SogiShiryoSofu__c> InsatsuList = new List<SogiShiryoSofu__c>();
        for(ResultWrapper sWrapper :resWrapList){
            if(sWrapper.isSelected && sWrapper.SogiShiryoSofu.SofuJokyo__c == '印刷待ち' && 
            sWrapper.SogiShiryoSofu.SearchSofuShiryoURLUmu__c){
                SogiShiryoSofu__c sInsatsu = new SogiShiryoSofu__c(
                    id = sWrapper.SogiShiryoSofu.id,
                    SofuJokyo__c = '印刷済',
                    InsatsuNichiji__c = Datetime.now(),
                    Insatsusha__c = UserInfo.getName()
                );
                InsatsuList.add(sInsatsu);
            }
        }
        if(InsatsuList.size() > 0){
            update InsatsuList;
            searchData();
        }
    }

    //状態変更ボタン処理
    public void doJotaiHenkoapex(){
        List<SogiShiryoSofu__c> SoufujoukyoList = new List<SogiShiryoSofu__c>();
        List<SogiShiryoSakuseiKekka__c> sakuseiKekkaList = new List<SogiShiryoSakuseiKekka__c>();
        if(String.isNotBlank(SoufujoukyoSelect)){
            for(ResultWrapper sWrapper :resWrapList){
                if(sWrapper.isSelected){
                    SogiShiryoSofu__c sSoufujoukyo = new SogiShiryoSofu__c(
                        id = sWrapper.SogiShiryoSofu.id,
                        SofuJokyo__c = SoufujoukyoSelect);
                        System.debug(sWrapper.SogiShiryoSofu.SogiShiryoSakuseiKekkaRef__c);
                    
                    if(SoufujoukyoSelect == '資料作成中'){
                        sSoufujoukyo.SofuShiryoURL__c = '';
                        SogiShiryoSakuseiKekka__c sakuseiKekka = new SogiShiryoSakuseiKekka__c(
                            id = sWrapper.SogiShiryoSofu.SogiShiryoSakuseiKekkaRef__c,
                            StatusCode__c = '',
                            Message__c = '',
                            Message_body__c = ''
                        );
                        sakuseiKekkaList.add(sakuseiKekka);
                    }
                    SoufujoukyoList.add(sSoufujoukyo);
                }
            }
            if(sakuseiKekkaList.size() > 0){
                update sakuseiKekkaList;
            }
            if(SoufujoukyoList.size() > 0){
                update SoufujoukyoList;
                searchData();
            }
        }
    }

    //選択リストのValuesとLabelの取得処理
    public static List<Schema.PicklistEntry> getPicklist(String sObjName, String fieldName){
        List<Schema.PicklistEntry> pickList;
        Schema.SObjectType sObjType = (Schema.SObjectType) Schema.getGlobalDescribe().get(sObjName);
        if(sObjType != null){
            Map<String, Schema.SObjectField> fieldmap = sObjType.getDescribe().fields.getMap();
            Schema.SObjectField f = (Schema.SObjectField) fieldmap.get(fieldName);
            if(f != null){
                Schema.DescribeFieldResult r = f.getDescribe();
                pickList = r.getPicklistValues();
            }
        }
        return pickList;
    }
}