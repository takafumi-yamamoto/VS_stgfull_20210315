public with sharing class WaribikiSummary {

    // STERN LECTURE ABOUT WHAT'S MISSING HERE COMING SOON

    @AuraEnabled
    public static DataContext getDataContext(String recordId) {

        return new DataCtxProvider().getDataCtx(recordId);

    }

    public class DataContext{

        @AuraEnabled public List<WaribikiSummaryEntry> entries {
            get { if(this.entries == null) this.entries = new List<WaribikiSummaryEntry>(); return this.entries; }
            set { entries = value; }
        }
        public DataContext addEntries(List<WaribikiSummaryEntry> entries){
            for(WaribikiSummaryEntry aEntry : entries){ this.addEntry(aEntry); }
            return this;
        }
        public DataContext addEntry(WaribikiSummaryEntry entry){ this.entries.add(entry); return this; }
    }

    public class DataCtxProvider{
        // issues4156 --Start--
        // 会員区分の表示切替スイッチ用
        public ShohinKaiteiSwitchingControl__mdt KaiinSwitchingControl;
        public boolean KaiinSwitchingControlFlg;
        
        public DataCtxProvider(){
            KaiinSwitchingControl =  [SELECT Id, DeveloperName, Switching__c FROM ShohinKaiteiSwitchingControl__mdt WHERE DeveloperName = 'KaiinSwitchingControl20_11' limit 1];
            KaiinSwitchingControlFlg = KaiinSwitchingControl.Switching__c;
        }
        // issues4156 --End--
        public DataContext getDataCtx(String recordId){
            Dao_Opportunity f_Dao_Opportunity = Dao_Opportunity.getInstance();
            IsNullAccountServices.IIsNullAccountService f_IsNullAccountServices = IsNullAccountServices.GetInstance();
            

            DataContext theDataContext = new DataContext();

            Opportunity theOpp = OpportunityLinqs.FirstOrDefault(
                f_Dao_Opportunity.selectByIds( new List<Id>{ recordId } )
            );
            Account theSoudanSya = this.getSoudanSya(theOpp);
            Account theTaisyoSya = this.getTaisyoSya(theOpp);

            String theRecordTypeName = RecordTypeCachedDaos.getInstance().SelectDeveloperNameById(theOpp.RecordTypeId);
            

            if( theOpp != null && !f_IsNullAccountServices.isNullOrNullObj(theOpp.AccountId) ){
              // issues4156 --Start--
               if(KaiinSwitchingControlFlg){
                    theDataContext.addEntries( new KaiinSummary().getEntries(theSoudanSya) );
                    theDataContext.addEntries( new KaiinTaisyosyaSummary().getEntries(theTaisyoSya) );
               }else{
                    theDataContext.addEntries( new MemberSummary().getEntries(theSoudanSya, theOpp) );
                    theDataContext.addEntries( new MemberTaisyosyaSummary().getEntries(theTaisyoSya) );
               }
              // issues4156 --End--
                if(theRecordTypeName == 'SimpleYasugo'){
                    // issues4156 --Start--
                    // theDataContext.addEntries( new JizenJunbiSheetWari().getEntries(theOpp) );
                    // theDataContext.addEntries( new ShikigoAnketoWari().getEntries(theOpp) );
                    theDataContext.addEntries( new JizenJunbiSheetWari().getEntries(theOpp,KaiinSwitchingControlFlg) );
                    theDataContext.addEntries( new ShikigoAnketoWari().getEntries(theOpp,KaiinSwitchingControlFlg) );
                    if(KaiinSwitchingControlFlg){
                        theDataContext.addEntries( new ButsuguNashiWari().getEntries(theOpp) );
                        List<Achievement__c> theAchievements = new List<Achievement__c> ();
                        theAchievements =  getSoudanSyaCampaign(theSoudanSya);
                        theDataContext.addEntries( new SoudanSyaCampaignSummary().getEntries(theAchievements) );
                    }
                    // issues4156 --End--
                    theDataContext.addEntries( new AllianceWari().getEntries(theOpp) );
                }
            }

            return theDataContext;
        }
        private Account getSoudanSya(Opportunity pOpp){
            Account theAccount = Dao_Account.getInstance().selectById(pOpp.AccountId);
            if(theAccount == null) return null;
            if( IsNullAccountServices.GetInstance().isNullOrNullObj(theAccount.Id) ) return null;
            return theAccount;
        }

        private Account getTaisyoSya(Opportunity pOpp){
            TaisyosyaResolvers.ITaisyoSyaResolver theITaisyoSyaResolver = TaisyosyaResolvers.getResolver(pOpp);
            if(theITaisyoSyaResolver == null) return null;
            List<Account> theAccounts = theITaisyoSyaResolver.getTaisyoSyas(pOpp);
            if(theAccounts.size() <= 0) return null;

            Account theAccount = theAccounts.get(0);
            if( IsNullAccountServices.GetInstance().isNullOrNullObj(theAccount.Id) ) return null;
            return theAccount;
        }

        // issues4156 --Start--
        private List<Achievement__c> getSoudanSyaCampaign(Account pAcc){
            List<String> Syubetsu = new List<String>();
            List<Achievement__c> theAchievements = new List<Achievement__c>();
            Date hanteibi = Date.today();

            Syubetsu = getDataYorisoCampaigntMaster();
            if(Syubetsu.size() > 0){ 
                theAchievements = [SELECT Id, 
                                          Syubetsu__c
                                   FROM Achievement__c 
                                   WHERE Syubetsu__c in :Syubetsu 
                                   AND TorihikiSakiRef__c = :pAcc.Id
                                   AND YukoFlag__c = True
                                   AND YukoKaishiBi__c <= :hanteibi
                                   AND YukoShuryoBi__c >= :hanteibi
                                   ORDER BY YukoShuryoBi__c];
            }
            return theAchievements;
        }

        public List<String> getDataYorisoCampaigntMaster(){
            Date selectDate = Date.today();
            List<YorisoCampaigntMaster__mdt> YorisoCampaigntApplication = new List<YorisoCampaigntMaster__mdt>();
            List<String> Syubetsu = new List<String>();
            
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
              for(YorisoCampaigntMaster__mdt sYCM :YorisoCampaigntApplication){
                  Syubetsu.add(sYCM.campaignID__c);
              }
              return Syubetsu;
        }
        // issues4156 --End--

    }

    public class JizenJunbiSheetWari{
        // issues4156 --Start--
        // public List<WaribikiSummaryEntry> getEntries(Opportunity pOpp){
        public List<WaribikiSummaryEntry> getEntries(Opportunity pOpp , boolean KaiinSwitchingControlFlg){
        // issues4156 --End--

            // issues4156 --Start--
            // String theDesc = (pOpp.Account.AcvmJizenJunbiMinDate__c != null || pOpp.SimpleYasugoRef__r.TaishoshaRef__r.AcvmJizenJunbiMinDate__c != null) ? 'あり' : '無';
            String theDesc = '無';
            String theTitle = '事前準備シート割　：';
            Boolean AccOsoshikiYoyakuChk = false;
            Boolean TaishoshaOsoshikiYoyakuChk = false;
            if(KaiinSwitchingControlFlg){
                theTitle = '事前アンケート割　：';
                Boolean Chkresult = new OsoshikiYoyakuChk().isCheck(pOpp); 
                if(Chkresult){
                   theDesc = (pOpp.Account.AcvmJizenJunbiMinDate__c != null || pOpp.SimpleYasugoRef__r.TaishoshaRef__r.AcvmJizenJunbiMinDate__c != null) ? 'あり' : '無';
                }
            }else{
                theDesc = (pOpp.Account.AcvmJizenJunbiMinDate__c != null || pOpp.SimpleYasugoRef__r.TaishoshaRef__r.AcvmJizenJunbiMinDate__c != null) ? 'あり' : '無';
            }
           // issues4156 --End--

            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    // issues4156 --Start--
                    // .setname('事前準備シート割　：')
                    .setname(theTitle)
                    // issues4156 --End--
                    .setdescr(theDesc)
                    .setrefNo('').setrefId('')  
            );
            return theEntries;
        }
    }

    public class ShikigoAnketoWari{
        // issues4156 --Start--
        // public List<WaribikiSummaryEntry> getEntries(Opportunity pOpp){
        public List<WaribikiSummaryEntry> getEntries(Opportunity pOpp , boolean KaiinSwitchingControlFlg){
        // issues4156 --End--

            // issues4156 --Start--
            // String theDesc = pOpp.SurveyDiscountAgreeStatus__c == '同意済' ? 'あり' : '無';
            String theDesc = '無';
            if(KaiinSwitchingControlFlg){
                Boolean Chkresult = new OsoshikiYoyakuChk().isCheck(pOpp); 
                if(Chkresult){
                   theDesc = pOpp.SurveyDiscountAgreeStatus__c == '同意済' ? 'あり' : '無';
                }
            }else{
                theDesc = pOpp.SurveyDiscountAgreeStatus__c == '同意済' ? 'あり' : '無';
            }
           // issues4156 --End--
            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    .setname('式後アンケート割　：')
                    .setdescr(theDesc)
                    .setrefNo('').setrefId('')  
            );
            return theEntries;
        }
    }

    public class AllianceWari{
        public List<WaribikiSummaryEntry> getEntries(Opportunity pOpp){
            String theDesc = pOpp.AllianceRef__c != null ? pOpp.AllianceRef__r.Teikeisaki__r.Name : '無';
            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    .setname('アライアンス　：')
                    .setdescr(theDesc)
                    .setrefNo('').setrefId('')  
            );
            return theEntries;
        }
    }

    public class MemberSummary{
        public List<WaribikiSummaryEntry> getEntries(Account pAccount, Opportunity pOpp){

            Dao_JizenwariShodans.Dao_JizenwariShodan f_Dao_JizenwariShodan = Dao_JizenwariShodans.getInstance();
            List<JizenwariShodan> theJizenwariShodans = f_Dao_JizenwariShodan.selectByKeiyakuTorihikisakiId(pOpp.AccountId);

            String oldJizenwari = '';
            for(JizenwariShodan aJizenwariShodan : theJizenwariShodans){
                Jizenwari__c theJizenwari = aJizenwariShodan.Jizenwari;
                if(!theJizenwari.RiyoKaisuSeigenAriExp__c) continue;
                if(theJizenwari.KeiyakuStatusCdExp__c != 'Active' && theJizenwari.KeiyakuStatusCdExp__c != 'Activating') continue;
                
                oldJizenwari = '(旧事前割)';
                break;
            }

            String strDescr1 = '-';
            String strDescr2 = '';
            if(pAccount != null){
                strDescr1 = pAccount.MemberKubun__c + ' ' + oldJizenwari;

                if(pAccount.JizenwariKekaKikan__c != null){
                    strDescr1 += ' ' + pAccount.JizenwariKekaKikan__c;
                }

                if(pAccount.AcvmOsoushikiYoyakuMinDate__c == null && pAccount.AcvmJizenWariMinDate__c != null){
                    strDescr2 = '(起算日 ' + pAccount.AcvmJizenWariMinDate__c.format() + ')';
                }
            }

            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    .setname('相談者　：')
                    .setdescr(strDescr1)
                    .setrefNo('')
                    .setrefId('')
            );
            if(strDescr2 != ''){
                theEntries.add(
                    new WaribikiSummaryEntry()
                        .setname('')
                        .setdescr(strDescr2)
                        .setrefNo('')
                        .setrefId('')
                );
            }
            return theEntries;
        }
    }

    public class MemberTaisyosyaSummary{
        public List<WaribikiSummaryEntry> getEntries(Account pAccount){

            String strDescr1 = '-';
            String strDescr2 = '';
            if(pAccount != null){
                strDescr1 = pAccount.MemberKubun__c;

                if(pAccount.JizenwariKekaKikan__c != null){
                    strDescr1 += ' ' + pAccount.JizenwariKekaKikan__c;
                }

                if(pAccount.AcvmOsoushikiYoyakuMinDate__c == null && pAccount.AcvmJizenWariMinDate__c != null){
                    strDescr2 = '(起算日 ' + pAccount.AcvmJizenWariMinDate__c.format() + ')';
                }
            }

            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    .setname('対象者　：')
                    .setdescr(strDescr1)
                    .setrefNo('')
                    .setrefId('')
            );
            if(strDescr2 != ''){
                theEntries.add(
                    new WaribikiSummaryEntry()
                        .setname('')
                        .setdescr(strDescr2)
                        .setrefNo('')
                        .setrefId('')
                );
            }
            return theEntries;
        }
    }

    public class WaribikiSummaryEntry{
        @AuraEnabled public String name {
            get { if(name == null){ name = ''; } return name; }
            set { name = value; }
        }
        public WaribikiSummaryEntry setname(String value){ this.name = value; return this; }

        @AuraEnabled public String descr {
            get { if(descr == null){ descr = ''; } return descr; }
            set { descr = value; }
        }
        public WaribikiSummaryEntry setdescr(String value){ this.descr = value; return this; }

        @AuraEnabled public String refId {
            get { if(refId == null){ refId = ''; } return refId; }
            set { refId = value; }
        }
        public WaribikiSummaryEntry setrefId(String value){ this.refId = value; return this; }

        @AuraEnabled public String refNo {
            get { if(refNo == null){ refNo = ''; } return refNo; }
            set { refNo = value; }
        }
        public WaribikiSummaryEntry setrefNo(String value){ this.refNo = value; return this; }
        
    }

    // issues4156 --Start--
    public class KaiinSummary{
        public List<WaribikiSummaryEntry> getEntries(Account pAccount){

            String strDescr1 = '-';
            if(pAccount != null){
                strDescr1 = pAccount.MemberKubun__c;
            }

            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    .setname('相談者　：')
                    .setdescr(strDescr1)
                    .setrefNo('')
                    .setrefId('')
            );
            return theEntries;
        }
    }

    public class KaiinTaisyosyaSummary{
        public List<WaribikiSummaryEntry> getEntries(Account pAccount){

            String strDescr1 = '-';
            if(pAccount != null){
                strDescr1 = pAccount.MemberKubun__c;

            }

            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    .setname('対象者　：')
                    .setdescr(strDescr1)
                    .setrefNo('')
                    .setrefId('')
            );
            return theEntries;
        }
    }

    public class ButsuguNashiWari{
        public List<WaribikiSummaryEntry> getEntries(Opportunity pOpp){
            String theDesc = '無';
            if(pOpp.SimpleYasugoRef__r.ButsuguNashiKibo__c == '仏具なし'){
                theDesc = 'あり';
            }
            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            theEntries.add(
                new WaribikiSummaryEntry()
                    .setname('仏具なし割引　：')
                    .setdescr(theDesc)
                    .setrefNo('').setrefId('')  
            );
            return theEntries;
        }
    }

    public class SoudanSyaCampaignSummary{

        public List<WaribikiSummaryEntry> getEntries(List<Achievement__c> theAchievements){

            integer IntCOUNT = 0;
            List<Schema.PicklistEntry> SyubetsuPicklist = getPicklist('Achievement__c','Syubetsu__c');
            Map<String,String> SyubetsuMap = new Map<String,String>();
            for(Schema.PicklistEntry sPicklis :SyubetsuPicklist){
                SyubetsuMap.put(String.valueOf(sPicklis.getValue()),String.valueOf(sPicklis.getLabel()));
            }

            List<WaribikiSummaryEntry> theEntries = new List<WaribikiSummaryEntry>();
            if(theAchievements.size() <= 0){
                theEntries.add(
                    new WaribikiSummaryEntry()
                        .setname('キャンペーン　：')
                        .setdescr('無')
                        .setrefNo('')
                        .setrefId('')
                );
            }else{
                for(Achievement__c a :theAchievements){
                    if(IntCOUNT == 0){
                        theEntries.add(
                            new WaribikiSummaryEntry()
                                .setname('キャンペーン　：')
                                .setdescr(SyubetsuMap.get(a.Syubetsu__c))
                                .setrefNo('')
                                .setrefId('')
                        );
                    }else{
                        theEntries.add(
                            new WaribikiSummaryEntry()
                                .setname('')
                                .setdescr(SyubetsuMap.get(a.Syubetsu__c))
                                .setrefNo('')
                                .setrefId('')
                        );
                    }
                    IntCOUNT = IntCOUNT + 1;
                }
            }
            return theEntries;
        }

        //選択リストのValuesとLabelの取得処理
        public List<Schema.PicklistEntry> getPicklist(String sObjName, String fieldName){
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

    public class OsoshikiYoyakuChk{
        public Boolean isCheck(Opportunity pOpp){

            Boolean Chkresult = false;
            Boolean TaishoshaOsoshikiYoyakuChkFlg = false;
            TaishoshaOsoshikiYoyakuChkFlg = new TaishoshaOsoshikiYoyakuChk().isCheck(pOpp);
            
            if(pOpp.Account.MemberTourokuZumi__c){
                if(pOpp.Account.AcvmOsoushikiYoyakuMinDate__c == null){
                    if(TaishoshaOsoshikiYoyakuChkFlg){
                        Chkresult = new TaishoshaAcvmOsoushikiYoyakuMinDate().isCheck(pOpp);
                    }else{
                        Chkresult = True;
                    }
                }
            }else{
                 if(TaishoshaOsoshikiYoyakuChkFlg){
                    Chkresult = new TaishoshaAcvmOsoushikiYoyakuMinDate().isCheck(pOpp);
                 }
            }
            return Chkresult;

        }
    }

    public class TaishoshaOsoshikiYoyakuChk{
        public Boolean isCheck(Opportunity pOpp){
            Boolean Chkresult = false;
            if(pOpp.SimpleYasugoRef__r.TaishoshaRef__c != null){
                if(pOpp.SimpleYasugoRef__r.TaishoshaRef__r.MemberTourokuZumi__c){
                    Chkresult = true;
                }
            }
            return Chkresult;
        }
    }

    public class TaishoshaAcvmOsoushikiYoyakuMinDate{
        public Boolean isCheck(Opportunity pOpp){
            Boolean Chkresult = false;
            if(pOpp.SimpleYasugoRef__r.TaishoshaRef__r.AcvmOsoushikiYoyakuMinDate__c == null){
                 Chkresult = True;
            }
            return Chkresult;
        }
    }
    // issues4156 --End--

}