global class Bat_ObouSekouKakuninBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts,Schedulable {

    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 10;
        System.debug('### Returned batch process ID: ' + Database.executeBatch(new Bat_ObouSekouKakuninBatch(), theBatchSize));
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(buildQuery());
    }

    global void execute(Database.BatchableContext BC, List<Opportunity> targetRecords) {
        List<Aos_SMSTransUtility.AosSmsMessage> theAosSmsMessages = CreateAosSmsMessages(targetRecords);
        Aos_SMSTransUtility.sendAosSmsMessages(theAosSmsMessages);
    }
    global void finish(Database.BatchableContext BC) {}

    public String buildQuery(){

        Date theEkimuteikyoBiTo = Date.today();
        Date theEkimuteikyoBiFrom = Date.today() - 3;
        String theEkimuteikyoBiToStr = Datetime.newInstance(theEkimuteikyoBiTo.year(), theEkimuteikyoBiTo.month(), theEkimuteikyoBiTo.day()).format('yyyy-MM-dd');
        String theEkimuteikyoBiFromStr = Datetime.newInstance(theEkimuteikyoBiFrom.year(), theEkimuteikyoBiFrom.month(), theEkimuteikyoBiFrom.day()).format('yyyy-MM-dd');

        String taioJoukyosToOptout = '\'施行完了\',\'施行待ち\'';
        String query = ' SELECT Id, Name, ShodanBango__c,ShodanBangoF__c,  Utiagebi__c, ObosanbinRef__r.MemorialServicePlan__c, ObosanbinRef__r.KokubetsuDateTime_Inp__c, ObosanbinRef__r.IraiTehaiDate__c, ';
        query += ' ObosanbinRef__r.MoshuName__c, Account.LastName, Account.FirstName,ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name,ObosanbinRef__r.MadoguchiSoryoRenrakusaki__c, ';
        query += ' ObosanbinRef__r.Taishosha1Ref__r.LastName, ObosanbinRef__r.Taishosha1Ref__r.FirstName,ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhoneFormula__c,ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.TorihikisakiBangoF__c';
        query += ' FROM Opportunity ';
        query += ' WHERE ';
        query += ' StageName IN (' + taioJoukyosToOptout + ') ';
        query += ' AND KakuteibiSyodan__c != null ';
        query += ' AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c != null ';
        query += ' AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhoneFormula__c != null ';
        query += ' AND ( ObosanbinRef__r.SekouConfirmation2__c = false AND ObosanbinRef__r.SekoKakuninSMSFlg__c = false AND ObosanbinRef__r.SekouConfirmation__c = false ) ';
        query += ' AND Utiagebi__c >= ' + theEkimuteikyoBiFromStr + ' '; // 売上日
        query += ' AND Utiagebi__c <= ' + theEkimuteikyoBiToStr + ' ';  // 売上日
        query += ' AND ObosanbinRef__r.MemorialServicePlan__c NOT IN(\'プラン未確定\',\'法事・法要は希望しない\',\'どの法要を選べばよいのかわからない\') ';
        query += ' AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c = \'自社手配\'';

        return query;
    }

    private List<Aos_SMSTransUtility.AosSmsMessage> CreateAosSmsMessages(List<Opportunity> targetRecords){

        List<Aos_SMSTransUtility.AosSmsMessage> theAosSmsMessages = new List<Aos_SMSTransUtility.AosSmsMessage>();
        for(Opportunity opp : targetRecords){

            String thePhoneNumber = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhoneFormula__c;
            String theShodanId    = opp.ShodanBangoF__c;
            String thsMonkId      = opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.TorihikisakiBangoF__c;

            String thePlan = opp.ObosanbinRef__r.MemorialServicePlan__c;
            String theMsgTemplateType = 'hoyo';
            if( thePlan == '火葬式' ) theMsgTemplateType = 'sogi';
            if( thePlan == '一日葬' ) theMsgTemplateType = 'sogi';
            if( thePlan == '一般葬' ) theMsgTemplateType = 'sogi';
            if( thePlan == '戒名・法名のみ' ) theMsgTemplateType = 'kaimyo';

            String theMessage = '';
            String messStr_last = '';
            if(theMsgTemplateType == 'hoyo'){ theMessage = this.createMsg_hoyo_1(opp); messStr_last = this.createMsg_hoyo_2(opp); }
            if(theMsgTemplateType == 'sogi'){ theMessage = this.createMsg_sogi_1(opp); messStr_last = this.createMsg_sogi_2(opp); }
            if(theMsgTemplateType == 'kaimyo'){ theMessage = this.createMsg_kaimyo_1(opp); messStr_last = this.createMsg_kaimyo_2(opp); }

            if( String.isBlank(theMessage) ) continue;
            if( String.isBlank(messStr_last) ) continue;
            
            //1通目
            String theClientTag   = BuildClientTag('ObouSekouKakunin',Datetime.now(),theAosSmsMessages.size()+1, thePhoneNumber,theShodanId,thsMonkId,1);
            Aos_SMSTransUtility.AosSmsMessage aos = new Aos_SMSTransUtility.AosSmsMessage();
            aos.ClientTag   = theClientTag;
            aos.PhoneNumber = thePhoneNumber;
            aos.Message     = theMessage.left(70);
            theAosSmsMessages.add(aos);

            //2通目
            String theClientTag_second = BuildClientTag('ObouSekouKakunin',Datetime.now(),theAosSmsMessages.size()+1, thePhoneNumber,theShodanId,thsMonkId,0);
            Aos_SMSTransUtility.AosSmsMessage aos_last = new Aos_SMSTransUtility.AosSmsMessage();
            aos_last.ClientTag      = theClientTag_second;
            aos_last.PhoneNumber    = thePhoneNumber;
            aos_last.Message        = messStr_last.left(70);
            theAosSmsMessages.add(aos_last);
        }

        return theAosSmsMessages;

    }

    private String BuildClientTag(String formatType, Datetime timeSpace, integer sequence, String phoneNumber, String shodanId,String monkId, Integer toUpdateSekoukakuninJoutai){
        return formatType + ',' + timeSpace.format('yyyyMMddHHmmss') + ',' + sequence + ',' + phoneNumber.right(4) + ',' + shodanId+ ',' + monkId + ',' + toUpdateSekoukakuninJoutai;
    }

    private String createMsg_hoyo_1(Opportunity pOpp){
        String theSoryoName = pOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name;
        if( String.isBlank(theSoryoName) ) return null;

        String theDate = 
            pOpp.ObosanbinRef__r.KokubetsuDateTime_Inp__c == null 
            ? ''
            : pOpp.ObosanbinRef__r.KokubetsuDateTime_Inp__c.format('MM/dd', UserInfo.getTimeZone().getId());
        if( String.isBlank(theDate) ) return null;

        String theSodanshaName = String.isBlank( pOpp.Account.LastName ) ? '' : pOpp.Account.LastName;
        if( !String.isBlank(theSodanshaName) ) theSodanshaName += String.isBlank( pOpp.Account.FirstName ) ? '' : pOpp.Account.FirstName;

        String theCustName = theSodanshaName;
        if( String.isBlank(theCustName) ) return null;

        String theMsgTemplate ='{SoryoName}様、{Date}の{CustName}様のご法務ありがとうございました。引き続き良きご縁が結ばれますよう努めて参ります。お坊さん便';
        return theMsgTemplate.replace('{SoryoName}', theSoryoName).replace('{Date}', theDate).replace('{CustName}', theCustName);
    }
    private String createMsg_hoyo_2(Opportunity pOpp){
        String theSodanshaName = String.isBlank( pOpp.Account.LastName ) ? '' : pOpp.Account.LastName;
        if( !String.isBlank(theSodanshaName) ) theSodanshaName += String.isBlank( pOpp.Account.FirstName ) ? '' : pOpp.Account.FirstName;

        String theCustName = theSodanshaName;
        if( String.isBlank(theCustName) ) return null;
        
        String theMsgTemplate = '{CustName}様に関し、お心当たりのない場合、お坊さん便(03-5348-6766)までお電話ください。本メッセージへは返信不可です。';
        return theMsgTemplate.replace('{CustName}', theCustName);
    }

    private String createMsg_sogi_1(Opportunity pOpp){
        String theSoryoName = pOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name;
        if( String.isBlank(theSoryoName) ) return null;

        String theDate = 
            pOpp.Utiagebi__c == null 
            ? ''
            : pOpp.Utiagebi__c.month() + '/' + pOpp.Utiagebi__c.day();
            
        if( String.isBlank(theDate) ) return null;

        String theSodanshaName = String.isBlank( pOpp.Account.LastName ) ? '' : pOpp.Account.LastName;
        if( !String.isBlank(theSodanshaName) ) theSodanshaName += String.isBlank( pOpp.Account.FirstName ) ? '' : pOpp.Account.FirstName;

        String theMoshuName = pOpp.ObosanbinRef__r.MoshuName__c;

        String theCustName = String.isBlank(theMoshuName) ? theSodanshaName : theMoshuName;
        if( String.isBlank(theCustName) ) return null;

        String theMsgTemplate ='{SoryoName}様、{Date}の{CustName}様のご法務ありがとうございました。引き続き良きご縁が結ばれますよう努めて参ります。お坊さん便';
        return theMsgTemplate.replace('{SoryoName}', theSoryoName).replace('{Date}', theDate).replace('{CustName}', theCustName);
    }
    private String createMsg_sogi_2(Opportunity pOpp){
        String theSodanshaName = String.isBlank( pOpp.Account.LastName ) ? '' : pOpp.Account.LastName;
        if( !String.isBlank(theSodanshaName) ) theSodanshaName += String.isBlank( pOpp.Account.FirstName ) ? '' : pOpp.Account.FirstName;

        String theMoshuName = pOpp.ObosanbinRef__r.MoshuName__c;

        String theCustName = String.isBlank(theMoshuName) ? theSodanshaName : theMoshuName;
        if( String.isBlank(theCustName) ) return null;
        
        String theMsgTemplate = '{CustName}様に関し、お心当たりのない場合、お坊さん便(03-5348-6766)までお電話ください。本メッセージへは返信不可です。';
        return theMsgTemplate.replace('{CustName}', theCustName);
    }

    private String createMsg_kaimyo_1(Opportunity pOpp){
        String theSoryoName = pOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name;
        if( String.isBlank(theSoryoName) ) return null;

        String theDate = 
            pOpp.ObosanbinRef__r.IraiTehaiDate__c == null 
            ? ''
            : pOpp.ObosanbinRef__r.IraiTehaiDate__c.month() + '/' + pOpp.ObosanbinRef__r.IraiTehaiDate__c.day();
        if( String.isBlank(theDate) ) return null;

        String theCustName = pOpp.ObosanbinRef__r.Taishosha1Ref__r.LastName;
        if( String.isBlank(theCustName) ) return null;

        String theMsgTemplate ='{SoryoName}様、{Date}に依頼いたしました戒名の授与、有難うございました。引き続き良きご縁が結ばれますよう努めて参ります。お坊さん便';
        return theMsgTemplate.replace('{SoryoName}', theSoryoName).replace('{Date}', theDate).replace('{CustName}', theCustName);
    }
    private String createMsg_kaimyo_2(Opportunity pOpp){
        String theCustName = pOpp.ObosanbinRef__r.Taishosha1Ref__r.LastName;
        if( String.isBlank(theCustName) ) return null;
        
        String theMsgTemplate = '{CustName}様に関し、お心当たりのない場合、お坊さん便(03-5348-6766)までお電話ください。本メッセージへは返信不可です。';
        return theMsgTemplate.replace('{CustName}', theCustName);
    }
}