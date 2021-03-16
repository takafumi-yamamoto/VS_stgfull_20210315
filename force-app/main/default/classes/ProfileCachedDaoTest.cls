@isTest
public class ProfileCachedDaoTest {
    @isTest
    public static void doTest(){
        ProfileCachedDao theTarget = ProfileCachedDao.getInstance();
        Profile theProfile = theTarget.selectById( UserInfo.getProfileId() );
        System.Debug(theProfile);
    }
}