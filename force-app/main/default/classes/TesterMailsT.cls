@isTest
private class TesterMailsT {

    @isTest
    static void test_honban_env() {
        String pMailAddress = 'test-yoriso-salesforce@yoriso.com.test';
        TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntriesStub(),
                                            new Environments.EnvStub().setIsSandBoxFalse());
        TesterMails.getInstance().raiseNotTesterExIfNotAllowed(pMailAddress);
        System.debug('honban ok');
    }

    @isTest
    static void test_honban_env_2() {
        String pMailAddress = 'test-yoriso-salesforce@yoriso.com.test';
        TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntriesStub().addEntry(pMailAddress),
                                            new Environments.EnvStub().setIsSandBoxFalse());
        TesterMails.getInstance().raiseNotTesterExIfNotAllowed(pMailAddress);
        System.debug('honban ok 2');
    }

    @isTest
    static void test_sandbox_env() {
        String pMailAddress = 'test-yoriso-salesforce@yoriso.com.test';
        TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntriesStub(),
                                            new Environments.EnvStub().setIsSandBoxTrue());
        try{
            TesterMails.getInstance().raiseNotTesterExIfNotAllowed(pMailAddress);
        } catch (Exception ex) {
            System.debug('Exception in sandbox');
            System.debug(ex);
        }
    }

    @isTest
    static void test_sandbox_env_ok() {
        String pMailAddress = 'test-yoriso-salesforce@yoriso.com.test';
        TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntriesStub().addEntry(pMailAddress),
                                            new Environments.EnvStub().setIsSandBoxTrue());
        TesterMails.getInstance().raiseNotTesterExIfNotAllowed(pMailAddress);
        System.debug('sandbox ok');
    }

    @isTest
    static void test_sandbox_env_use_mdt() {
        String pMailAddress = 'test-yoriso-salesforce@yoriso.com.test';
        TesterMails.f_instance = new TesterMails(new TesterMailEnts.TesterMailEntries(),
                                            new Environments.EnvStub().setIsSandBoxTrue());
        try{
            TesterMails.getInstance().raiseNotTesterExIfNotAllowed(pMailAddress);
        } catch (Exception ex) {
            System.debug('カスタムメータデータが見つかりません.');
            System.debug(ex);
        }
    }
}