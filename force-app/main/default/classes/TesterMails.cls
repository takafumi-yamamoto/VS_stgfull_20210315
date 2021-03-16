public class TesterMails implements ITesterMails{

    private TesterMailEnts.ITesterMailEntries f_IEntProvider;
    private Environments.IEnv f_IEnv;

    @TestVisible
    private TesterMails(TesterMailEnts.ITesterMailEntries pEntProvider, Environments.IEnv pEnv){
        this.f_IEntProvider = pEntProvider;
        this.f_IEnv = pEnv;
    }

    private Boolean isAllowed(String pMailAddress) {
        if( !this.f_IEnv.isSandbox() ) return true;
        return this.f_IEntProvider.hasEntry(pMailAddress);
    }

    public void raiseNotTesterExIfNotAllowed(String pMailAddress){
        if( String.isBlank(pMailAddress) ) return;
        if( !this.isAllowed(pMailAddress) ) throw new Testers.NotTesterException( String.format('{0} is not tester', new List<String>{pMailAddress}) );
    }

    @TestVisible private static TesterMails f_instance;
    public static TesterMails getInstance(){
        if(f_instance == null){
            f_instance = new TesterMails( new TesterMailEnts.TesterMailEntries(), new Environments.Env() );
        }
        return f_instance;
    }

    public interface ITesterMails {
        void raiseNotTesterExIfNotAllowed(String pMailAddress);
    }
}