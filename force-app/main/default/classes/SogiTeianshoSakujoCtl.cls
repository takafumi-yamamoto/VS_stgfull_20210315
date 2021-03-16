public class SogiTeianshoSakujoCtl {

    public class ResultSogiTeiansho {
        @AuraEnabled public Boolean err = false;
        @AuraEnabled public String msg = '';
    }
    
    @AuraEnabled
    public static ResultSogiTeiansho chkSogiTeiansho(String recordId){
        ResultSogiTeiansho res = new ResultSogiTeiansho();

        SogiShiryoSofu__c shiryoSofu = [select Id, SofuJokyo__c, (select Id from Teianshos__r) from SogiShiryoSofu__c where Id = :recordId];
        if(shiryoSofu.SofuJokyo__c != '資料作成中' && shiryoSofu.SofuJokyo__c != '情報確認中'){
            res.err = true;
            res.msg = '「送付状況」が資料作成中か情報確認中の場合のみ削除可能です';
            return res;
        }

        if(shiryoSofu.Teianshos__r.size() == 0){
            res.err = true;
            res.msg = '提案書がありません';
            return res;
        }

        return res;
    }

    @AuraEnabled
    public static ResultSogiTeiansho delSogiTeiansho(String recordId){
        ResultSogiTeiansho res = new ResultSogiTeiansho();

        try{
            delete [select Id, SofuJokyo__c, (select Id from Teianshos__r) from SogiShiryoSofu__c where Id = :recordId].Teianshos__r;
        }
        catch(Exception e){
            res.err = true;
            res.msg = e.getMessage();
        }

        return res;
    }
}