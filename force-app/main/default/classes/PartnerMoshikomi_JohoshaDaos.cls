public class PartnerMoshikomi_JohoshaDaos {
    public static IPartnerMoshikomi_JohoshaDao GetInstance(){
        return new PartnerMoshikomi_JohoshaDao();
    }

    public interface IPartnerMoshikomi_JohoshaDao{
        PartnerMoshikomi_Johosha__c SelectById(Id id);
    }

    public class PartnerMoshikomi_JohoshaDao Implements IPartnerMoshikomi_JohoshaDao{

        private PartnerMoshikomi_JohoshaDao(){}

        private String getQueryBody(){
	        String query_str = '';
	        query_str += ' SELECT ';
	        query_str += ' Id, ';               // カスタムオブジェクト ID
	        query_str += ' Name, ';               // 【パートナー申込】助法者番号
	        query_str += ' LastNameFurigana__c, ';               // 姓（カナ）
	        query_str += ' FirstNameFurigana__c, ';               // 名(カナ)
	        query_str += ' LastName__c, ';               // 姓
	        query_str += ' FirstName__c, ';               // 名
	        query_str += ' Gender__c, ';               // 性別
	        query_str += ' JohoshaKyojuchiPostalcode__c, ';               // 住所(請求先)(郵便番号)
	        query_str += ' JohoshaKyojuchiState__c, ';               // 住所(請求先)(都道府県)
	        query_str += ' JohoshaKyojuchiCity__c, ';               // 住所(請求先)(市区郡)
	        query_str += ' JohoshaKyojuchiStreet__c, ';               // 住所(請求先)(町名・番地)
	        query_str += ' JohoshaTel__c, ';               // 電話1
	        query_str += ' Fax__c, ';               // Fax
	        query_str += ' MobilePhone__c, ';               // 携帯1
	        query_str += ' HomutaiokanoArea__c, ';               // 法務対応可能エリア
	        query_str += ' PersonBirthdate__c, ';               // 生年月日
	        query_str += ' HoninKakuninSyoruiSyubetsu__c, ';               // 本人確認書類種別
	        query_str += ' MailAddress__c, ';               // メールアドレス1
	        query_str += ' Syuha__c, ';               // 宗派
	        query_str += ' JiinShuhaSonotaKana__c, ';               // 宗派その他(カナ)
	        query_str += ' JiinShushaSonota__c, ';               // 宗派その他
	        query_str += ' SangoJiinMeiFurigana__c, ';               // 在籍寺院名（カナ）
	        query_str += ' TeikeisakiName__c, ';               // 在籍寺院名
	        query_str += ' JiinZaisekijiinjushoPostalcode__c, ';               // 住所(請求先)(郵便番号)
	        query_str += ' JiinZaisekijiinjushoState__c, ';               // 住所(請求先)(都道府県)
	        query_str += ' JiinZaisekijiinjushoCity__c, ';               // 住所(請求先)(市区郡)
	        query_str += ' JiinZaisekijiinjushoStreet__c, ';               // 住所(請求先)(町名・番地)
	        query_str += ' JohoshajiinTel__c, ';               // 電話1
	        query_str += ' JohoshajiinFax__c, ';               // Fax
	        query_str += ' JohoshajiinHpurl__c, ';               // Web サイト
	        query_str += ' JohoshajiinTanishubetsu__c, ';               // 宗教法人単位種別
	        query_str += ' JohoshajiinHojintoki__c, ';               // 宗教法人格有
	        query_str += ' Obousanbin__c, ';               // 【パートナー申込】お坊さん便
	        query_str += ' johoshajiin_sosekishuhakeito__c, ';               // 僧籍宗派系統
	        query_str += ' OkyakusamaTeikeisakiRef__c ';               // お客様・提携先
	        query_str += ' FROM PartnerMoshikomi_Johosha__c WHERE Id != null ';
	        return query_str;
        }

        public PartnerMoshikomi_Johosha__c SelectById(Id id){
            List<PartnerMoshikomi_Johosha__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
    }
}