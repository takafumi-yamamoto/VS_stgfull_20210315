@isTest
private class ExceptionsT {
	
	@isTest static void test_method_one() {
		Exception ex = new Exceptions.AnException('hello Exception');
		System.debug(ex);
	}
	
}