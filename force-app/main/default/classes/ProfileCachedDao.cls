public class ProfileCachedDao {

    private Dao_Profile f_Dao_Profile;
    private Map<Id,Profile> f_MapOfProfilesById = new  Map<Id,Profile>();
    
    private Boolean f_isLoaded = false;
    private void load(){
        for(Profile aProfile : this.f_Dao_Profile.selectAll() ){
            this.f_MapOfProfilesById.put( aProfile.Id, aProfile );
        }
        this.f_isLoaded = true;
    }

    private ProfileCachedDao(Dao_Profile pDao_Profile){
        this.f_Dao_Profile = pDao_Profile;
    }

    public Profile selectById(Id pId){
        if(!this.f_isLoaded) this.load();
        return this.f_MapOfProfilesById.get(pId);
    }

    private static ProfileCachedDao instance;
    public static ProfileCachedDao getInstance(){
        if(instance == null) instance = new ProfileCachedDao( Dao_Profile.getInstance() );
        return instance;
    }
}