public with sharing class WaribikiSuggester {

    // STERN LECTURE ABOUT WHAT'S MISSING HERE COMING SOON

    @AuraEnabled
    public static DataContext getDataContext(String recordId) {

        return new DataCtxProvider().getDataCtx(recordId);

    }

    public class DataContext{

        @AuraEnabled public List<WaribikiSuggesterEntry> entries {
            get { if(this.entries == null) this.entries = new List<WaribikiSuggesterEntry>(); return this.entries; }
            set { entries = value; }
        }
        public DataContext addEntries(List<WaribikiSuggesterEntry> entries){
            for(WaribikiSuggesterEntry aEntry : entries){ this.addEntry(aEntry); }
            return this;
        }
        public DataContext addEntry(WaribikiSuggesterEntry entry){ this.entries.add(entry); return this; }
    }

    public class DataCtxProvider{
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
                theDataContext.addEntries( new MemberSuggester().getEntries(theSoudanSya) );
                theDataContext.addEntries( new MemberTaisyosyaSuggester().getEntries(theTaisyoSya) );
                if(theRecordTypeName == 'SimpleYasugo'){
                    theDataContext.addEntries( new SimpleYasugoSiryoSeikyuSuggester().getEntries(theOpp) );
                    theDataContext.addEntries( new JizenwariSuggester().getEntries(theOpp) );
                    theDataContext.addEntries( new PostalClubWariSuggester().getEntries(theOpp) );
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
    }

    public class SimpleYasugoSiryoSeikyuSuggester{
        public List<WaribikiSuggesterEntry> getEntries(Opportunity pOpp){
            List<WaribikiSuggesterEntry> theEntries = new List<WaribikiSuggesterEntry>();
            WaribikiKennri waribikiKennri = new WaribikiKennri();
            String theDesc = waribikiKennri.isOldSiryouseikyu(pOpp) ? '旧資料請求' : (waribikiKennri.isSimpleYasugoSiryouseikyu(pOpp) ? '安豪のみ' : '無し' );
            //String theDesc = pOpp.ShiryoSeikyuUmuExp__c ? '有' : '無';
            theEntries.add(
                new WaribikiSuggesterEntry()
                    .setname('資料請求割引')
                    .setdescr(theDesc)
                    .setrefNo('').setrefId('')  
            );
            return theEntries;
        }
    }

    public class PostalClubWariSuggester{
        public List<WaribikiSuggesterEntry> getEntries(Opportunity pOpp){
            String postalWari = '無';
            Map<Id,Keiyaku__c> theKeiyakuIdMap = KeiyakuCachedDaos.getInstance().SelectAlliance();
            if(theKeiyakuIdMap != null){
                for(Keiyaku__c theKeiyaku : theKeiyakuIdMap.values()){
                    if(theKeiyaku.Name.contains('ポスタルくらぶ') && pOpp.AllianceRef__c == theKeiyaku.Id ){
                        postalWari = '有';
                    }
                }

            }

            List<WaribikiSuggesterEntry> theEntries = new List<WaribikiSuggesterEntry>();
            theEntries.add(
                new WaribikiSuggesterEntry()
                    .setname('ポスタルくらぶ割')
                    .setdescr(postalWari)
                    .setrefNo('').setrefId('')  
            );
            return theEntries;
        }
    }


    public class JizenwariSuggester{
        public List<WaribikiSuggesterEntry> getEntries(Opportunity pOpp){
            Dao_JizenwariShodans.Dao_JizenwariShodan f_Dao_JizenwariShodan = Dao_JizenwariShodans.getInstance();

            List<WaribikiSuggesterEntry> theEntries = new List<WaribikiSuggesterEntry>();
            List<JizenwariShodan> theJizenwariShodans
                = f_Dao_JizenwariShodan.selectByKeiyakuTorihikisakiId(pOpp.AccountId);

            WaribikiSuggesterEntry theWaribikiSuggesterEntry;

            for(JizenwariShodan aJizenwariShodan : theJizenwariShodans){
                Jizenwari__c theJizenwari = aJizenwariShodan.Jizenwari;
                if(!theJizenwari.RiyoKaisuSeigenAriExp__c) continue;
                if(theJizenwari.KeiyakuStatusCdExp__c != 'Active' && theJizenwari.KeiyakuStatusCdExp__c != 'Activating') continue;
                
                //over write
                String theStartDate = theJizenwari.Yuko_kigenStart__c == null ? '' : String.valueOf(theJizenwari.Yuko_kigenStart__c);
                String theKyuJizenwariId = theJizenwari.Name__c == null ? '' : theJizenwari.Name__c;
                String theDescr = '有効開始日:' + theStartDate;
                if(theKyuJizenwariId != '') theDescr += ', お客様ID:' + theKyuJizenwariId;

                theWaribikiSuggesterEntry 
                    = new WaribikiSuggesterEntry()
                        .setname('旧事前割')
                        .setdescr(theDescr)
                        .setrefNo(aJizenwariShodan.Opp.ShodanBangoF__c)
                        .setrefId(aJizenwariShodan.Opp.Id);
            }
            if(theWaribikiSuggesterEntry == null){
                theWaribikiSuggesterEntry 
                    = new WaribikiSuggesterEntry()
                        .setname('旧事前割')
                        .setdescr('無し')
                        .setrefNo('')
                        .setrefId('');   
            }
            theEntries.add(theWaribikiSuggesterEntry);
            return theEntries;
        }
    }

    public class MemberSuggester{
        public List<WaribikiSuggesterEntry> getEntries(Account pAccount){

            List<WaribikiSuggesterEntry> theEntries = new List<WaribikiSuggesterEntry>();

            //if(pAccount == null || pAccount.MemberKubunCode__c == 'NotMember') return theEntries;

            theEntries.add(
                new WaribikiSuggesterEntry()
                    .setname('相談者メンバ区分')
                    .setdescr( pAccount == null ? '-' :  pAccount.MemberTokutenKubun__c)
                    .setrefNo('')
                    .setrefId('')
            );
            return theEntries;
        }
    }

    public class MemberTaisyosyaSuggester{
        public List<WaribikiSuggesterEntry> getEntries(Account pAccount){
            List<WaribikiSuggesterEntry> theEntries = new List<WaribikiSuggesterEntry>();

            theEntries.add(
                new WaribikiSuggesterEntry()
                    .setname('対象者メンバ区分')
                    .setdescr( pAccount == null ? '-' :  pAccount.MemberTokutenKubun__c)
                    .setrefNo('')
                    .setrefId('')
            );
            return theEntries;
        }
    }

    public class WaribikiSuggesterEntry{
        @AuraEnabled public String name {
            get { if(name == null){ name = ''; } return name; }
            set { name = value; }
        }
        public WaribikiSuggesterEntry setname(String value){ this.name = value; return this; }

        @AuraEnabled public String descr {
            get { if(descr == null){ descr = ''; } return descr; }
            set { descr = value; }
        }
        public WaribikiSuggesterEntry setdescr(String value){ this.descr = value; return this; }

        @AuraEnabled public String refId {
            get { if(refId == null){ refId = ''; } return refId; }
            set { refId = value; }
        }
        public WaribikiSuggesterEntry setrefId(String value){ this.refId = value; return this; }

        @AuraEnabled public String refNo {
            get { if(refNo == null){ refNo = ''; } return refNo; }
            set { refNo = value; }
        }
        public WaribikiSuggesterEntry setrefNo(String value){ this.refNo = value; return this; }
        
    }
}