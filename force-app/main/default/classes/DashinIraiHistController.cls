public class DashinIraiHistController {
    public class TableRow {
        @AuraEnabled public String Id {get; set;}
        @AuraEnabled public String Answer {get; set;}
        @AuraEnabled public String DashinSaki {get; set;}
        @AuraEnabled public String Jinmei {get; set;}
        @AuraEnabled public String KekkaNitiji {get; set;}
    }

    @AuraEnabled
    public static List<TableRow> doInit(String recordId) {
        return getDashSakiList(recordId);
    }

    private static List<TableRow> getDashSakiList(String oppId) {
        List<TableRow> tablerows = new List<TableRow>();
        Set<String> dashinIraiIds = new Set<String>();
        for (DashIraiHist__c dashinIraiHist : [
            SELECT Id, DashIraiRef__c
            FROM DashIraiHist__c
            WHERE OppRef__c = :oppId
        ]) {
            dashinIraiIds.add(dashinIraiHist.DashIraiRef__c);
        }
        for(DashSaki__c dashsaki : [
            SELECT
                Id,
                Name,
                Answer__c,
                DashIraiRef__c,
                DashIraiRef__r.KekkaJushinNichiji__c,
                DashinSakiRef__c,
                DashinSakiRef__r.Name,
                DashinSakiRef__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,
                KeiyakuBango__c
            FROM DashSaki__c
            WHERE DashIraiRef__c = :dashinIraiIds
            AND DashIraiRef__r.KekkaJushinNichiji__c != null
        ]){
            System.debug(dashsaki);
            TableRow row = new TableRow();
            row.Id = dashsaki.Id;

            row.Answer = getAnswerVal(dashsaki.Answer__c);
            row.DashinSaki = dashsaki.DashinSakiRef__r.Name;
            row.Jinmei = dashsaki.DashinSakiRef__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name;
            row.KekkaNitiji = dashsaki.DashIraiRef__r.KekkaJushinNichiji__c != null ?
                                dashsaki.DashIraiRef__r.KekkaJushinNichiji__c.format('YYYY/MM/dd HH:mm')
                                : '';
            tablerows.add(row);
        }
        return tablerows;
    }

    private static String getAnswerVal(String answerCode){
        Map<String, String> answers = new Map<String, String>{
            'accept' => '受諾',
            'reject' => '辞退'
        };
        return answers.get(answerCode);
    }
}