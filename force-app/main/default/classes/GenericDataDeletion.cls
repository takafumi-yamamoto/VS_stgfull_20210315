public without sharing class GenericDataDeletion {

    @AuraEnabled
    public static String executionDelete(String recordId) {

        String msg = '削除が完了しました。';

        try{
            String objName;
            String headFiled = recordId.substring(0, 3);  //先頭から3文字
            for (Schema.SObjectType globalSOType : Schema.getGlobalDescribe().values()) {
                String prefix = globalSOType.getDescribe().getKeyPrefix();
                if( headFiled.equals(prefix)){
                    objName = globalSOType.getDescribe().getName();
                    break;
                }
            }
            
            String query = 'Select Id From ' + objName + ' Where Id = \'' + recordId + '\'';
            delete Database.query(query );
        }
        catch(Exception e){
            msg = 'エラーが発生しました。システム管理者へ連絡してください。' + '\r\n' + e.getMessage();
        }
        
        return msg;
    }
}