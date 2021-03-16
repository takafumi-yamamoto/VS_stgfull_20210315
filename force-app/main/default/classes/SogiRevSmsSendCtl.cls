public class SogiRevSmsSendCtl {

    public Opportunity opp = new Opportunity();
    public String tel {get;set;}
    public String txt {get;set;}
    public Integer status {get;set;}
    public String msg {get;set;}
    
    public SogiRevSmsSendCtl(ApexPages.StandardController controller) {

        SogiRevServerConfig__mdt conf = [SELECT Id, base_url__c 
                                        FROM SogiRevServerConfig__mdt 
                                        WHERE DeveloperName = :Environments.isSandbox() ? 'dev' : 'prod'];

        Opportunity tempOpp = (Opportunity)controller.getRecord();
        opp = [SELECT Id, 
                        ShodanBango__c, 
                        Account.MobilePhoneFormula__c, 
                        SogiReviRef__c, 
                        SogiReviRef__r.ChoikinUrlSoshinNichiji__c, 
                        SogiReviRef__r.ChoikinUrlSoshinKaisu__c 
                FROM Opportunity 
                WHERE Id =: tempOpp.Id];

        tel = opp.Account.MobilePhoneFormula__c;
        txt = '葬儀レビです。先程はお電話ありがとうございました。' + '\r\n' +
                '\r\n' + 
                '葬儀レビ経由でお葬式をされた方で、申請いただいた方全員に弔慰金5,000円差し上げています。' + '\r\n' + 
                '\r\n' + 
                '弔慰金申請はこちら' + '\r\n' + 
                conf.base_url__c + '/chouikin/form.html?opp=' + opp.ShodanBango__c + '\r\n' + 
                '\r\n' + 
                'お問合せはこちらから' + '\r\n' + 
                '0120-542-991 (365日/24時間対応)';
    }

    public void sendSms(){

        AccreteSmsApi accreteSmsApi = new AccreteSmsApi();

        try {
            accreteSmsApi.smsReg(txt , tel, opp.ShodanBango__c);
            Decimal cnt = opp.SogiReviRef__r.ChoikinUrlSoshinKaisu__c == null ? 0 : opp.SogiReviRef__r.ChoikinUrlSoshinKaisu__c;

            update new SougiRev__c( Id=opp.SogiReviRef__c,
                                    ChoikinUrlSoshinKaisu__c = cnt+1,
                                    ChoikinUrlSoshinNichiji__c = datetime.now() );
            
            status = accreteSmsApi.statusCode;
            msg = '送信が完了しました';
        
        } catch (Exception e) {
            status = accreteSmsApi.statusCode;
            
            Map<String, Object> mapRes = accreteSmsApi.mapRes;
            if(mapRes == null || mapRes.get('result_code') == null) {
                msg = 'エラーが発生しました。システム管理者にご連絡ください。';
            }
            else {
                switch on Integer.valueOf(mapRes.get('result_code')) {
                    when 2005 { msg = '電話番号が指定されていません'; }
                    when 2006 { msg = '電話番号のフォーマットが不正です'; }
                    when 3001 { msg = '利用可能な電話番号帯ではありません'; }
                    when else { msg = 'エラーが発生しました。システム管理者にご連絡ください。'; }
                }
            }
            msg += ' (エラーコード：' + status + ')';
        }
    }
}