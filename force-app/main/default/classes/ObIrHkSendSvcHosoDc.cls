public class ObIrHkSendSvcHosoDc {
    @TestVisible
    private static ObIrHkShoryu.IProvider mObIrHkShoryuProvider = new ObIrHkShoryu.Provider();

    @TestVisible
    private static OpfcConfs.Config mOpfcConfsConfig = OpfcConfs.getConfig();

    @TestVisible
    private static OpFcPwd mOpFcPwd = new OpFcPwd();

    @TestVisible
    private static ObHokoDc_TehaiSogi.IObHokoDc_TehaiSogi mObHokoDc_TehaiSogi = new ObHokoDc_TehaiSogi();

    @TestVisible
    private static ObHokoDc_TehaiKaimyo.IObHokoDc_TehaiKaimyo mObHokoDc_TehaiKaimyo = new ObHokoDc_TehaiKaimyo();
    
    @TestVisible
    private static ObHokoDc_TehaiHoyo.IObHokoDc_TehaiHoyo mObHokoDc_TehaiHoyo = new ObHokoDc_TehaiHoyo();

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
                Loggings.createLogEntry(Loggings.Level.Warn, '20200828-1843', 'ObIrHkSendSvcHosoDc.getDoc')
                .putAttr('ex.getTypeName()', ex.getTypeName() )
                .putAttr('ex.getMessage()', ex.getMessage())
                .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                .putAttr('JSON.serializePretty(pReq)', pReq == null ? '' : JSON.serializePretty(pReq) )
            );
            throw ex;
        }
    }
    public static Res run_getDoc(Req pReq){

        Opportunity the_opp = [
            SELECT Id,
            RyunyumotoService__c,
            ObosanbinRef__r.SonotaSogisha__c,
            ObosanbinRef__r.Sogisha__r.Name,
            ObosanbinRef__r.SogiTantosha__c,
            ObosanbinRef__r.SogiTantoshaFax__c,
            ObosanbinRef__r.MemorialServicePlan__c
            FROM Opportunity 
            WHERE Id = :pReq.opp_id
            LIMIT 1
        ].get(0);

        Res theRes = new Res();
        
        {
            theRes.sosin_taisho_kubun = 'optional';
            ObIrHkShoryu.Kubuns the_shoryu_kubun = mObIrHkShoryuProvider.getKubun(the_opp.RyunyumotoService__c);
            if( the_shoryu_kubun == ObIrHkShoryu.Kubuns.KyuTehaiDaiko ) theRes.sosin_taisho_kubun = 'yes';
            if( the_shoryu_kubun == ObIrHkShoryu.Kubuns.Terapass ) theRes.sosin_taisho_kubun = 'yes';
            if( the_shoryu_kubun == ObIrHkShoryu.Kubuns.SogiTenkan ) theRes.sosin_taisho_kubun = 'yes';
        }
        if( theRes.sosin_taisho_kubun == 'no' ) return theRes;


        theRes.sosin_saki = new SosinSaki();
        {
            theRes.sosin_saki.name = '';
            String theSogishaName = 
                String.isBlank(the_opp.ObosanbinRef__r.Sogisha__r.Name) 
                ? the_opp.ObosanbinRef__r.SonotaSogisha__c
                :  the_opp.ObosanbinRef__r.Sogisha__r.Name;
            if( !String.isBlank(theSogishaName) ){
                theRes.sosin_saki.name += (theSogishaName + ' ');
            }
            if( !String.isBlank(the_opp.ObosanbinRef__r.SogiTantosha__c) ){
                theRes.sosin_saki.name += (the_opp.ObosanbinRef__r.SogiTantosha__c);
            }

            theRes.sosin_saki.method = 'fax';    

            theRes.sosin_saki.address = String.isBlank(the_opp.ObosanbinRef__r.SogiTantoshaFax__c) ? null : the_opp.ObosanbinRef__r.SogiTantoshaFax__c;
        }

        List<OpFcReq.TemplateData> theTemplatesDatas = new List<OpFcReq.TemplateData>();

        if( OboPlanKeitais.isSogi( the_opp.ObosanbinRef__r.MemorialServicePlan__c ) ){
            theTemplatesDatas.add( mObHokoDc_TehaiSogi.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }else if( OboPlanKeitais.isKaimyo ( the_opp.ObosanbinRef__r.MemorialServicePlan__c) ){
            theTemplatesDatas.add( mObHokoDc_TehaiKaimyo.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
        }else{
            theTemplatesDatas.add( mObHokoDc_TehaiHoyo.getOpFcTemplateData(pReq.opp_id, theRes.sosin_saki.method, theRes.sosin_saki.address) );
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