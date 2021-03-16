public class OboStApi_Offer {
    public class OboStApiOfferException extends Exception {}

	public class Offer_contract {
		public String contract_id;
		public Offer_contract setContractId(String contract_id) {
			this.contract_id = contract_id;
			return this;
		}
	}

	public class Place {
		public String name;
		public String postal_code;
		public String state;
		public String city;
		public String street;
		public Place setName(String name) { this.name = name; return this; }
		public Place setPostalCode(String postal_code) { this.postal_code = postal_code; return this; }
		public Place setState(String state) { this.state = state; return this; }
		public Place setCity(String city) { this.city = city; return this; }
		public Place setStreet(String street) { this.street = street; return this; }
	}

	public class Hoyo_detail {
		public String kaimyo;
		public String service_content;
		public Place place;
		public List<Map<String, String>> candidate_datetimes = new List<Map<String, String>>();
		public Place additional_place;
		public Hoyo_detail setKaimyo(String kaimyo) { this.kaimyo = kaimyo; return this; }
		public Hoyo_detail setServiceContent(String service_content) { this.service_content = service_content; return this; }
		public Hoyo_detail setPlace(Place place) { this.place = place; return this; }
		public Hoyo_detail setAdditionalPlace(Place additional_place) { this.additional_place = additional_place; return this; }

		public Hoyo_detail addCandidateDatetime(Datetime candidate_datetime){
			if(candidate_datetime == null) return this;
			String date1 = candidate_datetime.format('yyyy-MM-dd');
			String time1 = candidate_datetime.format('HH:mm:ss');
			if(candidate_datetime.hour() == 0 && candidate_datetime.minute() == 0) time1 = null;
			for(Map<String, String> exist_candidate_datetime : this.candidate_datetimes) {
				if(	   exist_candidate_datetime.get('date') == date1
					&& exist_candidate_datetime.get('time') == time1
					){
					return this;
				}
			}
			candidate_datetimes.add(new Map<String, String>{
				'date' => date1,
				'time' => time1
			});
			return this;
		}

	}

	public class Sogi_detail {
		public String kaimyo;
		public String service_content;
		public Place place;
		public String makurakyo_datetime;
		public String tsuya_datetime;
		public String kokubetsu_datetime;
		public String kaso_datetime;
		public String shonanoka;
		public String kasoba_name;
		public Sogi_detail setKaimyo(String kaimyo) { this.kaimyo = kaimyo; return this; }
		public Sogi_detail setServiceContent(String service_content) { this.service_content = service_content; return this; }
		public Sogi_detail setPlace(Place place) { this.place = place; return this; }
		public Sogi_detail setMakurakyoDatetime(DateTime makurakyo_datetime) { if(makurakyo_datetime!=null) this.makurakyo_datetime = makurakyo_datetime.format('yyyy-MM-dd HH:mm:ss'); return this; }
		public Sogi_detail setTsuyaDatetime(DateTime tsuya_datetime) { if(tsuya_datetime!=null) this.tsuya_datetime = tsuya_datetime.format('yyyy-MM-dd HH:mm:ss'); return this; }
		public Sogi_detail setKokubetsuDatetime(DateTime kokubetsu_datetime) { if(kokubetsu_datetime!=null) this.kokubetsu_datetime = kokubetsu_datetime.format('yyyy-MM-dd HH:mm:ss'); return this; }
		public Sogi_detail setKasoDatetime(DateTime kaso_datetime) { if(kaso_datetime!=null) this.kaso_datetime = kaso_datetime.format('yyyy-MM-dd HH:mm:ss'); return this; }
		public Sogi_detail setShonanoka(String shonanoka) { this.shonanoka = shonanoka; return this; }
		public Sogi_detail setKasobaName(String kasoba_name) { this.kasoba_name = kasoba_name; return this; }
	}

	public class Kaimyo_detail {
		public String kaimyo;
		public Kaimyo_detail setKaimyo(String kaimyo) { this.kaimyo = kaimyo; return this; }
	}

    public class Subscription {
        public Integer provider_revenue; // 葬儀社へのお戻し金額
        public Integer contract_revenue; // 僧侶のお納め金額
        public Subscription setProviderRevenue(Integer provider_revenue) { this.provider_revenue = provider_revenue; return this; }
        public Subscription setContractRevenue(Integer contract_revenue) { this.contract_revenue = contract_revenue; return this; }
    }

	public class ReqBody {
		public String negotiation_id;
		public String service_type;
		public Boolean is_repeat;
		public Boolean is_urgent;
		public Integer send_limit;
		public Integer hours_allowed;
		public String expiry_datetime;
		public List<Offer_contract> offer_contracts = new List<Offer_contract>();
		public String kibo_shuha;
		public Boolean is_bodaiji;
		public String plan;
		public Integer service_fee;
		public Integer commission;
        public Subscription subscription;
		public String caption;
		public Hoyo_detail hoyo_detail;
		public Sogi_detail sogi_detail;
		public Kaimyo_detail kaimyo_detail;
		public String toJson(){ return JSON.serialize( this ); }
		public ReqBody setExpiryDatetime(DateTime expiry_datetime) { this.expiry_datetime = expiry_datetime.format('yyyy-MM-dd HH:mm:ss'); return this; }
	}

    /////////////////////////////////////////////////////////
    //HttpRequest戻り値
    public class Result {
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
        public Integer offer_id;
    }

    public class ResBody {
    	public Integer id;
    }

    /////////////////////////////////////////////////////////
    // HttpRequest
    public Result sendRequest(ReqBody pReqBody) {
        OboStConfig theConfig = new OboStConfig();

        Result theResult = new Result();
        try {
            theResult.endPoint = theConfig.getBaseEndPoint() + '/api/offers';
            theResult.reqBodyRaw = pReqBody.toJson();

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setBody( theResult.reqBodyRaw );

			request.setTimeout(30000);
            new OboStApi_Auth().setAuthHeader(request);

            HttpResponse response = new http().send(request);

            theResult.statusCode = response.getStatusCode();
            theResult.resBodyRaw = response.getBody();
            theResult.isSuccess = theResult.statusCode == 200;
            if(theResult.isSuccess){
	            ResBody result_data = (ResBody)JSON.deserialize(theResult.resBodyRaw, ResBody.class);
	            theResult.offer_id = result_data.id;
            }

            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Info, '20190528-1600-01', 'OboStApi_Offer.sendRequest')
                    .putAttr('theResult.endPoint', theResult.endPoint)
                    .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                    .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                    .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                    .putAttr('theResult.descr',theResult.descr)
            );
        } catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.debug(theResult.descr);

            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20190528-1600-02', 'OboStApi_Offer.sendRequest')
                    .putAttr('theResult.endPoint', theResult.endPoint)
                    .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                    .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                    .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                    .putAttr('theResult.descr',theResult.descr)
            );
            throw new OboStApiOfferException(theResult.descr);
        }

        return theResult;
    }
}