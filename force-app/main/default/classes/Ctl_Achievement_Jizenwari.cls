public class Ctl_Achievement_Jizenwari{

    private Dao_JizenwariShodans.Dao_JizenwariShodan f_Dao_JizenwariShodan;
    private Dao_Achievement.IAchievementDao f_IAchievementDao;
    private IsNullAccountServices.IIsNullAccountService f_IIsNullAccountService;

    private static Ctl_Achievement_Jizenwari f_Ctl_Achievement_Jizenwari;
    public static Ctl_Achievement_Jizenwari getInstance(){
        if(f_Ctl_Achievement_Jizenwari == null){
            f_Ctl_Achievement_Jizenwari = new Ctl_Achievement_Jizenwari(
                Dao_JizenwariShodans.getInstance(),
                Dao_Achievement.GetInstance(),
                IsNullAccountServices.GetInstance()
            );
        }
        return f_Ctl_Achievement_Jizenwari;
    }

    private Ctl_Achievement_Jizenwari(
        Dao_JizenwariShodans.Dao_JizenwariShodan pDao_JizenwariShodan,
        Dao_Achievement.IAchievementDao pIAchievementDao,
        IsNullAccountServices.IIsNullAccountService pIIsNullAccountService
    ){
        this.f_Dao_JizenwariShodan = pDao_JizenwariShodan;
        this.f_IAchievementDao = pIAchievementDao;
        this.f_IIsNullAccountService = pIIsNullAccountService;
    }

    public void onJizenwariAfterUpdate(List<Jizenwari__c> newOnes, Map<ID, Jizenwari__c> oldOnes){

        // issues4156 --Start--
        // 使用しないため、対象ロジックを削除　ただし、APEXのコードカバー率確保のためにonJizenwariAfterUpdateメソッド以外の処理は残す
        // issues4156 --End--
    }
}