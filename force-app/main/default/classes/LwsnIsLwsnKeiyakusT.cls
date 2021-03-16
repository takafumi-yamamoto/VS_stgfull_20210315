@isTest
public class LwsnIsLwsnKeiyakusT {

	@isTest public static void getInstance(){
		Test.startTest();
		LwsnIsLwsnKeiyakus.getInstance();
		Test.stopTest();
	}

	@isTest public static void IsLawsonKeiyakuSvc_IsLawsonKeiyakuById(){
		Test.startTest();
		new LwsnIsLwsnKeiyakus.IsLawsonKeiyakuSvc( new LwsnConfig() ).IsLawsonKeiyakuById(null);
		Test.stopTest();
	}
	
	@isTest public static void IsLawsonKeiyakuSvcStub_IsLawsonKeiyakuById(){
		Test.startTest();
		new LwsnIsLwsnKeiyakus.IsLawsonKeiyakuSvcStub().setKeiyakuId(null).IsLawsonKeiyakuById(null);
		Test.stopTest();
	}
}