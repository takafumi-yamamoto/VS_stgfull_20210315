public with sharing class Utility_Account {

  public void StandardMobileToCustomMobile(List<Account> triggerNew){

    for(Account newOneS : triggerNew){

      if(newOneS.PersonMobilePhone != null){

        newOneS.MobilePhone__c = newOneS.PersonMobilePhone;
      }
    }
  }
}