global class AddOpportunityContactRoleBat implements Database.Batchable<sObject>{

	public static ID AccountTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	public static ID OpportunityTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

	public static void Batstart(){
		if(isBatchActive()) return;
		AddOpportunityContactRoleBat__mdt f_CachedConfig = [SELECT BatchSize__c
												FROM AddOpportunityContactRoleBat__mdt
												WHERE DeveloperName = 'AddOpportunityContactRoleBat'
												Limit 1];
		Integer theBatchSize = Integer.valueOf(f_CachedConfig.BatchSize__c);
		Database.executeBatch(new AddOpportunityContactRoleBat(), theBatchSize);
	}

	private static Boolean isBatchActive(){
		/*the apex-class-name of AsyncApexJob is not internal class's name but root-class'name*/
		String theBatchName = AddOpportunityContactRoleBat.Class.toString();
		List<AsyncApexJob> theJobs = [
			SELECT Id, ApexClass.Name from AsyncApexJob 
			where Status in ('Holding','Queued','Preparing','Processing') 
			and ApexClass.Name = :theBatchName
			and JobType in ('BatchApex','BatchApexWorker')
			Limit 1
		];
		return theJobs.size() >= 1;
	}

	public Database.QueryLocator start(Database.BatchableContext bc) {

		return Database.getQueryLocator([SELECT Id,
											ShodanBango__c
										FROM AddOpportunityContactRole__c 
										WHERE ToBeProced__c = True]);

	}

	public void execute(Database.BatchableContext bc, List<AddOpportunityContactRole__c> scope){

		try{
			this.Batrun(scope);

			if(Test.isRunningTest()){
				CalloutException e = new CalloutException();
				e.setMessage('This is a constructed exception!');
				throw e;
			}
			
		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20200204-1452-01', 'AddOpportunityContactRoleBat.execute')
					.putAttr('ex.getMessage()', ex.getMessage())
					.putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
					.putAttr('ex.getStackTraceString()', ex.getStackTraceString()
				)
			);
		}

	}

	public void finish(Database.BatchableContext bc){
		//特に処理はしない
	}

	private void Batrun(List<AddOpportunityContactRole__c> scope){
	
		SET<String> s_ShodanBango = new SET<String>();
		SET<String> s_TargetShodanBango = new SET<String>();
		SET<String> s_TargetAddOpportunityContactRoleId = new SET<String>();
		AddOpportunityContactRoleBat__mdt f_CachedConfig = new AddOpportunityContactRoleBat__mdt();
		List<MarketoManagement__c> l_MarketoManagement = new List<MarketoManagement__c>();
		List<Opportunity> l_TargetOpportunity = new List<Opportunity>();

		String StrCheckEmail = '%@yoriso.com';

		f_CachedConfig = [SELECT MarketoFlg__c,
								TESTMarketoFlg__c
						FROM AddOpportunityContactRoleBat__mdt
						WHERE DeveloperName = 'AddOpportunityContactRoleBat'
						Limit 1];

		//issues3806--Start--
		l_MarketoManagement = [SELECT Id,
									MarketoName__c,
									MarketoFlg__c,
									TESTMarketoFlg__c,
									Campaign__c,
									MarketoClassName__c
								FROM MarketoManagement__c
								WHERE MarketoFlg__c = TRUE];
		//issues3806--End--

		if(f_CachedConfig.MarketoFlg__c){
			for(AddOpportunityContactRole__c ascope :scope){
				s_ShodanBango.add(ascope.ShodanBango__c);
			}
			
			String query_str  = '';
			query_str  = 'SELECT';
			query_str  = query_str  + ' Id,';
			query_str  = query_str  + ' AccountId,';
			query_str  = query_str  + ' Account.RecordTypeId,';
			query_str  = query_str  + ' Account.PersonContactId,';
			query_str  = query_str  + ' Account.MemberTourokuZumi__c,';
			query_str  = query_str  + ' Account.PermissionFlag__pc,';
			query_str  = query_str  + ' Account.E_NG__pc,';
			query_str  = query_str  + ' Account.PersonEmail,';
			query_str  = query_str  + ' MosyuRef__c,';
			query_str  = query_str  + ' MosyuRef__r.RecordTypeId,';
			query_str  = query_str  + ' MosyuRef__r.PersonContactId,';
			query_str  = query_str  + ' TaishoushaJokyo__c,';
			query_str  = query_str  + ' StageName,';
			query_str  = query_str  + ' SubPhase__c,';
			query_str  = query_str  + ' ShodanBango__c';
			query_str  = query_str  + ' FROM Opportunity';
			query_str  = query_str  + ' Where ShodanBango__c in :s_ShodanBango';
			query_str  = query_str  + ' AND RecordTypeId = :OpportunityTypeId';

			//「AddOpportunityContactRoleBat__mdt.TESTMarketoFlg__c」は、本番環境でTESTを行うためのフラグ
			//メールアドレスに'@yoriso.com'が入っているデータのみを処理対象にする
			if(f_CachedConfig.TESTMarketoFlg__c){
				query_str  = query_str  + ' AND Account.PersonEmail like :StrCheckEmail';
			}
			System.debug(query_str);
			l_TargetOpportunity = Database.query(query_str);
			System.debug(l_TargetOpportunity.size());
			System.debug(l_TargetOpportunity);

			if(l_TargetOpportunity.size() > 0){

				for(Opportunity sOpportunity :l_TargetOpportunity){
					s_TargetShodanBango.add(sOpportunity.ShodanBango__c);
				}

				for(AddOpportunityContactRole__c sscope :scope){
					if(s_TargetShodanBango.contains(sscope.ShodanBango__c)){
						s_TargetAddOpportunityContactRoleId.add(sscope.Id);
					}
				}

				addRole(l_TargetOpportunity);

				List<Opportunity> l_OpportunityAdd = UpdateSendToMarketoFlag(l_TargetOpportunity);

				if(l_OpportunityAdd.size() > 0){
					if(l_MarketoManagement.size() > 0){
						for(MarketoManagement__c sMarketoManagement :l_MarketoManagement){
							Type t = Type.forName(sMarketoManagement.MarketoClassName__c);
							MarketoCampaignMember api = (MarketoCampaignMember)t.newInstance();
							api.addCampaignMember(l_OpportunityAdd,sMarketoManagement);
						}
					}
				}
			}

			if(s_TargetAddOpportunityContactRoleId.size() > 0){
				List<AddOpportunityContactRole__c> l_AddOpportunityContactRole = [SELECT Id,
																						ShodanBango__c,
																						LastProcVersion__c 
																				FROM AddOpportunityContactRole__c 
																				WHERE Id in :s_TargetAddOpportunityContactRoleId];
				
				Long NewVerNo = genNewVerNo();
				if(l_AddOpportunityContactRole.size() > 0){
					for(AddOpportunityContactRole__c aAOPCR :l_AddOpportunityContactRole){
						aAOPCR.LastProcVersion__c = NewVerNo;
					}
					update l_AddOpportunityContactRole;
				}
			}
		}
	}

	public static Long genNewVerNo(){
		String StrDate = Datetime.now().format('yyyyMMddHHmmssSSS');
		Long LongDate = Long.valueOf(StrDate);
		return LongDate;
	}

	private void addRole(List<Opportunity> ListOpportunity){

		SET<String> s_OpportunityID = new SET<String>();
		LIST<OpportunityContactRole> l_OpportunityContactRole = new LIST<OpportunityContactRole>();
		LIST<OpportunityContactRole> new_l_OpportunityContactRole = new LIST<OpportunityContactRole>();

		for(Opportunity sopp :ListOpportunity){
			s_OpportunityID.add(sopp.id);
		}
		
		l_OpportunityContactRole = [SELECT Id
									FROM OpportunityContactRole
									WHERE OpportunityId in :s_OpportunityID
									AND Role in ('相談者','喪主')];		
		if(l_OpportunityContactRole.size() > 0){delete l_OpportunityContactRole;}

		for(Opportunity aOpportunity :ListOpportunity){
			if(String.isNotBlank(aOpportunity.AccountId)){
				if(aOpportunity.Account.RecordTypeId == AccountTypeId){
					new_l_OpportunityContactRole.add(newOCR(aOpportunity.Id,aOpportunity.Account.PersonContactId,'相談者'));
				}
			}
			if(String.isNotBlank(aOpportunity.MosyuRef__c)){
				if(aOpportunity.MosyuRef__r.RecordTypeId == AccountTypeId){
					new_l_OpportunityContactRole.add(newOCR(aOpportunity.Id,aOpportunity.MosyuRef__r.PersonContactId,'喪主'));
				}
			}
		}
		if(new_l_OpportunityContactRole.size() > 0){
			insert new_l_OpportunityContactRole;
		}
	}

	public OpportunityContactRole newOCR(Id OpportunityID,Id ContactID,String StrRole){
		OpportunityContactRole sOpportunityContactRole = New OpportunityContactRole();
		sOpportunityContactRole.OpportunityId = OpportunityID;
		sOpportunityContactRole.ContactId = ContactID;
		sOpportunityContactRole.Role = StrRole;
		sOpportunityContactRole.IsPrimary = FALSE;
		return sOpportunityContactRole;
		
	}

	private List<Opportunity> UpdateSendToMarketoFlag(List<Opportunity> ListOpportunity){

		SET<String> s_HaishinContactId = new SET<String>();
		List<Opportunity> return_l_Opportunity = new List<Opportunity>();
		
		for(Opportunity aOpportunity :ListOpportunity){
			if(String.isNotBlank(aOpportunity.AccountId)){
				if((aOpportunity.Account.RecordTypeId == AccountTypeId)
				&& (aOpportunity.Account.MemberTourokuZumi__c)
				&& (aOpportunity.Account.PermissionFlag__pc == '受け取る')
				&& (!aOpportunity.Account.E_NG__pc)
				&& (String.isNotBlank(aOpportunity.Account.PersonEmail))){
					s_HaishinContactId.add(aOpportunity.Account.PersonContactId);
					return_l_Opportunity.add(aOpportunity);
				}
			}
		}

		if(s_HaishinContactId.size() > 0){

			List<Contact> l_Contact = new List<Contact>([SELECT Id, 
															mkto71_SendToMarketoFlag__c,
															Email
														FROM Contact
														WHERE Id in :s_HaishinContactId]);

			if(l_Contact.size() > 0){
				for(Contact aCon :l_Contact){
					aCon.mkto71_SendToMarketoFlag__c = TRUE;
				}
				update l_Contact;
			}
		}
		
		return return_l_Opportunity;

	}

}