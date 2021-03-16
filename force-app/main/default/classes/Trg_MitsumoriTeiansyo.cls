public class Trg_MitsumoriTeiansyo {

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;

	public Trg_MitsumoriTeiansyo(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeInsert(List<MitsumoriTeiansyo__c> newOnes){
        
        Set<String> theOppIds = new Set<String>();
        for(MitsumoriTeiansyo__c aNewOne : newOnes){ theOppIds.add(aNewOne.ShodanRef__c ); }
        Map<String, Opportunity> theOppIdToOpps = new Map<String, Opportunity>();
        for(Opportunity aOpp : [ SELECT Id, Account.JizenwariKekaKikan__c,Account.AcvmJizenWariMinDate__c FROM Opportunity WHERE Id IN :theOppIds ]){
            theOppIdToOpps.put(aOpp.Id, aOpp);
        }
        for(MitsumoriTeiansyo__c aNewOne : newOnes){ 
            String theJizenwariKeikaKikan = theOppIdToOpps.get(aNewOne.ShodanRef__c).Account.JizenwariKekaKikan__c;
            Date theJizenwariMenberKisanbi = theOppIdToOpps.get(aNewOne.ShodanRef__c).Account.AcvmJizenWariMinDate__c;
            aNewOne.JizenwariKekaKikan__c = theJizenwariKeikaKikan;
            aNewOne.JizenwariBackgroundImage__c =  this.getJizenwariBackImg( theJizenwariKeikaKikan );
            aNewOne.AcvmJizenWariMinDate__c = theJizenwariMenberKisanbi;
            aNewOne.JizenwariMember30d__c = theJizenwariMenberKisanbi != null ? theJizenwariMenberKisanbi.addDays(30) : null;
            aNewOne.JizenwariMember1y__c = theJizenwariMenberKisanbi != null ? theJizenwariMenberKisanbi.addDays(366) : null;
            aNewOne.JizenwariMember2y__c = theJizenwariMenberKisanbi != null ? theJizenwariMenberKisanbi.addDays(731) : null;
        }

        List<MitsumoriTeianshoTemplate__c> theTemplates = this.loadMitsumoriTeianshoTemplate(newOnes, new Map<ID, MitsumoriTeiansyo__c>());

        new Ctl_MitsumoriTeiansyo.TemplateService().applyTemplateOnMitsumoriTeiansyoBeforeInsert(Trigger.New,theTemplates);
        new Ctl_MitsumoriTeiansyo.CommandService()
            .InsertMitsumoriTeiansyoCmdAndAttachOnMitsumoriTeiansyoBeforeInsert(Trigger.New);

	}

    private String getJizenwariBackImg(String pJizenwariKekakikan){
        MteianJizenBackImgs__mdt jizenwariImage = MteianJizenBackImgs.getConfig();
        if(pJizenwariKekakikan == '0日～29日') return jizenwariImage.JizenImg0d__c;
        if(pJizenwariKekakikan == '30日～1年') return jizenwariImage.JizenImg30d__c;
        if(pJizenwariKekakikan == '1年～2年') return jizenwariImage.JizenImg1y__c;
        if(pJizenwariKekakikan == '2年～') return jizenwariImage.JizenImg2y__c;
        return null;
    }

	public void OnAfterInsert(List<MitsumoriTeiansyo__c> newOnes){
        List<MitsumoriTeianshoTemplate__c> theTemplates = this.loadMitsumoriTeianshoTemplate(newOnes, new Map<ID, MitsumoriTeiansyo__c>());

        List<TeianSho__c> theTeianShosToBeInserted = new Ctl_MitsumoriTeiansyo.TemplateService().createTeianshosByTemplate(Trigger.New, theTemplates);
        if(theTeianShosToBeInserted.size() > 0){
	        insert theTeianShosToBeInserted;  
        }
	}

    private List<MitsumoriTeianshoTemplate__c> loadMitsumoriTeianshoTemplate(List<MitsumoriTeiansyo__c> newOnes, Map<ID, MitsumoriTeiansyo__c> oldOnes){
        return new List<MitsumoriTeianshoTemplate__c>(
            [
                select id, HosokuSetsumei__c,
                (
                    select id, 
                    Plan__c, SubTitle__c,TokkiJiko__c, TsuikaRyokin1_Hinmei__c, 
                    TsuikaRyokin1_Kingaku__c, TsuikaRyokin2_Hinmei__c, TsuikaRyokin2_Kingaku__c
                    from TeianshoTemplates__r
                )
                from MitsumoriTeianshoTemplate__c where Id = :Ctl_MitsumoriTeiansyo.collectTemplateRef(newOnes)
            ]
        );
    }
}