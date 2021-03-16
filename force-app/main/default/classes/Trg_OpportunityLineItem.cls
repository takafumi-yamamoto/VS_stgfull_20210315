public without sharing class Trg_OpportunityLineItem {

  private boolean m_isExecuting = false;
  private integer BatchSize = 0;
  
  private static Boolean isTriggerActive = true;
  public static void setTriggerActive(){isTriggerActive = true; }
  public static void setTriggerInActive(){isTriggerActive = false; }

  public Trg_OpportunityLineItem(boolean isExecuting, integer size){
      m_isExecuting = isExecuting;
      BatchSize = size;
  }

  public void OnBeforeInsert(List<OpportunityLineItem> newList){
    if( !isTriggerActive ) return;
    System.Debug('Limits.getQueries().Trg_OpportunityLineItem.01;' + Limits.getQueries());
    Ctl_OpportunityLineItem.getInstanceOfApplyingProductDefaultToLineItems()
      .onOpportunityLineItemBeforeInsert(newList);
    OpportunityLineItemCheck.checkYorisoNoOsoshiki(newList);
    KeirSimeLocks.onOpportunityLineItemBeforeInsert(newList);
    System.Debug('Limits.getQueries().Trg_OpportunityLineItem.02;' + Limits.getQueries());
  }

  public void OnBeforeUpdate(List<OpportunityLineItem> newList, Map<ID, OpportunityLineItem> oldMap){
    if( !isTriggerActive ) return;
    System.Debug('Limits.getQueries().Trg_OpportunityLineItem.03;' + Limits.getQueries());
    Ctl_OpportunityLineItem.getInstanceOfApplyingProductDefaultToLineItems()
      .onOpportunityLineItemBeforeUpdate(newList,oldMap);
    KeirSimeLocks.onOpportunityLineItemBeforeUpdate(newList,oldMap);
    System.Debug('Limits.getQueries().Trg_OpportunityLineItem.04;' + Limits.getQueries());
  }
  public void OnBeforeDelete(List<OpportunityLineItem> oldOne){
    if( !isTriggerActive ) return;
    KeirSimeLocks.onOpportunityLineItemBeforeDelete(oldOne);
  }

  public void OnAfterInsert(List<OpportunityLineItem> newList){
    if( !isTriggerActive ) return;
    System.Debug('Limits.getQueries().Trg_OpportunityLineItem.05;' + Limits.getQueries());
    new Ctl_OpportunityLineItem.RegisteringTesuryoCyoseiMeisais().onOpportunityLineItemAfterInsert(newList);
    System.Debug('Limits.getQueries().Trg_OpportunityLineItem.06;' + Limits.getQueries());
    new Ctl_WaribikiShouhin().addWaribikiShouhin(newList);
    System.Debug('Limits.getQueries().Trg_OpportunityLineItem.07;' + Limits.getQueries());
    // issues4314 --Start--
    new ShukeiyoKetteiPlanConversion().updateSimpleYasugoList(newList);
    // issues4314 --End--
  }

  public void OnAfterUpdate(List<OpportunityLineItem> newList, Map<ID, OpportunityLineItem> oldMap){
  }

  public void OnAfterDelete(List<OpportunityLineItem> oldList){
    // issues4314 --Start--
    new ShukeiyoKetteiPlanConversion().updateSimpleYasugoList(oldList);
    // issues4314 --End--
  }
}