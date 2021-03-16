public class SaijoSogiReviSyncQms implements IHdlQms{
    public static String msgType = 'SaijoSogiReviSyncQms';

    public class Data{
        public String saijoId;
        public String method;
    }

    public static List<Qms__c> createPostQmses(List<Saijo__c> saijoList){
        List<Qms__c> theQmses = new List<Qms__c>();
        for(Saijo__c aSaijo : saijoList){
            Data theData = new Data();
            theData.saijoId = aSaijo.SaijoKeisaiJohoId__c;
            theData.method = 'POST';
            theQmses.add(
                QmsBld.newRoot().setMsgType( SaijoSogiReviSyncQms.msgType ).setData( JSON.serialize( theData ) ).build()
            );
        }
        return theQmses;
    }
    public static List<Qms__c> createDeleteQmses(List<Saijo__c> saijoList){
        List<Qms__c> theQmses = new List<Qms__c>();
        for(Saijo__c aSaijo : saijoList){
            Data theData = new Data();
            theData.saijoId = aSaijo.SaijoKeisaiJohoId__c;
            theData.method = 'DELETE';
            theQmses.add(
                QmsBld.newRoot().setMsgType( SaijoSogiReviSyncQms.msgType ).setData( JSON.serialize( theData ) ).build()
            );
        }
        return theQmses;
    }

    public void handleQms(Qms__c pQms){
        try{
            System.enqueueJob( new jobRun(pQms) );
        }catch(Exception ex){
            UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190917-1511', msgType)
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
    }

    private class jobRun implements Queueable,Database.AllowsCallouts{
        private Qms__c pQms;

        public jobRun(Qms__c pQms){ this.pQms = pQms; }

        public void execute(QueueableContext context) { this.run(); }

        private void run(){

            Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);

            String theMethod = '';
            String theMsgBody = '';

            if(theData.method == 'DELETE'){
                theMethod = 'DELETE';
                theMsgBody = '{\"id\":\"' + theData.saijoId + '\"}';
            }

            if(theData.method == 'POST'){
                theMethod = 'POST';

                String objName = 'Saijo__c';
                sObject newObj = (sObject)Type.forName(objName).newInstance();
                Schema.DescribeSObjectResult descResult = newObj.getsObjectType().getDescribe();
                String soql = 'Select ' + concatSet(descResult.fields.getMap().keySet(), ', ') + ' From ' + objName + ' Where SaijoKeisaiJohoId__c = \'' + theData.saijoId + '\'';
                System.debug('soql:' + soql);
                Saijo__c saijo = Database.query(soql);
                theMsgBody = serializeNullInclude(descResult.fields.getMap(), saijo);
            }

            Boolean isError = false;
            try{
                if(RsCoreApi_Configs.getConfig().IsShisetsuRenkeiYuko__c){  
                    HttpRequest request = new HttpRequest();

                    SogiRevServerConfig__mdt conf = [SELECT Id, base_url__c, basic_authorization_id__c, basic_authorization_pass__c  
                                                        FROM SogiRevServerConfig__mdt 
                                                        WHERE DeveloperName = :Environments.isSandbox() ? 'dev' : 'prod'];
                    String theEndPoint = conf.base_url__c + '/api/sync/salesforce/hall';
                    Blob headerValue = Blob.valueOf(conf.basic_authorization_id__c + ':' + conf.basic_authorization_pass__c);
                    request.setEndpoint(theEndPoint);
                    request.setMethod(theMethod);
                    request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(headerValue));
                    request.setBody(theMsgBody);
                    RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
                    HttpResponse response = new http().send(request);
                    Integer theStatusCode = response.getStatusCode();
                    if(theStatusCode!=200) isError = true;
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Info, '20200826-1627-1', 'SaijoSogiReviSyncQms')
                        .setSubjectRecordId(pQms.Id)
                        .putAttr('theStatusCode', String.valueOf(theStatusCode) )
                        .putAttr('theMsgBody', theMsgBody )
                        .putAttr('theMethod', theMethod )
                        .putAttr('theEndPoint', theEndPoint)
                        .putAttr('theResBody', response.getBody())
                    );
                }
            }catch(Exception e){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200826-1627-2', 'SaijoSogiReviSyncQms')
                    .setSubjectRecordId(pQms.Id)
                    .putAttr('Exception', e.getMessage())
                    .putAttr('LineNumber', '' + e.getLineNumber())
                    .putAttr('getStackTraceString', e.getStackTraceString())
                );
                isError = true;
            }

            if(isError){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200826-1627-3', 'SaijoSogiReviSyncQms')
                    .setSubjectRecordId(pQms.Id)
                );
                UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
            }

            if(!isError) UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
        }

        private String concatSet(Set<String> strSet, String sep) {
            String retStr;
            for (String str : strSet) { retStr = retStr == null ? str : retStr + sep + str; }
            return retStr == null ? '' : retStr;
        }

        private String serializeNullInclude(Map<String, Schema.SObjectField> fieldMap, Saijo__c saijo){
            String strJson = '{';
            for(Schema.SObjectField field : fieldMap.values()){
                String str = field.getDescribe().getName();
                Object saijoFieldObj = saijo.get(str);

                if(field.getDescribe().getType() == Schema.DisplayType.TextArea || field.getDescribe().getType() == Schema.DisplayType.String){
                    strJson += '"' + str + '":"' + strEscape(saijoFieldObj) + '",';
                }
                else{
                    strJson += '"' + str + '":"' + urlEncodingProcessing(str, saijoFieldObj) + '",';
                }
            }
            strJson = strJson.removeEnd(',');
            strJson += '}';
            System.debug('strJson:' + strJson);
            return strJson;
        }

        private String strEscape(Object obj){
            String str = (String)obj;
            if(str == null) return str;

            str = str.replace('\r\n', '¥r¥n');
            str = str.replace('\n', '¥n');
            str = str.replace('\t', '¥t');
            str = str.replace('"', '”');
            return str;
        }

        private Object urlEncodingProcessing(String key, Object obj){
            if(key == 'saijojohoprintpagesimple__c') return EncodingUtil.urlEncode((String)obj, 'UTF-8');
            if(key == 'saijojohoprintpageyasugo__c') return EncodingUtil.urlEncode((String)obj, 'UTF-8');
            return obj;
        }
    }
}