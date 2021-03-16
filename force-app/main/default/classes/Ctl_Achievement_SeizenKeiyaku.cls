public class Ctl_Achievement_SeizenKeiyaku{

    private Dao_SeizenKeiyakuShodans.Dao_SeizenKeiyakuShodan f_Dao_SeizenKeiyakuShodan;
    private Dao_Achievement.IAchievementDao f_IAchievementDao;
    private IsNullAccountServices.IIsNullAccountService f_IIsNullAccountService;
    private static String SYUBETU_OSOSHIKIYOYAKU = 'OsoshikiYoyaku';

    private static Ctl_Achievement_SeizenKeiyaku f_Ctl_Achievement_SeizenKeiyaku;
    public static Ctl_Achievement_SeizenKeiyaku getInstance(){
        if(f_Ctl_Achievement_SeizenKeiyaku == null){
            f_Ctl_Achievement_SeizenKeiyaku = new Ctl_Achievement_SeizenKeiyaku(
                Dao_SeizenKeiyakuShodans.getInstance(),
                Dao_Achievement.GetInstance(),
                IsNullAccountServices.GetInstance()
            );
        }
        return f_Ctl_Achievement_SeizenKeiyaku;
    }

    private Ctl_Achievement_SeizenKeiyaku(
        Dao_SeizenKeiyakuShodans.Dao_SeizenKeiyakuShodan pDao_SeizenKeiyakuShodan,
        Dao_Achievement.IAchievementDao pIAchievementDao,
        IsNullAccountServices.IIsNullAccountService pIIsNullAccountService
    ){
        this.f_Dao_SeizenKeiyakuShodan = pDao_SeizenKeiyakuShodan;
        this.f_IAchievementDao = pIAchievementDao;
        this.f_IIsNullAccountService = pIIsNullAccountService;
    }

    public void onSeizenKeiyakuAfterUpdate(List<SeizenKeiyaku__c> newOnes, Map<ID, SeizenKeiyaku__c> oldOnes){

        List<SeizenKeiyaku__c> theSeizenKeiyakuToProcess = this.getSeizenKeiyakuToProcess(newOnes, oldOnes);
        
        List<SeizenKeiyakuShodan> theSeizenKeiyakuShodans = f_Dao_SeizenKeiyakuShodan.selectBySeizenKeiyakuIds( SobjectsExtension.collectIds(newOnes) );
        List<Achievement__c> theAchievementsToBeInseted = this.getAchievementsToBeInsetedThisTime(theSeizenKeiyakuShodans);
        List<Achievement__c> theAchievementsToBeDeleted = this.getAchievementsToBeDeletedThisTime(theSeizenKeiyakuShodans);

        Insert theAchievementsToBeInseted;
        Delete theAchievementsToBeDeleted;
    }

    private List<Achievement__c> getAchievementsToBeDeletedThisTime(List<SeizenKeiyakuShodan> pSeizenKeiyakuShodans){
        List<Id> theOppIds = SeizenKeiyakuShodanLinqs.collectOppIds(pSeizenKeiyakuShodans);
        return this.f_IAchievementDao
                .SelectByOppIdsAndSyubetsu( new Set<Id>(theOppIds),SYUBETU_OSOSHIKIYOYAKU);
    }

    private List<Achievement__c> getAchievementsToBeInsetedThisTime(List<SeizenKeiyakuShodan> pSeizenKeiyakuShodans){
        List<Achievement__c> theAchievementsToBeInseted = new List<Achievement__c>();
        for(SeizenKeiyakuShodan aSeizenKeiyakuShodan : pSeizenKeiyakuShodans){
            if( this.isAchieved(aSeizenKeiyakuShodan) ){
                theAchievementsToBeInseted.add( this.createAchivement(aSeizenKeiyakuShodan) );
            }
        }
        return theAchievementsToBeInseted;
    }

    private List<SeizenKeiyaku__c> getSeizenKeiyakuToProcess(List<SeizenKeiyaku__c> newOnes, Map<ID, SeizenKeiyaku__c> oldOnes){
        List<SeizenKeiyaku__c> theEntries = new List<SeizenKeiyaku__c>();
        for(SeizenKeiyaku__c aNewOne : newOnes){
            SeizenKeiyaku__c aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isSeizenKeiyakuToProcess(aNewOne, aOldOne) ){
                theEntries.add(aNewOne);
            }
        }
        return theEntries;
    }

    private Boolean isSeizenKeiyakuToProcess(SeizenKeiyaku__c pNewOne, SeizenKeiyaku__c pOldOne){
        if(pNewOne.KeiyakuKaishiBi__c != pOldOne.KeiyakuKaishiBi__c) return true;
        if(pNewOne.KeiyakuSya__c != pOldOne.KeiyakuSya__c) return true;
        // if(pNewOne.SeizenKeiyakuPlanRef__c != pOldOne.SeizenKeiyakuPlanRef__c) return true;
        return false;
    }

    private Boolean isAchieved(SeizenKeiyakuShodan pSeizenKeiyakuShodan){
        if( pSeizenKeiyakuShodan.SeizenKeiyaku.KeiyakuKaishiBi__c == null ) return false;
        if( this.f_IIsNullAccountService.isNullOrNullObj(pSeizenKeiyakuShodan.SeizenKeiyaku.KeiyakuSya__c) ) return false;
    //     if(pSeizenKeiyakuShodan.SeizenKeiyaku.SeizenKeiyakuPlanCodeExp__c != 'Yoriso') return false;
        return true;
    }


    private Achievement__c createAchivement(SeizenKeiyakuShodan pSeizenKeiyakuShodan){
        return new Achievement__c(
            SourceShodanRef__c = pSeizenKeiyakuShodan.Opp.Id,
            TorihikiSakiRef__c = pSeizenKeiyakuShodan.SeizenKeiyaku.KeiyakuSya__c,
            Syubetsu__c = SYUBETU_OSOSHIKIYOYAKU,
            YukoFlag__c = true, 
            YukoKaishiBi__c = pSeizenKeiyakuShodan.SeizenKeiyaku.KeiyakuKaishiBi__c
        ) ;
    }

}