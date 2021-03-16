public class Ctl_Jizenwari {

	// 事前割申込時
	public class ProcessingOfJizenwariWebUketsuke{
		public void onOpportunityAfterInserted(List<Opportunity> targetOpportunities){
	        
	        set<Id> caseIdSet    = new set<Id>();
	        map<Id,Case> caseMap = new map<Id,case>();
	        for (Opportunity opp:targetOpportunities){            
	            caseIdSet.add(opp.CaseRef__c);
	        }
	        for (Case c:[select id,
	                            Description,
	                            recordtypeid,
	                            Origin
	                       from Case 
	                      where id in :caseIdSet]){
	        	if(c.Origin != 'Web'){continue;}
    	        caseMap.put(c.id,c);
	        }

	        for(Opportunity targetOpportunitie : targetOpportunities){
	        	//System.debug('targetOpportunitie:' + targetOpportunitie);
	        }

	        if(!caseMap.isEmpty()){
     			Id jizenwariCaseRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','JizenwariWebMoshikomi');

			    List<OkyakusamaSeikyuMeisai__c> insertOkyakusamaSeikyuMeisais = createOkyakusamaSeikyuMeisai(targetOpportunities, caseMap, jizenwariCaseRecordTypeId);	        	
			    List<OpportunityLineItem> insertopportunityLineItems = createOpportunityLineItem(targetOpportunities, caseMap, jizenwariCaseRecordTypeId);
			    insert insertOkyakusamaSeikyuMeisais;
			    insert insertopportunityLineItems;
	        }
		}

		private List<OkyakusamaSeikyuMeisai__c> createOkyakusamaSeikyuMeisai(List<Opportunity> targetOpportunities, map<Id,Case> caseMap, Id jizenwariCaseRecordTypeId){

		    Id kobetsuSeikyuMeisaiRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('OkyakusamaSeikyuMeisai__c','KobetsuSeikyu');


		    List<OkyakusamaSeikyuMeisai__c> createdOkyakusamaSeikyuMeisai = new List<OkyakusamaSeikyuMeisai__c>();
			for(Opportunity anOpportunity : targetOpportunities){

	            Case c = caseMap.get(anOpportunity.CaseRef__c);
	            if (c.recordtypeid == jizenwariCaseRecordTypeId){

	   				Ctl_JizenwariJson2Apex j2Ap = Ctl_JizenwariJson2Apex.parse(c.Description);

	   				String seikyuHouhou = j2Ap.getSeikyuHouhou();

	                OkyakusamaSeikyuMeisai__c jizenwariSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
	                jizenwariSeikyuMeisai.ServiceSyubetsu__c = '事前割';
	                jizenwariSeikyuMeisai.RecordTypeId       = kobetsuSeikyuMeisaiRecordTypeId;
	                jizenwariSeikyuMeisai.SeikyuHouhou__c    = seikyuHouhou;
	                jizenwariSeikyuMeisai.SeikyuBango__c     = j2Ap.sid;
	                jizenwariSeikyuMeisai.SeikyuKingaku__c   = 500;
	                jizenwariSeikyuMeisai.OpportunityRef__c  = anOpportunity.Id;

	                if(seikyuHouhou == 'paydesign_cvs_den'){
	                	jizenwariSeikyuMeisai.SeikyuStatus__c = 'cvs_denpyo_soufu_machi';
	                }

	                createdOkyakusamaSeikyuMeisai.add(jizenwariSeikyuMeisai);
	            }
			}

			return createdOkyakusamaSeikyuMeisai;
		}

		private List<OpportunityLineItem> createOpportunityLineItem(List<Opportunity> targetOpportunities, map<Id,Case> caseMap, Id jizenwariCaseRecordTypeId){
	        
	        //Product2 shohinPlan = [SELECT Id FROM Product2 WHERE ShohinBango__c = 'SBG-0000075' LIMIT 1];
			List<OpportunityLineItem> createdOpportunityLineItems = new List<OpportunityLineItem>();

			for(Opportunity anOpportunity : targetOpportunities){

	            Case c = caseMap.get(anOpportunity.CaseRef__c);
	            if (c.recordtypeid == jizenwariCaseRecordTypeId){

	            	System.debug('----test----');

	                OpportunityLineItem jizenwariShohin = new OpportunityLineItem();
	                jizenwariShohin.OpportunityId = anOpportunity.Id;
	                //jizenwariShohin.Product2Id    = shohinPlan.Id;
	                jizenwariShohin.Product2Id = '01t7F000002QhVWQA0';

	                System.debug('--jizenwariShohin--' + jizenwariShohin);

	                createdOpportunityLineItems.add(jizenwariShohin);
	            }
			}
			return createdOpportunityLineItems;

		}
	
	}

}