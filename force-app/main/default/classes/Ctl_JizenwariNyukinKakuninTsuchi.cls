public class Ctl_JizenwariNyukinKakuninTsuchi {


	public void processingOfNyukinKakuninTsuchi(List<Jizenwari__c> targetJizenwaris, Date sendMailconditionsDate){

		List<Id> targetJizenwariIds = new List<Id>();
		Set<Id> accountIds = new Set<Id>();
		for(Jizenwari__c jizenwari: targetJizenwaris){
			targetJizenwariIds.add(jizenwari.Id);
			accountIds.add(jizenwari.KeiyakuSha__c);
		}

		List<JizenwariShodan> jizenwariShodans = Dao_JizenwariShodans.getInstance().selectByjizenwariIds(targetJizenwariIds);

		Map<Id, Account> accountMap = createMapOfIdAndAccount(accountIds);


		List<Jizenwari__c> sendMailJizennwaris = new List<Jizenwari__c>();
		List<SendMail__c>  insertSendMails = new List<SendMail__c>();

		for(JizenwariShodan aJizenwariShodan : jizenwariShodans){

			if(accountMap.containsKey(aJizenwariShodan.jizenwari.KeiyakuSha__c)) {

	    		if(sendMailHantei(aJizenwariShodan,sendMailconditionsDate)){

	    			Account targetAccount = accountMap.get(aJizenwariShodan.jizenwari.KeiyakuSha__c);
	    			insertSendMails.add(createSendMail(targetAccount, aJizenwariShodan.jizenwari));

	    			Jizenwari__c targetJizenwari = aJizenwariShodan.jizenwari;
	    			targetJizenwari.NyukinKakuninTsuchiBi__c = date.Today();
	    			sendMailJizennwaris.add(targetJizenwari);
	    		}
			}

		}

		update sendMailJizennwaris;
		if(!Test.isRunningTest()){
			insert insertSendMails;	
		}
		
	}


	private Map<Id, Account> createMapOfIdAndAccount(Set<Id> accountIds){

		RecordType defualtAccount = new RecordTypeDao().selectRecordBySobjectTypeDeveloperName('Account', 'null');
		
		List<Account> targetAccounts = [SELECT 
											Id,
											LastName,
											FirstName,
											NameFurigana__c,
											MailAddress__c 
		                                FROM 
		                                	Account 
		                                WHERE
		                                	Id = :accountIds
		                                AND
		                                	RecordTypeId != :defualtAccount.Id 
		                                AND 
		                                	MailAddress__c != null

		                                ];

		return new Map<Id, Account>(targetAccounts);

	}

	private Boolean sendMailHantei(JizenwariShodan aJizenwariShodan,Date sendMailconditionsDate){

		if( sendMailconditionsDate <= aJizenwariShodan.jizenwari.MoushikomiKanryoBi__c 
			&& 
			date.Today().addDays(-30) <= aJizenwariShodan.jizenwari.MoushikomiKanryoBi__c
			&&
			aJizenwariShodan.Opp.KessaiKingakuGoukei__c > 0

			){
			return true;
		}

		return false;
	}

	private SendMail__c createSendMail(Account targetAccount, Jizenwari__c targetJizenwari){

		SendMail__c newSendMail = new SendMail__c();

		newSendMail.Atesaki__c            = targetAccount.MailAddress__c;
		newSendMail.MoshikomishaSei__c    = targetAccount.LastName;
		newSendMail.MoshikomishaMei__c    = targetAccount.FirstName;
		newSendMail.MoshikomishaKana__c   = targetAccount.NameFurigana__c;
		newSendMail.MoushikomiKanryoBi__c = targetJizenwari.MoushikomiKanryoBi__c;
	    newSendMail.Yuko_kigenStart__c    = targetJizenwari.Yuko_kigenStart__c;
		return newSendMail;
	}

}