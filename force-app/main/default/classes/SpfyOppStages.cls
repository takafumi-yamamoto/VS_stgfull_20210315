public class SpfyOppStages {

    public class Req{
        public String prevStageName;
        public Req set_prevStageName(String pValue){ this.prevStageName = pValue; return this; }
        public String prevSubPhase;
        public Req set_prevSubPhase(String pValue){ this.prevSubPhase = pValue; return this; }
        public Datetime cancelled_at;
        public Req set_cancelled_at(Datetime pValue){ this.cancelled_at = pValue; return this; }
        public String financial_status;
        public Req set_financial_status(String pValue){ this.financial_status = pValue; return this; }
        public String gateway;
        public Req set_gateway(String pValue){ this.gateway = pValue; return this; }
        public String fulfillment_status;
        public Req set_fulfillment_status(String pValue){ this.fulfillment_status = pValue; return this; }
        public Date shipDate; 
        public Req set_shipDate(Date pValue){ this.shipDate = pValue; return this; }
    }
    public class Res{
        public String PrevStageName;
        public String PrevSubPhase;
        public String nextStageName;
        public String nextSubPhase;
    }

    public class StageRsolver{
        private SpfyPreKessaiPolicy.PreKessaiPolicy mPreKessaiPolicy;
        public StageRsolver(SpfyPreKessaiPolicy.PreKessaiPolicy pPreKessaiPolicy){
            this.mPreKessaiPolicy = pPreKessaiPolicy;
        }

        public Res getStageNext(Req pReq){
            Res theRes = new Res();
            theRes.PrevStageName = pReq.PrevStageName;
            theRes.PrevSubPhase = pReq.PrevSubPhase;
            theRes.nextStageName = pReq.PrevStageName;
            theRes.nextSubPhase = pReq.PrevSubPhase;
    
            if(pReq.cancelled_at != null){
                theRes.nextStageName = 'キャンセル';
                theRes.nextSubPhase = '';
                return theRes;
            }

            if(pReq.financial_status == 'refunded'){
                theRes.nextStageName = 'キャンセル';
                theRes.nextSubPhase = '';
                return theRes;
            }
            
            if( pReq.cancelled_at == null && pReq.fulfillment_status == 'fulfilled' && pReq.shipDate != null && pReq.financial_status == 'paid'){
                theRes.nextStageName = '商談クローズ';
                theRes.nextSubPhase = '';
                return theRes;
            }

            if( pReq.cancelled_at == null && pReq.fulfillment_status == 'fulfilled'){
                theRes.nextStageName = '出荷完了';
                theRes.nextSubPhase = '';
                return theRes;
            }

            if( pReq.cancelled_at == null && pReq.fulfillment_status == 'partial'){
                theRes.nextStageName = '出荷待ち';
                theRes.nextSubPhase = '';
                return theRes;
            }
    
            if( pReq.cancelled_at == null && pReq.PrevStageName == '発注準備' ){
                Boolean theKessaiOk = this.mPreKessaiPolicy.isKessaiOk(pReq.gateway, pReq.financial_status);
                if(pReq.PrevSubPhase == '入金待ち-best' && theKessaiOk){
                    theRes.nextStageName = '発注書作成';
                    theRes.nextSubPhase = '発注書作成-best';
                    return theRes;
                }
            }

            if( pReq.cancelled_at == null && String.isBlank(pReq.PrevStageName) ){
                theRes.nextStageName = '受注';
                theRes.nextSubPhase = '';
                return theRes;
            }
    
            return theRes;
        }
    }
}