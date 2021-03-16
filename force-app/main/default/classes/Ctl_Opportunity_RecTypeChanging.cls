public class Ctl_Opportunity_RecTypeChanging{

    private static Ctl_Opportunity_RecTypeChanging f_Ctl_Opportunity_RecTypeChanging;
    public static Ctl_Opportunity_RecTypeChanging getInstance(){
        if(f_Ctl_Opportunity_RecTypeChanging == null){
            f_Ctl_Opportunity_RecTypeChanging = new Ctl_Opportunity_RecTypeChanging(
                RecordTypeCachedDaos.getInstance()
            );
        }
        return f_Ctl_Opportunity_RecTypeChanging;
    }

    private RecordTypeCachedDaos.IRecordTypeCachedDao f_IRecordTypeCachedDao;
    private Ctl_Opportunity_RecTypeChanging(RecordTypeCachedDaos.IRecordTypeCachedDao pIRecordTypeCachedDao){
        this.f_IRecordTypeCachedDao = pIRecordTypeCachedDao;
    }

    /*public void onOpportunityBeforeUpdate(List<Opportunity> pNewOnes, Map<Id,Opportunity> pOldOnes){
        List<Opportunity> theEntriesToProcess = this.getEntriesToProcess(pNewOnes, pOldOnes);
        this.process(theEntriesToProcess);
    }*/
    public List<Opportunity> onOpportunityBeforeUpdate(List<Opportunity> pNewOnes, Map<Id,Opportunity> pOldOnes){
        List<Opportunity> theEntriesToProcess = this.getEntriesToProcess(pNewOnes, pOldOnes);
        this.process(theEntriesToProcess);
        return theEntriesToProcess;
    }

    private List<Opportunity> getEntriesToProcess(List<Opportunity> pNewOnes, Map<Id,Opportunity> pOldOnes){
        List<Opportunity> theEntires = new List<Opportunity>();
        for(Opportunity aNewOne : pNewOnes){
            Opportunity aOldOne = pOldOnes.get(aNewOne.Id);
            if( this.toProcess(aNewOne, aOldOne) ) theEntires.add(aNewOne);
        }
        return theEntires;
    }

    private Boolean toProcess(Opportunity pNewOne, Opportunity pOldOne){
        if(pNewOne.ChangeRecordType__c == null) return false;
        if(pNewOne.ChangeRecordType__c != pOldOne.ChangeRecordType__c) return true;
        return false;
    }

    private void process(List<Opportunity> pNewOnes){
        for(Opportunity aNewOne : pNewOnes){
            String theRecordTypeNameAfter = aNewOne.ChangeRecordType__c;
            aNewOne.RecordTypeId = this.f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('Opportunity',theRecordTypeNameAfter);
            aNewOne.ChangeRecordType__c = null;
        }
    }
}