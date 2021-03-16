@RestResource(urlMapping='/api/v1/partnerseikyusho/detail/*')
global class Api_V1_PtWeb_PartnerSeikyushoDetail {

	public class ReqBody{
        public String seikyu_bango = '';
        public ReqBody readRequest(RestRequest pRestRequest){
        	System.debug('pRestRequest:' + pRestRequest);
            this.seikyu_bango = pRestRequest.params.get('seikyu_bango');
            return this;
        }
    }

    public class ResBody{
        public String seikyu_bango = '';
        public String seikyu_date = '';
        public String torihikisaki_bango = '';
        public String torihikisaki_mei = '';
        public String torihikisaki_shogo = '';
        public Decimal seikyu_kingaku = 0;
        public String seikyu_status = '';
        public String nyukin_status = '';
        public String shodan_bango = '';
        public String shiharai_kijitsu = '';
        public String kinyukikan_code = '';
        public String kinyukikan_name = '';
        public String shiten_code = '';
        public String shiten_name = '';
        public String koza_shubetsu = '';
        public String koza_meigi = '';
        public String koza_meigi_kana = '';
        public String koza_bango = '';

        public List<SeikyuDetail> seikyu_detail = new List<SeikyuDetail>();
    }

    public class SeikyuDetail{
    	public Decimal no = 0;
    	public String shodan_bango = '';
    	public String okyakusama_mei = '';
    	public String plan_naiyo = '';
    	public Decimal sogaku = 0;
    	public Decimal plan_tesuryo = 0;
    	public Decimal tokuyakuten_tesuryo = 0;
    	public Decimal sonota_tesuryo = 0;
    	public Decimal sashihikigaku = 0;
    	public Date seko_date = null;
    	public List<Options> options = new List<Options>();
    }

    public class Options{
    	public Decimal unit_price = 0;
    	public Decimal quantity = 0;
    	public String name = '';
    	public Decimal amount = 0;
    	public String tesuryoritsu = '';
    	public Decimal tesuryo = 0;
    }

    @HttpGet
    global static void doGet(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');
        System.debug('theReq:' + theReq);
        ReqBody theReqBody = new ReqBody().readRequest(theReq);
        System.debug('theReqBody.seikyu_bango:' + theReqBody.seikyu_bango);
        if( String.isBlank(theReqBody.seikyu_bango) ){
            theRes.statusCode = 400;
            return;
        }

        try{
            ResBody theResBody = new Processor().run(theReqBody);
            theRes.statusCode = 200;
            theRes.responseBody = Blob.valueOf( JSON.serialize( theResBody ) );
            System.debug('theRes.responseBody:' + theRes.responseBody);
        }catch(Exception e){
            theRes.statusCode = 500;
            return;
        }
    }

    private class Processor{

        public ResBody run(ReqBody pReqBody){

            PartnerSeikyuSogisha__c thePartnerSeikyuSogisha = 
                [
                    select Id, 
	    				Name, 
	                    KokyakuId__c, 
                        TorihikisakiBango__c, 
                        SogishaName__c, 
                        SeikyusakiName__c, 
                        SeikyuStatus__c, 
                        SeikyuKingaku__c, 
                        Seikyubi__c, 
                        NyukinShimekiribi__c, 
                        KinyukikanCodeTosha__c, 
                        KinyukikanMeiTosha__c, 
                        KozaShubetsuTosha__c, 
                        KozaBangoTosha__c, 
                        KozaMeigiKanaTosha__c, 
                        KozaMeigiTosha__c, 
                        ShitenCodeTosha__c, 
                        ShitenMeiTosha__c, 
                        (
                        	select Id,
                        			Name,
                        			No__c,
                        			EmbalmingPrice__c,
									EmbalmingPriceFee__c,
									EmbalmingPriceFeeRate__c,
									EmbalmingPriceFeeRateText__c,
									OptionTesuryo__c,
									OkyakusamaMei__c,
									OwakareBana__c,
									OwakareBanaFee__c,
									OwakareBanaFeeRate__c,
									OwakareBanaFeeRateText__c,
									PartnerSeikyuSogishaRef__c,
									PlanTesuryo__c,
									TokuyakutenTesuryo__c,
									PlanNaiyo__c,
									MakeDress__c,
									MakeDressFee__c,
									MakeDressFeeRate__c,
									MakeDressFeeRateText__c,
									LastMake__c,
									LastMakeFee__c,
									LastMakeFeeRate__c,
									LastMakeFeeRateText__c,
									IeiShashin__c,
									IeiShashinFee__c,
									IeiShashinFeeRate__c,
									IeiShashinFeeRateText__c,
									GaisoSetsubiTsuika__c,
									GaisoSetsubiTsuikaFee__c,
									GaisoSetsubiTsuikaFeeRate__c,
									GaisoSetsubiTsuikaFeeRateText__c,
									Hitsugi__c,
									HitsugiFee__c,
									HitsugiFeeRate__c,
									HitsugiFeeRateText__c,
									KanjoHanataba__c,
									KanjoHanatabaFee__c,
									KanjoHanatabaFeeRate__c,
									KanjoHanatabaFeeRateText__c,
									Kyoka__c,
									KyokaFee__c,
									KyokaFeeRate__c,
									KyokaFeeRateText__c,
									Kumotsu__c,
									KokyakuId__c,
									GokeiKingaku__c,
									KotsutsuboRankUp__c,
									KotsutsuboRankUpFee__c,
									KotsutsuboRankUpFeeRate__c,
									KotsutsuboRankUpFeeRateText__c,
									Sashihikigaku__c,
									SaidanPrice__c,
									SaidanPriceFee__c,
									SaidanPriceFeeRate__c,
									SaidanPriceFeeRateText__c,
									Sekobi__c,
									JimuTesuryo__c,
									OpportunityRef__c,
									ShomenKanban__c,
									ShomenKanbanFee__c,
									ShomenKanbanFeeRate__c,
									ShomenKanbanFeeRateText__c,
									Yukan__c,
									YukanFee__c,
									YukanFeeRate__c,
									YukanFeeRateText__c,
									Henreihin__c,
									HenreihinFee__c,
									HenreihinFeeRate__c,
									HenreihinFeeRateText__c,
									MakuraBana__c,
									MakuraBanaFee__c,
									MakuraBanaFeeRate__c,
									MakuraBanaFeeRateText__c,
									Ryori__c,
									RyoriFee__c,
									RyoriFeeRate__c,
									RyoriFeeRateText__c, 
									Yorisofutankingaku__c,
									kishafutankingaku__c,
									OpportunityRef__r.SeikyuZandakaPartnerExp__c 
							from PartnerSeikyuSogishaPartnerSeikyuMeisais__r
							order by No__c asc
                        )
                    from PartnerSeikyuSogisha__c 
                    where Name = :pReqBody.seikyu_bango
                    order by Seikyubi__c desc 
                    limit 100
                ];
	
			
            ResBody theResBody = new ResBody();
	        theResBody.seikyu_bango = changeNullString(thePartnerSeikyuSogisha.Name);
	        theResBody.seikyu_date = thePartnerSeikyuSogisha.Seikyubi__c == null ? '' : String.valueOf(thePartnerSeikyuSogisha.Seikyubi__c);
	        theResBody.torihikisaki_bango = changeNullString(thePartnerSeikyuSogisha.TorihikisakiBango__c);
	        theResBody.torihikisaki_mei = changeNullString(thePartnerSeikyuSogisha.SogishaName__c);
	        theResBody.torihikisaki_shogo = changeNullString(thePartnerSeikyuSogisha.SeikyusakiName__c);
	        theResBody.seikyu_kingaku = thePartnerSeikyuSogisha.SeikyuKingaku__c;
	        theResBody.seikyu_status = getSeikyuStatus(thePartnerSeikyuSogisha.SeikyuStatus__c);
	        theResBody.shodan_bango = changeNullString(thePartnerSeikyuSogisha.KokyakuId__c);
	        theResBody.shiharai_kijitsu = thePartnerSeikyuSogisha.NyukinShimekiribi__c == null ? '' : String.valueOf(thePartnerSeikyuSogisha.NyukinShimekiribi__c);
	        theResBody.kinyukikan_code = changeNullString(thePartnerSeikyuSogisha.KinyukikanCodeTosha__c);
	        theResBody.kinyukikan_name = changeNullString(thePartnerSeikyuSogisha.KinyukikanMeiTosha__c);
	        theResBody.shiten_code = changeNullString(thePartnerSeikyuSogisha.ShitenCodeTosha__c);
	        theResBody.shiten_name = changeNullString(thePartnerSeikyuSogisha.ShitenMeiTosha__c);
	        theResBody.koza_shubetsu = changeNullString(thePartnerSeikyuSogisha.KozaShubetsuTosha__c);
	        theResBody.koza_meigi = changeNullString(thePartnerSeikyuSogisha.KozaMeigiTosha__c);
	        theResBody.koza_meigi_kana = changeNullString(thePartnerSeikyuSogisha.KozaMeigiKanaTosha__c);
	        theResBody.koza_bango = changeNullString(thePartnerSeikyuSogisha.KozaBangoTosha__c);

	        Decimal seikyuZandakaTotal = 0;
	        for(PartnerSeikyuMeisaiSogisha__c thePartnerSeikyuMeisai : thePartnerSeikyuSogisha.PartnerSeikyuSogishaPartnerSeikyuMeisais__r){
	        	seikyuZandakaTotal += thePartnerSeikyuMeisai.OpportunityRef__r.SeikyuZandakaPartnerExp__c;

	        	SeikyuDetail sd = new SeikyuDetail();
	        	sd.no = thePartnerSeikyuMeisai.No__c;
	        	sd.shodan_bango = thePartnerSeikyuMeisai.KokyakuId__c;
	        	sd.okyakusama_mei = thePartnerSeikyuMeisai.OkyakusamaMei__c;
	        	sd.plan_naiyo = thePartnerSeikyuMeisai.PlanNaiyo__c;
	        	sd.sogaku = thePartnerSeikyuMeisai.GokeiKingaku__c;
	        	sd.plan_tesuryo = thePartnerSeikyuMeisai.PlanTesuryo__c;
	        	sd.tokuyakuten_tesuryo = thePartnerSeikyuMeisai.TokuyakutenTesuryo__c;
	        	sd.sonota_tesuryo = thePartnerSeikyuMeisai.OptionTesuryo__c;
	        	sd.sashihikigaku = thePartnerSeikyuMeisai.Sashihikigaku__c;
	        	sd.seko_date = thePartnerSeikyuMeisai.Sekobi__c;

	        	Options optHenreihin = new Options();
	        	optHenreihin.unit_price = thePartnerSeikyuMeisai.Henreihin__c;
	        	optHenreihin.quantity = 1;
	        	optHenreihin.name = '返礼品';
	        	optHenreihin.amount = thePartnerSeikyuMeisai.HenreihinFee__c;
	        	optHenreihin.tesuryoritsu = thePartnerSeikyuMeisai.HenreihinFeeRateText__c;
	        	optHenreihin.tesuryo = thePartnerSeikyuMeisai.HenreihinFee__c;
	        	sd.options.add(optHenreihin);

	        	Options optRyori = new Options();
	        	optRyori.unit_price = thePartnerSeikyuMeisai.Ryori__c;
	        	optRyori.quantity = 1;
	        	optRyori.name = '料理';
	        	optRyori.amount = thePartnerSeikyuMeisai.RyoriFee__c;
	        	optRyori.tesuryoritsu = thePartnerSeikyuMeisai.RyoriFeeRateText__c;
	        	optRyori.tesuryo = thePartnerSeikyuMeisai.RyoriFee__c;
	        	sd.options.add(optRyori);

	        	Options optLastMake = new Options();
	        	optLastMake.unit_price = thePartnerSeikyuMeisai.LastMake__c;
	        	optLastMake.quantity = 1;
	        	optLastMake.name = 'ラストメイク';
	        	optLastMake.amount = thePartnerSeikyuMeisai.LastMakeFee__c;
	        	optLastMake.tesuryoritsu = thePartnerSeikyuMeisai.LastMakeFeeRateText__c;
	        	optLastMake.tesuryo = thePartnerSeikyuMeisai.LastMakeFee__c;
	        	sd.options.add(optLastMake);
	        	
	        	Options optMakeDress = new Options();
	        	optMakeDress.unit_price = thePartnerSeikyuMeisai.MakeDress__c;
	        	optMakeDress.quantity = 1;
	        	optMakeDress.name = 'メイク＆ドレス(古式湯灌)';
	        	optMakeDress.amount = thePartnerSeikyuMeisai.MakeDressFee__c;
	        	optMakeDress.tesuryoritsu = thePartnerSeikyuMeisai.MakeDressFeeRateText__c;
	        	optMakeDress.tesuryo = thePartnerSeikyuMeisai.MakeDressFee__c;
	        	sd.options.add(optMakeDress);
	        	
	        	Options optYukan = new Options();
	        	optYukan.unit_price = thePartnerSeikyuMeisai.Yukan__c;
	        	optYukan.quantity = 1;
	        	optYukan.name = '湯かん';
	        	optYukan.amount = thePartnerSeikyuMeisai.YukanFee__c;
	        	optYukan.tesuryoritsu = thePartnerSeikyuMeisai.YukanFeeRateText__c;
	        	optYukan.tesuryo = thePartnerSeikyuMeisai.YukanFee__c;
	        	sd.options.add(optYukan);
	        	
	        	Options optMakuraBana = new Options();
	        	optMakuraBana.unit_price = thePartnerSeikyuMeisai.MakuraBana__c;
	        	optMakuraBana.quantity = 1;
	        	optMakuraBana.name = '枕花';
	        	optMakuraBana.amount = thePartnerSeikyuMeisai.MakuraBanaFee__c;
	        	optMakuraBana.tesuryoritsu = thePartnerSeikyuMeisai.MakuraBanaFeeRateText__c;
	        	optMakuraBana.tesuryo = thePartnerSeikyuMeisai.MakuraBanaFee__c;
	        	sd.options.add(optMakuraBana);
	        	
	        	Options optKanjoHanataba = new Options();
	        	optKanjoHanataba.unit_price = thePartnerSeikyuMeisai.KanjoHanataba__c;
	        	optKanjoHanataba.quantity = 1;
	        	optKanjoHanataba.name = '棺上花束';
	        	optKanjoHanataba.amount = thePartnerSeikyuMeisai.KanjoHanatabaFee__c;
	        	optKanjoHanataba.tesuryoritsu = thePartnerSeikyuMeisai.KanjoHanatabaFeeRateText__c;
	        	optKanjoHanataba.tesuryo = thePartnerSeikyuMeisai.KanjoHanatabaFee__c;
	        	sd.options.add(optKanjoHanataba);
	        	
	        	Options optOwakareBana = new Options();
	        	optOwakareBana.unit_price = thePartnerSeikyuMeisai.OwakareBana__c;
	        	optOwakareBana.quantity = 1;
	        	optOwakareBana.name = 'お別れ花';
	        	optOwakareBana.amount = thePartnerSeikyuMeisai.OwakareBanaFee__c;
	        	optOwakareBana.tesuryoritsu = thePartnerSeikyuMeisai.OwakareBanaFeeRateText__c;
	        	optOwakareBana.tesuryo = thePartnerSeikyuMeisai.OwakareBanaFee__c;
	        	sd.options.add(optOwakareBana);
	        	
	        	Options optKyoka = new Options();
	        	optKyoka.unit_price = thePartnerSeikyuMeisai.Kyoka__c;
	        	optKyoka.quantity = 1;
	        	optKyoka.name = '供花';
	        	optKyoka.amount = thePartnerSeikyuMeisai.KyokaFee__c;
	        	optKyoka.tesuryoritsu = thePartnerSeikyuMeisai.KyokaFeeRateText__c;
	        	optKyoka.tesuryo = thePartnerSeikyuMeisai.KyokaFee__c;
	        	sd.options.add(optKyoka);
	        	
	        	Options optIeiShashin = new Options();
	        	optIeiShashin.unit_price = thePartnerSeikyuMeisai.IeiShashin__c;
	        	optIeiShashin.quantity = 1;
	        	optIeiShashin.name = '遺影写真';
	        	optIeiShashin.amount = thePartnerSeikyuMeisai.IeiShashinFee__c;
	        	optIeiShashin.tesuryoritsu = thePartnerSeikyuMeisai.IeiShashinFeeRateText__c;
	        	optIeiShashin.tesuryo = thePartnerSeikyuMeisai.IeiShashinFee__c;
	        	sd.options.add(optIeiShashin);
	        	
	        	Options optShomenKanban = new Options();
	        	optShomenKanban.unit_price = thePartnerSeikyuMeisai.ShomenKanban__c;
	        	optShomenKanban.quantity = 1;
	        	optShomenKanban.name = '看板';
	        	optShomenKanban.amount = thePartnerSeikyuMeisai.ShomenKanbanFee__c;
	        	optShomenKanban.tesuryoritsu = thePartnerSeikyuMeisai.ShomenKanbanFeeRateText__c;
	        	optShomenKanban.tesuryo = thePartnerSeikyuMeisai.ShomenKanbanFee__c;
	        	sd.options.add(optShomenKanban);
	        	
 	        	Options optGaisoSetsubiTsuika = new Options();
	        	optGaisoSetsubiTsuika.unit_price = thePartnerSeikyuMeisai.GaisoSetsubiTsuika__c;
	        	optGaisoSetsubiTsuika.quantity = 1;
	        	optGaisoSetsubiTsuika.name = '外装設備追加';
	        	optGaisoSetsubiTsuika.amount = thePartnerSeikyuMeisai.GaisoSetsubiTsuikaFee__c;
	        	optGaisoSetsubiTsuika.tesuryoritsu = thePartnerSeikyuMeisai.GaisoSetsubiTsuikaFeeRateText__c;
	        	optGaisoSetsubiTsuika.tesuryo = thePartnerSeikyuMeisai.GaisoSetsubiTsuikaFee__c;
	        	sd.options.add(optGaisoSetsubiTsuika);
	        	
	        	Options optKotsutsuboRankUp = new Options();
	        	optKotsutsuboRankUp.unit_price = thePartnerSeikyuMeisai.KotsutsuboRankUp__c;
	        	optKotsutsuboRankUp.quantity = 1;
	        	optKotsutsuboRankUp.name = '骨壺ランクアップ';
	        	optKotsutsuboRankUp.amount = thePartnerSeikyuMeisai.KotsutsuboRankUpFee__c;
	        	optKotsutsuboRankUp.tesuryoritsu = thePartnerSeikyuMeisai.KotsutsuboRankUpFeeRateText__c;
	        	optKotsutsuboRankUp.tesuryo = thePartnerSeikyuMeisai.KotsutsuboRankUpFee__c;
	        	sd.options.add(optKotsutsuboRankUp);
	        	
	        	Options optHitsugi = new Options();
	        	optHitsugi.unit_price = thePartnerSeikyuMeisai.Hitsugi__c;
	        	optHitsugi.quantity = 1;
	        	optHitsugi.name = '棺';
	        	optHitsugi.amount = thePartnerSeikyuMeisai.HitsugiFee__c;
	        	optHitsugi.tesuryoritsu = thePartnerSeikyuMeisai.HitsugiFeeRateText__c;
	        	optHitsugi.tesuryo = thePartnerSeikyuMeisai.HitsugiFee__c;
	        	sd.options.add(optHitsugi);
	        	
	        	Options optJimuTesuryo = new Options();
	        	optJimuTesuryo.unit_price = thePartnerSeikyuMeisai.JimuTesuryo__c;
	        	optJimuTesuryo.quantity = 1;
	        	optJimuTesuryo.name = '事務手数料';
	        	optJimuTesuryo.amount = thePartnerSeikyuMeisai.JimuTesuryo__c;
	        	optJimuTesuryo.tesuryoritsu = '-';
	        	optJimuTesuryo.tesuryo = thePartnerSeikyuMeisai.JimuTesuryo__c;
	        	sd.options.add(optJimuTesuryo);

	        	Options optEmbalming = new Options();
	        	optEmbalming.unit_price = thePartnerSeikyuMeisai.EmbalmingPrice__c;
	        	optEmbalming.quantity = 1;
	        	optEmbalming.name = 'エンバーミング';
	        	optEmbalming.amount = thePartnerSeikyuMeisai.EmbalmingPriceFee__c;
	        	optEmbalming.tesuryoritsu = thePartnerSeikyuMeisai.EmbalmingPriceFeeRateText__c;
	        	optEmbalming.tesuryo = thePartnerSeikyuMeisai.EmbalmingPriceFee__c;
	        	sd.options.add(optEmbalming);

	        	Options optSaidan = new Options();
	        	optSaidan.unit_price = thePartnerSeikyuMeisai.SaidanPrice__c;
	        	optSaidan.quantity = 1;
	        	optSaidan.name = '祭壇';
	        	optSaidan.amount = thePartnerSeikyuMeisai.SaidanPriceFee__c;
	        	optSaidan.tesuryoritsu = thePartnerSeikyuMeisai.SaidanPriceFeeRateText__c;
	        	optSaidan.tesuryo = thePartnerSeikyuMeisai.SaidanPriceFee__c;
				sd.options.add(optSaidan);
				
				Options optYorisofutan = new Options();
	        	optYorisofutan.unit_price = thePartnerSeikyuMeisai.Yorisofutankingaku__c;
	        	optYorisofutan.quantity = 1;
	        	optYorisofutan.name = 'よりそう負担';
	        	optYorisofutan.amount = thePartnerSeikyuMeisai.Yorisofutankingaku__c;
				optYorisofutan.tesuryoritsu = '-';
				if(thePartnerSeikyuMeisai.Yorisofutankingaku__c == null){
					optYorisofutan.unit_price = 0;
					optYorisofutan.amount = 0;
					optYorisofutan.tesuryo = 0;
				}else{
					optYorisofutan.unit_price = thePartnerSeikyuMeisai.Yorisofutankingaku__c;
					optYorisofutan.amount = thePartnerSeikyuMeisai.Yorisofutankingaku__c;
					optYorisofutan.tesuryo = thePartnerSeikyuMeisai.Yorisofutankingaku__c;
				}
	        	
				sd.options.add(optYorisofutan);
				
				Options optKishafutan = new Options();
	        	
	        	optKishafutan.quantity = 1;
				optKishafutan.name = '貴社負担';
	        	
				optKishafutan.tesuryoritsu = '-';
				if(thePartnerSeikyuMeisai.kishafutankingaku__c == null){
					optKishafutan.tesuryo = 0;
					optKishafutan.unit_price = 0;
					optKishafutan.amount = 0;
				}else{
					optKishafutan.unit_price = thePartnerSeikyuMeisai.kishafutankingaku__c;
					optKishafutan.tesuryo = thePartnerSeikyuMeisai.kishafutankingaku__c;
					optKishafutan.amount = thePartnerSeikyuMeisai.kishafutankingaku__c;
				}
	        	sd.options.add(optKishafutan);
	        	theResBody.seikyu_detail.add(sd);
	        }

	        theResBody.nyukin_status = getNyukinStatus(seikyuZandakaTotal);

            return theResBody;
        }

	    private String getSeikyuStatus(String seikyuStatsu){
	    	if(seikyuStatsu == '要再請求'){
	    		seikyuStatsu = '請求取消';
	    	}

	    	return seikyuStatsu;
	    }

	    private String getNyukinStatus(Decimal seikyuZandakaPartner){
	    	String nyukinStatsu = '';
	    	if(seikyuZandakaPartner == 0){
	    		nyukinStatsu = '入金済';
	    	}
	    	else{
	    		nyukinStatsu = '未入金';
	    	}

	    	return nyukinStatsu;
	    }

	    private String changeNullString(String str){
	    	if(str == null) return '';
	    	return str;
	    }
    }
}