/*
* 決済結果通知受信
*/
public class WepPayKekkaUketsukeTaskProcessor implements Queueable {

    private WepPayKekkaUketsukeTask__c theTask;

    public WepPayKekkaUketsukeTaskProcessor(WepPayKekkaUketsukeTask__c aTask){
        List<WepPayKekkaUketsukeTask__c> taskList = [
            SELECT 
                    Id,
                    ErrorMessage__c ,    // ErrorMessage
                    ShoriStatus__c ,    // 処理ステータス
                    Status__c ,    // Status
                    SeikyuBango__c     // 請求番号
             FROM WepPayKekkaUketsukeTask__c
             WHERE ShoriStatus__c = '未処理'
             And Id = :aTask.Id
             ];
             System.debug(taskList);
        if(taskList != null && taskList.size() > 0){
            this.theTask = taskList[0];
        }
    }

    public void execute(QueueableContext context) {
        run();
    }

    private void run(){
        if(this.isAvaliable(this.theTask)) {
            updateOkyakusamaseikyu(this.theTask);
        } else {
            System.debug('The task is not avaliable !!' + this.theTask);
        }
    }


    private Boolean isAvaliable(WepPayKekkaUketsukeTask__c aTask){
        if(aTask == null) return false;
        //else if(aTask.TryCount__c >= aTask.RetryLimit__c) return false;
        return true;
    }

    private void updateOkyakusamaseikyu(WepPayKekkaUketsukeTask__c aTask){
        List<KessaiErrorLog__c> kessaiErrorLogList = new List<KessaiErrorLog__c>();
        List<OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiForUpdateList = new List<OkyakusamaSeikyuMeisai__c>();
        Map<Id, Opportunity> oppList = new Map<Id, Opportunity>();

        Set<Id> theSeikyuMeisaiIds = new Set<Id>();
        for(OkyakusamaSeikyuMeisai__c aSeikyuMeisai : 
            [ select Id from OkyakusamaSeikyuMeisai__c where SeikyuBango__c = :aTask.SeikyuBango__c ]
        ){ theSeikyuMeisaiIds.add(aSeikyuMeisai.Id); }

        List<OkyakusamaSeikyuMeisai__c> theSeikyuMeisais = [
            SELECT Id, SeikyuStatus__c, OpportunityRef__c, sokujiUriage__c, 
                    OpportunityRef__r.RecordType.DeveloperName,
                    OpportunityRef__r.SubPhase__c,
                    OpportunityRef__r.StageName
            FROM OkyakusamaSeikyuMeisai__c
            WHERE Id = :theSeikyuMeisaiIds
            FOR UPDATE
        ];

        for(OkyakusamaSeikyuMeisai__c seikyumeisai : theSeikyuMeisais){
            if(seikyumeisai.SeikyuStatus__c == '決済済' || seikyumeisai.SeikyuStatus__c == '売上確定済') continue;
            seikyumeisai.isSkipCrudPlicy__c = true;

            if( isKessaiOk(aTask) ){
                seikyumeisai.SeikyuStatus__c = '決済済';
                seikyumeisai.Kessaibi__c = Date.today();
                if( seikyumeisai.sokujiUriage__c ){
                    seikyumeisai.SeikyuStatus__c = '売上確定済';
                    seikyumeisai.UriageKakuteiBi__c = Date.today();
                } 
                if(seikyumeisai.OpportunityRef__r.RecordType.DeveloperName == 'Obosanbin'){
                    if( seikyumeisai.OpportunityRef__r.StageName == '決定' &&
                        seikyumeisai.OpportunityRef__r.SubPhase__c == 'クレジットカード決済待ち'){
                        oppList.put(seikyumeisai.OpportunityRef__c, new Opportunity(Id=seikyumeisai.OpportunityRef__c, 
                                                    SubPhase__c='依頼書・手配報告書作成'));
                    }
                }
            }

            // 他の情報を保存
            if( !isKessaiOk(aTask) ){
                seikyumeisai.SeikyuStatus__c = '決済NG';
                kessaiErrorLogList.add(getKessaiErrorLog(seikyumeisai.Id, aTask));
            } 

            okyakusamaSeikyuMeisaiForUpdateList.add(seikyumeisai);
        }

        if(theSeikyuMeisais == null || theSeikyuMeisais.size() == 0){
            aTask.ShoriStatus__c = 'エラー';
            update aTask;

            Loggings.Level level = Loggings.Level.Error;
            String title = '決済結果通知受信エラー';
            Loggings.writeLog(
               Loggings.createLogEntry(level, '201811291734', 'CoreKessai.WepPayKekkaUketsukeTaskProcessor', title)
                   .putAttr('task_id', aTask.id)
                   .putAttr('SeikyuBango', aTask.SeikyuBango__c)
                   .putAttr('Description', '請求明細が見つかりません！')
           );
            return;
        }

        Savepoint sp = Database.setSavepoint();
        try {
            if(okyakusamaSeikyuMeisaiForUpdateList.size() > 0) update okyakusamaSeikyuMeisaiForUpdateList;
            if(kessaiErrorLogList.size() > 0) insert kessaiErrorLogList;
            if(oppList.size() > 0) {
                AutoCreateOkyakusamaSeikyuMeisai.isActive = False;
                update oppList.values();
                AutoCreateOkyakusamaSeikyuMeisai.isActive = True;
            }

            aTask.ShoriStatus__c = '完了';
            update aTask;
        }
        catch (Exception ex) {
            Database.rollback(sp);

            // log
            Loggings.Level level = Loggings.Level.Error;
            String title = '決済結果通知受信エラー';
            Loggings.writeLog(
               Loggings.createLogEntry(level, '201811291733', 'CoreKessai.WepPayKekkaUketsukeTaskProcessor', title)
                   .putAttr('task_id', aTask.id)
                   .putAttr('SeikyuBango', aTask.SeikyuBango__c)
                   .putAttr('Exception', ex.getMessage())
           );

        }
    }

    private KessaiErrorLog__c getKessaiErrorLog(String seikyuRef, WepPayKekkaUketsukeTask__c aTask){
        KessaiErrorLog__c sobj = new KessaiErrorLog__c();
        sobj.SeikyuRef__c = seikyuRef;    // お客様請求明細
        sobj.Descr__c = aTask.ErrorMessage__c;    // 内容
        sobj.HasseiDateTime__c = datetime.now();    // 発生日時
        return sobj;
    }

    private Boolean isKessaiOk(WepPayKekkaUketsukeTask__c aTask){
        return aTask.Status__c == 'success';
    }

}