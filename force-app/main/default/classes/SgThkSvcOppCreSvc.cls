public class SgThkSvcOppCreSvc {

    @TestVisible
    private static IOppCreator m_IOppCreator_instance = 
        new OppCreator(
            new OppCreator_49Nichi(),
            new OppCreator_EitaiKuyo(),
            new OppCreator_KaiyoSankotsu()
        );

    public class CreateOppReq{
        @AuraEnabled public String SgThkCallSvcAnnai_id {get;set;}
        public CreateOppReq set_SgThkCallSvcAnnai_id(String p_value){ this.SgThkCallSvcAnnai_id = p_value; return this; }
    }
    public class CreateOppRes{
        @AuraEnabled public String opp_id;
        public CreateOppRes set_opp_id(String p_value){ this.opp_id = p_value; return this; }
    }
    @AuraEnabled
    public static CreateOppRes create_opp(CreateOppReq p_req){
        try{
            String a_opp_id = m_IOppCreator_instance.create_opp(p_req.SgThkCallSvcAnnai_id);
            UPDATE new SgThkCallSvcAnnai__c(
                Id = p_req.SgThkCallSvcAnnai_id, OppRef__c = a_opp_id
            );
            return new CreateOppRes().set_opp_id(a_opp_id);
        }catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Warn, '20210109-0955', 'SgThkSvcOppCreSvc.create_opp')
                .putAttr('ex.getTypeName()', ex.getTypeName() )
                .putAttr('ex.getMessage()', ex.getMessage())
                .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                .putAttr('JSON.serializePretty(pReq)', p_req == null ? '' : JSON.serializePretty(p_req) )
            );
            throw ex;
        }
    }

    public interface IOppCreator {
        String create_opp(String p_SgThkCallSvcAnnai_id);
    }
    public class OppCreator implements IOppCreator{

        private IOppCreator_49Nichi m_IOppCreator_49Nichi;
        private IOppCreator_EitaiKuyo m_IOppCreator_EitaiKuyo;
        private IOppCreator_KaiyoSankotsu m_IOppCreator_KaiyoSankotsu;
        public OppCreator(
            IOppCreator_49Nichi p_IOppCreator_49Nichi,
            IOppCreator_EitaiKuyo p_IOppCreator_EitaiKuyo,
            IOppCreator_KaiyoSankotsu p_IOppCreator_KaiyoSankotsu
        ){
            this.m_IOppCreator_49Nichi = p_IOppCreator_49Nichi;
            this.m_IOppCreator_EitaiKuyo = p_IOppCreator_EitaiKuyo;
            this.m_IOppCreator_KaiyoSankotsu = p_IOppCreator_KaiyoSankotsu;
        }

        public String create_opp(String p_SgThkCallSvcAnnai_id){
            SgThkCallSvcAnnai__c a_SgThkCallSvcAnnai = 
                [
                    SELECT Id, ServiceKbn__c 
                    FROM SgThkCallSvcAnnai__c
                    WHERE Id = :p_SgThkCallSvcAnnai_id
                ]
                .get(0);
            
            String a_opp_id = null;
            if(a_SgThkCallSvcAnnai.ServiceKbn__c == '四十九日法要'){
                a_opp_id = this.m_IOppCreator_49Nichi.create_opp(p_SgThkCallSvcAnnai_id);
            }
            else if(a_SgThkCallSvcAnnai.ServiceKbn__c == '永代供養墓'){
                a_opp_id = this.m_IOppCreator_EitaiKuyo.create_opp(p_SgThkCallSvcAnnai_id);
            }
            else if(a_SgThkCallSvcAnnai.ServiceKbn__c == '海洋散骨'){
                a_opp_id = this.m_IOppCreator_KaiyoSankotsu.create_opp(p_SgThkCallSvcAnnai_id);
            }

            return a_opp_id;
        }
    }
    
    public interface IOppCreator_49Nichi {
        String create_opp(String p_SgThkCallSvcAnnai_id);
    }
    public class OppCreator_49Nichi implements IOppCreator_49Nichi{
        public String create_opp(String p_SgThkCallSvcAnnai_id){
            SgThkCallSvcAnnai__c a_SgThkCallSvcAnnai = 
                [
                    SELECT Id,
                    ServiceKbn__c,
                    SgThkCallRef__r.SodanshaRef__c,
                    SgThkCallRef__r.SodanshaRef__r.Name,
                    SgThkCallRef__r.TaishoshaRef__c
                    FROM SgThkCallSvcAnnai__c
                    WHERE Id = :p_SgThkCallSvcAnnai_id
                ]
                .get(0);

            String a_opp_name = String.join(
                new List<String>{
                    String.isBlank(a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__r.Name) ? '' : a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__r.Name,
                    'お坊さん便'
                },
                '_'
            );

            Opportunity a_opp = new Opportunity(
                RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Obosanbin').getRecordTypeId(),
                StageName = '問合せ受付',
                Req_Day__c = Datetime.now(),
                CloseDate = Date.today(),
                Name = a_opp_name,
                AccountId = a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__c
            );
            INSERT a_opp;

            String a_Obosanbin_id = [ SELECT Id, ObosanbinRef__c FROM opportunity WHERE Id = :a_opp.Id ].get(0).ObosanbinRef__c;
            UPDATE new Obosanbin__c(
                Id = a_Obosanbin_id, 
                Taishosha1Ref__c = a_SgThkCallSvcAnnai.SgThkCallRef__r.TaishoshaRef__c,
                MemorialServicePlan__c = '	四十九日法要'
            );
            return a_opp.Id;
        } 
    }

    public interface IOppCreator_EitaiKuyo {
        String create_opp(String p_SgThkCallSvcAnnai_id);
    }
    public class OppCreator_EitaiKuyo implements IOppCreator_EitaiKuyo{
        public String create_opp(String p_SgThkCallSvcAnnai_id){
            SgThkCallSvcAnnai__c a_SgThkCallSvcAnnai = 
                [
                    SELECT Id,
                    ServiceKbn__c,
                    SgThkCallRef__r.SodanshaRef__c,
                    SgThkCallRef__r.SodanshaRef__r.Name,
                    SgThkCallRef__r.TaishoshaRef__c
                    FROM SgThkCallSvcAnnai__c
                    WHERE Id = :p_SgThkCallSvcAnnai_id
                ]
                .get(0);

            String a_opp_name = String.join(
                new List<String>{
                    String.isBlank(a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__r.Name) ? '' : a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__r.Name,
                    '永代供養'
                },
                '_'
            );

            Opportunity a_opp = new Opportunity(
                RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('PerpetualMemorial').getRecordTypeId(),
                StageName = '問合せ受付',
                Req_Day__c = Datetime.now(),
                CloseDate = Date.today(),
                Name = a_opp_name,
                AccountId = a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__c
            );
            INSERT a_opp;

            String a_EitaiKuyo_id = [ SELECT Id, EitaiKuyoRef__c FROM opportunity WHERE Id = :a_opp.Id ].get(0).EitaiKuyoRef__c;
            UPDATE new EitaiKuyo__c(
                Id = a_EitaiKuyo_id, 
                TaishoshaRef__c = a_SgThkCallSvcAnnai.SgThkCallRef__r.TaishoshaRef__c
            );
            return a_opp.Id;
        } 
    }

    public interface IOppCreator_KaiyoSankotsu {
        String create_opp(String p_SgThkCallSvcAnnai_id);
    }
    public class OppCreator_KaiyoSankotsu implements IOppCreator_KaiyoSankotsu{
        public String create_opp(String p_SgThkCallSvcAnnai_id){
            SgThkCallSvcAnnai__c a_SgThkCallSvcAnnai = 
                [
                    SELECT Id,
                    ServiceKbn__c,
                    SgThkCallRef__r.SodanshaRef__c,
                    SgThkCallRef__r.SodanshaRef__r.Name,
                    SgThkCallRef__r.TaishoshaRef__c
                    FROM SgThkCallSvcAnnai__c
                    WHERE Id = :p_SgThkCallSvcAnnai_id
                ]
                .get(0);

            String a_opp_name = String.join(
                new List<String>{
                    String.isBlank(a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__r.Name) ? '' : a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__r.Name,
                    '海洋散骨'
                },
                '_'
            );

            Opportunity a_opp = new Opportunity(
                RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KaiyoUmie').getRecordTypeId(),
                StageName = '問合せ受付',
                Req_Day__c = Datetime.now(),
                CloseDate = Date.today(),
                Name = a_opp_name,
                AccountId = a_SgThkCallSvcAnnai.SgThkCallRef__r.SodanshaRef__c
            );
            INSERT a_opp;

            String a_KaiyoSankotsuUmie_id = [ SELECT Id, KaiyoSankotsuUmieRef__c FROM opportunity WHERE Id = :a_opp.Id ].get(0).KaiyoSankotsuUmieRef__c;
            UPDATE new KaiyoSankotsuUmie__c(
                Id = a_KaiyoSankotsuUmie_id, 
                TaishoshaRef__c = a_SgThkCallSvcAnnai.SgThkCallRef__r.TaishoshaRef__c
            );
            return a_opp.Id;
        } 
    }

}