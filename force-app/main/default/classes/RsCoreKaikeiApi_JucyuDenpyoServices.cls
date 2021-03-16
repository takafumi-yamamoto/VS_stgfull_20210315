public class RsCoreKaikeiApi_JucyuDenpyoServices{
    	private static String DATA_KUBUN_1 = '1:通常商品';
        private static String DATA_KUBUN_2 = '2:割引プラン';
	    private static String DATA_KUBUN_3 = '3:クーポン';
	public class applicationException extends Exception {}
    public class JucyuDenpyoResult{
        public Boolean hasError { get; private set; }
        public String errorMessage { get; private set; }
        public JucyuDenpyo jucyuDenpyo { get; private set; }
    }   
      
    public class Item{
        public String orderDate { get; private set; }
        public String sfItemId { get; private set; }
        public String itemName { get; private set; }
        public String categoryCode { get; private set; }
        public Decimal price { get; private set; }
        public Integer amount { get; private set; }
        public List<userDiscount> userDiscounts  { get; private set; }
        public List<PartnerChargeDiscount> partnerChargeDiscounts { get; private set; }
        public Item(){
        	userDiscounts=new List<userDiscount>();
        	partnerChargeDiscounts=new List<PartnerChargeDiscount>();
        }
    }   
    public class userDiscount{
        public Integer recordType { get; private set; }
        public String discountPlanMasterId { get; private set; }
        public String couponMasterId { get; private set; }
        public Decimal price { get; private set; }
    }
    public class PartnerChargeDiscount{
        public String name { get; private set; }
        public Decimal rebateAmount { get; private set; }
    }
    public class Payment{
        public List<PaymentLine> payments { get; private set; }
        public Deposit deposit { get; private set; }
        public Payment(){
        	payments=new List<PaymentLine>();
        }
    }
    public class PaymentLine{
        public String paymentMasterId { get; private set; }
        public String paymentDate { get; private set; }
        public Decimal payment { get; private set; }
    }
    public class Deposit{
        public String paymentMasterId { get; private set; }
        public String depositSfId { get; private set; }
        public Decimal deposit { get; private set; }
    }     
    public class JucyuDenpyo{
        public String sfId  { get; private set; }
        public String rootSfId { get; private set; }
		public String userId { get; private set; }	
		public String userName{ get; private set; }			
		public String taishoshaName{ get; private set; }			
        public String salesDate { get; private set; }
        public String fixedDate { get; private set; }
        public Boolean isWon { get; private set; }
		public String partnerId { get; private set; }		
        public Decimal subTotal { get; private set; }
        public Decimal totalAmount { get; private set; }
        public List<Item> items { get; private set; }
        public Payment payment  { get; private set; }
        public JucyuDenpyo(){
        	items = new List<Item>();
        	payment=new Payment();
        }
    }

    public class RestResponseParam{
        public Decimal planTesuryo {get;set;}
        public OptionTesuryo optionTesuryo {get;set;}
        public Decimal jimuTesuryo {get;set;}
	}
	public class OptionTesuryo{
		public Decimal total {get; set;}
		public Details details {get; set;}
	}
	public class Details{
		public Decimal yoriso {get; set;} //yoriso-option
		public Decimal sogisha {get; set;} //sogisha-option
	}

    private class OppData{
        public Opportunity opp { get; private set; }
        public List<OpportunityLineItem> oppLineItems { get; private set; }
        public List<OkyakusamaSeikyuMeisai__c> seikyuMeisais { get; private set; }
        public List<PatnerUriage__c> partnerUriages { get; private set; }
        List<OpportunityLineItem> readHontaiUriages(){
        	List<OpportunityLineItem> hontaiUriages=new List<OpportunityLineItem>();
        	for (OpportunityLineItem item:oppLineItems){
        		if ((item.Product2.k_ShohinSyubetsuRef__r.ID__c=='1'||item.Product2.k_ShohinSyubetsuRef__r.ID__c=='2' ) && item.Product2.DataKubun__c==DATA_KUBUN_1){
        			hontaiUriages.add(item);
        		}        		
        	}
        	return hontaiUriages;
        }
        List<OpportunityLineItem> readWaribikis(){
        	List<OpportunityLineItem> waribikis=new List<OpportunityLineItem>();
        	for (OpportunityLineItem item:oppLineItems){
        		if (item.Product2.DataKubun__c==DATA_KUBUN_2){
        			waribikis.add(item);
        		}        		
        	}
        	return waribikis;
		}
        List<OpportunityLineItem> readCoupons(){
        	List<OpportunityLineItem> coupons=new List<OpportunityLineItem>();
        	for (OpportunityLineItem item:oppLineItems){
        		if (item.Product2.DataKubun__c==DATA_KUBUN_3){
        			coupons.add(item);
        		}        		
        	}
        	return coupons;        	
        }		
        List<OpportunityLineItem> readOptionUriages(){
        	List<OpportunityLineItem> optionUriages=new List<OpportunityLineItem>();
        	for (OpportunityLineItem item:oppLineItems){
        		if ((item.Product2.k_ShohinSyubetsuRef__r.ID__c=='3'||item.Product2.k_ShohinSyubetsuRef__r.ID__c=='4') && item.Product2.DataKubun__c==DATA_KUBUN_1){
        			optionUriages.add(item);
        		}        		
        	}
        	return optionUriages;  	
        }
        List<PatnerUriage__c> readPartnerDiscounts(){
        	return partnerUriages;         	
        }
        List<OkyakusamaSeikyuMeisai__c> readPayments(){
        	list<OkyakusamaSeikyuMeisai__c> Payments=new list<OkyakusamaSeikyuMeisai__c>();
        	for(OkyakusamaSeikyuMeisai__c OkyakusamaSeikyuMeisai:seikyuMeisais){
        		Payments.add(OkyakusamaSeikyuMeisai);     		
        	}
        	return Payments;   	
        }
    }
    public class OppDataDao{    	
    	
        public OppData selectOppDataByOppId(Id pOppId){        	
        	//商談
        	Opportunity opp=Dao_Opportunity.SearchById(pOppId);      
        	//お客様明細  	
            list<OkyakusamaSeikyuMeisai__c> OkyakusamaSeikyuMeisaiLst=Dao_OkyakusamaSeikyuMeisai.getOkyakusamaSeikyuMeisaiByOppid(pOppId);
            //提携先向け割引
        	list<PatnerUriage__c> PatnerUriageLst= Dao_PatnerUriage.getPatnerUriageByOppid(pOppId);
        	
        	OppData newOppData=new OppData();
        	newOppData.opp=opp;
        	newOppData.oppLineItems=opp.OpportunityLineItems;
        	newOppData.seikyuMeisais=OkyakusamaSeikyuMeisaiLst;
        	newOppData.partnerUriages=PatnerUriageLst;
        	return newOppData;
        }
    }
    public class JucyuDenpyoBuilder{    	
        private OppData theOppData;
        private JucyuDenpyo theJucyuDenpyo;
        public JucyuDenpyoBuilder(Id iOppId){
        	theOppData=new OppDataDao().selectOppDataByOppId(iOppId);
        	theJucyuDenpyo=new JucyuDenpyo();
        }
        public JucyuDenpyoResult createByOppData(){
        	system.debug('====================JucyuDenpyoBuilder.createByOppData begin====================');

        	Opportunity theOpp = theOppData.opp;
            List<OpportunityLineItem> theHontaiUriages = theOppData.readHontaiUriages();
            List<OpportunityLineItem> theOptionUriages = theOppData.readOptionUriages();
            List<OpportunityLineItem> theWaribikis = theOppData.readWaribikis();
            List<OpportunityLineItem> theCoupons = theOppData.readCoupons();
            List<PatnerUriage__c> thePartnerDiscounts = theOppData.readPartnerDiscounts();
            List<OkyakusamaSeikyuMeisai__c> thePayments = theOppData.readPayments();

			String theShohinBangoPara = '';
        	if(theWaribikis.size() > 1) {

				String privateAccRecTypeId =  RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo');

				if(theOpp.RecordTypeId != privateAccRecTypeId) {
					return this.createWaribikiShouldBeOnlyOneResult('割引プラン商品が2件以上あります。');
				}

				// issues4379 --Start--
				if(theWaribikis.size() > 5) {
					return this.createWaribikiShouldBeOnlyOneResult('割引プラン商品が6件以上あります。');
				}
				// issues4379 --end--

				Set<String> Service_Id = new Set<String>();
				Set<String> ShohinBango = new Set<String>();

				for(OpportunityLineItem sWaribiki :theWaribikis){
					Service_Id.add(sWaribiki.Product2.k_Service_Id_exp__c);
					ShohinBango.add(sWaribiki.Product2.ShohinBango__c);
				}

				if(Service_Id.size() > 1) {
					return this.createWaribikiShouldBeOnlyOneResult('複数のプランに関係する割引プラン商品が選択されています。');
				}

				List<CompoundDiscountPlan__mdt> lCDP = this.slectCompoundDiscountPlan(Service_Id,ShohinBango);

				Set<String> WaribikiPlan_Name = new Set<String>();

				Map<String,CompoundDiscountPlan__mdt> mCDP = new Map<String,CompoundDiscountPlan__mdt>();

				for(CompoundDiscountPlan__mdt sCDP :lCDP){
					WaribikiPlan_Name.add(sCDP.k_WaribikiPlan_Name__c);
					mCDP.put(sCDP.k_WaribikiPlan_Name__c,sCDP);
				}

				if(theWaribikis.size() != WaribikiPlan_Name.size()) {
					return this.createWaribikiShouldBeOnlyOneResult('同じような種類の割引プラン商品が選択されています。');
				}

				if(mCDP.get('プラン割') == null) {
					if(ShohinBango.contains('SBG-0005108') && ShohinBango.contains('SBG-0005187')){
						theShohinBangoPara = 'SBG-0005197';
					}else{
						return this.createWaribikiShouldBeOnlyOneResult('会員の割引プラン商品が選択されていません。');
					}
				}else{

					if((mCDP.get('式後アンケート割') != null) && (mCDP.get('事前アンケート割') != null) && (mCDP.get('仏具なし割引') != null) && (mCDP.get('直葬プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Preparation_Butsugu_TokubetsuWari__c;
						System.debug('式後＋事前＋仏具+直葬プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('事前アンケート割') != null) && (mCDP.get('仏具なし割引') != null) && (mCDP.get('一日プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Preparation_Butsugu_TokubetsuWari__c;
						System.debug('式後＋事前＋仏具+一日プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('事前アンケート割') != null) && (mCDP.get('仏具なし割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Preparation_Butsugu__c;
						System.debug('式後＋事前＋仏具 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('事前アンケート割') != null) && (mCDP.get('直葬プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Preparation_TokubetsuWaribiki__c;
						System.debug('式後＋事前＋直葬プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('事前アンケート割') != null) && (mCDP.get('一日プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Preparation_TokubetsuWaribiki__c;
						System.debug('式後＋事前＋一日プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('仏具なし割引') != null) && (mCDP.get('直葬プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Butsugu_TokubetsuWaribiki__c;
						System.debug('式後＋仏具+直葬プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('仏具なし割引') != null) && (mCDP.get('一日プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Butsugu_TokubetsuWaribiki__c;
						System.debug('式後＋仏具+一日プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('事前アンケート割') != null) && (mCDP.get('仏具なし割引') != null) && (mCDP.get('直葬プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Preparation_Butsugu_TokubetsuWaribiki__c;
						System.debug('事前＋仏具+直葬プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('事前アンケート割') != null) && (mCDP.get('仏具なし割引') != null) && (mCDP.get('一日プラン特別割引') != null)){
						theShohinBangoPara = mCDP.get('プラン割').Preparation_Butsugu_TokubetsuWaribiki__c;
						System.debug('事前＋仏具+一日プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('事前アンケート割') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Preparation__c;
						System.debug('式後＋事前 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('仏具なし割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Butsugu__c;
						System.debug('式後＋仏具 ' + theShohinBangoPara);

					}else if((mCDP.get('事前アンケート割') != null) && (mCDP.get('仏具なし割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Preparation_Butsugu__c;
						System.debug('事前＋仏具 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('直葬プラン特別割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Survey_TokubetsuWaribiki__c;
						System.debug('式後＋直葬プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('式後アンケート割') != null) && (mCDP.get('一日プラン特別割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Survey_TokubetsuWaribiki__c;
						System.debug('式後＋一日プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('事前アンケート割') != null) && (mCDP.get('直葬プラン特別割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Preparation_TokubetsuWaribiki__c;
						System.debug('事前＋直葬プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('事前アンケート割') != null) && (mCDP.get('一日プラン特別割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Preparation_TokubetsuWaribiki__c;
						System.debug('事前＋一日プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('仏具なし割引') != null) && (mCDP.get('直葬プラン特別割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Butsugu_TokubetsuWaribiki__c;
						System.debug('仏具＋直葬プラン特別 ' + theShohinBangoPara);

					}else if((mCDP.get('仏具なし割引') != null) && (mCDP.get('一日プラン特別割引') != null) ){
						theShohinBangoPara = mCDP.get('プラン割').Butsugu_TokubetsuWaribiki__c;
						System.debug('仏具＋一日プラン特別 ' + theShohinBangoPara);

					}else if(mCDP.get('式後アンケート割') != null){
						theShohinBangoPara = mCDP.get('プラン割').Survey_Only__c;
						System.debug('式後 ' + theShohinBangoPara);

					}else if(mCDP.get('事前アンケート割') != null){
						theShohinBangoPara = mCDP.get('プラン割').Preparation_Only__c;
						System.debug('事前 ' + theShohinBangoPara);

					}else if(mCDP.get('仏具なし割引') != null){
						theShohinBangoPara = mCDP.get('プラン割').Butsugu_Only__c;
						System.debug('仏具 ' + theShohinBangoPara);

					}else if(mCDP.get('直葬プラン特別割引') != null){
						theShohinBangoPara = mCDP.get('プラン割').TokubetsuWaribiki_Only__c;
						System.debug('直葬プラン特別 ' + theShohinBangoPara);

					}else if(mCDP.get('一日プラン特別割引') != null){
						theShohinBangoPara = mCDP.get('プラン割').TokubetsuWaribiki_Only__c;
						System.debug('一日プラン特別 ' + theShohinBangoPara);

					}else{
						theShohinBangoPara = mCDP.get('プラン割').ShohinBango__c;
						System.debug('その他 ' + theShohinBangoPara);
					}
				}

			}
            AddOpp(theOpp);
            AddHontaiShohin(theOpp,theHontaiUriages);
            AddWaribikis(theWaribikis,theShohinBangoPara);
            AddCoupons(theCoupons);
            AddPartnerDiscounts(thePartnerDiscounts,theHontaiUriages);
            AddOptionUriages(theOpp,theOptionUriages);
            AddPayments(thePayments);       
            
            JucyuDenpyoResult result=new JucyuDenpyoResult();
            result.hasError=false;
            result.jucyuDenpyo=theJucyuDenpyo;
            system.debug('====================JucyuDenpyoBuilder.createByOppData end====================');
            return result;            
        }
	    private JucyuDenpyoResult createWaribikiShouldBeOnlyOneResult(String ErrMessage){
	    	JucyuDenpyoResult result=new JucyuDenpyoResult();
	    	result.hasError=True;
	    	result.errorMessage=ErrMessage;
	    	result.jucyuDenpyo=null;
	    	return result;
	    } 

		private List<CompoundDiscountPlan__mdt> slectCompoundDiscountPlan(Set<String> ServiceParameter,Set<String> ShohinBangoParameter){

			// issues4379 --Start--
			List<CompoundDiscountPlan__mdt> lCDP = [SELECT Id, 
													 DeveloperName,
													 Name__c,
													 k_Service_Id_exp__c,
													 k_Service_Name_exp__c,
													 k_WaribikiPlan_Name__c,
													 Preparation_Only__c,
													 Preparation_TokubetsuWaribiki__c,
													 Preparation_Butsugu__c,
													 Preparation_Butsugu_TokubetsuWaribiki__c,
													 Survey_Butsugu__c,
													 Survey_Butsugu_TokubetsuWaribiki__c,
													 Survey_Only__c,
													 Survey_Preparation__c,
													 Survey_Preparation_TokubetsuWaribiki__c,
													 Survey_Preparation_Butsugu__c,
													 Survey_Preparation_Butsugu_TokubetsuWari__c,
													 Survey_TokubetsuWaribiki__c,
													 ShohinBango__c,
													 TokubetsuWaribiki_Only__c,
													 Butsugu_Only__c,
													 Butsugu_TokubetsuWaribiki__c,
													 YukoFlg__c
											   FROM CompoundDiscountPlan__mdt 
											   WHERE k_Service_Id_exp__c in :ServiceParameter 
											   and YukoFlg__c = TRUE
											   and ShohinBango__c in :ShohinBangoParameter];
			// issues4379 --End--
			return lCDP;
		}

		private userDiscount NewWaribikisPlan(String theShohinBango){
			Product2 sP2 = [SELECT Id, k_WaribikiPlan_Id_exp__c,
										 (SELECT Id, UnitPrice FROM PricebookEntries)
									 FROM Product2 
									 WHERE ShohinBango__c = :theShohinBango limit 1];

			userDiscount oUserDiscount=new userDiscount();
	        oUserDiscount.recordType=2; 
	        oUserDiscount.discountPlanMasterId = sP2.k_WaribikiPlan_Id_exp__c;	
	        oUserDiscount.couponMasterId ='0';
			oUserDiscount.price = sP2.PricebookEntries[0].UnitPrice;
			return oUserDiscount;
		}

        public string getJsonBody(){
        	return JSON.serializePretty(this);
        }
        
        public void AddHontaiShohin(opportunity iOpp,List<OpportunityLineItem> iHontaiUriages){
        	for (OpportunityLineItem hontaiUriage:iHontaiUriages){
        		Item hontaiShohinItem=new Item();
        		hontaiShohinItem.orderDate = formatDate(iOpp.KakuteibiSyodan__c);
        		hontaiShohinItem.sfItemId = hontaiUriage.Product2.ShohinBango__c;
        		hontaiShohinItem.itemName = hontaiUriage.Product2.Name;
        		hontaiShohinItem.categoryCode = hontaiUriage.Product2.k_ShohinCategory_Id_exp__c;
				hontaiShohinItem.price = hontaiUriage.UnitPrice;
                hontaiShohinItem.amount = hontaiUriage.Quantity != null ? hontaiUriage.Quantity.intValue() : 0;    
				theJucyuDenpyo.items.add(hontaiShohinItem); 		
        	}

        }
        public void AddWaribikis(List<OpportunityLineItem> iWaribikis,String theShohinBangoPara){
        	Item FirstHontaiUriageItem=new Item();
        	if (theJucyuDenpyo.items.size() > 0){
        		FirstHontaiUriageItem = theJucyuDenpyo.items[0];
        	}
			if(String.isBlank(theShohinBangoPara)){
				for (OpportunityLineItem Waribiki:iWaribikis){
					userDiscount oUserDiscount=new userDiscount();
					oUserDiscount.recordType=2; 
					oUserDiscount.discountPlanMasterId =Waribiki.Product2.k_WaribikiPlan_Id_exp__c;	
					oUserDiscount.couponMasterId ='0';
					oUserDiscount.price = Waribiki.TotalPrice;
					FirstHontaiUriageItem.userDiscounts.add(oUserDiscount);      		
				}
			}else{
				FirstHontaiUriageItem.userDiscounts.add(this.NewWaribikisPlan(theShohinBangoPara));      		
			}
        	system.debug('AddWaribikis FirstHontaiUriageItem.userDiscounts=' + FirstHontaiUriageItem.userDiscounts);

        }
        public void AddCoupons(List<OpportunityLineItem> iCoupons){
        	Item FirstHontaiUriageItem=new Item();
        	if (theJucyuDenpyo.items.size()>0){
        		FirstHontaiUriageItem=theJucyuDenpyo.items[0];
        	}
        	for (OpportunityLineItem coupon:iCoupons){
	        	userDiscount oUserDiscount=new userDiscount();
	        	oUserDiscount.recordType=3; 
	        	oUserDiscount.discountPlanMasterId ='0';
	        	oUserDiscount.couponMasterId =coupon.Product2.k_Coupon_Id_exp__c;
				oUserDiscount.price = coupon.TotalPrice;
				FirstHontaiUriageItem.userDiscounts.add(oUserDiscount);      		
        	}
        }
        public void AddPartnerDiscounts( List<PatnerUriage__c> iPartnerDiscounts,List<OpportunityLineItem> iHontaiUriages){
        	Item FirstHontaiUriageItem=new Item();
        	if (theJucyuDenpyo.items.size()>0){
        		FirstHontaiUriageItem=theJucyuDenpyo.items[0];
        	}        	
        	for (PatnerUriage__c partnerDiscount:iPartnerDiscounts){
        		PartnerChargeDiscount oPartnerChargeDiscount=new PartnerChargeDiscount();
        		oPartnerChargeDiscount.name = String.valueOf(partnerDiscount.Syohin__r.name);
				oPartnerChargeDiscount.rebateAmount = partnerDiscount.Kingaku__c;
				FirstHontaiUriageItem.partnerChargeDiscounts.add(oPartnerChargeDiscount);
        	}  
        	//SBG-0000211商品の場合
        	for (OpportunityLineItem prodItem:iHontaiUriages){
        		if (prodItem.Product2.ShohinBango__c=='SBG-0000211'){
        			PartnerChargeDiscount oPartnerChargeDiscount=new PartnerChargeDiscount();
        			oPartnerChargeDiscount.name = '[移行データ]　お坊さん便';
        			if (prodItem.TesuryoPartner__c==null){
        				oPartnerChargeDiscount.rebateAmount = -prodItem.TotalPrice;
        			}else{
        				oPartnerChargeDiscount.rebateAmount = prodItem.TesuryoPartner__c-prodItem.TotalPrice;
        			}        			
        			FirstHontaiUriageItem.partnerChargeDiscounts.add(oPartnerChargeDiscount);
        		}        		
        	}
        }  
        public void AddPayments(List<OkyakusamaSeikyuMeisai__c> iPayments){
        	for (OkyakusamaSeikyuMeisai__c OkyakusamaSeikyuMeisai:iPayments){
        		PaymentLine oPaymentLine=new PaymentLine();
        		oPaymentLine.paymentMasterId=OkyakusamaSeikyuMeisai.SeikyuHohoCode__c;
        		oPaymentLine.paymentDate=formatDate(OkyakusamaSeikyuMeisai.Kessaibi__c);    	
				oPaymentLine.payment = OkyakusamaSeikyuMeisai.SeikyuKingaku__c;
        		theJucyuDenpyo.payment.payments.add(oPaymentLine);
        	}
        }

        public void AddOptionUriages(Opportunity iOpp,List<OpportunityLineItem> iOptionUriages){
        	for (OpportunityLineItem optionUriage:iOptionUriages){
        		Item OptionShohinItem=new Item();
        		OptionShohinItem.orderDate = formatDate(iOpp.KakuteibiSyodan__c);
        		OptionShohinItem.sfItemId = optionUriage.Product2.ShohinBango__c;
        		OptionShohinItem.itemName = optionUriage.Product2.Name;
        		OptionShohinItem.categoryCode = optionUriage.Product2.k_ShohinCategory_Id_exp__c;
                OptionShohinItem.price = optionUriage.UnitPrice;  
				OptionShohinItem.amount = optionUriage.Quantity != null ? optionUriage.Quantity.intValue() : 0;  
				theJucyuDenpyo.items.add(OptionShohinItem); 		
        	} 
        }
        public void AddOpp(opportunity iOpp){
			theJucyuDenpyo.sfId = iOpp.ShodanBangoF__c;
		    theJucyuDenpyo.rootSfId = iOpp.TorihikiShodanRef__r.ShodanBangoF__c;   	
        	theJucyuDenpyo.userId =iOpp.Account.TorihikisakiBangoF__c;	 
        	if  (string.isBlank(iOpp.Account.name)){
        		theJucyuDenpyo.userName=iOpp.Account.LastName+ ' ' + iOpp.Account.FirstName; 
        	}else{
        		theJucyuDenpyo.userName=iOpp.Account.name;
        	}
        	
        	theJucyuDenpyo.taishoshaName=resolveTaishoshaName(iOpp);
        	theJucyuDenpyo.salesDate=formatDate(iOpp.Utiagebi__c);
        	theJucyuDenpyo.fixedDate=formatDate(iOpp.KakuteibiSyodan__c);
            theJucyuDenpyo.isWon = iOpp.IsWon;
        	theJucyuDenpyo.partnerId=resolvePartnerId(iOpp);			
			theJucyuDenpyo.subTotal = iOpp.JucyuGokeiKingakuWaribikiJogai__c;			
			theJucyuDenpyo.totalAmount = iOpp.Amount;
        }
        private String resolveTaishoshaName(Opportunity opp){
        	string taishoshaName='';
        	if (opp.RecordType.DeveloperName=='SimpleYasugo'){
        		taishoshaName=opp.SimpleYasugoRef__r.TaishoshaRef__r.LastName+' '+opp.SimpleYasugoRef__r.TaishoshaRef__r.FirstName;
            }else if (opp.RecordType.DeveloperName=='Obosanbin'){        		
        		taishoshaName=opp.ObosanbinRef__r.Taishosha1Ref__r.name;
        	}else if (opp.RecordType.DeveloperName=='Seizenkeiyaku'){
        	}else if (opp.RecordType.DeveloperName=='PerpetualMemorial'){        		
        		taishoshaName =opp.EitaiKuyoRef__r.TaishoshaRef__r.name;
        	}else if (opp.RecordType.DeveloperName=='SougiRev'){        		
        		taishoshaName =opp.SogiReviRef__r.TaisyosyaRef__r.name;
        	}else if (opp.RecordType.DeveloperName=='KaiyoUmie'){        		
        		taishoshaName =opp.KaiyoSankotsuUmieRef__r.TaishoshaRef__r.name;
			}else if (opp.RecordType.DeveloperName=='KakuyasuButsudan'){
        		taishoshaName =opp.TaisyousyaNameTxt__c;        		
        	}else if (opp.RecordType.DeveloperName=='MosyuDaiko'){
			}
        	if (string.isblank(taishoshaName)){
        		taishoshaName='DUMMY';
        	}
        	return  taishoshaName;	    	
        }    		
    	private String resolvePartnerId(Opportunity opp){    		
    		String minreviId = '0';
    		string partnerId = '';
        	if (opp.RecordType.DeveloperName=='SimpleYasugo'){
        		partnerId = opp.SimpleYasugoRef__r.PartnerTorihikiSakiBangoExp__c;
        	}else if (opp.RecordType.DeveloperName=='Obosanbin'){
        		partnerId=opp.ObosanbinRef__r.PartnerTorihikiSakiBangoExp__c;
        	}else if (opp.RecordType.DeveloperName=='Seizenkeiyaku'){
        		partnerId = minreviId;
        	}else if (opp.RecordType.DeveloperName=='PerpetualMemorial'){
        		partnerId =opp.EitaiKuyoRef__r.PartnerTorihikiSakiBangoExp__c;        		
        	}else if (opp.RecordType.DeveloperName=='SougiRev'){
        		partnerId =opp.SogiReviRef__r.PartnerTorihikiSakiBangoExp__c;        		
        	}else if (opp.RecordType.DeveloperName=='KaiyoUmie'){
        		partnerId =opp.KaiyoSankotsuUmieRef__r.PartnerTorihikiSakiBangoExp__c; 
        	}else if (opp.RecordType.DeveloperName=='KakuyasuButsudan'){
        		partnerId ='BB-00001'; 
        	}else if (opp.RecordType.DeveloperName=='MosyuDaiko'){
        		partnerId =opp.MosyuDaikoRef__r.PartnerTorihikiSakiBangoExp__c; 
			}
        	return partnerId;
    	}   
		/**
	    * formatDate
	    * （yyyy/mm/dd）
	    * @param Datetime inDatetime
	    * @return String
	    * @created: 2017/12/20 Vinh Hua Quoc
	    * @modified: 
	    */
		private String formatDate(Datetime inDatetime){
			if(inDatetime == null){
				return null;
			} else {
				return inDatetime.format('yyyy/MM/dd');
			}
		}    	 	             
    }
    public class JucyuDenpyoService{
    	public void runProc(Opportunity iOpp){
    		system.debug('====================JucyuDenpyoService.runProc begin====================');
    		//登録.更新
    		if (iOpp.IsWon){
    			sentUpsert(iOpp);
    		}else{
    		//キャンセル	
    		    sentCancel(iOpp);
    		}
    		system.debug('====================JucyuDenpyoService.runProc end====================');
    	}
        public void runTesuryoKeisanProc(Opportunity iOpp){
            sentUpsert(iOpp);
            Opportunity_SimeSiharaiDate.setYorisoNoOsoshikiSimeShiharaiDate(iOpp.Id);
			Decimal tokyakuten_tesuryo = SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo(iOpp.Id);
			Opportunity a_opp_update = new Opportunity(
				Id = iOpp.Id,
				TokuyakutenTesuryoKihonbun__c = tokyakuten_tesuryo
				);
			UPDATE a_opp_update; 
        }
    	private void sentCancel(Opportunity iOpp){
    		system.debug('====================JucyuDenpyoService.sentCancel begin====================');
    		Opportunity tempOpp=new Opportunity();  
    		tempOpp.id=iOpp.id;    	
    		try{
	    		HttpResponse res=callOutDelete(iOpp.ShodanBangoF__c, iOpp.Id);
	    		//HttpResponse res=callOutDelete('101');
	    		system.debug('***res2='+res);
	    		if (res.getStatusCode()==200){
	    			//処理ステータス
	    			tempOpp.ShoriStatus__c='連携済';
	    			//処理ステータス備考
	    			tempOpp.ShoriStatusBiko__c='連携が成功しました！';
                    tempOpp.TesuryoKeisanzumi__c = false;
	    		}else{
	    		//失敗
	    		    system.debug('***失敗');
		         	//処理ステータス
		        	tempOpp.ShoriStatus__c='エラー';
	                //処理ステータス備考
		            tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
	    		}
    		}catch(exception e){
         		//処理ステータス
        		tempOpp.ShoriStatus__c='エラー';
                //処理ステータス備考
                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+ e.getMessage();
    		}
		
	    	Savepoint sp = Database.setSavepoint();
	        try {
	            update tempOpp;
	        } catch(DMLException e) {
	            Database.rollback(sp);
	            System.debug('DMLException:' + e.getMessage());
	        } catch(Exception e) {
	            Database.rollback(sp);
	            System.debug('saveDto Exception:' + e.getMessage());
	        }
	        system.debug('====================JucyuDenpyoService.sentCancel end====================');    		
    	}
    	private void sentUpsert(Opportunity iOpp){
    		system.debug('====================JucyuDenpyoService.sentUpsert begin====================');
    		Opportunity tempOpp=new Opportunity();
			tempOpp.id=iOpp.id;    	
    		try{	
	    		JucyuDenpyoBuilder builder=new JucyuDenpyoBuilder(iOpp.id);
	    		JucyuDenpyoResult DenpyoResult=builder.createByOppData();
	    		if (DenpyoResult.hasError){
	    			throw new applicationException(DenpyoResult.errorMessage);	    			
	    		}
	    		system.debug('***DenpyoResult='+DenpyoResult);
				string JsonBody=JSON.serializePretty(DenpyoResult.jucyuDenpyo);
				system.debug('***JsonBody='+JsonBody);
				HttpResponse res=callOutInsertUpdate(JsonBody,iOpp.id);
	    		//成功
	    		if (res.getStatusCode()==200){
                    String resBody = res.getBody();
                    RestResponseParam resparam = (RestResponseParam)JSON.deserialize(resBody, RestResponseParam.class);
                    system.debug('***resparam='+resparam);
                    if(!iOpp.IsWon){
						tempOpp.TesuryoPartnerForPlan__c = resparam.planTesuryo;
						tempOpp.TesuryoPartnerForOption__c = resparam.optionTesuryo.total;
						tempOpp.TesuryoPartnerForSogiOption__c = resparam.optionTesuryo.details.sogisha;
						tempOpp.TesuryoPartnerForYorisoOption__c = resparam.optionTesuryo.details.yoriso;
						tempOpp.JimuTesuryo__c = resparam.jimuTesuryo;
                    }
	    			//処理ステータス	
	    			tempOpp.ShoriStatus__c='連携済';
	    			//処理ステータス備考
	    			tempOpp.ShoriStatusBiko__c='連携が成功しました！';
                    tempOpp.TesuryoKeisanzumi__c = true;
                    tempOpp.NyukinSimekiriBiPartner__c = iOpp.NyukinSimekiriBiPartner__c;
	    		}else{
	    		//失敗
	    		    system.debug('***失敗');
	    			//処理ステータス
		        	tempOpp.ShoriStatus__c='エラー';
	                //処理ステータス備考
		            tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
	    		}

                Loggings.writeLog(
                    Loggings.createLogEntry(
                        res.getStatusCode() == 200 ? Loggings.Level.Info : Loggings.Level.Error, '20191126-1138-01', '手数料計算処理')
                        .putAttr('theResult.statusCode',String.valueOf(res.getStatusCode()) )
                        .putAttr('theResult.reqBodyRaw',JsonBody)
                        .putAttr('theResult.resBodyRaw',res.getBody())
                        .putAttr('theResult.descr','手数料計算結果')
				);

			}catch(exception e){
				//処理ステータス
        		tempOpp.ShoriStatus__c='エラー';
                //処理ステータス備考
                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラー情報：'+ e.getMessage();
			}
	    	Savepoint sp = Database.setSavepoint();
	        try {
	            update tempOpp;
	        } catch(DMLException e) {
	            Database.rollback(sp);
	            System.debug('DMLException:' + e.getMessage());
	        } catch(Exception e) {
	            Database.rollback(sp);
	            System.debug('saveDto Exception:' + e.getMessage());
	        }    
	        system.debug('====================JucyuDenpyoService.sentUpsert end====================');   		
    	}
    	HttpResponse callOutInsertUpdate(string jsonBody, Id pOppId){
    		system.debug('====================JucyuDenpyoService.callOutInsertUpdate begin====================');	     	
	    	string EndPointUrl=RsCoreApi_Configs.getConfig().EndPoint__c;    	
	    	EndPointUrl = EndPointUrl+'/order';
	    	HttpRequest request = new HttpRequest(); 
			request.setEndpoint(EndPointUrl);
			request.setMethod('POST');
			request.setHeader('Content-Type', 'application/json;charset=UTF-8');
			RsCoreApi_AuthClients.getInstance().setAuthHeader(request);		
			system.debug('***EndPointUrl='+EndPointUrl);
			system.debug('***request='+request);
			request.setBody(jsonBody);
	        HttpResponse response = new http().send(request);
	        system.debug('*response='+response);
	        system.debug('***JucyuDenpyoService.callOutInsertUpdate.end***');
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Info, '20180620-1143-01', 'CoreRenkei.JucyuData.callOutInsertUpdate')
					.setSubjectRecordId(pOppId)
					.putAttr('endPoint',EndPointUrl)
					.putAttr('reqBodyRaw',jsonBody)
					.putAttr('statusCode', String.valueOf( response.getStatusCode() ) )
			);
			return response;				
    	}
    	HttpResponse callOutDelete(string removeRecordId, Id pOppId){
	     	system.debug('***JucyuDenpyoService.callOutDelete.begin***');
	    	string EndPointUrl=RsCoreApi_Configs.getConfig().EndPoint__c;    	
	    	string DELETE_ENDPOINT = EndPointUrl+'/order/';    	
	    	HttpRequest request = new HttpRequest(); 
			request.setEndpoint(DELETE_ENDPOINT + removeRecordId);		
			request.setMethod('DELETE');		
			request.setHeader('Content-Type', 'application/json;charset=UTF-8');
			RsCoreApi_AuthClients.getInstance().setAuthHeader(request);		
			system.debug('***request='+request);
	        HttpResponse response = new http().send(request);
	        system.debug('*response='+response);
	        system.debug('***JucyuDenpyoService.callOutDelete.end***');
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Info, '20180620-1143-02', 'CoreRenkei.JucyuData.callOutDelete')
					.setSubjectRecordId(pOppId)
					.putAttr('endPoint',DELETE_ENDPOINT + removeRecordId)
					.putAttr('statusCode', String.valueOf( response.getStatusCode() ) )
			);
			return response;				
   		}
	    }     
}