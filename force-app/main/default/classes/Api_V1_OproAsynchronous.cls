@RestResource(urlMapping='/api/v1/opro/*/completed/')
global class Api_V1_OproAsynchronous {

    static final String API_URL_BASE = '/api/v1/opro/';
    static final String API_URL_PREFIX = '/completed/';

    @HttpPost
    global static void doPost() {
        RestRequest request = RestContext.request;
        String pdfKeyName = request.requestURI.replace(API_URL_BASE,'').replace(API_URL_PREFIX,'');
        System.debug(request);
        SogiShiryoOproAsyncResult result = SogiShiryoOproAsyncResult.parse(request.requestBody.toString());
        process(pdfKeyName,result);
    }

    public static void process(String pdfName,SogiShiryoOproAsyncResult result){
        OpfcConfs.Config theConfig = OpfcConfs.getConfig();
        String pdfConditions = theConfig.base_url + '/' + pdfName + '.pdf';
        System.debug(pdfConditions);
        List<SogiShiryoSofu__c> sogiShiryoSofu = [select Id, SogiShiryoSakuseiKekkaRef__c from SogiShiryoSofu__c where SofuShiryoURL__c =: pdfConditions];
        if(sogiShiryoSofu.size() > 0 ){
            String sakuseiId = sogiShiryoSofu.get(0).SogiShiryoSakuseiKekkaRef__c;
            SogiShiryoSakuseiKekka__c sakuseikekka = [select Id,StatusCode__c,Message__c,Message_body__c from SogiShiryoSakuseiKekka__c WHERE Id =: sakuseiId];
            sakuseikekka.StatusCode__c = Api_V1_OproAsynchronous.nullToZero(result.status).format();
            sakuseikekka.Message__c    = Api_V1_OproAsynchronous.nullToblank(result.statusDescription);
            if(Api_V1_OproAsynchronous.nullToZero(result.status) != 200 && Api_V1_OproAsynchronous.nullToZero(result.status) != 402 ){
                sakuseikekka.Message_body__c = Api_V1_OproAsynchronous.nullToblank(result.body);
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200708-1132-01', 'Api_V1_OproAsynchronous.process')
                    .putAttr('result.status', Api_V1_OproAsynchronous.nullToZero(result.status).format())
                    .putAttr('result.body', Api_V1_OproAsynchronous.nullToblank(result.body) )
                    .putAttr('pdfName',pdfConditions)
                );
            }
            update sakuseikekka;
        }
    }
    public static Integer nullToZero(Decimal value){
        if(value == null){
            return 0;
        }
        return value.intValue();
    }
    public static String nullToblank(String value){
        if(value == null){
            return '';
        }
        return value;
    }
}