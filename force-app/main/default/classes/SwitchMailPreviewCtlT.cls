@isTest
private class SwitchMailPreviewCtlT {
    
    @isTest static void testMethod_case1(){
        Test.startTest();

        Apexpages.currentPage().getParameters().put('template', '標準');
        Apexpages.currentPage().getParameters().put('atena', 'テスト');
        Apexpages.currentPage().getParameters().put('mailaddress', 'test@yoriso.com');
        Apexpages.currentPage().getParameters().put('pdfUrl', 'https://www.yoriso.com');
        Apexpages.currentPage().getParameters().put('passWord', 'test');

        SwitchMailPreviewCtl smp = new SwitchMailPreviewCtl();

        smp.init();
        
        Test.stopTest();
    }

    @isTest static void testMethod_case2(){
        Test.startTest();

        Apexpages.currentPage().getParameters().put('template', '施行可能葬儀社なし');
        Apexpages.currentPage().getParameters().put('atena', 'テスト');
        Apexpages.currentPage().getParameters().put('mailaddress', 'test@yoriso.com');
        Apexpages.currentPage().getParameters().put('kiboarea', '東京都品川区');

        SwitchMailPreviewCtl smp = new SwitchMailPreviewCtl();

        smp.init();
        
        Test.stopTest();
    }
}