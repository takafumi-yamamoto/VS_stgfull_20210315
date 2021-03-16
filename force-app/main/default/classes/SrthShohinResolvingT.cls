@isTest
private class SrthShohinResolvingT {
	
	@isTest static void test_method_one() {
		SrthShohinResolving.Request req = new SrthShohinResolving.Request()
                                                .setRiyokaisu('初めて')
                                                .setHojiHoyo('hojiHoyo')
                                                .setKaimyoPlan('釋・釋尼');
		// Implement test code
		System.debug(new SrthShohinResolving().getShohinLines(req));
	}
	
}