public with sharing class Com_Message {

  public static final String MSG_0001 = '例';


    //エラーメッセージ
  public static final String ERROR_MESSE_SYSTEM ='システムエラーが発生しました。開発部にお問合せください。';

  //入力チェックメッセージ
  public static final String INPUT_CHK_NO_SOUGISYANAME      = '葬儀社名の入力がありません。 ';
  public static final String INPUT_CHK_NO_AMOUNT          = '最終決定合計金額の入力がありません。 ';
  public static final String INPUT_CHK_NO_TESURYO          = '手数料の入力がありません。 ';
  public static final String INPUT_CHK_NO_SIHRAIHOUHOU      = '支払方法の入力がありません。 ';
  public static final String INPUT_CHK_NO_NYUUKINSHIME      = '入金締日の入力がありません。 ';
  public static final String INPUT_CHK_NO_SOUGIPLANSAISYU      = '葬儀プラン（最終）の入力がありません。 ';
  public static final String INPUT_CHK_NO_SOUGISYASHIHARAIKIJITU  = '葬儀社支払い期日の入力がありません。 ';
  public static final String INPUT_CHK_NO_CARDLOANKESSAIKINGAKU  = 'カードローン決済金額の入力がありません。 ';
  public static final String INPUT_CHK_NO_KEIRIRENKEI_CODE    = '経理連携取引先コードの入力がありません。 ';
  public static final String INPUT_CHK_NO_HOUYOUBI        = '法要日の入力がありません。 ';
  public static final String INPUT_CHK_NO_JIINMEI          = '寺院名の入力がありません。 ';
  public static final String INPUT_CHK_NO_WARIBIKITEKIYOUGOPLANKINGAKU = '割引適用後プラン金額の入力がありません。 ';
  public static final String INPUT_CHK_NO_PULANTESURYO      = 'プラン手数料の入力がありません。 ';

  public static final String INPUT_CHK_NO_TEHAIKUBUN        = '手配区分の入力がありません。 ';
  public static final String INPUT_CHK_NO_MADOGUCHI        = '窓口の入力がありません。 ';
  public static final String INPUT_CHK_NO_ENTRANCE        = '入口の入力がありません。 ';
  public static final String INPUT_CHK_NO_SENDINGDATE        = 'チケット送付日の入力がありません。 ';
  public static final String INPUT_CHK_NO_JIINSIHARAIKINGAKU    = '寺院支払金額の入力がありません。 ';
  public static final String INPUT_CHK_NO_JIINSIRAIKIGEN      = '寺院支払期限の入力がありません。 ';

  //売上表関係メッセージ
  public static final String URIAGE_LOCK_MESSAGE       = '売上確定済みのため編集できません。';
  public static final String NO_SELECT_URIAGE_TARGET     = '売上確定対象商談を選択してください。';
  public static final String NO_SELECT_SENDING_TARGET   = 'チケット送付伝票作成対象商談を選択してください。';
  public static final String SUCCESS_KAKUTEI        = '確定処理を行いました。';

  //その他
  public static final String OVERLISTSIZELIMIT       = '検索条件で得られる結果が1000件を超えています。1000件目以降は表示されません。';
}