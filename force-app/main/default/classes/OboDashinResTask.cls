public class OboDashinResTask implements Queueable{

    //AsyncBegin
    public OboDashinResTask(Id pTaskId){ this.f_TaskId = pTaskId; }
    private Id f_TaskId = null;
    private void runTask(Id pTaskId){
        OboDashinResTask__c theTask = (OboDashinResTask__c)SobjectsExtension.firstOrNull(
            [
                select 
                Id, data__c
                from OboDashinResTask__c 
                where Id = :pTaskId
                limit 1
            ]
        );
        if(theTask == null) return;

        try{
            Api_V1_OboDashinRes.ReqBody theReqBody = (Api_V1_OboDashinRes.ReqBody)JSON.deserialize(theTask.data__c, Api_V1_OboDashinRes.ReqBody.class);
            
            DashIrai__c theDashIrai = (DashIrai__c)SobjectsExtension.firstOrNull(
                [
                    SELECT Id, content_type__c,
                    koho_datetime1__c, koho_datetime2__c, koho_datetime3__c,
                    tsuya_datetime__c, kokubetsu_datetime__c, kaso_datetime__c,
                    OwnerId
                    FROM DashIrai__c 
                    WHERE offer_id__c = :theReqBody.offer_Id
                    LIMIT 1
                ]
            );
            Opportunity theOpp = (Opportunity)SobjectsExtension.firstOrNull(
                [
                    SELECT Id, StageName, SubPhase__c, ObosanbinRef__c, ShodanBango__c
                    FROM Opportunity
                    WHERE ShodanBango__c = :theReqBody.shodan_bango
                    LIMIT 1
                ]
            );
            Obosanbin__c theObou = (Obosanbin__c)SobjectsExtension.firstOrNull(
                [
                    SELECT Id, ObosanbinKeiyakuMadoguchi__c
                    FROM Obosanbin__c
                    WHERE Id = :theOpp.ObosanbinRef__c
                    LIMIT 1
                ]
            );

            List<DashSaki__c> theDashSakis = [
                SELECT Id, KeiyakuBango__c
                FROM DashSaki__c
                WHERE DashIraiRef__c = :theDashIrai.Id
            ];

            //DashinIrai BEGIN
            theDashIrai.KekkaJushinNichiji__c = Datetime.now();

            If(theReqBody.result == 'ng'){ 
                theDashIrai.Result__c = 'NG';
                theDashIrai.Status__c = 'NG-DashinNG'; 
            }

            If(theReqBody.result == 'ok'){
                theDashIrai.Result__c = 'OK';
                
                theDashIrai.kekka_kettei_datetime__c = theReqBody.parseAcceptedDateTime();

                Keiyaku__c theSokyakuSaki = 
                    (Keiyaku__c)SobjectsExtension.firstOrNull( [ SELECT Id FROM Keiyaku__c WHERE KeiyakuBango__c = :theReqBody.sokyakusaki ] );
                theDashIrai.KekkaSokyakuSakiRef__c = theSokyakuSaki.Id;

                Keiyaku__c theSekoTanto = 
                    (Keiyaku__c)SobjectsExtension.firstOrNull( [ SELECT Id FROM Keiyaku__c WHERE KeiyakuBango__c = :theReqBody.sekotanto ] );
                theDashIrai.KekkaSekoTantoRef__c = theSekoTanto.Id;

                Boolean canKetteiShori = 
                    theOpp.StageName == '決定'
                    && (theOpp.SubPhase__c == '僧侶手配（自動打診）' || theOpp.SubPhase__c == 'スケジュール確認中（自動打診）' )
                    && theObou.ObosanbinKeiyakuMadoguchi__c == null;

                if(!canKetteiShori){ theDashIrai.Status__c = 'NG-DashinOK-KetteiNG'; }
                if(canKetteiShori){ theDashIrai.Status__c = 'OK';  }
            }

            If(theDashIrai.Status__c == 'NG-DashinOK-KetteiNG'){
                theDashIrai.StatusDescr__c = '僧侶手配はできましたが、すでに窓口僧侶が登録されているか、フェーズが変更されているため、登録処理を停止しました。';
            }

            UPDATE theDashIrai;
            //DashinIrai END

            //Opportunity-Obosanbin BEGIN
            If(theDashIrai.Status__c == 'OK'){
                if(theDashIrai.kekka_kettei_datetime__c!=null){
                    theObou.KokubetsuDateTime_Inp__c = theDashIrai.kekka_kettei_datetime__c;
                }
                theObou.ObosanbinKeiyakuMadoguchi__c = theDashIrai.KekkaSokyakuSakiRef__c;
                theObou.ObosanbinKeiyakuSekotanto__c = theDashIrai.KekkaSekoTantoRef__c;
                theOpp.SubPhase__c = '僧侶決定連絡';
                UPDATE theObou;
                UPDATE theOpp;
            }
            If(theDashIrai.Status__c == 'NG-DashinOK-KetteiNG'){
                if(theOpp.SubPhase__c == '僧侶手配（自動打診）' || theOpp.SubPhase__c == 'スケジュール確認中（自動打診）' ){
                    theOpp.SubPhase__c = '自動打診エラー';
                    UPDATE theOpp;
                }
            }
            If(theDashIrai.Status__c == 'NG-DashinNG'){
                if(theOpp.SubPhase__c == '僧侶手配（自動打診）' || theOpp.SubPhase__c == 'スケジュール確認中（自動打診）' ){
                    theOpp.SubPhase__c = '僧侶手配';
                    UPDATE theOpp;
                }
            }
            //Opportunity-Obosanbin END

            //Dashinsaki Begin
            for(Api_V1_OboDashinRes.reply aReply : theReqBody.replies){
                DashSaki__c aDashSaki = this.findDashinSakiByKeiyakuBango( theDashSakis, aReply.keiyaku_bango );
                if(aDashSaki == null) continue;
                if(aReply.answer == 'accept') aDashSaki.Answer__c = 'accept';
                if(aReply.answer == 'reject') aDashSaki.Answer__c = 'reject';
            }
            UPDATE theDashSakis;
            //Dashinsaki End

            //RejectedEvents Begin
            List<Event> theRejectedEvents = new List<Event>();
            
            OboDashinResTaskEvents.CreateRejectedEventArg theCreateRejectedEventArg = new OboDashinResTaskEvents.CreateRejectedEventArg();
            theCreateRejectedEventArg.DashinIraiId = theDashIrai.Id;
            theCreateRejectedEventArg.OwnerId = theDashIrai.OwnerId;
            theCreateRejectedEventArg.RejectedKeiyakuBangos = theReqBody.collectRejectedKeiyakuBangos();
            if ( theDashIrai.content_type__c == 'hoyo'){
                theCreateRejectedEventArg.HoyoKohoDatetime1 = theDashIrai.koho_datetime1__c;
                theCreateRejectedEventArg.HoyoKohoDatetime2 = theDashIrai.koho_datetime2__c;
                theCreateRejectedEventArg.HoyoKohoDatetime3 = theDashIrai.koho_datetime3__c;
            }
            if ( theDashIrai.content_type__c == 'sogi'){
                theCreateRejectedEventArg.TsuyaDatetime = theDashIrai.tsuya_datetime__c;
                theCreateRejectedEventArg.KokubetsuDatetime = theDashIrai.kokubetsu_datetime__c;
                theCreateRejectedEventArg.KasoDatetime = theDashIrai.kaso_datetime__c;
            }
            
            theRejectedEvents = new OboDashinResTaskEvents().createRejectedEvents(theCreateRejectedEventArg);
            INSERT theRejectedEvents;
            //RejectedEvents End

            //MailAlert Begin
            List<MailAlert__c> theMailAlerts = new List<MailAlert__c>();
            If(theDashIrai.Status__c == 'NG-DashinNG' ){ 
                OboDashin_DashinNGMail.CreateMailArg theArg = new OboDashin_DashinNGMail.CreateMailArg();
                theArg.ShodanBango = theOpp.ShodanBango__c;
                theArg.ShodanId = theOpp.Id;
                theArg.DashinIraiId = theDashIrai.Id;
                theMailAlerts.add( new OboDashin_DashinNGMail().createMail(theArg) );
            }
            If(theDashIrai.Status__c == 'NG-DashinOK-KetteiNG'){
                OboDashin_KetteiNGMail.CreateMailArg theArg = new OboDashin_KetteiNGMail.CreateMailArg();
                theArg.ShodanBango = theOpp.ShodanBango__c;
                theArg.ShodanId = theOpp.Id;
                theArg.DashinIraiId = theDashIrai.Id;
                theMailAlerts.add( new OboDashin_KetteiNGMail().createMail(theArg) );
            }
            INSERT theMailAlerts;
            //MailAlert End

            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;

        } catch (Exception e){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            System.Debug( e.getMessage() );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20190529-1333-01', 'OboDashinResTask')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
                    .putAttr( 'e.getLineNumber()', String.valueOf(e.getLineNumber())  )
                    .putAttr( 'e.getStackTraceString()', e.getStackTraceString() )
            );
            return;
        }
    }

    public void execute(QueueableContext context) {
        this.runTask( this.f_TaskId );
    }
    //AsyncEnd

    private DashSaki__c findDashinSakiByKeiyakuBango(List<DashSaki__c> pDashinSakis, String pKeiyakuBango){
        for(DashSaki__c aDashSaki : pDashinSakis){
            if(aDashSaki.KeiyakuBango__c == pKeiyakuBango) return aDashSaki;
        }
        return null;
    }

}