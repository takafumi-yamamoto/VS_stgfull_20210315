public class Environments {
	private static Boolean f_isValueCached = false;
	private static Boolean f_cachedValue = false;

	public static boolean isSandbox(){
		if( !f_isValueCached ){
			Organization org = [select Id, IsSandbox from Organization limit 1];
			f_cachedValue =  org.IsSandbox;
			f_isValueCached = true;
		}
		return f_cachedValue;
	}

	public interface IEnv {
		Boolean isSandbox();
	}
	public class Env implements Environments.IEnv{
		public Boolean isSandbox(){ return Environments.isSandbox(); }
	}
	public class EnvStub implements Environments.IEnv{
		private Boolean f_isSand = false;
		public EnvStub setIsSandBoxTrue(){ this.f_isSand = true; return this;}
		public EnvStub setIsSandBoxFalse(){ this.f_isSand = false; return this; }
		public Boolean isSandbox(){ return this.f_isSand; }
	}
}