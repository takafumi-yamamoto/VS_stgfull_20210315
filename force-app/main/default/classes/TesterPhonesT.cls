@isTest
private class TesterPhonesT {

    @isTest
    static void test_honban_env() {
        String pPhoneAddress = '088-1010-1234';
        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntriesStub(),
                                            new Environments.EnvStub().setIsSandBoxFalse());
        TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(pPhoneAddress);
        System.debug('honban ok');
    }

    @isTest
    static void test_honban_env_2() {
        String pPhoneAddress = '088-1010-1234';
        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntriesStub().addEntry(pPhoneAddress),
                                            new Environments.EnvStub().setIsSandBoxFalse());
        TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(pPhoneAddress);
        System.debug('honban ok 2');
    }

    @isTest
    static void test_sandbox_env() {
        String pPhoneAddress = '088-1010-1234';
        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntriesStub(),
                                            new Environments.EnvStub().setIsSandBoxTrue());
        try{
            TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(pPhoneAddress);
        } catch (Exception ex) {
            System.debug('Exception in sandbox');
            System.debug(ex);
        }
    }

    @isTest
    static void test_sandbox_env_ok() {
        String pPhoneAddress = '088-1010-1234';
        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntriesStub().addEntry(pPhoneAddress),
                                            new Environments.EnvStub().setIsSandBoxTrue());
        TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(pPhoneAddress);
        System.debug('sandbox ok');
    }

    @isTest
    static void test_sandbox_env_use_mdt() {
        String pPhoneAddress = '088-1010-1234';
        TesterPhones.f_instance = new TesterPhones(new TesterPhoneEnts.TesterPhoneEntries(),
                                            new Environments.EnvStub().setIsSandBoxTrue());
        try{
            TesterPhones.getInstance().raiseNotTesterExIfNotAllowed(pPhoneAddress);
        } catch (Exception ex) {
            System.debug('カスタムメータデータが見つかりません.');
            System.debug(ex);
        }
    }
}