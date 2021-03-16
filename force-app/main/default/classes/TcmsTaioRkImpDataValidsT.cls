@isTest
public class TcmsTaioRkImpDataValidsT {

    private class IValidator_Stub implements TcmsTaioRkImpDataValids.IValidator{
        public TcmsTaioRkImpDataValids.Result validate(TcmsTaioRkImpData__c aImpData){

            TcmsTaioRkImpDataValids.Result the_Result = new TcmsTaioRkImpDataValids.Result();
            the_Result.erros.add(
                new TcmsTaioRkImpDataValids.ErrEntry()
                    .set_field_name('_')
                    .set_imput_value('_')
                    .set_descr('_')
            );

            return the_Result;
        }
    }
    @isTest public static void Validator_validate(){

        TcmsTaioRkImpData__c the_TcmsTaioRkImpData = new TcmsTaioRkImpData__c(
            ToiawaseDt__c = 'x',
            Sodansha_Sei_Kana__c = null,
            SiryoKibo__c = 'x',
            SmsPermission__c = 'x',
            TaishoshaUmu__c = 'x',
            Taishosha_Joutai__c = 'x',
            SogiType1__c = 'x',
            SogiType2__c  = 'x',
            SoryoTehaiUmu__c = 'x',
            BodaijiUmu__c = 'x',
            AnchiSaki__c = 'x',
            Taishosha_Zokugara_From_Sodansha__c = 'x',
            Taishosha_Yomei__c = 'x',
            Taishosha_KyojuKeitai__c = 'x',
            Kanryo_Shubetsu__c = 'x',
            ShiryoHassoDate__c = 'x'
        );

        Test.startTest();
        new TcmsTaioRkImpDataValids.Validator(
            new TcmsTaioRkImpDataValids.Datetime_Validator(),
            new TcmsTaioRkImpDataValids.Date_Validator()
        ).validate(the_TcmsTaioRkImpData);
        Test.stopTest();

    }

    @isTest public static void ValidationOnBefore_validate(){

        Test.startTest();
        new TcmsTaioRkImpDataValids.ValidationOnBefore( new IValidator_Stub() ).validate( new TcmsTaioRkImpData__c() );
        Test.stopTest();

    }
}