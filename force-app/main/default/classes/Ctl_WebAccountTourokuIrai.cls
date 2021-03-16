/**
* 会員基盤と連携
* 
* CaseToWebAccountTorokuIrai:
*   CaseからWebアカウント依頼書を登録
*
* WebAccountTourokuIraiJob:
*   Webアカウント依頼書が検証済みProcessing_ValidatedのものをFront側と連携する
* 
* WebAccountTourokuIraiValidate: 
*   登録されたWebアカウント依頼書を検証する
*/
public class Ctl_WebAccountTourokuIrai {

    // レコードタイプ , 
    public static final String CONST_SHORIKUBUN_NEW = 'New';
    public static final String CONST_SHORIKUBUN_UPDATE = 'Modify';
    public static final String CONST_SHORIKUBUN_DEL = 'Remove';
    public static final String CONST_SHORIKUBUN_ACTIVATE = 'Activate';

    // 処理ステータス , ShoriStatus__c , picklist
    public static final String CONST_SHORISTATUS_NEW = 'Processing_Created';
    public static final String CONST_SHORISTATUS_CHECK = 'Processing_Validated';
    public static final String CONST_SHORISTATUS_IRAIZUMI = 'Processing_WebAccountRequested';
    public static final String CONST_SHORISTATUS_SYORIZUMI = 'Processing_WebAccountProcessed';
    public static final String CONST_SHORISTATUS_OK = 'Closed_Success';
    public static final String CONST_SHORISTATUS_ERROR = 'Closed_Error';

    public static final String CONST_NINSHOHOUHOU_EMAIL = 'メールアドレス';
    public static final String CONST_NINSHOHOUHOU_TELNUMBER = '電話番号';

    // エラーメッセージ
    private static final String CONST_ERROR_TOUROKUCHI_INVALID_EMAIL = '登録値はメールアドレスではありません。';
    private static final String CONST_ERROR_NINSHOHOUHOU_INVALID = '認証方法を入れてください。';
    private static final String CONST_ERROR_DUPLICATE_INVALID = '登録値が重複しています。';
    private static final String CONST_ERROR_NOT_FOUND_EMAIL_INVALID = 'メールアドレスが存在しません。';

    private static final String CONST_ERROR_TOUROKUCHI_INVALID_TELNUMBER = '電話番号はハイフンなし半角数字11桁で入力してください。';
    private static final String CONST_ERROR_DUPLICATE_TELNUMBER_INVALID = '重複電話番号が存在します。';

    // 20.11商品改定 --Start--
    // カスタム表示ラベルに変更するため、コメントアウト
    // private static final String CONST_ERROR_NOT_MEMBER = '非メンバーのためWebアカウントは登録できません。';
    // 20.11商品改定 --End--

    private static final String CONST_ERROR_NOT_EDIT_WEBACCOUNT = '変更対象のWebアカウントが見つかりません。';
    private static final String CONST_ERROR_FOUND_INVALID = 'Webアカウントが既に登録済みです。';
    private static final String ERROR_MSG_NOT_FOUND_WEBACCOUNT = 'Webアカウントがみつかりません。';

    public class SendingTourokuRequstToKaiinKiban{
        public void onWebAccountTourokuIraiAfterInsert(List<WebAccountTourokuIrai__c> newList){
            this.WebAccountTouroku(
                this.getEntriesToProcess( newList )
            );
        }

        private List<WebAccountTourokuIrai__c> getEntriesToProcess(List<WebAccountTourokuIrai__c> newList){
            List<WebAccountTourokuIrai__c> dataList = new List<WebAccountTourokuIrai__c>();
            for(WebAccountTourokuIrai__c data : newList){
                if(data.ShoriStatus__c == CONST_SHORISTATUS_CHECK) dataList.add(data);
            }
            return dataList;
        }

        private void WebAccountTouroku(List<WebAccountTourokuIrai__c> newList){
        // data validation
            for(WebAccountTourokuIrai__c irai : newList){
                // add to queue to run 
                ID jobID = System.enqueueJob(new WebAccountTourokuIraiJob(irai));
                System.debug('jobID : ' + jobID);
            }
        }
    }



    /**
    * 取引依頼書Queue処理
    */
    public class WebAccountTourokuIraiJob implements Queueable, Database.AllowsCallouts{
    	WebAccountTourokuIrai__c irai;
        Ctl_WebAccountTourokuIrai.Util util;
    	
    	public WebAccountTourokuIraiJob(WebAccountTourokuIrai__c irai){
    		this.irai = irai.clone(true, false, true, true);
            this.util = new Ctl_WebAccountTourokuIrai.Util();
    	}

	    public void execute(QueueableContext context) {
          	System.debug('callout');
          	System.debug(irai);
            if(irai != null && irai.ShoriStatus__c == CONST_SHORISTATUS_CHECK){
                if(this.util.isNewIrai(irai) || this.util.isUpdateIrai(irai)){
                    RsCoreApi_Util.doPut(new RsCoreApi_WebAccountClient(irai));
                } else if(this.util.isDelIrai(irai)){
                    RsCoreApi_Util.doPatch(new RsCoreApi_WebAccountClient(irai));
                }
            }
	    }
    }


    /**
    * Caseからwebアカウントの登録
    */

    private class ResolvingOfWebAccountIraiContext{

        private RecordTypeCachedDaos.IRecordTypeCachedDao f_IRecordTypeCachedDao;
        public ResolvingOfWebAccountIraiContext(RecordTypeCachedDaos.IRecordTypeCachedDao pIRecordTypeCachedDao){
            this.f_IRecordTypeCachedDao = pIRecordTypeCachedDao;
        }

        public String Resolve(Case aCase){
            if( aCase.RecordTypeId == f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm') && aCase.FormType__c == '安くて豪華なお葬式') {
                return 'ohanaippainoososhiki_shiryoseikyu';
            }
            if( aCase.RecordTypeId == f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm') ) {
                return 'simple_yasugo_siryoseikyu';
            }
            if( aCase.RecordTypeId == f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('Case','JizenwariWebMoshikomi') ) {
                return 'jizenwari_moushikomi';
            }
            if( aCase.RecordTypeId == f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoEndingnoteWebForm') ) {
                return 'simple_yasugo_endingnote';
            }
            if( aCase.RecordTypeId == f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('Case','OsoshikiYoyaku_SiryoSeikyu_Web') ) {
                return 'ososhiki_yoyaku_siryoseikyu';
            }
            return null;
        }
    }

    public class CaseToWebAccountTorokuIrai {
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_IRecordTypeCachedDao = RecordTypeCachedDaos.getInstance();

        private WebAccountTourokuIrai__c getWebAccountTourokuIraiFromcase(Case aCase){

            WebAccountTourokuIrai__c irai = new WebAccountTourokuIrai__c();
            irai.RecordTypeId = this.f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('WebAccountTourokuIrai__c','New');
            irai.TorihikiSakiRef__c = aCase.AccountId;    // 取引先
            irai.NinshoHouhou__c = 'メールアドレス';    // 認証方法
            irai.TourokuChi__c = aCase.MailAddress__c;    // 登録値
            irai.ShoriStatus__c = 'Processing_Created';    // 処理ステータス
            irai.WebAccountRequestTryCount__c = 0;    // Webアカウント依頼試行回数
            irai.Context__c = new ResolvingOfWebAccountIraiContext(f_IRecordTypeCachedDao).Resolve(aCase);
            return irai;
        }

        public void onCaseAfterInsert(List<Case> caseList){
            this.insertWebAccountTorokuIraiFromCase(caseList);
        }
        public void onCaseAfterUpdate(List<Case> caseList, Map<ID, Case> caseOldMap){
            this.insertWebAccountTorokuIraiFromCaseOnAccountChange(caseList,caseOldMap);
        }

        private void insertWebAccountTorokuIraiFromCase(List<Case> caseList){
            IsNullAccountServices.IIsNullAccountService theIsNullAccountService
                = IsNullAccountServices.GetInstance();

            List<WebAccountTourokuIrai__c> webAccountTourokuIraiList = new List<WebAccountTourokuIrai__c>();

            for(Case aCase : caseList) {
                if( this.toCreateWebAccountIrai(aCase) ) {
                    WebAccountTourokuIrai__c irai = getWebAccountTourokuIraiFromcase(aCase);
                    webAccountTourokuIraiList.add(irai);
                }
            }

            insert webAccountTourokuIraiList;
        }

        private Boolean toCreateWebAccountIrai(Case pCase){
            IsNullAccountServices.IIsNullAccountService theIsNullAccountService
                = IsNullAccountServices.GetInstance();
            if ( theIsNullAccountService.isNullOrNullObj(pCase.AccountId)) return false;
            if (pCase.WebAccountKibo__c == '希望する') return true;
            return false;
        }

        private void insertWebAccountTorokuIraiFromCaseOnAccountChange(List<Case> caseList, Map<ID, Case> caseOldMap){
            IsNullAccountServices.IIsNullAccountService theIsNullAccountService
                = IsNullAccountServices.GetInstance();

            List<WebAccountTourokuIrai__c> webAccountTourokuIraiList = new List<WebAccountTourokuIrai__c>();

            for(Case aCase : caseList) {
                Case theOldCase = caseOldMap.get(aCase.Id);

                if( this.toProcess(aCase,theOldCase) && this.toCreateWebAccountIrai(aCase) ){
                    WebAccountTourokuIrai__c irai = getWebAccountTourokuIraiFromcase(aCase);
                    webAccountTourokuIraiList.add(irai);
                }
            }

            insert webAccountTourokuIraiList;
        }

        private Boolean toProcess(Case newOne, Case oldOne){
            if(newOne.AccountId != oldOne.AccountId) return true;
            return false;
        }
    }

    public class Util {

        public Boolean isNewIrai(WebAccountTourokuIrai__c irai){
            return irai.RecordTypeId == RecordTypeCachedDaos.getInstance()
                .SelectIdByObjectTypeNameAndDevName('WebAccountTourokuIrai__c',CONST_SHORIKUBUN_NEW);
        }

        public Boolean isDelIrai(WebAccountTourokuIrai__c irai){
            return irai.RecordTypeId == RecordTypeCachedDaos.getInstance()
                .SelectIdByObjectTypeNameAndDevName('WebAccountTourokuIrai__c',CONST_SHORIKUBUN_DEL);
        }

        public Boolean isUpdateIrai(WebAccountTourokuIrai__c irai){
            return irai.RecordTypeId == RecordTypeCachedDaos.getInstance()
                .SelectIdByObjectTypeNameAndDevName('WebAccountTourokuIrai__c',CONST_SHORIKUBUN_UPDATE);
        }
    }

    /**
     * Webアカウント登録依頼　Validate
     */
    public class WebAccountTourokuIraiValidate {
        Ctl_WebAccountTourokuIrai.Util util = new Ctl_WebAccountTourokuIrai.Util();

        public void onWebAccountTourokuIraiBeforeInsert(List<WebAccountTourokuIrai__c> newOnes){
            List<String> emailsOrTelNumbers = new List<String>();
            List<String> accountIds = new List<String>();
            List<WebAccountTourokuIrai__c> validateWebAccountTourokuIraiList = new List<WebAccountTourokuIrai__c>();
            // 20.11商品改定 --Start--
            ShohinKaiteiSwitchingControl__mdt WebAccountTourokuIraiMemberKubun;
            WebAccountTourokuIraiMemberKubun =  [SELECT Id, DeveloperName, Switching__c, JokenMojiretu__c FROM ShohinKaiteiSwitchingControl__mdt WHERE DeveloperName = 'WebAccountTourokuIraiMemberKubun' limit 1];
            // 20.11商品改定 --End--


            for(WebAccountTourokuIrai__c irai : newOnes){
                if(irai.ShoriStatus__c == CONST_SHORISTATUS_NEW) {
                    // 登録値のチェック：メール、電話番号のフォーマットが正しいかどうか確認
                    checkTourokuChi(irai);
                    emailsOrTelNumbers.add(irai.TourokuChi__c);
                    accountIds.add(irai.TorihikiSakiRef__c);
                    validateWebAccountTourokuIraiList.add(irai);
                }
            }

            Map<ID, Account> accountIdMap = new Map<ID, Account>([
                                                                    select Id, 
                                                                        // 20.11商品改定 --Start--
                                                                        // MemberTokutenKubun__c, 
                                                                        MemberKubun__c, 
                                                                        // 20.11商品改定 --End--
                                                                        (select Id, 
                                                                            TorihikiSakiRef__c, 
                                                                            NinshoHouhou__c 
                                                                        from TorihikiSakiWebAccounts__r)
                                                                    from Account 
                                                                    where Id = :accountIds]);
            for(WebAccountTourokuIrai__c irai : newOnes){
                Account acc = accountIdMap.get(irai.TorihikiSakiRef__c);
                // 20.11商品改定 --Start--
                // if(acc.MemberTokutenKubun__c == '非メンバー'){
                //    irai.addError(CONST_ERROR_NOT_MEMBER);
                // }
                if(acc.MemberKubun__c == WebAccountTourokuIraiMemberKubun.JokenMojiretu__c){
                    irai.addError(System.Label.WebAccountTourokuIraiMemberKubunMessage);
                }
                // 20.11商品改定 --End--
                
                if(util.isUpdateIrai(irai)){
                    Boolean modifyErrorFlg = true;
                    for(WebAccount__c webaccount : acc.TorihikiSakiWebAccounts__r){
                        if(irai.NinshoHouhou__c == webaccount.NinshoHouhou__c){
                            modifyErrorFlg = false;
                        }
                    }

                    if(modifyErrorFlg){
                        irai.addError(CONST_ERROR_NOT_EDIT_WEBACCOUNT);
                    }
                }
            }

            // 重複チェック
            if(emailsOrTelNumbers.size() > 0) checkDuplicate(emailsOrTelNumbers, validateWebAccountTourokuIraiList);

            // メンバー登録済みチェック & Webアカウント存在チェック
            if(accountIdMap.size() > 0) checkExistWebAccount(accountIdMap, validateWebAccountTourokuIraiList);
        }

        /**
         * 重複チェック
         */
        public void checkDuplicate(List<String> emailsOrTelNumbers, List<WebAccountTourokuIrai__c> validateWebAccountTourokuIraiList){
            List<WebAccount__c> webAccountList = Dao_WebAccount.GetInstance().SelectByEmailsOrTelNumbers(emailsOrTelNumbers);
            Map<String, WebAccount__c> webAccountMap = new Map<String, WebAccount__c>();
            for(WebAccount__c webAcc : webAccountList){
                if(String.isNotBlank(webAcc.TourokuChi__c))
                    webAccountMap.put(webAcc.TourokuChi__c, webAcc);
            }

            for(WebAccountTourokuIrai__c irai : validateWebAccountTourokuIraiList){
                WebAccount__c webaccount = webAccountMap.get(irai.TourokuChi__c);
                if(util.isNewIrai(irai)) {
                    if(webaccount != null){
                        // 存在する場合、エラー設定
                        setShoriStatusBikoAndErrorStatus(irai, CONST_ERROR_DUPLICATE_INVALID + webaccount.Id);
                    }
                } else if(util.isUpdateIrai(irai)) {
                    if(webaccount != null){
                        // 更新値が存在する場合、エラー設定
                        setShoriStatusBikoAndErrorStatus(irai, CONST_ERROR_DUPLICATE_INVALID + webaccount.Id);
                    }
                } else if(util.isDelIrai(irai) ) {
                    //　処理不要

                } 
            }
        }

        /**
         * メンバー登録済みチェック & WebAccount唯一チェック
         */
        public void checkExistWebAccount(Map<ID, Account> accountIdMap, List<WebAccountTourokuIrai__c> validateWebAccountTourokuIraiNewList){
            
            for(WebAccountTourokuIrai__c irai : validateWebAccountTourokuIraiNewList){
                if(util.isNewIrai(irai)) {
                    Account acc = accountIdMap.get(irai.TorihikiSakiRef__c);
                    for(WebAccount__c webAcc : acc.TorihikiSakiWebAccounts__r){
                        if(webAcc.NinshoHouhou__c == irai.NinshoHouhou__c){
                            setShoriStatusBikoAndErrorStatus(irai, CONST_ERROR_FOUND_INVALID + webAcc.Id);
                            break;
                        }
                    }
                } 
            }
        }

        /**
        *　登録値チェック:
        * メール、電話番号のフォーマットが正しいかどうか確認
        */
        private void checkTourokuChi(WebAccountTourokuIrai__c irai) {
            Boolean isValid = true;
            // 登録値
            if(String.isBlank(irai.NinshoHouhou__c) && !util.isDelIrai(irai)){
                isValid = false;
                setShoriStatusBikoAndErrorStatus(irai, CONST_ERROR_NINSHOHOUHOU_INVALID);
            }
            if(String.isNotBlank(irai.TourokuChi__c)){
                if(irai.NinshoHouhou__c == CONST_NINSHOHOUHOU_EMAIL){
                    Boolean isValidEmail = Utility_Common.isValidEmailAddress(irai.TourokuChi__c);
                    isValid = isValid && isValidEmail;
                    if(!isValidEmail){
                        setShoriStatusBikoAndErrorStatus(irai, CONST_ERROR_TOUROKUCHI_INVALID_EMAIL);
                    }
                }
                else if(irai.NinshoHouhou__c == CONST_NINSHOHOUHOU_TELNUMBER){
                    Boolean isValidTelNumber = TelNos.isValidMobilePhoneNumber(irai.TourokuChi__c);
                    isValid = isValid && isValidTelNumber;
                    if(!isValidTelNumber){
                        setShoriStatusBikoAndErrorStatus(irai, CONST_ERROR_TOUROKUCHI_INVALID_TELNUMBER);
                    }
                }
            }

            if(isValid){
              irai.ShoriStatus__c = CONST_SHORISTATUS_CHECK;
            }
        }

        private void setShoriStatusBikoAndErrorStatus(WebAccountTourokuIrai__c irai, String msg){
            irai.ShoriStatusBiko__c = String.isBlank(irai.ShoriStatusBiko__c) ? '' : irai.ShoriStatusBiko__c;
            irai.ShoriStatusBiko__c += msg + '\n';
            irai.ShoriStatus__c = CONST_SHORISTATUS_ERROR;
        }

    }

    public class WebAccountCompleting {
        Ctl_WebAccountTourokuIrai.Util util = new Ctl_WebAccountTourokuIrai.Util();

        public void onWebAccountTourokuIraiBeforeUpdate(List<WebAccountTourokuIrai__c> newList){
            this.doWebAccount(
                this.getEntriesToProcess(newList),
                this.getWebAccountMap(newList)
            );
        }

        private List<WebAccountTourokuIrai__c> getEntriesToProcess(List<WebAccountTourokuIrai__c> newList){
            List<WebAccountTourokuIrai__c> dataList = new List<WebAccountTourokuIrai__c>();
            for(WebAccountTourokuIrai__c data : newList){
                if(data.ShoriStatus__c == 'Processing_WebAccountProcessed' && String.isNotBlank( data.TorihikiSakiRef__c ) ) dataList.add(data);
            }
            return dataList;
        }

        private Map<String, List<WebAccount__c>> getWebAccountMap(List<WebAccountTourokuIrai__c> newList) {
            List<String> accountIds = new List<String>();
            Map<String, List<WebAccount__c>> mapResult = new Map<String, List<WebAccount__c>>();
            for(WebAccountTourokuIrai__c irai : newList){
                if(String.isNotBlank( irai.TorihikiSakiRef__c )){
                    accountIds.add(irai.TorihikiSakiRef__c);
                }
            }
            if(accountIds.size() > 0) {
                List<WebAccount__c> webAccountList =  Dao_WebAccount.GetInstance().getWebAccountByAccountIds(accountIds);
                for(WebAccount__c webAccount: webAccountList){
                    List<WebAccount__c> tempWebAccountList = new List<WebAccount__c>();
                    if(mapResult.containskey(webAccount.TorihikiSakiRef__c)){
                        tempWebAccountList = mapResult.get(webAccount.TorihikiSakiRef__c);
                    }
                    tempWebAccountList.add(webAccount);
                    mapResult.put(webAccount.TorihikiSakiRef__c, tempWebAccountList);
                }
            }
            
            return mapResult;

        }

        private void doWebAccount(List<WebAccountTourokuIrai__c> newList, Map<String, List<WebAccount__c>> webAccountMap) {
            List<WebAccount__c> webAccountList = new List<WebAccount__c>();
            List<WebAccount__c> webAccountForDelList = new List<WebAccount__c>();
            for(WebAccountTourokuIrai__c irai : newList){
                if(util.isNewIrai(irai)){
                    WebAccount__c webAccount = new WebAccount__c();
                    webAccount.TorihikiSakiRef__c = irai.TorihikiSakiRef__c;    
                    webAccount.NinshoHouhou__c = irai.NinshoHouhou__c;   // 認証方法
                    webAccount.TourokuChi__c = irai.TourokuChi__c;    // 登録値
                    webAccountList.add(webAccount);

                    irai.ShoriStatus__c = CONST_SHORISTATUS_OK;
                } else {
                    if(webAccountMap.containskey(irai.TorihikiSakiRef__c)){
                        for(WebAccount__c webAccount : webAccountMap.get(irai.TorihikiSakiRef__c)){
                            if(util.isUpdateIrai(irai)){
                                if(irai.NinshoHouhou__c == webAccount.NinshoHouhou__c){
                                    webAccount.TourokuChi__c = irai.TourokuChi__c;
                                    webAccountList.add(webAccount);
                                }
                            } else if(util.isDelIrai(irai)){
                                webAccountForDelList.add(webAccount);
                            }
                            irai.ShoriStatus__c = CONST_SHORISTATUS_OK;
                        }
                    }
                    else{
                        //依頼書更新
                        // TODO
                        irai.ShoriStatus__c = CONST_SHORISTATUS_ERROR;
                        irai.ShoriStatusBiko__c = ERROR_MSG_NOT_FOUND_WEBACCOUNT;
                    }
                }
            }
            upsert webAccountList;
            delete webAccountForDelList;
        }
    }
}