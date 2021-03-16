@isTest
public class Dao_UserTest {
    @isTest
    public static void doTest(){
        Dao_User theTarget = Dao_User.getInstance();
        User theActual = theTarget.selectById( UserInfo.getUserId() );
        System.Debug(theActual);
    }
}