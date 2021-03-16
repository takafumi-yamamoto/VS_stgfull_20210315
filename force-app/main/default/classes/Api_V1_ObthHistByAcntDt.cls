public class Api_V1_ObthHistByAcntDt {
	
	public interface IDataProvider{
		Api_V1_ObthHistByAcntRes.Response getResponse(Api_V1_ObthHistByAcntReq.Req pReq);
	}

	public class DataProvider implements IDataProvider{
		private Api_V1_ObthHistByAcntRes.IOboTehaiValidator mOboTehaiValidator = null;
		public DataProvider(Api_V1_ObthHistByAcntRes.IOboTehaiValidator pOboTehaiValidator){
			this.mOboTehaiValidator = pOboTehaiValidator;
		}
		
		public Api_V1_ObthHistByAcntRes.Response getResponse(Api_V1_ObthHistByAcntReq.Req pReq){

			Account theAccount = this.selectAccount(pReq.torihikisaki_bango);
			if( theAccount == null ) throw new Api_V1_ObthHistByAcntDt.AccountNotFoundException();

			List<Opportunity> theOpps = this.selectOpps(theAccount.Id);

			Api_V1_ObthHistByAcntRes.Torihikisaki theTorihikisaki = new Api_V1_ObthHistByAcntRes.Torihikisaki();
			{
				theTorihikisaki.torihikisaki_bango = theAccount.TorihikisakiBango__c;
				theTorihikisaki.last_name = theAccount.LastName;
				theTorihikisaki.first_name = theAccount.FirstName;
				theTorihikisaki.last_name_kana = theAccount.LastNameFurigana__pc;
				theTorihikisaki.first_name_kana = theAccount.FirstNameFurigana__pc;
				theTorihikisaki.mobile_phone = theAccount.MobilePhone__c;
				theTorihikisaki.email = theAccount.MailAddress__c;
			}

			List<Api_V1_ObthHistByAcntRes.OboTehai> theOboTehais = new List<Api_V1_ObthHistByAcntRes.OboTehai>();
			for(Opportunity aOpp : theOpps){
				Api_V1_ObthHistByAcntRes.OboTehai aOboTehai = this.createOboTehai(aOpp);
				if(this.mOboTehaiValidator.isValid(aOboTehai) ) theOboTehais.add(aOboTehai);
			}

			Api_V1_ObthHistByAcntRes.Response theResponse = new Api_V1_ObthHistByAcntRes.Response();
			{
				theResponse.torihikisaki = theTorihikisaki;
				theResponse.obotehais = theOboTehais;
			}

			return theResponse;
		}

		private Account selectAccount(String pTorihikisakiBango){

			if( String.isBlank(pTorihikisakiBango) ) return null;
			Account theAccount = (Account)SobjectsExtension.firstOrNull(
				[
					SELECT Id, TorihikisakiBango__c,
					LastNameFurigana__pc, FirstNameFurigana__pc,
					LastName, FirstName,
					MobilePhone__c, MailAddress__c
					FROM Account
					WHERE TorihikisakiBango__c = :pTorihikisakiBango
					LIMIT 1
				]
			);
			return theAccount;
		}

		private List<Opportunity> selectOpps(String pAccountId){
			List<Opportunity> theOpps = [
				SELECT Id, ShodanBango__c,
				Utiagebi__c,
				ObosanbinRef__c,
				ObosanbinRef__r.MemorialServicePlan__c,
				ObosanbinRef__r.ZokugaraSodanshaNitottenoTaishosha1__c,

				ObosanbinRef__r.SekoTantoSoryoSangoJiinMei__c,
				ObosanbinRef__r.SekoTantoSoryoShushi__c,
				ObosanbinRef__r.SekoTantoSoryoShuha__c,
				ObosanbinRef__r.SekotantoSoryoSoryomei__c,

				ObosanbinRef__r.Taishosha1Ref__c,
				ObosanbinRef__r.Taishosha1Ref__r.TorihikisakiBango__c,
				ObosanbinRef__r.Taishosha1Ref__r.LastNameFurigana__pc,
				ObosanbinRef__r.Taishosha1Ref__r.FirstNameFurigana__pc,
				ObosanbinRef__r.Taishosha1Ref__r.LastName,
				ObosanbinRef__r.Taishosha1Ref__r.FirstName,
				ObosanbinRef__r.Taishosha1Ref__r.Syuha__c,
				ObosanbinRef__r.Taishosha1Ref__r.PersonBirthdate,
				ObosanbinRef__r.Taishosha1Ref__r.PersonDeathDate__pc,

				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.KeiyakuBango__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.KeiyakuJokyo__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c,

				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyusi__c,
				ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c,
				
				ObosanbinRef__r.ObosanbinKeiyakuSekotanto__c,
				ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.KeiyakuBango__c,
				ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.KeiyakuJokyo__c,
				ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__c,
				ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name
				FROM Opportunity
				WHERE AccountId = :pAccountId
				AND Utiagebi__c != null
				AND StageName IN ('施行待ち','施行完了','商談クローズ')
				ORDER BY Utiagebi__c DESC
				LIMIT 20
			];
			return theOpps;
		}

		private Api_V1_ObthHistByAcntRes.OboTehai createOboTehai(Opportunity pOpp){
			Opportunity aOpp = pOpp;

			Api_V1_ObthHistByAcntRes.Taishosha aTaishosha = null;
			{
				if( !String.isBlank(aOpp.ObosanbinRef__r.Taishosha1Ref__r.TorihikisakiBango__c) ){
					Api_V1_ObthHistByAcntRes.Taishosha theTaishosha = new Api_V1_ObthHistByAcntRes.Taishosha();
					theTaishosha.torihikisaki_bango = aOpp.ObosanbinRef__r.Taishosha1Ref__r.TorihikisakiBango__c;
					theTaishosha.last_name = aOpp.ObosanbinRef__r.Taishosha1Ref__r.LastName;
					theTaishosha.first_name = aOpp.ObosanbinRef__r.Taishosha1Ref__r.FirstName;
					theTaishosha.last_name_kana = aOpp.ObosanbinRef__r.Taishosha1Ref__r.LastNameFurigana__pc;
					theTaishosha.first_name_kana = aOpp.ObosanbinRef__r.Taishosha1Ref__r.FirstNameFurigana__pc;
					theTaishosha.birth_date = 
						aOpp.ObosanbinRef__r.Taishosha1Ref__r.PersonBirthdate != null
						? String.valueOf(aOpp.ObosanbinRef__r.Taishosha1Ref__r.PersonBirthdate)
						: null;
					theTaishosha.death_date = 
						aOpp.ObosanbinRef__r.Taishosha1Ref__r.PersonDeathDate__pc != null
						? String.valueOf(aOpp.ObosanbinRef__r.Taishosha1Ref__r.PersonDeathDate__pc)
						: null;

					theTaishosha.zokugara_by_sodansha =	
						aOpp.ObosanbinRef__r.ZokugaraSodanshaNitottenoTaishosha1__c;
					
					aTaishosha = theTaishosha;
				}
			}

			Api_V1_ObthHistByAcntRes.OboPlanEvent aOboPlanEvent = null;
			{
				if( !String.isBlank(aOpp.ObosanbinRef__r.MemorialServicePlan__c)  ){
					Api_V1_ObthHistByAcntRes.OboPlanEvent theOboPlanEvent = new Api_V1_ObthHistByAcntRes.OboPlanEvent();
					theOboPlanEvent.code = aOpp.ObosanbinRef__r.MemorialServicePlan__c;
					theOboPlanEvent.Name = 
						sche_Pickls.tryGetLabel(
							'Obosanbin__c',
							'MemorialServicePlan__c',
							aOpp.ObosanbinRef__r.MemorialServicePlan__c,
							'none'
						);
					aOboPlanEvent = theOboPlanEvent;
				}
			}

			String aOboPlanKeitai = null;
			{
				if( !String.isBlank(aOpp.ObosanbinRef__r.MemorialServicePlan__c) ){
					String theMemorialServicePlan = aOpp.ObosanbinRef__r.MemorialServicePlan__c;
					String theOboPlanKeitai = 'HOYO';
					if( OboPlanKeitais.isSogi(theMemorialServicePlan) ) theOboPlanKeitai = 'SOGI';
					if( OboPlanKeitais.isKaimyo(theMemorialServicePlan) ) theOboPlanKeitai = 'KAIMYO';
					aOboPlanKeitai = theOboPlanKeitai;
				}
			}

			Api_V1_ObthHistByAcntRes.KiboShuha aKiboShuha = null;
			{
				if( !String.isBlank(aOpp.ObosanbinRef__r.Taishosha1Ref__r.Syuha__c) ){
					Api_V1_ObthHistByAcntRes.KiboShuha theKiboShuha = new Api_V1_ObthHistByAcntRes.KiboShuha();
					theKiboShuha.code = aOpp.ObosanbinRef__r.Taishosha1Ref__r.Syuha__c;
					theKiboShuha.Name = 
						sche_Pickls.tryGetLabel(
							'Account',
							'Syuha__c',
							aOpp.ObosanbinRef__r.Taishosha1Ref__r.Syuha__c,
							'none'
						);
					aKiboShuha = theKiboShuha;
				}
			}

			Boolean isTashaTehai =
				aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c == '他社手配';
			
			Api_V1_ObthHistByAcntRes.Sekosha aSekosha = null;
			{
				Api_V1_ObthHistByAcntRes.Sekosha theSekosha = new Api_V1_ObthHistByAcntRes.Sekosha();
				theSekosha.name = 
					(!isTashaTehai)
					? aOpp.ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name
					: aOpp.ObosanbinRef__r.SekotantoSoryoSoryomei__c;
				
				if( !String.isBlank(theSekosha.name) ) aSekosha = theSekosha;
			}

			Api_V1_ObthHistByAcntRes.Jiin aJiin = null;
			{
				Api_V1_ObthHistByAcntRes.Jiin theJiin = new Api_V1_ObthHistByAcntRes.Jiin();
				theJiin.name = 
					(!isTashaTehai)
					? aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name
					: aOpp.ObosanbinRef__r.SekoTantoSoryoSangoJiinMei__c;
				theJiin.shushi =
					(!isTashaTehai)
					? aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyusi__c
					: aOpp.ObosanbinRef__r.SekoTantoSoryoShushi__c;
				theJiin.shuha =
					(!isTashaTehai)
					? aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.JiinSyuha__c
					: aOpp.ObosanbinRef__r.SekoTantoSoryoShuha__c;
				
				if( !String.isBlank(theJiin.name) ) aJiin = theJiin;
			}

			Boolean isActive = 
				aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.KeiyakuJokyo__c == '契約中' &&
				(
					isTashaTehai
					||
					aOpp.ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.KeiyakuJokyo__c == '契約中'
				);

			Api_V1_ObthHistByAcntRes.Tehaisaki aTehaisaki = null;
			{
				if( aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c != null ){
					Api_V1_ObthHistByAcntRes.Tehaisaki theTehaisaki = new Api_V1_ObthHistByAcntRes.Tehaisaki();
					theTehaisaki.tehaisaki_keiyaku_bango = 
						aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.KeiyakuBango__c;
					theTehaisaki.sekosha_keiyaku_bango =
						aOpp.ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.KeiyakuBango__c;
					theTehaisaki.is_tasha_tehai = isTashaTehai;
					theTehaisaki.is_active = isActive;
					theTehaisaki.sekosha = aSekosha;
					theTehaisaki.jiin = aJiin;

					aTehaisaki = theTehaisaki;
				}
			}

			Api_V1_ObthHistByAcntRes.OboTehai theOboTehai = new Api_V1_ObthHistByAcntRes.OboTehai();
			{
				theOboTehai.shodan_bango = aOpp.ShodanBango__c;
				theOboTehai.oboplan_keitai = aOboPlanKeitai;
				theOboTehai.oboplan_event = aOboPlanEvent;
				theOboTehai.kibo_shuha = aKiboShuha;
				theOboTehai.service_date = 
					aOpp.Utiagebi__c == null
					? null
					: String.valueOf(aOpp.Utiagebi__c);
				theOboTehai.taishosha = aTaishosha;
				theOboTehai.tehaisaki = aTehaisaki;
			}

			return theOboTehai;
		}
	}

	public class AccountNotFoundException extends Exception{}
}