@RestResource(urlMapping='/api/v1/member/yoriso_member_certs/*')
global with sharing class Api_V1_Member_YorisoJizenwariCerts {

    @HttpGet
    global static void doGet() {

        String theTorihikisakiBango = RestContext.request.params.get('cust_cd');
        system.debug('**theTorihikisakiBango='+theTorihikisakiBango);
        // issues4156 --Start--
        // Account theAccount
        //     = Dao_Account.getInstance().selectByTorihikisakiBango(theTorihikisakiBango);
        Account theAccount = getDataAccount(theTorihikisakiBango);
        // issues4156 --End--
        if(theAccount == null){
            setResponse(RestContext.response, createNoneResult());
            return;
        } 

        // issues4156 --Start--
        // 取引先（Account)のよりそう会員起算日（YorisoKiinKisanbi__c）に変更するためコメントアウト
        /*
        if(theAccount.TorihikiSakiAchivements__r.size() == 0){
            setResponse(RestContext.response, createNoneResult());
            return;
        }

        Achievement__c achi = theAccount.TorihikiSakiAchivements__r.get(0);
        */
        // issues4156 --End--

        Data theData = new Data();
        theData.cust_cd = theAccount.TorihikisakiBangoF__c == null ? '' : theAccount.TorihikisakiBangoF__c ;
        theData.shodan_cd = theAccount.TorihikisakiBangoF__c == null ? '' : theAccount.TorihikisakiBangoF__c ;
        theData.sei = theAccount.LastName == null ? '' : theAccount.LastName;
        theData.mei = theAccount.FirstName == null ? '' : theAccount.FirstName;
        theData.sei_kana = theAccount.LastNameFurigana__pc == null ? '' : theAccount.LastNameFurigana__pc;
        theData.mei_kana = theAccount.FirstNameFurigana__pc == null ? '' : theAccount.FirstNameFurigana__pc;
        theData.plan_cd  = '';
        theData.keiyaku_staus_cd = '';
        // issues4156 --Start--
        // 取引先（Account)のよりそう会員起算日（YorisoKiinKisanbi__c）に変更する
        // theData.moshikomi_kanryo_date = achi.JizenwariMemberKisanbi__c == null ? '' : String.valueOf(achi.JizenwariMemberKisanbi__c);
        // theData.yuko_kaishi_date  = achi.JizenwariMemberKisanbi__c == null ? '' : String.valueOf(achi.JizenwariMemberKisanbi__c);
        theData.moshikomi_kanryo_date = theAccount.YorisoKiinKisanbi__c == null ? '' : String.valueOf(theAccount.YorisoKiinKisanbi__c);
        theData.yuko_kaishi_date  = theAccount.YorisoKiinKisanbi__c == null ? '' : String.valueOf(theAccount.YorisoKiinKisanbi__c);
        // issues4156 --End--

        Result theResult = new Result();
        theResult.result_code = 'success';
        theResult.data = theData;
        
        setResponse(RestContext.response, theResult);
    }

    private static void setResponse(RestResponse res, Object obj){
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(obj));
    }

    private static Result createNoneResult(){
        Result theResult = new Result();
        theResult.result_code = 'none';
        return theResult;
    }

    public class Result{
        public String result_code { get; set; }
        public Data data { get; set; }
    }
    public class Data{
        public String cust_cd { get;  set; }
        public String shodan_cd { get; set; }
        public String sei { get;  set; }
        public String mei { get;  set; }
        public String sei_kana { get;  set; }
        public String mei_kana { get;  set; }
        public String plan_cd { get; set; }
        public String keiyaku_staus_cd { get; set; }
        public String moshikomi_kanryo_date { get;  set; }
        public String yuko_kaishi_date { get;  set; }
    }

    // issues4156 --Start--
    public static Account getDataAccount(String pTorihikisakiBango){
        List<Account> theEntities = new List<Account>();
        theEntities = [SELECT Id, 
                              TorihikisakiBangoF__c, 
                              Name, 
                              LastName, 
                              FirstName,
                              NameFurigana__c, 
                              LastNameFurigana__pc, 
                              FirstNameFurigana__pc,
                              PersonBirthdate, 
                              PhoneFormula__c, 
                              MobilePhoneFormula__c,
                              Phone, 
                              MobilePhone__c, 
                              MailAddress__c, 
                              MailAddress2__c, 
                              BillingPostalCode, 
                              BillingState, 
                              BillingCity, 
                              BillingStreet, 
                              JizenwariMemberKa__c,
                              MemberKubunCode__c, 
                              MemberTokutenKubunCode__c, 
                              MemberKubun__c, 
                              MemberTokutenKubun__c, 
                              JizenJizenSheetTeishutsuzumi__c, 
                              JizenwariKekaKikan__c, 
                              AcvmJizenWariMinDate__c, 
                              AcvmJizenJunbiMinDate__c, 
                              AcvmOsoushikiYoyakuMinDate__c, 
                              RecordType.DeveloperName, 
                              YorisoKiinKisanbi__c 
                      FROM Account
                      where TorihikisakiBangoF__c = :pTorihikisakiBango];
          if(theEntities.size() <= 0) return null;
          return theEntities.get(0);
    }
    // issues4156 --End--

}