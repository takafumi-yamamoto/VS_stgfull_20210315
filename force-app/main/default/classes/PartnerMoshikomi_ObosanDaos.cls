public class PartnerMoshikomi_ObosanDaos {
    public static IPartnerMoshikomi_ObosanDao GetInstance(){
        return new PartnerMoshikomi_ObosanDao();
    }

    public interface IPartnerMoshikomi_ObosanDao{
        PartnerMoshikomi_Obosanbin__c SelectById(Id id);
    }

    public class PartnerMoshikomi_ObosanDao Implements IPartnerMoshikomi_ObosanDao{

        private PartnerMoshikomi_ObosanDao(){}

        private String getQueryBody(){
	        String query_str = '';
	        query_str += ' SELECT ';
	        query_str += ' Id, ';               // カスタムオブジェクト ID
	        query_str += ' OwnerId, ';               // 所有者 ID
	        query_str += ' IsDeleted, ';               // 削除
	        query_str += ' Name, ';               // 【パートナー申込】お坊さん便番号
	        query_str += ' CreatedDate, ';               // 作成日
	        query_str += ' CreatedById, ';               // 作成者 ID
	        query_str += ' LastModifiedDate, ';               // 最終更新日
	        query_str += ' LastModifiedById, ';               // 最終更新者 ID
	        query_str += ' SystemModstamp, ';               // System Modstamp
	        query_str += ' LastActivityDate, ';               // 最終活動日
	        query_str += ' LastViewedDate, ';               // 最終参照日
	        query_str += ' LastReferencedDate, ';               // 最終参照日
	        query_str += ' LastNameFurigana__c, ';               // 姓（カナ）
	        query_str += ' FirstNameFurigana__c, ';               // 名（カナ）
	        query_str += ' LastName__c, ';               // 姓
	        query_str += ' FirstName__c, ';               // 名
	        query_str += ' Gender__c, ';               // 性別
	        query_str += ' JiinSyuha__c, ';               // 宗派
	        query_str += ' JiinShuhaSonotaKana__c, ';               // 宗派その他(カナ)
	        query_str += ' JiinShuhaSonota__c, ';               // 宗派その他
	        query_str += ' MoshikomishaKyojuchiPostalcode__c, ';               // 住所(請求先)(郵便番号)
	        query_str += ' MoshikomishaKyojuchiState__c, ';               // 住所(請求先)(都道府県)
	        query_str += ' MoshikomishaKyojuchiCity__c, ';               // 住所(請求先)(市区郡)
	        query_str += ' MoshikomishaKyojuchiStreet__c, ';               // 住所(請求先)(町名・番地)
	        query_str += ' Phone__c, ';               // 電話1
	        query_str += ' Fax__c, ';               // Fax
	        query_str += ' MobilePhone__c, ';               // 携帯1
	        query_str += ' HomutaiokanoArea__c, ';               // 法務対応可能エリア
	        query_str += ' PersonBirthdate__c, ';               // 生年月日
	        query_str += ' HoninKakuninSyoruiSyubetsu__c, ';               // 本人確認書類種別
	        query_str += ' MailAddress__c, ';               // メールアドレス1
	        query_str += ' JiinJiinshuha__c, ';               // 宗派
	        query_str += ' JiinJiinshuhaSonotaKana__c, ';               // 宗派その他(カナ)
	        query_str += ' JiinJiinshuhaSonota__c, ';               // 宗派その他
	        query_str += ' SangoJiinMeiFurigana__c, ';               // 山号寺院名（カナ）
	        query_str += ' KatudojiinJiinName__c, ';               // お客様・提携先名
	        query_str += ' KatudojiinJiinjushoPostalcode__c, ';               // 住所(請求先)(郵便番号)
	        query_str += ' KatudojiinJiinjushoState__c, ';               // 住所(請求先)(都道府県)
	        query_str += ' KatudojiinJiinjushoCity__c, ';               // 住所(請求先)(市区郡)
	        query_str += ' KatudojiinJiinjushoStreet__c, ';               // 住所(請求先)(町名・番地)
	        query_str += ' JiinTel__c, ';               // 電話1
	        query_str += ' JiinFax__c, ';               // Fax
	        query_str += ' JiinsekininshaseiKana__c, ';               // 姓（カナ）
	        query_str += ' JiinsekininshameiKana__c, ';               // 名（カナ）
	        query_str += ' Jiinsekininshasei__c, ';               // 姓
	        query_str += ' Jiinsekininshamei__c, ';               // 名
	        query_str += ' JiinHpurl__c, ';               // Web サイト
	        query_str += ' JiinTanisyubetsu__c, ';               // 宗教法人単位種別
	        query_str += ' JiinHojintoki__c, ';               // 宗教法人格有
	        query_str += ' JiinjohoBetsuinjushoPostalcode__c, ';               // 住所(請求先)(郵便番号)
	        query_str += ' JiinjohoBetsuinjushoState__c, ';               // 住所(請求先)(都道府県)
	        query_str += ' JiinjohoBetsuinjushoCity__c, ';               // 住所(請求先)(市区郡)
	        query_str += ' JiinjohoBetsuinjushoStreet__c, ';               // 住所(請求先)(町名・番地)
	        query_str += ' JiinjohoBetsuindenokatsudo__c, ';               // 別院での活動を希望
	        query_str += ' JiinjohoBetsuintel__c, ';               // 電話1
	        query_str += ' JiinjohoBetsuinfax__c, ';               // Fax
	        query_str += ' JiinjohoZaisekijiinmeiKana__c, ';               // 山号寺院名（カナ）
	        query_str += ' JiinjohoZaisekijiinmei__c, ';               // お客様・提携先名
	        query_str += ' JiinjohoZaisekijiinjushoPostalcode__c, ';               // 住所(請求先)(郵便番号)
	        query_str += ' JiinjohoZaisekijiinjushoState__c, ';               // 住所(請求先)(都道府県)
	        query_str += ' JiinjohoZaisekijiinjushoCity__c, ';               // 住所(請求先)(市区郡)
	        query_str += ' JiinjohoZaisekijiinjushoStreet__c, ';               // 住所(請求先)(町名・番地)
	        query_str += ' JiinjohoZaisekijiintel__c, ';               // 電話1
	        query_str += ' JiinjohoZaisekijiinfax__c, ';               // Fax
	        query_str += ' BankName__c, ';               // 銀行名
	        query_str += ' BankBranchName__c, ';               // 銀行支店名
	        query_str += ' BankAccountType__c, ';               // 口座種別
	        query_str += ' BankAccountNo__c, ';               // 口座番号
	        query_str += ' BankAccountMeigi__c, ';               // 口座名義
	        query_str += ' Kaimyojuyonomiirai__c, ';               // 戒名授与のみ依頼
	        query_str += ' KaimyojuyoIraiYosodan__c, ';               // 戒名授与のみ依頼要相談
	        query_str += ' IdoSyudan__c, ';               // 移動手段
	        query_str += ' JizenanketoIdoshudanSonota__c, ';               // 移動手段その他
	        query_str += ' Iraisyosofuhouhou__c, ';               // 依頼書送付方法
	        query_str += ' ToubaTaioKahiKubun__c, ';               // 塔婆対応可否区分
	        query_str += ' TobaTaioYosodan__c, ';               // 塔婆対応要相談
	        query_str += ' TobaTaioKingakuFrom__c, ';               // 塔婆対応金額
	        query_str += ' TobaTaioKingakuTo__c, ';               // 塔婆対応金額
	        query_str += ' KakoTyoKinyuTaiouKahiKubun__c, ';               // 過去帳記入対応可否区分
	        query_str += ' KakochoKinyuYosodan__c, ';               // 過去帳記入要相談
	        query_str += ' KakochoKinyuKingakuFrom__c, ';               // 過去帳記入金額
	        query_str += ' KakochoKinyuKingakuTo__c, ';               // 過去帳記入金額
	        query_str += ' SyuzaiTaiouKahiKubun__c, ';               // 取材対応区分
	        query_str += ' JiinDenoHoyoKa__c, ';               // 寺院での法要可
	        query_str += ' SyuyoNinzu__c, ';               // 収容人数
	        query_str += ' CyusyaJoUmu__c, ';               // 駐車場有無
	        query_str += ' CyusyaKanouDaisu__c, ';               // 駐車可能台数
	        query_str += ' Somei__c, ';               // 僧名
	        query_str += ' JizenanketoSomeidenotorokuwokibo__c, ';               // 僧名での登録を希望
	        query_str += ' JizenanketoTashaservicetoroku__c, ';               // 他社サービス登録
	        query_str += ' JizenanketoTashaservicetorokumei__c, ';               // 他社サービス登録名
	        query_str += ' JiindenohoyoYosodan__c, ';               // 寺院での法要要相談
	        query_str += ' SomeiKana__c, ';               // 僧名(カナ)
	        query_str += ' moshikomisha_sosekishuhakeito__c, ';               // 僧籍宗派系統
	        query_str += ' ShozokuJiinShuhaKeito__c, ';               // 僧籍宗派系統
	        query_str += ' OkyakusamaTeikeisaki__c ';               // お客様・提携先
	        query_str += ' FROM PartnerMoshikomi_Obosanbin__c WHERE Id != null ';
	        return query_str;
        }

        public PartnerMoshikomi_Obosanbin__c SelectById(Id id){
            List<PartnerMoshikomi_Obosanbin__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
    }
}