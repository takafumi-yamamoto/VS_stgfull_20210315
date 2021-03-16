public class SpfyOppNewAcntRslv {

    public class Req{
        Decimal customer_id;
        public Req set_customer_id(Decimal pValue){ this.customer_id = pValue; return this; }
        String first_name;
        public Req set_first_name(String pValue){ this.first_name = pValue; return this; }
        String last_name;
        public Req set_last_name(String pValue){ this.last_name = pValue; return this; }
        String phone;
        public Req set_phone(String pValue){ this.phone = pValue; return this; }
        String email;
        public Req set_email(String pValue){ this.email = pValue; return this; }
        String address_zip;
        public Req set_address_zip(String pValue){ this.address_zip = pValue; return this; }
        String address_province;
        public Req set_address_province(String pValue){ this.address_province = pValue; return this; }
        String address_city;
        public Req set_address_city(String pValue){ this.address_city = pValue; return this; }
        String address_address1;
        public Req set_address_address1(String pValue){ this.address_address1 = pValue; return this; }
        String address_address2;
        public Req set_address_address2(String pValue){ this.address_address2 = pValue; return this; }
    }

    public class Res{
        public String AccountId;
    }

    public interface IAccountResolver {
        Res resolveAccount(Req pReq);
    } 
    public class AccountResolver implements IAccountResolver{
        public Res resolveAccount(Req pReq){

            Account the_Account_ToBe_Insert = null;
            {
                Boolean isMobilePhone = !String.isBlank(pReq.phone) && isMobileNo(pReq.phone);
    
                the_Account_ToBe_Insert = new Account(
                    RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                    FirstName = pReq.first_name, 
                    LastName = pReq.last_name,
                    BillingPostalCode = pReq.address_zip,
                    BillingState = pReq.address_province,
                    BillingCity = pReq.address_city,
                    BillingStreet = 
                        String.format('{0}{1}', new List<String>{
                            String.isBlank(pReq.address_address1) ? '' :  pReq.address_address1,
                            String.isBlank(pReq.address_address2) ? '' :  pReq.address_address2
                        }),
                    MailAddress__c = pReq.email,
                    MobilePhone__c = isMobilePhone ? pReq.phone : null,
                    Phone = isMobilePhone ? null : pReq.phone,
                    spfy_customer_id__c = pReq.customer_id
                );
            }

            String the_Account_Id_Resolved = null;
            Boolean to_Update_Account = false;
            Database.SaveResult theSaveResult = Database.insert(the_Account_ToBe_Insert, false);

            if( theSaveResult.isSuccess() ){
                the_Account_Id_Resolved = theSaveResult.getId();
            }
            if( !theSaveResult.isSuccess() ){
                String the_Account_Id_Matched = null;
                List<Id> theMatchAccountIds = new List<Id>();
                for(Database.Error aError : theSaveResult.getErrors()){

                    Datacloud.DuplicateResult theDuplicateResult = null;
                    if(aError instanceof Database.DuplicateError){
                        theDuplicateResult = ((Database.DuplicateError)aError).getDuplicateResult();
                    }else{
                        throw new Exceptions.AnException( aError.getMessage() );
                    }

                    List<Datacloud.MatchRecord> thMatchRecords = new List<Datacloud.MatchRecord>();
                    for(Datacloud.MatchResult aMatchResult : theDuplicateResult.getMatchResults()) {
                        thMatchRecords.addAll( aMatchResult.getMatchRecords() );
                    }
    
                    for(Datacloud.MatchRecord aMatchRecord : thMatchRecords) {
                        the_Account_Id_Matched = aMatchRecord.getRecord().Id;
                    }

                    the_Account_Id_Resolved = the_Account_Id_Matched;
                    to_Update_Account = true;
                }
            }

            if(to_Update_Account){

                Account the_Account_ToBeUpdate = [
                    SELECT Id,
                    spfy_customer_id__c,
                    MailAddress__c, MailAddress2__c,
                    MobilePhone__c, Phone
                    FROM Account
                    WHERE Id = :the_Account_Id_Resolved
                    LIMIT 1
                ].get(0);

                Boolean toUpdate = false;
                if( pReq.customer_id != null && pReq.customer_id > 0 ){
                    if( pReq.customer_id != the_Account_ToBeUpdate.spfy_customer_id__c ){
                        the_Account_ToBeUpdate.spfy_customer_id__c = pReq.customer_id;
                        toUpdate = true;
                    }
                }
                
                if(!String.isBlank(pReq.email)){
                    if(pReq.email != the_Account_ToBeUpdate.MailAddress__c && pReq.email != the_Account_ToBeUpdate.MailAddress2__c){
                        the_Account_ToBeUpdate.MailAddress2__c = the_Account_ToBeUpdate.MailAddress__c;
                        the_Account_ToBeUpdate.MailAddress__c = pReq.email;
                        toUpdate = true;
                    }
                }
                if(!String.isBlank(pReq.phone)){
                    if( pReq.phone != the_Account_ToBeUpdate.MobilePhone__c && pReq.phone != the_Account_ToBeUpdate.Phone ){
                        Boolean isMobilePhone = !String.isBlank(pReq.phone) && isMobileNo(pReq.phone);      
                        if(isMobilePhone) the_Account_ToBeUpdate.MobilePhone__c = pReq.phone;
                        if(!isMobilePhone) the_Account_ToBeUpdate.Phone = pReq.phone;
                        toUpdate = true;
                    }

                }
                if(toUpdate){
                    Database.DMLOptions theDmlOption = new Database.DMLOptions();
                    theDmlOption.DuplicateRuleHeader.allowSave = true;
                    Database.SaveResult theSaveResult_Update = 
                        Database.update(
                            new Account(
                                Id = the_Account_ToBeUpdate.Id,
                                MailAddress__c = the_Account_ToBeUpdate.MailAddress__c,
                                MailAddress2__c = the_Account_ToBeUpdate.MailAddress2__c,
                                MobilePhone__c = the_Account_ToBeUpdate.MobilePhone__c,
                                Phone = the_Account_ToBeUpdate.Phone,
                                spfy_customer_id__c = the_Account_ToBeUpdate.spfy_customer_id__c
                            ), 
                            theDmlOption
                        );
                    if( !theSaveResult_Update.isSuccess() ){
                        throw new Exceptions.AnException( 'Database.update(theAccount_Upd, theDmlOption); faield.' );
                    }
                }
            }

            Res theRes = new Res();
            theRes.AccountId = the_Account_Id_Resolved;
            return theRes;
        }
    }

    public static Boolean isMobileNo(String pTelNo){
        if( String.isBlank(pTelNo) ) return false;
        String theTelNo = pTelNo;
        theTelNo = TelNos.toNumber(theTelNo);
        return TelNos.isValidMobilePhoneNumber(theTelNo);
    }
}