@RestResource(urlMapping='/api/v1/sogi_jizen_ancate/*')
global class Api_V1_SgJzAn{

	@TestVisible
	public static Api_V1_SgJzAn.IProcessor  mSogiJizenAncate = new Api_V1_SgJzAn.Processor();

	@HttpPost
	global static void doPost(){

		RestResponse res = RestContext.response;
		if (res == null) {
			res = new RestResponse();
			RestContext.response = res;
		}

		String theBody = RestContext.request.requestBody.toString();

		Api_V1_SgJzAn.Data theData = new Api_V1_SgJzAn.Data();

		try {

			theData = ( Api_V1_SgJzAn.Data )JSON.deserialize( theBody , Api_V1_SgJzAn.Data.class );
			mSogiJizenAncate.save( theData );
			res.responseBody = Blob.valueOf(JSON.serialize( theData ));
			res.statusCode = 200;

		} catch(Exception ex) {

			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20210203-1600-00', 'Api_V1_SgJzAn.doPost')
					.putAttr('ex.getTypeName()', ex.getTypeName() )
					.putAttr('ex.getMessage()', ex.getMessage() )
					.putAttr('ex.getLineNumber()', '' + ex.getLineNumber() )
					.putAttr('ex.getStackTraceString', ex.getStackTraceString() )
					.putAttr('requestBody', theBody )
			);

			String err = '[エラーメッセージ]\r\n' + ex.getMessage() + '\r\n' + ex.getStackTraceString();
			res.responseBody = Blob.valueOf(err);
			res.statusCode = 500;

		}

	}

	public interface IProcessor {
		void save( Data theData );
	}

	public class Processor implements IProcessor{
		public void save( Data theData ){
			SogiJizenAncate__c theSogiJizenAncate = new SogiJizenAncate__c();
			theSogiJizenAncate.Status__c                                   = '未紐付け';
			theSogiJizenAncate.Torokubi__c                                 = Date.today();
			theSogiJizenAncate.GaClientId__c                               = theData.gaclient_id;
			theSogiJizenAncate.uniq_id__c                                  = theData.mail_syori_id;
			theSogiJizenAncate.ToiawaseDate__c                             = Com_Utility.toDateTime(theData.toiawase_date);
			theSogiJizenAncate.SogiWebShiryoSeikyuUniqueKey__c             = theData.sogi_webshiryoseikyu_uniquekey;
			theSogiJizenAncate.Lastname__c                                 = theData.customer_sei;
			theSogiJizenAncate.Firstname__c                                = theData.customer_mei;
			theSogiJizenAncate.LastNameKana__c                             = theData.customer_sei_kana;
			theSogiJizenAncate.FirstNameKana__c                            = theData.customer_mei_kana;
			theSogiJizenAncate.Seinengappi__c                              = Com_Utility.toDate(theData.customer_birthday);
			if(Com_Utility.isMobile(theData.customer_tel)) {
				theSogiJizenAncate.KeitaiDenwa__c                          = theData.customer_tel;
			}
			else{
				theSogiJizenAncate.TelNo__c                                = theData.customer_tel;
			}
			theSogiJizenAncate.MailAddress__c                              = theData.customer_mail;
			theSogiJizenAncate.PostalCode__c                               = theData.customer_postal_code;
			theSogiJizenAncate.State__c                                    = theData.customer_state;
			theSogiJizenAncate.City__c                                     = theData.customer_city;
			theSogiJizenAncate.Street__c                                   = theData.customer_street;
			theSogiJizenAncate.TaishoushaJokyo__c                          = Api_V1_ItemValueMaster.getTaishoushaJokyo(theData.taisyosya_jokyo);
			theSogiJizenAncate.TaishoshaSei__c                             = theData.taisyosya_sei;
			theSogiJizenAncate.TaishoshaMei__c                             = theData.taisyosya_mei;
			theSogiJizenAncate.TaishoshaSeiFurigana__c                     = theData.taisyosya_sei_kana;
			theSogiJizenAncate.TaishoshaMeiFurigana__c                     = theData.taisyosya_mei_kana;
			theSogiJizenAncate.TaishoshaSeinengappi__c                     = Com_Utility.toDate(theData.taisyosya_birthday);
			if(Com_Utility.isMobile(theData.taisyosya_tel)) {
				theSogiJizenAncate.TaishoshaKeitaiDenwa__c                 = theData.taisyosya_tel;
			}
			else{
				theSogiJizenAncate.TaishoshaTelNo__c                       = theData.taisyosya_tel;
			}
			theSogiJizenAncate.TaishoshaZipCode__c                         = theData.taisyosya_postal_code;
			theSogiJizenAncate.TaishoshaState__c                           = theData.taisyosya_state;
			theSogiJizenAncate.TaishoshaCity__c                            = theData.taisyosya_city;
			theSogiJizenAncate.TaishoshaStreet__c                          = theData.taisyosya_street;

			theSogiJizenAncate.JuminhyoAddressInfo__c                      = theData.juminhyo_address_info;

			if(theData.juminhyo_address_info == 'other'){
				theSogiJizenAncate.TaishoshaJuminhyoState__c               = theData.taisyosya_juminhyo_state;
				theSogiJizenAncate.TaishoshaJuminhyoCity__c                = theData.taisyosya_juminhyo_city;
			}else{
				theSogiJizenAncate.TaishoshaJuminhyoState__c               = theData.customer_state;
				theSogiJizenAncate.TaishoshaJuminhyoCity__c                = theData.customer_city;
			}

			theSogiJizenAncate.Shuha__c                                    = theData.taisyosya_syuha;
			theSogiJizenAncate.SonotanoSyukyoSyuha__c                      = theData.taisyosya_sonotasyuha;
			theSogiJizenAncate.TaishoshaBodaijinoUmu__c                    = Api_V1_ItemValueMaster.getTaisyosyaBodaijiUmu(theData.taisyosya_bodaiji_umu);
			theSogiJizenAncate.ZokugaraSodanshaNitottenoTaishosha__c       = Api_V1_ItemValueMaster.getTaisyosyaFromCustomer(theData.taisyosya_from_customer);
			theSogiJizenAncate.ZokugaraSodanshaNitottenoTaishoshaSonota__c = theData.taisyosya_from_customer_sonota;
			theSogiJizenAncate.OmukaesakiMeisho__c                         = theData.omukae_name;

			theSogiJizenAncate.OmukaeAddressInfo__c                        = theData.omukae_address_info;

			if(theData.omukae_address_info == 'other'){
				theSogiJizenAncate.OmukaesakiZipCode__c                    = theData.omukae_postal_code;
				theSogiJizenAncate.OmukaesakiState__c                      = theData.omukae_state;
				theSogiJizenAncate.OmukaesakiCity__c                       = theData.omukae_city;
				theSogiJizenAncate.OmukaesakiStreet__c                     = theData.omukae_street;
			}else{
				theSogiJizenAncate.OmukaesakiZipCode__c                    = theData.customer_postal_code;
				theSogiJizenAncate.OmukaesakiState__c                      = theData.customer_state;
				theSogiJizenAncate.OmukaesakiCity__c                       = theData.customer_city;
				theSogiJizenAncate.OmukaesakiStreet__c                     = theData.customer_street;
			}

			theSogiJizenAncate.AnchiKubun__c                               = Api_V1_ItemValueMaster.getAnchisakiKubun(theData.anchisaki_kubun);
			theSogiJizenAncate.KiboAreaState__c                            = theData.sogi_yotei_area_state;
			theSogiJizenAncate.KiboAreaCity__c                             = theData.sogi_yotei_area_city;
			theSogiJizenAncate.KiboPlan__c                                 = Api_V1_ItemValueMaster.getSimpleyasugoPlan(theData.simpleyasugo_plan);
			theSogiJizenAncate.ObosanbinOption__c                          = Api_V1_ItemValueMaster.getSimpleyasugoObousanbinPlan(theData.simpleyasugo_obousanbin_plan);
			theSogiJizenAncate.CampaignMoshikomiName__c                    = theData.campaign_id;

			if( !String.isBlank(theData.yoriso_wo_sitta_kikkake) ){ theSogiJizenAncate.YorisoWoSittaKikkake__c = theData.yoriso_wo_sitta_kikkake; }

			insert theSogiJizenAncate;

		}
	}

	public class Data{
		public String gaclient_id { get; set; }
		public String mail_syori_id { get; set; }
		public String toiawase_date { get; set; }
		public String sogi_webshiryoseikyu_uniquekey { get; set; }
		public String customer_sei { get; set; }
		public String customer_mei { get; set; }
		public String customer_sei_kana { get; set; }
		public String customer_mei_kana { get; set; }
		public String customer_birthday { get; set; }
		public String customer_tel { get; set; }
		public String customer_mail { get; set; }
		public String customer_postal_code { get; set; }
		public String customer_state { get; set; }
		public String customer_city { get; set; }
		public String customer_street { get; set; }
		public String taisyosya_jokyo { get; set; }
		public String taisyosya_sei { get; set; }
		public String taisyosya_mei { get; set; }
		public String taisyosya_sei_kana { get; set; }
		public String taisyosya_mei_kana { get; set; }
		public String taisyosya_birthday { get; set; }
		public String taisyosya_tel { get; set; }
		public String taisyosya_postal_code { get; set; }
		public String taisyosya_state { get; set; }
		public String taisyosya_city { get; set; }
		public String taisyosya_street { get; set; }
		public String taisyosya_juminhyo_state { get; set; }
		public String taisyosya_juminhyo_city { get; set; }
		public String taisyosya_syuha { get; set; }
		public String taisyosya_sonotasyuha { get; set; }
		public String taisyosya_bodaiji_umu { get; set; }
		public String taisyosya_from_customer { get; set; }
		public String taisyosya_from_customer_sonota { get; set; }
		public String omukae_name { get; set; }
		public String omukae_postal_code { get; set; }
		public String omukae_state { get; set; }
		public String omukae_city { get; set; }
		public String omukae_street { get; set; }
		public String anchisaki_kubun { get; set; }
		public String sogi_yotei_area_state { get; set; }
		public String sogi_yotei_area_city { get; set; }
		public String simpleyasugo_plan { get; set; }
		public String simpleyasugo_obousanbin_plan { get; set; }
		public String campaign_id { get; set; }
		public String yoriso_wo_sitta_kikkake { get; set; }
		public String juminhyo_address_info { get; set; }
		public String omukae_address_info { get; set; }
	}
}