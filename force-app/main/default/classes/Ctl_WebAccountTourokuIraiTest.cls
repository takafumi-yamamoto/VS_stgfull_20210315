@isTest
private class Ctl_WebAccountTourokuIraiTest {

    /**
     * This is a test method for WebAccountTouroku
     */
    static testMethod void test_WebAccountTouroku() {

        // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者セカンド', LastName = '_',
                            MobilePhone__c='09098760129',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-3@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        WebAccountTourokuIrai__c webAccountTourokuIrai = new WebAccountTourokuIrai__c();
        webAccountTourokuIrai.ShoriStatus__c = 'Processing_Created';
        webAccountTourokuIrai.TorihikiSakiRef__c = lsracc.getId();
        webAccountTourokuIrai.TourokuChi__c = 'hironori-takechi+2020-09-17-3@yoriso.com';
        webAccountTourokuIrai.RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('WebAccountTourokuIrai__c','Modify');
        insert webAccountTourokuIrai;
        List<WebAccountTourokuIrai__c> newList = [SELECT Id,Name,ShoriStatus__c,TorihikiSakiRef__c,NinshoHouhou__c,RecordTypeId,TourokuChi__c,ShoriStatusBiko__c FROM WebAccountTourokuIrai__c WHERE Id = :webAccountTourokuIrai.Id];

    	new Ctl_WebAccountTourokuIrai.WebAccountTourokuIraiValidate().onWebAccountTourokuIraiBeforeInsert(newList);

        Test.stopTest();
    }

    static testMethod void test_WebAccountTourokuNew() {

        // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
        // Test.setCurrentPage(pageRef);
        // pageRef.getParameters().put('param1', 'param1');

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者セカンド', LastName = '_',
                            MobilePhone__c='09098760129',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-3@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        WebAccountTourokuIrai__c webAccountTourokuIrai = new WebAccountTourokuIrai__c();
        webAccountTourokuIrai.ShoriStatus__c = 'Processing_Created';
        webAccountTourokuIrai.TorihikiSakiRef__c = lsracc.getId();
        webAccountTourokuIrai.TourokuChi__c = 'hironori-takechi+2020-09-17-3@yoriso.com';
        webAccountTourokuIrai.RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('WebAccountTourokuIrai__c','New');
        insert webAccountTourokuIrai;
        List<WebAccountTourokuIrai__c> newList = [SELECT Id,Name,ShoriStatus__c,TorihikiSakiRef__c,NinshoHouhou__c,RecordTypeId,TourokuChi__c,ShoriStatusBiko__c FROM WebAccountTourokuIrai__c WHERE Id = :webAccountTourokuIrai.Id];

    	new Ctl_WebAccountTourokuIrai.WebAccountTourokuIraiValidate().onWebAccountTourokuIraiBeforeInsert(newList);

        Test.stopTest();
    }

    static testMethod void test_onWebAccountTourokuIraiBeforeUpdate() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者セカンド', LastName = '_',
                            MobilePhone__c='09098760129',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-3@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        WebAccountTourokuIrai__c webAccountTourokuIrai = new WebAccountTourokuIrai__c();
        webAccountTourokuIrai.ShoriStatus__c = 'Processing_WebAccountProcessed';
        webAccountTourokuIrai.TorihikiSakiRef__c = lsracc.getId();
        webAccountTourokuIrai.TourokuChi__c = 'hironori-takechi+2020-09-17-3@yoriso.com';
        webAccountTourokuIrai.RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('WebAccountTourokuIrai__c','Remove');
        insert webAccountTourokuIrai;
        List<WebAccountTourokuIrai__c> newList = [SELECT Id,Name,ShoriStatus__c,TorihikiSakiRef__c,NinshoHouhou__c,RecordTypeId,TourokuChi__c FROM WebAccountTourokuIrai__c WHERE Id = :webAccountTourokuIrai.Id];
        WebAccount__c sWebAccountj = new WebAccount__c(
            TourokuChi__c = 'hironori-takechi+2020-09-17-3@yoriso.com',
            NinshoHouhou__c = 'メールアドレス',
            TorihikiSakiRef__c = lsracc.getId()
        );
        insert sWebAccountj;
    	new Ctl_WebAccountTourokuIrai.WebAccountCompleting().onWebAccountTourokuIraiBeforeUpdate(newList);

        Test.stopTest();
    }

    static testMethod void test_onWebAccountTourokuIraiAfterInsert() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者セカンド', LastName = '_',
                            MobilePhone__c='09098760129',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-3@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        WebAccountTourokuIrai__c webAccountTourokuIrai = new WebAccountTourokuIrai__c();
        webAccountTourokuIrai.ShoriStatus__c = 'Processing_Validated';
        webAccountTourokuIrai.TorihikiSakiRef__c = lsracc.getId();
        insert webAccountTourokuIrai;
        List<WebAccountTourokuIrai__c> newList = [SELECT Id,Name,ShoriStatus__c,TorihikiSakiRef__c FROM WebAccountTourokuIrai__c WHERE Id = :webAccountTourokuIrai.Id];
        System.debug('--newList--' + newList.size());

    		new Ctl_WebAccountTourokuIrai.SendingTourokuRequstToKaiinKiban().onWebAccountTourokuIraiAfterInsert(newList);

        Test.stopTest();
    }

    static testMethod void test_onCaseAfterInsert() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者', LastName = '_',
                            MobilePhone__c='09001201234',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        Case aCase = new Case(
                            AccountId = lsracc.getId(),
                            WebAccountKibo__c = '希望する',
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm')
                            );
        Database.SaveResult lsrCase = Database.insert(aCase);

        List<Case> newCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId FROM Case WHERE Id = :lsrCase.getId()];

        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterInsert(newCases);

        Test.stopTest();
    }

    static testMethod void test_SimpleYasugoShiryoSeikyuWebFormGoka() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者', LastName = '_',
                            MobilePhone__c='09001201234',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        Case aCase = new Case(
                            AccountId = lsracc.getId(),
                            WebAccountKibo__c = '希望する',
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            FormType__c = '安くて豪華なお葬式',
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm')
                            );
        Database.SaveResult lsrCase = Database.insert(aCase);

        List<Case> newCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId,FormType__c FROM Case WHERE Id = :lsrCase.getId()];

        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterInsert(newCases);

        Test.stopTest();
    }

    static testMethod void test_SimpleYasugoShiryoSeikyuWebForm() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者', LastName = '_',
                            MobilePhone__c='09001201234',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        Case aCase = new Case(
                            AccountId = lsracc.getId(),
                            WebAccountKibo__c = '希望する',
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoShiryoSeikyuWebForm')
                            );
        Database.SaveResult lsrCase = Database.insert(aCase);

        List<Case> newCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId,FormType__c FROM Case WHERE Id = :lsrCase.getId()];

        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterInsert(newCases);

        Test.stopTest();
    }

    static testMethod void test_JizenwariWebMoshikomi() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者', LastName = '_',
                            MobilePhone__c='09001201234',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        Case aCase = new Case(
                            AccountId = lsracc.getId(),
                            WebAccountKibo__c = '希望する',
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','JizenwariWebMoshikomi')
                            );
        Database.SaveResult lsrCase = Database.insert(aCase);

        List<Case> newCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId,FormType__c FROM Case WHERE Id = :lsrCase.getId()];

        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterInsert(newCases);

        Test.stopTest();
    }

    static testMethod void test_SimpleYasugoEndingnoteWebForm() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者', LastName = '_',
                            MobilePhone__c='09001201234',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        Case aCase = new Case(
                            AccountId = lsracc.getId(),
                            WebAccountKibo__c = '希望する',
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoEndingnoteWebForm')
                            );
        Database.SaveResult lsrCase = Database.insert(aCase);

        List<Case> newCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId,FormType__c FROM Case WHERE Id = :lsrCase.getId()];

        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterInsert(newCases);

        Test.stopTest();
    }

    static testMethod void test_OsoshikiYoyaku_SiryoSeikyu_Web() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者', LastName = '_',
                            MobilePhone__c='09001201234',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        Case aCase = new Case(
                            AccountId = lsracc.getId(),
                            WebAccountKibo__c = '希望する',
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','OsoshikiYoyaku_SiryoSeikyu_Web')
                            );
        Database.SaveResult lsrCase = Database.insert(aCase);

        List<Case> newCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId,FormType__c FROM Case WHERE Id = :lsrCase.getId()];

        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterInsert(newCases);

        Test.stopTest();
    }

    static testMethod void test_onCaseAfterUpdate() {

        Test.startTest();

        Account a = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者', LastName = '_',
                            MobilePhone__c='09001201234',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc = Database.insert(a);

        Account a2 = new Account(
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                            FirstName = '相談者セカンド', LastName = '_',
                            MobilePhone__c='09098760129',
                            MemberTourokuZumi__c = true,
                            MailAddress__c = 'hironori-takechi+2020-09-17-3@yoriso.com',
                            JizenJizenSheetTeishutsuzumi__c = true
                          );
        Database.SaveResult lsracc2 = Database.insert(a2);

        Case aCase = new Case(
                            AccountId = lsracc.getId(),
                            WebAccountKibo__c = '希望する',
                            MailAddress__c = 'hironori-takechi+2020-09-17-2@yoriso.com',
                            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','SimpleYasugoOtoiawaseWebForm')
                            );
        Database.SaveResult lsrCase = Database.insert(aCase);

        List<Case> oldCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId FROM Case WHERE Id = :lsrCase.getId()];
        List<Case> newCases = new List<Case>();
		Map<ID, Case> oldmapCases = new Map<ID, Case>();
        for(Case c1 :oldCases){
        	oldmapCases.put(c1.id,c1);
		}
        for(Case c2 :oldCases){
        	c2.AccountId = lsracc2.getId();
        	newCases.add(c2);
        }
        List<Database.SaveResult> lsrCase2 = Database.update(newCases);
        List<Case> listnewCases = [SELECT Id,AccountId,WebAccountKibo__c,MailAddress__c,RecordTypeId FROM Case WHERE Id = :lsrCase.getId()];
        
        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterUpdate(listnewCases,oldmapCases);

        Test.stopTest();

        // Check
        // System.assert(ApexPages.hasMessages());
        // for(ApexPages.Message msg : ApexPages.getMessages()) {
        //     System.assertEquals('Upload file is NULL', msg.getSummary());
        //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        // }
    }


  //  /**
  //   * This is a test method for WebAccountTourokuIraiJob
  //   */
  //  static testMethod void test_WebAccountTourokuIraiJob() {

  //      // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
  //      // Test.setCurrentPage(pageRef);
  //      // pageRef.getParameters().put('param1', 'param1');

  //      Test.startTest();

		//List<WebAccountTourokuIrai__c> webAccountTourokuIraiList = null;
		//Ctl_WebAccountTourokuIrai ctl_WebAccountTourokuIrai = new Ctl_WebAccountTourokuIrai();
		//public resultWebAccountTourokuIraiJob = ctl_WebAccountTourokuIrai.WebAccountTourokuIraiJob(webAccountTourokuIraiList);


  //      Test.stopTest();

  //      // Check
  //      // System.assert(ApexPages.hasMessages());
  //      // for(ApexPages.Message msg : ApexPages.getMessages()) {
  //      //     System.assertEquals('Upload file is NULL', msg.getSummary());
  //      //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
  //      // }
  //  }


  //  /**
  //   * This is a test method for execute
  //   */
  //  static testMethod void test_execute() {

  //      // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
  //      // Test.setCurrentPage(pageRef);
  //      // pageRef.getParameters().put('param1', 'param1');

  //      Test.startTest();

		//QueueableContext context = null;
		//Ctl_WebAccountTourokuIrai ctl_WebAccountTourokuIrai = new Ctl_WebAccountTourokuIrai();
		//ctl_WebAccountTourokuIrai.execute(context);


  //      Test.stopTest();

  //      // Check
  //      // System.assert(ApexPages.hasMessages());
  //      // for(ApexPages.Message msg : ApexPages.getMessages()) {
  //      //     System.assertEquals('Upload file is NULL', msg.getSummary());
  //      //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
  //      // }
  //  }


  //  /**
  //   * This is a test method for WebAccountTourokuIraiValidate
  //   */
  //  static testMethod void test_WebAccountTourokuIraiValidate() {

  //      // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
  //      // Test.setCurrentPage(pageRef);
  //      // pageRef.getParameters().put('param1', 'param1');

  //      Test.startTest();

		//List<WebAccountTourokuIrai__c> webAccountTourokuIraiList = null;
		//Ctl_WebAccountTourokuIrai ctl_WebAccountTourokuIrai = new Ctl_WebAccountTourokuIrai();
		//public resultWebAccountTourokuIraiValidate = ctl_WebAccountTourokuIrai.WebAccountTourokuIraiValidate(webAccountTourokuIraiList);


  //      Test.stopTest();

  //      // Check
  //      // System.assert(ApexPages.hasMessages());
  //      // for(ApexPages.Message msg : ApexPages.getMessages()) {
  //      //     System.assertEquals('Upload file is NULL', msg.getSummary());
  //      //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
  //      // }
  //  }


  //  /**
  //   * This is a test method for validate
  //   */
  //  static testMethod void test_validate() {

  //      // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
  //      // Test.setCurrentPage(pageRef);
  //      // pageRef.getParameters().put('param1', 'param1');

  //      Test.startTest();

		//Ctl_WebAccountTourokuIrai ctl_WebAccountTourokuIrai = new Ctl_WebAccountTourokuIrai();
		//ctl_WebAccountTourokuIrai.validate();


  //      Test.stopTest();

  //      // Check
  //      // System.assert(ApexPages.hasMessages());
  //      // for(ApexPages.Message msg : ApexPages.getMessages()) {
  //      //     System.assertEquals('Upload file is NULL', msg.getSummary());
  //      //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
  //      // }
  //  }


  //  /**
  //   * This is a test method for checkExistWebAccount
  //   */
  //  static testMethod void test_checkExistWebAccount() {

  //      // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
  //      // Test.setCurrentPage(pageRef);
  //      // pageRef.getParameters().put('param1', 'param1');

  //      Test.startTest();

		//List<String> accountIds = null;
		//List<WebAccountTourokuIrai__c> validateWebAccountTourokuIraiNewList = null;
		//Ctl_WebAccountTourokuIrai ctl_WebAccountTourokuIrai = new Ctl_WebAccountTourokuIrai();
		//ctl_WebAccountTourokuIrai.checkExistWebAccount(accountIds,validateWebAccountTourokuIraiNewList);


  //      Test.stopTest();

  //      // Check
  //      // System.assert(ApexPages.hasMessages());
  //      // for(ApexPages.Message msg : ApexPages.getMessages()) {
  //      //     System.assertEquals('Upload file is NULL', msg.getSummary());
  //      //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
  //      // }
  //  }


  //  /**
  //   * This is a test method for checkDuplicate
  //   */
  //  static testMethod void test_checkDuplicate() {

  //      // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
  //      // Test.setCurrentPage(pageRef);
  //      // pageRef.getParameters().put('param1', 'param1');

  //      Test.startTest();

		//List<String> emails = null;
		//List<WebAccountTourokuIrai__c> validateWebAccountTourokuIraiList = null;
		//Ctl_WebAccountTourokuIrai ctl_WebAccountTourokuIrai = new Ctl_WebAccountTourokuIrai();
		//ctl_WebAccountTourokuIrai.checkDuplicate(emails,validateWebAccountTourokuIraiList);


  //      Test.stopTest();

  //      // Check
  //      // System.assert(ApexPages.hasMessages());
  //      // for(ApexPages.Message msg : ApexPages.getMessages()) {
  //      //     System.assertEquals('Upload file is NULL', msg.getSummary());
  //      //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
  //      // }
  //  }


  //  /**
  //   * This is a test method for checkTourokuChi
  //   */
  //  static testMethod void test_checkTourokuChi() {

  //      // PageReference pageRef = Page.Ctl_WebAccountTourokuIrai;
  //      // Test.setCurrentPage(pageRef);
  //      // pageRef.getParameters().put('param1', 'param1');

  //      Test.startTest();

		//WebAccountTourokuIrai__c irai = null;
		//Ctl_WebAccountTourokuIrai ctl_WebAccountTourokuIrai = new Ctl_WebAccountTourokuIrai();
		//Boolean resultCheckTourokuChi = ctl_WebAccountTourokuIrai.checkTourokuChi(irai);


  //      Test.stopTest();

  //      // Check
  //      // System.assert(ApexPages.hasMessages());
  //      // for(ApexPages.Message msg : ApexPages.getMessages()) {
  //      //     System.assertEquals('Upload file is NULL', msg.getSummary());
  //      //     System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
  //      // }
  //  }


}