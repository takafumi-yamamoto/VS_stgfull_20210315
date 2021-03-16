public class ObIrHkSendSvcHokoDc {

    private static ObIrHkShoryu.IProvider mObIrHkShoryuProvider = new ObIrHkShoryu.Provider();
    private static OpfcConfs.Config mOpfcConfsConfig = OpfcConfs.getConfig();
    private static OpFcPwd mOpFcPwd = new OpFcPwd();

    @TestVisible
    private static ObHokoDc_Sofujo.IObHokoDc_Sofujo mObHokoDc_Sofujo = new ObHokoDc_Sofujo();
    @TestVisible
    private static ObHokoDc_TehaiSogi.IObHokoDc_TehaiSogi mObHokoDc_TehaiSogi = new ObHokoDc_TehaiSogi();
    @TestVisible
    private static ObHokoDc_TehaiKaimyo.IObHokoDc_TehaiKaimyo mObHokoDc_TehaiKaimyo = new ObHokoDc_TehaiKaimyo();
    @TestVisible
    private static ObHokoDc_TehaiHoyo.IObHokoDc_TehaiHoyo mObHokoDc_TehaiHoyo = new ObHokoDc_TehaiHoyo();
    @TestVisible
    private static ObHokoDc_Cyuin.IObHokoDc_Cyuin mObHokoDc_Cyuin = new ObHokoDc_Cyuin();

    public class Req{
        @AuraEnabled public String opp_id {get;set;}
        @AuraEnabled public Boolean dont_include_panflets_in_dofushorui {get;set;}
    }
    public class Res{
        @AuraEnabled public String sosin_taisho_kubun;
        @AuraEnabled public SosinSaki sosin_saki;
        @AuraEnabled public RequestForOproFc request_for_opro_facade;

    }
    public class RequestForOproFc{
        @AuraEnabled public String endpoint = '';
        @AuraEnabled public String request_body;
        @AuraEnabled public String opro_pdf_base_url;
        @AuraEnabled public String opro_pdf_password;
    }
    public class SosinSaki{
        @AuraEnabled public String account_id;
        @AuraEnabled public String name;
        @AuraEnabled public String method;
        @AuraEnabled public String address;
    }
    @AuraEnabled
    public static Res getDoc(Req pReq){
        try{
            return run_getDoc(pReq);
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Warn, '20200828-1800', 'ObIrHkSendSvcHokoDc.getDoc')
                .putAttr('ex.getTypeName()', ex.getTypeName() )
                .putAttr('ex.getMessage()', ex.getMessage())
                .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                .putAttr('JSON.serializePretty(pReq)', pReq == null ? '' : JSON.serializePretty(pReq) )
            );
            throw ex;
        }
    }

    private static Res run_getDoc(Req pReq){

        Opportunity the_opp = [
            SELECT Id,
            RyunyumotoService__c,
            Account.Name,
            Account.MobilePhone__c, 
            Account.MailAddress__c,
            Account.BillingPostalCode,
            Account.BillingState,
            Account.BillingCity,
            Account.BillingStreet,
            ShiryoSoufuSakiAtena__c,
            ShiryoSoufuSakiPostalCode__c,
            ShiryoSoufuSakiState__c,
            ShiryoSoufuSakiCity__c,
            ShiryoSoufuSakiStreet__c,
            ObosanbinRef__r.TehaiHokoForCustMethod__c,
            ObosanbinRef__r.MemorialServicePlan__c
            FROM Opportunity 
            WHERE Id = :pReq.opp_id
            LIMIT 1
        ].get(0);

        Res theRes = new Res();
        {
            theRes.sosin_taisho_kubun = 'yes';
            ObIrHkShoryu.Kubuns the_shoryu_kubun = mObIrHkShoryuProvider.getKubun(the_opp.RyunyumotoService__c);
            if( the_shoryu_kubun == ObIrHkShoryu.Kubuns.KyuTehaiDaiko ) theRes.sosin_taisho_kubun = 'no';
            if( the_shoryu_kubun == ObIrHkShoryu.Kubuns.Terapass ) theRes.sosin_taisho_kubun = 'no';
            if( the_shoryu_kubun == ObIrHkShoryu.Kubuns.SogiTenkan ) theRes.sosin_taisho_kubun = 'optional';
        }
        if( theRes.sosin_taisho_kubun == 'no' ) return theRes;

        theRes.sosin_saki = new SosinSaki();
        {

            theRes.sosin_saki.method = null;
            if(the_opp.ObosanbinRef__r.TehaiHokoForCustMethod__c == 'SMS') theRes.sosin_saki.method ='sms';
            if(the_opp.ObosanbinRef__r.TehaiHokoForCustMethod__c == 'MAIL') theRes.sosin_saki.method ='mail';
            if(the_opp.ObosanbinRef__r.TehaiHokoForCustMethod__c == '郵送') theRes.sosin_saki.method ='post';     

            theRes.sosin_saki.account_id = the_opp.Account.Id;

            theRes.sosin_saki.name = null;
            {
                Boolean toUse_ShiryoSofusaki_Name = theRes.sosin_saki.method == 'post' && !String.isBlank(the_opp.ShiryoSoufuSakiAtena__c);
                theRes.sosin_saki.name = toUse_ShiryoSofusaki_Name ? the_opp.ShiryoSoufuSakiAtena__c : the_opp.Account.Name;
            }
 

            theRes.sosin_saki.address = null;
            if(theRes.sosin_saki.method == 'sms') {
                theRes.sosin_saki.address = String.isBlank(the_opp.Account.MobilePhone__c) ? null : the_opp.Account.MobilePhone__c;
                if( !String.isBlank(theRes.sosin_saki.address) ) theRes.sosin_saki.address = TelNos.toNumber(theRes.sosin_saki.address);
            }
            if(theRes.sosin_saki.method == 'mail') theRes.sosin_saki.address = String.isBlank(the_opp.Account.MailAddress__c) ? null : the_opp.Account.MailAddress__c;   
            if( theRes.sosin_saki.method == 'post' ){

                theRes.sosin_saki.address = '';

                Boolean toUse_ShiryoSofusaki_Address = 
                    !String.isBlank(the_opp.ShiryoSoufuSakiPostalCode__c)
                    && !String.isBlank(the_opp.ShiryoSoufuSakiState__c)
                    && !String.isBlank(the_opp.ShiryoSoufuSakiCity__c)
                    && !String.isBlank(the_opp.ShiryoSoufuSakiStreet__c)
                    ;

                if(toUse_ShiryoSofusaki_Address){
                    if( !String.isBlank(the_opp.ShiryoSoufuSakiPostalCode__c) ){
                        theRes.sosin_saki.address += the_opp.ShiryoSoufuSakiPostalCode__c + ' ';
                    }
                    if( !String.isBlank(the_opp.ShiryoSoufuSakiState__c) ){
                        theRes.sosin_saki.address += the_opp.ShiryoSoufuSakiState__c;
                    }
                    if( !String.isBlank(the_opp.ShiryoSoufuSakiCity__c) ){
                        theRes.sosin_saki.address += the_opp.ShiryoSoufuSakiCity__c;
                    }
                    if( !String.isBlank(the_opp.ShiryoSoufuSakiStreet__c) ){
                        theRes.sosin_saki.address += the_opp.ShiryoSoufuSakiStreet__c;
                    }
                }else{
                    if( !String.isBlank(the_opp.Account.BillingPostalCode) ){
                        theRes.sosin_saki.address += the_opp.Account.BillingPostalCode + ' ';
                    }
                    if( !String.isBlank(the_opp.Account.BillingState) ){
                        theRes.sosin_saki.address += the_opp.Account.BillingState;
                    }
                    if( !String.isBlank(the_opp.Account.BillingCity) ){
                        theRes.sosin_saki.address += the_opp.Account.BillingCity;
                    }
                    if( !String.isBlank(the_opp.Account.BillingStreet) ){
                        theRes.sosin_saki.address += the_opp.Account.BillingStreet;
                    }
                }
                
            }
        }
        
        List<OpFcReq.TemplateData> theTemplatesDatas = new List<OpFcReq.TemplateData>();

        Boolean no_panfs = pReq.dont_include_panflets_in_dofushorui == null ? false : pReq.dont_include_panflets_in_dofushorui;

        if( theRes.sosin_saki.method == 'post'){
            theTemplatesDatas.add( mObHokoDc_Sofujo.getOpFcTemplateData(pReq.opp_id, no_panfs) );
        }

        if( OboPlanKeitais.isSogi( the_opp.ObosanbinRef__r.MemorialServicePlan__c ) ){
            theTemplatesDatas.add( mObHokoDc_TehaiSogi.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }else if( OboPlanKeitais.isKaimyo ( the_opp.ObosanbinRef__r.MemorialServicePlan__c) ){
            theTemplatesDatas.add( mObHokoDc_TehaiKaimyo.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }else{
            theTemplatesDatas.add( mObHokoDc_TehaiHoyo.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }

        if( !no_panfs && ObHokoDc_Cyuin.to_include(the_opp.ObosanbinRef__r.MemorialServicePlan__c) ){
            theTemplatesDatas.add( mObHokoDc_Cyuin.getOpFcTemplateData(pReq.opp_id) );
        }

        String thePassword = mOpFcPwd.genPassword(); 
        OpFcReq.Req theReq = 
            new OpFcReq.Req()
            .setCid(mOpfcConfsConfig.opro_cid)
            .setUid(mOpfcConfsConfig.opro_uid)
            .setUpw(mOpfcConfsConfig.opro_upw)
            .setFontEmb(true)
            .setOproPdfPassword( thePassword )
            .addTemplateDatas(theTemplatesDatas);
        
        theRes.request_for_opro_facade = new RequestForOproFc();
        theRes.request_for_opro_facade.endpoint = OpFcApiCrePdf.getEndPoint();
        theRes.request_for_opro_facade.request_body = theReq.getParamString();
        theRes.request_for_opro_facade.opro_pdf_base_url = OpFcApiCrePdf.getCreatedPdfBaseEndPoint();
        theRes.request_for_opro_facade.opro_pdf_password = thePassword;

        return theRes;
    }
}