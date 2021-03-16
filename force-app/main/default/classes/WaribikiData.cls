public class WaribikiData {
    public static String WARIBKI_TYPE_POSTAL = 'ポスタルくらぶ割';
    public static String WARIBKI_TYPE_OLD_JIZENWARI = '旧事前割';
    public static String WARIBKI_TYPE_MURYOU = 'よりそうメンバ割 / 無料メンバ';
    public static String WARIBKI_TYPE_ITTEIJOKEN = 'よりそうメンバ割 / WEB事前準備無料メンバ';
    public static String WARIBKI_TYPE_JIZENWARIMEMBER = 'よりそうメンバ割 / 事前割メンバ';
    public static String WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER = 'よりそうメンバ割 / お葬式予約メンバ';
    public static String WARIBKI_TYPE_OLDSIRYOUSEIKYU = '資料請求割 / 旧資料請求割';
    public static String WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU = '資料請求割 / 安豪資料請求割';

    private class WaribikiBean {
        public String key;
        public String waribkiShohinBango;     // 割引番号
        private String shohinName;    // 商品名
        private String shohinBango;     // 商品番号
        private String waribkiShohinName;     // 割引商品名
        private Integer waribkiKinngaku;     // 割引金額
        private String waribkiType;     // 割引金額

        public WaribikiBean(String shohinName, String shohinBango,  String waribkiShohinName, String waribkiShohinBango, Integer waribkiKinngaku, String waribkiType){
                this.shohinName = shohinName;
                this.shohinBango = shohinBango;
                this.waribkiShohinBango = waribkiShohinBango;
                this.waribkiKinngaku = waribkiKinngaku;
                this.waribkiType = waribkiType;
                this.waribkiShohinName = waribkiShohinName;
                this.key = shohinBango + waribkiType;
        }
    }

    private static Map<String, List<WaribikiBean>> waribikiMap;

    public WaribikiData(){
        if(waribikiMap == null){
            initMap();
        }
    }

    private void initMap(){
        waribikiMap = new Map<String, List<WaribikiBean>>();
        waribikiMap.put('SBG-0000001'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　直葬プラン[2019/9/30迄]','SBG-0000001','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000001'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　直葬プラン[2019/9/30迄]','SBG-0000001','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000001'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　直葬プラン[2019/9/30迄]','SBG-0000001','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000001'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　直葬プラン[2019/9/30迄]','SBG-0000001','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000001'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　直葬プラン[2019/9/30迄]','SBG-0000001','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000002'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','シンプルなお葬式　旧事前割・無償事前割 (火葬式)[2019/9/30迄]','SBG-0000201',-15000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000002'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','シンプルなお葬式　旧事前割・無償事前割 (火葬式)[2019/9/30迄]','SBG-0000201',-15000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000002'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000002'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ), 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000002'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','シンプルなお葬式　事前割メンバー割引 (火葬式)[2019/9/30迄]','SBG-0000191',-15000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000002'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','シンプルなお葬式　お葬式予約メンバー割引 (火葬式)[2019/9/30迄]','SBG-0000196',-20000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000002'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]','SBG-0000002','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000003'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','シンプルなお葬式　旧事前割・無償事前割 (火葬式)[2019/9/30迄]','SBG-0000201',-15000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000003'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','シンプルなお葬式　旧事前割・無償事前割 (火葬式)[2019/9/30迄]','SBG-0000201',-15000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000003'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000003'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000003'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','シンプルなお葬式　事前割メンバー割引 (火葬式)[2019/9/30迄]','SBG-0000191',-15000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000003'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','シンプルなお葬式　お葬式予約メンバー割引 (火葬式)[2019/9/30迄]','SBG-0000196',-20000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000003'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]','SBG-0000003','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000004'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','シンプルなお葬式　旧事前割・無償事前割 (火葬式)[2019/9/30迄]','SBG-0000201',-15000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000004'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','シンプルなお葬式　旧事前割・無償事前割 (火葬式)[2019/9/30迄]','SBG-0000201',-15000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000004'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000004'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000004'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','シンプルなお葬式　事前割メンバー割引 (火葬式)[2019/9/30迄]','SBG-0000191',-15000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000004'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','シンプルなお葬式　お葬式予約メンバー割引 (火葬式)[2019/9/30迄]','SBG-0000196',-20000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000004'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]','SBG-0000004','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000005'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','シンプルなお葬式　旧事前割・無償事前割(一日葬)[2019/9/30迄]','SBG-0000202',-15000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000005'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','シンプルなお葬式　旧事前割・無償事前割(一日葬)[2019/9/30迄]','SBG-0000202',-15000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000005'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000005'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000005'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','シンプルなお葬式　事前割メンバー割引 (一日葬)[2019/9/30迄]','SBG-0000192',-15000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000005'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','シンプルなお葬式　お葬式予約メンバー割引 (一日葬)[2019/9/30迄]','SBG-0000197',-25000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000005'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]','SBG-0000005','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000006'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','シンプルなお葬式　旧事前割・無償事前割(一日葬)[2019/9/30迄]','SBG-0000202',-15000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000006'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','シンプルなお葬式　旧事前割・無償事前割(一日葬)[2019/9/30迄]','SBG-0000202',-15000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000006'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000006'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000006'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','シンプルなお葬式　事前割メンバー割引 (一日葬)[2019/9/30迄]','SBG-0000192',-15000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000006'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','シンプルなお葬式　お葬式予約メンバー割引 (一日葬)[2019/9/30迄]','SBG-0000197',-25000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000006'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]','SBG-0000006','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000007'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','シンプルなお葬式　旧事前割・無償事前割(一日葬)[2019/9/30迄]','SBG-0000202',-15000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000007'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','シンプルなお葬式　旧事前割・無償事前割(一日葬)[2019/9/30迄]','SBG-0000202',-15000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000007'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000007'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000007'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','シンプルなお葬式　事前割メンバー割引 (一日葬)[2019/9/30迄]','SBG-0000192',-15000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000007'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','シンプルなお葬式　お葬式予約メンバー割引 (一日葬)[2019/9/30迄]','SBG-0000197',-25000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000007'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]','SBG-0000007','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000008'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','シンプルなお葬式　旧事前割・無償事前割(家族葬)[2019/9/30迄]','SBG-0000203',-30000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000008'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','シンプルなお葬式　旧事前割・無償事前割(家族葬)[2019/9/30迄]','SBG-0000203',-30000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000008'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000008'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000008'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','シンプルなお葬式　事前割メンバー割引 (家族葬)[2019/9/30迄]','SBG-0000193',-30000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000008'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','シンプルなお葬式　お葬式予約メンバー割引 (家族葬)[2019/9/30迄]','SBG-0000198',-50000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000008'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]','SBG-0000008','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000009'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','シンプルなお葬式　旧事前割・無償事前割(家族葬)[2019/9/30迄]','SBG-0000203',-30000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000009'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','シンプルなお葬式　旧事前割・無償事前割(家族葬)[2019/9/30迄]','SBG-0000203',-30000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000009'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000009'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000009'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','シンプルなお葬式　事前割メンバー割引 (家族葬)[2019/9/30迄]','SBG-0000193',-30000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000009'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','シンプルなお葬式　お葬式予約メンバー割引 (家族葬)[2019/9/30迄]','SBG-0000198',-50000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000009'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]','SBG-0000009','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000010'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','シンプルなお葬式　旧事前割・無償事前割(家族葬)[2019/9/30迄]','SBG-0000203',-30000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000010'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','シンプルなお葬式　旧事前割・無償事前割(家族葬)[2019/9/30迄]','SBG-0000203',-30000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000010'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000010'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000010'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','シンプルなお葬式　事前割メンバー割引 (家族葬)[2019/9/30迄]','SBG-0000193',-30000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000010'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','シンプルなお葬式　お葬式予約メンバー割引 (家族葬)[2019/9/30迄]','SBG-0000198',-50000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000010'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]','SBG-0000010','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000011'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','シンプルなお葬式　旧事前割・無償事前割 (一般葬)[2019/9/30迄]','SBG-0000204',-50000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000011'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','シンプルなお葬式　旧事前割・無償事前割 (一般葬)[2019/9/30迄]','SBG-0000204',-50000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000011'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000011'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000011'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','シンプルなお葬式　事前割メンバー割引 (一般葬)[2019/9/30迄]','SBG-0000194',-50000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000011'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','シンプルなお葬式　お葬式予約メンバー割引 (一般葬)[2019/9/30迄]','SBG-0000199',-70000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000011'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]','SBG-0000011','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000012'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','シンプルなお葬式　旧事前割・無償事前割 (一般葬)[2019/9/30迄]','SBG-0000204',-50000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000012'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','シンプルなお葬式　旧事前割・無償事前割 (一般葬)[2019/9/30迄]','SBG-0000204',-50000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000012'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000012'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000012'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','シンプルなお葬式　事前割メンバー割引 (一般葬)[2019/9/30迄]','SBG-0000194',-50000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000012'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','シンプルなお葬式　お葬式予約メンバー割引 (一般葬)[2019/9/30迄]','SBG-0000199',-70000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000012'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]','SBG-0000012','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000013'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','シンプルなお葬式　旧事前割・無償事前割 (一般葬)[2019/9/30迄]','SBG-0000204',-50000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0000013'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','シンプルなお葬式　旧事前割・無償事前割 (一般葬)[2019/9/30迄]','SBG-0000204',-50000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0000013'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0000013'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','シンプルなお葬式　無料メンバー割引[2019/9/30迄]','SBG-0000189',-5000,WARIBKI_TYPE_MURYOU ),
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','メンバー　WEB事前準備シート記入割引[2019/9/30迄]','SBG-0000205',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0000013'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','シンプルなお葬式　事前割メンバー割引 (一般葬)[2019/9/30迄]','SBG-0000194',-50000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0000013'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','シンプルなお葬式　お葬式予約メンバー割引 (一般葬)[2019/9/30迄]','SBG-0000199',-70000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0000013'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]','SBG-0000013','シンプルなお葬式　資料請求割引[2019/9/30迄]','SBG-0000215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000100'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　火葬式　16.8万円プラン[2019/9/30迄]','SBG-0000100','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000101'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　火葬式　19.8万円プラン[2019/9/30迄]','SBG-0000101','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000102'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　火葬式　21.8万円プラン[2019/9/30迄]','SBG-0000102','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000103'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　一日葬　32.8万円プラン[2019/9/30迄]','SBG-0000103','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000104'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　一日葬　34.8万円プラン[2019/9/30迄]','SBG-0000104','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000105'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　一日葬　36.8万円プラン[2019/9/30迄]','SBG-0000105','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000106'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　家族葬　48.8万円プラン[2019/9/30迄]','SBG-0000106','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000107'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　家族葬　50.8万円プラン[2019/9/30迄]','SBG-0000107','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0000108'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　家族葬　52.8万円プラン[2019/9/30迄]','SBG-0000108','安くて豪華なお葬式　資料請求割引[2019/9/30迄]','SBG-0000200',-5000,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );

        // 201910消費税対応
        waribikiMap.put('SBG-0001001'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　直葬プラン','SBG-0001001','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001001'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　直葬プラン','SBG-0001001','よりそうのお葬式　WEB事前準備メンバー割引（直葬）','SBG-0002001',-5500,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001001'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　直葬プラン','SBG-0001001','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001001'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　直葬プラン','SBG-0001001','よりそうのお葬式　お葬式予約メンバー割引 (直葬)','SBG-0001195',-5500,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001001'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　直葬プラン','SBG-0001001','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001002'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　無宗教プラン','SBG-0001002','よりそうのお葬式　旧事前割・無償事前割 (火葬式)','SBG-0001201',-16500,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001002'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　無宗教プラン','SBG-0001002','よりそうのお葬式　旧事前割・無償事前割 (火葬式)','SBG-0001201',-16500,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001002'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　無宗教プラン','SBG-0001002','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001002'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　無宗教プラン','SBG-0001002','よりそうのお葬式　WEB事前準備メンバー割引（火葬式）','SBG-0002002',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001002'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　無宗教プラン','SBG-0001002','よりそうのお葬式　事前割メンバー割引 (火葬式)','SBG-0001191',-16500,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001002'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　無宗教プラン','SBG-0001002','よりそうのお葬式　お葬式予約メンバー割引 (火葬式)','SBG-0001196',-22000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001002'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　無宗教プラン','SBG-0001002','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001003'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　仏式プラン','SBG-0001003','よりそうのお葬式　旧事前割・無償事前割 (火葬式)','SBG-0001201',-16500,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001003'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　仏式プラン','SBG-0001003','よりそうのお葬式　旧事前割・無償事前割 (火葬式)','SBG-0001201',-16500,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001003'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　仏式プラン','SBG-0001003','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001003'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　仏式プラン','SBG-0001003','よりそうのお葬式　WEB事前準備メンバー割引（火葬式）','SBG-0002002',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001003'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　仏式プラン','SBG-0001003','よりそうのお葬式　事前割メンバー割引 (火葬式)','SBG-0001191',-16500,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001003'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　仏式プラン','SBG-0001003','よりそうのお葬式　お葬式予約メンバー割引 (火葬式)','SBG-0001196',-22000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001003'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　仏式プラン','SBG-0001003','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001004'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　花束プラン','SBG-0001004','よりそうのお葬式　旧事前割・無償事前割 (火葬式)','SBG-0001201',-16500,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001004'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　花束プラン','SBG-0001004','よりそうのお葬式　旧事前割・無償事前割 (火葬式)','SBG-0001201',-16500,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001004'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　花束プラン','SBG-0001004','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001004'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　花束プラン','SBG-0001004','よりそうのお葬式　WEB事前準備メンバー割引（火葬式）','SBG-0002002',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001004'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　花束プラン','SBG-0001004','よりそうのお葬式　事前割メンバー割引 (火葬式)','SBG-0001191',-16500,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001004'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　花束プラン','SBG-0001004','よりそうのお葬式　お葬式予約メンバー割引 (火葬式)','SBG-0001196',-22000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001004'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　火葬式　花束プラン','SBG-0001004','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001005'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　無宗教プラン','SBG-0001005','よりそうのお葬式　旧事前割・無償事前割(一日葬)','SBG-0001202',-16500,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001005'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　無宗教プラン','SBG-0001005','よりそうのお葬式　旧事前割・無償事前割(一日葬)','SBG-0001202',-16500,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001005'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　無宗教プラン','SBG-0001005','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001005'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　無宗教プラン','SBG-0001005','よりそうのお葬式　WEB事前準備メンバー割引（一日葬）','SBG-0002003',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001005'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　無宗教プラン','SBG-0001005','よりそうのお葬式　事前割メンバー割引 (一日葬)','SBG-0001192',-16500,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001005'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　無宗教プラン','SBG-0001005','よりそうのお葬式　お葬式予約メンバー割引 (一日葬)','SBG-0001197',-27500,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001005'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　無宗教プラン','SBG-0001005','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001006'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　仏式プラン','SBG-0001006','よりそうのお葬式　旧事前割・無償事前割(一日葬)','SBG-0001202',-16500,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001006'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　仏式プラン','SBG-0001006','よりそうのお葬式　旧事前割・無償事前割(一日葬)','SBG-0001202',-16500,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001006'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　仏式プラン','SBG-0001006','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001006'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　仏式プラン','SBG-0001006','よりそうのお葬式　WEB事前準備メンバー割引（一日葬）','SBG-0002003',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001006'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　仏式プラン','SBG-0001006','よりそうのお葬式　事前割メンバー割引 (一日葬)','SBG-0001192',-16500,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001006'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　仏式プラン','SBG-0001006','よりそうのお葬式　お葬式予約メンバー割引 (一日葬)','SBG-0001197',-27500,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001006'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　仏式プラン','SBG-0001006','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001007'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　お花増量プラン','SBG-0001007','よりそうのお葬式　旧事前割・無償事前割(一日葬)','SBG-0001202',-16500,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001007'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　お花増量プラン','SBG-0001007','よりそうのお葬式　旧事前割・無償事前割(一日葬)','SBG-0001202',-16500,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001007'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　お花増量プラン','SBG-0001007','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001007'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　お花増量プラン','SBG-0001007','よりそうのお葬式　WEB事前準備メンバー割引（一日葬）','SBG-0002003',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001007'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　お花増量プラン','SBG-0001007','よりそうのお葬式　事前割メンバー割引 (一日葬)','SBG-0001192',-16500,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001007'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　お花増量プラン','SBG-0001007','よりそうのお葬式　お葬式予約メンバー割引 (一日葬)','SBG-0001197',-27500,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001007'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一日葬　お花増量プラン','SBG-0001007','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001008'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　無宗教プラン','SBG-0001008','よりそうのお葬式　旧事前割・無償事前割(家族葬)','SBG-0001203',-33000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001008'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　無宗教プラン','SBG-0001008','よりそうのお葬式　旧事前割・無償事前割(家族葬)','SBG-0001203',-33000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001008'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　無宗教プラン','SBG-0001008','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001008'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　無宗教プラン','SBG-0001008','よりそうのお葬式　WEB事前準備メンバー割引（家族葬）','SBG-0002004',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001008'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　無宗教プラン','SBG-0001008','よりそうのお葬式　事前割メンバー割引 (家族葬)','SBG-0001193',-30000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001008'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　無宗教プラン','SBG-0001008','よりそうのお葬式　お葬式予約メンバー割引 (家族葬)','SBG-0001198',-55000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001008'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　無宗教プラン','SBG-0001008','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001009'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　仏式プラン','SBG-0001009','よりそうのお葬式　旧事前割・無償事前割(家族葬)','SBG-0001203',-33000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001009'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　仏式プラン','SBG-0001009','よりそうのお葬式　旧事前割・無償事前割(家族葬)','SBG-0001203',-33000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001009'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　仏式プラン','SBG-0001009','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001009'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　仏式プラン','SBG-0001009','よりそうのお葬式　WEB事前準備メンバー割引（家族葬）','SBG-0002004',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001009'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　仏式プラン','SBG-0001009','よりそうのお葬式　事前割メンバー割引 (家族葬)','SBG-0001193',-30000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001009'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　仏式プラン','SBG-0001009','よりそうのお葬式　お葬式予約メンバー割引 (家族葬)','SBG-0001198',-55000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001009'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　仏式プラン','SBG-0001009','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001010'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　お花増量プラン','SBG-0001010','よりそうのお葬式　旧事前割・無償事前割(家族葬)','SBG-0001203',-33000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001010'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　お花増量プラン','SBG-0001010','よりそうのお葬式　旧事前割・無償事前割(家族葬)','SBG-0001203',-33000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001010'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　お花増量プラン','SBG-0001010','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001010'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　お花増量プラン','SBG-0001010','よりそうのお葬式　WEB事前準備メンバー割引（家族葬）','SBG-0002004',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001010'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　お花増量プラン','SBG-0001010','よりそうのお葬式　事前割メンバー割引 (家族葬)','SBG-0001193',-30000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001010'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　お花増量プラン','SBG-0001010','よりそうのお葬式　お葬式予約メンバー割引 (家族葬)','SBG-0001198',-55000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001010'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　家族葬　お花増量プラン','SBG-0001010','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001011'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　無宗教プラン','SBG-0001011','よりそうのお葬式　旧事前割・無償事前割 (一般葬)','SBG-0001204',-55000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001011'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　無宗教プラン','SBG-0001011','よりそうのお葬式　旧事前割・無償事前割 (一般葬)','SBG-0001204',-55000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001011'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　無宗教プラン','SBG-0001011','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001011'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　無宗教プラン','SBG-0001011','よりそうのお葬式　WEB事前準備メンバー割引（一般葬）','SBG-0002005',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001011'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　無宗教プラン','SBG-0001011','よりそうのお葬式　事前割メンバー割引 (一般葬)','SBG-0001194',-55000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001011'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　無宗教プラン','SBG-0001011','よりそうのお葬式　お葬式予約メンバー割引 (一般葬)','SBG-0001199',-77000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001011'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　無宗教プラン','SBG-0001011','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001012'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　仏式プラン','SBG-0001012','よりそうのお葬式　旧事前割・無償事前割 (一般葬)','SBG-0001204',-55000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001012'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　仏式プラン','SBG-0001012','よりそうのお葬式　旧事前割・無償事前割 (一般葬)','SBG-0001204',-55000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001012'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　仏式プラン','SBG-0001012','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001012'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　仏式プラン','SBG-0001012','よりそうのお葬式　WEB事前準備メンバー割引（一般葬）','SBG-0002005',-11000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001012'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　仏式プラン','SBG-0001012','よりそうのお葬式　事前割メンバー割引 (一般葬)','SBG-0001194',-55000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001012'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　仏式プラン','SBG-0001012','よりそうのお葬式　お葬式予約メンバー割引 (一般葬)','SBG-0001199',-77000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001012'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　仏式プラン','SBG-0001012','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001013'+WARIBKI_TYPE_POSTAL, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　お花増量プラン','SBG-0001013','よりそうのお葬式　旧事前割・無償事前割 (一般葬)','SBG-0001204',-55000,WARIBKI_TYPE_POSTAL ) 
        } );
        waribikiMap.put('SBG-0001013'+WARIBKI_TYPE_OLD_JIZENWARI, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　お花増量プラン','SBG-0001013','よりそうのお葬式　旧事前割・無償事前割 (一般葬)','SBG-0001204',-55000,WARIBKI_TYPE_OLD_JIZENWARI ) 
        } );
        waribikiMap.put('SBG-0001013'+WARIBKI_TYPE_MURYOU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　お花増量プラン','SBG-0001013','よりそうのお葬式　無料メンバー割引','SBG-0001189',-5500,WARIBKI_TYPE_MURYOU ) 
        } );
        waribikiMap.put('SBG-0001013'+WARIBKI_TYPE_ITTEIJOKEN, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　お花増量プラン','SBG-0001013','よりそうのお葬式　WEB事前準備メンバー割引（一般葬）','SBG-002005',-5000,WARIBKI_TYPE_ITTEIJOKEN ) 
        } );
        waribikiMap.put('SBG-0001013'+WARIBKI_TYPE_JIZENWARIMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　お花増量プラン','SBG-0001013','よりそうのお葬式　事前割メンバー割引 (一般葬)','SBG-0001194',-55000,WARIBKI_TYPE_JIZENWARIMEMBER ) 
        } );
        waribikiMap.put('SBG-0001013'+WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　お花増量プラン','SBG-0001013','よりそうのお葬式　お葬式予約メンバー割引 (一般葬)','SBG-0001199',-77000,WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER ) 
        } );
        waribikiMap.put('SBG-0001013'+WARIBKI_TYPE_OLDSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'よりそうのお葬式　一般葬　お花増量プラン','SBG-0001013','よりそうのお葬式　資料請求割引','SBG-0001215',-5000,WARIBKI_TYPE_OLDSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001100'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　火葬式　16.8万円プラン','SBG-0001100','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001101'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　火葬式　19.8万円プラン','SBG-0001101','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001102'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( '安くて豪華なお葬式　火葬式　21.8万円プラン','SBG-0001102','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001103'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'お花いっぱいのお葬式 一日葬 無宗教プラン','SBG-0001103','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001104'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'お花いっぱいのお葬式 一日葬 仏式プラン','SBG-0001104','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001105'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'お花いっぱいのお葬式 一日葬 お花増量プラン','SBG-0001105','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001106'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'お花いっぱいのお葬式 家族葬 無宗教プラン','SBG-0001106','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001107'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'お花いっぱいのお葬式 家族葬 仏式プラン','SBG-0001107','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
        waribikiMap.put('SBG-0001108'+WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU, new List<WaribikiBean> { 
            new WaribikiBean( 'お花いっぱいのお葬式 家族葬 お花増量プラン','SBG-0001108','安くて豪華なお葬式　資料請求割引','SBG-0001200',-5500,WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU ) 
        } );
    }

    public List<String> getWaribikiShohinBango(String shohinBango, String waribkiType){
        List<String> waribkiShohinBangos = new List<String>();
        String key = shohinBango + waribkiType;
        if(waribikiMap.containsKey(key)){
            for(WaribikiBean b: waribikiMap.get(key)) {
                waribkiShohinBangos.add(b.waribkiShohinBango);
            }
        }
        return waribkiShohinBangos;
    }

}