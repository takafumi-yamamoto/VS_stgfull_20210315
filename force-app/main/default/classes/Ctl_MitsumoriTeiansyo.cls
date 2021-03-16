public class Ctl_MitsumoriTeiansyo {

    public static List<Id> collectTemplateRef(List<MitsumoriTeiansyo__c> entries){
        Set<Id> theIds = new Set<Id>();
        for(MitsumoriTeiansyo__c aEntry : entries){
            if(aEntry.Cmd_TemplateRef__c != null) theIds.add(aEntry.Cmd_TemplateRef__c);
        }
        return new List<Id>( theIds );
    }

    public class TemplateService{

        public Map<String,List<DepPickListCtrl.TPicklistEntry>> tPicklistEntries = new Map<String,List<DepPickListCtrl.TPicklistEntry>>();
            
        public void applyTemplateOnMitsumoriTeiansyoBeforeInsert(List<MitsumoriTeiansyo__c> pMitsumoriTeiansyos, List<MitsumoriTeianshoTemplate__c> pTemplates){
            this.applyTemplate(pMitsumoriTeiansyos, pTemplates);
        }
        private void applyTemplate(List<MitsumoriTeiansyo__c> pMitsumoriTeiansyos, List<MitsumoriTeianshoTemplate__c> pTemplates){
            Map<Id, SObject> theMapOfTemplateById = SobjectsExtension.listToMap(pTemplates);
            for(MitsumoriTeiansyo__c aMitsumoriTeiansyo : pMitsumoriTeiansyos){
                if(aMitsumoriTeiansyo.Cmd_TemplateRef__c == null) continue;
                MitsumoriTeianshoTemplate__c theTemplate = (MitsumoriTeianshoTemplate__c)theMapOfTemplateById.get(aMitsumoriTeiansyo.Cmd_TemplateRef__c);
                this.applyTemplate(aMitsumoriTeiansyo, theTemplate);
            }
        }
        private void applyTemplate(MitsumoriTeiansyo__c pMitsumoriTeiansyo, MitsumoriTeianshoTemplate__c pTemplate){
            pMitsumoriTeiansyo.HosokuSetsumei__c = pTemplate.HosokuSetsumei__c;
        }

        public List<TeianSho__c> createTeianshosByTemplate(List<MitsumoriTeiansyo__c> pMitsumoriTeiansyos, List<MitsumoriTeianshoTemplate__c> pTemplates){
            List<TeianSho__c> theTeianshos = new List<TeianSho__c>();
            tPicklistEntries = DepPickListCtrl.GetDependentOptions('MitsumoriTeiansyoCmd__c','Service__c','Plans__c');
            Map<Id, SObject> theMapOfTemplateById = SobjectsExtension.listToMap(pTemplates);
            for(MitsumoriTeiansyo__c aMitsumoriTeiansyo : pMitsumoriTeiansyos){
                if(aMitsumoriTeiansyo.Cmd_TemplateRef__c == null) continue;
                List<DepPickListCtrl.TPicklistEntry> thisPicklistEntries = tPicklistEntries.get(aMitsumoriTeiansyo.Service__c);
                MAP<String,String> thisPicklistMap = new MAP<String,String>();
                for(DepPickListCtrl.TPicklistEntry Picklist :thisPicklistEntries){
                    thisPicklistMap.put(Picklist.value, Picklist.value);
                }
                MitsumoriTeianshoTemplate__c theTemplate = (MitsumoriTeianshoTemplate__c)theMapOfTemplateById.get(aMitsumoriTeiansyo.Cmd_TemplateRef__c);
                theTeianshos.addAll( this.createTeianshosByTemplate(aMitsumoriTeiansyo, theTemplate,thisPicklistMap) );
            }
            return theTeianshos;
        }
        private List<TeianSho__c> createTeianshosByTemplate(MitsumoriTeiansyo__c pMitsumoriTeiansyo, MitsumoriTeianshoTemplate__c pTemplate,MAP<String,String> thisPicklistMap){
            List<TeianSho__c> theTeianshos = new List<TeianSho__c>();			            
            for(TeianshoTemplate__c aTeianshoTemplate : pTemplate.TeianshoTemplates__r){
                if(thisPicklistMap.get(aTeianshoTemplate.Plan__c) != null){
                    TeianSho__c theTeianSho = new TeianSho__c
                        (
                        MitsumoriTeianshoRef__c = pMitsumoriTeiansyo.Id,
                        SubTitle__c = aTeianshoTemplate.SubTitle__c,
                        TsuikaRyokin1_Hinmei__c = aTeianshoTemplate.TsuikaRyokin1_Hinmei__c,
                        TsuikaRyokin1_Kingaku__c = aTeianshoTemplate.TsuikaRyokin1_Kingaku__c,
                        TsuikaRyokin2_Hinmei__c = aTeianshoTemplate.TsuikaRyokin2_Hinmei__c,
                        TsuikaRyokin2_Kingaku__c = aTeianshoTemplate.TsuikaRyokin2_Kingaku__c,
                        Plan__c = aTeianshoTemplate.Plan__c,
                        TokkiJiko__c = aTeianshoTemplate.TokkiJiko__c
                        );
                    theTeianshos.add(theTeianSho);
	            }
            }
            return theTeianshos;
        }
    }

    public class CommandService{
        public void InsertMitsumoriTeiansyoCmdAndAttachOnMitsumoriTeiansyoBeforeInsert(List<MitsumoriTeiansyo__c> newOnes){
            this.InsertMitsumoriTeiansyoCmdAndAttach(newOnes);
        }
        private void InsertMitsumoriTeiansyoCmdAndAttach(List<MitsumoriTeiansyo__c> pMitsumoriTeiansyos){
            List<MitsumoriTeiansyoCmd__c> theCommandsToBeInserted = new List<MitsumoriTeiansyoCmd__c>();
            for(MitsumoriTeiansyo__c aMitsumoriTeiansyo : pMitsumoriTeiansyos){
                theCommandsToBeInserted.add(
                    new MitsumoriTeiansyoCmd__c(
                        Service__c = aMitsumoriTeiansyo.Service__c,
                    	TekiyoWaribiki__c = aMitsumoriTeiansyo.TekiyoWaribiki__c)
                );
            }
            Insert theCommandsToBeInserted;

            Integer theIndex = -1;
            for(MitsumoriTeiansyo__c aMitsumoriTeiansyo : pMitsumoriTeiansyos){
                theIndex ++;
                aMitsumoriTeiansyo.MitsumoriTeiansyoCmdRef__c = theCommandsToBeInserted.get(theIndex).Id;
            }
        } 
    }
}