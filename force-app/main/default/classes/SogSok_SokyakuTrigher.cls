public class SogSok_SokyakuTrigher {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public SogSok_SokyakuTrigher(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnBeforeInsert(List<SogSok_Sokyaku__c> pNewOnes){
        Map<Id, Opportunity> theOpps = this.selectOpps(pNewOnes, null);
        SogSok_Sokyaku_ChkCanNew.subscriveSogSokSokyakuBeforeInsert(pNewOnes, theOpps);
        new Ctl_SogSok_Sokyaku().OnBeforeInsert(pNewOnes);
    }

	public void OnAfterInsert(List<SogSok_Sokyaku__c> pNewOnes){
        new Ctl_SogSok_Sokyaku().OnAfterInsert(pNewOnes);
	}  

    public void OnBeforeDelete(Map<Id,SogSok_Sokyaku__c> pOldOnes){
        for(SogSok_Sokyaku__c aOldOne : pOldOnes.values() ){
            if(aOldOne.DocStatus__c == 'Activated') aOldOne.addError('送客済みのものは削除できません; ');
        }
    }

    private Map<Id, Opportunity> selectOpps(List<SogSok_Sokyaku__c> pNewOnes, Map<Id, SogSok_Sokyaku__c> pOldOnes){
        Set<Id> theOppIds = new Set<Id>();
        if(pNewOnes != null){
            for(SogSok_Sokyaku__c aNewOne : pNewOnes){
                if(aNewOne.OpportunityRef__c!= null) theOppIds.add(aNewOne.OpportunityRef__c);
            }
        }
        if(pOldOnes != null){
            for(SogSok_Sokyaku__c aOldOne : pOldOnes.values() ){
                if(aOldOne.OpportunityRef__c!= null) theOppIds.add(aOldOne.OpportunityRef__c);
            }
        }

        Map<Id, Opportunity> theOpps = new Map<Id, Opportunity>(
            [
                select Id, 
                KiboShiharaiHouhou__c,
                Account.FirstNameFurigana__pc,
                Account.LastNameFurigana__pc,
                Account.Phone,
                Account.MobilePhone__c,
                KakuteibiSyodan__c,
                SimpleYasugoRef__r.OmukaeSakiName__c,
                SimpleYasugoRef__r.OmukaeSakiCity__c,
                SimpleYasugoRef__r.OmukaeSakiState__c,
                SimpleYasugoRef__r.OmukaeSakiStreet__c,
                SimpleYasugoRef__r.OmukaeSakiZipcode__c,
                SimpleYasugoRef__r.KiboGoanchisaki__c,
                SimpleYasugoRef__r.GoanchisakiJusho__c,
                SimpleYasugoRef__r.Id,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Id,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.IsSoukyakujiFax__c,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Id,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.CanPtWebSokyakuExp__c,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Fax,
                SimpleYasugoRef__r.TaishoshaRef__r.Id,
                SimpleYasugoRef__r.TaishoshaRef__r.LastNameFurigana__pc,
                SimpleYasugoRef__r.TaishoshaRef__r.FirstNameFurigana__pc,
                SimpleYasugoRef__r.TaishoshaRef__r.PersonBirthdate,
                SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc,
                SimpleYasugoRef__r.MoshuRef__c,
                (
                    select
                    id, SoukyakuStatus__c
                    from SogSok_Sokyakus__r 
                ),
                (
                    Select 
                    id, 
                    Product2.ShohinBango__c,
                    Product2.k_Service_Id_exp__c,
                    Product2.k_ShohinSyubetsu_Id_exp__c,
                    Product2.HinmokuBunrui__c,
                    Product2.LatestFlg__c
                    From OpportunityLineItems
                )
                from Opportunity
                where Id = :theOppIds
            ]
        );
        return theOpps;
    }
}