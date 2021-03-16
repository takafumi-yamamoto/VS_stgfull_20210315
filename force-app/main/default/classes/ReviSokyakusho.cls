public class ReviSokyakusho {

    private String mOppId;
	public String mRecordId{get;set;}
    public String mFileName{get; set;}
    public ReviSokyakusho(ApexPages.StandardController controller){
        this.mOppId = controller.getId();
    }

    @TestVisible
    private ReviSokyakusho(){}
    
    public PageReference print_for_shibo(){        
        this.print(this.mOppId, '【よりそう_僧侶手配依頼書】新SF用依頼書（死亡用）');
		return null;
    }

    public PageReference print_for_jizen(){
        this.print(this.mOppId, '【よりそう_僧侶手配依頼書】新SF用依頼書（事前用）');
		return null;
    }

    public void print(String pOppId, String pFileBaseName){
        ReviSokyakusho__c theRecord = new RecordCreation().createRecord(pOppId);
        INSERT theRecord;
        this.mRecordId = theRecord.Id;
		this.mFileName = pFileBaseName + '_' + theRecord.ShodanBango__c;
    }

    public class RecordCreation{
        public ReviSokyakusho__c createRecord(String p_opp_id){

            Opportunity the_opp = 
                [
                    SELECT Id,
                    ShodanBango__c,
                    AimitsumoriSaki__c,
                    TaishoushaJokyo__c,
                    FirstContact__r.Name,

                    Account.BillingPostalCode,
                    Account.BillingState,
                    Account.BillingCity,
                    Account.BillingStreet,
                    Account.Phone,
                    Account.MobilePhone__c,
                    Account.MailAddress__c,
                    Account.FAX,
                    Account.LastNameFurigana__pc,
                    Account.FirstNameFurigana__pc,
                    Account.Name,
                    Account.Gender__pc,
                    Account.SeinengappiWareki__c,
                    Account.JuminhyouState__c,
                    Account.JuminhyouCity__c,

                    SogiReviRef__r.TaisyosyaRef__r.Name,
                    SogiReviRef__r.TaisyosyaRef__r.LastNameFurigana__pc,
                    SogiReviRef__r.TaisyosyaRef__r.FirstNameFurigana__pc,
                    SogiReviRef__r.TaisyosyaRef__r.SeinengappiWareki__c,
                    SogiReviRef__r.TaisyosyaRef__r.Gender__pc,
                    SogiReviRef__r.TaisyosyaRef__r.Syushi__c,
                    SogiReviRef__r.TaisyosyaRef__r.Syuha__c,
                    SogiReviRef__r.TaisyosyaRef__r.BodaijinoUmu__c,
                    SogiReviRef__r.TaisyosyaRef__r.JuminhyouState__c,
                    SogiReviRef__r.TaisyosyaRef__r.JuminhyouCity__c,
                    
                    SogiReviRef__r.Zokugara__c,
                    SogiReviRef__r.FuanNaKoto__c,
                    SogiReviRef__r.KiboSougijo__c,
                    SogiReviRef__r.RyoriHenreihinTehai__c,
                    SogiReviRef__r.KiboMitsumoriSoufuHouhou__c,
                    SogiReviRef__r.MitsumoriTouchakuKibouKikan__c,
                    SogiReviRef__r.RenrakuKiboJikanTai__c,
                    SogiReviRef__r.SougisyaKaranoRenrakuKahi__c,
                    SogiReviRef__r.TaisyosyaGenzaiBasyo__c,
                    SogiReviRef__r.TaisyosyaGenzaiJusyo__c,
                    SogiReviRef__r.ShikijoName__c,
                    SogiReviRef__r.Anchibasho__c,
                    SogiReviRef__r.SinzokuSu__c,
                    SogiReviRef__r.KaisosyaSu__c,
                    SogiReviRef__r.SougiKeishiki__c,
                    SogiReviRef__r.KiboAreaStates__c,
                    SogiReviRef__r.KiboAreaCityStreet__c,
                    SogiReviRef__r.Yosan__c,
                    SogiReviRef__r.YoubouNaiyo__c,
                    SogiReviRef__r.ShukyoshaNoTehai__c
                    
                    FROM Opportunity
                    WHERE Id = :p_opp_id
                    LIMIT 1
                ]
                .get(0);

            ReviSokyakusho__c theRecord = new ReviSokyakusho__c(
                ShodanBango__c = the_opp.ShodanBango__c,
                Sodansha_BirthDate_Wareki__c = the_opp.Account.SeinengappiWareki__c,
                KiboSougijo__c = the_opp.SogiReviRef__r.KiboSougijo__c,
                MitsumoriTouchakuKibouKikan__c = the_opp.SogiReviRef__r.MitsumoriTouchakuKibouKikan__c,
                RenrakuKiboJikanTai__c = the_opp.SogiReviRef__r.RenrakuKiboJikanTai__c,
                FuanNaKoto__c = the_opp.SogiReviRef__r.FuanNaKoto__c,
                ShukyoshaNoTehai__c = the_opp.SogiReviRef__r.ShukyoshaNoTehai__c,
                RyoriHenreihinTehai__c = the_opp.SogiReviRef__r.RyoriHenreihinTehai__c,
                AimitsumoriSaki__c	= the_opp.AimitsumoriSaki__c,
                KiboMitsumoriSoufuHouhou__c = the_opp.SogiReviRef__r.KiboMitsumoriSoufuHouhou__c,
                SougisyaKaranoRenrakuKahi__c = the_opp.SogiReviRef__r.SougisyaKaranoRenrakuKahi__c,
                FirstContact_Name__c = the_opp.FirstContact__r.Name,
                Sodansha_Name_Kana__c = 
                    ( String.isBlank(the_opp.Account.LastNameFurigana__pc) ? '' : the_opp.Account.LastNameFurigana__pc )
                    +
                    ( String.isBlank(the_opp.Account.FirstNameFurigana__pc) ? '' : ' ' + the_opp.Account.FirstNameFurigana__pc )
                    ,
                Sodansha_Name__c = the_opp.Account.Name,
                Sodansha_Gender__c = the_opp.Account.Gender__pc,
                Taishosha_Zokugara_For_Sodansha__c = the_opp.SogiReviRef__r.Zokugara__c,
                Sodansha_Addr_ZipCode__c = the_opp.Account.BillingPostalCode,
                Sodansha_Phone__c = the_opp.Account.Phone,
                Sodansha_Mobile__c = the_opp.Account.MobilePhone__c,
                Sodansha_Mail__c = the_opp.Account.MailAddress__c,
                Sodansha_Fax__c = the_opp.Account.FAX,
                Taishosha_Name_Kana__c	= 
                    ( String.isBlank(the_opp.SogiReviRef__r.TaisyosyaRef__r.LastNameFurigana__pc) ? '' : the_opp.SogiReviRef__r.TaisyosyaRef__r.LastNameFurigana__pc )
                    + 
                    ( String.isBlank(the_opp.SogiReviRef__r.TaisyosyaRef__r.FirstNameFurigana__pc) ? '' : ' ' +  the_opp.SogiReviRef__r.TaisyosyaRef__r.FirstNameFurigana__pc)
                    ,
                Taishosha_Name__c = the_opp.SogiReviRef__r.TaisyosyaRef__r.Name,
                Sodansha_JuminhyouState__c = the_opp.Account.JuminhyouState__c,
                Sodansha_JuminhyouCity__c = the_opp.Account.JuminhyouCity__c,
                TaisyosyaGenzaiBasyo__c = the_opp.SogiReviRef__r.TaisyosyaGenzaiBasyo__c,
                TaisyosyaGenzaiJusyo__c = the_opp.SogiReviRef__r.TaisyosyaGenzaiJusyo__c,
                ShikijoName__c = the_opp.SogiReviRef__r.ShikijoName__c,
                Anchibasho__c = the_opp.SogiReviRef__r.Anchibasho__c,
                SinzokuSu__c = the_opp.SogiReviRef__r.SinzokuSu__c,
                KaisosyaSu__c = the_opp.SogiReviRef__r.KaisosyaSu__c,
                SougiKeishiki__c = the_opp.SogiReviRef__r.SougiKeishiki__c,
                KiboAreaStates__c = the_opp.SogiReviRef__r.KiboAreaStates__c,
                KiboAreaCityStreet__c = the_opp.SogiReviRef__r.KiboAreaCityStreet__c,
                Yosan__c = the_opp.SogiReviRef__r.Yosan__c,
                Syushi__c = the_opp.SogiReviRef__r.TaisyosyaRef__r.Syushi__c,
                Syuha__c = the_opp.SogiReviRef__r.TaisyosyaRef__r.Syuha__c,
                BodaijinoUmu__c = the_opp.SogiReviRef__r.TaisyosyaRef__r.BodaijinoUmu__c,
                YoubouNaiyo__c = the_opp.SogiReviRef__r.YoubouNaiyo__c,
                Sodansha_Addr_State__c = the_opp.Account.BillingState,
                Sodansha_Addr_City__c = the_opp.Account.BillingCity,
                Sodansha_Addr_Street__c = the_opp.Account.BillingStreet,
                TaishoushaJokyo__c = the_opp.TaishoushaJokyo__c,
                JuminhyoShozaichi__c =
                    ( String.isBlank(the_opp.SogiReviRef__r.TaisyosyaRef__r.JuminhyouState__c) ? '' : the_opp.SogiReviRef__r.TaisyosyaRef__r.JuminhyouState__c )
                    +
                    ( String.isBlank(the_opp.SogiReviRef__r.TaisyosyaRef__r.JuminhyouCity__c) ? '' : the_opp.SogiReviRef__r.TaisyosyaRef__r.JuminhyouCity__c)
                    ,
                Taishosha_Gender__c = the_opp.SogiReviRef__r.TaisyosyaRef__r.Gender__pc
            );

            return theRecord;
        }
    }
}