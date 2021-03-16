public class YorisoNoOsoshikiEndingNoteAdminMail {

    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('YorisoNoOsoshikiEndingNoteAdmin');

    public class CreateMailArg{
        public String title = '';
        public String mailArrivalTime = '';
        public String salesforceOrgURL = '';
        public String jidoShiryoSofuKekka = '';
        public String duplicationCheckAccountUrl = '';
        public String addressConfirmInfo = '';
        public String uniq_id = '';
        public String kiboAreaState = '';
        public String kiboAreaCity = '';
        public String toiawaseDate = '';
    }

    public MailAlert__c createMail(createMailArg pCreateMailArg){
        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        if( String.isBlank(pCreateMailArg.title) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.salesforceOrgURL) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.uniq_id) ) throw new RequestInvalidException();
        
        try{
            theMailAlert.Title__c = pCreateMailArg.title
                .replace('{{受付番号}}', pCreateMailArg.uniq_id);
            theMailAlert.Body__c = theMailAlert.Body__c
                .replace('{{データリンク}}', pCreateMailArg.salesforceOrgURL )
                .replace('{{自動資料送付結果}}', String.isBlank(pCreateMailArg.jidoShiryoSofuKekka) ? '' : pCreateMailArg.jidoShiryoSofuKekka)
                .replace('{{重複取引先}}', String.isBlank(pCreateMailArg.duplicationCheckAccountUrl) ? 'なし' : pCreateMailArg.duplicationCheckAccountUrl )
                .replace('{{住所確認情報}}', String.isBlank(pCreateMailArg.addressConfirmInfo) ? 'なし' : pCreateMailArg.addressConfirmInfo )
                .replace('{{受付番号}}', pCreateMailArg.uniq_id )
                .replace('{{希望都道府県}}', String.isBlank(pCreateMailArg.kiboAreaState) ? '' : pCreateMailArg.kiboAreaState )
                .replace('{{希望市区郡}}', String.isBlank(pCreateMailArg.kiboAreaCity) ? '' : pCreateMailArg.kiboAreaCity )
                .replace('{{送信時間}}', pCreateMailArg.toiawaseDate )
                ;
            theMailAlert.ToAddress__c = this.m_Template.getSender();
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '202019-1052', 'YorisoNoOsoshikiEndingNoteAdminMail')
                    .putAttr('Exception', ex.getMessage())
                    .putAttr('LineNumber', '' + ex.getLineNumber())
                    .putAttr('getStackTraceString', ex.getStackTraceString())
            );
        }
        return theMailAlert;
    }

    public class RequestInvalidException extends Exception{}
}