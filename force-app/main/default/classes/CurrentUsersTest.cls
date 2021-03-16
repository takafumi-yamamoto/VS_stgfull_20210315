@isTest
public class CurrentUsersTest {
    @isTest
    public static void doTest(){
        CurrentUsers.ICurrentUser theTarget = CurrentUsers.getInstance();
        User theActual = theTarget.getUser();
        System.Debug(theActual);
    }
    public static void doTestMock(){
        User theUser = Dao_User.getInstance().selectById( UserInfo.getUserId() );
        CurrentUsers.ICurrentUser theTarget = new CurrentUsers.CurrentUserMock( theUser );
        User theActual = theTarget.getUser();
        System.Debug(theActual);
    }
}