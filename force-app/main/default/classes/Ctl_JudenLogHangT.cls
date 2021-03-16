@isTest
public class Ctl_JudenLogHangT {
    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}
    @isTest
    public static void phoneNumerBinding(){
        beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            'Cust_A' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = 'Cust_A', LastName = '_',
                MobilePhone__c = '08099999999'
            ),
            'Cust_B' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = 'Cust_B', LastName = '_',
                MobilePhone__c = '08099999999'
            )
        };
        INSERT theAccounts.values();

        Lead aLead_Biztel = new Lead(LastName = 'Bizel');
        INSERT aLead_Biztel;
        Ctl_JudenLogHang.SysBiztelLeadData_for_test = aLead_Biztel.Id;
        endSetUp();

        Test.startTest();
        Task aTask = new Task(WhoId = aLead_Biztel.Id, B_PhoneFrom__c = '08099999999');
        new Ctl_JudenLogHang().phoneNumerBinding(new List<Task>{aTask});
        Test.stopTest();
    }

    @isTest
    public static void todoHang(){
        beginSetUp();

        Map<String, Account> theAccounts = new Map<String, Account>{
            'Cust_A' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = 'Cust_A', LastName = '_',
                MobilePhone__c = '08099999999'
            )
        };
        INSERT theAccounts.values();
        endSetUp();

        Test.startTest();
        new Ctl_JudenLogHang().todoHang(
            new List<Account>{
                theAccounts.get('Cust_A')
            },
            new Map<Id,Account>{
                theAccounts.get('Cust_A').Id => theAccounts.get('Cust_A')
            }
        );
        Test.stopTest();

    }
}