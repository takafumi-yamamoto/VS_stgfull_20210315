public class Ctl_Achievement_Obosanbin{

    private Dao_ObosanbinShodans.Dao_ObosanbinShodan f_Dao_ObosanbinShodan;
    private Dao_Achievement.IAchievementDao f_IAchievementDao;
    private IsNullAccountServices.IIsNullAccountService f_IIsNullAccountService;
    private static String SYUBETU_OBOUSANBIN = 'ObousanbinRiyo';

    private static Ctl_Achievement_Obosanbin f_Ctl_Achievement_Obosanbin;
    public static Ctl_Achievement_Obosanbin getInstance(){
        if(f_Ctl_Achievement_Obosanbin == null){
            f_Ctl_Achievement_Obosanbin = new Ctl_Achievement_Obosanbin(
                Dao_ObosanbinShodans.getInstance(),
                Dao_Achievement.GetInstance(),
                IsNullAccountServices.GetInstance()
            );
        }
        return f_Ctl_Achievement_Obosanbin;
    }

    private Ctl_Achievement_Obosanbin(
        Dao_ObosanbinShodans.Dao_ObosanbinShodan pDao_ObosanbinShodan,
        Dao_Achievement.IAchievementDao pIAchievementDao,
        IsNullAccountServices.IIsNullAccountService pIIsNullAccountService
    ){
        this.f_Dao_ObosanbinShodan = pDao_ObosanbinShodan;
        this.f_IAchievementDao = pIAchievementDao;
        this.f_IIsNullAccountService = pIIsNullAccountService;
    }

    public void onOpportunityAfterUpdate(List<Opportunity> newOnes, Map<ID, Opportunity> oldOnes){

        List<Opportunity> theObosanbinToProcess = this.getObosanbinToProcess(newOnes, oldOnes);
        
        List<ObosanbinShodan> theObosanbinShodans = f_Dao_ObosanbinShodan.selectByOpportunityIds( SobjectsExtension.collectIds(newOnes) );
        List<Achievement__c> theAchievementsToBeInseted = this.getAchievementsToBeInsetedThisTime(theObosanbinShodans);
        List<Achievement__c> theAchievementsToBeDeleted = this.getAchievementsToBeDeletedThisTime(theObosanbinShodans);

        Insert theAchievementsToBeInseted;
        Delete theAchievementsToBeDeleted;
    }

    private List<Achievement__c> getAchievementsToBeDeletedThisTime(List<ObosanbinShodan> pObosanbinShodans){
        List<Id> theOppIds = ObosanbinShodanLinqs.collectOppIds(pObosanbinShodans);
        return this.f_IAchievementDao
                .SelectByOppIdsAndSyubetsu( new Set<Id>(theOppIds),SYUBETU_OBOUSANBIN);
    }

    private List<Achievement__c> getAchievementsToBeInsetedThisTime(List<ObosanbinShodan> pObosanbinShodans){
        List<Achievement__c> theAchievementsToBeInseted = new List<Achievement__c>();
        for(ObosanbinShodan aObosanbinShodan : pObosanbinShodans){
            if( this.isAchieved(aObosanbinShodan) ){
                theAchievementsToBeInseted.add( this.createAchivement(aObosanbinShodan) );
            }
        }
        return theAchievementsToBeInseted;
    }

    private List<Opportunity> getObosanbinToProcess(List<Opportunity> newOnes, Map<ID, Opportunity> oldOnes){
        List<Opportunity> theEntries = new List<Opportunity>();
        for(Opportunity aNewOne : newOnes){
            Opportunity aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isObosanbinToProcess(aNewOne, aOldOne) ){
                theEntries.add(aNewOne);
            }
        }
        return theEntries;
    }

    private Boolean isObosanbinToProcess(Opportunity pNewOne, Opportunity pOldOne){
        if( pNewOne.StageName != pOldOne.StageName ) return true;
        return false;
    }

    private Boolean isAchieved(ObosanbinShodan pObosanbinShodan){
        if( pObosanbinShodan.Opp.StageName == '商談クローズ' ) return true;
        return false;
    }


    private Achievement__c createAchivement(ObosanbinShodan pObosanbinShodan){
        return new Achievement__c(
            SourceShodanRef__c = pObosanbinShodan.Opp.Id,
            TorihikiSakiRef__c = pObosanbinShodan.Opp.AccountId,
            Syubetsu__c = SYUBETU_OBOUSANBIN,
            YukoFlag__c = true, 
            YukoKaishiBi__c = Date.newInstance(1900, 1, 1)
        ) ;
    }
}