@RestResource(urlMapping='/api/v1/member/profile/*')
global with sharing class Api_V1_Member_Profile {

    @HttpGet
    global static void doGet() {
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        res.addHeader('Content-Type', 'application/json');

        try{
            
            String theTorihikiSakiBango = RestContext.request.params.get('custcd');
            if(String.isBlank(theTorihikiSakiBango)){
                res.responseBody = Blob.valueOf(JSON.serialize('取引先番号はブランクです.'));
                res.statusCode = 500;
                return;
            }

            // issues4156 --Start--

            Date selectDate = Date.today();

            List<YorisoCampaigntMaster__mdt> YorisoCampaigntApplication = new List<YorisoCampaigntMaster__mdt>();

            // キャンペーン利用(applied_campaigns)に登録されたキャンペーンは
            // 応募可能キャンペーン(applicable_campaigns)に設定しないための処理に
            // 利用する配列
            List<String> NotApplicableCampaigns = new List<String>();

            List<String> Syubetsu = new List<String>();

            YorisoCampaigntApplication = getDataYorisoCampaigntMaster(selectDate);

            for(YorisoCampaigntMaster__mdt sYCM :YorisoCampaigntApplication){
                Syubetsu.add(sYCM.campaignID__c);
            }

            // Account theAccount = Dao_Account.getInstance().selectByTorihikisakiBango(theTorihikiSakiBango);
            Account theAccount = getDataAccount(theTorihikiSakiBango,Syubetsu);
            // issues4156 --End--

            Data theData = new Data();
            theData.custcode = theAccount.TorihikisakiBangoF__c == null ? '' : theAccount.TorihikisakiBangoF__c ;
            theData.sei = theAccount.LastName == null ? '' : theAccount.LastName;
            theData.mei = theAccount.FirstName == null ? '' : theAccount.FirstName;
            theData.sei_kana = theAccount.LastNameFurigana__pc == null ? '' : theAccount.LastNameFurigana__pc;
            theData.mei_kana = theAccount.FirstNameFurigana__pc == null ? '' : theAccount.FirstNameFurigana__pc;
            theData.birthday = theAccount.PersonBirthdate == null ? '' : String.valueOf(theAccount.PersonBirthdate);
            theData.phone = theAccount.Phone == null ? '' : TelNos.toNumber(theAccount.Phone);
            theData.mobile = theAccount.MobilePhone__c == null ? '' : TelNos.toNumber(theAccount.MobilePhone__c);
            theData.mail1 = theAccount.MailAddress__c == null ? '' : theAccount.MailAddress__c;
            theData.mail2 = theAccount.MailAddress2__c == null ? '' : theAccount.MailAddress2__c;
            theData.postal_code = theAccount.BillingPostalCode == null ? '' : PostalCodes.toNumber(theAccount.BillingPostalCode);
            theData.state = theAccount.BillingState == null ? '' : theAccount.BillingState;
            theData.city = theAccount.BillingCity == null ? '' : theAccount.BillingCity;
            theData.street = theAccount.BillingStreet == null ? '' : theAccount.BillingStreet;
            theData.member_kbn_cd = theAccount.MemberKubunCode__c == null ? '' : theAccount.MemberKubunCode__c;
            theData.member_tokuten_kbn_cd = theAccount.MemberTokutenKubunCode__c == null ? '' : theAccount.MemberTokutenKubunCode__c;
            theData.jizen_junbi_shieet_teishutsuzumi = theAccount.AcvmJizenJunbiMinDate__c != null ? true : false;

            // issues4156 --Start--
            theData.kaiin_kaishi_date  = theAccount.YorisoKiinKisanbi__c == null ? '' : String.valueOf(theAccount.YorisoKiinKisanbi__c);
            theData.applied_campaigns = new List<CampaignUseDetail>();
            theData.applicable_campaigns = new List<CampaignApplicationDetail>();
            // よりそう会員(YorisoKaiin)の人のみ、キャンペーン情報を連携
            if(theData.member_kbn_cd == 'YorisoKaiin'){
                for(Achievement__c Achi :theAccount.TorihikiSakiAchivements__r){
                    NotApplicableCampaigns.add(Achi.Syubetsu__c);
                    // アチーブメントオブジェクトの媒体登録が「Web登録」のみ連携
                    if(Achi.BaitaiToroku__c == 'Web'){
                        CampaignUseDetail cud = new CampaignUseDetail();
                        cud.campaign_id = Achi.Syubetsu__c == null ? '' : Achi.Syubetsu__c;
                        cud.campaign_shuryobi = Achi.YukoShuryoBi__c == null ? '' : String.valueOf(Achi.YukoShuryoBi__c);
                        cud.campaign_toroku = Achi.BaitaiToroku__c == null ? '' : Achi.BaitaiToroku__c;
                        theData.applied_campaigns.add(cud);
                    }
                }
                for(YorisoCampaigntMaster__mdt YorisoCampaignt :YorisoCampaigntApplication){
                    // アチーブメントオブジェクトに登録されていないキャンペーンのみ連携
                    if(NotApplicableCampaigns.contains(YorisoCampaignt.campaignID__c) == false){
                         CampaignApplicationDetail cua = new CampaignApplicationDetail();
                         cua.campaign_id = YorisoCampaignt.campaignID__c == null ? '' :YorisoCampaignt.campaignID__c;
                         cua.campaign_moshikomi_deadline_days = YorisoCampaignt.campaignmoshikomiDeadlinedays__c == null ? '' : String.valueOf(YorisoCampaignt.campaignmoshikomiDeadlinedays__c);
                         cua.campaign_moshikomi_kaishibi =  YorisoCampaignt.campaignkaishibi__c == null ? '' : String.valueOf(YorisoCampaignt.campaignkaishibi__c);
                         cua.campaign_moshikomi_shuryobi =  YorisoCampaignt.campaignshuryobi__c == null ? '' : String.valueOf(YorisoCampaignt.campaignshuryobi__c);
                         theData.applicable_campaigns.add(cua);
                    }
                }
            }
            // issues4156 --End--
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(theData));

        } catch(Exception ex){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf(JSON.serialize(ex.getMessage()));
        }
        //return theTorihikiSakiBango;
    }

    // issues4156 --Start--
    public static Account getDataAccount(String pTorihikisakiBango,List<String> Syubetsu){
        List<Account> theEntities = new List<Account>();
        Account returnAcc = new Account();
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
                              YorisoKiinKisanbi__c, 
                              (SELECT Id, 
                                       Syubetsu__c, 
                                       BaitaiToroku__c, 
                                       YukoShuryoBi__c 
                                FROM TorihikiSakiAchivements__r 
                                WHERE Syubetsu__c in :Syubetsu 
                                ORDER BY YukoShuryoBi__c )
                      FROM Account
                      where TorihikisakiBangoF__c = :pTorihikisakiBango];
          if(theEntities.size() > 0) returnAcc = theEntities.get(0);
          return returnAcc;
    }

    public static List<YorisoCampaigntMaster__mdt> getDataYorisoCampaigntMaster(Date selectDate ){
        List<YorisoCampaigntMaster__mdt> YorisoCampaigntApplication = new List<YorisoCampaigntMaster__mdt>();
        YorisoCampaigntApplication = [SELECT Id, 
                                            campaignID__c, 
                                            campaignsummary__c, 
                                            campaignmoshikomikaishibi__c, 
                                            campaignmoshikomishuryobi__c, 
                                            campaignmoshikomiDeadlinedays__c, 
                                            campaignkaishibi__c,
                                            campaignshuryobi__c 
                                      FROM YorisoCampaigntMaster__mdt 
                                      WHERE campaignkaishibi__c <= :selectDate 
                                      AND campaignshuryobi__c >= :selectDate];
          return YorisoCampaigntApplication;

    }
    // issues4156 --End--

    public class Data{
        public String custcode { get;  set; }
        public String sei { get;  set; }
        public String mei { get;  set; }
        public String sei_kana { get;  set; }
        public String mei_kana { get;  set; }
        public String birthday  { get;  set; }
        public String phone { get;  set; }
        public String mobile { get;  set; }
        public String mail1 { get;  set; }
        public String mail2	 { get;  set; }
        public String postal_code { get;  set; }
        public String state { get;  set; }
        public String city { get;  set; }
        public String street { get;  set; }
        public String member_kbn_cd { get;  set; }
        public String member_tokuten_kbn_cd { get;  set; }
        public Boolean jizen_junbi_shieet_teishutsuzumi { get;  set; }
        // issues4156 --Start--
        public String kaiin_kaishi_date { get;  set; }
        public List<CampaignApplicationDetail> applicable_campaigns { get;  set; }
        public List<CampaignUseDetail> applied_campaigns { get;  set; }
        // issues4156 --End--
    }

    // issues4156 --Start--
    public class CampaignApplicationDetail{
        public String campaign_id { get;  set; }
        public String campaign_moshikomi_deadline_days { get;  set; }
        public String campaign_moshikomi_kaishibi { get;  set; }
        public String campaign_moshikomi_shuryobi { get;  set; }
    }

    public class CampaignUseDetail{
        public String campaign_id { get;  set; }
        public String campaign_shuryobi { get;  set; }
        public String campaign_toroku { get;  set; }
    }
    // issues4156 --End--

}