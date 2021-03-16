global class Cnst {
    // commons
    global static final String LF = '\n';
    global static final String CRLF = '\r\n';
    global static final String BLANK_ZENKAKU = '　';
    global static final String STR_EMPTY = '';

    // objects group
    global static final String PRODUCT2_BUNRUI_HONTAI = '本体';
    global static final String PRODUCT2_SOGI_CATEGORY_NAME_CHOKUSO   = '直葬';
    global static final String PRODUCT2_SOGI_CATEGORY_NAME_KASO      = '火葬式';
    global static final String PRODUCT2_SOGI_CATEGORY_NAME_ICHINICHI = '一日葬';
    global static final String PRODUCT2_SOGI_CATEGORY_NAME_KAZOKU    = '家族葬';
    global static final String PRODUCT2_SOGI_CATEGORY_NAME_IPPAN     = '一般葬';
    global static final String PRODUCT2_SOGI_CATEGORY_NAME_YASUGO    = '安豪';
    global static final String PRODUCT2_NAME_FOR_CUSTOMER_ATOSO = '後葬サポート割引';
    global static final String PRODUCT2_NAME_PREFIX_VALID_BEFORE_ONE = '【19.12】';
    global static final String PRODUCT2_NAME_PREFIX_VALID_CURRENT    = '【20.06】';
    global static final String PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_DOKKYO = '葬儀読経';
    global static final String PRODUCT2_SHOHIN_CATEGORY_NAME_SOGI_KAIMYO = '葬儀戒名';
    global static final String PRODUCT2_SHOHIN_CATEGORY_NAME_HOYO        = '法要';
    global static final String PRODUCT2_SHOHIN_CATEGORY_NAME_KAIMYO      = '戒名';
    global static final String PRODUCT2_NAME_TERAPASS = '定額僧侶手配代行';

    global static final String OPPORTUNITY_PHASE_KETTEI    = '決定';
    global static final String OPPORTUNITY_PHASE_SEKO_WAIT = '施行待ち';
    global static final String OPPORTUNITY_PHASE_SEKO_END  = '施行完了';
    global static final String OPPORTUNITY_PHASE_CLOSE     = '商談クローズ';
    global static final String OPPORTUNITY_SURVEY_DISCOUNT_STATUS_AGREE = '同意済';
    global static final String OPPORTUNITY_INFROW_SERVICE_SOGI              = 'シンプルなお葬式';
    global static final String OPPORTUNITY_INFROW_SERVICE_TERAPASS          = '定額僧侶手配代行';
    global static final String OPPORTUNITY_INFROW_SERVICE_SORYO_TEHAI_DAIKO = '僧侶手配代行';

    global static final String ACCOUNT_PERMISSIONFLAG_RECIEVE = '受け取る';
    global static final String ACCOUNT_PERMISSIONFLAG_NORECIEVE = '受け取らない';

    global static final String OBOSANBIN_MEMORIAL_SERVICE_PLAN_KASO      = '火葬式';
    global static final String OBOSANBIN_MEMORIAL_SERVICE_PLAN_ICHINICHI = '一日葬';
    global static final String OBOSANBIN_MEMORIAL_SERVICE_PLAN_IPPAN     = '一般葬';
    global static final String OBOSANBIN_MEMORIAL_SERVICE_PLAN_KAIMYO_OR_HOMYO_ONLY = '戒名・法名のみ';

    // Survey
    global static final String REPLACE_WORD_USER_NAME = '{{$$UserName$$}}';
    global static final String REPLACE_WORD_SURVEY_SHORT_URL = '{{$$SurveySUrl$$}}';
    global static final String REPLACE_WORD_KODEN_GAESHI_URL = '{{$$KodenGaeshiUrl$$}}';
    global static final String REPLACE_WORD_IHAI_URL = '{{$$IhaiUrl$$}}';
    global static final String REPLACE_WORD_YORISO_URL = '{{$$YorisoUrl$$}}';
    global static final String REPLACE_WORD_SOGI_URL = '{{$$SogiUrl$$}}';
    global static final String REPLACE_WORD_OBO_URL = '{{$$OboUrl$$}}';
    global static final String REPLACE_WORD_OBO_TOP_URL = '{{$$OboTopUrl$$}}';
    global static final String REPLACE_WORD_49HOYO_URL = '{{$$49HoyoUrl$$}}';
    global static final String REPLACE_WORD_EITAI_KUYO_URL = '{{$$EitaiKuyoUrl$$}}';
    global static final String REPLACE_WORD_KAIYO_SANKOTU_URL = '{{$$KaiyoSankotuUrl$$}}';
    global static final String REPLACE_WORD_SOZOKU_SODAN_URL = '{{$$SozokuSodanUrl$$}}';
    global static final String REPLACE_WORD_WEB_FRONT_BASE_URL = '{{$$WebFrontBaseUrl$$}}';
    global static final String REPLACE_WORD_SF_MAINTENACE_INFO_MSG = '{{$$SfMaintenaceMsg$$}}';
    global static final String SURVEY_URL_FILENAME = 'redirectsurvey';
    global static final String SURVEY_TAKER_URL_FILENAME = 'RedirectSurveyTaker';
    global static final String UTM_MEDIUM_SMS = 'sms';
    global static final String UTM_MEDIUM_SMS_AFTER_ONE_WEEK = 'sms_7';
    global static final String UTM_MEDIUM_SMS_AFTER_TWO_WEEK = 'sms_14';
    global static final String UTM_MEDIUM_EMAIL = 'mail';
    global static final String UTM_MEDIUM_EMAIL_AFTER_ONE_WEEK = 'mail_7';
    global static final String UTM_MEDIUM_EMAIL_AFTER_TWO_WEEK = 'mail_14';
    global static final String UTM_MEDIUM_EMAIL_NO_SURVEY = 'mail_no_survey';
    global static final String UTM_MEDIUM_SMS_AFTER_8DAY = 'sms_8';
    global static final String UTM_MEDIUM_EMAIL_AFTER_8DAY = 'mail_8';
    global static final String SMS_MSG_SOGI_SURVEY_FIRST = '【よりそうお葬式】先般のご葬儀大変お疲れ様でございました。改めてお悔やみ申し上げます。「アンケート割」を適用した方にお送りしているアンケートです。ご回答お願いいたします。' + LF
                                                    + '▼アンケートはこちらから' + LF
                                                    + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
                                                    + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
                                                    + 'ご葬儀後のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
                                                    + '▼お香典返し手配がまだの方へ' + LF
                                                    + '【ご予算で選べる13種類】選べるカタログギフトのご案内' + LF
                                                    + REPLACE_WORD_KODEN_GAESHI_URL + LF + LF
                                                    + '▼葬儀後手続きでお悩みの方へ' + LF
                                                    + '【相談無料】葬儀後手続きサポートのご案内' + LF
                                                    + REPLACE_WORD_SOZOKU_SODAN_URL;
    global static final String SMS_MSG_SOGI_SURVEY_RESEND_AFTER_ONE_WEEK = '先日「よりそうお葬式」式後アンケートのお願いをさせていただいておりましたが、まだ回答いただけていないようです。' + LF
                                                    + 'お早めの回答をお願いいたします。' + LF
                                                    + '▼アンケートはこちらから' + LF
                                                    + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
                                                    + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
                                                    + '※すでにご回答済でしたら行き違いとなってしまい申し訳ございません。' + LF + LF
                                                    + '▼お香典返し手配がまだの方へ' + LF
                                                    + '【ご予算で選べる13種類】選べるカタログギフトのご案内' + LF
                                                    + REPLACE_WORD_KODEN_GAESHI_URL + LF + LF
                                                    + '▼葬儀後手続きでお悩みの方へ' + LF
                                                    + '【相談無料】葬儀後手続きサポートのご案内' + LF
                                                    + REPLACE_WORD_SOZOKU_SODAN_URL;
    global static final String SMS_MSG_SOGI_SURVEY_RESEND_AFTER_TWO_WEEK = '「よりそうお葬式」アンケート割を適用させていただきましたが、まだアンケートに回答いただけていないようです。' + LF
                                                    + 'アンケートに回答いただくことを条件に割引をさせていただいておりますので、恐れ入りますが【1週間以内に】ご回答をお願いいたします。' + LF
                                                    + '▼アンケートはこちらから' + LF
                                                    + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
                                                    + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
                                                    + '※すでにご回答済でしたら行き違いとなってしまい申し訳ございません。' + LF + LF
                                                    + '▼本位牌・仏壇の購入' + LF
                                                    + '本位牌もお仏壇も、すべて送料無料でお届けいたします。' + LF
                                                    + REPLACE_WORD_IHAI_URL + LF + LF
                                                    + '▼四十九日法要の僧侶手配' + LF
                                                    + '初回は総額35,000円でお坊さんを手配いたします。' + LF
                                                    + REPLACE_WORD_49HOYO_URL;
    global static final String SMS_MSG_OBO_SURVEY_FIRST_DOKKYO =
        '【よりそうお坊さん便】でございます。先般のご葬儀大変お疲れ様でございました。' + LF
        + '悲しみも癒えぬ時期かと存じますが、サービス品質向上のため、アンケートにご回答をお願いしたく、ご連絡差し上げました。 恐れ入りますがご回答をお願いいたします。' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご葬儀後のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼ご法事・ご法要の僧侶手配なら' + LF
        + REPLACE_WORD_OBO_TOP_URL + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL;
    global static final String SMS_MSG_OBO_SURVEY_FIRST_HOYO =
        '【よりそうお坊さん便】先般のご法要はいかがでしたでしょうか。サービス品質向上のため、アンケートにご協力をお願いいたします。' + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご法要の他、仏事のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL;
    global static final String SMS_MSG_OBO_SURVEY_FIRST_KAIMYO =
        '【よりそうお坊さん便】をご利用いただき、誠にありがとうございました。サービス品質向上のため、アンケートにご協力をお願いいたします。' + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご供養や仏事でお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼ご法事・ご法要の僧侶手配なら' + LF
        + REPLACE_WORD_OBO_TOP_URL + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL;
    global static final String SMS_MSG_OBO_SURVEY_RESEND_AFTER_8DAY_DOKKYO =
        '【よりそうお坊さん便】でございます。先般のご葬儀大変お疲れ様でございました。' + LF
        + '先日「よりそうお坊さん便」よりアンケートのお願いをお送りいたしましたが、ご確認いただけましたでしょうか。' + LF
        + '恐れ入りますが、ご回答をお願いいたします。' + LF
        + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご葬儀後のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼ご法事・ご法要の僧侶手配なら' + LF
        + REPLACE_WORD_OBO_TOP_URL + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL;
    global static final String SMS_MSG_OBO_SURVEY_RESEND_AFTER_8DAY_HOYO =
        '【よりそうお坊さん便】先般のご法要はいかがでしたでしょうか。サービス品質向上のため、アンケートにご協力をお願いいたします。' + LF
        + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご法要の他、仏事のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL;
    global static final String SMS_MSG_OBO_SURVEY_RESEND_AFTER_8DAY_KAIMYO =
        '【よりそうお坊さん便】をご利用いただき、ありがとうございました。先日「よりそうお坊さん便」よりアンケートのお願いをお送りいたしましたが、ご確認いただけましたでしょうか。' + LF
        + '恐れ入りますが、ご回答をお願いいたします。' + LF
        + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご法要の他、仏事のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL;
    global static final String EMAIL_SUBJECT_SOGI_SURVEY = '【よりそうお葬式】式後アンケートのお願い';
    global static final String EMAIL_SUBJECT_OBO_SURVEY = '【よりそうお坊さん便】アンケートのお願い';
    global static final String EMAIL_BODY_SOGI_SURVEY = REPLACE_WORD_USER_NAME + ' 様' + LF + LF
                                                + '先般のご葬儀大変お疲れ様でございました。' + LF
                                                + '改めて、お悔やみを申し上げます。' + LF + LF
                                                + '悲しみも癒えぬ時期とは存じますが、「よりそうお葬式」の式後アンケートにご回答いただきたくご連絡差し上げました。' + LF
                                                + '恐れ入りますがお早めのご回答をお願いいたします。' + LF + LF
                                                + '下記URLをクリックして、アンケートにご回答ください。' + LF
                                                + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
                                                + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
                                                + '末筆ではございますが、お葬式のあとに必要となるお香典返しの手配、法事法要、各種お手続きなど、様々なサポートを提供させていただいております。' + LF
                                                + 'ご興味のあるサービスがありましたら、お気軽にご相談ください。' + LF + LF
                                                + '▼お葬式後すぐに必要なもの' + LF + LF
                                                + '1. お香典返しの手配' + LF
                                                + 'ご予算にあわせて、13種類のカタログギフトからお選びいただけます。' + LF
                                                + REPLACE_WORD_KODEN_GAESHI_URL + LF + LF
                                                + '2. 相続・遺品整理などの手続き' + LF
                                                + '相続手続きは、内容によって期限が定められている場合があります。まずはお気軽にご相談ください。【相談無料】' + LF
                                                + REPLACE_WORD_SOZOKU_SODAN_URL + LF + LF
                                                + '▼お葬式後2,3週間以内（四十九日の3週間以上前）に必要なもの' + LF + LF
                                                + '3. 本位牌・仏壇の購入' + LF
                                                + '本位牌もお仏壇も、すべて送料無料でお届けいたします。' + LF
                                                + REPLACE_WORD_IHAI_URL + LF + LF
                                                + '4. 四十九日法要の僧侶手配' + LF
                                                + '初回は総額35,000円でお坊さんを手配いたします。' + LF
                                                + REPLACE_WORD_49HOYO_URL + LF + LF
                                                + '▼1年後までに必要なもの' + LF + LF
                                                + '5. お墓・納骨・散骨の用意' + LF
                                                + '納めるお墓が決まっていない場合は、ご遺骨を納める方法をご検討ください。' + LF
                                                + 'よりそうでは、「永代供養墓」「海洋散骨」サービスを提供しています。' + LF
                                                + '・定額35,000円の永代供養墓（月額・管理費不要）' + LF
                                                + REPLACE_WORD_EITAI_KUYO_URL + LF + LF
                                                + '・定額49,800円の海洋散骨（追加費用なし）' + LF
                                                + REPLACE_WORD_KAIYO_SANKOTU_URL + LF;
    global static final String EMAIL_BODY_OBO_SURVEY_DOKKYO =
        REPLACE_WORD_USER_NAME + ' 様' + LF + LF
        + '先般のご葬儀大変お疲れ様でございました。' + LF
        + '悲しみも癒えぬ時期とは存じますが、' + LF
        + 'サービス品質向上のため、アンケートにご回答をお願いいたしたく、' + LF
        + 'ご連絡差し上げました。' + LF
        + '恐れ入りますが、ご回答をお願いいたします。' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご葬儀後のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼ご法事・ご法要の僧侶手配なら' + LF
        + REPLACE_WORD_OBO_TOP_URL + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL + LF + LF;
    global static final String EMAIL_BODY_OBO_SURVEY_HOYO =
        REPLACE_WORD_USER_NAME + ' 様' + LF + LF
        + 'この度は「よりそうお坊さん便」をご利用いただき、' + LF
        + '誠にありがとうございました。' + LF
        + '先般のご法要はいかがでしたでしょうか。' + LF
        + 'サービス品質向上のため、' + LF
        + 'アンケートにご協力をお願いいたします。' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'よりそうは「よりそうお坊さん便」のほか、様々なサービスをご提供しております。' + LF
        + 'お困り事がございましたら、お気軽にご相談ください。' + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL + LF + LF;
    global static final String EMAIL_BODY_OBO_SURVEY_KAIMYO =
        REPLACE_WORD_USER_NAME + ' 様' + LF + LF
        + 'この度は「よりそうお坊さん便」をご利用いただき、' + LF
        + '誠にありがとうございました。' + LF
        + 'サービス品質向上のため、' + LF
        + 'アンケートにご協力をお願いいたします。' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'よりそうは「よりそうお坊さん便」のほか、様々なサービスをご提供しております。' + LF
        + 'お困り事がございましたら、お気軽にご相談ください。' + LF + LF
        + '▼ご法事・ご法要の僧侶手配なら' + LF
        + REPLACE_WORD_OBO_TOP_URL + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL + LF + LF;
    global static final String EMAIL_SUBJECT_SOGI_SURVEY_RESEND_AFTER_ONE_WEEK = '【再送】【よりそうお葬式】式後アンケートのお願い';
    global static final String EMAIL_SUBJECT_OBO_SURVEY_RESEND_AFTER_8DAY = '＜再送＞【よりそうお坊さん便】アンケートのお願い';
    global static final String EMAIL_BODY_SOGI_SURVEY_RESEND_AFTER_ONE_WEEK = REPLACE_WORD_USER_NAME + ' 様' + LF + LF
                                                    + '「よりそうお葬式」をご利用頂きましてありがとうございます。' + LF
                                                    + '先般のご葬儀大変お疲れ様でございました。' + LF + LF
                                                    + '先日「よりそうお葬式」式後アンケートのお願いをさせていただいておりましたがご確認いただけましたでしょうか。' + LF
                                                    + 'アンケートに回答いただくことを条件に割引をさせていただいておりますので、恐れ入りますがお早めのご回答をお願いいたします。' + LF + LF
                                                    + '下記URLをクリックして、アンケートにご回答ください。' + LF
                                                    + REPLACE_WORD_SURVEY_SHORT_URL + LF
                                                    + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
                                                    + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
                                                    + '末筆ではございますが、お葬式のあとに必要となるお香典返しの手配、法事法要、各種お手続きなど、様々なサポートを提供させていただいております。' + LF
                                                    + 'ご興味のあるサービスがありましたら、お気軽にご相談ください。' + LF + LF
                                                    + '▼お葬式後すぐに必要なもの' + LF + LF
                                                    + '1. お香典返しの手配' + LF
                                                    + 'ご予算にあわせて、13種類のカタログギフトからお選びいただけます。' + LF
                                                    + REPLACE_WORD_KODEN_GAESHI_URL + LF + LF
                                                    + '2. 相続・遺品整理などの手続き' + LF
                                                    + '相続手続きは、内容によって期限が定められている場合があります。まずはお気軽にご相談ください。【相談無料】' + LF
                                                    + REPLACE_WORD_SOZOKU_SODAN_URL + LF + LF
                                                    + '▼お葬式後2,3週間以内（四十九日の3週間以上前）に必要なもの' + LF + LF
                                                    + '3. 本位牌・仏壇の購入' + LF
                                                    + '本位牌もお仏壇も、すべて送料無料でお届けいたします。' + LF
                                                    + REPLACE_WORD_IHAI_URL + LF + LF
                                                    + '4. 四十九日法要の僧侶手配' + LF
                                                    + '初回は総額35,000円でお坊さんを手配いたします。' + LF
                                                    + REPLACE_WORD_49HOYO_URL + LF + LF
                                                    + '▼1年後までに必要なもの' + LF + LF
                                                    + '5. お墓・納骨・散骨の用意' + LF
                                                    + '納めるお墓が決まっていない場合は、ご遺骨を納める方法をご検討ください。' + LF
                                                    + 'よりそうでは、「永代供養墓」「海洋散骨」サービスを提供しています。' + LF
                                                    + '・定額35,000円の永代供養墓（月額・管理費不要）' + LF
                                                    + REPLACE_WORD_EITAI_KUYO_URL + LF
                                                    + '・定額49,800円の海洋散骨（追加費用なし）' + LF
                                                    + REPLACE_WORD_KAIYO_SANKOTU_URL + LF;
    global static final String EMAIL_BODY_OBO_SURVEY_RESEND_AFTER_8DAY_DOKKYO =
        REPLACE_WORD_USER_NAME + ' 様' + LF + LF
        + '先般のご葬儀大変お疲れ様でございました。' + LF
        + '先日「よりそうお坊さん便」よりアンケートのお願いをお送りいたしましたが、' + LF
        + 'ご確認いただけましたでしょうか。' + LF
        + '恐れ入りますが、ご回答をお願いいたします。' + LF
        + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'ご葬儀後のお困り事などございましたら、お気軽にご相談ください。' + LF + LF
        + '▼ご法事・ご法要の僧侶手配なら' + LF
        + REPLACE_WORD_OBO_TOP_URL + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL + LF + LF;
    global static final String EMAIL_BODY_OBO_SURVEY_RESEND_AFTER_8DAY_HOYO =
        REPLACE_WORD_USER_NAME + ' 様' + LF + LF
        + '「よりそうお坊さん便」をご利用いただきまして、' + LF
        + '誠にありがとうございました。' + LF + LF
        + '先日「よりそうお坊さん便」よりアンケートのお願いをお送りいたしましたが、' + LF
        + 'ご確認いただけましたでしょうか。' + LF
        + '恐れ入りますが、ご回答をお願いいたします。' + LF
        + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'よりそうは「よりそうお坊さん便」のほか、様々なサービスをご提供しております。' + LF
        + 'お困り事がございましたら、お気軽にご相談ください。' + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL + LF + LF;
    global static final String EMAIL_BODY_OBO_SURVEY_RESEND_AFTER_8DAY_KAIMYO =
        REPLACE_WORD_USER_NAME + ' 様' + LF + LF
        + 'この度は「よりそうお坊さん便」をご利用いただき、' + LF
        + '誠にありがとうございました。' + LF
        + '先日「よりそうお坊さん便」よりアンケートのお願いをお送りいたしましたが、' + LF
        + 'ご確認いただけましたでしょうか。' + LF
        + '恐れ入りますが、ご回答をお願いいたします。' + LF
        + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
        + '▼アンケートはこちらから' + LF
        + REPLACE_WORD_SURVEY_SHORT_URL + LF + LF
        + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
        + 'よりそうは「よりそうお坊さん便」のほか、様々なサービスをご提供しております。' + LF
        + 'お困り事がございましたら、お気軽にご相談ください。' + LF + LF
        + '▼ご法事・ご法要の僧侶手配なら' + LF
        + REPLACE_WORD_OBO_TOP_URL + LF + LF
        + '▼位牌・仏壇をお探しなら' + LF
        + REPLACE_WORD_IHAI_URL + LF + LF
        + '▼永代供養墓をお探しなら' + LF
        + REPLACE_WORD_EITAI_KUYO_URL + LF + LF;
    global static final String EMAIL_SUBJECT_SOGI_SURVEY_RESEND_AFTER_TWO_WEEK = '【よりそうお葬式】アンケート割の条件を満たしておりません';
    global static final String EMAIL_BODY_SOGI_SURVEY_RESEND_AFTER_TWO_WEEK = REPLACE_WORD_USER_NAME + ' 様' + LF + LF
                                                    + 'この度は「よりそうお葬式」をご利用頂きましてありがとうございます。' + LF
                                                    + '先般のご葬儀大変お疲れ様でございました。' + LF + LF
                                                    + 'アンケート割を適用させていただきましたが、まだアンケートに回答いただけていないようです。' + LF
                                                    + 'アンケートに回答いただくことを条件に割引をさせていただいておりますので、恐れ入りますが【1週間以内に】ご回答をお願いいたします。' + LF + LF
                                                    + '下記URLをクリックして、アンケートにご回答ください。' + LF
                                                    + REPLACE_WORD_SURVEY_SHORT_URL + LF
                                                    + REPLACE_WORD_SF_MAINTENACE_INFO_MSG
                                                    + '（すでにご回答済みでしたら、行き違いとなってしまい大変申し訳ございません）' + LF + LF
                                                    + '末筆ではございますが、お葬式のあとに必要となるお香典返しの手配、法事法要、各種お手続きなど、様々なサポートを提供させていただいております。' + LF
                                                    + 'ご興味のあるサービスがありましたら、お気軽にご相談ください。' + LF + LF
                                                    + '▼お葬式後すぐに必要なもの' + LF + LF
                                                    + '1. お香典返しの手配' + LF
                                                    + 'ご予算にあわせて、13種類のカタログギフトからお選びいただけます。' + LF
                                                    + REPLACE_WORD_KODEN_GAESHI_URL + LF + LF
                                                    + '2. 相続・遺品整理などの手続き' + LF
                                                    + '相続手続きは、内容によって期限が定められている場合があります。まずはお気軽にご相談ください。【相談無料】' + LF
                                                    + REPLACE_WORD_SOZOKU_SODAN_URL + LF + LF
                                                    + '▼お葬式後2,3週間以内（四十九日の3週間以上前）に必要なもの' + LF + LF
                                                    + '3. 本位牌・仏壇の購入' + LF
                                                    + '本位牌もお仏壇も、すべて送料無料でお届けいたします。' + LF
                                                    + REPLACE_WORD_IHAI_URL + LF + LF
                                                    + '4. 四十九日法要の僧侶手配' + LF
                                                    + '初回は総額35,000円でお坊さんを手配いたします。' + LF
                                                    + REPLACE_WORD_49HOYO_URL + LF + LF
                                                    + '▼1年後までに必要なもの' + LF + LF
                                                    + '5. お墓・納骨・散骨の用意' + LF
                                                    + '納めるお墓が決まっていない場合は、ご遺骨を納める方法をご検討ください。' + LF
                                                    + 'よりそうでは、「永代供養墓」「海洋散骨」サービスを提供しています。' + LF
                                                    + '・定額35,000円の永代供養墓（月額・管理費不要）' + LF
                                                    + REPLACE_WORD_EITAI_KUYO_URL + LF
                                                    + '・定額49,800円の海洋散骨（追加費用なし）' + LF
                                                    + REPLACE_WORD_KAIYO_SANKOTU_URL + LF;
    global static final String EMAIL_SUBJECT_SOGI_NO_SURVEY = '【よりそうお葬式】各種葬儀後サポートのご案内';
    global static final String EMAIL_BODY_SOGI_NO_SURVEY = REPLACE_WORD_USER_NAME + ' 様' + LF + LF
                                                + '先般のご葬儀大変お疲れ様でございました。' + LF
                                                + '改めて、お悔やみを申し上げます。' + LF + LF
                                                + 'よりそうでは、お葬式のあとに必要となるお香典返しの手配、法事法要、各種お手続きなど、様々なサポートを提供させていただいております。' + LF
                                                + 'ご興味のあるサービスがありましたら、お気軽にご相談ください。' + LF + LF
                                                + '▼お葬式後すぐに必要なもの' + LF + LF
                                                + '1. お香典返しの手配' + LF
                                                + 'ご予算にあわせて、13種類のカタログギフトからお選びいただけます。' + LF
                                                + REPLACE_WORD_KODEN_GAESHI_URL + LF + LF
                                                + '2. 相続・遺品整理などの手続き' + LF
                                                + '相続手続きは、内容によって期限が定められている場合があります。まずはお気軽にご相談ください。【相談無料】' + LF
                                                + REPLACE_WORD_SOZOKU_SODAN_URL + LF + LF
                                                + '▼お葬式後2,3週間以内（四十九日の3週間以上前）に必要なもの' + LF + LF
                                                + '3. 本位牌・仏壇の購入' + LF
                                                + '本位牌もお仏壇も、すべて送料無料でお届けいたします。' + LF
                                                + REPLACE_WORD_IHAI_URL + LF + LF
                                                + '4. 四十九日法要の僧侶手配' + LF
                                                + '初回は総額35,000円でお坊さんを手配いたします。' + LF
                                                + REPLACE_WORD_49HOYO_URL + LF + LF
                                                + '▼1年後までに必要なもの' + LF + LF
                                                + '5. お墓・納骨・散骨の用意' + LF
                                                + '納めるお墓が決まっていない場合は、ご遺骨を納める方法をご検討ください。' + LF
                                                + 'よりそうでは、「永代供養墓」「海洋散骨」サービスを提供しています。' + LF
                                                + '・定額35,000円の永代供養墓（月額・管理費不要）' + LF
                                                + REPLACE_WORD_EITAI_KUYO_URL + LF + LF
                                                + '・定額49,800円の海洋散骨（追加費用なし）' + LF
                                                + REPLACE_WORD_KAIYO_SANKOTU_URL + LF;
    global static final String EMAIL_BODY_SOGI_SURVEY_SIGNATURE = LF + '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' + LF
                                                    + 'よりそう公式ページ' + LF
                                                    + REPLACE_WORD_YORISO_URL + LF + LF
                                                    + 'よりそうお葬式' + LF
                                                    + REPLACE_WORD_SOGI_URL + LF + LF
                                                    + '▼お問い合わせ' + LF
                                                    + 'よりそうマイページに関するお問い合わせはこちら' + LF
                                                    + 'Mail：sougi-service@yoriso.com' + LF + LF
                                                    + 'お葬式に関するお問い合わせはこちら' + LF
                                                    + 'Tel : 0120-541-672 （24時間365日対応）' + LF
                                                    + 'Fax : 03-5487-3805' + LF
                                                    + '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' + LF
                                                    + '発行 : 株式会社よりそう' + LF
                                                    + '住所 : 〒141-0031 東京都品川区⻄五反⽥2-11-17 HI五反⽥ビル2F';
    global static final String EMAIL_BODY_OBO_SURVEY_SIGNATURE =
        LF + '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' + LF
        + 'よりそうお坊さん便' + LF
        + REPLACE_WORD_OBO_URL + LF + LF
        + 'よりそう公式ページ' + LF
        + REPLACE_WORD_YORISO_URL + LF + LF
        + '▼お葬式に関するお問い合わせはこちら' + LF
        + 'よりそうお葬式コールセンター ' + LF
        + '  0120-541-672 （24時間365日対応）' + LF + LF
        + '▼ご法事・ご法要に関するお問い合わせはこちら' + LF
        + 'よりそうお坊さん便コールセンター' + LF
        + '  0120-542-918 （受付時間：8時30分から20時30分）' + LF
        + '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' + LF
        + '発行 : 株式会社よりそう' + LF
        + '住所 : 〒141-0031 東京都品川区⻄五反⽥2-11-17 HI五反⽥ビル2F';

    global static final String SURVEY_QUESTION_YORISO_SECTION             = 'YS000';
    global static final String SURVEY_QUESTION_YORISO_ATTENDEE_CNT        = 'YS001';
    global static final String SURVEY_QUESTION_YORISO_REASON_FOR_CHOISING = 'YS002';
    global static final String SURVEY_QUESTION_YORISO_PLAN_INTELLIGIBILITY_SATISFACTION = 'YS003';
    global static final String SURVEY_QUESTION_YORISO_PLAN_INTELLIGIBILITY_REASON       = 'YS004';
    global static final String SURVEY_QUESTION_YORISO_TOTAL_COST         = 'YS005';
    global static final String SURVEY_QUESTION_YORISO_PRICE_SATISFACTION = 'YS006';
    global static final String SURVEY_QUESTION_YORISO_SOGI_SATISFACTION  = 'YS008';
    global static final String SURVEY_QUESTION_YORISO_RECOMMEND_NPS      = 'YS009';
    global static final String SURVEY_QUESTION_YORISO_FREE_ANSWER        = 'YS010';
    global static final String SURVEY_QUESTION_YORISO_COMPARE_OTHER_SERVICES = 'YS014';
    global static final List<String> SURVEY_QUESTION_YORISO = new List<String> {
        SURVEY_QUESTION_YORISO_SECTION
        ,SURVEY_QUESTION_YORISO_ATTENDEE_CNT
        ,SURVEY_QUESTION_YORISO_REASON_FOR_CHOISING
        ,SURVEY_QUESTION_YORISO_PLAN_INTELLIGIBILITY_SATISFACTION
        ,SURVEY_QUESTION_YORISO_PLAN_INTELLIGIBILITY_REASON
        ,SURVEY_QUESTION_YORISO_TOTAL_COST
        ,SURVEY_QUESTION_YORISO_PRICE_SATISFACTION
        ,SURVEY_QUESTION_YORISO_SOGI_SATISFACTION
        ,SURVEY_QUESTION_YORISO_RECOMMEND_NPS
        ,SURVEY_QUESTION_YORISO_FREE_ANSWER
        ,SURVEY_QUESTION_YORISO_COMPARE_OTHER_SERVICES
    };
    global static final String SURVEY_QUESTION_YORISO_ATOSO_FEELINGS_CHANGE_AFTER_USE = 'YS011';
    global static final String SURVEY_QUESTION_YORISO_ATOSO_GOOD_AND_HOPE_SERVICE     = 'YS012';
    global static final String SURVEY_QUESTION_YORISO_ATOSO_INTERVIE_COOPERATION      = 'YS013';
    global static final List<String> SURVEY_QUESTION_YORISO_ATOSO = new List<String> {
            SURVEY_QUESTION_YORISO_ATOSO_FEELINGS_CHANGE_AFTER_USE
            ,SURVEY_QUESTION_YORISO_ATOSO_GOOD_AND_HOPE_SERVICE
            ,SURVEY_QUESTION_YORISO_ATOSO_INTERVIE_COOPERATION
    };
    global static final List<String> SURVEY_QUESTION_CS = new List<String> {
            'CS000', 'CS001', 'CS002', 'CS003'
            ,'CS005','CS007'
            ,'CS013'
    };
    global static final List<String> SURVEY_QUESTION_SOGISHA = new List<String> {
            'SG000', 'SG001', 'SG002', 'SG004'
            ,'SG005', 'SG007', 'SG009'
    };
    global static final List<String> SURVEY_QUESTION_SAIJO = new List<String> {
            'SJ000', 'SJ001', 'SJ003'
            ,'SJ005', 'SJ007'
    };
    global static final List<String> SURVEY_QUESTION_KASOBA = new List<String> {
            'KS000', 'KS001', 'KS003'
            ,'KS005'
    };
    global static final List<String> SURVEY_QUESTION_OBO = new List<String> {
            'OB000', 'OB001', 'OB002', 'OB003', 'OB004'
            ,'OB005'
    };
    global static final String SURVEY_QUESTION_NAME_LAST_SECTION           = 'LT000';
    global static final String SURVEY_QUESTION_NAME_LAST_TROUBLE           = 'LT001';
    global static final String SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES = 'LT002';
    global static final String SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME     = 'LT003';
    global static final List<String> SURVEY_QUESTION_LAST = new List<String> {
            SURVEY_QUESTION_NAME_LAST_SECTION
            ,SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES
            ,SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME
    };
    global static final String SURVEY_ANSWER_MULTI_CHECK_DELIMITER = Cnst.LF + '; ';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_SOZOKU            = '相続・遺品整理などの手続き';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI              = '本位牌・仏壇の購入';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_SHIJUKUNICHI_HOYO = '四十九日法要の僧侶手配';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_OTHER_HOYO        = 'その他法要の僧侶手配';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO        = '永代供養';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_KAIYO_SANKOTSU    = '海洋散骨';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_SOZOKU_FULL =
        SURVEY_ANSWER_LAST_INTEREST_SERVICES_SOZOKU + 'サポート（初回相談無料）';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI_FULL =
        SURVEY_ANSWER_LAST_INTEREST_SERVICES_IHAI + '（位牌の文字入れ1名様分無料、全品送料無料）';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_SHIJUKUNICHI_HOYO_FULL =
        SURVEY_ANSWER_LAST_INTEREST_SERVICES_SHIJUKUNICHI_HOYO + 'のご相談（総額35,000円～）';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_OTHER_HOYO_FULL =
        SURVEY_ANSWER_LAST_INTEREST_SERVICES_OTHER_HOYO + 'のご相談';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO_FULL =
        SURVEY_ANSWER_LAST_INTEREST_SERVICES_EITAI_KUYO + '（一柱につき定額35,000円 ※管理費、月額不要）';
    global static final String SURVEY_ANSWER_LAST_INTEREST_SERVICES_KAIYO_SANKOTSU_FULL =
        SURVEY_ANSWER_LAST_INTEREST_SERVICES_KAIYO_SANKOTSU + '（一柱につき定額49,800円）';
    global static final String SURVEY_QUESTION_NAME_OLD_SURVEY_AREA_CODE = 'OD001';
    global static final String SURVEY_QUESTION_NAME_OLD_SAIJO_ID         = 'OD002';
    global static final String SURVEY_QUESTION_NAME_OLD_KASOBA_ID        = 'OD003';
    global static final String SURVEY_QUESTION_NAME_OLD_SEKO_DATE        = 'OD004';
    global static final String SURVEY_QUESTION_NAME_OLD_PLAN_TYPE_NAME   = 'OD005';
    global static final String SURVEY_QUESTION_NAME_OLD_DEATH_AGE        = 'OD006';
    global static final String SURVEY_QUESTION_NAME_OLD_MOSHU_AGE        = 'OD007';
    global static final String SURVEY_QUESTION_NAME_OLD_MOSHU_GENDER     = 'OD008';
    global static final List<String> SURVEY_QUESTION_OLDS = new List<String> {
            SURVEY_QUESTION_NAME_OLD_SURVEY_AREA_CODE
            ,SURVEY_QUESTION_NAME_OLD_SAIJO_ID
            ,SURVEY_QUESTION_NAME_OLD_KASOBA_ID
            ,SURVEY_QUESTION_NAME_OLD_SEKO_DATE
            ,SURVEY_QUESTION_NAME_OLD_PLAN_TYPE_NAME
            ,SURVEY_QUESTION_NAME_OLD_DEATH_AGE
            ,SURVEY_QUESTION_NAME_OLD_MOSHU_AGE
            ,SURVEY_QUESTION_NAME_OLD_MOSHU_GENDER
    };
    global static final List<String> SURVEY_WEB_POSTING_EXCLUSIVE_QUESTION_RESPONSE_LIST = new List<String> {
            'YS005', 'YS007', 'YS009', 'YS011', 'YS012', 'YS013', 'YS014', 'YS015'
            ,'CS004', 'CS006', 'CS008', 'CS009', 'CS010', 'CS011', 'CS012', 'CS013'
            ,'SG001', 'SG002', 'SG003', 'SG004', 'SG005', 'SG006', 'SG007', 'SG008', 'SG009'
            ,'SJ002', 'SJ004', 'SJ006'
            ,'KS002', 'KS004'
            ,'OB001', 'OB002', 'OB003', 'OB004', 'OB005'
            ,'OB006', 'OB007', 'OB008', 'OB009', 'OB010'
            ,'OB011', 'OB012', 'OB013', 'OB014', 'OB015'
            ,SURVEY_QUESTION_NAME_LAST_TROUBLE
            ,SURVEY_QUESTION_NAME_LAST_INTEREST_SERVICES
            ,SURVEY_QUESTION_NAME_LAST_TEL_GOOD_TIME
    };
    global static final Map<String, String> SURVEY_WEB_POSTING_CONVERT_PICKUPSTAR_TO_NUMBER_LIST = new Map<String, String> {
        '★★★★★ とても満足' => '5'
        ,'★★★★☆ まあまあ満足' => '4'
        ,'★★★☆☆ 普通' => '3'
        ,'★★☆☆☆ やや不満' => '2'
        ,'★☆☆☆☆ 不満' => '1'
    };
    global static final List<String> SURVEY_WEB_POSTING_REQUIRED_LIST = new List<String> {
            'YS003', 'YS006'
            ,'CS001', 'CS003', 'CS005','CS007', 'CS009','CS011'
            ,'SJ001', 'SJ003', 'SJ005'
            ,'KS001', 'KS003'
    };
}