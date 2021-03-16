/**
* クラス名      :   Ctrl_PriorityMunk
* クラス概要     :   僧侶検索画面
* @created  :   2017/11/30 Vinh Hua Quoc
* @modified :   
*/
public with sharing class Ctrl_PriorityMunk {

    public SearchWrapper searchWrapper {get; set;}
    public List<ResultWraper> resultWraperList {get; set;}
    public List<ResultWraper> markWraperList {get; set;}
    public String mapCenterPosition {get; set;}
    public String messageInfo {get; set;}

    /*
    * Ctrl_PriorityMunk
    * コンストラクタ
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified:
    */
    public Ctrl_PriorityMunk() {
        searchWrapper = new SearchWrapper();
        resultWraperList = new List<ResultWraper>();
        markWraperList = new List<ResultWraper>();
        mapCenterPosition = '東京駅';
        messageInfo = '';
    }

    /**
    * clearData
    * データをクリアする
    * @param なし
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    public void clearData(){
        searchWrapper = new SearchWrapper();
        resultWraperList = new List<ResultWraper>();
        markWraperList = new List<ResultWraper>();
        mapCenterPosition = '東京駅';
        messageInfo = '';
    }

    /**
    * checkInputValid
    * チェック仕様
    * @param Boolean
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    public Boolean checkInputValid(){
        messageInfo = '';
        Boolean isInvalid = false;
        if(searchWrapper.syozokusangojiinmeFurigana.length() == 1){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'所属山号寺院名(カナ)は2文字以上を入力してください。'));
            messageInfo += '所属山号寺院名(カナ)は2文字以上を入力してください。<br/>';
            isInvalid = true;
        }
        if(searchWrapper.someiFurigana.length() == 1){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'僧名(カナ)は2文字以上を入力してください。'));
            messageInfo += '僧名(カナ)は2文字以上を入力してください。<br/>';
            isInvalid = true;
        }
        if(searchWrapper.madoguchiSouryoRenrakuSaki.length() == 1){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'僧侶連絡先は2文字以上を入力してください。'));
            messageInfo += '僧侶連絡先は2文字以上を入力してください。<br/>';
            isInvalid = true;
        }
        if(isInvalid){
            return false;
        }
        return true;
    }

    /**
    * searchData
    * 検索アクション
    * @param なし
    * @return なし
    * @created: 2017/11/30 Vinh Hua Quoc
    * @modified: 
    */
    public void searchData(){
        List<String> billingStateValues = new List<String>();
        List<String> homutaiokanoAreaValues = new List<String>();
        resultWraperList = new List<ResultWraper>();
        markWraperList = new List<ResultWraper>();
        // チェック仕様
        if(!checkInputValid()){
            return;
        }
        String strQuery = 'SELECT Id,'
                        + 'MadoguchisoryoIdo__c,'
                        + 'MadoguchisoryoKeido__c,'
                        + 'Keiyakukaishibi__c,'     
                        + 'TokkiJiko__c,'
                        + 'Syushi__c,'
                        + 'Syuha__c,'
                        //+ 'Madoguchisoryo__r.ShozokuSangouSangoJiin__r.SangoJiinName__c,'
                        + 'Madoguchisoryo__r.ShozokuSangouSangoJiin__r.Name,'
                        + 'Madoguchisoryo__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,'
                        + 'MadoguchiSouryoRenrakuSaki__c,'
                        + 'Madoguchisoryo__r.SeikyuSakiFax1__c,'
                        + 'Madoguchisoryo__r.Name,'
                        + 'HomutaiokanoArea__c,'
                        + 'Madoguchisoryo__r.Age__pc,'
                        + 'Iraisyosofuhouhou__c,'
                        + 'Madoguchisoryo__r.MailAddress__c,'
                        + 'Madoguchisoryo__r.Gender__pc,'
                        + 'AmazonTaioka__c,'
                        + 'Kaimyojuyonomiirai__c,'
                        + 'Madoguchisoryo__r.BillingState,'
                        + 'Madoguchisoryo__r.BillingCity,'
                        + 'Madoguchisoryo__r.BillingStreet,'
                        + 'Madoguchisoryo__r.BillingPostalCode'
                        + ' FROM Keiyaku__c ';
        String strWhere = '';
        // 窓口僧侶居住地
        if(String.isNotBlank(searchWrapper.keiyakuBillingState.HomutaiokanoArea__c)){
            for(String item : searchWrapper.keiyakuBillingState.HomutaiokanoArea__c.split(';')){
                billingStateValues.add(item);
            }
            strWhere += ' AND MadoguchiSoryoBillingState__c IN :billingStateValues';
        }
        // 法務対応可能エリア
        if(String.isNotBlank(searchWrapper.keiyaku.HomutaiokanoArea__c)){
            for(String item : searchWrapper.keiyaku.HomutaiokanoArea__c.split(';')){
                homutaiokanoAreaValues.add(item);
            }
            strWhere += ' AND HomutaiokanoArea__c includes (\'' + String.join(homutaiokanoAreaValues,'\',\'')+ '\') ';
        }
        // 宗旨
        if(String.isNotBlank(searchWrapper.account.Syushi__c)){
            strWhere += ' AND Syushi__c = \'' + searchWrapper.account.Syushi__c + '\'';
        }
        // 宗派
        if(String.isNotBlank(searchWrapper.account.Syuha__c)){
            strWhere += ' AND Syuha__c = \'' + searchWrapper.account.Syuha__c + '\'';
        }
        // 所属山号寺院名(カナ)  
        if(String.isNotBlank(searchWrapper.syozokusangojiinmeFurigana)){
            strWhere += ' AND SyozokusangojiinmeFurigana__c = \'' + searchWrapper.syozokusangojiinmeFurigana + '\'';
        }
        // 窓口僧名(カナ)
        if(String.isNotBlank(searchWrapper.someiFurigana)){
            strWhere += ' AND MadoguchiSomeiFurigana__c = \'' + searchWrapper.someiFurigana + '\'';
        }
        // 戒名授与のみ依頼
        if(String.isNotBlank(searchWrapper.keiyaku.Kaimyojuyonomiirai__c)){
            strWhere += ' AND Kaimyojuyonomiirai__c = \'' + searchWrapper.keiyaku.Kaimyojuyonomiirai__c + '\'';
        }
        // 窓口僧侶連絡先
        if(String.isNotBlank(searchWrapper.madoguchiSouryoRenrakuSaki)){
            strWhere += ' AND MadoguchiSouryoRenrakuSaki__c = \'' + searchWrapper.madoguchiSouryoRenrakuSaki + '\'';
        }
        if(String.isNotBlank(strWhere)){
            strWhere = strWhere.replaceFirst('AND', 'WHERE');
            strQuery += strWhere;
        }
        // 希望エリア
        String strOrder = '';
        if(String.isNotBlank(searchWrapper.account.ShikugunRef__c)){
            List<Shikugun__c> lTempObject = [
                SELECT Id,
                    Chiriichijouhou__latitude__s, 
                    Chiriichijouhou__longitude__s 
                FROM Shikugun__c 
                WHERE Id = :searchWrapper.account.ShikugunRef__c
            ];
            if(!lTempObject.isEmpty() && lTempObject[0].Chiriichijouhou__latitude__s != null && lTempObject[0].Chiriichijouhou__longitude__s != null){
                strOrder += ' ORDER BY DISTANCE(Madoguchisoryo__r.BillingAddress, GEOLOCATION(' + lTempObject[0].Chiriichijouhou__latitude__s + ',' + lTempObject[0].Chiriichijouhou__longitude__s + '), \'mi\') NULLS LAST ';
            }
        }
        if(String.isNotBlank(strOrder)){
            strQuery += strOrder;
        }
        System.debug('==strQuery==' + strQuery);
        List<Keiyaku__c> searchResult = database.query(strQuery);
        if(searchResult.size() == 0){
            // 検索結果の件数 = 0
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'検索結果は0件です。'));
            messageInfo += '検索結果は0件です。<br/>';
        } else if(searchResult.size() > 100){
            // 検索結果の件数 > 100
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'検索結果が多いため100件を表示しています。'));
            messageInfo += '検索結果が多いため100件を表示しています。<br/>';
        }
        for(Integer i = 0; i < Math.min(searchResult.size(), 100); i++){
            ResultWraper temp = new ResultWraper();
            temp.keiyaku = searchResult[i];
            resultWraperList.add(temp);
            if(temp.checkHaveMark()){
                markWraperList.add(temp);
            }
        }
    }

    public void reloadMap(){return;}
    
    /**
    * クラス名      :   SearchWrapper
    * クラス概要     :   僧侶検索
    * @created  :   2017/11/30 Vinh Hua Quoc
    * @modified :   
    */
    public class SearchWrapper {
        public Keiyaku__c keiyaku {get; set;}
        public Keiyaku__c keiyakuBillingState {get; set;}
        public String syozokusangojiinmeFurigana {get; set;}
        public String someiFurigana {get; set;}
        public String madoguchiSouryoRenrakuSaki {get; set;}
        public Account account {get;set;}
        public String syushi {get; set;}
        public String syuha {get; set;}
        public SearchWrapper() {
            keiyaku = new Keiyaku__c();
            keiyakuBillingState = new Keiyaku__c();
            account = new Account();
            syozokusangojiinmeFurigana = '';
            someiFurigana = '';
            madoguchiSouryoRenrakuSaki = '';
            syushi = '';
            syuha = '';
        }
    }

    /**
    * クラス名      :   ResultWraper
    * クラス概要     :   僧侶検索結果
    * @created  :   2017/11/30 Vinh Hua Quoc
    * @modified :   
    */
    public class ResultWraper {
        public Keiyaku__c keiyaku {get; set;}
        public ResultWraper() {
            keiyaku = new Keiyaku__c();
        }
        private Boolean checkHaveMark(){
            if(this.keiyaku.MadoguchisoryoIdo__c == null || this.keiyaku.MadoguchisoryoKeido__c == null){
                return false;
            }
            return true;
        }
    }

}