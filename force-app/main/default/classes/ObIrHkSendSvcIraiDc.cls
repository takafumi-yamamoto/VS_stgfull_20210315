public class ObIrHkSendSvcIraiDc {
    private static ObIrHkShoryu.IProvider mObIrHkShoryuProvider = new ObIrHkShoryu.Provider();
    private static OpfcConfs.Config mOpfcConfsConfig = OpfcConfs.getConfig();
    private static OpFcPwd mOpFcPwd = new OpFcPwd();

    @TestVisible
    private static ISendMethodDecision mSendMethodDecision = new SendMethodDecision();

    @TestVisible
    private static ObIraiDc_IraiSogi.IObIraiDc_IraiSogi mObIraiDc_IraiSogi = new ObIraiDc_IraiSogi();
    @TestVisible
    private static ObIraiDc_IraiHoyo.IObIraiDc_IraiHoyo mObIraiDc_IraiHoyo = new ObIraiDc_IraiHoyo();
    @TestVisible
    private static ObIraiDc_IraiKaimyo.IObIraiDc_IraiKaimyo mObIraiDc_IraiKaimyo = new ObIraiDc_IraiKaimyo();
    @TestVisible
    private static ObIraiDc_Terapass.IObIraiDc_Terapass mObIraiDc_Terapass = new ObIraiDc_Terapass();

    public class Req{
        @AuraEnabled public String opp_id {get;set;}
        //@AuraEnabled public String document_set_type {get;set;}
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
                Loggings.createLogEntry(Loggings.Level.Warn, '20200828-1906', 'ObIrHkSendSvcIraiDc.getDoc')
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
            ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c,
            ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name,
            ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MailAddress__c,
            ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.FAX,
            ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Iraisyosofuhouhou__c,
            ObosanbinRef__r.MemorialServicePlan__c
            FROM Opportunity 
            WHERE Id = :pReq.opp_id
            LIMIT 1
        ].get(0);

        Res theRes = new Res();
        ObIrHkShoryu.Kubuns the_shoryu_kubun = mObIrHkShoryuProvider.getKubun(the_opp.RyunyumotoService__c);
        
        {
            theRes.sosin_taisho_kubun = 'yes';
        }

        theRes.sosin_saki = new SosinSaki();
        {
            theRes.sosin_saki.account_id = the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c;
            theRes.sosin_saki.name = the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Name;

            theRes.sosin_saki.method = mSendMethodDecision.getMethod(the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Iraisyosofuhouhou__c);

            theRes.sosin_saki.address = null;

            if(theRes.sosin_saki.method == 'fax') {
                theRes.sosin_saki.address = 
                    String.isBlank(the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.FAX) 
                    ? null 
                    : the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.FAX;
                if( !String.isBlank(theRes.sosin_saki.address) ) theRes.sosin_saki.address = TelNos.toNumber(theRes.sosin_saki.address);
            }

            if(theRes.sosin_saki.method == 'mail'){
                theRes.sosin_saki.address = 
                    String.isBlank(the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MailAddress__c) 
                    ? null 
                    : the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MailAddress__c; 
            }


            if( theRes.sosin_saki.method == 'fax_and_mail' ){
                theRes.sosin_saki.address = 
                    String.isBlank(the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MailAddress__c) 
                    ? null 
                    : the_opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MailAddress__c; 
            }
        }

        List<OpFcReq.TemplateData> theTemplatesDatas = new List<OpFcReq.TemplateData>();

        if( OboPlanKeitais.isSogi( the_opp.ObosanbinRef__r.MemorialServicePlan__c ) ){
            theTemplatesDatas.add( mObIraiDc_IraiSogi.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }else if( OboPlanKeitais.isKaimyo ( the_opp.ObosanbinRef__r.MemorialServicePlan__c) ){
            theTemplatesDatas.add( mObIraiDc_IraiKaimyo.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }else{
            theTemplatesDatas.add( mObIraiDc_IraiHoyo.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }

        if( the_shoryu_kubun == ObIrHkShoryu.Kubuns.Terapass ){
            theTemplatesDatas.add( mObIraiDc_Terapass.getOpFcTemplateData(pReq.opp_id) );
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

    public interface ISendMethodDecision {
        String getMethod(String pOpp_Iraisyosofuhouhou);
    }

    @TestVisible
    private class SendMethodDecision implements ISendMethodDecision{

        public String getMethod(String pOpp_Iraisyosofuhouhou){
            if(pOpp_Iraisyosofuhouhou == 'FAXのみ') return 'fax';
            if(pOpp_Iraisyosofuhouhou == 'MAILのみ') return 'mail';
            if(pOpp_Iraisyosofuhouhou == 'FAX＆MAIL') return 'fax_and_mail';
            return null;
        }
   
    }
}