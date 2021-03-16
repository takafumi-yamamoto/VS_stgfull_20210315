@isTest
private class GeoLocsT {
	@isTest static void test_method_one() {
		new GeoLocs().getGeoLocation('', '');
        new GeoLocs().getGeoLocation('', '', true);
	}
}