public class SorKetRenHoyoCredMail {
    private MailTemplates.Template m_Template = new MailTemplates().getTemplate('SorKetRenHoyoCredMail');

    public class CreateMailArg{
        public String name;
        public String mailaddress;
        public String jiinName;
        public String jiinNameKana;
        public String shuha;
        public Datetime nichiji;
        public String hoyoBashoName;
        public String tsuikaHoyoBashoName;
        public Decimal hoyoryo;
    }

    public MailAlert__c createMail(createMailArg pCreateMailArg){

        if( String.isBlank(pCreateMailArg.name) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.mailaddress) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.jiinName) ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.shuha) ) throw new RequestInvalidException();
        if( pCreateMailArg.nichiji == null ) throw new RequestInvalidException();
        if( String.isBlank(pCreateMailArg.hoyoBashoName) ) throw new RequestInvalidException();
        if( pCreateMailArg.hoyoryo == 0 || pCreateMailArg.hoyoryo == null ) throw new RequestInvalidException();

        MailAlert__c theMailAlert = new MailAlert__c();
        MailAlerts.applyTemplate(this.m_Template, theMailAlert);

        String theTsuikaHoyoBasho =
            String.isBlank(pCreateMailArg.tsuikaHoyoBashoName)
            ? ''
            : '追加法要場所：' + pCreateMailArg.tsuikaHoyoBashoName;

        String theHoyoNichiji =
            pCreateMailArg.nichiji.hour() == 0 && pCreateMailArg.nichiji.minute() == 0
            ? pCreateMailArg.nichiji.format('yyyy年M月d日')
            : pCreateMailArg.nichiji.format('yyyy年M月d日 HH:mm');

        theMailAlert.Body__c = theMailAlert.Body__c
            .replace('{Name}', pCreateMailArg.name)
            .replace('{窓口僧侶寺院名}', pCreateMailArg.jiinName)
            .replace('{窓口僧侶寺院名カナ}', String.isBlank(pCreateMailArg.jiinNameKana) ? '' : pCreateMailArg.jiinNameKana)
            .replace('{窓口僧侶宗派}', pCreateMailArg.shuha)
            .replace('{法要日時}', theHoyoNichiji)
            .replace('{法要場所名}', pCreateMailArg.hoyoBashoName)
            .replace('{追加法要場所：追加法要場所名}', theTsuikaHoyoBasho)
            .replace('{法要料}', pCreateMailArg.hoyoryo.format())
            ;
        theMailAlert.ToAddress__c = pCreateMailArg.mailaddress;
        return theMailAlert;
    }
    public class RequestInvalidException extends Exception{}
}