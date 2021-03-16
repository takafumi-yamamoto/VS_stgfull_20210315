public class TcmsSougiShiryoSakusei {
    private static Map<String,String> ImageURLMap = new Map<String,String>();
    private static Map<String,String> KoueimineiSyousai = new Map<String, String>();
    private static Map<String,String> teianshoPlanImageURLMap = new Map<String,String>();   
    private static List<String> saijyoImageSortKey = new List<String>();
    public static Map<String,String> soufujyouMongonMap = new Map<String, String>();
    public String oproPdfPassWord {get;set;}
    static final Integer SAIJONAME_MAX_LENGTH = 14;
    static final Integer SAIJOICHIRAN_ACCESS_MAX_LENGTH = 38;
    public Boolean passwordIssue {get;set;}

    public class OproResult{
        public String path;
    }
    public class SougiShiryoSakuseiResult{
        public String path;
        public String password;
    }
    public class Result{
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }
 
    public TcmsSougiShiryoSakusei(){
        ImageURLMap.put('saijyoIchirancard1','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cPR&d=/a/2v000000cBZi/4cYWlDtRW75C3YAwkGWH7N8BWWnzisp3lNxhkkIiPBE&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard2','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cPq&d=/a/2v000000cBZY/XIoOm8gT39crlZ_utycBb7zDwwRJNxi9agYoH6hdAbE&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard3','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQ5&d=/a/2v000000cBZK/cvNcUIrGnDvdnea9Ck.TQVpz2gSfL_x4IMOqAWUEIEs&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard4','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQA&d=/a/2v000000cBZO/Yy7HPN5XDk6Zo4k1VmKjjruQ1rn_tWGJTt6hEzseXi8&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard5','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQF&d=/a/2v000000cBZT/d8O6yr89QyniAcdz1.dwCq3lK1QxyYza7ksl9GwtVGQ&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard6','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQP&d=/a/2v000000cBZJ/uP_PS1qB9ZFKBpuQ2xPUwnpFTTZZDoKd140r6Hfi2dI&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard7','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQU&d=/a/2v000000cBZ9/JDaUWkmq6fCWdajF9BTQtU9VKVYQwFq7EWaVvKOB2Vw&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard8','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQZ&d=/a/2v000000cBZE/xkcwnRgX5LpR601XIx9DDCI66NKzncoN2EayLcA_s2M&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard9','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQe&d=/a/2v000000cBZ4/xF5KJVWVoCZUiDIi45Byy6PLBA.EFggfgJJ35AwE3mQ&oid=00D7F000001xTd0');
        ImageURLMap.put('saijyoIchirancard10','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cQo&d=/a/2v000000cBYz/M_zkuqsflBjiYTew74jC6gCeXVa9rWwiOVTDiXqAs0A&oid=00D7F000001xTd0');
        ImageURLMap.put('kasouIchiranCard1','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cUW&d=/a/2v000000cBZn/1_7F0RyC.I.jcIvrETLUuqyGOq4BSIM5_tRWHQ.OLsM&oid=00D7F000001xTd0');
        ImageURLMap.put('kasouIchiranCard2','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1cUb&d=/a/2v000000cBZd/aSUZB7HUQx9ns0YUFmlLYlItR1vOM21PrcCc861GHmw&oid=00D7F000001xTd0');
        ImageURLMap.put('kasouIchiranTitle','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0X7Z&d=/a/2v000000cBYp/rv0HPr8G6Qvi.9e3vSTPbdFh6FH7XAnJKXYJFB7_mXw&oid=00D7F000001xTd0');
        ImageURLMap.put('koueiImage','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0ODM&d=/a/2v000000cBa7/bURSmAPQ1x.50ofWmLsanskaGWKE5cz46XVKNC2VXXU&oid=00D7F000001xTd0');
        ImageURLMap.put('mineiImage','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0ODR&d=/a/2v000000cBZs/osTmVN9ZhwcrjzJL8jXf8lC07fMznPObXqRarRpTOlc&oid=00D7F000001xTd0');
        ImageURLMap.put('jiinImage','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0ODH&d=/a/2v000000cBa2/zi96y7fZljirSdYh9JCgtJRrjTrjDEy.VAoNTJZ4Mg4&oid=00D7F000001xTd0');
        ImageURLMap.put('jisyaImage','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0ODW&d=/a/2v000000cBZx/aO83qL1FBJi5Wn28C0_KkGCz8e0f8wdli1bOcPdMPeY&oid=00D7F000001xTd0');
        ImageURLMap.put('noImage','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0XAA&d=/a/2v000000cBYk/4viLh9dhS7.S5h_lVpcLbfwRnEwrcZ8KA9xUYMhMYsE&oid=00D7F000001xTd0');
        ImageURLMap.put('parkingIconON','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0Wq7&d=/a/2v000000cBXr/z1MtKE6rP1v2VGOy_Z8alva_aFHjO8Mcp8giiRViWu8&oid=00D7F000001xTd0');
        ImageURLMap.put('parkingIconOFF','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0WqC&d=/a/2v000000cBY1/Lv5NKf8f0v2qm1Syi4iQYaT2FnrGomETqM72nUhQZfs&oid=00D7F000001xTd0');
        ImageURLMap.put('napFacilityON','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0WqW&d=/a/2v000000cBXw/kCw05JHlwNMDCg7GJ2BIjvn_r8YyiPlv_XJxkOxHzS0&oid=00D7F000001xTd0');
        ImageURLMap.put('napFacilityOFF','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0Wqn&d=/a/2v000000cBY6/AAvl7z6wtXdRVxqN3T55qXw_u4tfv4sDnSXhWaUlHO4&oid=00D7F000001xTd0');
        ImageURLMap.put('waitingroomON','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0Woi&d=/a/2v000000cBYB/iqO4FxeyqRRn8MPqbEmO0e_Ol22K_4bb4K1cO1tTqFw&oid=00D7F000001xTd0');
        ImageURLMap.put('waitingroomOFF','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0Wjy&d=/a/2v000000cBYG/NG4PjXN5lkXrDvQ2FDCoEhXSY4Uwdsi45VPeR5NEtXg&oid=00D7F000001xTd0');
        ImageURLMap.put('barrierFreeON','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0WrM&d=/a/2v000000cBYQ/H8aGhDe8CpKU3fIefSEGMLB3ZY.mFZQRq9MFpqqrm5w&oid=00D7F000001xTd0');
        ImageURLMap.put('barrierFreeOFF','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0Wr7&d=/a/2v000000cBYL/NyWRiFjTV0gr_slNnuMlWLh6ih3R95Ckmcyq5LOBwnM&oid=00D7F000001xTd0');
        ImageURLMap.put('escrowFacilityON','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0Wrb&d=/a/2v000000cBYV/UcOmuU_ioweGQ01pilZ_25aTMXXQNbQ2a7tYND0srzs&oid=00D7F000001xTd0');
        ImageURLMap.put('escrowFacilityOFF','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0Wrq&d=/a/2v000000cBYa/3IOnyx9SOo6FQyyw7UnBvAdELpNioHNH94NoQGycNSY&oid=00D7F000001xTd0');
        ImageURLMap.put('inplanIcon','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0X8X&d=/a/2v000000cBYf/_AcjoOlUvGAasvDS6vsSrxcx8Y91rV_azRJoevafvlQ&oid=00D7F000001xTd0');
        ImageURLMap.put('jizenwari2y','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0OD7&d=/a/2v000000cBaC/C6a9A03Ncl.UFKGV98hhNpl__r16Foqm4svFLBJI3c4&oid=00D7F000001xTd0');
        ImageURLMap.put('jizenwari0d','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0OAt&d=/a/2v000000cBaH/uwI2xF4Upsv8nctlqFlfRi3uDaZAcaH0MYEchvArMYs&oid=00D7F000001xTd0');
        ImageURLMap.put('jizenwari30d','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0OD2&d=/a/2v000000cBaM/YkSG1rfP_4KjYYOrH4XCJ.BAH66a4TOU4RABEZVZzcA&oid=00D7F000001xTd0');
        ImageURLMap.put('jizenwari1y','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0OCx&d=/a/2v000000cBaR/7.FKvNWfwYZ4SpUwwHBL0mJFdz9I8nMjB9lBaMsOQKM&oid=00D7F000001xTd0');
        KoueimineiSyousai.put('公営','公営斎場');
        KoueimineiSyousai.put('民営','民営斎場');
        KoueimineiSyousai.put('寺院','寺院斎場');
        KoueimineiSyousai.put('自社','よりそうのお葬式 提携斎場');
        saijyoImageSortKey.add('gaikan');
        saijyoImageSortKey.add('gaikan2');
        saijyoImageSortKey.add('gaikan3');
        saijyoImageSortKey.add('naikan');
        saijyoImageSortKey.add('naikan2');
        saijyoImageSortKey.add('naikan3');
        saijyoImageSortKey.add('entrance');
        saijyoImageSortKey.add('entrance2');
        saijyoImageSortKey.add('entrance3');
        saijyoImageSortKey.add('saidan');
        saijyoImageSortKey.add('saidan2');
        saijyoImageSortKey.add('saidan3');
        saijyoImageSortKey.add('hall');
        saijyoImageSortKey.add('hall2');
        saijyoImageSortKey.add('hall3');
        saijyoImageSortKey.add('shinzokuHikaeshitsu');
        saijyoImageSortKey.add('shinzokuHikaeshitsu2');
        saijyoImageSortKey.add('shinzokuHikaeshitsu3');
        saijyoImageSortKey.add('hikaeshitsu');
        saijyoImageSortKey.add('hikaeshitsu2');
        saijyoImageSortKey.add('hikaeshitsu3');
        saijyoImageSortKey.add('parking');
        saijyoImageSortKey.add('parking2');
        saijyoImageSortKey.add('parking3');
        saijyoImageSortKey.add('other');
        saijyoImageSortKey.add('other2');
        saijyoImageSortKey.add('other3');
        saijyoImageSortKey.add('rozen');
        saijyoImageSortKey.add('rozen2');
        saijyoImageSortKey.add('rozen3');
        saijyoImageSortKey.add('syukotsushitsu');
        saijyoImageSortKey.add('syukotsushitsu2');
        saijyoImageSortKey.add('syukotsushitsu3');
        saijyoImageSortKey.add('okiyome');
        saijyoImageSortKey.add('okiyome2');
        saijyoImageSortKey.add('okiyome3');
        saijyoImageSortKey.add('top');
        teianshoPlanImageURLMap.put('直葬','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MJX&d=/a/2v000000cC5y/7U9nwiYZB.oqSONFJkD1peaMQR1fmKd8_LNOYQCyhMs&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('火葬式　無宗教プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MG4&d=/a/2v000000cC3T/IzsyM2mXfisOH6UwLR7llBJNDcZI54LjBk9fQSEXsDs&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('火葬式　仏式プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MFV&d=/a/2v000000cC3Y/tW4foClBtUY3Z1HWvNp19uye2zfdXmDZ8rClRuwod5U&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('火葬式　花束プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MGd&d=/a/2v000000cC3d/IFegD3NK.hIJfX7USZ94inSzs9bJlH1hVP_HkSlZ6tY&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('一日葬　仏式プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MIP&d=/a/2v000000cC3i/YXfCX23anOr7LyPLlC11Lp9AUrS_jOqT_b3HjTKP09o&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('一日葬　無宗教プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2HwX&d=/a/2v000000cC3n/QJismi3_6l1HZ6A.fnSxa7mZpzqgG8b8Ibp__vzFLP0&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('家族葬　仏式プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MH2&d=/a/2v000000cC3s/EyG8dWL1mP5dCWrwvIHXKZ2Y_eWku6ImZFYF45kua6c&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('家族葬　無宗教プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MHM&d=/a/2v000000cC3x/xbQq6kCZPmcH.d0a3r4QG7y4MjV9LJSli4MX2aNcfk0&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('一般葬　無宗教プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MEc&d=/a/2v000000cC42/ShB1Yo_fcCD6tBqi.qVyP920M7qptcz2S.67ZCnaHnE&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('一般葬　仏式プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MF1&d=/a/2v000000cC47/dofaMRd18ACI5aTWHCOm6ym3NQF62PIhZToIwtYXizA&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('一般葬　お花増量プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MF1&d=/a/2v000000cC47/dofaMRd18ACI5aTWHCOm6ym3NQF62PIhZToIwtYXizA&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('家族葬　お花増量プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MH2&d=/a/2v000000cC3s/EyG8dWL1mP5dCWrwvIHXKZ2Y_eWku6ImZFYF45kua6c&oid=00D7F000001xTd0');
        teianshoPlanImageURLMap.put('一日葬　お花増量プラン','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G2MIP&d=/a/2v000000cC3i/YXfCX23anOr7LyPLlC11Lp9AUrS_jOqT_b3HjTKP09o&oid=00D7F000001xTd0');
        soufujyouMongonMap.put('斎場資料','葬儀場のご案内');
        soufujyouMongonMap.put('提案書','ご提案書');
        passwordIssue = false;
    }

    public Map<String, String> createSoufujyouMap(SogiShiryoSofu__c sogiShiryoSofu){
        Map<String, String> soufujyouMap = new Map<String, String>();
        Map<String, String> sokutasuumu = new Map<String, String>();
        sokutasuumu.put('速達','速達');
        sokutasuumu.put('通常','');
        sokutasuumu.put('信書','');
        sokutasuumu.put('速達信書','速達');
        // 受付日
        soufujyouMap.put('ud',DateTime.now().format('yyyy年MM月dd日'));
        // 補足説明
        soufujyouMap.put('eq',this.nullToblank(sogiShiryoSofu.HosokuSetsumei__c));
        // お客様番号
        soufujyouMap.put('cno',sogiShiryoSofu.OpportunityRef__r.ShodanBangoF__c);
        // 速達有無
        soufujyouMap.put('stu',this.nullToblank(sokutasuumu.get(sogiShiryoSofu.YusoShubetsu__c)));
        // 郵便番号
        if(this.nullToblank(sogiShiryoSofu.PostalCode__c) != '' ){
            soufujyouMap.put('pc','〒' + this.nullToblank(sogiShiryoSofu.PostalCode__c));
        }else{
            soufujyouMap.put('pc','');
        }
        // 住所
        soufujyouMap.put('ad',this.nullToblank(sogiShiryoSofu.State__c) +	this.nullToblank(sogiShiryoSofu.City__c) + this.nullToblank(sogiShiryoSofu.Street__c));
        // 送付物一覧
        List<String> soufuButsuList = new List<String>();
        String souhuJyouIchiran = '';
        if(this.nullToblank(sogiShiryoSofu.InsatsubutsuIchiran__c) != ''){
            soufuButsuList = sogiShiryoSofu.InsatsubutsuIchiran__c.split(';');
        }
        if(this.nullToblank(sogiShiryoSofu.TaSofubutsu1__c) != ''){
            soufuButsuList.add(sogiShiryoSofu.TaSofubutsu1__c);
        }
        if(this.nullToblank(sogiShiryoSofu.TaSofubutsu2__c) != ''){
            soufuButsuList.add(sogiShiryoSofu.TaSofubutsu2__c);
        }
        if(this.nullToblank(sogiShiryoSofu.TaSofubutsu3__c) != ''){
            soufuButsuList.add(sogiShiryoSofu.TaSofubutsu3__c);
        }
        if(sogiShiryoSofu.PamphletYohi__c == '要'){
            soufuButsuList.add('よりそう　お葬式パンフレット一式');
        }
        for(Integer i = 0; i < soufuButsuList.size(); i++ ){
            if(soufujyouMongonMap.get(soufuButsuList.get(i)) != null ){
                soufuButsuList.set(i,soufujyouMongonMap.get(soufuButsuList.get(i)));
            }

        }
        Integer index = 0;
        Integer souhuJouhouMaxLength = 0;
        Integer souhuButsuMaxRow = 4;
        for(String souhuJyouhou : soufuButsuList){
            if(souhuJyouhou.length() > souhuJouhouMaxLength ){
                souhuJouhouMaxLength = souhuJyouhou.length();
            }
            if(index == souhuButsuMaxRow){
                break;
            }
            index++;
        }
        if(soufuButsuList.size() > souhuButsuMaxRow){
            Integer twoColoutputSize = soufuButsuList.size() - souhuButsuMaxRow;
            for (Integer i = 0; i < twoColoutputSize ; i++) {
                Integer paddingStrlength = souhuJouhouMaxLength - soufuButsuList.get(i).length();
                souhuJyouIchiran = souhuJyouIchiran + '・' 
                + soufuButsuList.get(i).rightPad(soufuButsuList.get(i).length() 
                + paddingStrlength,'　') + '　・' + soufuButsuList.get(i + 4)+ '\r\n';
                soufuButsuList.set(i,'');
                soufuButsuList.set(i + souhuButsuMaxRow ,'');
            }
            for(String soufuButsuValue : soufuButsuList){
                if(soufuButsuValue != ''){
                    souhuJyouIchiran = souhuJyouIchiran + '・' + soufuButsuValue +'\r\n';
                }
            }
        }else{
            for(String sofuName : soufuButsuList){
                souhuJyouIchiran = souhuJyouIchiran + sofuName + '\r\n';
            }
        }
        soufujyouMap.put('sd',souhuJyouIchiran);
        // お客様名
        soufujyouMap.put('cnm',sogiShiryoSofu.Atena__c + ' 様');
        soufujyouMap = this.setPassword(this.getRandomString(12),sogiShiryoSofu,soufujyouMap);
        return soufujyouMap;
    }

    public Map<String, String> createHyoshiMap (String passWord,SogiShiryoSofu__c sogiShiryoSofu) {
        Map<String, String> hyoshiMap = new Map<String, String>();
        hyoshiMap = this.setPassword(passWord,sogiShiryoSofu,hyoshiMap);
        return hyoshiMap;
    }

    public Map<String , String > setPassword(String passWord,SogiShiryoSofu__c sogiShiryoSofu,Map <String , String > pdfData){
        if(sogiShiryoSofu.SofuShubetsu__c == 'FAX'  ){
            pdfData.put('password','');
        }else if(sogiShiryoSofu.SofuShubetsu__c == 'メール' && !passwordIssue){
            pdfData.put('password',passWord);
            oproPdfPassWord = passWord;
            passwordIssue = true;
        }else{
            pdfData.put('password','');
        }
        return pdfData;
    }


    public String getPartsImageURL (String key) {
        return ImageURLMap.get(key);
    }

    public String getShisetsuKubunName (String key) {
        return KoueimineiSyousai.get(key);
    }

    public List<String> getImageSortKeyList (){
        return saijyoImageSortKey;
    }

    public String getTeianshoImageURL(String key){
        return teianshoPlanImageURLMap.get(key);
    }


    public Map<String, String> createSaijyouIchiranList ( List< SogiShiryoSofuMeisai__c > sogiShiryomeisai ,
    List<Saijo__c> saijyoData,SogiShiryoSofu__c sogiShiryoSofu ,Map<String,List<String>> saijyoImageMap ,
    Map<String,List<String>> kasouImageMap) {
        Map<String, String> saijyouIchiran = new Map<String, String>();
        Map<String,String> koueiminei = new Map<String, String>();
        koueiminei.put('公営','koueiImage');
        koueiminei.put('民営','mineiImage');
        koueiminei.put('寺院','jiinImage');
        koueiminei.put('自社','jisyaImage');

        integer saijyoNo = 1;
        integer kasouNo = 1;
        // 斎場タイトル(画像)
        saijyouIchiran.put('fT_top','');
        // 斎場カード①背景画像
        saijyouIchiran.put('fbi_1','');
        // 斎場カード②背景画像
        saijyouIchiran.put('fbi_2','');
        // 斎場カード③背景画像
        saijyouIchiran.put('fbi_3','');
        // 斎場カード④背景画像
        saijyouIchiran.put('fbi_4','');
        // 斎場カード⑤背景画像
        saijyouIchiran.put('fbi_5','');
        // 斎場カード⑥背景画像
        saijyouIchiran.put('fbi_6','');
        // 斎場カード⑦背景画像
        saijyouIchiran.put('fbi_7','');
        // 斎場カード⑧背景画像
        saijyouIchiran.put('fbi_8','');
        // 斎場カード⑨背景画像
        saijyouIchiran.put('fbi_9','');
        // 斎場カード⑩背景画像
        saijyouIchiran.put('fbi_10','');
        // 火葬場タイトル（斎場８枚以上掲載時）
        saijyouIchiran.put('fkt_10','');
        // 火葬場カード①背景画像（斎場８枚以上掲載時）
        saijyouIchiran.put('fkbi_10_1','');
        // 火葬場カード①区分画像（斎場８枚以上掲載時）
        saijyouIchiran.put('fkd_10_1','');
        // 火葬場カード②背景画像（斎場８枚以上掲載時）
        saijyouIchiran.put('fkbi_10_2','');
        // 火葬場カード②区分画像（斎場８枚以上掲載時）
        saijyouIchiran.put('fkd_10_2','');
        // 火葬場タイトル（斎場８枚以下掲載時）
        saijyouIchiran.put('fkt_8','');
        // 火葬場カード①背景画像（斎場８枚以下掲載時）
        saijyouIchiran.put('fkbi_8_1','');
        // 火葬場カード①区分画像（斎場８枚以下掲載時）
        saijyouIchiran.put('fkd_8_1','');
        // 火葬場カード②背景画像（斎場８枚以下掲載時）
        saijyouIchiran.put('fkbi_8_2','');
        // 火葬場カード②区分画像（斎場８枚以下掲載時）
        saijyouIchiran.put('fkd_8_2','');
        // 火葬場タイトル（斎場６枚以下掲載時）
        saijyouIchiran.put('fkt_6','');
        // 火葬場カード①背景画像（斎場６枚以下掲載時）
        saijyouIchiran.put('fkbi_6_1','');
        // 火葬場カード①区分画像（斎場６枚以下掲載時）
        saijyouIchiran.put('fkd_6_1','');
        // 火葬場カード②背景画像（斎場６枚以下掲載時）
        saijyouIchiran.put('fkbi_6_2','');
        // 火葬場カード②区分画像（斎場６枚以下掲載時）
        saijyouIchiran.put('fkd_6_2','');
        // 火葬場タイトル（斎場４枚以下掲載時）
        saijyouIchiran.put('fkt_4','');
        // 火葬場カード①背景画像（斎場４枚以下掲載時）
        saijyouIchiran.put('fkbi_4_1','');
        // 火葬場カード①区分画像（斎場４枚以下掲載時）
        saijyouIchiran.put('fkd_4_1','');
        // 火葬場カード②背景画像（斎場４枚以下掲載時）
        saijyouIchiran.put('fkbi_4_2','');
        // 火葬場カード②区分画像（斎場４枚以下掲載時）
        saijyouIchiran.put('fkd_4_2','');
        // 火葬場タイトル（斎場２枚以下掲載時）
        saijyouIchiran.put('fkt_2','');
        // 火葬場カード①背景画像（斎場2枚以下掲載時）
        saijyouIchiran.put('fkbi_2_1','');
        // 火葬場カード①区分画像（斎場2枚以下掲載時）
        saijyouIchiran.put('fkd_2_1','');
        // 火葬場カード②背景画像（斎場2枚以下掲載時）
        saijyouIchiran.put('fkbi_2_2','');
        // 火葬場カード②区分画像（斎場2枚以下掲載時）
        saijyouIchiran.put('fkd_2_2','');
        // 斎場カード①区分画像
        saijyouIchiran.put('fd_1','');
        // 斎場カード②区分画像
        saijyouIchiran.put('fd_2','');
        // 斎場カード③区分画像
        saijyouIchiran.put('fd_3','');
        // 斎場カード④区分画像
        saijyouIchiran.put('fd_4','');
        // 斎場カード⑤区分画像
        saijyouIchiran.put('fd_5','');
        // 斎場カード⑥区分画像
        saijyouIchiran.put('fd_6','');
        // 斎場カード⑦区分画像
        saijyouIchiran.put('fd_7','');
        // 斎場カード⑧区分画像
        saijyouIchiran.put('fd_8','');
        // 斎場カード⑨区分画像
        saijyouIchiran.put('fd_9','');
        // 斎場カード⑩区分画像
        saijyouIchiran.put('fd_10','');
        // 斎場カード①斎場名文字列
        saijyouIchiran.put('fn_1','');
        // 斎場カード①アクセス文字列
        saijyouIchiran.put('fac_1','');
        // 斎場カード②斎場名文字列
        saijyouIchiran.put('fn_2','');
        // 斎場カード②アクセス文字列
        saijyouIchiran.put('fac_2','');
        // 斎場カード③斎場名文字列
        saijyouIchiran.put('fn_3','');
        // 斎場カード③アクセス文字列
        saijyouIchiran.put('fac_3','');
        // 斎場カード④斎場名文字列
        saijyouIchiran.put('fn_4','');
        // 斎場カード④アクセス文字列
        saijyouIchiran.put('fac_4','');
        // 斎場カード⑤斎場名文字列
        saijyouIchiran.put('fn_5','');
        // 斎場カード⑤アクセス文字列
        saijyouIchiran.put('fac_5','');
        // 斎場カード⑥斎場名文字列
        saijyouIchiran.put('fn_6','');
        // 斎場カード⑥アクセス文字列
        saijyouIchiran.put('fac_6','');
        // 斎場カード⑦斎場名文字列
        saijyouIchiran.put('fn_7','');
        // 斎場カード⑦アクセス文字列
        saijyouIchiran.put('fac_7','');
        // 斎場カード⑧斎場名文字列
        saijyouIchiran.put('fn_8','');
        // 斎場カード⑧アクセス文字列
        saijyouIchiran.put('fac_8','');
        // 斎場カード⑨斎場名文字列
        saijyouIchiran.put('fn_9','');
        // 斎場カード⑨アクセス文字列
        saijyouIchiran.put('fac_9','');
        // 斎場カード⑩斎場名文字列
        saijyouIchiran.put('fn_10','');
        // 斎場カード⑩アクセス文字列
        saijyouIchiran.put('fac_10','');
        // 火葬場カード①火葬場名文字列（斎場８枚以上掲載時）
        saijyouIchiran.put('kn_10_1','');
        // 火葬場カード①火葬場アクセス文字列（斎場８枚以上掲載時）
        saijyouIchiran.put('kac_10_1','');
        // 火葬場カード②火葬場名文字列（斎場８枚以上掲載時）
        saijyouIchiran.put('kn_10_2','');
        // 火葬場カード②火葬場アクセス文字列（斎場８枚以上掲載時）
        saijyouIchiran.put('kac_10_2','');
        // 斎場外観写真①
        saijyouIchiran.put('fp_1','');
        // 斎場外観写真②
        saijyouIchiran.put('fp_2','');
        // 斎場外観写真③
        saijyouIchiran.put('fp_3','');
        // 斎場外観写真④
        saijyouIchiran.put('fp_4','');
        // 斎場外観写真⑤
        saijyouIchiran.put('fp_5','');
        // 斎場外観写真⑥
        saijyouIchiran.put('fp_6','');
        // 斎場外観写真⑦
        saijyouIchiran.put('fp_7','');
        // 斎場外観写真⑧
        saijyouIchiran.put('fp_8','');
        // 斎場外観写真⑨
        saijyouIchiran.put('fp_9','');
        // 斎場外観写真⑩
        saijyouIchiran.put('fp_10','');
        // 火葬場外観写真①（斎場８枚以上掲載時）
        saijyouIchiran.put('fkp_10_1','');
        // 火葬場外観写真②（斎場８枚以上掲載時）
        saijyouIchiran.put('fkp_10_2','');
        // 火葬場カード①火葬場名文字列（斎場８枚以下掲載時）
        saijyouIchiran.put('kn_8_1','');
        // 火葬場カード①火葬場アクセス文字列（斎場８枚以下掲載時）
        saijyouIchiran.put('kac_8_1','');
        // 火葬場カード①火葬場住所文字列（斎場８枚以下掲載時）
        saijyouIchiran.put('kad_8_1','');
        // 火葬場カード②火葬場名文字列（斎場８枚以下掲載時）
        saijyouIchiran.put('kn_8_2','');
        // 火葬場カード②火葬場アクセス文字列（斎場８枚以下掲載時）
        saijyouIchiran.put('kac_8_2','');
        // 火葬場カード②火葬場住所文字列（斎場８枚以下掲載時）
        saijyouIchiran.put('kad_8_2','');
        // 火葬場カード①火葬場名文字列（斎場6枚以下掲載時）
        saijyouIchiran.put('kn_6_1','');
        // 火葬場カード①火葬場アクセス文字列（斎場6枚以下掲載時）
        saijyouIchiran.put('kac_6_1','');
        // 火葬場カード①火葬場住所文字列（斎場6枚以下掲載時）
        saijyouIchiran.put('kad_6_1','');
        // 火葬場カード②火葬場名文字列（斎場6枚以下掲載時）
        saijyouIchiran.put('kn_6_2','');
        // 火葬場カード②火葬場アクセス文字列（斎場6枚以下掲載時）
        saijyouIchiran.put('kac_6_2','');
        // 火葬場カード②火葬場住所文字列（斎場6枚以下掲載時）
        saijyouIchiran.put('kad_6_2','');
        // 火葬場カード①火葬場名文字列（斎場4枚以下掲載時）
        saijyouIchiran.put('kn_4_1','');
        // 火葬場カード①火葬場アクセス文字列（斎場4枚以下掲載時）
        saijyouIchiran.put('kac_4_1','');
        // 火葬場カード①火葬場住所文字列（斎場4枚以下掲載時）
        saijyouIchiran.put('kad_4_1','');
        // 火葬場カード②火葬場名文字列（斎場4枚以下掲載時）
        saijyouIchiran.put('kn_4_2','');
        // 火葬場カード②火葬場アクセス文字列（斎場4枚以下掲載時）
        saijyouIchiran.put('kac_4_2','');
        // 火葬場カード②火葬場住所文字列（斎場4枚以下掲載時）
        saijyouIchiran.put('kad_4_2','');
        // 火葬場カード①火葬場名文字列（斎場2枚以下掲載時）
        saijyouIchiran.put('kn_2_1','');
        // 火葬場カード①火葬場アクセス文字列（斎場2枚以下掲載時）
        saijyouIchiran.put('kac_2_1','');
        // 火葬場カード①火葬場住所文字列（斎場2枚以下掲載時）
        saijyouIchiran.put('kad_2_1','');
        // 火葬場カード②火葬場名文字列（斎場2枚以下掲載時）
        saijyouIchiran.put('kn_2_2','');
        // 火葬場カード②火葬場アクセス文字列（斎場2枚以下掲載時）
        saijyouIchiran.put('kac_2_2','');
        // 火葬場カード②火葬場住所文字列（斎場2枚以下掲載時）
        saijyouIchiran.put('kad_2_2','');
        // 火葬場カード①火葬場外観画像（斎場８枚以下掲載時）
        saijyouIchiran.put('fkp_8_1','');
        // 火葬場カード②火葬場外観画像（斎場８枚以下掲載時）
        saijyouIchiran.put('fkp_8_2','');
        // 火葬場カード①火葬場外観画像（斎場2枚以下掲載時）
        saijyouIchiran.put('fkp_2_2','');
        // 火葬場カード②火葬場外観画像（斎場2枚以下掲載時）
        saijyouIchiran.put('fkp_2_1','');
        // 火葬場カード①火葬場外観画像（斎場4枚以下掲載時）
        saijyouIchiran.put('fkp_4_1','');
        // 火葬場カード②火葬場外観画像（斎場4枚以下掲載時）
        saijyouIchiran.put('fkp_4_2','');
        // 火葬場カード①火葬場外観画像（斎場6枚以下掲載時）
        saijyouIchiran.put('fkp_6_1','');
        // 火葬場カード②火葬場外観画像（斎場6枚以下掲載時）
        saijyouIchiran.put('fkp_6_2','');
        // 一覧タイトル
        saijyouIchiran.put('ct',sogiShiryoSofu.Atena__c +' 様' + 'へのおすすめの葬儀場です');
        // 斎場カード①住所文字列
        saijyouIchiran.put('fad_1','');
        // 斎場カード②住所文字列
        saijyouIchiran.put('fad_2','');
        // 斎場カード④住所文字列
        saijyouIchiran.put('fad_4','');
        // 斎場カード⑤住所文字列
        saijyouIchiran.put('fad_5','');
        // 斎場カード⑥住所文字列
        saijyouIchiran.put('fad_6','');
        // 斎場カード⑦住所文字列
        saijyouIchiran.put('fad_7','');
        // 斎場カード⑧住所文字列
        saijyouIchiran.put('fad_8','');
        // 斎場カード⑨住所文字列
        saijyouIchiran.put('fad_9','');
        // 斎場カード⑩住所文字列
        saijyouIchiran.put('fad_10','');
        // 火葬場カード①火葬場住所文字列（斎場8枚以上掲載時）
        saijyouIchiran.put('kad_10_1','');
        // 火葬場カード②火葬場住所文字列（斎場8枚以上掲載時）
        saijyouIchiran.put('kad_10_2','');
        // 斎場カード③住所文字列
        saijyouIchiran.put('fad_3','');
        // 斎場0件時のテキスト
        saijyouIchiran.put('zero_t','');
        Boolean kasouFlag = sogiShiryoSofu.KasoshikiyoMongon__c;
        if(saijyoData.size()!= 0){
            // 斎場タイトル(画像)
            saijyouIchiran.put('fT_top','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G0XBN&d=/a/2v000000cBYu/uohgkgYPet8Z1E4I0c1a1v5VvxDsgBzqFYEQEzhjKi8&oid=00D7F000001xTd0');
        }else if(kasouFlag){
            // 火葬のみ
            saijyouIchiran.put('zero_t','火葬式をご希望いただいているため、式場は掲載しておりません。\n お式を行うプランをご検討の場合は、あらためて式場をお探しいたします。\n ご要望の際は「よりそう　お葬式」までご連絡ください。\n 0120-541-646 (相談無料 24時間365日)');
        }else{
            saijyouIchiran.put('zero_t','現在、ご希望地域の周辺でご紹介可能な式場がございません。\n 別の地域で、式場の提案が可能なことがございます。 \n詳しくは「よりそう　お葬式」までご連絡ください。\n0120-541-646　(相談無料 24時間365日)');
        }
        for(SogiShiryoSofuMeisai__c sogiShiryoSofuMeisairecord : sogiShiryomeisai ){
            if(sogiShiryoSofuMeisairecord.SaijoRef__c != null){
                saijyouIchiran.put('fbi_' + saijyoNo.format() ,this.getPartsImageURL('saijyoIchirancard' + saijyoNo.format()));
                String[] accessList = this.nullToblank(sogiShiryoSofuMeisairecord.SaijoRef__r.AccessHouhouDensha__c).replaceAll('\r\n' , '\n').split('\n');
                if(accessList.size() > 1 ){
                    saijyouIchiran.put('fac_' + saijyoNo.format() ,accessList[0] + '\n ...他');
                }else if(this.nullToblank(sogiShiryoSofuMeisairecord.SaijoRef__r.AccessHouhouDensha__c).length() >= SAIJOICHIRAN_ACCESS_MAX_LENGTH ){
                    saijyouIchiran.put('fac_' + saijyoNo.format() ,
                    this.nullToblank(sogiShiryoSofuMeisairecord.SaijoRef__r.AccessHouhouDensha__c).substring(0,SAIJOICHIRAN_ACCESS_MAX_LENGTH -1)+'...');
                }else{
                    saijyouIchiran.put('fac_' + saijyoNo.format() ,this.nullToblank(sogiShiryoSofuMeisairecord.SaijoRef__r.AccessHouhouDensha__c));
                }
                saijyouIchiran.put('fad_' + saijyoNo.format() ,this.nullToblank(sogiShiryoSofuMeisairecord.SaijoRef__r.Jusho__c) );
                saijyouIchiran.put('fd_'  + saijyoNo.format() ,this.getPartsImageURL(this.nullToblank(koueiminei.get(sogiShiryoSofuMeisairecord.SaijoRef__r.ShisetsuKubun__c))));
                saijyouIchiran.put('fn_'  + saijyoNo.format() ,this.textOverflowconversion(this.nullToblank(sogiShiryoSofuMeisairecord.SaijoRef__r.Name)));
                List<String> saijyoImageUrlList = saijyoImageMap.get(sogiShiryoSofuMeisairecord.SaijoRef__c);
                if(saijyoImageUrlList != null && saijyoImageUrlList.size() > 0 ){
                    saijyouIchiran.put('fp_'  + saijyoNo.format() ,saijyoImageUrlList.get(0));
                }else{
                    saijyouIchiran.put('fp_'  + saijyoNo.format() ,this.getPartsImageURL('noImage'));
                }
                saijyoNo++;
            }
            if(sogiShiryoSofuMeisairecord.ShisetsuRef__c != null ){
                List<String> kasouImageUrlList = kasouImageMap.get(sogiShiryoSofuMeisairecord.ShisetsuRef__c);
                String[] kasouAccessList = this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).replaceAll('\r\n' , '\n').split('\n');
                if(saijyoData.size() > 8)  {
                    saijyouIchiran.put('fkt_10' , this.getPartsImageURL('kasouIchiranTitle'));
                    saijyouIchiran.put('fkbi_10_'+ kasouNo.format(),this.getPartsImageURL('kasouIchiranCard'+kasouNo.format()));
                    saijyouIchiran.put('kn_10_'+ kasouNo.format(),this.textOverflowconversion(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.Name)));
                    saijyouIchiran.put('fkd_10_'+ kasouNo.format(),this.getPartsImageURL(this.nullToblank(koueiminei.get(sogiShiryoSofuMeisairecord.ShisetsuRef__r.KoeiMinei__c))));                    
                    if(kasouAccessList.size() > 1){
                        saijyouIchiran.put('kac_10_' + kasouNo.format() ,kasouAccessList[0] + '\n ...他');
                    }else if(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).length() >= SAIJOICHIRAN_ACCESS_MAX_LENGTH ){
                        saijyouIchiran.put('kac_10_'+ kasouNo.format(), 
                        this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).substring(0,SAIJOICHIRAN_ACCESS_MAX_LENGTH -1 )+'...');
                    }else{
                        saijyouIchiran.put('kac_10_'+ kasouNo.format(),this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c));
                    }
                    saijyouIchiran.put('kad_10_'+ kasouNo.format(),sogiShiryoSofuMeisairecord.ShisetsuRef__r.Jusho__c);
                    if(kasouImageUrlList != null && kasouImageUrlList.size() > 0 ){
                        saijyouIchiran.put('fkp_10_'  + kasouNo.format() ,kasouImageUrlList.get(0));
                    }else{
                        saijyouIchiran.put('fkp_10_'  + kasouNo.format() ,this.getPartsImageURL('noImage'));
                    }
                    kasouNo++;
                }else if(saijyoData.size() > 6){
                    saijyouIchiran.put('fkt_8' , this.getPartsImageURL('kasouIchiranTitle'));
                    saijyouIchiran.put('fkbi_8_'+ kasouNo.format(),this.getPartsImageURL('kasouIchiranCard'+kasouNo.format()));
                    saijyouIchiran.put('kn_8_'+ kasouNo.format(),this.textOverflowconversion(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.Name)));
                    saijyouIchiran.put('fkd_8_'+ kasouNo.format(),this.getPartsImageURL(this.nullToblank(koueiminei.get(sogiShiryoSofuMeisairecord.ShisetsuRef__r.KoeiMinei__c))));
                    if(kasouAccessList.size() > 1){
                        saijyouIchiran.put('kac_8_' + kasouNo.format() ,kasouAccessList[0] + '\n ...他');
                    }else if(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).length() >= SAIJOICHIRAN_ACCESS_MAX_LENGTH ){
                        saijyouIchiran.put('kac_8_'+ kasouNo.format(),
                        this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).substring(0,SAIJOICHIRAN_ACCESS_MAX_LENGTH -1)+'...');
                    }else{
                        saijyouIchiran.put('kac_8_'+ kasouNo.format(),this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c));
                    }
                    saijyouIchiran.put('kad_8_'+ kasouNo.format(),sogiShiryoSofuMeisairecord.ShisetsuRef__r.Jusho__c);
                    if(kasouImageUrlList != null && kasouImageUrlList.size() > 0 ){
                        saijyouIchiran.put('fkp_8_'  + kasouNo.format() ,kasouImageUrlList.get(0));
                    }else{
                        saijyouIchiran.put('fkp_8_'  + kasouNo.format() ,this.getPartsImageURL('noImage'));
                    }
                    kasouNo++;
                }else if(saijyoData.size() > 4){
                    saijyouIchiran.put('fkt_6' , this.getPartsImageURL('kasouIchiranTitle'));
                    saijyouIchiran.put('fkbi_6_'+ kasouNo.format(),this.getPartsImageURL('kasouIchiranCard'+kasouNo.format()));
                    saijyouIchiran.put('kn_6_'+ kasouNo.format(),this.textOverflowconversion(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.Name)));
                    saijyouIchiran.put('fkd_6_'+ kasouNo.format(),this.getPartsImageURL(this.nullToblank(koueiminei.get(sogiShiryoSofuMeisairecord.ShisetsuRef__r.KoeiMinei__c))));
                    if(kasouAccessList.size() > 1){
                        saijyouIchiran.put('kac_6_' + kasouNo.format() ,kasouAccessList[0] + '\n ...他');
                    }else if(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).length() >= SAIJOICHIRAN_ACCESS_MAX_LENGTH ){
                        saijyouIchiran.put('kac_6_'+ kasouNo.format(),
                        this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).substring(0,SAIJOICHIRAN_ACCESS_MAX_LENGTH -1)+'...');
                    }else{
                        saijyouIchiran.put('kac_6_'+ kasouNo.format(),this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c));
                    }
                    saijyouIchiran.put('kad_6_'+ kasouNo.format(),sogiShiryoSofuMeisairecord.ShisetsuRef__r.Jusho__c);
                    if(kasouImageUrlList != null && kasouImageUrlList.size() > 0 ){
                        saijyouIchiran.put('fkp_6_'  + kasouNo.format() ,kasouImageUrlList.get(0));
                    }else{
                        saijyouIchiran.put('fkp_6_'  + kasouNo.format() ,this.getPartsImageURL('noImage'));
                    }
                    kasouNo++;
                }else if(saijyoData.size() > 2){
                    saijyouIchiran.put('fkt_4' , this.getPartsImageURL('kasouIchiranTitle'));
                    saijyouIchiran.put('fkbi_4_'+ kasouNo.format(),this.getPartsImageURL('kasouIchiranCard'+kasouNo.format()));
                    saijyouIchiran.put('kn_4_'+ kasouNo.format(),this.textOverflowconversion(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.Name)));
                    saijyouIchiran.put('fkd_4_'+ kasouNo.format(),this.getPartsImageURL(this.nullToblank(koueiminei.get(sogiShiryoSofuMeisairecord.ShisetsuRef__r.KoeiMinei__c))));
                    saijyouIchiran.put('kac_4_'+ kasouNo.format(),this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c));
                    if(kasouAccessList.size() > 1){
                        saijyouIchiran.put('kac_4_' + kasouNo.format() ,kasouAccessList[0] + '\n ...他');
                    }else if(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).length() >= SAIJOICHIRAN_ACCESS_MAX_LENGTH ){
                        saijyouIchiran.put('kac_4_'+ kasouNo.format(),
                        this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).substring(0,SAIJOICHIRAN_ACCESS_MAX_LENGTH -1)+'...');
                    }else{
                        saijyouIchiran.put('kac_4_'+ kasouNo.format(),this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c));
                    }
                    saijyouIchiran.put('kad_4_'+ kasouNo.format(),sogiShiryoSofuMeisairecord.ShisetsuRef__r.Jusho__c);
                    if(kasouImageUrlList != null && kasouImageUrlList.size() > 0 ){
                        saijyouIchiran.put('fkp_4_'  + kasouNo.format() ,kasouImageUrlList.get(0));
                    }else{
                        saijyouIchiran.put('fkp_4_'  + kasouNo.format() ,this.getPartsImageURL('noImage'));
                    }
                    kasouNo++;
                }else{
                    saijyouIchiran.put('fkt_2' , this.getPartsImageURL('kasouIchiranTitle'));
                    saijyouIchiran.put('fkbi_2_'+ kasouNo.format(),this.getPartsImageURL('kasouIchiranCard'+kasouNo.format()));
                    saijyouIchiran.put('kn_2_'+ kasouNo.format(),this.textOverflowconversion(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.Name)));
                    saijyouIchiran.put('fkd_2_'+ kasouNo.format(),this.getPartsImageURL(this.nullToblank(koueiminei.get(sogiShiryoSofuMeisairecord.ShisetsuRef__r.KoeiMinei__c))));
                    saijyouIchiran.put('kac_2_'+ kasouNo.format(),this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c));
                    if(kasouAccessList.size() > 1){
                        saijyouIchiran.put('kac_2_' + kasouNo.format() ,kasouAccessList[0] + '\n ...他');
                    }else if(this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).length() >= SAIJOICHIRAN_ACCESS_MAX_LENGTH ){
                        saijyouIchiran.put('kac_2_'+ kasouNo.format(),
                        this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c).substring(0,SAIJOICHIRAN_ACCESS_MAX_LENGTH -1)+'...');
                    }else{
                        saijyouIchiran.put('kac_2_'+ kasouNo.format(),this.nullToblank(sogiShiryoSofuMeisairecord.ShisetsuRef__r.AccessHouhouDensha__c));
                    }
                    saijyouIchiran.put('kad_2_'+ kasouNo.format(),sogiShiryoSofuMeisairecord.ShisetsuRef__r.Jusho__c);
                    if(kasouImageUrlList != null && kasouImageUrlList.size() > 0 ){
                        saijyouIchiran.put('fkp_2_'  + kasouNo.format() ,kasouImageUrlList.get(0));
                    }else{
                        saijyouIchiran.put('fkp_2_'  + kasouNo.format() ,this.getPartsImageURL('noImage'));
                    }
                    kasouNo++;
                }
            }
        }
        return saijyouIchiran;
    }


    public List< Map<String, String> > createFacilityMap (SogiShiryoSofu__c sogiShiryoSofu,List<Saijo__c> saijyoDataList,String ShisetsuKubun , List<Shisetsu__c> kasouData,Map<String , List<String> > facciltyImageMap,List < SogiShiryoSofuMeisai__c > sogishiryoSofuMeisai) {
        
        List<Map<String,String>> retFacilityList = new List<Map<String,String>>();
        integer saijyoNo = 1;
        integer kasoNo = 1;
        Map<String,List< Map < String, String > >>  hallList = this.conversionMapSsaijyouHallData(saijyoDataList);
        for(SogiShiryoSofuMeisai__c  saiJyoData : sogishiryoSofuMeisai){
            Map<String, String> facilityDetail = new Map<String, String>();
            if(ShisetsuKubun == '斎場' && saiJyoData.ShisetsuKubun__c == ShisetsuKubun){
                facilityDetail = this.createsaijyoMap(sogiShiryoSofu,hallList,saiJyoData,saijyoNo,facciltyImageMap);
                retFacilityList.add(facilityDetail);
                saijyoNo++;
            }else if(ShisetsuKubun == '火葬場' && saiJyoData.ShisetsuKubun__c == ShisetsuKubun){
                facilityDetail = this.createKasouMap(sogiShiryoSofu,kasouData,saiJyoData,kasoNo,facciltyImageMap);
                retFacilityList.add(facilityDetail);
                kasoNo++;
            }   
        }
        return retFacilityList;
    }

    public Map<String, String> createKasouMap (SogiShiryoSofu__c sogiShiryoSofu,List<Shisetsu__c> kasouData,SogiShiryoSofuMeisai__c  saiJyoData,Integer kasoNo ,Map<String , List<String> > facciltyImageMap){
        Map<String, String> facilityDetail = new Map<String, String>();        
        // 斎場（火葬場）番号
        facilityDetail.put('fnum',kasoNo.format());
        // 施設区分 getShisetsuKubunName
        facilityDetail.put('fdns',this.nullToblank(this.getShisetsuKubunName(saiJyoData.ShisetsuRef__r.KoeiMinei__c)));
        // 斎場（火葬場）名称
        facilityDetail.put('fdn',this.nullToblank(saiJyoData.ShisetsuRef__r.Name));
        List<String> kasouImage =  facciltyImageMap.get(saiJyoData.ShisetsuRef__c);
        facilityDetail.put('fdi5_1','');
        facilityDetail.put('fdi5_2','');
        facilityDetail.put('fdi5_3','');
        facilityDetail.put('fdi5_4','');
        facilityDetail.put('fdi5_5','');
        if(kasouImage.size() > 1){
            for (Integer i = 0; i < 5 ; i++) {
                if( i < kasouImage.size() ){
                    facilityDetail.put('fdi5_' + (i + 1).format() , kasouImage.get(i));
                }else{
                    facilityDetail.put('fdi5_' + (i + 1).format() , this.getPartsImageURL('noImage'));
                }
                
            }
        }
        facilityDetail.put('fdad',this.nullToblank(saiJyoData.ShisetsuRef__r.Jusho__c));
        // 斎場アクセス文字列
        String accessData = '';
        if(this.nullToblank(saiJyoData.ShisetsuRef__r.AccessHouhouDensha__c) != '' ){
            accessData = accessData + this.nullToblank(saiJyoData.ShisetsuRef__r.AccessHouhouDensha__c) + '\r\n';
        }
        if(this.nullToblank(saiJyoData.ShisetsuRef__r.AccessHohoKuruma__c) != ''){
            accessData = accessData + this.nullToblank(saiJyoData.ShisetsuRef__r.AccessHohoKuruma__c)+ '\r\n';
        }
        if(this.nullToblank(saiJyoData.ShisetsuRef__r.AccessHohoBasu__c) != ''){
            accessData = accessData + this.nullToblank(saiJyoData.ShisetsuRef__r.AccessHohoBasu__c);
        }
        facilityDetail.put('fdac', accessData );
        // googlemap
        facilityDetail.put('gmap',this.createGoogleMapUrl(saiJyoData.ShisetsuRef__r.IdoKedo__latitude__s,saiJyoData.ShisetsuRef__r.IdoKedo__longitude__s));
        // qrコード
        facilityDetail.put('qr',this.createFacilityQrCode(saiJyoData.ShisetsuRef__r.KasobaKeisaiJohoId__c,'火葬場'));
        // プラン内料金のため追加料金なし（火葬場は非表示）
        facilityDetail.put('fdpl','');
        // 控室アイコン
        if( saiJyoData.ShisetsuRef__r.ShinzokuHikaeshitsuAri__c){
            facilityDetail.put('fdwrm',this.getPartsImageURL('waitingroomON'));
        }else{
            facilityDetail.put('fdwrm',this.getPartsImageURL('waitingroomOFF'));
        }
        // 仮眠室アイコン
        if( saiJyoData.ShisetsuRef__r.ShukuhakuKa__c){
            facilityDetail.put('fdnap',this.getPartsImageURL('napFacilityON'));
        }else{
            facilityDetail.put('fdnap',this.getPartsImageURL('napFacilityOFF'));
        }
        // 安置施設アイコン
        if(saiJyoData.ShisetsuRef__r.AnchiKa__c){
            facilityDetail.put('fdmo',this.getPartsImageURL('escrowFacilityON'));
        }else{
            facilityDetail.put('fdmo',this.getPartsImageURL('escrowFacilityOFF'));
        }
        // バリアフリーアイコン
        if(saiJyoData.ShisetsuRef__r.Bariafuri__c ){
            facilityDetail.put('fdbf',this.getPartsImageURL('barrierFreeON'));
        }else{
            facilityDetail.put('fdbf',this.getPartsImageURL('barrierFreeOFF'));
        }
        // 駐車場有無アイコン
        if(saiJyoData.ShisetsuRef__r.ChushajoAri__c){
            facilityDetail.put('fdpk',this.getPartsImageURL('parkingIconON'));
        }else{
            facilityDetail.put('fdpk',this.getPartsImageURL('parkingIconOFF'));
        }
        // 駐車台数文字列
        facilityDetail.put('pkc','台数：'+ this.nullToZero(saiJyoData.ShisetsuRef__r.Chushadaisu__c).format());
        // 備考文字列
        facilityDetail.put('fdeq','※ご希望の日にちによっては、空き状況などによりお待ち頂く場合がございます。\r\n※火葬料金の詳細につきましては、「よりそうのお葬式」までお問い合わせください。');
        // お客様番号、お客様名　文字列
        facilityDetail.put('fdcn',sogiShiryoSofu.OpportunityRef__r.ShodanBangoF__c + ' ' + sogiShiryoSofu.Atena__c + ' 様');

        if(kasouImage.size() == 1){
            // 斎場詳細画像（メイン １枚のみ時）
            facilityDetail.put('fdi1_1', kasouImage.get(0));
        }else if(kasouImage.size() == 0){
            facilityDetail.put('fdi1_1', this.getPartsImageURL('noImage'));
        }else{
            facilityDetail.put('fdi1_1', '');
        }


        return facilityDetail;
    }

    public Map<String, String> createsaijyoMap(SogiShiryoSofu__c sogiShiryoSofu,Map<String,List< Map < String, String > >>  hallList,SogiShiryoSofuMeisai__c  saiJyoData ,integer saijyoNo,Map<String , List<String> > facciltyImageMap){
        Map<String, String> facilityDetail = new Map<String, String>();
        // 斎場（火葬場）番号
        facilityDetail.put('fnum',saijyoNo.format());
        // 施設区分 getShisetsuKubunName
        facilityDetail.put('fdns',this.nullToblank(this.getShisetsuKubunName(saiJyoData.SaijoRef__r.ShisetsuKubun__c)));
        // 斎場（火葬場）名称
        facilityDetail.put('fdn',this.nullToblank(saiJyoData.SaijoRef__r.Name));
        List<String> saijyoImage =  facciltyImageMap.get(saiJyoData.SaijoRef__c);
        facilityDetail.put('fdi5_1','');
        facilityDetail.put('fdi5_2','');
        facilityDetail.put('fdi5_3','');
        facilityDetail.put('fdi5_4','');
        facilityDetail.put('fdi5_5','');
        if(saijyoImage.size() > 1){
            for (Integer i = 0; i < 5 ; i++) {
                if( i < saijyoImage.size() ){
                    facilityDetail.put('fdi5_' + (i + 1).format() , saijyoImage.get(i));
                }else{
                    facilityDetail.put('fdi5_' + (i + 1).format() , this.getPartsImageURL('noImage'));
                }
                
            }
        }
        // 斎場詳細所在地
        facilityDetail.put('fdad',this.nullToblank(saiJyoData.SaijoRef__r.Jusho__c));
        // 斎場アクセス文字列
        String accessData = '';
        if(this.nullToblank(saiJyoData.SaijoRef__r.AccessHouhouDensha__c) != '' ){
            accessData =  accessData + this.nullToblank(saiJyoData.SaijoRef__r.AccessHouhouDensha__c) + '\r\n';
        }
        if(this.nullToblank(saiJyoData.SaijoRef__r.AccessHohoKuruma__c) != ''){
            accessData =  accessData + this.nullToblank(saiJyoData.SaijoRef__r.AccessHohoKuruma__c) + '\r\n';
        }
        if(this.nullToblank(saiJyoData.SaijoRef__r.AccessHohoBasu__c) != '' ){
            accessData =  accessData + this.nullToblank(saiJyoData.SaijoRef__r.AccessHohoBasu__c) + '\r\n';
        }
        facilityDetail.put('fdac', accessData);
        // googlemap
        facilityDetail.put('gmap',this.createGoogleMapUrl(saiJyoData.SaijoRef__r.IdoKedo__latitude__s,saiJyoData.SaijoRef__r.IdoKedo__longitude__s));
        // qrコード
        facilityDetail.put('qr',this.createFacilityQrCode(saiJyoData.SaijoRef__r.SaijoKeisaiJohoId__c,'斎場'));
        // プラン内料金のため追加料金なし
        Boolean planFlg = true;
        Boolean jisyaFlag = false;
        if(this.nullToblank(saiJyoData.SaijoRef__r.ShisetsuKubun__c) == '自社'){
            jisyaFlag = true;
        }
        if(hallList.get(saiJyoData.SaijoRef__c) != null ){
            for( Map < String, String > row : hallList.get(saiJyoData.SaijoRef__c) ){
                if(row.get('X1ShiyoRyokinIppan__c') != '0' ){
                    planFlg = false;
                }
                if(row.get('X1ShiyoRyokinShimin__c') != '0' ){
                    planFlg = false;
                }
                if(row.get('X1ShiyoRyokinSonota__c') != '0' ){
                    planFlg = false;
                }
                if(row.get('X2ShiyoRyokinIppan__c') != '0'){
                    planFlg = false;
                }
                if(row.get('X2ShiyoRyokinShimin__c') != '0' ){
                    planFlg = false;
                }
                if(row.get('X2ShiyoRyokinSonota__c') != '0' ){
                    planFlg = false;
                }
            }
        }else{
            jisyaFlag =true;
        }
        if(jisyaFlag && planFlg){
            facilityDetail.put('fdpl',this.getPartsImageURL('inplanIcon'));
        }else{
            facilityDetail.put('fdpl','');
        }
        // 控室アイコン
        if(saiJyoData.SaijoRef__r.ShinzokuHikaeshitsu__c == '有'){
            facilityDetail.put('fdwrm',this.getPartsImageURL('waitingroomON'));
        }else{
            facilityDetail.put('fdwrm',this.getPartsImageURL('waitingroomOFF'));
        }
        // 仮眠室アイコン
        if(saiJyoData.SaijoRef__r.KaminShisetsuUmuAnchiKikanchu__c == '有'){
            facilityDetail.put('fdnap',this.getPartsImageURL('napFacilityON'));
        }else{
            facilityDetail.put('fdnap',this.getPartsImageURL('napFacilityOFF'));
        }
        // 安置施設アイコン
        if(saiJyoData.SaijoRef__r.AnchiShisetsu__c == '有'){
            facilityDetail.put('fdmo',this.getPartsImageURL('escrowFacilityON'));
        }else{
            facilityDetail.put('fdmo',this.getPartsImageURL('escrowFacilityOFF'));
        }
        // バリアフリーアイコン
        if(saiJyoData.SaijoRef__r.KurumaisuTaio__c == '可'){
            facilityDetail.put('fdbf',this.getPartsImageURL('barrierFreeON'));
        }else{
            facilityDetail.put('fdbf',this.getPartsImageURL('barrierFreeOFF'));
        }
        // 駐車場有無アイコン
        if(saiJyoData.ShisetsuRef__r.ChushajoAri__c){
            facilityDetail.put('fdpk',this.getPartsImageURL('parkingIconON'));
        }else{
            facilityDetail.put('fdpk',this.getPartsImageURL('parkingIconOFF'));
        }
        // 駐車台数文字列
        facilityDetail.put('pkc','台数：'+this.nullToZero(saiJyoData.SaijoRef__r.ChushaDaisu__c).format());
        // 備考文字列
        facilityDetail.put('fdeq','※ご希望の日にちによっては、空き状況などによりお待ち頂く場合がございます。\r\n※火葬料金の詳細につきましては、「よりそうのお葬式」までお問い合わせください。');
        // お客様番号、お客様名　文字列
        facilityDetail.put('fdcn',sogiShiryoSofu.OpportunityRef__r.ShodanBangoF__c + ' ' + sogiShiryoSofu.Atena__c+ ' 様');

        if(saijyoImage.size() == 1){
            // 斎場詳細画像（メイン １枚のみ時）
            facilityDetail.put('fdi1_1', saijyoImage.get(0));
        }else if(saijyoImage.size() == 0){
            facilityDetail.put('fdi1_1', this.getPartsImageURL('noImage'));
        }else{
            facilityDetail.put('fdi1_1', '');
        }

        return facilityDetail;
    }

    public Map<String, String> createJizenwariMap (SogiShiryoSofu__c sogiShiryoSofu){
        Map<String, String> jizenwariDetail = new Map<String, String>();
        Date JizenwariKisanbi = sogiShiryoSofu.OpportunityRef__r.Account.AcvmJizenWariMinDate__c;
        if(JizenwariKisanbi == null){
            JizenwariKisanbi = Date.today();
        }
        String kisanbi = this.formatDateTime(JizenwariKisanbi,'yyyy/MM/dd');
        String kisanbi30 =  this.formatDateTime(JizenwariKisanbi.addDays(30),'yyyy/MM/dd');
        String kisanbi1y =  this.formatDateTime(JizenwariKisanbi.addDays(366),'yyyy/MM/dd');
        String kisanbi2y =  this.formatDateTime(JizenwariKisanbi.addDays(731),'yyyy/MM/dd');
        String jizenwariBgUrl = '';
        if(sogiShiryoSofu.OpportunityRef__r.Account.JizenwariKekaKikan__c == '0日～29日'){
            jizenwariBgUrl = this.getPartsImageURL('jizenwari0d');
        }
        if(sogiShiryoSofu.OpportunityRef__r.Account.JizenwariKekaKikan__c == '30日～1年'){
            jizenwariBgUrl = this.getPartsImageURL('jizenwari30d');
        }
        if(sogiShiryoSofu.OpportunityRef__r.Account.JizenwariKekaKikan__c == '1年～2年'){
            jizenwariBgUrl = this.getPartsImageURL('jizenwari1y');
        }
        if(sogiShiryoSofu.OpportunityRef__r.Account.JizenwariKekaKikan__c == '2年～'){
            jizenwariBgUrl = this.getPartsImageURL('jizenwari2y');
        }
        if(sogiShiryoSofu.OpportunityRef__r.Account.JizenwariKekaKikan__c == null){
            jizenwariBgUrl = this.getPartsImageURL('jizenwari0d');
        }
        // 事前割背景画像
        jizenwariDetail.put('jbg',jizenwariBgUrl);
        // お客様名
        jizenwariDetail.put('cn',sogiShiryoSofu.Atena__c + ' 様');
        // 作成日
        jizenwariDetail.put('cd',Datetime.now().format('yyyy/MM/dd'));
        // 事前割メンバー期間名
        if(sogiShiryoSofu.OpportunityRef__r.Account.JizenwariKekaKikan__c == null){
            jizenwariDetail.put('jdn','0日～29日');
        }else{
            jizenwariDetail.put('jdn',sogiShiryoSofu.OpportunityRef__r.Account.JizenwariKekaKikan__c);
        }
        // 事前割日付（0日）
        jizenwariDetail.put('jd0',kisanbi);
        // 事前割日付（30日以降）
        jizenwariDetail.put('jd30',kisanbi30);
        // 事前割日付（1年以降）
        jizenwariDetail.put('jd1y',kisanbi1y);
        // 事前割日付（2年以降）
        jizenwariDetail.put('jd2y',kisanbi2y);
        // お客様ID
        jizenwariDetail.put('cno','お客様ID：'+sogiShiryoSofu.OpportunityRef__r.ShodanBangoF__c);
        
        jizenwariDetail = this.setPassword(this.getRandomString(12),sogiShiryoSofu,jizenwariDetail);
        
        return jizenwariDetail;
    }

    public List< Map<String, String> > createTeianshoMap (SogiShiryoSofu__c sogiShiryoSofu,List<TeianSho__c> teianshoListData){
        List<Map<String,String>> retTeianshoList = new List<Map<String,String>>();
        // TODO 提案書オブジェクトの配列をつかうようにする
        List<TeianSho__c> teianshoList = teianshoListData;
        for(TeianSho__c  teianshoData : teianshoList){
            Map<String, String> teianshoDetail = new Map<String, String>();
            // ロゴ
            teianshoDetail.put('t_lg','');
            // プラン画像
            teianshoDetail.put('t_pv','');
            // お客様名
            teianshoDetail.put('t_cn','');
            // 管理番号
            teianshoDetail.put('t_no','');
            // 作成日
            teianshoDetail.put('t_cd','');
            // 基本セットプラン
            teianshoDetail.put('t_pn','');
            // 式場名
            teianshoDetail.put('t_fn','');
            // 火葬場名
            teianshoDetail.put('t_kn','');
            // 基本セットプラン名
            teianshoDetail.put('t_pnd','');
            // 基本セットプラン料金
            teianshoDetail.put('t_pndp','');
            // 割引名1行目
            teianshoDetail.put('t_w1','');
            // 割引名金額1行目
            teianshoDetail.put('t_wp1','');
            // 割引名2行目
            teianshoDetail.put('t_w2','');
            // 割引名金額2行目
            teianshoDetail.put('t_wp2','');
            // 割引名3行目
            teianshoDetail.put('t_w3','');
            // 割引名金額3行目
            teianshoDetail.put('t_wp3','');
            // 小計①（税抜)
            teianshoDetail.put('t_sb1ot','');
            // 小計①（税込)
            teianshoDetail.put('t_sb1it','');
            // 斎場料金
            teianshoDetail.put('t_fp','');
            // 火葬場料金
            teianshoDetail.put('t_kp','');
            // 小計②（税込)
            teianshoDetail.put('t_sb2it','');
            // 追加オプション（品名）１行目
            teianshoDetail.put('t_opn1','');
            // 追加オプション（数量）１行目
            teianshoDetail.put('t_opm1','');
            // 追加オプション（金額）１行目
            teianshoDetail.put('t_opp1','');
            // 追加オプション（品名）2行目
            teianshoDetail.put('t_opn2','');
            // 追加オプション（数量）2行目
            teianshoDetail.put('t_opm2','');
            // 追加オプション（金額）2行目
            teianshoDetail.put('t_opp2','');
            // 追加オプション（品名）3行目
            teianshoDetail.put('t_opn3','');
            // 追加オプション（数量）3行目
            teianshoDetail.put('t_opm3','');
            // 追加オプション（金額）3行目
            teianshoDetail.put('t_opp3','');
            // 追加オプション（品名）4行目
            teianshoDetail.put('t_opn4','');
            // 追加オプション（数量）4行目
            teianshoDetail.put('t_opm4','');
            // 追加オプション（金額）4行目
            teianshoDetail.put('t_opp4','');
            // 小計③（税込)
            teianshoDetail.put('t_sb3it','');
            // 合計金額
            teianshoDetail.put('t_top','');
            // 割引名4行目
            teianshoDetail.put('t_w4','');
            // 割引名金額4行目
            teianshoDetail.put('t_wp4','');
            // 地域名
            teianshoDetail.put('t_aa','');
            // パスワード
            teianshoDetail.put('password','');
            // 式場項目表記
            teianshoDetail.put('t_sn','');
            // 火葬場項目表記
            teianshoDetail.put('t_kkn','');
            // 割引名5行目
            teianshoDetail.put('t_w5','');
            // 割引名金額5行目
            teianshoDetail.put('t_wp5','');
            // 追加オプション（品名）5行目
            teianshoDetail.put('t_opn5','');
            // 追加オプション（数量）5行目
            teianshoDetail.put('t_opm5','');
            // 追加オプション（金額）5行目
            teianshoDetail.put('t_opp5','');
            // 追加オプション（品名）6行目
            teianshoDetail.put('t_opn6','');
            // 追加オプション（数量）6行目
            teianshoDetail.put('t_opm6','');
            // 追加オプション（金額）6行目
            teianshoDetail.put('t_opp6','');
            // 追加オプション（品名）7行目
            // teianshoDetail.put('t_opn7','');
            // 追加オプション（品名）7行目
            // teianshoDetail.put('t_opm7','');
            // 追加オプション（品名）7行目
            // teianshoDetail.put('t_opp7','');
            switch on teianshoData.Service__c  {
                when 'お花いっぱいのお葬式' {
                    teianshoDetail.put('t_lg','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Jpg&versionId=0682v00000G2JU3&d=/a/2v000000cC3O/1IKnt1k1ubiR7OdoI4pC8v5zDGF3PAiV52EZYYwa5JI&oid=00D7F000001xTd0');
                }
                when 'よりそうのお葬式' {
                    teianshoDetail.put('t_lg','https://minrevi--c.ap15.content.force.com/sfc/dist/version/renditionDownload?rendition=ORIGINAL_Png&versionId=0682v00000G1wCI&d=/a/2v000000cBx6/Ga8uGFndUrX3UBv.mCcAZXskUb4pIKxaANXqKowR500&oid=00D7F000001xTd0');
                }
            }
            teianshoDetail.put('t_pv',this.getTeianshoImageURL(teianshoData.Plan__c));
            teianshoDetail.put('t_cn',sogiShiryoSofu.Atena__c );
            teianshoDetail.put('t_no',this.nullToblank(sogiShiryoSofu.Name));
            teianshoDetail.put('t_cd',this.formatDateTime(Date.today(),'yyyy/MM/dd'));
            teianshoDetail.put('t_pn',this.nullToblank(teianshoData.Plan__c));
            teianshoDetail.put('t_fn',this.nullToblank(teianshoData.ShikijoName__c));
            teianshoDetail.put('t_kn',this.nullToblank(teianshoData.KasobaName__c));
            teianshoDetail.put('t_sn',this.nullToblank(teianshoData.ShikijoMeisaiHyokiName__c));
            teianshoDetail.put('t_kkn',this.nullToblank(teianshoData.KasobaMeisaiHyokiName__c));
            teianshoDetail.put('t_pnd',this.nullToblank(teianshoData.Plan__c));
            teianshoDetail.put('t_pndp',this.convertYenText(this.nullToZero(teianshoData.PlanKihonKingakZeinuki__c),false));
            teianshoDetail.put('t_w1',this.nullToblank(teianshoData.Waribiki1_Hinmei__c));
            if(this.nullToblank(teianshoData.Waribiki1_Hinmei__c) != ''){
                teianshoDetail.put('t_wp1',this.convertYenText(this.nullToZero(teianshoData.Waribiki1_KingakuZeinuki__c),true));
            }
            teianshoDetail.put('t_w2',this.nullToblank(teianshoData.Waribiki2_Hinmei__c));
            if(this.nullToblank(teianshoData.Waribiki2_Hinmei__c) != ''){
                teianshoDetail.put('t_wp2',this.convertYenText(this.nullToZero(teianshoData.Waribiki2_KingakuZeinuki__c),true));
            }
            teianshoDetail.put('t_w3',this.nullToblank(teianshoData.Waribiki3_Hinmei__c));
            if(this.nullToblank(teianshoData.Waribiki3_Hinmei__c) != ''){
                teianshoDetail.put('t_wp3',this.convertYenText(this.nullToZero(teianshoData.Waribiki3_KingakuZeinuki__c),true));
            }
            teianshoDetail.put('t_w4',this.nullToblank(teianshoData.Waribiki4_Hinmei__c));
            if(this.nullToblank(teianshoData.Waribiki4_Hinmei__c) != '' ){
                teianshoDetail.put('t_wp4',this.convertYenText(this.nullToZero(teianshoData.Waribiki4_KingakuZeinuki__c),true));
            }
            teianshoDetail.put('t_w5',this.nullToblank(teianshoData.Waribiki5_Hinmei__c));
            if(this.nullToblank(teianshoData.Waribiki5_Hinmei__c) != '' ){
                teianshoDetail.put('t_wp5',this.convertYenText(this.nullToZero(teianshoData.Waribiki5_KingakuZeinuki__c),true));
            }
            teianshoDetail.put('t_sb1ot',this.convertYenText(this.nullToZero(teianshoData.Shokei1Zeinuki__c),false));
            teianshoDetail.put('t_sb1it',this.convertYenText(this.nullToZero(teianshoData.Shokei1Zeikomi__c),false));
            if(this.nullToblank(teianshoData.ShikijoMeisaiHyokiName__c) != ''){
                teianshoDetail.put('t_fp',this.convertYenText(this.nullToZero(teianshoData.ShikijoMeisaiKingaku__c),false));
            }
            if(this.nullToblank(teianshoData.KasobaMeisaiHyokiName__c) != ''){
                teianshoDetail.put('t_kp',this.convertYenText(this.nullToZero(teianshoData.KasobaMeisaiKingaku__c),false));
            }
            
            teianshoDetail.put('t_sb2it',this.convertYenText(this.nullToZero(teianshoData.Shokei2Zeikomi__c),false));
            if(this.nullToblank(teianshoData.TsuikaRyokin1_Hinmei__c) != ''){
                teianshoDetail.put('t_opn1',this.nullToblank(teianshoData.TsuikaRyokin1_Hinmei__c));
                teianshoDetail.put('t_opm1',this.zeroToblank(this.nullToZero(teianshoData.TsuikaRyokin1_Suryo__c)));
                teianshoDetail.put('t_opp1',this.convertYenText(this.nullToZero(teianshoData.TsuikaRyokin1_Kingaku__c),false));
            }
            if(this.nullToblank(teianshoData.TsuikaRyokin2_Hinmei__c) != ''){
                teianshoDetail.put('t_opn2',this.nullToblank(teianshoData.TsuikaRyokin2_Hinmei__c));
                teianshoDetail.put('t_opm2',this.zeroToblank(this.nullToZero(teianshoData.TsuikaRyokin2_Suryo__c)));
                teianshoDetail.put('t_opp2',this.convertYenText(this.nullToZero(teianshoData.TsuikaRyokin2_Kingaku__c),false));
            }
            if(this.nullToblank(teianshoData.TsuikaRyokin3_Hinmei__c) != ''){
                teianshoDetail.put('t_opn3',this.nullToblank(teianshoData.TsuikaRyokin3_Hinmei__c));
                teianshoDetail.put('t_opm3',this.zeroToblank(this.nullToZero(teianshoData.TsuikaRyokin3_Suryo__c)));
                teianshoDetail.put('t_opp3',this.convertYenText(this.nullToZero(teianshoData.TsuikaRyokin3_Kingaku__c),false));
            }
            if(this.nullToblank(teianshoData.TsuikaRyokin4_Hinmei__c) != ''){
                teianshoDetail.put('t_opn4',this.nullToblank(teianshoData.TsuikaRyokin4_Hinmei__c));
                teianshoDetail.put('t_opm4',this.zeroToblank(this.nullToZero(teianshoData.TsuikaRyokin4_Suryo__c)));
                teianshoDetail.put('t_opp4',this.convertYenText(this.nullToZero(teianshoData.TsuikaRyokin4_Kingaku__c),false));    
            }
            if(this.nullToblank(teianshoData.TsuikaRyokin5_Hinmei__c) != ''){
                teianshoDetail.put('t_opn5',this.nullToblank(teianshoData.TsuikaRyokin5_Hinmei__c));
                teianshoDetail.put('t_opm5',this.zeroToblank(this.nullToZero(teianshoData.TsuikaRyokin5_Suryo__c)));
                teianshoDetail.put('t_opp5',this.convertYenText(this.nullToZero(teianshoData.TsuikaRyokin5_Kingaku__c),false));    
            }
            if(this.nullToblank(teianshoData.TsuikaRyokin6_Hinmei__c) != ''){
                teianshoDetail.put('t_opn6',this.nullToblank(teianshoData.TsuikaRyokin6_Hinmei__c));
                teianshoDetail.put('t_opm6',this.zeroToblank(this.nullToZero(teianshoData.TsuikaRyokin6_Suryo__c)));
                teianshoDetail.put('t_opp6',this.convertYenText(this.nullToZero(teianshoData.TsuikaRyokin6_Kingaku__c),false));    
            }
            // TODO fix後削除
            // if(this.nullToblank(teianshoData.TsuikaRyokin7_Hinmei__c) != ''){
            //     teianshoDetail.put('t_opn7',this.nullToblank(teianshoData.TsuikaRyokin7_Hinmei__c));
            //     teianshoDetail.put('t_opm7',this.zeroToblank(this.nullToZero(teianshoData.TsuikaRyokin7_Suryo__c)));
            //     teianshoDetail.put('t_opp7',this.convertYenText(this.nullToZero(teianshoData.TsuikaRyokin7_Kingaku__c),false));    
            // }
            teianshoDetail.put('t_sb3it',this.convertYenText(this.nullToZero(teianshoData.Shokei3Zeikomi__c),false));
            teianshoDetail.put('t_top',this.zeroToblank(this.nullToZero(teianshoData.GoukeiKingaku__c)));
            teianshoDetail.put('t_aa',this.nullToblank(teianshoData.KiboArea__c));
            teianshoDetail = this.setPassword(this.getRandomString(12),sogiShiryoSofu,teianshoDetail);
            retTeianshoList.add(teianshoDetail);
        }
        return retTeianshoList;
    }

    public String formatDateTime ( Date value , String format){
        if(value == null){
            return '';
        }
        Datetime fDatetime = Datetime.newInstance(value.year(), value.month(), value.day());
        String dt_str = fDatetime.format(format);
        return dt_str;
    }

    public SougiShiryoSakuseiResult postOproPdf(SogiShiryoSofu__c argSogiShiryoSofu ){
        SogiShiryoSofu__c sogiShiryoSofu = argSogiShiryoSofu;
        List < SogiShiryoSofuMeisai__c > sogishiryoSofuMeisai = [select 
                                                                    SaijoRef__c,
                                                                    SaijoRef__r.Name,
                                                                    SaijoRef__r.AccessHohoBasu__c, 
                                                                    SaijoRef__r.AccessHohoKuruma__c,
                                                                    SaijoRef__r.AccessHouhouDensha__c,
                                                                    SaijoRef__r.KaminShisetsuUmuAnchiKikanchu__c,
                                                                    SaijoRef__r.ShinzokuHikaeshitsu__c,
                                                                    SaijoRef__r.AnchiShisetsu__c,
                                                                    SaijoRef__r.KurumaisuTaio__c,
                                                                    SaijoRef__r.IdoKedo__latitude__s,
                                                                    SaijoRef__r.IdoKedo__longitude__s,
                                                                    SaijoRef__r.ChushajoAri__c,
                                                                    SaijoRef__r.ChushaDaisu__c,
                                                                    SaijoRef__r.Jusho__c,
                                                                    SaijoRef__r.ShisetsuKubun__c,
                                                                    SaijoRef__r.SaijoKeisaiJohoId__c,
                                                                    ShisetsuRef__c,
                                                                    ShisetsuKubun__c,
                                                                    SogiShiryoSofuRef__c,
                                                                    ShisetsuRef__r.Name, 
                                                                    ShisetsuRef__r.AccessHohoKuruma__c,
                                                                    ShisetsuRef__r.AccessHouhouDensha__c,
                                                                    ShisetsuRef__r.AccessHohoBasu__c,
                                                                    ShisetsuRef__r.ChushajoAri__c,
                                                                    ShisetsuRef__r.ShukuhakuKa__c,
                                                                    ShisetsuRef__r.ShinzokuHikaeshitsuAri__c,
                                                                    ShisetsuRef__r.ShawaRoomAri__c,
                                                                    ShisetsuRef__r.Bariafuri__c,
                                                                    ShisetsuRef__r.BebiRoomAri__c,
                                                                    ShisetsuRef__r.AnchiKa__c,
                                                                    ShisetsuRef__r.KoeiMinei__c,
                                                                    ShisetsuRef__r.Jusho__c,
                                                                    ShisetsuRef__r.Chushadaisu__c,
                                                                    ShisetsuRef__r.IdoKedo__latitude__s,
                                                                    ShisetsuRef__r.IdoKedo__longitude__s,
                                                                    ShisetsuRef__r.KasobaKeisaiJohoId__c,
                                                                    Hyojijun__c 
                                                                    from SogiShiryoSofuMeisai__c 
                                                                    where SogiShiryoSofuRef__c =: argSogiShiryoSofu.Id
                                                                    order by Hyojijun__c 
                                                                ];
        List<String> saijyoIdList = new List<String>();
        List<String> kasouIdList = new List<String>();
        for(SogiShiryoSofuMeisai__c  saiJyoData : sogishiryoSofuMeisai){
            if(saiJyoData.SaijoRef__c != null){
                saijyoIdList.add(saiJyoData.SaijoRef__c);
            }
            if(saiJyoData.ShisetsuRef__c != null){
                kasouIdList.add(saiJyoData.ShisetsuRef__c);
            }
        }
        List<Saijo__c> saijyoData = [select Id,
                                            (
                                                select SaijoRef__c,
                                                ImageUrl__c,
                                                Purpose__c
                                                from SaijoSaijoImgs__r
                                            ),(
                                                select SaijoRef__c,
                                                hallKeisaiJohoId__c,
                                                SaijoKeisaiJohoId__c,
                                                X1ShiyoRyokinIppan__c,
                                                X1ShiyoRyokinShimin__c,
                                                X1ShiyoRyokinSonota__c,
                                                X2ShiyoRyokinIppan__c,
                                                X2ShiyoRyokinShimin__c,
                                                X2ShiyoRyokinSonota__c
                                                from SaijoShikijos__r
                                            ) from Saijo__c
                                            where Id IN :saijyoIdList];
        List<Shisetsu__c> kasouData = [select Id,(
                                                    select ImageUrl__c,
                                                    Purpose__c
                                                    from ShisetsuImgs__r
                                                ) from Shisetsu__c
                                                where Id IN :kasouIdList];
        List<TeianSho__c> teianshoData = [select Id,
                                        Service__c,
                                        Plan__c,
                                        PlanKihonKingaku__c,
                                        MemberSeido__c,
                                        KasobaName__c,
                                        KasobaMeisaiKingaku__c,
                                        KasobaMeisaiHyokiName__c,
                                        Waribiki1_Kingaku__c,
                                        Waribiki1_Hinmei__c,
                                        Waribiki2_Kingaku__c,
                                        Waribiki2_Hinmei__c,
                                        Waribiki3_Kingaku__c,
                                        Waribiki3_Hinmei__c,
                                        Waribiki4_Kingaku__c,
                                        Waribiki4_Hinmei__c,
                                        Waribiki5_Kingaku__c,
                                        Waribiki5_Hinmei__c,
                                        WaribikiKingakuKeiExp__c,
                                        ShikijoName__c,
                                        ShikijoMeisaiKingaku__c,
                                        ShikijoMeisaiHyokiName__c,
                                        Shokei1Zeikomi__c,
                                        Shokei1Zeinuki__c,
                                        Shokei2Zeikomi__c,
                                        Shokei3Zeikomi__c,
                                        TsuikaRyokin1_Kingaku__c,
                                        TsuikaRyokin1_Suryo__c,
                                        TsuikaRyokin1_Hinmei__c,
                                        TsuikaRyokin2_Kingaku__c,
                                        TsuikaRyokin2_Suryo__c,
                                        TsuikaRyokin2_Hinmei__c,
                                        TsuikaRyokin3_Kingaku__c,
                                        TsuikaRyokin3_Suryo__c,
                                        TsuikaRyokin3_Hinmei__c,
                                        TsuikaRyokin4_Kingaku__c,
                                        TsuikaRyokin4_Suryo__c,
                                        TsuikaRyokin4_Hinmei__c,
                                        TsuikaRyokin5_Kingaku__c,
                                        TsuikaRyokin5_Suryo__c,
                                        TsuikaRyokin5_Hinmei__c,
                                        TsuikaRyokin6_Kingaku__c,
                                        TsuikaRyokin6_Suryo__c,
                                        TsuikaRyokin6_Hinmei__c,
                                        TsuikaRyokin7_Kingaku__c,
                                        TsuikaRyokin7_Suryo__c,
                                        TsuikaRyokin7_Hinmei__c,
                                        GoukeiKingaku__c,
                                        PlanKihonKingakZeinuki__c,
                                        Waribiki1_KingakuZeinuki__c,
                                        Waribiki2_KingakuZeinuki__c,
                                        Waribiki3_KingakuZeinuki__c,
                                        Waribiki4_KingakuZeinuki__c,
                                        Waribiki5_KingakuZeinuki__c,
                                        KiboArea__c 
                                        from TeianSho__c WHERE SogiShiryoSofuRef__c =: argSogiShiryoSofu.Id 
                                        order by GoukeiKingaku__c asc
                                        ];

        List<String> createReportName = this.margeInsatsubutsuIchiran(sogiShiryoSofu.InsatsubutsuIchiran__c,sogiShiryoSofu);
        String oproTemplateParam = '';
        oproTemplateParam = this.createRequestTemprateParam(createReportName,saijyoData);
        String oproTemplateData = '';
        oproTemplateData = this.createTemplateData(createReportName,sogiShiryoSofu,saijyoData,kasouData,sogishiryoSofuMeisai,teianshoData);
        OpfcConfs.Config theConfig = OpfcConfs.getConfig();
        String oproSendParam = 'CID='+theConfig.opro_cid+'&UID='+theConfig.opro_uid+'&UPW='+ theConfig.opro_upw +'&OP=dlp&FE=true&RF=10&UPD=1&CDATE='+ DateTime.now().format('yyMMddhhmmss') + '&';
        oproSendParam = oproSendParam +  oproTemplateParam + oproTemplateData;
        String oproResult = '';
        Result theResult = new Result();
        try {
            String postUrl = theConfig.base_url + '/AsyncFacade';
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');

            theResult.endPoint = postUrl;
            request.setEndpoint(postUrl);

            theResult.reqBodyRaw = oproSendParam;
            request.setBody( oproSendParam );

            request.setTimeout(60000);
            HttpResponse response = new http().send(request);
            System.debug(oproSendParam);
            System.debug('http().send(request) done.');
            System.debug(response);
            theResult.statusCode = response.getStatusCode();
            theResult.resBodyRaw = response.getBody();
            if(theResult.statusCode == 200 || theResult.statusCode == 202){
                theResult.isSuccess = true;
            }else{
                theResult.isSuccess = false;
            }
            oproResult = response.getBody();
        } catch (Exception e) {
            theResult.isSuccess = false;
            theResult.descr = 'exception error :'+e.getMessage() +' oproSendParam : '+ oproSendParam ;
            System.Debug(theResult.descr);
        }
        if(!theResult.isSuccess){
            if(theResult.statusCode != 503 && theResult.statusCode  != 402){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200708-1132-01', 'SougiShiryoSakusei.postOproPdf')
                    .putAttr('theResult.endPoint', theResult.endPoint)
                    .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                    .putAttr('theResult.descr',theResult.descr)
                    .putAttr('sogishiryoSofu.Id',argSogiShiryoSofu.Id)
                );
            }else{
                System.debug('theResult.statusCode:' + theResult.statusCode.format() );
                System.debug('body...:' + oproResult);
                throw new RequestServiceUnavailableException();
            }
        }
        OproResult result = new OproResult();
        SougiShiryoSakuseiResult shiryoSakuseiResult = new SougiShiryoSakuseiResult();
        result = (OproResult) JSON.deserialize(oproResult, OproResult.class);
        shiryoSakuseiResult.path = result.path;
        shiryoSakuseiResult.password = oproPdfPassWord;
        return shiryoSakuseiResult;
    }

    public List<String>  margeInsatsubutsuIchiran(String InsatsubutsuIchiran,SogiShiryoSofu__c sogiShiryoSofu){
        Boolean mitsumoriFlag = false;
        if(InsatsubutsuIchiran.indexOf('提案書') != -1){
            mitsumoriFlag = true;
        }
        List<String> ichiranList = InsatsubutsuIchiran.split(';');
        List<String> retList = new List<String>();
        if(sogiShiryoSofu.SofuShubetsu__c == 'メール' || sogiShiryoSofu.SofuShubetsu__c == 'FAX' ){
            for(String ichiran : ichiranList){
                if(ichiran == '斎場資料' ){
                    retList.add('表紙');
                }
                retList.add(ichiran);
                if(!mitsumoriFlag && ichiran == '斎場資料' ){
                    retList.add('裏表紙');
                }
                if(mitsumoriFlag && ichiran == '提案書'){
                    retList.add('裏表紙');
                }
            }
        }else{
            for(String ichiran : ichiranList){
                retList.add(ichiran);
            }
        }
        return retList;
    }

    public Map<String , List<String> > conversionMapSaijyoImageData(List<Saijo__c> saijyoData){
        Map<String , List<String> > retImageMap = new Map<String , List<String> >();
        for( Saijo__c record :saijyoData){
            List<String> imageUrlList = new List<String>();
            for(String sortKey : this.getImageSortKeyList()){
                for(SaijoImg__c image : record.SaijoSaijoImgs__r){
                    if(image.Purpose__c == sortKey ){
                        imageUrlList.add(image.ImageUrl__c);
                        break;
                    }
                }
            }
            retImageMap.put(record.Id,imageUrlList);
        }
        return retImageMap;
    }

    public Map<String , List<String> > conversionMapKasouImageData(List<Shisetsu__c> kasouData){
        Map<String , List<String> > retImageMap = new Map<String , List<String> >();
        for( Shisetsu__c record :kasouData){
            List<String> imageUrlList = new List<String>();
            for(ShisetsuImg__c image : record.ShisetsuImgs__r){
                imageUrlList.add(image.ImageUrl__c);
                System.Debug(image.ImageUrl__c);
            }
            retImageMap.put(record.Id,imageUrlList);
        }
        return retImageMap;
    }

    public Map <String,List< Map < String, String > > > conversionMapSsaijyouHallData ( List<Saijo__c> saijyoData){
        Map<String,List< Map < String, String > >> retMap = new Map<String,List< Map < String, String > >>();
        List< Map < String, String > > saijyoHallList = new List<Map < String, String > >();
        for(Saijo__c row :saijyoData ) {
            for(SaijoHall__c hall  : row.SaijoShikijos__r){
                Map <String ,String > saijyoHallDetail = new Map<String ,String >();
                saijyoHallDetail.put('SaijoRef__c',hall.SaijoRef__c);
                saijyoHallDetail.put('SaijoKeisaiJohoId__c',hall.SaijoKeisaiJohoId__c);
                saijyoHallDetail.put('X1ShiyoRyokinIppan__c',this.nullToZero(hall.X1ShiyoRyokinIppan__c).format());
                saijyoHallDetail.put('X1ShiyoRyokinShimin__c',this.nullToZero(hall.X1ShiyoRyokinShimin__c).format());
                saijyoHallDetail.put('X1ShiyoRyokinSonota__c',this.nullToZero(hall.X1ShiyoRyokinSonota__c).format());
                saijyoHallDetail.put('X2ShiyoRyokinIppan__c',this.nullToZero(hall.X2ShiyoRyokinIppan__c).format());
                saijyoHallDetail.put('X2ShiyoRyokinShimin__c',this.nullToZero(hall.X2ShiyoRyokinShimin__c).format());
                saijyoHallDetail.put('X2ShiyoRyokinSonota__c',this.nullToZero(hall.X2ShiyoRyokinSonota__c).format());
                saijyoHallList.add(saijyoHallDetail);
            }
            retMap.put(row.Id,saijyoHallList);
        }
        return retMap;
    }


    public String createTemplateData(List<String> createReportName , SogiShiryoSofu__c sogiShiryoSofu,
    List<Saijo__c> saijyoData,List<Shisetsu__c> kasouData,List < SogiShiryoSofuMeisai__c > sogishiryoSofuMeisai,List<TeianSho__c> teianshoData ){
        String retParam = '';
        String tdParam = 'TD';
        integer reportNumber = 0;
        integer createReportCount = 0;
        Map<String , List<String> > saijyoImageMap = this.conversionMapSaijyoImageData(saijyoData);
        Map<String , List<String> > kasouImageMap = this.conversionMapKasouImageData(kasouData);
        for(String reportName : createReportName){
            reportNumber++;
            createReportCount++;
            switch on reportName {
                when '表紙' {
                    retParam = retParam + tdParam + reportNumber.format() + '_1=';
                    Map<String, String> hyoshiData = this.createHyoshiMap(this.getRandomString(12),sogiShiryoSofu);
                    if(createReportName.size() != createReportCount){
                        retParam = retParam + this.getOproUrlEncodeFromMap(hyoshiData)+'&';
                    }else{
                        retParam = retParam + this.getOproUrlEncodeFromMap(hyoshiData);
                    }
                }
                when '送付状' {
                    retParam = retParam + tdParam + reportNumber.format() + '_1=';
                    Map<String,String> soufujyoData = this.createSoufujyouMap(sogiShiryoSofu);
                    if(createReportName.size() != createReportCount){
                        retParam = retParam + this.getOproUrlEncodeFromMap(soufujyoData)+'&';
                    }else{
                        retParam = retParam + this.getOproUrlEncodeFromMap(soufujyoData);
                    }
                }
                when '斎場資料' {
                    retParam = retParam + tdParam + reportNumber.format() + '_1=';
                    Map<String, String> saijyoList = this.createSaijyouIchiranList(sogishiryoSofuMeisai,saijyoData,sogiShiryoSofu,saijyoImageMap,kasouImageMap);
                    retParam = retParam + this.getOproUrlEncodeFromMap(saijyoList)+'&';
                    if(saijyoData.size() > 0){
                        reportNumber++;
                        retParam = retParam + tdParam + reportNumber.format() + '_1=';
                        List< Map<String, String> >  facilitySaijyoList = this.createFacilityMap(sogiShiryoSofu,saijyoData,'斎場',kasouData,saijyoImageMap,sogishiryoSofuMeisai);
                        retParam = retParam + this.getOproUrlEncodeFromList(facilitySaijyoList)+'&';
                    }
                    reportNumber++;
                    retParam = retParam + tdParam + reportNumber.format() + '_1=';
                    List< Map<String, String> >  facilityKasouList = this.createFacilityMap(sogiShiryoSofu,saijyoData,'火葬場',kasouData,kasouImageMap,sogishiryoSofuMeisai);
                    if(createReportName.size() != createReportCount){
                        retParam = retParam + this.getOproUrlEncodeFromList(facilityKasouList)+'&';
                    }else{
                        retParam = retParam + this.getOproUrlEncodeFromList(facilityKasouList);
                    }
                }
                when '提案書' {
                    retParam = retParam + tdParam + reportNumber.format() + '_1=';
                    List< Map<String, String> > teianshoList = this.createTeianshoMap(sogiShiryoSofu,teianshoData);
                    if(createReportName.size() != createReportCount){
                        retParam = retParam + this.getOproUrlEncodeFromList(teianshoList)+'&';
                    }else{
                        retParam = retParam + this.getOproUrlEncodeFromList(teianshoList);
                    }
                }
                when '事前割証書' {
                    retParam = retParam + tdParam + reportNumber.format() + '_1=';
                    Map<String,String> soufujyoData = this.createJizenwariMap(sogiShiryoSofu);
                    if(createReportName.size() != createReportCount){
                        retParam = retParam + this.getOproUrlEncodeFromMap(soufujyoData)+'&';
                    }else{
                        retParam = retParam + this.getOproUrlEncodeFromMap(soufujyoData);
                    }
                }
            }
        }
        System.debug(retParam);
        return retParam ;
    }

    public String createRequestTemprateParam( List<String> createReportName , List<Saijo__c> saijyoData ){
        String retParam = '';
        String tpParam = 'TP';
        integer reportNumber = 0;
        for(String reportName : createReportName){
            reportNumber++;
            switch on reportName {
                when '送付状' {
                    retParam = retParam + tpParam +reportNumber.format() + '=live_Shikijyo_Shiryo_Soufujyou_v20200806&';
                }
                when'首都圏案内文'{
                    retParam = retParam + tpParam +reportNumber.format() + '=live_Shikijyo_ShutokenAnnai&';
                }
                when '表紙' {
                    retParam = retParam + tpParam +reportNumber.format() + '=live_Shikijyo_Siryo_hyoshi&';
                }
                when '斎場資料' {
                    retParam = retParam + tpParam + reportNumber.format() + '=live_Shikijyo_ichiranv20200715&';
                    if(saijyoData.size() > 0 ){
                        reportNumber++;
                        retParam = retParam + tpParam + reportNumber.format() + '=live_Shikijyo_Shosai&';
                    }
                    reportNumber++;
                    retParam = retParam + tpParam + reportNumber.format() + '=live_Shikijyo_Shosai_kasouba&';
                }
                when '提案書' {
                    retParam = retParam + tpParam + reportNumber.format() + '=live_Shikijyo_Teiansho_v20201001&';
                }
                when '裏表紙' {
                    retParam = retParam + tpParam +reportNumber.format() + '=live_Shikijyo_Siryo_urahyoshi&';
                }
                when '事前割証書' {
                    retParam = retParam + tpParam + reportNumber.format() + '=live_Shikijyo_Siryo_Jizenwari_v20200717&';
                    reportNumber++;
                    retParam = retParam + tpParam + reportNumber.format() + '=live_Shikijyo_Siryo_jizenwari_ura&';
                }
            }
        }
        System.debug(retParam);
        return retParam;
    }
    public String getOproUrlEncodeFromMap(Map<String, String> mapobj){
        String retMap = '';
        List<String> HeaderList = new List<String>();
        List<String> dataList = new List<String>();
        List<String> keyList = new List<String>();
        for(String mapKey : mapobj.keySet()){
            HeaderList.add('"'+ mapKey +'"');
            keyList.add(mapKey);
        }
        retMap = String.join(HeaderList,',') + '\r\n';
        for(String mapKey : keyList){
            dataList.add('"' + mapobj.get(mapKey)+ '"');
        }
        retMap = retMap + String.join(dataList,',');
        System.debug(retMap);
        return EncodingUtil.urlEncode(retMap, 'UTF-8');
    }

    public String getOproUrlEncodeFromList(List<Map<String,String> > listObj){
        String retMap = '';
        Map <String,String> row = new Map<String, String>();
        if(listObj.size() > 0){
            row = listObj.get(0);
        }
        
        List<String> keyList = new List<String>();
        List<String> HeaderList = new List<String>();
        for(String mapKey : row.keySet()){
            HeaderList.add('"'+ mapKey +'"');
            keyList.add(mapKey);
        }
        retMap = String.join(HeaderList,',') + '\r\n';
        Integer ListCount = listObj.size();
        Integer ListIndex = 1;
        for( Map <String,String> maprow : listObj){
            List<String> dataList = new List<String>();
            for(String keyName : keyList){
                dataList.add('"' + maprow.get(keyName)+ '"');
            }
            if(ListIndex == ListCount){
                retMap = retMap + String.join(dataList,',');
            }else{
                retMap = retMap + String.join(dataList,',')+ '\r\n';
            }
            System.debug(retMap);
            ListIndex++;
        }
        
        return EncodingUtil.urlEncode(retMap, 'UTF-8');
    }

    public String nullToblank(String value){
        if(value == null){
            return '';
        }
        return this.repraceDoublequotation(value);
    }

    public Integer nullToZero(Decimal value){
        if(value == null){
            return 0;
        }
        return value.intValue();
    }

    public String zeroToblank(Integer value){
        if(value == 0){
            return '';
        }
        return value.format();
    }

    public String convertYenText (Integer value,Boolean waribikiFlag){
        if(waribikiFlag){
            return '-' + value.format()+'円';
        }else{
            return value.format()+'円';
        }
        
    }

    public String repraceDoublequotation (String value ){
        return value.replace('"','＂');
    }

    public String textOverflowconversion(String value){
        // 16文字以上は15文字・・・にする
        String retString = '';
        if(value.length() > SAIJONAME_MAX_LENGTH){
            retString = value.substring(0,SAIJONAME_MAX_LENGTH -1)+'…';
        }else{
            retString = value;
        }
        return retString;
    }

    public String createGoogleMapUrl ( Decimal latitudeValue , Decimal longitudeValue){
        if(latitudeValue == null || longitudeValue == null ){
            return '';
        }
        String baseUrl = 'https://maps.googleapis.com/maps/api/staticmap?center=';
        String baseOption ='&size=380x310&sensor=false&zoom=16&markers=';
        String baseAPIkeys = '&key=AIzaSyBX_4BgwUf2UWpj7tH6wZFAazUJygKa3B8';
        return baseUrl + latitudeValue + ',' + longitudeValue + baseOption + latitudeValue + ',' + longitudeValue + baseAPIkeys;
    }

    public String createFacilityQrCode(String saijokeisaiJohoId,String facilityType){
        String baseQrUrl = '';
        switch on facilityType {
            when '斎場' {
                baseQrUrl ='https://www.yoriso.com/sogi/saijyo-arealist/saijyo-citieslist/saijyo-placeablelist/saijyo-detail/?hid='+saijokeisaiJohoId+'&ref=qrcode';
            }
            when '火葬場' {
                baseQrUrl ='https://www.yoriso.com/sogi/saijyo-arealist/saijyo-citieslist/saijyo-placeablelist/kasou-detail/?hid='+saijokeisaiJohoId+'&ref=qrcode';
            }
        }
        String requestQrUrl = EncodingUtil.urlEncode(baseQrUrl, 'UTF-8');
        String qrUrl = 'https://image-charts.com/chart?cht=qr&chs=50x50&chld=L|0&chl=' + requestQrUrl;
        return qrUrl;
    }
    public string getRandomString(Integer LengthRequired){
        String CharList = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String numList = '0123456789';
        String kigouList = '!#$%\'()*,./:;<=>?@[]^_`{|}~';
        String Res = '';
        integer position;
        integer positionkigou;
        integer positionNum;
        List<integer> randomList = this.getuniquerandomNumber(2,LengthRequired);
        Integer addkigouIndexkigou = randomList.get(0);
        Integer addkigouIndexNum = randomList.get(1);
        for(Integer i = 0; i < LengthRequired; i++) {
            position = Integer.valueof(String.valueof(Math.roundToLong(CharList.length()*Math.random()))) -1;
            positionkigou = Integer.valueof(String.valueof(Math.roundToLong(kigouList.length()*Math.random()))) -1;
            positionNum = Integer.valueof(String.valueof(Math.roundToLong(numList.length()*Math.random()))) -1;
            if(position < 0){
                position = 0;
            }
            if(positionkigou < 0){
                positionkigou = 0;
            }
            if(positionNum < 0){
                positionNum = 0;
            }
            if(i == addkigouIndexkigou){
                Res = Res + kigouList.substring(positionkigou,positionkigou+1);
            }else if(i == addkigouIndexNum){
                Res = Res + numList.substring(positionNum,positionNum+1);
            }else{
                Res = Res + CharList.substring(position,position+1);
            }
        }
        return Res;
    }

    public List<integer> getuniquerandomNumber (integer listsize,integer upperLimit ) {
        List<integer> intlist = new List<integer>();

        Map<integer, integer> randMap = new Map<integer, integer>();
        integer count = 0;
        while (true) {
            Integer randNum = Math.round(Math.random()*1000);
            Integer romdomNum = Math.mod(randNum, upperLimit-1);
            randMap.put(romdomNum,romdomNum);
            if(randMap.size() == listsize){
                break;
            }
            if(count == 100){
                break;
            }
            count++;
        }
        for(integer randkey : randMap.keySet()){
            intlist.add(randkey);
        }
        return intlist;
    }

    public class RequestServiceUnavailableException extends Exception{}

    @TestVisible
    public class JSONTokenOproResponse {
        public String path;
    }
}