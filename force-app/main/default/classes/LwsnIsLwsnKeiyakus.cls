public class LwsnIsLwsnKeiyakus {
	
	private static IIsLawsonKeiyakuSvc instance = new IsLawsonKeiyakuSvc( new LwsnConfig() );
	public static IIsLawsonKeiyakuSvc getInstance(){ return instance; }
	@TestVisible private static void setInstacne(IIsLawsonKeiyakuSvc pValue){ instance = pValue; }

	public interface IIsLawsonKeiyakuSvc{
		Boolean IsLawsonKeiyakuById(String pKeiyakuId);
	}

	public class IsLawsonKeiyakuSvc implements IIsLawsonKeiyakuSvc{
		private LwsnConfig mLwsnConfig;
		public IsLawsonKeiyakuSvc(LwsnConfig pLwsnConfig){
			mLwsnConfig = pLwsnConfig;
		}
		public Boolean IsLawsonKeiyakuById(String pKeiyakuId){
			return pKeiyakuId == this.mLwsnConfig.getAllianceKeiyakuId();
		}
	}
	public class IsLawsonKeiyakuSvcStub implements IIsLawsonKeiyakuSvc{
		private String keiyakuId; 
		public IsLawsonKeiyakuSvcStub setKeiyakuId(String pValue){ this.keiyakuId = pValue; return this; }
		public Boolean IsLawsonKeiyakuById(String pKeiyakuId){ return pKeiyakuId == this.keiyakuId; }
	}
	
}