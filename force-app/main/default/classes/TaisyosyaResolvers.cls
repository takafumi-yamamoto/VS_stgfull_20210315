public class TaisyosyaResolvers{
    public interface ITaisyoSyaResolver{
        List<Account> getTaisyoSyas(Opportunity pOpp);
    }

    public static ITaisyoSyaResolver getResolver(Opportunity pOpp){
        String theRecordTypeName = RecordTypeCachedDaos.getInstance().SelectDeveloperNameById(pOpp.RecordTypeId);
        return getResolverByRecordTypeName(theRecordTypeName);
    } 
    public static ITaisyoSyaResolver getResolverByRecordTypeName(String pRecordTypeName){
        if(pRecordTypeName == 'SimpleYasugo') return new TaisyoSyaResolverOnSimpleYasugo();
        if(pRecordTypeName == 'Obosanbin') return new TaisyoSyaResolverOnObousanBin();
        if(pRecordTypeName == 'KaiyoUmie') return new TaisyoSyaResolverOnUmie();
        if(pRecordTypeName == 'PerpetualMemorial') return new TaisyoSyaResolverOnEitaiKuyo();
        return null;
    }   

    public class TaisyoSyaResolverOnSimpleYasugo implements ITaisyoSyaResolver{
        public List<Account> getTaisyoSyas(Opportunity pOpp){
            List<Account> theAccounts = new List<Account>();

            IsNullAccountServices.IIsNullAccountService f_IsNullAccountServices = IsNullAccountServices.GetInstance();
            SimpleYasugo__c theSimpleYasugo = Dao_SimpleYasugo.SearchById(pOpp.SimpleYasugoRef__c);
            if(theSimpleYasugo == null) return theAccounts;
            Account theAccount = Dao_Account.getInstance().selectById(theSimpleYasugo.TaishoshaRef__c);
            if(theAccount != null && !f_IsNullAccountServices.isNullOrNullObj(theAccount.Id) ) theAccounts.add(theAccount);
            return theAccounts;
        }
    }

    public class TaisyoSyaResolverOnObousanBin implements ITaisyoSyaResolver{
        public List<Account> getTaisyoSyas(Opportunity pOpp){
            List<Account> theAccounts = new List<Account>();

            IsNullAccountServices.IIsNullAccountService f_IsNullAccountServices = IsNullAccountServices.GetInstance();
            Obosanbin__c theObosanbin = Dao_Obosanbin.SearchById(pOpp.ObosanbinRef__c);
            if(theObosanbin == null) return theAccounts;
            Account theAccount = Dao_Account.getInstance().selectById(theObosanbin.Taishosha1Ref__c);
            if(theAccount != null && !f_IsNullAccountServices.isNullOrNullObj(theAccount.Id) ) theAccounts.add(theAccount);
            return theAccounts;
        }
    }

    public class TaisyoSyaResolverOnUmie implements ITaisyoSyaResolver{
        public List<Account> getTaisyoSyas(Opportunity pOpp){
            List<Account> theAccounts = new List<Account>();

            IsNullAccountServices.IIsNullAccountService f_IsNullAccountServices = IsNullAccountServices.GetInstance();
            KaiyoSankotsuUmie__c theKaiyoSankotsuUmie = Dao_Umie.getInstance().selectByid(pOpp.KaiyoSankotsuUmieRef__c);
            if(theKaiyoSankotsuUmie == null) return theAccounts;
            Account theAccount = Dao_Account.getInstance().selectById(theKaiyoSankotsuUmie.TaishoshaRef__c);
            if(theAccount != null && !f_IsNullAccountServices.isNullOrNullObj(theAccount.Id) ) theAccounts.add(theAccount);
            return theAccounts;
        }
    }

    public class TaisyoSyaResolverOnEitaiKuyo implements ITaisyoSyaResolver{
        public List<Account> getTaisyoSyas(Opportunity pOpp){
            List<Account> theAccounts = new List<Account>();

            IsNullAccountServices.IIsNullAccountService f_IsNullAccountServices = IsNullAccountServices.GetInstance();
            EitaiKuyo__c theEitaiKuyo = Dao_EitaiKuyo.getInstance().selectByid(pOpp.EitaiKuyoRef__c);
            if(theEitaiKuyo == null) return theAccounts;
            Account theAccount = Dao_Account.getInstance().selectById(theEitaiKuyo.TaishoshaRef__c);
            if(theAccount != null && !f_IsNullAccountServices.isNullOrNullObj(theAccount.Id) ) theAccounts.add(theAccount);
            return theAccounts;
        }
    }
    
}

//SimpleYasugoRef__c