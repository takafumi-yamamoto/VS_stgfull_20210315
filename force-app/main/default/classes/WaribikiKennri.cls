/**
* 割引権利
*/
public class WaribikiKennri {
    public WaribikiData f_waribikiData;

    public WaribikiKennri(){
        this.f_waribikiData = new WaribikiData();
    }

    /////////////////////////////割引権利保有認識条件
	// ポスタルくらぶ会員
	// 流入経路（新規）= ポスタルくらぶ
    private Boolean isPostalClubKaiin(Opportunity opp){
        Map<Id,Keiyaku__c> theKeiyakuIdMap = KeiyakuCachedDaos.getInstance().SelectAlliance();
        if(theKeiyakuIdMap != null){
            for(Keiyaku__c theKeiyaku : theKeiyakuIdMap.values()){
                if(theKeiyaku.Name.contains('ポスタルくらぶ') && opp.AllianceRef__c == theKeiyaku.Id){
                    return true;
                }
            }
        }
    	return false;
    }

    /*
    旧事前割
    事前割
	.where ( x.契約者 = 商談.相談者 )
	.where( x.RiyoKaisuSeigenAriExp__c == true )
	.where( x.KeiyakuStatusCdExp__c in (Active,Activating) )
	.where(x.Yuko_kigenStart__c <= 商談.問合せ日)
	.where(x.Yuko_kigenEnd__c > 商談.問合せ日)
	.count() > 0
    */
    private Boolean isOldJizenwari(Jizenwari__c jizenwari, Opportunity opp){
    	Boolean result = true;
    	if(jizenwari == null || jizenwari.id == null)
    		return false;

    	result = jizenwari.KeiyakuSha__c == opp.AccountId
                && jizenwari.RiyoKaisuSeigenAriExp__c == true //履行回数制限有exp
    			&& (jizenwari.KeiyakuStatusCdExp__c == 'Activating'
                    || jizenwari.KeiyakuStatusCdExp__c == 'Active' )
    			&& ((jizenwari.Yuko_kigenStart__c <= opp.Req_Day__c // 有効期限開始日
                    && jizenwari.Yuko_kigenEnd__c > opp.Req_Day__c)
                    || (jizenwari.Yuko_kigenStart__c <= system.today() // 有効期限開始日
                    && jizenwari.Yuko_kigenEnd__c > system.today())); // 有効期限終了日
    	return result;
    }

	//MemberTokutenKubunCode__c,
	//"NotMember", "非メンバー",
	//"Muryo","無料メンバー",
	//"ItteiJoken","Web事前準備登録メンバー",
	//"Jizenwari","事前割メンバー",
	//"OsoshikiYoyaku","お葬式予約メンバー",

	//よりそうメンバー割-無料メンバー
    private Boolean isYorisoMuryoMember(Opportunity opp){
    	return opp.Account.MemberTokutenKubunCode__c == 'Muryo'
                || opp.TaishosyaRef__r.MemberTokutenKubunCode__c == 'Muryo';
    }

	//よりそうメンバー割-無料メンバー-Web事前準備
    private Boolean isYorisoItteiJokenMember(Opportunity opp){
    	return opp.Account.MemberTokutenKubunCode__c == 'ItteiJoken'
                || opp.TaishosyaRef__r.MemberTokutenKubunCode__c == 'ItteiJoken';
    }

	//よりそうメンバー割-事前割メンバー
    private Boolean isYorisoJizenwariMember(Opportunity opp){
    	return opp.Account.MemberTokutenKubunCode__c == 'Jizenwari'
                || opp.TaishosyaRef__r.MemberTokutenKubunCode__c == 'Jizenwari';
    }

	//よりそうメンバー割-お葬式予約メンバー
    private Boolean isYorisoOsoshikiYoyakuMember(Opportunity opp){
    	return opp.Account.MemberTokutenKubunCode__c == 'OsoshikiYoyaku'
                || opp.TaishosyaRef__r.MemberTokutenKubunCode__c == 'OsoshikiYoyaku';
    }

	//資料請求割_旧制度
    public Boolean isOldSiryouseikyu(Opportunity opp){
    	//[ヨリソウ以降の問合せ]=false && [資料請求有]=true
    	return (isFromKagakuCom(opp) || isYorisoYikouToiawase(opp) == false) && isSiryoSeikyuoAri(opp);
    }

	//資料請求割_安豪資料請求割
    public Boolean isSimpleYasugoSiryouseikyu(Opportunity opp){
    	return !isFromKagakuCom(opp) && isYorisoYikouToiawase(opp) && isSiryoSeikyuoAri(opp);
    }

    // ヨリソウ以降の問合せ
	// 商談.問合せ日 >= 2018/03/01
    private Boolean isYorisoYikouToiawase(Opportunity opp){
    	Date yorisoReleaseDate = Date.newInstance(2018, 3, 1);
    	return opp.Req_Day__c >= yorisoReleaseDate;
    }

    // 資料請求有
    // 商談.ShiryoSeikyuUmuExp__c = true || 商談.流入元 contains(価格.com)
    // 価格.comの判断は　ShiryoSeikyuUmuExp__c　に入れました。
    private Boolean isSiryoSeikyuoAri(Opportunity opp){
    	//String iriguchi = Utility_Common.str(opp.Iriguchi__c);
    	return opp.ShiryoSeikyuUmuExp__c;
    }

    // 商談.流入元は価格.com　からの判定
    private Boolean isFromKagakuCom(Opportunity opp){
        Map<Id,Keiyaku__c> theKeiyakuIdMap = KeiyakuCachedDaos.getInstance().SelectAlliance();
        System.debug('opp.AllianceRef__c:' + opp.AllianceRef__c);
        for(Keiyaku__c theKeiyaku : theKeiyakuIdMap.values()){
            System.debug('theKeiyaku.Name:' + theKeiyaku.Name);
          if(theKeiyaku.Name.contains('カカクコム') || theKeiyaku.Name.contains('カカクコム')){
            System.debug('theKeiyaku.Id:' + theKeiyaku.Id);
            if(opp.AllianceRef__c == theKeiyaku.Id){
                return true;
            }
          }
        }

        return false;
    }


    //直葬の判断 : シンプルなお葬式　火葬式　直葬プラン
    private Boolean isTyokuso(String shohinBango){
        return shohinBango == 'SBG-0000001' || shohinBango == 'SBG-0001001' ;
    }

    //シンプルなお葬式　火葬式　
    private Boolean isSimpleNoTyokusoIgai(String shohinBango){
        Boolean flag =  shohinBango == 'SBG-0000002' ||    // シンプルなお葬式　火葬式　無宗教プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000003' ||   // シンプルなお葬式　火葬式　仏式プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000004' ||   // シンプルなお葬式　火葬式　花束プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000005' ||   // シンプルなお葬式　一日葬　無宗教プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000006' ||   // シンプルなお葬式　一日葬　仏式プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000007' ||   // シンプルなお葬式　一日葬　お花増量プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000008' ||   // シンプルなお葬式　家族葬　無宗教プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000009' ||   // シンプルなお葬式　家族葬　仏式プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000010' ||   // シンプルなお葬式　家族葬　お花増量プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000011' ||   // シンプルなお葬式　一般葬　無宗教プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000012' ||   // シンプルなお葬式　一般葬　仏式プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000013' ||    // シンプルなお葬式　一般葬　お花増量プラン[2019/9/30迄]
                        shohinBango == 'SBG-0001002' ||    // よりそうのお葬式　火葬式　無宗教プラン
                        shohinBango == 'SBG-0001003' ||    // よりそうのお葬式　火葬式　仏式プラン
                        shohinBango == 'SBG-0001004' ||    // よりそうのお葬式　火葬式　花束プラン
                        shohinBango == 'SBG-0001005' ||    // よりそうのお葬式　一日葬　無宗教プラン
                        shohinBango == 'SBG-0001006' ||    // よりそうのお葬式　一日葬　仏式プラン
                        shohinBango == 'SBG-0001007' ||    // よりそうのお葬式　一日葬　お花増量プラン
                        shohinBango == 'SBG-0001008' ||    // よりそうのお葬式　家族葬　無宗教プラン
                        shohinBango == 'SBG-0001009' ||    // よりそうのお葬式　家族葬　仏式プラン
                        shohinBango == 'SBG-0001010' ||    // よりそうのお葬式　家族葬　お花増量プラン
                        shohinBango == 'SBG-0001011' ||    // よりそうのお葬式　一般葬　無宗教プラン
                        shohinBango == 'SBG-0001012' ||    // よりそうのお葬式　一般葬　仏式プラン
                        shohinBango == 'SBG-0001013';    // よりそうのお葬式　一般葬　お花増量プラン

        return flag;
    }

    // 安くて豪華なお葬式
    private Boolean isYasugou(String shohinBango){
        Boolean flag =  shohinBango == 'SBG-0000100' ||  // 安くて豪華なお葬式　火葬式　16.8万円プラン
                        shohinBango == 'SBG-0000101' ||  // 安くて豪華なお葬式　火葬式　19.8万円プラン
                        shohinBango == 'SBG-0000102' ||  // 安くて豪華なお葬式　火葬式　21.8万円プラン
                        shohinBango == 'SBG-0000103' ||  // 安くて豪華なお葬式　一日葬　32.8万円プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000104' ||  // 安くて豪華なお葬式　一日葬　34.8万円プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000105' ||  // 安くて豪華なお葬式　一日葬　36.8万円プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000106' ||  // 安くて豪華なお葬式　家族葬　48.8万円プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000107' ||  // 安くて豪華なお葬式　家族葬　50.8万円プラン[2019/9/30迄]
                        shohinBango == 'SBG-0000108' ||  // 安くて豪華なお葬式　家族葬　52.8万円プラン[2019/9/30迄]
                        shohinBango == 'SBG-0001103' ||  // 安くて豪華なお葬式　一日葬　32.8万円プラン
                        shohinBango == 'SBG-0001104' ||  // 安くて豪華なお葬式　一日葬　34.8万円プラン
                        shohinBango == 'SBG-0001105' ||  // 安くて豪華なお葬式　一日葬　36.8万円プラン
                        shohinBango == 'SBG-0001106' ||  // 安くて豪華なお葬式　家族葬　48.8万円プラン
                        shohinBango == 'SBG-0001107' ||  // 安くて豪華なお葬式　家族葬　50.8万円プラン
                        shohinBango == 'SBG-0001108';    // 安くて豪華なお葬式　家族葬　52.8万円プラン
        return flag;
    }


    /////////////////////////////商品割引取得
    public List<String> getWaribikiProduct2Bango(Jizenwari__c jizenwari, Opportunity opp, String shohinBango){

        
        String theWaribikiType = 'none';
        if(isTyokuso(shohinBango)){
            //よりそうメンバ割 / 無料メンバ    Yes 4
            //よりそうメンバ割 / Web事前準備無料メンバ Yes 3
            //よりそうメンバ割 / 事前割メンバ   Yes 2
            //よりそうメンバ割 / お葬式予約メンバ Yes 1
            //資料請求割 / 旧資料請求割  Yes 4

            if(isYorisoOsoshikiYoyakuMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER;
            } else if(isYorisoJizenwariMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_JIZENWARIMEMBER;
            } else if(isYorisoItteiJokenMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_ITTEIJOKEN;
            } else if(isYorisoMuryoMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_MURYOU;
            } else if(isOldSiryouseikyu(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_OLDSIRYOUSEIKYU;
            }

        } else if(isSimpleNoTyokusoIgai(shohinBango)){
            if(isYorisoOsoshikiYoyakuMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_OSOSHIKIYOYAKUMEMBER;
            } else if(isPostalClubKaiin(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_POSTAL;
            } else if(isOldJizenwari(jizenwari, opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_OLD_JIZENWARI;
            } else if(isYorisoJizenwariMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_JIZENWARIMEMBER;
            } else if(isYorisoItteiJokenMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_ITTEIJOKEN;
            } else if(isYorisoMuryoMember(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_MURYOU;
            } else if(isOldSiryouseikyu(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_OLDSIRYOUSEIKYU;
            }

        } else if(isYasugou(shohinBango)){
            if(isSimpleYasugoSiryouseikyu(opp)){
                theWaribikiType = WaribikiData.WARIBKI_TYPE_SIMPLEYASUGOSIRYOUSEIKYU;
            }
        }

        List<String> bangoList = f_waribikiData.getWaribikiShohinBango(shohinBango, theWaribikiType);

        return bangoList;
    }


}