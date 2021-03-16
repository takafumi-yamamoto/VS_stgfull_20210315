trigger ObouYoyakuCaseToShodanTaskTrigger on ObouYoyakuCaseToShodanTask__c (after insert) {
    new Ctl_ObosanbinService.CaseToShodanTaskProcessor().sendStartRequest();
}