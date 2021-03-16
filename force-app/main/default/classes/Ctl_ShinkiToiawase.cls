public class Ctl_ShinkiToiawase {
    
    public Ctl_ShinkiToiawase() {}

    @AuraEnabled 
    public static String auraShanaiFlg(){
        String shanaiFlg = 'shanai';
        Profile p = [select id, Name FROM Profile Where id = :UserInfo.getProfileId()];
        System.debug('p.Name:' + p.Name);
        if(p.Name == '社外ライフデザイン'){
            shanaiFlg = 'shagai';
        }
        return shanaiFlg;
    }

    /**
     * Auraイベント：手動問い合わせ作成
     *
     * @Auther Yamamoto
     * @return サービス商談ID
     */ 
    @AuraEnabled
    public static String auraShinkiToiawase(String recordTypeDevName) {
        System.debug('auraShinkiToiawase start');

        Case insCaseObj = insertCase(recordTypeDevName);

        /*if(recordTypeDevName == 'KakuyasuButsudan'){
            return insCaseObj.Id;
        }*/

        System.debug('auraShinkiToiawase end');
        return new OpportunityDao().SelectByCaseId(insCaseObj.Id).Id;
    }

    /**
     * ケース作成 
     */
    private static Case insertCase(String recordTypeDevName){
        System.debug('insertCase start');

        RecordType recordType = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Case', recordTypeDevName);

        Case insCase = new Case();
        insCase.Status = '対応中';
        insCase.Origin = '電話';
        insCase.Priority = '中';
        insCase.Type = 'サービス利用';
        insCase.RecordTypeId = recordType.Id;
        insCase.ToiawaseDate__c = datetime.now();
        insert insCase;

        System.debug('insertCase end');
        return insCase;
    }
}