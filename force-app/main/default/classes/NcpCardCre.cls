public class NcpCardCre {

    public static ICardCreator get_ICardCreator_instance(){
        return new CardCreator(
            new Todays.Today(),
            SzsdCardExcld.get_IJudgeToExclude_instance()
        );
    }
    public interface ICardCreator {
        String try_publish_card( String p_opp_id, Boolean p_is_hakkou_shijji_directly);
    }
    public class CardCreator implements ICardCreator{
        private Todays.IToday m_IToday;
        private SzsdCardExcld.IJudgeToExclude m_IJudgeToExclude;
        public CardCreator(
            Todays.IToday p_IToday,
            SzsdCardExcld.IJudgeToExclude p_IJudgeToExclude
        ){
            this.m_IToday = p_IToday;
            this.m_IJudgeToExclude = p_IJudgeToExclude;
        }

        public String try_publish_card( String p_opp_id, Boolean p_is_hakkou_shijji_directly){
            NcpSzkSdnShkCard__c a_card = null;
            Boolean isExistsAlready = [SELECT Id FROM NcpSzkSdnShkCard__c WHERE OppRef__c = :p_opp_id LIMIT 1].size() > 0;

            if( !isExistsAlready && !this.m_IJudgeToExclude.to_exclude(p_opp_id, p_is_hakkou_shijji_directly) ){
                a_card = this.create_card(p_opp_id);
                INSERT a_card;
            }
            return a_card == null ? null : a_card.Id;
        }
        public NcpSzkSdnShkCard__c create_card(String p_opp_id){
            Opportunity a_opp = this.select_opps( new List<String>{ p_opp_id }).get(0);
            return this.create_card( a_opp );
        }
        private List<Opportunity> select_opps(List<String> p_opp_ids){
            return [
				SELECT 
				Id, Name, ShodanBango__c,
				StageName,
				Utiagebi__c,
				Account.Id, Account.TorihikisakiBango__c,
				Account.Name, Account.NameFurigana__c,
				Account.PersonDeathDate__pc,
				Account.Phone,
				Account.MobilePhone__c,
				Account.BillingPostalCode,
				Account.BillingState,
				Account.BillingCity,
				Account.BillingStreet,
				SimpleYasugoRef__r.Id,
				SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c,
				SimpleYasugoRef__r.SaijoRef__r.Id,
				SimpleYasugoRef__r.SaijoRef__r.Name,
				SimpleYasugoRef__r.SonotaSaijoShisetsu__c,
				SimpleYasugoRef__r.KasobaShisetsu__r.Id,
				SimpleYasugoRef__r.KasobaShisetsu__r.Name,
				SimpleYasugoRef__r.SonotaKasobaShisetsu__c,
				SimpleYasugoRef__r.TaishoshaRef__r.Id,
				SimpleYasugoRef__r.TaishoshaRef__r.Name, 
				SimpleYasugoRef__r.TaishoshaRef__r.NameFurigana__c,
				SimpleYasugoRef__r.TaishoshaRef__r.BillingPostalCode,
				SimpleYasugoRef__r.TaishoshaRef__r.BillingState,
				SimpleYasugoRef__r.TaishoshaRef__r.BillingCity,
				SimpleYasugoRef__r.TaishoshaRef__r.BillingStreet,
				SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthDate,
				SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc,
                SimpleYasugoRef__r.TaishoshaRef__r.Age__pc,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name,
                (
                    SELECT Id, Product2.SougiPlan__c, Product2.NameForCustomer__c
                    FROM OpportunityLineItems
                    WHERE Product2.SougiPlan__c = true
                    LIMIT 1
                )
				FROM Opportunity
                WHERE Id IN :p_opp_ids
            ];
        }

        private NcpSzkSdnShkCard__c create_card(Opportunity p_opp){

            String plan_name = '';
            for(OpportunityLineItem a_line_item : p_opp.OpportunityLineItems){
                if( a_line_item.Product2.SougiPlan__c ){ plan_name = a_line_item.Product2.NameForCustomer__c; }
            }

            NcpSzkSdnShkCard__c theCard = 
                new NcpSzkSdnShkCard__c(
                    AccountRef__c = p_opp.Account.Id,
                    OppRef__c = p_opp.Id,
                    YorisoKanriBango__c = ('Y' + p_opp.ShodanBango__c),
                    ShokaiDate__c = m_IToday.date(),
                    SekouDate__c = p_opp.Utiagebi__c,
                    KaikanMei__c = this.genKaikanMei(
                        p_opp.SimpleYasugoRef__r.SaijoRef__r.Name, p_opp.SimpleYasugoRef__r.SonotaSaijoShisetsu__c,
                        p_opp.SimpleYasugoRef__r.KasobaShisetsu__r.Name, p_opp.SimpleYasugoRef__r.SonotaKasobaShisetsu__c
                    ),
                    KojinName__c = this.formatNameAndKana( p_opp.SimpleYasugoRef__r.TaishoshaRef__r.Name, p_opp.SimpleYasugoRef__r.TaishoshaRef__r.NameFurigana__c ),
                    KojinAddr__c = this.formatAddr(
                        p_opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingPostalCode,
                        p_opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingState,
                        p_opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingCity,
                        p_opp.SimpleYasugoRef__r.TaishoshaRef__r.BillingStreet	
                    ),
                    KojinDeathDate__c = p_opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc,
                    KojinAgeAtDeath__c = this.validateAgeAtDeath(
                        p_opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthDate,
                        p_opp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc,
                        p_opp.SimpleYasugoRef__r.TaishoshaRef__r.Age__pc
                    ),
                    SodanshaName__c = this.formatNameAndKana( p_opp.Account.Name, p_opp.Account.NameFurigana__c ),
                    SodanshaMobile__c = String.isBlank(p_opp.Account.MobilePhone__c) ? null : ('#' + p_opp.Account.MobilePhone__c),
                    SodanshaPhone__c = String.isBlank(p_opp.Account.Phone) ? null : ('#' + p_opp.Account.Phone),
                    SodanshaAddr__c = this.formatAddr(
                        p_opp.Account.BillingPostalCode,
                        p_opp.Account.BillingState,
                        p_opp.Account.BillingCity,
                        p_opp.Account.BillingStreet	
                    ),
                    SodanshaZokugara__c = p_opp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c,
                    SogiPlanName__c = plan_name,
                    SogishaName__c = p_opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name,
                    Biko__c = null
                );
			return theCard;
        }

		private Decimal validateAgeAtDeath(Date pBirthDate, Date pDeathDate, Decimal pAge){
			if( pBirthDate == null || pDeathDate == null ) return -1;
			return pAge;
		}

		private String genKaikanMei(String pSaijoName, String pSaijoNameSonota, String pKasobaName, String pKasoboNameSonota){
			if( !String.isBlank(pSaijoName) ) return pSaijoName;
			if( !String.isBlank(pSaijoNameSonota) ) return pSaijoNameSonota;
			if( !String.isBlank(pKasobaName) ) return pKasobaName;
			if( !String.isBlank(pKasoboNameSonota) ) return pKasoboNameSonota;
			return '';
		}

		private String formatNameAndKana(String pName, String pKana){
			List<String> theValues = new List<String>();
			if( !String.isBlank( pName ) ) theValues.add( pName );
			if( !String.isBlank( pKana ) ) theValues.add( pKana );
			if( theValues.size() == 0 ) return '';
			return String.join( theValues, ' | ' );
		}

		private String formatAddr(String pZipCode, String pState, String pCity, String pStreet){
			String theStateCityStreet = 
				(String.isBlank(pState) ? '' : pState) + 
				(String.isBlank(pCity) ? '' : pCity) + 
				(String.isBlank(pStreet) ? '' : pStreet);
			List<String> theValues = new List<String>();
			if( !String.isBlank( pZipCode ) ) theValues.add( pZipCode );
			if( !String.isBlank( theStateCityStreet ) ) theValues.add( theStateCityStreet );
			return String.join( theValues, ' ' ).left(50);
        }
    }
}