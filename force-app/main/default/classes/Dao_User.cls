public class Dao_User {

    private static Dao_User instance;
    public static Dao_User getInstance(){
        if(instance == null) instance = new Dao_User();
        return instance;
    }

    private Dao_User(){}
    private String getSelectBody(){
        return 'select Id, Name, IsKatsudoSakujoKinshiExp__c from user where id != null ';
    }
    public User selectById(Id pId){
        List<User> theUsers = Database.query( this.getSelectBody() + 'and Id = :pId' );
        return theUsers.size() > 0 ? theUsers.get(0) : null;
    }
    public User selectByProfileName(String pPName){
        List<User> theUsers = Database.query( this.getSelectBody() + 'and Profile.Name = :pPName' );
        return theUsers.size() > 0 ? theUsers.get(0) : null;
    }
}