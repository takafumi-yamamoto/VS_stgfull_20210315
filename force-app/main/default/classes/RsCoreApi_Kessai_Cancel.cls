public class RsCoreApi_Kessai_Cancel {

    public class ReqArgs{
        public String seikyuBango = '';
    }

    public class Result{
        public Boolean isError = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String resBodyRaw = '';
        public String descr = '';
        public String seikyuBango = '';
    }

    public class Agent{
        public Result sendRequest(ReqArgs pReqArgs){
            RsCoreApi_Kessai_Cancel.Result theResult = new Result();
            try{
                theResult.seikyuBango = pReqArgs.seikyuBango;
                theResult.endPoint = RsCoreApi_Configs.getConfig().Endpoint__c + '/payments/seikyuBango/' + theResult.seikyuBango;
                
                HttpRequest request = new HttpRequest();
                request.setEndpoint(theResult.endPoint);
                request.setMethod('DELETE');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
                HttpResponse response = new http().send(request);
                
                theResult.statusCode = response.getStatusCode();
                if(theResult.statusCode != 200) theResult.isError = true;
                theResult.resBodyRaw = response.getBody();
            }catch(Exception e){
                theResult.isError = true;
                theResult.descr = e.getMessage();
                System.Debug(theResult.descr);
            }

            if( !theResult.isError ) this.logSuccess(theResult);
            if( theResult.isError ) this.logError(theResult);
            return theResult;
        }

        private void logError(Result pResult){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error,'20180607-1225-01', 'CoreKessai.CancelSeikyu.CoreApi','Error')
                    .putAttr('seikyuBango', pResult.seikyuBango)
                    .putAttr('endPoint', pResult.endPoint)
                    .putAttr('statusCode', String.valueOf(pResult.statusCode))
                    .putAttr('resBodyRaw', pResult.resBodyRaw)
                    .putAttr('descr', pResult.descr)
            );
        }
        private void logSuccess(Result pResult){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Info,'20180607-1225-02', 'CoreKessai.CancelSeikyu.CoreApi','Success')
                    .putAttr('seikyuBango', pResult.seikyuBango)
                    .putAttr('endPoint', pResult.endPoint)
                    .putAttr('statusCode', String.valueOf(pResult.statusCode) )
                    .putAttr('resBodyRaw', pResult.resBodyRaw)
                    .putAttr('descr', pResult.descr)
            );
        }
    }
}