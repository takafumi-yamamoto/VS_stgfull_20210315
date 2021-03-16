public class OpportunityLineItemDao{
    
    private String getQueryBody(){
        return 'SELECT Id, Name, OpportunityId, ProductCode, TotalPrice, Quantity, UnitPrice, SyodanWaribikimoto__r.Name, Subtotal, isAutoAddWaribkiItem__c, '
                + ' Opportunity.Name, Opportunity.Iriguchi__c, Opportunity.Pricebook2Id, Opportunity.Account.MemberKubunCode__c, Opportunity.Account.MemberTokutenKubunCode__c, ' 
                + ' Opportunity.TaishosyaRef__r.MemberTokutenKubunCode__c, '
                + ' Opportunity.Req_Day__c, Opportunity.ShiryoSeikyuUmuExp__c, Opportunity.AccountId, '
                //+ ' Opportunity.JizenwariRef__r.Id, Opportunity.JizenwariRef__r.RiyoKaisuSeigenAriExp__c, Opportunity.JizenwariRef__r.Yuko_kigenStart__c, Opportunity.JizenwariRef__r.Yuko_kigenEnd__c, Opportunity.JizenwariRef__r.KeiyakuSha__c, Opportunity.JizenwariRef__r.KeiyakuStatusCdExp__c, '
                + ' Opportunity.RecordType.DeveloperName, '
                + ' Opportunity.TorihikiShodanRef__r.RecordType.DeveloperName, '
                + ' Opportunity.AllianceRef__c, '
                + ' Opportunity.AllianceRef__r.Teikeisaki__r.Name, '
                + ' Opportunity.Account.JizenwariKekaKikan__c, Opportunity.TaishosyaRef__r.JizenwariKekaKikan__c, '
                + ' Opportunity.Account.AcvmJizenJunbiMinDate__c, Opportunity.TaishosyaRef__r.AcvmJizenJunbiMinDate__c, '
                + ' Opportunity.SurveyDiscountAgreeStatus__c, '
                + ' Opportunity.KiboShiharaiHouhou__c, '
                + ' Product2.k_ShohinSyubetsu_Type__c, ' 
                + ' Product2.NameForCustomerExp__c, ' 
                + ' Product2.Name, Product2.ShohinBango__c, Product2.DataKubun__c, Product2.HinmokuBunrui__c ' 
                + ' FROM OpportunityLineItem WHERE Id != null ';
    }

    public Map<Id,OpportunityLineItem> ListToMapById(List<OpportunityLineItem> entries){
        Map<Id,OpportunityLineItem> mapById = new Map<Id,OpportunityLineItem>();
        for(OpportunityLineItem aItem : entries)
        {
            mapById.put(aItem.Id, aItem);
        }
        return mapById;
    }

    public List<OpportunityLineItem> SelectByTehaiShodanId(Set<Id> tehaiShodanIds){
        return Database.query(getQueryBody() + 'AND OpportunityId = :tehaiShodanIds');
    }

    public List<OpportunityLineItem> SelectById(List<Id> ids){
        return Database.query(getQueryBody() + 'AND Id = :ids');
    }

    public OpportunityLineItem SelectById(Id opportunityLineItemId){
        List<OpportunityLineItem> entities = Database.query(getQueryBody() + 'AND Id = :opportunityLineItemId');
        if(entities.size() > 0){
            return entities.get(0);
        }
        return null;
    }
}