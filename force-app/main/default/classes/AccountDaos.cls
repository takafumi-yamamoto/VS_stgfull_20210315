public class AccountDaos
{
    public static IAccountDao GetInstance(){
        return new AccountDao();
    }

    private static Account f_DefaultAccount = null;

    public interface IAccountDao{
        Account SelectById(Id id);
        Map<Id,Account> SelectByIdsAsMapById(List<Id> ids);
        Account GetDefualtAccount();
    }
    public class AccountDao Implements IAccountDao{

        private AccountDao(){}

        private String getQueryBody(){
            return 'SELECT Id, Name, LastName, FirstName, NameFurigana__c,'
                + 'BillingPostalCode, BillingState, BillingCity, BillingStreet, MailAddress__c, '
                + 'YusenFaxFormula__c, YusenMailAddressFormula__c From Account WHERE Id != null ';
        }

        public Account SelectById(Id id){
            List<Account> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }

        private List<Account> SelectByIds(List<Id> ids){
            List<Account> theEntities = Database.query(getQueryBody() + 'AND Id IN :ids');
            return theEntities;
        }

        public Map<Id,Account> SelectByIdsAsMapById(List<Id> ids){
            Map<Id,Account> theMap = new Map<Id,Account>();
            List<Account> theEntities = this.SelectByIds(ids);
            return AccountLinqs.ListToMapById(theEntities);
        }

        public Account GetDefualtAccount(){
            if(AccountDaos.f_DefaultAccount == null){
                String theRecTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account', 'null');
                AccountDaos.f_DefaultAccount = [select id, name, recordtype.name from account where recordtypeId = :theRecTypeId limit 1];
            }
            return AccountDaos.f_DefaultAccount;
        }
    }
}