public class TcmsTaioRkImpDataValids {

    public static IValidationOnBefore get_ValidationOnBefore_instance(){
        return new ValidationOnBefore(
            new Validator(
                new Datetime_Validator(),
                new Date_Validator()
            )
        );
    }
    
    public class Result{
        public List<ErrEntry> erros = new List<ErrEntry>();
    }
    public class ErrEntry{
        public String field_name = '';
        public ErrEntry set_field_name(String pValue){ this.field_name = pValue; return this; }
        public String imput_value = '';
        public ErrEntry set_imput_value(String pValue){ this.imput_value = pValue; return this; }
        public String descr = '';
        public ErrEntry set_descr(String pValue){ this.descr = pValue; return this; }
        
    }

    public interface IValidator {
        Result validate(TcmsTaioRkImpData__c aImpData);
    }

    @TestVisible
    private class Validator implements IValidator{

        private IDatetime_Validator mDatetime_Validator = null;
        private IDate_Validator mDate_Validator = null;

        public Validator(IDatetime_Validator pDatetime_Validator, IDate_Validator pDate_Validator ){
            this.mDatetime_Validator = pDatetime_Validator;
            this.mDate_Validator = pDate_Validator;
        }

        public Result validate(TcmsTaioRkImpData__c aImpData){

            Result the_result = new Result();

            { //問合せ日時
                if( !this.mDatetime_Validator.isValid( aImpData.ToiawaseDt__c ) ){
                    the_result.erros.add(
                        new ErrEntry()
                        .set_field_name('問合せ日時')
                        .set_imput_value(aImpData.ToiawaseDt__c)
                        .set_descr('フォーマット不正')
                    );
                }
            }

            { //姓（フリガナ）
                if( String.isBlank(aImpData.Sodansha_Sei_Kana__c) ){
                    the_result.erros.add(
                        new ErrEntry()
                        .set_field_name('姓（フリガナ）')
                        .set_imput_value(aImpData.Sodansha_Sei_Kana__c)
                        .set_descr('必須')
                    );
                }
            }
            
            { //資料発送希望
                List<String> the_options = new List<String>{
                    'はい',
                    'いいえ'
                };
                if( !String.isBlank(aImpData.SiryoKibo__c) && !the_options.contains(aImpData.SiryoKibo__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('資料発送希望')
                    .set_imput_value(aImpData.SiryoKibo__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //SMSパーミッション取得
                List<String> the_options = new List<String>{
                    'OK',
                    'NG'
                };
                if( !String.isBlank(aImpData.SmsPermission__c) && !the_options.contains(aImpData.SmsPermission__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('SMSパーミッション取得')
                    .set_imput_value(aImpData.SmsPermission__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //対象者有無
                List<String> the_options = new List<String>{
                    '有',
                    '無'
                };
                if( !String.isBlank(aImpData.TaishoshaUmu__c) && !the_options.contains(aImpData.TaishoshaUmu__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('対象者有無')
                    .set_imput_value(aImpData.TaishoshaUmu__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //対象者のご状態
                List<String> the_options = new List<String>{
                    '死亡',
                    '危篤',
                    '余命宣告',
                    '高齢終末期',
                    '闘病中（重度）',
                    '闘病中（軽度）',
                    '闘病中（度合不明）',
                    '健在'
                };
                if( !String.isBlank(aImpData.Taishosha_Joutai__c) && !the_options.contains(aImpData.Taishosha_Joutai__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('対象者のご状態')
                    .set_imput_value(aImpData.Taishosha_Joutai__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //葬儀形式1
                List<String> the_options = new List<String>{
                    '直葬',
                    '火葬式',
                    '一日葬',
                    '家族葬',
                    '一般葬'
                };
                if( !String.isBlank(aImpData.SogiType1__c) && !the_options.contains(aImpData.SogiType1__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('葬儀形式1')
                    .set_imput_value(aImpData.SogiType1__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //葬儀形式2
                List<String> the_options = new List<String>{
                    '無宗教',
                    '仏式'
                };
                if( !String.isBlank(aImpData.SogiType2__c) && !the_options.contains(aImpData.SogiType2__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('葬儀形式2')
                    .set_imput_value(aImpData.SogiType2__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //僧侶手配有無
                List<String> the_options = new List<String>{
                    '有',
                    '無',
                    'ご検討中'
                };
                if( !String.isBlank(aImpData.SoryoTehaiUmu__c) && !the_options.contains(aImpData.SoryoTehaiUmu__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('僧侶手配有無')
                    .set_imput_value(aImpData.SoryoTehaiUmu__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //菩提寺有無
                List<String> the_options = new List<String>{
                    '有',
                    '無'
                };
                if( !String.isBlank(aImpData.BodaijiUmu__c) && !the_options.contains(aImpData.BodaijiUmu__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('菩提寺有無')
                    .set_imput_value(aImpData.BodaijiUmu__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //安置先
                List<String> the_options = new List<String>{
                    '預かり安置',
                    '付き添い安置',
                    '自宅',
                    'その他'
                };
                if( !String.isBlank(aImpData.AnchiSaki__c) && !the_options.contains(aImpData.AnchiSaki__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('安置先')
                    .set_imput_value(aImpData.AnchiSaki__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //続柄
                List<String> the_options = new List<String>{
                    '夫',
                    '妻',
                    '父',
                    '母',
                    '祖父',
                    '祖母',
                    '兄',
                    '弟',
                    '姉',
                    '妹',
                    'ご本人',
                    '知人',
                    '親戚',
                    '義父',
                    '義母',
                    '義兄',
                    '義弟',
                    '義姉',
                    '義妹',
                    '息子',
                    '娘',
                    '叔父',
                    '叔母',
                    'いとこ',
                    '孫',
                    '甥',
                    '姪',
                    '介護関係者',
                    'その他'
                };
                if( !String.isBlank(aImpData.Taishosha_Zokugara_From_Sodansha__c) && !the_options.contains(aImpData.Taishosha_Zokugara_From_Sodansha__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('続柄')
                    .set_imput_value(aImpData.Taishosha_Zokugara_From_Sodansha__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //対象者の余命
                List<String> the_options = new List<String>{
                    '2週間以内',
                    '1か月以内',
                    '3か月以内',
                    '6か月以内',
                    '1年以内',
                    '2年以内',
                    '3年以内',
                    '4年以内',
                    '5年以内'
                };
                if( !String.isBlank(aImpData.Taishosha_Yomei__c) && !the_options.contains(aImpData.Taishosha_Yomei__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('対象者の余命')
                    .set_imput_value(aImpData.Taishosha_Yomei__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //対象者の居住形態
                List<String> the_options = new List<String>{
                    '自宅',
                    '病院（入院中）',
                    '老人ホーム',
                    '介護施設',
                    'その他'
                };
                if( !String.isBlank(aImpData.Taishosha_KyojuKeitai__c) && !the_options.contains(aImpData.Taishosha_KyojuKeitai__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('対象者の居住形態')
                    .set_imput_value(aImpData.Taishosha_KyojuKeitai__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //完了種別
                List<String> the_options = new List<String>{
                    '未完了/1回目完了',
                    '未完了/2回目完了',
                    '完了/資料送付1',
                    '完了/資料送付2',
                    '完了/SMS許諾',
                    '完了/お断り',
                    '完了/間違い、イタズラ',
                    '完了/3回目完了',
                    '完了/エスカレーション'
                };
                if( !String.isBlank(aImpData.Kanryo_Shubetsu__c) && !the_options.contains(aImpData.Kanryo_Shubetsu__c) )
                the_result.erros.add(
                    new ErrEntry()
                    .set_field_name('完了種別')
                    .set_imput_value(aImpData.Kanryo_Shubetsu__c)
                    .set_descr('未定義選択肢')
                );
            }

            { //資料発送日
                if( !this.mDate_Validator.isValid( aImpData.ShiryoHassoDate__c ) ){
                    the_result.erros.add(
                        new ErrEntry()
                        .set_field_name('資料発送日')
                        .set_imput_value(aImpData.ShiryoHassoDate__c)
                        .set_descr('フォーマット不正')
                    );
                }
            }

            return the_result;
        }
    }

    public interface IDatetime_Validator {
        Boolean isValid(String pValue);
        Datetime parse(String pValue);
    }
    public class Datetime_Validator implements IDatetime_Validator{
        public Boolean isValid(String pValue){
            Boolean is_valid = true;
            try{
                this.parse(pValue);
            }catch(Exception ex){
                is_valid = false;
            }
            return is_valid;
        } 
        public Datetime parse(String pValue){
            if( String.isBlank(pValue) ) return null;
            return Datetime.valueOf(pValue.replace('#','') + ':00');
        }
    }

    public interface IDate_Validator {
        Boolean isValid(String pValue);
        Datetime parse(String pValue);
    }
    public class Date_Validator implements IDate_Validator{
        public Boolean isValid(String pValue){
            Boolean is_valid = true;
            try{
                this.parse(pValue);
            }catch(Exception ex){
                is_valid = false;
            }
            return is_valid;
        } 
        public Date parse(String pValue){
            if( String.isBlank(pValue) ) return null;
            return Date.valueOf(pValue.replace('#',''));
        }
    }

    public interface IValidationOnBefore {
        void validate( TcmsTaioRkImpData__c aNewOne );
    }
    @TestVisible
    private class ValidationOnBefore implements IValidationOnBefore{

        private IValidator mValidator = null;

        public ValidationOnBefore(IValidator pValidator){
            this.mValidator = pValidator;
        }

        public void validate( TcmsTaioRkImpData__c aNewOne ){
            aNewOne.HasValidationError__c = false;
            aNewOne.ValidationErrorDescr__c = null;
            TcmsTaioRkImpDataValids.Result the_validation_result = this.mValidator.validate(aNewOne);

            if( the_validation_result.erros.size() > 0 ){
                aNewOne.HasValidationError__c = true;
                String the_error_descr = Json.serializePretty(the_validation_result);
                aNewOne.ValidationErrorDescr__c = String.isBlank(the_error_descr) ? null : the_error_descr.left(5000);
            }
        }
    }
}