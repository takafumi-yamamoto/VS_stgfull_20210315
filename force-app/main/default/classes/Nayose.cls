public class Nayose {

    public void nayoseSogisha(List<Account> newAccountList, Map<ID, Account> oldAccountMap){

        ID rtSoryoAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SoryoAccount').getRecordTypeId();
        ID rtSogishaId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sogisya').getRecordTypeId();

        for(Account newAccount : newAccountList){

            if((newAccount.RecordTypeId == rtSoryoAccountId || 
                newAccount.RecordTypeId == rtSogishaId) &&
                (oldAccountMap == null || 
                newAccount.Phone != oldAccountMap.get(newAccount.Id).Phone ||
                newAccount.Phone2__c != oldAccountMap.get(newAccount.Id).Phone2__c ||
                newAccount.MobilePhone__c != oldAccountMap.get(newAccount.Id).MobilePhone__c ||
                newAccount.MailAddress__c != oldAccountMap.get(newAccount.Id).MailAddress__c ||
                newAccount.MailAddress2__c != oldAccountMap.get(newAccount.Id).MailAddress2__c)){
                
                String tempValue1 = '';
                String tempValue2 = '';
                if(newAccount.Phone != null) tempValue1 = newAccount.Phone.replace('-', '');
                if(newAccount.RecordTypeId == rtSogishaId && newAccount.Phone2__c != null) tempValue2 = newAccount.Phone2__c.replace('-', '');
                if(newAccount.RecordTypeId == rtSoryoAccountId && newAccount.MobilePhone__c != null) tempValue2 = newAccount.MobilePhone__c.replace('-', '');
                List<String> phoneStringSortList = stringSortList(tempValue1, tempValue2);
                newAccount.NayosePhone1__c = phoneStringSortList.get(0);
                newAccount.NayosePhone2__c = phoneStringSortList.get(1);

                List<String> mailStringSortList = stringSortList(newAccount.MailAddress__c, newAccount.MailAddress2__c);
                newAccount.NayoseMailAddress__c = mailStringSortList.get(0);
                newAccount.NayoseMailAddress2__c = mailStringSortList.get(1);
            }
        }
    }

    public void nayoseCustomer(List<Account> newAccountList, Map<ID, Account> oldAccountMap){

        ID rtCustomerAccountId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

              
        for(Account newAccount : newAccountList){

            if(newAccount.RecordTypeId == rtCustomerAccountId &&
                (oldAccountMap == null || 
                newAccount.Phone != oldAccountMap.get(newAccount.Id).Phone ||
                newAccount.MobilePhone__c != oldAccountMap.get(newAccount.Id).MobilePhone__c ||
                newAccount.MailAddress__c != oldAccountMap.get(newAccount.Id).MailAddress__c ||
                newAccount.MailAddress2__c != oldAccountMap.get(newAccount.Id).MailAddress2__c)){
                
                
                String thePhoneKey = genTelNoKey(newAccount.Phone);
                String theMobilePhoneKey = genTelNoKey(newAccount.MobilePhone__c);
                String theMailAddressKey = genMailKey(newAccount.MailAddress__c);
                String theMailAddress2Key = genMailKey(newAccount.MailAddress2__c);

                newAccount.NayosePhone1__c = sortNayoseKey(thePhoneKey,theMobilePhoneKey).get(0);
                newAccount.NayosePhone2__c = sortNayoseKey(thePhoneKey,theMobilePhoneKey).get(1);
                newAccount.NayoseMailAddress__c = sortNayoseKey(theMailAddressKey,theMailAddress2Key).get(0);
                newAccount.NayoseMailAddress2__c = sortNayoseKey(theMailAddressKey,theMailAddress2Key).get(1);
            }
        }
    }
    
    public List<String> stringSortList(String value1, String value2){

        List<String> tempList = new List<String>();
        String strValue1 = '';
        String strValue2 = '';
        if(value1 == null || value1 == ''){
            strValue1 = value2;
            strValue2 = value2;
        }
        else if(value2 == null || value2 == ''){
            strValue1 = value1;
            strValue2 = value1;
        }
        else{
            if(value1 <= value2){
                strValue1 = value1;
                strValue2 = value2;
            }
            else{
                strValue1 = value2;
                strValue2 = value1;
            }
        }

        tempList.add(strValue1);
        tempList.add(strValue2);
        return tempList;
    }

    public String genTelNoKey(String pTelNo){
        if(String.isBlank(pTelNo)) return null;
        String regEx = '[^0-9]';   
        Pattern p = Pattern.compile(regEx);   
        Matcher m = p.matcher(pTelNo);
        String theReplaced = m.replaceAll('').trim();
        return String.isBlank(theReplaced) ? null : theReplaced;
    }
    public String genMailKey(String pMailAddress){
        if(String.isBlank(pMailAddress)) return null;
        return pMailAddress.trim();
    }


    private List<String> sortNayoseKey(String pVal1, String pVal2){
        List<String> result = new List<String>();

        if(String.isBlank(pVal1)){
            result.add(pVal2);
            result.add(pVal2);
        } else if(String.isBlank(pVal2)) {
            result.add(pVal1);
            result.add(pVal1);
        } else {
            result.add(pVal1);
            result.add(pVal2);
            result.sort();
        }
        return result;
    }

}