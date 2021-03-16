public class JcshMsgFmt {

    public static IMessageFormatter get_IMessageFormatter_instance(){
        return new MessageFormatter();
    }
    public interface IMessageFormatter{
        String get_message(JcshSyukeis.SyukeiResult pSyukeiResult);
    }
    public class MessageFormatter implements IMessageFormatter{
        public String get_message(JcshSyukeis.SyukeiResult pSyukeiResult){
            String a_msg_text = '';
            a_msg_text += String.format('本日の受注状況速報 ({0} 時点)\n', 
                new List<String>{ 
                    pSyukeiResult.syukei_date_time.format('yyyy/MM/dd HH:mm')
                }
            );
            a_msg_text  += '-------------------\n';
            a_msg_text  += '# 受注件数\n';
            a_msg_text += String.format('合計: {0}件\n', 
                new List<String>{
                    pSyukeiResult.jucyu_cnt.format()
                }
            );

            a_msg_text += String.format('火葬式-シンプル/死亡: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-シンプル/死亡', 0).format()
                }
            );
            a_msg_text += String.format('火葬式-シンプル/事前(not死亡): {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-シンプル/事前(not死亡)', 0).format()
                }
            );

            a_msg_text += String.format('火葬式-基本/死亡: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-基本/死亡', 0).format()
                }
            );
            a_msg_text += String.format('火葬式-基本/事前(not死亡): {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-基本/事前(not死亡)', 0).format()
                }
            );

            a_msg_text += String.format('火葬式-仏具セット/死亡: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-仏具セット/死亡', 0).format()
                }
            );
            a_msg_text += String.format('火葬式-仏具セット/事前(not死亡): {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-仏具セット/事前(not死亡)', 0).format()
                }
            );

            a_msg_text += String.format('火葬式-お花セット/死亡: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-お花セット/死亡', 0).format()
                }
            );
            a_msg_text += String.format('火葬式-お花セット/事前(not死亡): {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'火葬式-お花セット/事前(not死亡)', 0).format()
                }
            );
        
            a_msg_text += String.format('一日/死亡: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'一日/死亡', 0).format()
                }
            );
            a_msg_text += String.format('一日/事前(not死亡): {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'一日/事前(not死亡)', 0).format()
                }
            );

            a_msg_text += String.format('二日/死亡: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'二日/死亡', 0).format()
                }
            );
            a_msg_text += String.format('二日/事前(not死亡): {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'二日/事前(not死亡)', 0).format()
                }
            );

            a_msg_text += String.format('華やか/死亡: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'華やか/死亡', 0).format()
                }
            );
            a_msg_text += String.format('華やか/事前(not死亡): {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'華やか/事前(not死亡)', 0).format()
                }
            );

            a_msg_text += String.format('未分類: {0}件\n', 
                new List<String>{
                    this.get_jucyu_count_of_bunrui_code(pSyukeiResult,'未分類', 0).format()
                }
            );

            a_msg_text  += '-------------------\n';
            a_msg_text  += '# サマリ\n';
            a_msg_text += String.format('問い合わせ件数: {0}件\n', 
                new List<String>{
                    pSyukeiResult.tooiawase_cnt.format()
                }
            );
            a_msg_text += String.format('現時点のお亡くなり対応数: {0}件\n', 
                new List<String>{
                    pSyukeiResult.onakunari_taio_cnt.format()
                }
            );
            a_msg_text += String.format('受注件数: {0}件\n', 
                new List<String>{
                    pSyukeiResult.jucyu_cnt.format()
                }
            );
            a_msg_text += String.format('受注件数+お亡くなり対応数: {0}件\n', 
                new List<String>{
                    pSyukeiResult.jucyu_plus_onakunari_taio_cnt.format()
                }
            );
            a_msg_text += String.format('失注数: {0}件\n', 
                new List<String>{
                    pSyukeiResult.shiccyu_cnt.format()
                }
            );
            a_msg_text += String.format('決定率: {0}%\n', 
                new List<String>{
                    pSyukeiResult.jucyu_rate == null || pSyukeiResult.jucyu_rate < 0
                    ? '-'
                    : ( (pSyukeiResult.jucyu_rate * 10000.0).round(System.RoundingMode.HALF_EVEN) / 100.0 ).format()
                }
            );

            return a_msg_text;
        }

        private Decimal get_jucyu_count_of_bunrui_code(JcshSyukeis.SyukeiResult pSyukeiResult, String p_bunrui_code, Decimal pValue_if_not_exits){
            return pSyukeiResult.bunrui_code_to_count_map.get(p_bunrui_code) == null
            ? pValue_if_not_exits
            : pSyukeiResult.bunrui_code_to_count_map.get(p_bunrui_code);
        }
    }
}