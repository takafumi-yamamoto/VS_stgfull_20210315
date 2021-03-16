public class SogiShiryoSofuInitialProcessing {

    public static void OnBeforeInsert(List<SogiShiryoSofu__c> newList){
        
        for(SogiShiryoSofu__c sofu : newList){
            sofu.SearchHikitsugiJikoUmu__c = resolveHikitsugiJiko(sofu.HikitsugiJiko__c);
            sofu.SogiShiryoSakuseiKekkaRef__c = createSogiShiryoSakuseiKekka();
        }
    }

    public static void OnBeforeUpdate(List<SogiShiryoSofu__c> newList){
        
        for(SogiShiryoSofu__c sofu : newList){
            sofu.SearchHikitsugiJikoUmu__c = resolveHikitsugiJiko(sofu.HikitsugiJiko__c);
        }
    }

    private static String resolveHikitsugiJiko(String val){
        return String.isBlank(val) ? '文言なし' : '文言有';
    }

    private static String createSogiShiryoSakuseiKekka(){
        return Database.insert(new SogiShiryoSakuseiKekka__c()).getId();
    }
}