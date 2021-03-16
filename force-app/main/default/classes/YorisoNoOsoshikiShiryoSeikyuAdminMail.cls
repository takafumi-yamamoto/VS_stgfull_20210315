public class YorisoNoOsoshikiShiryoSeikyuAdminMail {

    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('YorisoNoOsoshikiShiryoSeikyuAdmin');

    public class CreateMailArg{
        public String title = '';
        public String salesforceOrgURL = '';
        public String jidoShiryoSofuKekka = '';
        public String duplicationCheckAccountUrl = '';
        public String addressConfirmInfo = '';
        public String chuiMsg = '';
        public String uniq_id = '';
        public String kiboAreaState = '';
        public String kiboAreaCity = '';
        public String taishoshaKyojuKeitai = '';
        public String taishoushaJokyo = '';
        public String webShiryoSeikyuTaishoushaJokyo = '';
        public String taishoshaYomeiKikan = '';
        public String toiawaseKiinsha = '';
        public String endingNoteFlg = '';
        public String toiawaseDate = '';
    }

    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        if( String.isBlank(pCreateMailArg.title) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.salesforceOrgURL) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.uniq_id) ) throw new RequestInvalidException();
        
        theMailAlert.Title__c = pCreateMailArg.title
            .replace('{{受付番号}}', pCreateMailArg.uniq_id);
        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{{データリンク}}', pCreateMailArg.salesforceOrgURL)
            .replace('{{自動資料送付結果}}', String.isBlank(pCreateMailArg.jidoShiryoSofuKekka) ? '' : pCreateMailArg.jidoShiryoSofuKekka)
            .replace('{{重複取引先}}', String.isBlank(pCreateMailArg.duplicationCheckAccountUrl) ? 'なし' : pCreateMailArg.duplicationCheckAccountUrl )
            .replace('{{住所確認情報}}', String.isBlank(pCreateMailArg.addressConfirmInfo) ? 'なし' : pCreateMailArg.addressConfirmInfo )
            .replace('{{注意メッセージ}}', String.isBlank(pCreateMailArg.chuiMsg) ? '' : pCreateMailArg.chuiMsg )
            .replace('{{受付番号}}', String.isBlank(pCreateMailArg.uniq_id) ? '' : pCreateMailArg.uniq_id )
            .replace('{{希望都道府県}}', String.isBlank(pCreateMailArg.kiboAreaState) ? '' : pCreateMailArg.kiboAreaState )
            .replace('{{希望市区郡}}', String.isBlank(pCreateMailArg.kiboAreaCity) ? '' : pCreateMailArg.kiboAreaCity )
            .replace('{{対象者様居住状態（初回）}}', String.isBlank(pCreateMailArg.taishoshaKyojuKeitai) ? '' : pCreateMailArg.taishoshaKyojuKeitai )
            .replace('{{対象者様のご状態（初回）}}', String.isBlank(pCreateMailArg.taishoushaJokyo) ? '' : pCreateMailArg.taishoushaJokyo )
            .replace('{{対象者様のご状況}}', String.isBlank(pCreateMailArg.webShiryoSeikyuTaishoushaJokyo) ? '' : pCreateMailArg.webShiryoSeikyuTaishoushaJokyo )
            .replace('{{余命期間（初回）}}', String.isBlank(pCreateMailArg.taishoshaYomeiKikan) ? '' : pCreateMailArg.taishoshaYomeiKikan )
            .replace('{{問い合わせ起因者（初回）}}', String.isBlank(pCreateMailArg.toiawaseKiinsha) ? '' : pCreateMailArg.toiawaseKiinsha )
            .replace('{{エンディングノート}}', String.isBlank(pCreateMailArg.endingNoteFlg) ? '' : pCreateMailArg.endingNoteFlg )
            .replace('{{送信時間}}', String.isBlank(pCreateMailArg.toiawaseDate) ? '' : pCreateMailArg.toiawaseDate )
            ;
        theMailAlert.ToAddress__c = this.m_Template.getSender();
        return theMailAlert;
    }

    public class RequestInvalidException extends Exception{}
}