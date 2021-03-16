public class CurrentUsers {

    public interface ICurrentUser{
        User getUser();
    }

    public static ICurrentUser instance;
    public static ICurrentUser getInstance(){
        if(instance == null) instance = new CurrentUser( Dao_User.getInstance() );
        return instance;
    }

    public class CurrentUser Implements ICurrentUser{
        private Dao_User f_Dao_User;
        private User f_User;

        private CurrentUser(Dao_User pDao_User){
            this.f_Dao_User = pDao_User;
        }

        public User getUser(){
            if(this.f_User == null) this.f_User = this.f_Dao_User.selectById( UserInfo.getUserId() );
            return this.f_User;
        }
    }

    public class CurrentUserMock Implements ICurrentUser{
        private User f_User;

        public CurrentUserMock(User pUser){
            this.f_User = pUser;
        }

        public User getUser(){
            return this.f_User;
        }
    }

}