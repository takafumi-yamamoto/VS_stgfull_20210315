@isTest
public class RsCoreApi_WebAccountClientT {

    @isTest
    static void testcase_one(){
        KaiinkibanSetting__c Kaiinkibandev = new KaiinkibanSetting__c(
            Name = 'dev',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibandev;

        KaiinkibanSetting__c Kaiinkibanprod = new KaiinkibanSetting__c(
            Name = 'prod',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibanprod;

        HttpResponse successRes = new HttpResponse();
        successRes.setStatusCode(200);
        successRes.setBody('OK');

        HttpResponse eroorRes = new HttpResponse();
        eroorRes.setStatusCode(500);
        eroorRes.setBody('NG');


        WebAccountTourokuIrai__c irai = new WebAccountTourokuIrai__c();
        irai.Context__c = 'simple_yasugo_siryoseikyu';
        irai.TourokuChi__c = 'test@test.com';
        irai.NinshoHouhou__c = 'メールアドレス';
        irai.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('New').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client = new RsCoreApi_WebAccountClient(irai);
        RsCoreApi_Util.doPut(client);

        WebAccountTourokuIrai__c irai2 = new WebAccountTourokuIrai__c();
        irai.Context__c = 'simple_yasugo_siryoseikyu';
        irai2.TourokuChi__c = '09011112222';
        irai2.NinshoHouhou__c = '電話番号';
        irai2.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('New').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client2 = new RsCoreApi_WebAccountClient(irai2);
        RsCoreApi_Util.doPut(client2);

        WebAccountTourokuIrai__c irai3 = new WebAccountTourokuIrai__c();
        irai3.Context__c = 'simple_yasugo_endingnote';
        irai3.TourokuChi__c = 'test@test.com';
        irai3.NinshoHouhou__c = 'メールアドレス';
        irai3.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('New').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client3 = new RsCoreApi_WebAccountClient(irai3);
        RsCoreApi_Util.doPut(client3);

        WebAccountTourokuIrai__c irai4 = new WebAccountTourokuIrai__c();
        irai4.Context__c = 'jizenwari_moushikomi';
        irai4.TourokuChi__c = 'test@test.com';
        irai4.NinshoHouhou__c = 'メールアドレス';
        irai4.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('New').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client4 = new RsCoreApi_WebAccountClient(irai4);
        RsCoreApi_Util.doPut(client4);
        
        WebAccountTourokuIrai__c irai5 = new WebAccountTourokuIrai__c();
        irai5.Context__c = 'ososhiki_yoyaku_siryoseikyu';
        irai5.TourokuChi__c = 'test@test.com';
        irai5.NinshoHouhou__c = 'メールアドレス';
        irai5.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('New').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client5 = new RsCoreApi_WebAccountClient(irai5);
        RsCoreApi_Util.doPut(client5);

        WebAccountTourokuIrai__c irai6 = new WebAccountTourokuIrai__c();
        irai6.Context__c = 'ohanaippainoososhiki_shiryoseikyu';
        irai6.TourokuChi__c = 'test@test.com';
        irai6.NinshoHouhou__c = 'メールアドレス';
        irai6.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('New').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client6 = new RsCoreApi_WebAccountClient(irai6);
        RsCoreApi_Util.doPut(client6);
        client6.isSuccess(successRes);
        client6.doOnSuccess(successRes);
        client6.doOnError(eroorRes);
    }

    @isTest
    static void testcase_two(){
        KaiinkibanSetting__c Kaiinkibandev = new KaiinkibanSetting__c(
            Name = 'dev',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibandev;

        KaiinkibanSetting__c Kaiinkibanprod = new KaiinkibanSetting__c(
            Name = 'prod',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibanprod;
        WebAccountTourokuIrai__c irai = new WebAccountTourokuIrai__c();
        irai.Context__c = null;
        irai.TourokuChi__c = 'test@test.com';
        irai.NinshoHouhou__c = 'メールアドレス';
        irai.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('Modify').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client = new RsCoreApi_WebAccountClient(irai);
        RsCoreApi_Util.doPut(client);
    }
    @isTest
    static void testcase_three(){
        KaiinkibanSetting__c Kaiinkibandev = new KaiinkibanSetting__c(
            Name = 'dev',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibandev;

        KaiinkibanSetting__c Kaiinkibanprod = new KaiinkibanSetting__c(
            Name = 'prod',
            client_id__c = '5',
            client_secret__c = 'EwbX0FwZGwnOHuvjty9PvjVIxbbNGeLDpeEqnmPh',
            grant_type__c = 'client_credentials',
            timeOutPeriod__c = 60000,
            Endpoint__c = 'https://dev-rakuso-core-api-external.minrevi.jp',
            KeiyakuCoreFlag__c = TRUE,
            IsShisetsuRenkeiYuko__c= TRUE,
            isActive__c= TRUE
        );
        insert Kaiinkibanprod;
        WebAccountTourokuIrai__c irai = new WebAccountTourokuIrai__c();
        irai.Context__c = 'simple_yasugo_siryoseikyu';
        irai.TourokuChi__c = 'test@test.com';
        irai.NinshoHouhou__c = 'メールアドレス';
        irai.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('Remove').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client = new RsCoreApi_WebAccountClient(irai);
        RsCoreApi_Util.doPatch(client);

        WebAccountTourokuIrai__c irai2 = new WebAccountTourokuIrai__c();
        irai2.Context__c = 'simple_yasugo_endingnote';
        irai2.TourokuChi__c = 'test@test.com';
        irai2.NinshoHouhou__c = 'メールアドレス';
        irai2.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('Remove').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client2 = new RsCoreApi_WebAccountClient(irai2);
        RsCoreApi_Util.doPatch(client2);

        WebAccountTourokuIrai__c irai3 = new WebAccountTourokuIrai__c();
        irai3.Context__c = 'simple_yasugo_endingnote';
        irai3.TourokuChi__c = 'test@test.com';
        irai3.NinshoHouhou__c = 'メールアドレス';
        irai3.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('Remove').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client3 = new RsCoreApi_WebAccountClient(irai3);
        RsCoreApi_Util.doPatch(client3);

        WebAccountTourokuIrai__c irai4 = new WebAccountTourokuIrai__c();
        irai4.Context__c = null;
        irai4.TourokuChi__c = 'test@test.com';
        irai4.NinshoHouhou__c = 'メールアドレス';
        irai4.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('Remove').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client4 = new RsCoreApi_WebAccountClient(irai4);
        RsCoreApi_Util.doPatch(client4);

        WebAccountTourokuIrai__c irai5 = new WebAccountTourokuIrai__c();
        irai5.Context__c = 'jizenwari_moushikomi';
        irai5.TourokuChi__c = 'test@test.com';
        irai5.NinshoHouhou__c = 'メールアドレス';
        irai5.RecordTypeId = Schema.SObjectType.WebAccountTourokuIrai__c.getRecordTypeInfosByDeveloperName().get('Remove').getRecordTypeId();

        RsCoreApi_Util.IHttpRequest client5 = new RsCoreApi_WebAccountClient(irai5);
        RsCoreApi_Util.doPatch(client5);
        HttpResponse successRes = new HttpResponse();
        successRes.setStatusCode(200);
        successRes.setBody('OK');

        HttpResponse eroorRes = new HttpResponse();
        eroorRes.setStatusCode(500);
        eroorRes.setBody('NG');
        client5.doOnSuccess(successRes);
    }
    @isTest
    static void testcase_four(){


    }

}