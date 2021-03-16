public interface IGeoLocs {
    GeoLocs.Result getGeoLocation(String postcode, String address, Boolean isRetry);
    GeoLocs.Result getGeoLocation(String postcode, String address);
}