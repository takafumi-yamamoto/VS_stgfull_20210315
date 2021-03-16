public class Aos_SMSSendingMessage_ObosanJizenSms {

    public void handle(SMSHistory__c aosHist){

        String taskId = aosHist.ClientTag__c.split(',')[4];
        List<JizenKakuninSmsTask__c> taskList = [
            Select id, name, JizenKakuninKbn__c, AccountRef__c, OpportunityRef__c ,OpportunityRef__r.ObosanbinRef__c
            From JizenKakuninSmsTask__c 
            where id = :taskId
            limit 1
            ];

        if( taskList.size()<=0 ) return;
        JizenKakuninSmsTask__c theTask = taskList.get(0);
        Boolean sendSmsStatus = aosHist.StatusId__c =='2'; //送達ステータス 2：成功　3:失敗

        if( !String.isBlank(theTask.OpportunityRef__r.ObosanbinRef__c) ) {
            Obosanbin__c obo = new Obosanbin__c(Id=theTask.OpportunityRef__r.ObosanbinRef__c);
            String result = sendSmsStatus ? '送達確認済' : 'エラー';
            String bikou = sendSmsStatus ? null : '送達エラー';
            if(theTask.JizenKakuninKbn__c == '1日前'){
                obo.JizenSmsBf1Status__c = result;
                obo.JizenSmsBf1SoutatsuResultDate__c = Date.today();
                obo.JzenSmsBf1StatusDescr__c = bikou;
            }else if(theTask.JizenKakuninKbn__c == '7日前'){
                obo.JizenSmsBf7Status__c = result;
                obo.JizenSmsBf7SoutatsuResultDate__c = Date.today();
                obo.JzenSmsBf7StatusDescr__c = bikou;
            }
            update obo;
        }

        if( !String.isBlank(theTask.OpportunityRef__c) ) {
            List<Opportunity> tmpopplist = [Select id, SubPhase__c From Opportunity Where Id = :theTask.OpportunityRef__c limit 1];
            if(tmpopplist.size() > 0){
                Opportunity opp = tmpopplist[0];
                if( sendSmsStatus ) {
                    if(theTask.JizenKakuninKbn__c == '1日前' && opp.SubPhase__c == '事前確認連絡1日前（SMS）'){
                        opp.StageName = '施行完了';
                        opp.SubPhase__c = '商談確定承認待ち';
                    }else if(theTask.JizenKakuninKbn__c == '7日前' && opp.SubPhase__c == '事前確認連絡7日前（SMS）'){
                        opp.SubPhase__c = '事前確認連絡1日前（SMS）';
                    }
                } else{
                    opp.SubPhase__c = '事前確認連絡（電話）';
                }
                update opp;
            }
        }

        if( !sendSmsStatus && !String.isBlank(theTask.OpportunityRef__r.ObosanbinRef__c)  ) {
            List<Obosanbin__c> oboList = [Select id, ObosanbinKeiyakuMadoguchi__c FROM Obosanbin__c Where id = :theTask.OpportunityRef__r.ObosanbinRef__c];
            if( oboList.size()> 0){
                Id keiyakuId = oboList[0].ObosanbinKeiyakuMadoguchi__c;
                if(String.isNotBlank(keiyakuId)){
                    Keiyaku__c keiyaku = new Keiyaku__c(Id = keiyakuId, Jizenkakuninhouhou__c = '電話');
                    update keiyaku;
                }
            }
        }

        if( theTask.AccountRef__c != null ) {
            aosHist.Account__c = theTask.AccountRef__c;
        }
        Insert aosHist;
    }

}