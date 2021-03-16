/**
 * 共通ユーティリティクラス
 */
public class Com_Utility {
  
  /**
   * 電話番号を日本国内形式に変換します。
   * ※日本国内番号のみ対応。
   * @param  phoneNumber 電話番号
   * @return             国内形式電話番号(0開始)
   */
  public static String convertPhoneNumberToJPFormat(String phoneNumber) {
    String JP_PHONE_NUMBER_PREFIX = '+81';
    return phoneNumber.replace(JP_PHONE_NUMBER_PREFIX, '0');
  }

    /**
     * 携帯電話番号判定
     * @param  phoneNumber 電話番号
     * @return true:携帯電話、false:その他
     */
    public static Boolean isMobile(String phoneNumber) {
        if(phoneNumber != null && (phoneNumber.startsWith('070') || phoneNumber.startsWith('080') || phoneNumber.startsWith('090'))) return true;
        return false;
    }

    public static String conversionJpCalendar(Date d) {
        return JpCalendar.convertSeirekiToWareki(d);
    }

    /**
    　* エラーメッセージ表示処理
     * エラーメッセージ、発生原因、行数を表示します。
    　*@param Exception e
     *@return void
    　*/
    public static void msgError(Exception e) {
        // Exceptionメッセージを表示
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
        // エラーメッセージを表示
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Com_Message.ERROR_MESSE_SYSTEM));
        // エラー発生原因を表示
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
            'Line:' + String.valueOf(e.getLineNumber()) + '【' + e.getTypeName() + '】'));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getStackTraceString()));
    }


    /**
    　* 半角カタカナを全角カタカナに変換
    　*@param String targetStr
     *@return replaceStr
    　*/
    public static String ZenkakuReplace(String targetStr){


        // 全角カナ変換時のMap
        Map<String,String> toZenkakuMap = new Map<String, String>

        {'ｱ' => 'ア', 'ｲ' => 'イ', 'ｳ' => 'ウ', 'ｴ' => 'エ', 'ｵ' => 'オ'
        ,'ｶ' => 'カ', 'ｷ' => 'キ', 'ｸ' => 'ク', 'ｹ' => 'ケ', 'ｺ' => 'コ'
        ,'ｻ' => 'サ', 'ｼ' => 'シ', 'ｽ' => 'ス', 'ｾ' => 'セ', 'ｿ' => 'ソ'
        ,'ﾀ' => 'タ', 'ﾁ' => 'チ', 'ﾂ' => 'ツ', 'ﾃ' => 'テ', 'ﾄ' => 'ト'
        ,'ﾅ' => 'ナ', 'ﾆ' => 'ニ', 'ﾇ' => 'ヌ', 'ﾈ' => 'ネ', 'ﾉ' => 'ノ'
        ,'ﾊ' => 'ハ', 'ﾋ' => 'ヒ', 'ﾌ' => 'フ', 'ﾍ' => 'ヘ', 'ﾎ' => 'ホ'
        ,'ﾏ' => 'マ', 'ﾐ' => 'ミ', 'ﾑ' => 'ム', 'ﾒ' => 'メ', 'ﾓ' => 'モ'
        ,'ﾔ' => 'ヤ', 'ﾕ' => 'ユ', 'ﾖ' => 'ヨ', 'ﾜ' => 'ワ', 'ｦ' => 'ヲ'
        ,'ﾝ' => 'ン', 'ﾗ' => 'ラ', 'ﾘ' => 'リ', 'ﾙ' => 'ル', 'ﾚ' => 'レ'
        ,'ﾛ' => 'ロ', 'ｶﾞ' => 'ガ', 'ｷﾞ' => 'ギ', 'ｸﾞ' => 'グ', 'ｹﾞ' => 'ゲ'
        ,'ｺﾞ' => 'ゴ', 'ｻﾞ' => 'ザ', 'ｼﾞ' => 'ジ', 'ｽﾞ' => 'ズ', 'ｾﾞ' => 'ゼ'
        ,'ｿﾞ' => 'ゾ', 'ﾀﾞ' => 'ダ', 'ﾁﾞ' => 'ヂ', 'ﾂﾞ' => 'ヅ', 'ﾃﾞ' => 'デ'
        ,'ﾄﾞ' => 'ド', 'ﾊﾞ' => 'バ', 'ﾋﾞ' => 'ビ', 'ﾌﾞ' => 'ブ', 'ﾍﾞ' => 'ベ'
        ,'ﾎﾞ' => 'ボ', 'ﾊﾟ' => 'パ', 'ﾋﾟ' => 'ピ', 'ﾌﾟ' => 'プ', 'ﾍﾟ' => 'ペ'
        ,'ﾎﾟ' => 'ポ', 'ｧ' => 'ァ', 'ｨﾟ' => 'ィ', 'ｩ' => 'ゥ', 'ｪ' => 'ェ'
        ,'-' => 'ー', ' ' => '　', '\\.' => '．', '\\(' => '（', '\\)' => '）', '･' => '・'
        ,'ｫ' => 'ォ', 'ｯ' => 'ッ', 'ｬ' => 'ャ', 'ｭ' => 'ュ', 'ｮ' => 'ョ'
        ,'1' => '１', '2' => '２', '3' => '３', '4' => '４', '5' => '５'
        ,'6' => '６', '7' => '７', '8' => '８', '9' => '９', '0' => '０'
        ,'a' => 'ａ', 'b' => 'ｂ', 'c' => 'ｃ', 'd' => 'ｄ', 'e' => 'ｅ'
        ,'f' => 'ｆ', 'g' => 'ｇ', 'h' => 'ｈ', 'i' => 'ｉ', 'j' => 'ｊ'
        ,'k' => 'ｋ', 'l' => 'ｌ', 'm' => 'ｍ', 'n' => 'ｎ', 'o' => 'ｏ'
        ,'p' => 'ｐ', 'q' => 'ｑ', 'r' => 'ｒ', 's' => 'ｓ', 't' => 'ｔ'
        ,'u' => 'ｕ', 'v' => 'ｖ', 'w' => 'ｗ', 'x' => 'ｘ', 'y' => 'ｙ'
        ,'z' => 'ｚ'
        ,'A' => 'Ａ', 'B' => 'Ｂ', 'C' => 'Ｃ', 'D' => 'Ｄ', 'E' => 'Ｅ'
        ,'F' => 'Ｆ', 'G' => 'Ｇ', 'H' => 'Ｈ', 'I' => 'Ｉ', 'J' => 'Ｊ'
        ,'K' => 'Ｋ', 'L' => 'Ｌ', 'M' => 'Ｍ', 'N' => 'Ｎ', 'O' => 'Ｏ'
        ,'P' => 'Ｐ', 'Q' => 'Ｑ', 'R' => 'Ｒ', 'S' => 'Ｓ', 'T' => 'Ｔ'
        ,'U' => 'Ｕ', 'V' => 'Ｖ', 'W' => 'Ｗ', 'X' => 'Ｘ', 'Y' => 'Ｙ'
        ,'Z' => 'Ｚ'};



        String replaceStr = '';
        for(Integer i = 0; i < targetStr.length(); i++){

            String charOne = targetStr.substring(i,i+1);
            if(toZenkakuMap.containsKey(charOne)){
                replaceStr += toZenkakuMap.get(charOne);
            }else{
                replaceStr += charOne;
            }
        }
        
        return replaceStr;
    }



    /**
    　* 全角カタカナを半角カタカナに変換
    　*@param String targetStr
     *@return replaceStr
    　*/
    public static String HankakuReplace(String targetStr){


        // 全角カナ変換時のMap
        Map<String,String> toHankakuMap = new Map<String, String>

        {'ア' => 'ｱ', 'イ' => 'ｲ', 'ウ' => 'ｳ', 'エ' => 'ｴ', 'オ' => 'ｵ'
        ,'カ' => 'ｶ', 'キ' => 'ｷ', 'ク' => 'ｸ', 'ケ' => 'ｹ', 'コ' => 'ｺ'
        ,'サ' => 'ｻ', 'シ' => 'ｼ', 'ス' => 'ｽ', 'セ' => 'ｾ', 'ソ' => 'ｿ'
        ,'タ' => 'ﾀ', 'チ' => 'ﾁ', 'ツ' => 'ﾂ', 'テ' => 'ﾃ', 'ト' => 'ﾄ'
        ,'ナ' => 'ﾅ', 'ニ' => 'ﾆ', 'ヌ' => 'ﾇ', 'ネ' => 'ﾈ', 'ノ' => 'ﾉ'
        ,'ハ' => 'ﾊ', 'ヒ' => 'ﾋ', 'フ' => 'ﾌ', 'ヘ' => 'ﾍ', 'ホ' => 'ﾎ'
        ,'マ' => 'ﾏ', 'ミ' => 'ﾐ', 'ム' => 'ﾑ', 'メ' => 'ﾒ', 'モ' => 'ﾓ'
        ,'ヤ' => 'ﾔ', 'ユ' => 'ﾕ', 'ヨ' => 'ﾖ', 'ワ' => 'ﾜ', 'ヲ' => 'ｦ'
        ,'ン' => 'ﾝ', 'ラ' => 'ﾗ', 'リ' => 'ﾘ', 'ル' => 'ﾙ', 'レ' => 'ﾚ'
        ,'ロ' => 'ﾛ', 'ガ' => 'ｶﾞ', 'ギ' => 'ｷﾞ', 'グ' => 'ｸﾞ', 'ゲ' => 'ｹﾞ'
        ,'ゴ' => 'ｺﾞ', 'ザ' => 'ｻﾞ', 'ジ' => 'ｼﾞ', 'ズ' => 'ｽﾞ', 'ゼ' => 'ｾﾞ'
        ,'ゾ' => 'ｿﾞ', 'ダ' => 'ﾀﾞ', 'ヂ' => 'ﾁﾞ', 'ヅ' => 'ﾂﾞ', 'デ' => 'ﾃﾞ'
        ,'ド' => 'ﾄﾞ', 'バ' => 'ﾊﾞ', 'ビ' => 'ﾋﾞ', 'ブ' => 'ﾌﾞ', 'ベ' => 'ﾍﾞ'
        ,'ボ' => 'ﾎﾞ', 'パ' => 'ﾊﾟ', 'ピ' => 'ﾋﾟ', 'プ' => 'ﾌﾟ', 'ペ' => 'ﾍﾟ'
        ,'ポ' => 'ﾎﾟ', 'ァ' => 'ｧ', 'ィ' => 'ｨﾟ', 'ゥ' => 'ｩ', 'ェ' => 'ｪ'
        ,'ー' => '-', '－' => '-', '―' => '-'
        ,'　' => ' ', '．' => '\\.', '（' => '\\(', '）' => '）', '･' => '・'
        ,'ォ' => 'ｫ', 'ッ' => 'ｯ', 'ャ' => 'ｬ', 'ュ' => 'ｭ', 'ョ' => 'ｮ'
        ,'１' => '1', '２' => '2', '３' => '3', '４' => '4', '５' => '5'
        ,'６' => '6', '７' => '7', '８' => '8', '９' => '9', '０' => '0'
        ,'ａ' => 'a', 'ｂ' => 'b', 'ｃ' => 'c', 'ｄ' => 'd', 'ｅ' => 'e'
        ,'ｆ' => 'f', 'ｇ' => 'g', 'ｈ' => 'h', 'ｉ' => 'i', 'ｊ' => 'i'
        ,'ｋ' => 'k', 'ｌ' => 'l', 'ｍ' => 'm', 'ｎ' => 'n', 'ｏ' => 'o'
        ,'ｐ' => 'p', 'ｑ' => 'q', 'ｒ' => 'r', 'ｓ' => 's', 'ｔ' => 't'
        ,'ｕ' => 'u', 'ｖ' => 'v', 'ｗ' => 'w', 'ｘ' => 'x', 'ｙ' => 'y'
        ,'ｚ' => 'z'
        ,'Ａ' => 'A', 'Ｂ' => 'B', 'Ｃ' => 'C', 'Ｄ' => 'D', 'Ｅ' => 'E'
        ,'Ｆ' => 'F', 'Ｇ' => 'G', 'Ｈ' => 'H', 'Ｉ' => 'I', 'Ｊ' => 'J'
        ,'Ｋ' => 'K', 'Ｌ' => 'L', 'Ｍ' => 'M', 'Ｎ' => 'N', 'Ｏ' => 'O'
        ,'Ｐ' => 'P', 'Q' => 'Ｑ', 'Ｒ' => 'R', 'Ｓ' => 'S', 'Ｔ' => 'T'
        ,'Ｕ' => 'U', 'V' => 'Ｖ', 'Ｗ' => 'W', 'Ｘ' => 'X', 'Ｙ' => 'Y'
        ,'Ｚ' => 'Z'};



        String replaceStr = '';
        for(Integer i = 0; i < targetStr.length(); i++){

            String charOne = targetStr.substring(i,i+1);
            if(toHankakuMap.containsKey(charOne)){
                replaceStr += toHankakuMap.get(charOne);
            }else{
                replaceStr += charOne;
            }
        }

        return replaceStr;
    }


    public static Date toDate(String strDate){
        try{
            return Date.valueOf(strDate);
        }
        catch(Exception e){
            return null;
        }
    }

    public static DateTime toDateTime(String strDateTime){
        try{
            return DateTime.valueOf(strDateTime);
        }
        catch(Exception e){
            return null;
        }
    }


    // DateTime型をData型に変換する
    public static Date DateTimeToDateConversion(DateTime targetDateTime){

        if(targetDateTime == null ) return null;

        Date replaceDate = targetDateTime.date();
        return replaceDate;
    }

    /**
     * パッディング：左ゼロ埋め
     * @param String 数値文字列
     * @param Integer 桁数（数値の桁を含める）
     * @return String 左ゼロ埋め文字列
     */
    public static String paddingLeftZero(String n, Integer len) {
        Integer nlen = n.length();
        if(nlen >= len) return String.valueOf(n);
        String s = '';
        for(Integer i=0, l=len-nlen; i<l; i++) {
            s += '0';
        }
        return s + n;
    }

    /**
     * メール送信
     * @param String Toアドレス
     * @param String 件名
     * @param String 本文
     */
    public static void sendEmail(String strToAddres, String strSubject, String strText) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(new String[]{strToAddres});
        message.setSubject(strSubject);
        message.setPlainTextBody(strText);
        message.setUseSignature(false);
        messages.add(message);
        Messaging.sendEmail(messages);
    }

    /**
     * メール送信
     * @param String Toアドレス
     * @param String 件名
     * @param String 本文
     */
    public static void sendEmail(List<String> strToAddressList, String strSubject, String strText) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setToAddresses(strToAddressList);
        message.setSubject(strSubject);
        message.setPlainTextBody(strText);
        message.setUseSignature(false);
        messages.add(message);
        Messaging.sendEmail(messages);
    }
}