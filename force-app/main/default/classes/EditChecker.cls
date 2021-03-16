/**
* @author : Exia.Huang
*/
public with sharing class EditChecker {

    @AuraEnabled
    public static String getEditorInfo(String recordId) {
        try {
            EditCheckerHandler handler = new EditCheckerHandler();

            String result = '';

            Opportunity theOpp = handler.getOpportunity(recordId);
            if( theOpp != null){
                String editUser = theOpp.EditUser__c;
                User currentUser = handler.getCurrentUser();
                Boolean isTimeout = handler.isTimeout();

                if(String.isBlank(editUser) || isTimeout){
                    Opportunity opp = new Opportunity(Id=theOpp.Id, EditUser__c=currentUser.Name, OppEditDate__c=Datetime.now());
                    update opp;
                    // result = 'update db ok, lock by ' + currentUser.Name;
                } else if(editUser == currentUser.Name) {
                    result = '';
                } else {
                    result = editUser + 'さんがこの商談画面を確認中です。ご注意ください。';
                }
            }

            return result;
        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static void clearEditorInfo(String recordId) {
        // System.debug('>>>>clearEditorInfo start!');
        try {
            EditCheckerHandler handler = new EditCheckerHandler();

            User currentUser = handler.getCurrentUser();
            Opportunity theOpp = handler.getOpportunity(recordId);
            
            if( theOpp != null){
                String editUser = theOpp.EditUser__c;
                if(String.isNotBlank(editUser) && editUser == currentUser.Name){

                    Opportunity opp = new Opportunity(Id=theOpp.Id, EditUser__c=Null, OppEditDate__c=Null);
                    // System.debug('>>>>clearEditorInfo');
                    // System.debug(opp);
                    update opp;
                }
            }

        } catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public class EditCheckerHandler {
        private User currentUser;
        private Opportunity theOpp;

        public User getCurrentUser(){
            if(currentUser == null){
                currentUser = Dao_User.getInstance().selectById(UserInfo.getUserId());
            }
            return currentUser;
        }

        public Opportunity getOpportunity(String recordId){
            if(theOpp == null){
                Dao_Opportunity f_Dao_Opportunity = Dao_Opportunity.getInstance();
                theOpp = OpportunityLinqs.FirstOrDefault(
                    f_Dao_Opportunity.selectByIds( new List<Id>{ recordId } )
                );
            }
            return theOpp;
        }

        public Integer getDefaultTimeout() {
            CommonSetting__c setting = CommonSetting__c.getInstance('default');
            if(setting !=null ){
                return setting.OppLockTime__c.intValue();
            }
            return 10;
        }

        private Boolean isTimeout(Datetime dt, Integer timeout){
            if(dt == null) return true;

            Datetime now = Datetime.now();
            Datetime overDatetime = dt.addMinutes(timeout);
            if(now > overDatetime){
                return true;
            }
            return false;
        }

        public Boolean isTimeout(){
            return isTimeout(theOpp.OppEditDate__c, getDefaultTimeout());
        }
    }


}