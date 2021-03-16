public class GoogleMapApi {

    public Geocode getAddress(String postcode, String todofuken, String shikugun, String tyoumei, String banchi) {
        if(String.isBlank(postcode) && String.isBlank(todofuken) && String.isBlank(shikugun) && String.isBlank(tyoumei) && String.isBlank(banchi)){
            return new Geocode().setStatus('Error');
        }

        try {
            String GOOGLE_API_KEY = GoogleMapApiConfig.getConfig().ApiKey__c;
            String ENDPOINT = GoogleMapApiConfig.getConfig().Endpoint__c;

            List<String> addressList = new List<String>();
            if(String.isNotBlank(todofuken)) addressList.add(todofuken);
            if(String.isNotBlank(shikugun)) addressList.add(shikugun);
            if(String.isNotBlank(tyoumei)) addressList.add(tyoumei);
            if(String.isNotBlank(banchi)) addressList.add(banchi);
            String address = String.join(addressList, '');
            String components = 'country:JP';
            if(String.isNotBlank(postcode)) components += '%7Cpostal_code:' + postcode.replace('-', '').replace('ー', '').replace('―', '').trim();
            String url = ENDPOINT + '?components=' + components + '&address=' + EncodingUtil.urlEncode(address, 'UTF-8') + '&key=' + GOOGLE_API_KEY + '&language=ja';
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            //req.setTimeout(6000);

            System.debug('endpoint : ' + url);
            HttpResponse res = http.send(req);
            System.debug('GoogleMapApi res body:');
            System.debug(res.getBody());
            return Geocode.parse(res.getBody());
        } catch(Exception ex) {
            System.debug('GoogleMapApi Exception');
            System.debug(ex);
            return new Geocode().setStatus('Error');
        }
    }

    public class Address_components {
        public String long_name;
        public String short_name;
        public List<String> types;
    }

    public class Northeast {
        public Decimal lat;
        public Decimal lng;
    }

    public class Southwest {
        public Decimal lat;
        public Decimal lng;
    }

    public class Bounds {
        public Northeast northeast;
        public Southwest southwest;
    }

    public class Location {
        public Decimal lat;
        public Decimal lng;
    }

    public class Viewport {
        public Northeast northeast;
        public Southwest southwest;
    }

    public class Geometry {
        public Bounds bounds;
        public Location location;
        public String location_type;
        public Viewport viewport;
    }

    public class Results {
        public List<Address_components> address_components;
        public String formatted_address;
        public Geometry geometry;
        public String place_id;
        public List<String> types;
    }

    public class Geocode {
        public List<Results> results;
        public String status;
        public Boolean is_success(){
            return status == 'OK';
        }
        public Geocode setStatus(String status){
            this.status = status;
            return this;
        }
    }

    public static Geocode parse(String jsonStr) {
        return (Geocode) JSON.deserialize(jsonStr, Geocode.class);
    }
}