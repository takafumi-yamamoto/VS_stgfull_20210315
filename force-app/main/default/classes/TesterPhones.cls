public class TesterPhones implements ITesterPhones{
    private TesterPhoneEnts.ITesterPhoneEntries f_IEntProvider;
    private Environments.IEnv f_IEnv;

    @TestVisible
    private TesterPhones(TesterPhoneEnts.ITesterPhoneEntries pEntProvider, Environments.IEnv pEnv){
        this.f_IEntProvider = pEntProvider;
        this.f_IEnv = pEnv;
    }

    private Boolean isAllowed(String pPhone) {
        if( !this.f_IEnv.isSandbox() ) return true;
        return this.f_IEntProvider.hasEntry(pPhone);
    }

    public void raiseNotTesterExIfNotAllowed(String pPhone){
        if( String.isBlank(pPhone) ) return;
        if( !this.isAllowed(pPhone) ) throw new Testers.NotTesterException( String.format('{0} is not tester', new List<String>{pPhone}) );
    }

    @TestVisible private static TesterPhones f_instance;
    public static TesterPhones getInstance(){
        if(f_instance == null){
            f_instance = new TesterPhones( new TesterPhoneEnts.TesterPhoneEntries(), new Environments.Env() );
        }
        return f_instance;
    }

    public interface ITesterPhones {
        void raiseNotTesterExIfNotAllowed(String pPhone);
    }
}