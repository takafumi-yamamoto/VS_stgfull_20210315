public class KrshPubSzkSdnShkCards implements Schedulable, Database.Batchable<sObject> {

	//schedulable-section begin
	public void execute(SchedulableContext context) {
		try{
			KrshPubSzkSdnShkCards.start();
		}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(
	                Loggings.Level.Error, '20191206-2007-01', 'KrshPubSzkSdnShkCards.execute','Batch cant start')
	                .putAttr('e.getMessage()',e.getMessage())
	        );
		}
	}
	//schedulable-section end

	//batchable-section begin
	public static void start(){
		if( isBatchActive() ) return;
		database.executebatch(new KrshPubSzkSdnShkCards(), 1);
	}
	private static Boolean isBatchActive(){
        /*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
        String theBatchName = KrshPubSzkSdnShkCards.Class.toString();
        List<AsyncApexJob> theJobs = [
            SELECT Id, ApexClass.Name from AsyncApexJob 
            where Status in ('Holding','Queued','Preparing','Processing') 
            and ApexClass.Name = :theBatchName
            and JobType in ('BatchApex','BatchApexWorker')
            Limit 1
        ];
        return theJobs.size() >= 1;
    }

	public Database.QueryLocator start(Database.BatchableContext BC) { return getQueryLocator(); }
	
	public static Database.QueryLocator getQueryLocator(){
		Date theFromDate = Date.today().addDays(-14);
		Date theToDate = Date.today();

		return Database.getQueryLocator(
			[
				SELECT Id, ShodanBango__c, Utiagebi__c
				FROM Opportunity
				WHERE RecordType.DeveloperName = 'SimpleYasugo'
				AND StageName IN ('決定','施行完了', '施行待ち','商談クローズ')
				AND 
				(
					(
						Utiagebi__c >= :theFromDate 
						AND 
						Utiagebi__c <= :theToDate
					)
				)
			]	
		);
	}

   	public void execute(Database.BatchableContext BC, List<Opportunity> pRecords) {
   		try{
			if( Environments.isSandbox() ) KrshPubSzkSdnShkCards.f_TestDataFilter = new TestDataFilterStub();
			for( Opportunity aOpp : pRecords){
				try{
					Boolean to_exclude_opps_for_shiragiku_list = true;
					KrshPubSzkSdnShkCards.procceedOpp(aOpp.ShodanBango__c, to_exclude_opps_for_shiragiku_list);
				}catch(Exception ex){
					Loggings.writeLog(
						Loggings.createLogEntry(
							Loggings.Level.Error, '20191206-2105-01', 'KrshPubSzkSdnShkCards.execute')
							.putAttr('aOpp.ShodanBango__c', aOpp.ShodanBango__c)
							.putAttr('ex.getMessage()', ex.getMessage())
							.putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
							.putAttr('ex.getStackTraceString()', ex.getStackTraceString()
						)
					);
				}
			}
   		}catch(Exception ex){
	        Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20191206-2008-01', 'KrshPubSzkSdnShkCards.execute')
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
   		}
   	}
	
	public void finish(Database.BatchableContext BC) { }
	//batchable-section end

	//main-section-begin
	public static ITestDataFilter f_TestDataFilter = new TestDataFilter();

	public static void procceedOpp(String pShodanBango, Boolean p_exclude_opps_for_shiragiku_list){
		Opportunity theOpp = getOpp(pShodanBango);
	
		Boolean isTestData = f_TestDataFilter.isTestData(theOpp);
		if( isTestData ) return;
	
		//Dailyのバッチでは、白菊送客分は除く;別途、必要に応じて、人による直接紹介指示がある・・という流れ
		if( p_exclude_opps_for_shiragiku_list ){
			if( new OppList_For_Shiragiku().isMatch(theOpp.Id) ) return;
		}
	
		for( CrossSellingTeian__c crossSellingTeian : theOpp.OpportunityCrossSellings__r ) {
			String teianKekka = crossSellingTeian.TeianKekka__c;
			Boolean isKiboari = teianKekka == 'クロスセル希望あり' || teianKekka == 'クロスセル検討中';
			if(isKiboari) return;
		}

		Boolean isDontContactMe = new ClaimGuard().isDontContactMe( theOpp.Account.TorihikisakiBango__c );
		if( isDontContactMe ) return;

		Boolean isValid = new OppValidation().isValid(theOpp);
		if( !isValid ) return;

		String theBiko = '';
		
		KrshSzkSdnShkCard__c theCard = createCard(theOpp, theBiko);

		Boolean isExist = 
			[ SELECT Id FROM KrshSzkSdnShkCard__c WHERE YorisoKanriBango__c = :theCard.YorisoKanriBango__c ]
			.size() > 0;
		if( isExist ) return;

		INSERT theCard;
		INSERT createStausRecord(theCard);
	}

	public static Opportunity getOpp(String pShodanBango){
		Opportunity theOpp =
			[
				SELECT 
				Id, Name, ShodanBango__c,
				RecordType.DeveloperName,
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
				SimpleYasugoRef__r.MitsumorijuryoDay__c,
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
				(
					SELECT ID, TeianKekka__c FROM OpportunityCrossSellings__r
				)
				FROM Opportunity
				WHERE ShodanBango__c = :pShodanBango
			]
			.get(0);
		return theOpp;
	}

	public static KrshSzkSdnShkCard__c createCard(Opportunity pOpp, String pBiko){
		return new CardCreation().createCard(pOpp, pBiko);
	}

	public static KrshSzkSdnStsRec__c createStausRecord(KrshSzkSdnShkCard__c pCard){
		KrshSzkSdnStsRec__c theStatus = new KrshSzkSdnStsRec__c(
			AccountRef__c = pCard.AccountRef__c,
			OppRef__c = pCard.OppRef__c,
			Stage__c = '新規',
			KaikanMei__c = pCard.KaikanMei__c,
			KojinName__c = pCard.KojinName__c,
			KojinAddr__c = pCard.KojinAddr__c,
			KojinDeathDate__c = pCard.KojinDeathDate__c,
			KojinAgeAtDeath__c = pCard.KojinAgeAtDeath__c,
			SekouDate__c = pCard.SekouDate__c,
			ShokaiTantoName__c = pCard.ShokaiTantoName__c,
			ShokaiDate__c = pCard.ShokaiDate__c,
			KrshSzkSdnShkCardRef__c = pCard.Id,
			SodanshaMobile__c = pCard.SodanshaMobile__c,
			SodanshaName__c = pCard.SodanshaName__c,
			SodanshaPhone__c = pCard.SodanshaPhone__c,
			SodanshaAddr__c = pCard.SodanshaAddr__c,
			SodanshaZokugara__c = pCard.SodanshaZokugara__c,
			Biko__c = pCard.Biko__c
		);
		return theStatus;
	}

	public interface ITestDataFilter {
		Boolean isTestData( Opportunity pOpp);
	}
	public class TestDataFilter implements ITestDataFilter{
		public Boolean isTestData( Opportunity pOpp){
			if( this.containsTestKeywords(pOpp.Name) ) return true;
			if( this.containsTestKeywords(pOpp.Account.Name) ) return true;
			if( this.containsTestKeywords(pOpp.Account.NameFurigana__c) ) return true;
			if( this.containsTestKeywords(pOpp.SimpleYasugoRef__r.TaishoshaRef__r.Name) ) return true;
			if( this.containsTestKeywords(pOpp.SimpleYasugoRef__r.TaishoshaRef__r.NameFurigana__c) ) return true;
			return false;
		}
		private Boolean containsTestKeywords(String pValue){
			if( String.isBlank( pValue ) ) return false;
			if( pValue.contains('テスト') ) return true;
			if( pValue.contains('てすと') ) return true;
			if( pValue.toLowerCase().contains('test') ) return true;
			return false;
		}
	}
	public class TestDataFilterStub implements ITestDataFilter{ 
		public Boolean isTestData( Opportunity pOpp){ return false; }
	}

	public class CardCreation{

		public KrshSzkSdnShkCard__c createCard(Opportunity pOpp, String pBiko){
			KrshSzkSdnShkCard__c theCard = new KrshSzkSdnShkCard__c(
				AccountRef__c = pOpp.Account.Id,
				OppRef__c = pOpp.Id,
				YorisoKanriBango__c = this.genYorisoKanriBango(pOpp.ShodanBango__c),
				ShokaiDate__c = Date.today(),
				ShokaiTantoName__c = null,
				SekouDate__c = pOpp.Utiagebi__c,
				KaikanMei__c = this.genKaikanMei(
					pOpp.SimpleYasugoRef__r.SaijoRef__r.Name, pOpp.SimpleYasugoRef__r.SonotaSaijoShisetsu__c,
					pOpp.SimpleYasugoRef__r.KasobaShisetsu__r.Name, pOpp.SimpleYasugoRef__r.SonotaKasobaShisetsu__c
				),
				KojinName__c = this.formatNameAndKana( pOpp.SimpleYasugoRef__r.TaishoshaRef__r.Name, pOpp.SimpleYasugoRef__r.TaishoshaRef__r.NameFurigana__c ),
				KojinAddr__c = this.formatAddr(
					pOpp.SimpleYasugoRef__r.TaishoshaRef__r.BillingPostalCode,
					pOpp.SimpleYasugoRef__r.TaishoshaRef__r.BillingState,
					pOpp.SimpleYasugoRef__r.TaishoshaRef__r.BillingCity,
					pOpp.SimpleYasugoRef__r.TaishoshaRef__r.BillingStreet	
				),
				KojinDeathDate__c = pOpp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc,
				KojinAgeAtDeath__c = this.validateAgeAtDeath(
					pOpp.SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthDate,
					pOpp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc,
					pOpp.SimpleYasugoRef__r.TaishoshaRef__r.Age__pc
				),
				SodanshaName__c = this.formatNameAndKana( pOpp.Account.Name, pOpp.Account.NameFurigana__c ),
				SodanshaMobile__c = pOpp.Account.MobilePhone__c,
				SodanshaPhone__c = pOpp.Account.Phone,
				SodanshaAddr__c = this.formatAddr(
					pOpp.Account.BillingPostalCode,
					pOpp.Account.BillingState,
					pOpp.Account.BillingCity,
					pOpp.Account.BillingStreet	
				),
				SodanshaZokugara__c = pOpp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c,
				Biko__c = pBiko
			);
			return theCard;
		}

		private Decimal validateAgeAtDeath(Date pBirthDate, Date pDeathDate, Decimal pAge){
			if( pBirthDate == null || pDeathDate == null ) return -1;
			return pAge;
		}
		private String genYorisoKanriBango(String pShodanBango){
			return 'Y' + pShodanBango;
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

	public class ClaimGuard{
		public Boolean isDontContactMe(String pTorihikisakiBango){
			Date theBottomDate = Date.today().addYears(-1);
			Account theAccount =
				[
					SELECT Id, TorihikisakiBango__c, 
					KoukokuSmsNg__c, KoukokuDmNg__c, KaihoshiNG__c, TelemarketingNG__pc,
					(
						SELECT Id FROM Tasks 
						WHERE DAY_ONLY(Kijitsu__c) >= :theBottomDate AND Claim__c = True
						LIMIT 1
					),
					(
						SELECT Id FROM OkyakusamaAccounts__r
						WHERE (Hasseibi__c >= :theBottomDate OR DAY_ONLY(CreatedDate) >= :theBottomDate) 
						LIMIT 1
					)
					FROM Account
					WHERE TorihikisakiBango__c = :pTorihikisakiBango
				]
				.get(0);
			
			Contact theContact = (Contact)SobjectsExtension.firstOrNull(
				[
					SELECT Id, 
					(
						SELECT Id FROM Tasks 
						WHERE DAY_ONLY(Kijitsu__c) >= :theBottomDate AND Claim__c = True
						LIMIT 1
					)
					FROM Contact
					WHERE AccountId = :theAccount.Id
					LIMIT 1
				]
			);

			if( theAccount.KoukokuSmsNg__c ) return true;
			if( theAccount.KoukokuDmNg__c ) return true;
			if( theAccount.KaihoshiNG__c ) return true;
			if( theAccount.TelemarketingNG__pc ) return true;
			Boolean theAccountHasClaims = theAccount.Tasks.size() > 0 || theAccount.OkyakusamaAccounts__r.size() > 0;
			if( theAccountHasClaims ) return true;
			Boolean theContactHasClaims = theContact.Tasks.size() > 0;
			if( theContactHasClaims ) return true;
			return false;
		}
	}

	public class OppValidation{
		public Boolean isValid(Opportunity pOpp){
			if( pOpp.RecordType.DeveloperName != 'SimpleYasugo' ) return false;
			if( !new List<String>{'決定','施行完了', '施行待ち','商談クローズ'}.contains(pOpp.StageName) ) return false;
			if( String.isBlank( pOpp.Account.Name ) ) return false;
			if( String.isBlank( pOpp.Account.Phone ) && String.isBlank( pOpp.Account.MobilePhone__c ) ) return false;
			if( pOpp.Account.PersonDeathDate__pc != null ) return false;
			if( String.isBlank( pOpp.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c ) ) return false;
			if( String.isBlank( pOpp.SimpleYasugoRef__r.TaishoshaRef__r.Name ) ) return false;
			if( pOpp.SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc == null ) return false;
			if( pOpp.Utiagebi__c == null ) return false;
			return true;
		}
	}
	//main-section-end

	public class OppList_For_Shiragiku{
		// レポート：白菊用_顧客リスト全国（北海道／沖縄除く）の条件
		// https://minrevi.lightning.force.com/lightning/r/Report/00O2v0000099UpFEAU/view?queryScope=userFolders

		public Boolean isMatch(String pOppId){

			Boolean is_match = true;
			Opportunity the_Opp = (Opportunity)SobjectsExtension.firstOrNull(
				[
					SELECT Id, RecordType.DeveloperName,
					Account.BillingState,
					Account.TelemarketingNG__pc,
					Account.KoukokuDmNg__c,
					Account.ClaimAllNum__c,
					SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c,
					(
						SELECT Id, 
						Product2.Name,
						Product2.k_ShohinSyubetsu_Id_exp__c,
						Product2.k_ShohinSyubetsu_Name_exp__c
						FROM OpportunityLineItems
					)
					FROM Opportunity 
					WHERE Id = :pOppId
					LIMIT 1
				]
			);
			if(the_Opp == null) return false;

			Boolean has_line_item_to_match = false;
			for( OpportunityLineItem aLineItem : the_Opp.OpportunityLineItems ){
				Boolean is_line_item_match = 
					(
						aLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '1'
						||
						aLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '2'
					)
					&&
					aLineItem.Product2.k_ShohinSyubetsu_Name_exp__c == '本体（委託）'
					&&
					!( aLineItem.Product2.Name.contains('火葬') );

				if( is_line_item_match ) has_line_item_to_match = true;
			}

			return 
			the_Opp.RecordType.DeveloperName == 'SimpleYasugo'
			&&
			!( new List<String>{'北海道','沖縄県'}.contains(the_Opp.Account.BillingState) )
			&&
			the_Opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c != null
			&&
			has_line_item_to_match
			&&
			the_Opp.Account.TelemarketingNG__pc == false
			&&
			the_Opp.Account.ClaimAllNum__c != null
			&&
			the_Opp.Account.KoukokuDmNg__c == false
			;
		}
	}
}