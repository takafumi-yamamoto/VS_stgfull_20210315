public class PostalCodeSearchCtl{

    public class Result {
        public String address1;
        public String address2;
        public String address3;
        public String kana1;
        public String kana2;
        public String kana3;
        public String prefcode;
        public String zipcode;
        public String message;
    }

    public Result getJSONByPostCD(String postalCD){

        if(postalCD == null || postalCD == ''){
            return null;
        }

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();

        String url = 'http://zipcloud.ibsnet.co.jp/api/search?&zipcode=' + postalCD;
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept','application/json');
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(20000);
        Boolean isError = false;
        Result result = new Result();
        try{
            res = http.send(req);
            System.debug('res.getBody():' + res.getBody());
            if (res.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> addresses = (List<Object>) results.get('results');
                if(addresses == null){
                    result.message = '郵便番号に一致する市区町村が存在しません';
                }
                else{
                    Map<String, Object> address = (Map<String, Object>) addresses[0];
                    // 住所を設定します。
                    result.address1 = (String)address.get('address1');
                    result.address2 = (String)address.get('address2');
                    result.address3 = (String)address.get('address3');
                    result.kana1 = (String)address.get('kana1');
                    result.kana2 = (String)address.get('kana2');
                    result.kana3 = (String)address.get('kana3');
                    result.prefcode = (String)address.get('prefcode');
                    result.address2 = (String)address.get('address2');
                    result.zipcode = (String)address.get('zipcode');
                    result.message = '';
                }
            }
        }catch(System.CalloutException ce){
            isError = true;
            //return ce.getMessage();
        }
        
        return result;
    }
}