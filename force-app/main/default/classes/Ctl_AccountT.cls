@isTest
private class Ctl_AccountT {

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
    private static void subscriveAccountBeforeInsert(){
        beginSetUp();
        List<Account> theAccounts = new List<Account>{
            new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                Name = '_',
                PersonBirthdate = Date.newInstance(2020,1,1),
                PersonDeathDate__pc = Date.newInstance(2020,1,1)
            )
        };
        endSetUp();

        Test.startTest();
        Ctl_Account.subscriveAccountBeforeInsert(theAccounts);
        Test.stopTest();
    }

    @isTest
    private static void subscriveAccountBeforeUpdate(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            'Customer' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
		INSERT theAccounts.values();
        endSetUp();

        Test.startTest();
        UPDATE New Account(
            Id = theAccounts.get('Customer').Id,
            PersonBirthdate = Date.newInstance(2020,1,1),
            PersonDeathDate__pc = Date.newInstance(2020,1,1)
        );
        Test.stopTest();
    }

    @isTest
    private static void searchForExistenceOfAccount(){
        beginSetUp();
        endSetUp();

        List<Case> theCases = new List<Case>{
            new Case(
                Firstname__c = '_',
                Lastname__c= '_',
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TelNo__c = '0'
            )
        };
        Test.startTest();
        new Ctl_Account().searchForExistenceOfAccount(theCases);
        Test.stopTest();
    }

    @isTest
    private static void searchForExistenceTaishoshaOfAccount(){
        
        beginSetUp();
        endSetUp();

        List<Case> cases = new List<Case>{
            new Case(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku'),
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TaishoshaSeiFurigana__c = 'ttest',
                TaishoshaMeiFurigana__c = 'test',
                TelNo__c = '0'
            )
        };
        Test.startTest();
        try {
            
            Ctl_Account ctl_Account = new Ctl_Account();
            ctl_Account.searchForExistenceTaishoshaOfAccount(cases);
        } catch (Exception ex) {
            System.debug(ex);
        }


        Test.stopTest();
    }
    
    @isTest
    private static void createFromCaseToAccount(){
        beginSetUp();
        endSetUp();

        List<Case> theCases = new List<Case>{
            new Case(
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TelNo__c = '0'
            )
        };
        Test.startTest();
        new Ctl_Account().createFromCaseToAccount(theCases);
        Test.stopTest();
    }

    @isTest
    private static void createFromTaishoshaToAccount(){
        
        beginSetUp();
        endSetUp();

        List<Case> cases = new List<Case>{
            new Case(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku'),
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TaishoshaSeiFurigana__c = 'ttest',
                TaishoshaMeiFurigana__c = 'test',
                TelNo__c = '0'
            )
        };
        Test.startTest();
		Ctl_Account ctl_Account = new Ctl_Account();
		ctl_Account.createFromTaishoshaToAccount(cases);
        Test.stopTest();
    }

    @isTest
    private static void checkDuplicateOfAccount(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客A' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '客A', LastName = '_', 
                MeiKana__c = '_', SeiKana__c = '_',
                Phone = '1', NayosePhone1__c = '1'
            )
        };
		INSERT theAccounts.values();

        List<Account> theAccountInfos = new List<Account>{
            new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '客A', LastName = '_', 
                MeiKana__c = '_', SeiKana__c = '_',
                Phone = '1'
            ),
            new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '客B', LastName = '_', 
                MeiKana__c = '_', SeiKana__c = '_',
                Phone = '2'
            )
        };
        endSetUp();

        Test.startTest();
        new Ctl_Account().checkDuplicateOfAccount(theAccountInfos);
        Test.stopTest();
    }

    @isTest
    private static void copyCaseAddressToAccountAddress(){
        
        
        beginSetUp();
        endSetUp();

        List<Case> cases = new List<Case>{
            new Case(
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TelNo__c = '0'
            )
        };
        Test.startTest();
		Ctl_Account ctl_Account = new Ctl_Account();
		ctl_Account.createFromTaishoshaToAccount(cases);
        Test.stopTest();
    }

    @isTest
    private static void associateTaishoshaWithAccount(){
        
        beginSetUp();
        endSetUp();

        List<Case> cases = new List<Case>{
            new Case(
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TelNo__c = '0'
            )
        };
        Test.startTest();
        Map<Integer,List<Id>> accountInsertResultMap = new Map<Integer,List<Id>>{
            0 => new List<Id>(),
            1 => new List<Id>()
        };
		Ctl_Account ctl_Account = new Ctl_Account();
		ctl_Account.associateTaishoshaWithAccount(cases, accountInsertResultMap);
        Test.stopTest();
    }
    
    @isTest
    private static void MemberTouroku_onCaseAfterInsert(){
        
        beginSetUp();
        endSetUp();

        List<Case> cases = new List<Case>{
            new Case(
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TelNo__c = '0'
            )
        };
        Test.startTest();
        Ctl_Account.MemberTouroku meberTouroku = new Ctl_Account.MemberTouroku();
        meberTouroku.onCaseAfterInsert(cases);
        Test.stopTest();
    }

    @isTest
    private static void MemberTouroku_onCaseAfterUpdate(){
        beginSetUp();
        endSetUp();

        List<Case> cases = new List<Case>{
            new Case(
                FirstNameKana__c = '_',
                LastNameKana__c = '_',
                TelNo__c = '0'
            )
        };
        Test.startTest();
        Ctl_Account.MemberTouroku meberTouroku = new Ctl_Account.MemberTouroku();
        Map<ID, Case> caseOldMap = new Map<ID, Case>{
            null => new Case()
        };
        meberTouroku.onCaseAfterUpdate(cases, caseOldMap);
        Test.stopTest();

    }

    @isTest
    private static void checkDuplicateAccountMerge(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '客' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT theAccounts.values();

        Map<String, WebAccountTourokuIrai__c> theWebAcIrais = new Map<String, WebAccountTourokuIrai__c>{
            'WebAccount登録依頼' =>
                new WebAccountTourokuIrai__c(
                    TorihikiSakiRef__c = theAccounts.get('客').Id
                )
        };
        INSERT theWebAcIrais.values();
        endSetUp();

        Test.startTest();
        List<Account> theArg = new List<Account>{
            new Account( Id = theAccounts.get('客').Id )
        };
        new Ctl_Account().checkDuplicateAccountMerge(theArg);
        Test.stopTest();
    }

    @isTest
    private static void copyContact_onAccountUpdated(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '僧侶' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'),
                Name = '_'
            )
        };
        INSERT theAccounts.values();
        endSetUp();

        Test.startTest();
        List<Account> theNewOnes = new List<Account>{
            new Account(
                Id = theAccounts.get('僧侶').Id,
                RecordTypeId = theAccounts.get('僧侶').RecordTypeId,
                Name = '_',
                LeadNumber__c = '_'
            )
        };
        Map<Id, Account> theOldOnes = new Map<Id, Account>{
            theAccounts.get('僧侶').Id => 
                new Account(
                    Id = theAccounts.get('僧侶').Id,
                    RecordTypeId = theAccounts.get('僧侶').RecordTypeId,
                    Name = '_',
                    LeadNumber__c = '_'
                )
        };

        new Ctl_Account().copyContact( theNewOnes, theOldOnes );
        Test.stopTest();
    }

    @isTest
    private static void copyContact_onAccountInserted(){
        beginSetUp();
        Map<String, Account> theAccounts = new Map<String, Account>{
            '僧侶' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','SoryoAccount'),
                Name = '_'
            )
        };
        INSERT theAccounts.values();
        endSetUp();

        Test.startTest();
        List<Account> theNewOnes = new List<Account>{
            new Account(
                Id = theAccounts.get('僧侶').Id,
                RecordTypeId = theAccounts.get('僧侶').RecordTypeId,
                Name = '_',
                LeadNumber__c = '_'
            )
        };
        Map<Id, Account> theOldOnes = null;

        new Ctl_Account().copyContact( theNewOnes, theOldOnes );
        Test.stopTest();
    }

    @isTest
    private static void changeKeiyakuName(){
        beginSetUp();
        List<Account> newAccountList = new List<Account>{
            new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                Name = '_',
                PersonBirthdate = Date.newInstance(2020,1,1),
                PersonDeathDate__pc = Date.newInstance(2020,1,1)
            )
        };
        endSetUp();

        Test.startTest();
		Map<ID,Account> oldAccountMap = new Map<ID,Account>();
		Ctl_Account ctl_Account = new Ctl_Account();
		ctl_Account.changeKeiyakuName(newAccountList,oldAccountMap);


        Test.stopTest();
    }

    @isTest
    private static void formatBillingPostalCode(){
        beginSetUp();
        List<Account> newAccountList = new List<Account>{
            new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                Name = '_',
                PersonBirthdate = Date.newInstance(2020,1,1),
                PersonDeathDate__pc = Date.newInstance(2020,1,1)
            )
        };
        endSetUp();

        Test.startTest();
		Map<ID,Account> oldAccountMap = new Map<ID,Account>();
		Ctl_Account.formatBillingPostalCode(newAccountList,oldAccountMap);


        Test.stopTest();

    }

    @isTest
    public static void equalStr(){
        new Ctl_Account().equalStr('a','b');
    }

    @isTest
    public static void convertToHankaku(){
        Ctl_Account.convertToHankaku('〒1410031');
    }
    @isTest
    public static void plusHihunPostalCode(){
        Ctl_Account.plusHihunPostalCode('1410031');
    }
}