public class Ctl_Achievement_Campaign{

	public void onCaseAfterInsert(List<Case> newOnes){

		Map<id,List<String>> CampaignMoshikomiName = new Map<id,List<String>>();
		Set<String> setBaitaiToroku = new Set<String>();
		List<YorisoCampaigntMaster__mdt> YorisoCampaigntApplication = new List<YorisoCampaigntMaster__mdt> ();
		Map<String,YorisoCampaigntMaster__mdt> CampaignApplicationDetail = new Map<String,YorisoCampaigntMaster__mdt>();
		List<Achievement__c> theAchievementsToBeInseted = new List<Achievement__c>();
		Set<String> setAccountId = new Set<String>();
		List<Account> ListAcc = new List<Account> ();
		List<Id> ListAccId = new List<Id> ();
		Id IDrecordtype = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();


		for(Case c :newOnes){
			if(String.isNotBlank(c.CampaignMoshikomiName__c) && c.AccountId != null){
				String CampaignName = c.CampaignMoshikomiName__c;
				List<String> ListCampaignName = CampaignName.split(';');
				CampaignMoshikomiName.put(c.id,ListCampaignName);
				setAccountId.add(c.AccountId);
				for(String str :ListCampaignName){
					setBaitaiToroku.add(str);
				}
			}
		}

		if(setAccountId.size() > 0){
			ListAcc = [SELECT Id 
						FROM Account
						WHERE Id in :setAccountId
						AND MemberKubunCode__c = 'YorisoKaiin'
						AND recordtypeid = :IDrecordtype];
		}

		if(ListAcc.size() > 0){
			for(Account aAcc :ListAcc){
				ListAccId.add(aAcc.Id);
			}
		}

		if(setBaitaiToroku.size() > 0){
			YorisoCampaigntApplication = [SELECT Id, 
												campaignID__c, 
												campaignsummary__c, 
												campaignmoshikomikaishibi__c, 
												campaignmoshikomishuryobi__c, 
												campaignmoshikomiDeadlinedays__c, 
												campaignkaishibi__c, 
												campaignshuryobi__c 
											FROM YorisoCampaigntMaster__mdt 
											WHERE campaignID__c in :setBaitaiToroku];
		}

		if(YorisoCampaigntApplication.size() > 0){
			for(YorisoCampaigntMaster__mdt y :YorisoCampaigntApplication){
				CampaignApplicationDetail.put(y.campaignID__c,y);
			}
		}

		if(CampaignApplicationDetail.size() > 0){
			for(Case aCase :newOnes){
				if(ListAccId.contains(aCase.AccountId)){
					if(CampaignMoshikomiName.containsKey(aCase.id)){
						List<String> ListTorokuCampaign = CampaignMoshikomiName.get(aCase.id);
						if(ListTorokuCampaign.size() > 0){
							for(String aTorokuCampaign :ListTorokuCampaign){
								if(CampaignApplicationDetail.containsKey(aTorokuCampaign)){
									Achievement__c aAchievement = createAchivement(aCase,CampaignApplicationDetail.get(aTorokuCampaign));
									if(aAchievement != null){
										theAchievementsToBeInseted.add(aAchievement);
									}
								}
							}
						}
					}
				}
			}
		}

		if(theAchievementsToBeInseted.size() > 0){
			Insert theAchievementsToBeInseted;
		}
	}


	private Achievement__c createAchivement(Case pCase, YorisoCampaigntMaster__mdt YCM){
		return new Achievement__c(
			SourceCaseRef__c = pCase.Id,
			TorihikiSakiRef__c = pCase.AccountId,
			Syubetsu__c = YCM.campaignID__c,
			YukoFlag__c = true, 
			BaitaiToroku__c = 'Web',
			YukoKaishiBi__c = Date.today(),
			YukoShuryoBi__c = YCM.campaignshuryobi__c
		);
	}

}