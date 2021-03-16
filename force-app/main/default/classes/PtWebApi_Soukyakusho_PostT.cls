@isTest
private class PtWebApi_Soukyakusho_PostT {
	
	@isTest static void test_method_one() {
		// Implement test code
		new PtWebApi_Soukyakusho_Post().getValidMessages(new Api_V1_SogSok_Soukyakusho_Data.SoukyakuSho());
		new PtWebApi_Soukyakusho_Post().getValidMessages(null);
	}
}