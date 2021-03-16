public class SgThkCre {

    public static ISogiSekogoThankYouCallCreator get_ISogiSekogoThankYouCallCreator_instance(){
        return new SogiSekogoThankYouCallCreator(
            SgThkExcld.get_IToExclude_Judger_instance(),
            SgThkSvcExcld.get_IServiceToBeExcluded_Judger_instance(),
            new Todays.Today()
        );
    }

    public interface ISogiSekogoThankYouCallCreator{
        String try_create(String p_opp_id);
    }
    public class SogiSekogoThankYouCallCreator implements ISogiSekogoThankYouCallCreator{

        private SgThkExcld.IToExclude_Judger m_IToExclude_Judger;
        private SgThkSvcExcld.IServiceToBeExcluded_Judger m_IServiceToBeExcluded_Judger;
        private Todays.IToday m_IToday;
        public SogiSekogoThankYouCallCreator(
            SgThkExcld.IToExclude_Judger p_IToExclude_Judger,
            SgThkSvcExcld.IServiceToBeExcluded_Judger p_IServiceToBeExcluded_Judger,
            Todays.IToday p_IToday
        ){
            this.m_IToExclude_Judger = p_IToExclude_Judger;
            this.m_IServiceToBeExcluded_Judger = p_IServiceToBeExcluded_Judger;
            this.m_IToday = p_IToday;
        }

        public String try_create(String p_opp_id){
            String a_SgThkCall_Id = null;

            if( this.m_IToExclude_Judger.get_any_reason_to_exclude(p_opp_id).size() > 0 ){
                return null;
            }

            a_SgThkCall_Id = this.create(p_opp_id);
            
            return a_SgThkCall_Id;
        }

        public String create(String p_opp_id){
            
            Opportunity a_opp = 
                [
                    SELECT Id,
                    Utiagebi__c,
                    Account.Id,
                    Account.LastName, Account.FirstName, 
                    Account.LastNameFurigana__pc , Account.FirstNameFurigana__pc,
                    Account.MobilePhone__c, Account.Phone,
                    Account.BillingPostalCode, Account.BillingState, Account.BillingCity, Account.BillingStreet,  
                    SimpleYasugoRef__r.TaishoshaRef__r.Id,
                    SimpleYasugoRef__r.TaishoshaRef__r.LastName,
                    SimpleYasugoRef__r.TaishoshaRef__r.FirstName,
                    SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc , 
                    SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc,
                    SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c,
                    (
                        SELECT Id, 
                        Product2.Id, Product2.Name, Product2.SougiPlan__c
                        FROM OpportunityLineItems
                    )
                    FROM Opportunity
                    WHERE Id = :p_opp_id
                ]
                .get(0);
        
            Datetime a_first_call_yotei_date_time = null;
            {
                date a_today = this.m_IToday.Date();
                a_first_call_yotei_date_time = Datetime.newInstance(a_today.year(), a_today.month(), a_today.day(), 10, 0, 0);
            }

            String a_sogi_plan_ref = null; 
            String a_sogi_plan_name = null;
            for( OpportunityLineItem a_line_item : a_opp.OpportunityLineItems ){
                if( a_line_item.Product2.SougiPlan__c ){
                    a_sogi_plan_ref = a_line_item.Product2.Id;
                    a_sogi_plan_name = a_line_item.Product2.Name;
                }
            }

            SgThkCall__c a_SgThkCall = new SgThkCall__c(
                Status__c = '未完了',
                CallYoteiDateTime__c = a_first_call_yotei_date_time,

                Sogi_OppRef__c = a_opp.Id,
                Sogi_SekoDate__c = a_opp.Utiagebi__c,
                Sogi_PlanRef__c = a_sogi_plan_ref,
                Sogi_PlanName__c = a_sogi_plan_name,

                SodanshaRef__c = a_opp.AccountId,
                Sodansha_LastName__c = a_opp.Account.LastName, 
                Sodansha_FirstName__c = a_opp.Account.FirstName,
                Sodansha_LastName_Kana__c = a_opp.Account.LastNameFurigana__pc, 
                Sodansha_FirstName_Kana__c = a_opp.Account.FirstNameFurigana__pc,
                Sodansha_Mobile__c = a_opp.Account.MobilePhone__c, 
                Sodansha_Phone__c = a_opp.Account.Phone,
                Sodansha_Addr_ZipCode__c = a_opp.Account.BillingPostalCode, 
                Sodansha_Addr_State__c = a_opp.Account.BillingState, 
                Sodansha_Addr_City__c = a_opp.Account.BillingCity, 
                Sodansha_Addr_Street__c = a_opp.Account.BillingStreet,

                TaishoshaRef__c = a_opp.SimpleYasugoRef__r.TaishoshaRef__r.Id,
                Taishosha_LastName__c = a_opp.SimpleYasugoRef__r.TaishoshaRef__r.LastName, 
                Taishosha_FirstName__c = a_opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstName,
                Taishosha_LastName_Kana__c = a_opp.SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc, 
                Taishosha_FirstName_Kana__c = a_opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc,
                Taishosha_Zokugara_By_Sodansha__c = a_opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c
            );
            INSERT a_SgThkCall;

            Set<SgThkSvcExcld.ServiceKubuns> the_services_tobe_excluded = 
                this.m_IServiceToBeExcluded_Judger.get_services_tobe_excluded(p_opp_id);

            List<SgThkCallSvcAnnai__c> the_SgThkCallSvcAnnais = new List<SgThkCallSvcAnnai__c>();

            if( !the_services_tobe_excluded.contains( SgThkSvcExcld.ServiceKubuns.koden_gaeshi ) ){
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 1,
                        ServiceKbn__c = '香典返し',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );
            }

            { //相続相談
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 2,
                        ServiceKbn__c = '相続相談',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );
            }

            if( !the_services_tobe_excluded.contains( SgThkSvcExcld.ServiceKubuns.hoyo_49nichi ) ){
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 3,
                        ServiceKbn__c = '四十九日法要',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );
            }

            { //位牌
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 4,
                        ServiceKbn__c = '位牌',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );
            }

            { //仏壇
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 5,
                        ServiceKbn__c = '仏壇',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );
            }

            if( !the_services_tobe_excluded.contains( SgThkSvcExcld.ServiceKubuns.eitai_kuyo ) ){
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 6,
                        ServiceKbn__c = '永代供養墓',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );
            }

            if( !the_services_tobe_excluded.contains( SgThkSvcExcld.ServiceKubuns.kaiyo_sankotsu ) ){
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 7,
                        ServiceKbn__c = '海洋散骨',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );   
            }

            { //お手元供養
                the_SgThkCallSvcAnnais.add(
                    new SgThkCallSvcAnnai__c(
                        SortNo__c = 8,
                        ServiceKbn__c = 'お手元供養',
                        CallKekka__c = '未案内',
                        SgThkCallRef__c = a_SgThkCall.Id
                    )
                );   
            }

            INSERT the_SgThkCallSvcAnnais;

            return a_SgThkCall.Id;
        }
    }

}