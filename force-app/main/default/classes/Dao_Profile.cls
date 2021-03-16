public class Dao_Profile {

    private static Dao_Profile instance;
    public static Dao_Profile getInstance(){
        if(instance == null) instance = new Dao_Profile();
        return instance;
    }

    private String getSelectBody(){
        return 'select Id, Name from profile where id != null';
    }

    public List<Profile> selectAll(){
        return Database.query( this.getSelectBody() );
    }
}