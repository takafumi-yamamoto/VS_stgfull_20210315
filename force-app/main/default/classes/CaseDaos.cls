public class CaseDaos
{
    public static ICaseDao GetInstance(){
        return new CaseDao();
    }

    public interface ICaseDao{
        Case SelectById(Id id);
        List<Case> getDataForCheckSelectByName(List<String> nameList);
        List<Case> getDataForCheckSelectByUniqId(List<String> uniq_id_list);
        List<Case> getDataForCheckSelectByRecordTypeIdAndKey(Id RecordTypeId, List<String> uniq_id_list);
        List<Case> getDataForCheckSelectByRecordTypeIdAndMailAddress(Id RecordTypeId, List<String> maillist);
    }
    public class CaseDao Implements ICaseDao{

        private CaseDao(){}

        private String getQueryBody(){
            return 'SELECT Id, AccountId From Case WHERE Id != null ';
        }

        public Case SelectById(Id id){
            List<Case> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }


        public List<Case> getDataForCheckSelectByName(List<String> nameList){

            return Database.query(getCheckFieldSoql() + ' WHERE Subject = :nameList');
        }

        public List<Case> getDataForCheckSelectByUniqId(List<String> uniq_id_list){

            return Database.query(getCheckFieldSoql() + ' WHERE uniq_id__c = :uniq_id_list');
        }

        public List<Case> getDataForCheckSelectByRecordTypeIdAndKey(Id RecordTypeId, List<String> lastname_list){

            return Database.query(getCheckFieldSoql() + ' WHERE RecordTypeId =: RecordTypeId and LastName__c = :lastname_list order by CreatedDate desc');
        }

        public List<Case> getDataForCheckSelectByRecordTypeIdAndMailAddress(Id RecordTypeId, List<String> maillist){

            return Database.query(getCheckFieldSoql() + ' WHERE RecordTypeId =: RecordTypeId and MailAddress__c = :maillist order by CreatedDate desc');
        }


        private String getCheckFieldSoql(){
            String query_str = '';
            query_str += ' SELECT ';
            query_str += ' Id, ';               // 
            query_str += ' GaClientId__c, ';               // GaClientId
            query_str += ' ContactId, ';               // 取引先責任者 ID
            query_str += ' AccountId, ';               // お客様・提携先名
            query_str += ' ParentId, ';               // 親ケース ID
            query_str += ' SuppliedName, ';               // 名前
            query_str += ' SuppliedEmail, ';               // メール
            query_str += ' SuppliedPhone, ';               // 電話
            query_str += ' SuppliedCompany, ';               // 会社名・所属寺院
            query_str += ' Type, ';               // 問合せ種別
            query_str += ' RecordTypeId, ';               // レコードタイプ ID
            query_str += ' Status, ';               // 状況
            query_str += ' Reason, ';               // 原因
            query_str += ' Origin, ';               // 発生チャネル
            query_str += ' Subject, ';               // 件名
            query_str += ' Priority, ';               // 優先度
            query_str += ' Description, ';               // 説明
            query_str += ' IsEscalated, ';               // エスカレーション済フラグ
            query_str += ' OwnerId, ';               // 所有者 ID
            query_str += ' CampanyYago__c, ';               // 会社名(屋号)
            query_str += ' PostalCode__c, ';               // 郵便番号
            query_str += ' State__c, ';               // 都道府県
            query_str += ' City__c, ';               // 市区郡
            query_str += ' Street__c, ';               // 町名・番地
            query_str += ' RepresentativeLastname__c, ';               // 代表者(姓)
            query_str += ' RepresentativeFirstname__c, ';               // 代表者(名)
            query_str += ' Lastname__c, ';               // 相談者・担当者(姓)
            query_str += ' Firstname__c, ';               // 相談者・担当者(名)
            query_str += ' FAX__c, ';               // FAX
            query_str += ' Website__c, ';               // Web サイト
            query_str += ' AffiliateSoukyakuSaki__c, ';               // アフィリエイト送客先
            query_str += ' Teikeisaijo__c, ';               // 提携斎場
            query_str += ' NumberOfEmployees__c, ';               // 従業員数
            query_str += ' OccurrenceType__c, ';               // 発生種別
            query_str += ' Teikeisakisyubetsu__c, ';               // 提携先種別
            query_str += ' ShikijoName__c, ';               // 式場名称
            query_str += ' Status__c, ';               // ステータス
            query_str += ' TaishoshaCity__c, ';               // 対象者住所（市区郡）
            query_str += ' TaishoshaState__c, ';               // 対象者住所（都道府県）
            query_str += ' TaishoshaStreet__c, ';               // 対象者住所（町名・番地以降）
            query_str += ' TaishoshaZipCode__c, ';               // 対象者住所（郵便番号）
            query_str += ' JisyaSaijoSyoyuJokyo__c, ';               // 自社斎場所有状況
            query_str += ' AnchiKubun__c, ';               // 安置区分
            query_str += ' DuplicationCheckAccountUrl__c, ';               // 重複チェック取引先URL
            query_str += ' EndingNoteFlg__c, ';               // エンディングノートの有無
            query_str += ' EntranceID__c, ';               // 入口識別ID
            query_str += ' Entrance__c, ';               // 入口
            query_str += ' Field1__c, ';               // 資料送付日
            query_str += ' FirstNameKana__c, ';               // 相談者・担当者(名カナ)
            query_str += ' FormType__c, ';               // フォーム種別
            query_str += ' GenzainoBasho__c, ';               // 現在の場所
            query_str += ' Gofuannakoto__c, ';               // ご不安なこと
            query_str += ' GosodanNoKikkake__c, ';               // ご相談のきっかけ
            query_str += ' Goyosan__c, ';               // ご予算
            query_str += ' HansoMuryoRiyo__c, ';               // 搬送無料利用
            query_str += ' Hansohi__c, ';               // 搬送費
            query_str += ' HojiHoyo__c, ';               // 法事・法要
            query_str += ' HoyoKiboDate1__c, ';               // 法要希望日（第一希望）
            query_str += ' HoyoKiboDate2__c, ';               // 法要希望日（第二希望）
            query_str += ' HoyoKiboDate3__c, ';               // 法要希望日（第三希望）
            query_str += ' HoyoKiboMinute1__c, ';               // 法要希望分（第一希望）
            query_str += ' HoyoKiboMinute2__c, ';               // 法要希望分（第二希望）
            query_str += ' HoyoKiboMinute3__c, ';               // 法要希望分（第三希望）
            query_str += ' HoyoKiboTime1__c, ';               // 法要希望時間（第一希望）
            query_str += ' HoyoKiboTime2__c, ';               // 法要希望時間（第二希望）
            query_str += ' HoyoKiboTime3__c, ';               // 法要希望時間（第三希望）
            query_str += ' HoyobashoCity__c, ';               // 法要場所住所（市区郡）
            query_str += ' HoyobashoMei__c, ';               // 法要場所名称
            query_str += ' HoyobashoState__c, ';               // 法要場所住所（都道府県）
            query_str += ' HoyobashoStreet__c, ';               // 法要場所住所（町名・番地以降）
            query_str += ' HoyobashoZipCode__c, ';               // 法要場所住所（郵便番号）
            query_str += ' HoyouYoteiStaus__c, ';               // 法要予定状況
            query_str += ' Ikosha__c, ';               // 意向者
            query_str += ' ImporantMessage__c, ';               // 重要連絡事項
            query_str += ' IraiHoho__c, ';               // 依頼方法
            query_str += ' IsHokenGate__c, ';               // 保険ゲート
            query_str += ' Jisyasaijo__c, ';               // 自社斎場
            query_str += ' JizenwariNoKikan__c, ';               // 事前割の期間
            query_str += ' JizewariPlan__c, ';               // 事前割プラン
            query_str += ' KaimyoHomei__c, ';               // 戒名・法名
            query_str += ' KaimyoHomeijuyo__c, ';               // 戒名・法名の授与
            query_str += ' KaimyoPlan__c, ';               // 戒名プラン
            query_str += ' KakuninRenrakuNoKiboUmu__c, ';               // 確認連絡の希望有無
            query_str += ' KanriGamenUrl__c, ';               // 管理画面URL
            query_str += ' KeitaiDenwa__c, ';               // 携帯電話番号
            query_str += ' KiboAreaCity__c, ';               // 希望エリア市区群
            query_str += ' KiboAreaState__c, ';               // 希望エリア都道府県
            query_str += ' KiboPlan__c, ';               // 希望プラン
            query_str += ' KiboRiyu__c, ';               // 希望理由
            query_str += ' KinkyuRenrakusakiMei__c, ';               // 緊急連絡先名
            query_str += ' KinkyuRenrakusakiTantoshaMeiFurigana__c, ';               // 緊急連絡先担当者（名カナ）
            query_str += ' KinkyuRenrakusakiTantoshaMei__c, ';               // 緊急連絡先担当者(名)
            query_str += ' KinkyuRenrakusakiTantoshaSeiFurigana__c, ';               // 緊急連絡先担当者（姓カナ）
            query_str += ' KinkyuRenrakusakiTantoshaSei__c, ';               // 緊急連絡先担当者（姓）
            query_str += ' KinkyuRenrakusakiTelNo__c, ';               // 緊急連絡先電話番号
            query_str += ' LastNameKana__c, ';               // 相談者・担当者(姓カナ)
            query_str += ' LoginTorihikisakiBango__c, ';               // ログイン取引先番号
            query_str += ' MailAddress__c, ';               // メール
            query_str += ' MailArrivalTime__c, ';               // メールの到着時間帯
            query_str += ' MemberTourokuKibo__c, ';               // メンバー登録希望
            query_str += ' MitsumoriKingaku__c, ';               // 見積り金額
            query_str += ' MitsumoriTochakuKiboKikan__c, ';               // 見積り到着希望期間
            query_str += ' Mitsumori__c, ';               // 見積もり
            query_str += ' MoshuSoteishaUmu__c, ';               // 喪主想定者有無
            query_str += ' ObosanbinOption__c, ';               // お坊さん便オプション
            query_str += ' OkyakusamaCommnet__c, ';               // お客様コメント
            query_str += ' OmukaesakiCity__c, ';               // お迎え先住所（市区郡）
            query_str += ' OmukaesakiMeisho__c, ';               // お迎え先名称
            query_str += ' OmukaesakiState__c, ';               // お迎え先住所（都道府県）
            query_str += ' OmukaesakiStreet__c, ';               // お迎え先住所（町名・番地以降）
            query_str += ' OmukaesakiZipCode__c, ';               // お迎え先住所（郵便番号）
            query_str += ' OsoshikiYoyakuDokyoOption__c, ';               // お葬式予約読経オプション
            query_str += ' OsoshikiYoyakuNokotsuOption__c, ';               // お葬式予約納骨オプション
            query_str += ' OsoshikiYoyakuShuPlan__c, ';               // お葬式予約主プラン
            query_str += ' PaymentType__c, ';               // 事前割支払い方法
            query_str += ' RenrakuKiboJikantai__c, ';               // 連絡希望時間帯
            query_str += ' Riyokaisu__c, ';               // 利用回数
            query_str += ' RyoriHenreihinNoTehai__c, ';               // 料理、返礼品の手配
            query_str += ' SId__c, ';               // SIｄ
            query_str += ' SaishuKengakubi__c, ';               // 最終見学日
            query_str += ' SankotsuKaiiki__c, ';               // 散骨海域
            query_str += ' Sanretsushasu__c, ';               // 参列者数
            query_str += ' Seinengappi__c, ';               // 相談者・担当者生年月日
            query_str += ' ShiharaiHouhou__c, ';               // 支払方法
            query_str += ' ShikijoCity__c, ';               // 式場住所（市区郡）
            query_str += ' ShikijoState__c, ';               // 式場住所（都道府県）
            query_str += ' ShikijoStreet__c, ';               // 式場住所（町名・番地以降）
            query_str += ' ShikijoZipCode__c, ';               // 式場住所（郵便番号）
            query_str += ' Shinzokusu__c, ';               // 親族数
            query_str += ' ShiryoHoyu__c, ';               // 資料保有
            query_str += ' ShiryoSoufuHoho__c, ';               // 資料送付方法
            query_str += ' ShiryohassosakiCity__c, ';               // 資料発送先（市区郡）
            query_str += ' ShiryohassosakiState__c, ';               // 資料発送先（都道府県）
            query_str += ' ShiryohassosakiStreet__c, ';               // 資料発送先（町名・番地以降）
            query_str += ' ShiryohassosakiZipCode__c, ';               // 資料発送先（郵便番号）
            query_str += ' Shuha__c, ';               // 宗派
            query_str += ' Shukyo__c, ';               // 宗教
            query_str += ' ShukyoshaNoTehai__c, ';               // 宗教者の手配
            query_str += ' SiryoSeikyoAri__c, ';               // 資料請求有
            query_str += ' SogiNoStyle__c, ';               // ご葬儀のスタイル
            query_str += ' SogiojoNoGokibo__c, ';               // 葬儀場のご希望
            query_str += ' SonotanoHoyo__c, ';               // その他の法要
            query_str += ' SonotanoSyukyoSyuha__c, ';               // その他の宗教・宗派
            query_str += ' SozokusodanKibo__c, ';               // 保険相続相談希望
            query_str += ' TaishoshaBodaijinoUmu__c, ';               // 菩提寺の有無
            query_str += ' TaishoshaGaMoshikomishaToDoitsu__c, ';               // お葬式対象者
            query_str += ' TaishoshaJuminhyoCity__c, ';               // 対象者住民票（市区郡）
            query_str += ' TaishoshaJuminhyoState__c, ';               // 対象者住民票（都道府県）
            query_str += ' TaishoshaKeitaiDenwa__c, ';               // 対象者携帯電話
            query_str += ' TaishoshaMailAddress__c, ';               // 対象者メールアドレス
            query_str += ' TaishoshaMeiFurigana__c, ';               // 対象者（名カナ）
            query_str += ' TaishoshaMei__c, ';               // 対象者（名）
            query_str += ' TaishoshaRef__c, ';               // 対象者
            query_str += ' TaishoshaSeiFurigana__c, ';               // 対象者（姓カナ）
            query_str += ' TaishoshaSei__c, ';               // 対象者（姓）
            query_str += ' TaishoshaSeinengappi__c, ';               // 対象者生年月日
            query_str += ' TaishoshaTelNo__c, ';               // 対象者電話番号
            query_str += ' TaishoushaBotsunengappi__c, ';               // 対象者没年月日
            query_str += ' TaishoushaJokyo__c, ';               // 対象者状況
            //issues3806--Start--
            query_str += ' TaishoshaKyojuKeitai__c, ';               // 対象者居住状態（初回）
            query_str += ' TaishoshaYomeiKikan__c, ';               // 余命期間（初回）
            query_str += ' ToiawaseKiinsha__c, ';               // 問い合わせ起因者（初回）
            //issues3806--End--
            query_str += ' TehaimaeRenrakuKibo__c, ';               // 手配前連絡希望有無
            query_str += ' TelNo__c, ';               // 電話番号
            query_str += ' ToiawaseDate__c, ';               // 問合せ日
            query_str += ' TorihikiShodanRef__c, ';               // 取引商談
            query_str += ' TsuikaHoyo__c, ';               // 追加法要
            query_str += ' TsuikahoyobashoCity__c, ';               // 追加法要場所住所（市区郡）
            query_str += ' TsuikahoyobashoMei__c, ';               // 追加法要場所名称
            query_str += ' TsuikahoyobashoState__c, ';               // 追加法要場所住所（都道府県）
            query_str += ' TsuikahoyobashoStreet__c, ';               // 追加法要場所住所（町名・番地以降）
            query_str += ' TsuikahoyobashoZipCode__c, ';               // 追加法要場所住所（郵便番号）
            query_str += ' WebAccountKibo__c, ';               // Webアカウント開設希望
            query_str += ' YoteiChiiki__c, ';               // 予定地域
            query_str += ' YoyakuShomeishoSofubi__c, ';               // 予約証明書送付日
            query_str += ' ZokugaraSodanshaNitottenoTaishoshaSonota__c, ';               // 続柄：相談者にとっての対象者その他関係
            query_str += ' ZokugaraSodanshaNitottenoTaishosha__c, ';               // 続柄：相談者にとっての対象者
            query_str += ' mail_flg__c, ';               // メール処理フラグ
            query_str += ' mauticAccountId__c, ';               // Mautic取引先ID
            query_str += ' qa_mail__c, ';               // お問合せメール
            query_str += ' uniq_id__c, ';               // メール処理ID
            query_str += ' Obonset__c, ';               // お盆セット
            query_str += ' ProductPlaceSelect__c ';               // 商品送付先
            query_str += ' FROM Case ';
            return query_str;
        }
    }


}