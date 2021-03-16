@isTest
private class OboDashinResTaskFlbT {

    @isTest
    static void myUnitTest_null() {
        new OboDashinResTaskFlb().execute(null);
    }

    @isTest
    static void myUnitTest() {
        String theNextTimeCron = DateTime.now().addSeconds(3).format('s m H d M ? y');
        System.schedule('OboDashinResTaskFlb-お坊さん便/打診結果取込TaskFlb' + '(' + theNextTimeCron + ')', theNextTimeCron, new OboDashinResTaskFlb() );
    }
}