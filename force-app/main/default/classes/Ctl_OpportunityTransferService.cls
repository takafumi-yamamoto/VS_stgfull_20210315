public class Ctl_OpportunityTransferService {
	private static String DATA_KUBUN_2 = '2:割引プラン';
	private static String DATA_KUBUN_3 = '3:クーポン';
	private List<Opportunity> oppInsertUpdateLst=new List<Opportunity>();
	private List<Opportunity> oppDeleteLst = new List<Opportunity>();
	private List<OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiLst = new List<OkyakusamaSeikyuMeisai__c>();
	private List<PatnerUriage__c> patnerUriageLst = new List<PatnerUriage__c>();
	
	private class OpportunityWrapper {
		//商談ID⇒商談.商談番号
		public String sfId {get; set;}
		//親商談ID⇒商談.親商談.商談番号
		public String rootSfId {get; set;}
		//ユーザーID⇒商談.取引先名.取引先番号
		public String userId {get; set;}
		//売上日⇒商談.売上日
		public String salesDate {get; set;}
		//提携先マスタID⇒商談.決定提携先.取引先番号
		public String partnerId {get; set;}
		//受注合計⇒商談.受注合計金額(割引除外)
		public String subTotal {get; set;}		
		//受注合計（割引適用後金額）⇒商談.金額						
		public String totalAmount {get; set;}
		//商品リスト
		public List<ShohinWrapper> items {get; set;}		
		public object payment {get; set;}
	}
	private class ShohinWrapper {
		//受注日⇒商談.確定日(商談)　※日時⇒日付に変換
		public String orderDate {get; set;}
		//商品マスタID⇒商談商品.商品.商品番号
		public String itemId {get; set;}
		//会計品目マスタID
		//public String serviceAccountMasterId {get; set;}
		//商品名⇒商談商品.商品.商品名
		public String itemName {get; set;}
		//商品カテゴリーコード⇒商談商品.商品.k_商品カテゴリ_Name_exp
		public String categoryCode {get; set;}
		//定価⇒商談商品.合計金額
		public String price {get; set;}
		//ユーザー向け割引
		public List<object> userDiscounts {get; set;}
		public List<PartnerChargeDiscount> partnerChargeDiscounts {get; set;}
	}	
	private class PaymentWrapper {
		public String paymentMasterId {get; set;}
		public String paymentDate {get; set;}
		public String payment {get; set;}
	}	
	//通常契約
	private class Payment1Wrapper{
		public list<PaymentWrapper> payments {get; set;}
	}
	//生前契約
	private class Payment2Wrapper{
		public PaymentWrapper deposit {get; set;}
	}
	///データ区分2　※固定	
	private class UserDiscount2 {
		//データ区分2　※固定
		public integer recordType {get; set;}
		//割引プランマスタID⇒商談商品.商品.k_割引プラン_Name_exp
		public String discountPlanMasterId {get; set;}
		//割引金額⇒商談商品.合計金額
		public String price {get; set;}
	}	
	//データ区分3　※固定	
	private class UserDiscount3 {
		//データ区分3　※固定
		public integer recordType {get; set;}
		//クーポンマスタID⇒商談商品.商品.k_クーポン_Name_exp
		public String couponMasterId {get; set;}
		//商談商品.合計金額
		public String price {get; set;}
	}
	private class PartnerChargeDiscount {
		//割引金額⇒パートナー売上.金額
		public String rebateAmount {get; set;}
	}	
	
    HttpResponse callOutInsertUpdate(string jsonBody){
     	system.debug('***Ctl_OpportunityTransferService.callOutInsertUpdate.begin***');
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
        system.debug('***Ctl_OpportunityTransferService.callOutInsertUpdate.end***');
		return response;				
    }
    HttpResponse callOutDelete(string removeRecordId){
     	system.debug('***Ctl_OpportunityTransferService.callOutDelete.begin***');
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
        system.debug('***Ctl_OpportunityTransferService.callOutDelete.end***');
		return response;				
    }    
    public void requestTransfer(List<Opportunity> oppLst){
    	oppInsertUpdateLst=getOppInsertUpdateLst(oppLst);
    	oppDeleteLst=getOppDeleteLst(oppLst);
    	list<id> idInsertUpdateLst=getIdLst(oppInsertUpdateLst);    	
    	okyakusamaSeikyuMeisaiLst=Dao_OkyakusamaSeikyuMeisai.getOkyakusamaSeikyuMeisaiByOppids(idInsertUpdateLst);
    	patnerUriageLst = Dao_PatnerUriage.getPatnerUriageByOppids(idInsertUpdateLst);
    	sendRequest();
    }
    public void sendRequest(){
    	system.debug('========Ctl_OpportunityTransferService.sendRequest.begin========');
    	system.debug('***oppInsertUpdateLst='+oppInsertUpdateLst);
    	system.debug('***oppdeleteLst='+oppDeleteLst);
    	list<Opportunity> oppUpdateLst=new list<Opportunity>();
    	//登録．更新
    	for (Opportunity oppInsertUpdate:oppInsertUpdateLst){
    		Opportunity tempOpp=new Opportunity();
    		tempOpp.id=oppInsertUpdate.id;    	
    		tempOpp.TryCount__c=oppInsertUpdate.TryCount__c;
    		tempOpp.TryLimit__c=oppInsertUpdate.TryLimit__c; 	
    		string JsonBody=getJsonBody(oppInsertUpdate);
    		//string JsonBody=getJsonBodyforTest(oppInsertUpdate);
    		system.debug('***JsonBody='+JsonBody);
    		//登録呼び出す
    		try{
	    		HttpResponse res=callOutInsertUpdate(JsonBody);
	    		system.debug('***res1='+res);
	    		//成功
	    		if (res.getStatusCode()==200){
	    			//処理ステータス
	    			tempOpp.ShoriStatus__c='連携済';
	    			//処理ステータス備考
	    			tempOpp.ShoriStatusBiko__c='連携が成功しました！';  			
	    		}else{
	    		//失敗
	    		    system.debug('***失敗');
	    			if (isRetry(oppInsertUpdate)){
	    				//処理ステータス
	    				tempOpp.ShoriStatus__c='連携中';
	                    //処理ステータス備考
		                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
		                //リトライ回数
		                setTryCount(tempOpp);
	    			}else{
		         		//処理ステータス
		        		tempOpp.ShoriStatus__c='エラー';
	                    //処理ステータス備考
		                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
		                //連携回数をリセット
		                tempOpp.TryCount__c=0;
	    			}
	    		}	    				
    		}catch(exception e){
				//処理ステータス
        		tempOpp.ShoriStatus__c='エラー';
                //処理ステータス備考
                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+ e.getMessage();
                //連携回数をリセット
                tempOpp.TryCount__c=0; 
    		}
    		oppUpdateLst.add(tempOpp);  
    	}    	

    	//キャンセル
    	for (Opportunity oppDelete:oppDeleteLst){
    		Opportunity tempOpp=new Opportunity();  
    		tempOpp.id=oppDelete.id;    	
    		tempOpp.TryCount__c=oppDelete.TryCount__c;
    		tempOpp.TryLimit__c=oppDelete.TryLimit__c; 	  	
    		try{
	    		HttpResponse res=callOutDelete(oppDelete.ShodanBangoF__c);
	    		//HttpResponse res=callOutDelete('101');
	    		system.debug('***res2='+res);
	    		if (res.getStatusCode()==200){
	    			//処理ステータス
	    			tempOpp.ShoriStatus__c='連携済';
	    			//処理ステータス備考
	    			tempOpp.ShoriStatusBiko__c='連携が成功しました！';  			
	    		}else{
	    		//失敗
	    		    system.debug('***失敗');
	    			if (isRetry(oppDelete)){
	    				//処理ステータス
	    				tempOpp.ShoriStatus__c='連携中';
	                    //処理ステータス備考
		                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
		                //リトライ回数
		                setTryCount(tempOpp);
	    			}else{
		         		//処理ステータス
		        		tempOpp.ShoriStatus__c='エラー';
	                    //処理ステータス備考
		                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
		                //連携回数をリセット
		                tempOpp.TryCount__c=0;	                
	    			}
	    		}
    		}catch(exception e){
         		//処理ステータス
        		tempOpp.ShoriStatus__c='エラー';
                //処理ステータス備考
                tempOpp.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+ e.getMessage();
                //連携回数をリセット
                tempOpp.TryCount__c=0;
    		}
    		oppUpdateLst.add(tempOpp);    		
    	}
    	Savepoint sp = Database.setSavepoint();
        try {
            update oppUpdateLst;
        } catch(DMLException e) {
            Database.rollback(sp);
            System.debug('DMLException:' + e.getMessage());
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug('saveDto Exception:' + e.getMessage());
        }
        system.debug('========Ctl_OpportunityTransferService.sendRequest.end========');
    }
    private list<id> getIdLst(list<sobject> sObjectLst){
    	list<id> resultLst=new list<id>();
    	Set<Id> resultIds = (new Map<Id,SObject>(sObjectLst)).keySet();
    	resultLst.addall(resultIds);
    	return resultLst;   	 
    }
    /**
    * リトライ
    */
    private void retryRequest(List<Opportunity> oppRetryList){
    	// add to queue to run 
    	if(oppRetryList != null && oppRetryList.size() > 0){
    		Utility_Common.sleep(1000);
    		system.debug('***try begin=='+oppRetryList);
    		new Ctl_Opportunity().SendToJob(oppRetryList);
    	}
    }    
    private Boolean isRetry(Opportunity opp) {
    	system.debug('***isRetry.TryCount__c='+opp.TryCount__c);
    	return (opp.TryCount__c < opp.TryLimit__c);
    }     
    private void setTryCount(Opportunity opp) {
    	Decimal retryCount = opp.TryCount__c == null ? 0 : opp.TryCount__c;
    	opp.TryCount__c = retryCount + 1;
    }	   

    private string getJsonBody(Opportunity opp){
    	//userDiscounts或いはpartnerChargeDiscountsがNullの場合はjsonから削除する。
    	list<string> DeleteItemFromJsonList=new list<string>();
    	//お客様明細Map
		Map<id,List<OkyakusamaSeikyuMeisai__c>> mapOkyakusamaSeikyuMeisai = new Map<id,List<OkyakusamaSeikyuMeisai__c>>();
		for(OkyakusamaSeikyuMeisai__c item : okyakusamaSeikyuMeisaiLst){
			id key = item.OpportunityRef__c;
			if(mapOkyakusamaSeikyuMeisai.containsKey(key)){
				mapOkyakusamaSeikyuMeisai.get(key).add(item);
			} else {
				List<OkyakusamaSeikyuMeisai__c> lstValues = new List<OkyakusamaSeikyuMeisai__c>{item};
				mapOkyakusamaSeikyuMeisai.put(key, lstValues);
			}
		}    	
    	
    	
		Map<String,List<PatnerUriage__c>> mapPatnerUriage = new Map<String,List<PatnerUriage__c>>();
		//提携先向け割引
		for(PatnerUriage__c item : patnerUriageLst){
			String key = item.Syodan__c + '_' + item.Syohin__c;
			if(mapPatnerUriage.containsKey(key)){
				mapPatnerUriage.get(key).add(item);
			} else {
				List<PatnerUriage__c> lstValues = new List<PatnerUriage__c>{item};
				mapPatnerUriage.put(key, lstValues);
			}
		}
		OpportunityWrapper myOpportunityWrapper = new OpportunityWrapper();
		
		//商談.商談番号
		myOpportunityWrapper.sfId = opp.ShodanBangoF__c;
		//親商談ID		
		myOpportunityWrapper.rootSfId = opp.TorihikiShodanRef__r.ShodanBangoF__c;
		//ユーザーID		
		myOpportunityWrapper.userId =opp.Account.TorihikisakiBangoF__c;
		//売上日
		myOpportunityWrapper.salesDate = formatDate(opp.Utiagebi__c);
		//提携先マスタID
		myOpportunityWrapper.partnerId = opp.KetteiTeikeisaki__r.TorihikisakiBangoF__c;
		//受注合計
		if(opp.JucyuGokeiKingakuWaribikiJogai__c != null){
			myOpportunityWrapper.subTotal = String.valueOf(opp.JucyuGokeiKingakuWaribikiJogai__c);
		}
		//受注合計（割引適用後金額）
		if(opp.Amount != null){
			myOpportunityWrapper.totalAmount = String.valueOf(opp.Amount);
		}
		List<ShohinWrapper> lstShohinWrapper = new List<ShohinWrapper>();
		system.debug('***opp.OpportunityLineItems='+ opp.OpportunityLineItems);
		for(OpportunityLineItem item : opp.OpportunityLineItems){
			ShohinWrapper shohinWrapper = new ShohinWrapper();
			// 受注日
			shohinWrapper.orderDate = formatDate(opp.KakuteibiSyodan__c);
            // 商品マスタID
			shohinWrapper.itemId = item.Product2.ShohinBango__c;
			//会計品目マスタID
			//shohinWrapper.serviceAccountMasterId='1';
			// 商品名
			shohinWrapper.itemName = item.Product2.Name;
			// 商品カテゴリーコード
			shohinWrapper.categoryCode = item.Product2.k_ShohinCategory_Id_exp__c;
			//定価
			if(item.TotalPrice != null){
				shohinWrapper.price = String.valueOf(item.TotalPrice);
			}
			
			//UserAccount
			List<object> lstUserDiscount = new List<object>();
			if(item.Product2.DataKubun__c == DATA_KUBUN_2){				
				UserDiscount2 tempUserDiscount = new UserDiscount2();
				//データ区分（2:割引プラン(複数不可))
				tempUserDiscount.recordType = 2;
				// 割引プランマスタID
				tempUserDiscount.discountPlanMasterId =item.Product2.k_WaribikiPlan_Id_exp__c;
				//割引金額
				if(item.TotalPrice != null){
					tempUserDiscount.price = String.valueOf(item.TotalPrice);
				}
				lstUserDiscount.add(tempUserDiscount);
			} else if(item.Product2.DataKubun__c == DATA_KUBUN_3){
				UserDiscount3 tempUserDiscount = new UserDiscount3();
				//データ区分（3:クーポン(複数可))
				tempUserDiscount.recordType =3;
				//クーポンマスタID
				tempUserDiscount.couponMasterId = item.Product2.k_Coupon_Id_exp__c;
				//割引金額
				if(item.TotalPrice != null){
					tempUserDiscount.price = String.valueOf(item.TotalPrice);
				}
				lstUserDiscount.add(tempUserDiscount);
			}			
			if(!lstUserDiscount.isEmpty()){	
				shohinWrapper.userDiscounts = lstUserDiscount;
			}else{
				DeleteItemFromJsonList.add('userDiscounts');
			}				
			// partnerChargeDiscounts
			List<PartnerChargeDiscount> lstPartnerChargeDiscount = new List<PartnerChargeDiscount>();
			String myKey = opp.Id + '_' + item.Product2.Id;
			system.debug('**opp.Id='+opp.Id);
			system.debug('**item.Product2.Id='+item.Product2.Id);
			system.debug('**mapPatnerUriage='+mapPatnerUriage);
			if(mapPatnerUriage.containsKey(myKey)){
				for(PatnerUriage__c itemPatnerUriage : mapPatnerUriage.get(myKey)){
					PartnerChargeDiscount tempPartnerChargeDiscount = new PartnerChargeDiscount();
					if(itemPatnerUriage.Kingaku__c != null){
						tempPartnerChargeDiscount.rebateAmount = String.valueOf(itemPatnerUriage.Kingaku__c);
					}
					lstPartnerChargeDiscount.add(tempPartnerChargeDiscount);
				}
			}
			
			if(!lstPartnerChargeDiscount.isEmpty()){
				shohinWrapper.partnerChargeDiscounts =lstPartnerChargeDiscount;
			}else{
				DeleteItemFromJsonList.add('partnerChargeDiscounts');
			}
			lstShohinWrapper.add(shohinWrapper);
		}
		myOpportunityWrapper.items = lstShohinWrapper;		

		//生前契約の場合
		if (opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku')){
			Payment2Wrapper tempPayment2=new Payment2Wrapper();
			if(mapOkyakusamaSeikyuMeisai.containsKey(opp.id)){
				for (OkyakusamaSeikyuMeisai__c itemOkyakusamaSeikyuMeisai : mapOkyakusamaSeikyuMeisai.get(opp.id)){					
					PaymentWrapper itemPaymentWrapper=new PaymentWrapper();
					itemPaymentWrapper.paymentMasterId=itemOkyakusamaSeikyuMeisai.SeikyuHohoCode__c;					
					itemPaymentWrapper.paymentDate=formatDate(itemOkyakusamaSeikyuMeisai.Kessaibi__c);
					if(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c != null){
						itemPaymentWrapper.payment = String.valueOf(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c);
					}	
					tempPayment2.deposit=itemPaymentWrapper;	
				}
			}		
			myOpportunityWrapper.payment=tempPayment2;
		}else{
		//通常契約の場合
			Payment1Wrapper tempPayment1=new Payment1Wrapper();
			if(mapOkyakusamaSeikyuMeisai.containsKey(opp.id)){
				List<PaymentWrapper> lstPayment = new List<PaymentWrapper>();
				for (OkyakusamaSeikyuMeisai__c itemOkyakusamaSeikyuMeisai : mapOkyakusamaSeikyuMeisai.get(opp.id)){	
					PaymentWrapper itemPaymentWrapper=new PaymentWrapper();
					itemPaymentWrapper.paymentMasterId=itemOkyakusamaSeikyuMeisai.SeikyuHohoCode__c;
                    itemPaymentWrapper.paymentDate=formatDate(itemOkyakusamaSeikyuMeisai.Kessaibi__c);
					if(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c != null){
						itemPaymentWrapper.payment = String.valueOf(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c);
					}
					lstPayment.add(itemPaymentWrapper);
				}
				tempPayment1.payments=lstPayment;
			}
			myOpportunityWrapper.payment=tempPayment1;
		}
		string JsonBody=JSON.serializePretty(myOpportunityWrapper);
		return (JsonBody);
    }
  
    public List<Opportunity> getOppInsertUpdateLst(List<Opportunity> oppLst){
    	list<Opportunity> resultLst = new list<Opportunity>();
    	list<id> idlst=new list<id>();
    	for (Opportunity opp:oppLst){
    		//登録
    		if (opp.IsWon){
    			idlst.add(opp.id);
    		}
    	}
    	resultLst=Dao_Opportunity.SearchByIds(idlst);    	
    	return resultLst;
    }
    public List<Opportunity> getOppDeleteLst(List<Opportunity> oppLst){
    	list<Opportunity> resultLst = new list<Opportunity>();
    	for (Opportunity opp:oppLst){
    		//delete
    		if (!opp.IsWon){
    			resultLst.add(opp);
    		}
    	}
    	return resultLst;
    }   
	/**
    * formatDate
    * （yyyy/mm/dd）
    * @param Datetime inDatetime
    * @return String
    * @created: 2017/12/20 Vinh Hua Quoc
    * @modified: 
    */
	private static String formatDate(Datetime inDatetime){
		if(inDatetime == null){
			return null;
		} else {
			return inDatetime.format('yyyy/MM/dd');
		}
	}    
	
	
/////*******************************************************************以下からテスト用******************************************************************//	
/////*******************************************************************以下からテスト用******************************************************************//	
/////*******************************************************************以下からテスト用******************************************************************//	
/////*******************************************************************以下からテスト用******************************************************************//	
/////*******************************************************************以下からテスト用******************************************************************//	
/*	private string jsontest(){
		string str='';
		str=str+'{';
		str=str+'"sfId": "101",';
		str=str+'"rootSfId": "101",';
		str=str+'"userId": "1",';
		str=str+'"salesDate": "2017/10/03",';
		str=str+'"partnerId": 1,';
		str=str+'"subTotal": 148000,';
		str=str+'"totalAmount": 133000,';
		str=str+'"items": [';
		str=str+'{';
		str=str+'"orderDate": "2017/09/28",';
		str=str+'"serviceAccountMasterId": 1,';
		str=str+'"itemId": 2,';
		str=str+'"itemName": "火葬式　無宗教プラン",';
		str=str+'"categoryCode": "kasou",';
		str=str+'"partnerId": 1,';
		str=str+'"price": 148000,';
		str=str+'"userDiscounts": [';
		str=str+'{';
		str=str+'"recordType": 2,';
		str=str+'"discountPlanMasterId": 2,';
		str=str+'"price": 15000';
		str=str+'}';
		str=str+'],';
		str=str+'"partnerChargeDiscounts": [';
		str=str+'{';
		str=str+'"rebateAmount": 1000';
		str=str+'}';
		str=str+']';
		str=str+'}';
		str=str+' ],';
		str=str+'"payment": {';
		str=str+'"payments": [';
		str=str+'{';
        str=str+'"paymentMasterId": 1,';
        str=str+'"paymentDate": "2017/10/12",';
        str=str+'"payment": 133000';
        str=str+'}';
        str=str+']}}';
	  return str;
	} 
    private string getJsonBodyforTest(Opportunity opp){
    	
    	//お客様明細Map
		Map<id,List<OkyakusamaSeikyuMeisai__c>> mapOkyakusamaSeikyuMeisai = new Map<id,List<OkyakusamaSeikyuMeisai__c>>();
		for(OkyakusamaSeikyuMeisai__c item : okyakusamaSeikyuMeisaiLst){
			id key = item.OpportunityRef__c;
			if(mapOkyakusamaSeikyuMeisai.containsKey(key)){
				mapOkyakusamaSeikyuMeisai.get(key).add(item);
			} else {
				List<OkyakusamaSeikyuMeisai__c> lstValues = new List<OkyakusamaSeikyuMeisai__c>{item};
				mapOkyakusamaSeikyuMeisai.put(key, lstValues);
			}
		}    	
    	
    	
		Map<String,List<PatnerUriage__c>> mapPatnerUriage = new Map<String,List<PatnerUriage__c>>();
		//提携先向け割引
		for(PatnerUriage__c item : patnerUriageLst){
			String key = item.Syodan__c + '_' + item.Syohin__c;
			if(mapPatnerUriage.containsKey(key)){
				mapPatnerUriage.get(key).add(item);
			} else {
				List<PatnerUriage__c> lstValues = new List<PatnerUriage__c>{item};
				mapPatnerUriage.put(key, lstValues);
			}
		}
		OpportunityWrapper myOpportunityWrapper = new OpportunityWrapper();
		
		//商談.商談番号
		myOpportunityWrapper.sfId = opp.ShodanBangoF__c;
		//親商談ID
		//生前契約の場合
		if (opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku')){
			myOpportunityWrapper.rootSfId ='101';// opp.ShodanBangoF__c;
		}else{
			myOpportunityWrapper.rootSfId = '101';//opp.TorihikiShodanRef__c;
		}
		//ユーザーID		
		myOpportunityWrapper.userId ='1';// opp.Account.AccountNumber;
		//売上日
		myOpportunityWrapper.salesDate = formatDate(opp.Utiagebi__c);
		//提携先マスタID
		myOpportunityWrapper.partnerId = '1';//opp.KetteiTeikeisaki__r.AccountNumber;
		//受注合計
		if(opp.JucyuGokeiKingakuWaribikiJogai__c != null){
			myOpportunityWrapper.subTotal = String.valueOf(opp.JucyuGokeiKingakuWaribikiJogai__c);
		}
		//受注合計（割引適用後金額）
		if(opp.Amount != null){
			myOpportunityWrapper.totalAmount = String.valueOf(opp.Amount);
		}
		List<ShohinWrapper> lstShohinWrapper = new List<ShohinWrapper>();
		system.debug('***opp.OpportunityLineItems='+ opp.OpportunityLineItems);
		for(OpportunityLineItem item : opp.OpportunityLineItems){
			ShohinWrapper shohinWrapper = new ShohinWrapper();
			// 受注日
			shohinWrapper.orderDate = formatDate(opp.KakuteibiSyodan__c);
            // 商品マスタID
			shohinWrapper.itemId = '2';//item.Product2.ProductCode;
			//会計品目マスタID
			//shohinWrapper.serviceAccountMasterId='1';
			// 商品名
			shohinWrapper.itemName = '火葬式　無宗教プラン';//item.Product2.Name;
			// 商品カテゴリーコード
			shohinWrapper.categoryCode = 'kasou';//item.Product2.SyohinKategoriCode__c;
			//定価
			if(item.TotalPrice != null){
				shohinWrapper.price = String.valueOf(item.TotalPrice);
			}
			
			//UserAccount
			List<object> lstUserDiscount = new List<object>();
			/*if(item.Product2.DataKubun__c == DATA_KUBUN_2){				
				UserDiscount2 tempUserDiscount = new UserDiscount2();
				//データ区分（2:割引プラン(複数不可))
				tempUserDiscount.recordType = 2;
				// 割引プランマスタID
				tempUserDiscount.discountPlanMasterId ='2';// item.Product2.k_WaribikiPlan_Name_exp__c;
				//割引金額
				if(item.TotalPrice != null){
					tempUserDiscount.price = String.valueOf(item.TotalPrice);
				}
				lstUserDiscount.add(tempUserDiscount);
			} else if(item.Product2.DataKubun__c == DATA_KUBUN_3){
				UserDiscount3 tempUserDiscount = new UserDiscount3();
				//データ区分（3:クーポン(複数可))
				tempUserDiscount.recordType =3;
				//クーポンマスタID
				tempUserDiscount.couponMasterId = 'kasou';//item.Product2.KuponCode__c;
				//割引金額
				if(item.TotalPrice != null){
					tempUserDiscount.price = String.valueOf(item.TotalPrice);
				}
				lstUserDiscount.add(tempUserDiscount);
			}	*/
	/*		if(item.Product2.DataKubun__c == DATA_KUBUN_3){				
				UserDiscount2 tempUserDiscount = new UserDiscount2();
				//データ区分（2:割引プラン(複数不可))
				tempUserDiscount.recordType = 2;
				// 割引プランマスタID
				tempUserDiscount.discountPlanMasterId ='2';// item.Product2.k_WaribikiPlan_Name_exp__c;
				//割引金額
				if(item.TotalPrice != null){
					tempUserDiscount.price = String.valueOf(item.TotalPrice);
				}
				lstUserDiscount.add(tempUserDiscount);
			}
			
			if(!lstUserDiscount.isEmpty()){	
				shohinWrapper.userDiscounts = lstUserDiscount;
			}					
			// partnerChargeDiscounts
			List<PartnerChargeDiscount> lstPartnerChargeDiscount = new List<PartnerChargeDiscount>();
			String myKey = opp.Id + '_' + item.Product2.Id;
			system.debug('**opp.Id='+opp.Id);
			system.debug('**item.Product2.Id='+item.Product2.Id);
			system.debug('**mapPatnerUriage='+mapPatnerUriage);
			if(mapPatnerUriage.containsKey(myKey)){
				for(PatnerUriage__c itemPatnerUriage : mapPatnerUriage.get(myKey)){
					PartnerChargeDiscount tempPartnerChargeDiscount = new PartnerChargeDiscount();
					if(itemPatnerUriage.Kingaku__c != null){
						tempPartnerChargeDiscount.rebateAmount = String.valueOf(itemPatnerUriage.Kingaku__c);
					}
					lstPartnerChargeDiscount.add(tempPartnerChargeDiscount);
				}
			}
			
			if(!lstPartnerChargeDiscount.isEmpty()){
				shohinWrapper.partnerChargeDiscounts =lstPartnerChargeDiscount;
			}
			lstShohinWrapper.add(shohinWrapper);
		}
		myOpportunityWrapper.items = lstShohinWrapper;		

		//生前契約の場合
		if (opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku')){
			Payment2Wrapper tempPayment2=new Payment2Wrapper();
			if(mapOkyakusamaSeikyuMeisai.containsKey(opp.id)){
				for (OkyakusamaSeikyuMeisai__c itemOkyakusamaSeikyuMeisai : mapOkyakusamaSeikyuMeisai.get(opp.id)){					
					PaymentWrapper itemPaymentWrapper=new PaymentWrapper();
					itemPaymentWrapper.paymentMasterId='1';//itemOkyakusamaSeikyuMeisai.SeikyuHohoCode__c;					
					itemPaymentWrapper.paymentDate=formatDate(itemOkyakusamaSeikyuMeisai.Kessaibi__c);
					if(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c != null){
						itemPaymentWrapper.payment = String.valueOf(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c);
					}	
					tempPayment2.deposit=itemPaymentWrapper;	
				}
			}		
			myOpportunityWrapper.payment=tempPayment2;
		}else{
		//通常契約の場合
			Payment1Wrapper tempPayment1=new Payment1Wrapper();
			if(mapOkyakusamaSeikyuMeisai.containsKey(opp.id)){
				List<PaymentWrapper> lstPayment = new List<PaymentWrapper>();
				for (OkyakusamaSeikyuMeisai__c itemOkyakusamaSeikyuMeisai : mapOkyakusamaSeikyuMeisai.get(opp.id)){	
					PaymentWrapper itemPaymentWrapper=new PaymentWrapper();
					itemPaymentWrapper.paymentMasterId='1';//itemOkyakusamaSeikyuMeisai.SeikyuHohoCode__c;
                    itemPaymentWrapper.paymentDate=formatDate(itemOkyakusamaSeikyuMeisai.Kessaibi__c);
					if(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c != null){
						itemPaymentWrapper.payment = String.valueOf(itemOkyakusamaSeikyuMeisai.SeikyuKingaku__c);
					}
					lstPayment.add(itemPaymentWrapper);
				}
				tempPayment1.payments=lstPayment;
			}
			myOpportunityWrapper.payment=tempPayment1;
		}
		return JSON.serializePretty(myOpportunityWrapper);
    }	*/
    /////*******************************************************************テスト用******************************************************************//	
}