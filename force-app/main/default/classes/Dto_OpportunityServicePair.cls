public with sharing class Dto_OpportunityServicePair {
    public Opportunity oppObj; 
    public SObject serviceObj; 

    public Dto_OpportunityServicePair (){}

    public Dto_OpportunityServicePair (Opportunity opp, SObject service) {
        oppObj = opp;
        serviceObj = service;
    }
}