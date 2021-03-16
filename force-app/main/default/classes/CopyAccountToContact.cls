public class CopyAccountToContact{

    public void ATC(){}

    /*
	// 個人取引先（AccountからContactへのコピー処理)
	public void Copy(List<Account> newAccountList, Map<ID, Account> oldAccountMap){
		
		Id CustomerrecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'Customer');
		List<Account> ListAcc = new List<Account>();
		
		for(Account newAcc :newAccountList){
			if(newAcc.recordTypeId == CustomerrecordTypeId){
				if(oldAccountMap == null){
					ListAcc.add(newAcc);
				}else{
					Account oldAccount = oldAccountMap.get(newAcc.Id);
					if((newAcc.KoukokuDmNg__c != oldAccount.KoukokuDmNg__c)
					||(newAcc.KoukokuSmsNg__c != oldAccount.KoukokuSmsNg__c)
					||(newAcc.KaihoshiNG__c != oldAccount.KaihoshiNG__c)
					||(newAcc.ClaimAllNum__c != oldAccount.ClaimAllNum__c)
					||(newAcc.MobilePhone__c != oldAccount.MobilePhone__c)
					||(newAcc.YusenMailAddressFormula__c != oldAccount.YusenMailAddressFormula__c)
					||(newAcc.TorihikisakiBango__c != oldAccount.TorihikisakiBango__c)
					||(newAcc.Syushi__c != oldAccount.Syushi__c)
					||(newAcc.Syuha__c != oldAccount.Syuha__c)
					||(newAcc.HakaUmuKubun__c != oldAccount.HakaUmuKubun__c)
					||(newAcc.SonotanoSyukyoSyuha__c != oldAccount.SonotanoSyukyoSyuha__c)
					||(newAcc.BodaijinoUmu__c != oldAccount.BodaijinoUmu__c)
					||(newAcc.MemberTokutenKubun__c != oldAccount.MemberTokutenKubun__c)
					||(newAcc.BillingCountry != oldAccount.BillingCountry)
					||(newAcc.BillingState != oldAccount.BillingState)
					||(newAcc.BillingCity != oldAccount.BillingCity)
					||(newAcc.BillingStreet != oldAccount.BillingStreet)
					||(newAcc.BillingPostalCode != oldAccount.BillingPostalCode)){
						ListAcc.add(newAcc);
					}
				}
			}
		}

		if(ListAcc.size() > 0){
			addCopyAccountToContact(ListAcc);
		}
	}

	public void addCopyAccountToContact(List<Account> pNewAcc){

		SET<String> AccIdBango = New SET<String>();
		
		for(Account aNewAcc : pNewAcc){
			AccIdBango.add(aNewAcc.Id);
		}
		UpdateVersionToBe(AccIdBango);
	}

	public void UpdateVersionToBe(SET<String> AccIdBango){
		Map<String, CopyAccountToContact__c> theDenVers = new Map<String, CopyAccountToContact__c>();
		for(String aAccIdBango : AccIdBango){
			theDenVers.put(
				aAccIdBango,
				new CopyAccountToContact__c(
					AccIdBango__c = aAccIdBango,
					OppVersion__c = genNewVerNo(),
					LastProcVersion__c = 0
				)
			);
		}
		UPSERT theDenVers.values() AccIdBango__c;
	}

	public Long GenNewVerNo(){
		String StrDate = Datetime.now().format('yyyyMMddHHmmssSSS');
		Long LongDate = Long.valueOf(StrDate);
		return LongDate;
	}
	*/

}