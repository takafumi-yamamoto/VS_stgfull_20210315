public class KeiyakuCoreSyncings {

    /*手数料適用単位連携 Begin*/
    public void subscriveOnTesuryoTekiyoAfterUpdated(List<TesuryoTekiyo__c> pNewOnes, Map<Id,TesuryoTekiyo__c> pOldOnes){
        List<Id> theTesuryoTekiyoIdsToBeProcessed = new List<Id>();
        for(TesuryoTekiyo__c aNewOne : pNewOnes){
            TesuryoTekiyo__c aOldOne = pOldOnes.get(aNewOne.Id);
            if(aNewOne.ShoninStatus__c == aOldOne.ShoninStatus__c ) continue;
            if(aNewOne.ShoninStatus__c == '承認済' || aOldOne.ShoninStatus__c == '承認済' ) theTesuryoTekiyoIdsToBeProcessed.add(aNewOne.Id);
        }
        this.runTesuryoTekiyoSyncingTasks( theTesuryoTekiyoIdsToBeProcessed );
    }

    public void runTesuryoTekiyoSyncingTasks(List<Id> pTesuryoTekiyoIds){
        for(TesuryoTekiyoSyncingTask aTask : this.createTesuryoTekiyoSyncingTasks(pTesuryoTekiyoIds) ){
            System.enqueueJob(aTask);
        }
    }

    private List<TesuryoTekiyoSyncingTask> createTesuryoTekiyoSyncingTasks(List<Id> pTesuryoTekiyoIds){
        List<TesuryoTekiyoSyncingTask> theTesuryoTekiyoSyncingTasks = new List<TesuryoTekiyoSyncingTask>();

        List<TesuryoTekiyo__c> theTesuryoTekiyos = new List<TesuryoTekiyo__c>(
            [
                select Id, Name,
                ShoninStatus__c, TekiyoKaishiBi__c, TekiyoSyuryoBi__c,
                RyoriTesuryoAri__c, HenreihinTesuryoAri__c, OptionTesuryoAri__c, CardLoanTesuryoAri__c, AtobaraiTesuryoAri__c, 
                UrnOptionTesuryoFlg__c, YorisoOptionFlowersTesuryoFlg__c,
                TesuryoPlanRef__r.CoreTesuryoPlanId__c,
                KeiyakuRef__r.KeiyakuBango__c, 
                KeiyakuRef__r.TeikesakiTorihikisakiBango__c, KeiyakuRef__r.Teikeisaki__r.name, 
                KeiyakuRef__r.CoreRenkeiSchemeExp__c, KeiyakuRef__r.ServiceId__c,
                (
                    select Id
                    from TesuryoTekiyo_TesuryoNebikiEntry__R
                )
                from TesuryoTekiyo__c
                where Id = :pTesuryoTekiyoIds
            ]
        );

        for(TesuryoTekiyo__c aTesuryoTekiyo : theTesuryoTekiyos ){
            if( aTesuryoTekiyo.KeiyakuRef__r.CoreRenkeiSchemeExp__c!='手数料適用単位' ) continue;
            if( aTesuryoTekiyo.KeiyakuRef__r.ServiceId__c =='0' ) continue;
            theTesuryoTekiyoSyncingTasks.add( new TesuryoTekiyoSyncingTask(aTesuryoTekiyo) );
        }
        return theTesuryoTekiyoSyncingTasks;
    }

    private class TesuryoTekiyoSyncingTask implements Queueable,Database.AllowsCallouts{
        private Ctl_TesuryoTekiyoTransferService f_corePayloadBuilder = new Ctl_TesuryoTekiyoTransferService();
        private TesuryoTekiyo__c f_TesuryoTekiyo = null;
        private TesuryoTekiyoSyncingTask(TesuryoTekiyo__c pTesuryoTekiyo){ this.f_TesuryoTekiyo = pTesuryoTekiyo; }

        public void execute(QueueableContext context) { this.run(); }

        public void run(){
            
            KeiyakuCoreSyncResult theResult = new KeiyakuCoreSyncResult();
            try{
                TesuryoTekiyo__c theTesuryoTekiyo = this.f_TesuryoTekiyo;
                if(theTesuryoTekiyo.KeiyakuRef__r.CoreRenkeiSchemeExp__c != '手数料適用単位') throw new KeiyakuCoreSyncingsException('コア連携スキーム不一致' );

                theResult.subjectRecordId = theTesuryoTekiyo.Id;
                theResult.keiyakuBango = theTesuryoTekiyo.KeiyakuRef__r.keiyakuBango__c;

                KeiyakuCoreSyncResult theCallOutResult = 
                    new RsCoreApi_Contracts_Agent().sendRequest(
                        this.f_corePayloadBuilder.getJsonBody( theTesuryoTekiyo )
                    );

                theResult.endPoint = theCallOutResult.endPoint;
                theResult.reqBodyRaw = theCallOutResult.reqBodyRaw;
                theResult.statusCode = theCallOutResult.statusCode;
                theResult.isSuccess = theCallOutResult.isSuccess;
            }catch(Exception e){
                System.Debug( e.getMessage() );
                theResult.descr = e.getMessage();
            }

			Loggings.writeLog(
				Loggings.createLogEntry( theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20180629-1625-02', 'CoreRenkei.Keiyaku.TesuryoTekiyo')
					.setSubjectRecordId( theResult.subjectRecordId )
					.putAttr('endPoint', theResult.endPoint )
					.putAttr('reqBodyRaw', theResult.reqBodyRaw )
					.putAttr('statusCode', String.valueOf( theResult.statusCode ) )
                    .putAttr('descr', String.valueOf( theResult.descr ) )
                    .putAttr('keiyakuBango', theResult.keiyakuBango )
			);
        }
    }
    /*手数料適用単位連携 End*/

    private class KeiyakuCoreSyncResult{
        private Boolean isSuccess = false;
        private String endPoint = '';
        private String reqBodyRaw = '';
        private Integer statusCode = 0;
        private String descr = '';
        private String keiyakuBango = '';
        private String subjectRecordId = '';
    }

    public class KeiyakuCoreSyncingsException extends Exception {}

    public class RsCoreApi_Contracts_Agent{
        public KeiyakuCoreSyncResult sendRequest(string pPayLoad){
            KeiyakuCoreSyncResult theResult = new KeiyakuCoreSyncResult();
            try{
                HttpRequest theReq = new HttpRequest();
                theResult.endPoint = RsCoreApi_Configs.getConfig().EndPoint__c + +'/master/contract/';
                theReq.setEndpoint( theResult.endPoint );
                theReq.setMethod('PUT');
                theReq.setHeader('Content-Type', 'application/json;charset=UTF-8');
                theResult.reqBodyRaw = pPayLoad;
                theReq.setBody( theResult.reqBodyRaw );

                if( !RsCoreApi_Configs.getConfig().KeiyakuCoreFlag__c || !RsCoreApi_Configs.getConfig().isActive__c ){
                    theResult.isSuccess = true;
                    return theResult;
                }

                RsCoreApi_AuthClients.getInstance().setAuthHeader(theReq);
                HttpResponse theRes = new http().send(theReq);
                theResult.statusCode = theRes.getStatusCode();
                if(theResult.statusCode == 200) theResult.isSuccess = true;
            }catch(Exception e){
                System.Debug( e.getMessage() );
                theResult.descr = e.getMessage();
            }
            return theResult;
        }
    }

}