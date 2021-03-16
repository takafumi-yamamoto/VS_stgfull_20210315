public class GeoLocs implements IGeoLocs {
	private GoogleMapApi googlemapapi = new GoogleMapApi();

	public class Result{
		public Boolean isSuccess = false;
		public GeoLocation geoLocation = null;
	}
    public class GeoLocation {
        public Decimal lat;
        public Decimal lng;
    }

	public Result getGeoLocation(String postcode, String address) {
		Result result = new Result();
		result.isSuccess = false;
		try {
			GoogleMapApi.Geocode geocode = googlemapapi.getAddress(postcode, address, null, null, null);
			if(geocode.is_success()) {
				result.geoLocation = new GeoLocation();
	            result.geoLocation.lat = geocode.results[0].geometry.location.lat;
	            result.geoLocation.lng = geocode.results[0].geometry.location.lng;
			}
			result.isSuccess = geocode.is_success();
		} catch (Exception ex){ }
		return result;
	}

	public Result getGeoLocation(String postcode, String address, Boolean isRetry) {
		Result result = this.getGeoLocation(postcode, address);
		if(!result.isSuccess && isRetry){
			result = this.getGeoLocation('', address);
		}
		return result;
	}
}