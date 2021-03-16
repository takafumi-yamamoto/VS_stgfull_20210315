public class Ctl_ShisetsuTransferService {}
// public class Ctl_ShisetsuTransferService {

// 	public string InsertOrUpdateFlag{get; set;}
	
// 	public class JSONTokenResponse {
//         public String token_type;
//         public String expires_in;
//         public String access_token;
//     }
	
// 	public class accessClass{
// 		public string accessTrain;
// 		public string accessBus;
// 		public string accessCar;
// 		public string accessOther;
// 	}
// 	public class saijoDataBean {
// 		//***共通***
// 		public id id;
// 		public String facilityKind;//
// 		public string areaCode;//エリアコード
// 		public string prefectureId;//県コード
// 		public decimal latitude;//緯度
// 		public decimal longitude;//経度
// 		public string name;//屋号
// 		public string nameHirakana;//屋号(ひらがな)
// 		public string tel1;//電話番号
// 		public string tel2;//電話番号
// 		public string fax1;//ファックス番号
// 		public string address;//住所
// 		public string addressHirakana;//住所かな
// 		public string zipCode;//郵便番号
// 		public string title;//
// 		public string description;//
// 		public integer parkingLots;//駐車場台数
// 		public integer isAnchi;//遺体安置可能フラグ
// 		public integer isShinzokuHikae;//控室有無フラグ
// 		public accessClass access;
// 		public integer simpleStatus;//
// 		public integer reviStatus;//
// 		public string facilityid;//施設番号
		
// 		//***斎場のみ***		
// 		public string scale;//一般葬、家族葬など
// 		public integer isZenShuha;//全宗派対応フラグ
// 		public integer isShowerRoom;//シャワールームフラグ
// 		public integer isStayRoom;//宿泊施設の有無フラグ
// 		public integer isBarrierFree;//バリアフリー対応フラグ
// 		public string closeDay;//休館日
// 		public string organiser;//
// 		public integer management;//一般葬、家族葬など
// 		public integer isAnchiMenkai;//
// 		public integer isSaijoTsukisoi;//
// 		public integer isKidsRoom;//
// 		public integer isBabyRoom;//	
// 		public integer isHoyo;//
// 		public integer planKaso;//
// 		public integer planOneDay;//
// 		public integer planKazoku;//
// 		public integer planIppan;//
// 	}
	
// 	public class kasobaDataBean {
// 		//***共通***
// 		public id id;
// 		public String facilityKind;//
// 		public string areaCode;//エリアコード
// 		public string prefectureId;//県コード
// 		public decimal latitude;//緯度
// 		public decimal longitude;//経度
// 		public string name;//屋号
// 		public string nameHirakana;//屋号(ひらがな)
// 		public string tel1;//電話番号
// 		public string tel2;//電話番号
// 		public string fax1;//ファックス番号
// 		public string address;//住所
// 		public string addressHirakana;//住所かな
// 		public string zipCode;//郵便番号
// 		public string title;//
// 		public string description;//
// 		public integer parkingLots;//駐車場台数
// 		public integer isAnchi;//遺体安置可能フラグ
// 		public integer isShinzokuHikae;//控室有無フラグ
// 		public accessClass access;
// 		public integer simpleStatus;//
// 		public integer reviStatus;//
// 		public string facilityid;//施設番号	
// 		//***火葬場のみ***		
// 		public integer isSaijoHeisetsu;//併設斎場フラグ		
// 		public string anchiResidentPrice;//安置 市民価格
// 		public string anchiNonResidentPrice;//安置 Not 市民価格
// 		public string sinzokuHikaeResidentPrice;//控室 市民価格
// 		public string sinzokuHikaeNonResidentPrice;//控室 Not 市民価格
// 	}	
// 	map<id,Shisetsu__c> shisetsuMap=new  map<id,Shisetsu__c>();
// 	list<saijoDataBean> saijoDataBeanLst =new list<saijoDataBean>();
// 	list<kasobaDataBean> kasobaDataBeanLst =new list<kasobaDataBean>();
	
// 	public void requestTransfer(List<Shisetsu__c> shisetsuLst){
// 		system.debug('***Ctl_ShisetsuTransferService.requestTransfer.begin***');   
// 		shisetsuMap.putAll(shisetsuLst);
// 		//緯度と経度の算出
// 		system.debug('****before.shisetsuLst='+shisetsuLst);
// 		Com_LatitudeAndLongitude.CovertLocationToLatitudeAndLongitude2(Shisetsu__c.getSObjectType().getDescribe().getName(),shisetsuLst);	
// 		system.debug('****after.shisetsuLst='+shisetsuLst);	
// 		getTransferList(shisetsuLst);
// 		sendRequest();
// 		system.debug('***Ctl_ShisetsuTransferService.requestTransfer.end***');  
// 	}
	
// 	public void getTransferList(List<Shisetsu__c> shisetsuLst){
// 		system.debug('***Ctl_ShisetsuTransferService.getTransferList.begin***'); 
// 		for (Shisetsu__c shisetsu:shisetsuLst){
// 			//斎場
// 			if (shisetsu.ShisetsuShubetsu__c=='斎場'){
// 				saijoDataBean DataBean=CovertToSaijoDataBean(shisetsu);
// 				saijoDataBeanLst.add(DataBean);
// 			}else if (shisetsu.ShisetsuShubetsu__c=='火葬場'){
// 				kasobaDataBean DataBean=CovertToKasobaDataBean(shisetsu);
// 				kasobaDataBeanLst.add(DataBean);
// 			}else if (shisetsu.ShisetsuShubetsu__c=='併設'){
// 				if (shisetsu.SaijoShoriStatus__c=='連携中'){
// 					saijoDataBean DataBean1=CovertToSaijoDataBean(shisetsu);
// 				    saijoDataBeanLst.add(DataBean1);
// 				}
// 				if (shisetsu.KasobaShoriStatus__c=='連携中'){
// 				    kasobaDataBean DataBean2=CovertToKasobaDataBean(shisetsu);
// 				    kasobaDataBeanLst.add(DataBean2);
// 				}
// 			}else{
// 				//処理しない
// 			}			
// 		}	
// 		system.debug('***Ctl_ShisetsuTransferService.getTransferList.end***'); 	
// 	}

// 	public saijoDataBean CovertToSaijoDataBean(Shisetsu__c shisetsu){
// 		system.debug('***Ctl_ShisetsuTransferService.CovertToSaijoDataBean.begin***'); 
// 		saijoDataBean bean = new saijoDataBean();
// 		bean.id=shisetsu.id;
// 		bean.facilityKind='saijo';
// 		//エリアコード
// 		bean.areaCode=shisetsu.AreaCode__c;
// 		//県コード
// 		bean.prefectureId=shisetsu.Shikugun__r.TodoufuKenRef__r.KenCode__c;
// 		//緯度
// 		bean.latitude=shisetsu.IdoKedo__latitude__s;
// 		//経度
// 		bean.longitude=shisetsu.IdoKedo__longitude__s;
// 		//屋号
// 		bean.name=shisetsu.name;		
// 		//屋号(ひらがな)
// 		bean.nameHirakana=shisetsu.ShisetsumeiFurigana__c;
// 		//電話番号		
// 		bean.tel1=shisetsu.Phone1__c;
// 		//電話番号		
// 		bean.tel2=shisetsu.Phone2__C;
// 		//ファックス番号		
// 		bean.fax1=shisetsu.Fax__c;		
// 		//住所		
// 		bean.address=shisetsu.Jusho__c;		
// 		//住所かな		
// 		bean.addressHirakana=shisetsu.AddressFurigana__c;
// 		//郵便番号
// 		bean.zipCode=shisetsu.PostalCode__c;
// 		//
// 		bean.title=shisetsu.TitleSaijo__c;
// 		//
// 		bean.description=shisetsu.TokuchoSaijo__c;	
// 		//駐車場台数	
// 		if (shisetsu.Chushadaisu__c!=null){
// 			bean.parkingLots=(integer)shisetsu.Chushadaisu__c;
// 		}
			
// 		//遺体安置可能フラグ	
// 		if (shisetsu.Anchika__c){
// 			bean.isAnchi=1;
// 		}else{
// 			bean.isAnchi=0;
// 		}	
// 		//控室有無フラグ
// 		if (shisetsu.ShinzokuHikaeshitsuAri__c){
// 			bean.isShinzokuHikae=1;
// 		}else{
// 			bean.isShinzokuHikae=0;
// 		}
// 		accessClass access=new accessClass();
// 		access.accessTrain = shisetsu.AccessHouhouDensha__c;
// 		access.accessBus=shisetsu.AccessHohoBasu__c;
// 		access.accessCar=shisetsu.AccessHohoKuruma__c;
// 		access.accessOther=shisetsu.AccessHohoSonota__c;
// 		bean.access=access;
// 		//シンプル掲載
// 		if (shisetsu.SimpleKeisai__c){
// 			bean.simpleStatus=1;
// 		}else{
// 			bean.simpleStatus=0;
// 		}
//         //葬儀レビ掲載
//         if (shisetsu.SogiRebiKeisai__c){
//         	bean.reviStatus=1;
//         }else{
//         	bean.reviStatus=0;
//         }
// 		//一般葬、家族葬など
// 		bean.scale=shisetsu.Scale__c;
// 		//全宗派対応フラグ
// 		if (shisetsu.ZenShuhaTaioKa__c){
// 			bean.isZenShuha=1;
// 		}else{
// 			bean.isZenShuha=0;
// 		}
		
// 		//シャワールームフラグ
// 		if (shisetsu.ShawaRoomAri__c){
// 			bean.isShowerRoom=1;
// 		}else{
// 			bean.isShowerRoom=0;
// 		}

// 		//宿泊施設の有無フラグ
// 		if (shisetsu.ShukuhakuKa__c){
// 			bean.isStayRoom=1;
// 		}else{
// 			bean.isStayRoom=0;
// 		}
// 		//バリアフリー対応フラグ
// 		if (shisetsu.Bariafuri__c){
// 			bean.isBarrierFree=1;
// 		}else{
// 			bean.isBarrierFree=0;
// 		}
// 		//休館日
// 		bean.closeDay=shisetsu.CloseDay__c;
// 		bean.organiser=shisetsu.Organiser__c;	
// 		//一般葬、家族葬など	
// 		if (shisetsu.KoeiMinei__c=='公営'){
// 			bean.management=0;
// 		}else if (shisetsu.KoeiMinei__c=='民営'){
// 			bean.management=1;
// 		}else if (shisetsu.KoeiMinei__c=='自社'){
// 			//TODO：自社の場合は、何を設定？
// 		}else if (shisetsu.KoeiMinei__c=='寺院'){
// 			bean.management=2;
// 		}else{			
// 		}
// 		//安置面会可
// 		if (shisetsu.AnchiMenkaiKa__c){
// 			bean.isAnchiMenkai=1;
// 		}else{
// 			bean.isAnchiMenkai=0;
// 		}

// 		//付添安置可
// 		if (shisetsu.TsukisoiAnchiKa__c){
// 			bean.isSaijoTsukisoi=1;
// 		}else{
// 			bean.isSaijoTsukisoi=0;
// 		}
		
// 		//キッズルーム有
// 		if (shisetsu.KizzuRoomAri__c){
// 			bean.isKidsRoom=1;
// 		}else{
// 			bean.isKidsRoom=0;
// 		}
// 		//ベビールーム有
// 		if (shisetsu.BebiRoomAri__c){
// 			bean.isBabyRoom=1;
// 		}else{
// 			bean.isBabyRoom=0;
// 		}	
		
// 		//法要可
// 		if (shisetsu.HoyoKa__c){
// 			bean.isHoyo=1;
// 		}else{
// 			bean.isHoyo=0;
// 		}
// 		//火葬式可
// 		if (shisetsu.KasoshikiKa__c){
// 			bean.planKaso=1;
// 		}else{
// 			bean.planKaso=0;
// 		}
// 		//一日葬可
// 		if (shisetsu.IchinichisoKa__c){
// 			bean.planOneDay=1;
// 		}else{
// 			bean.planOneDay=0;
// 		}
// 		//家族葬可
// 		if (shisetsu.KazokusoKa__c){
// 			bean.planKazoku=1;
// 		}else{
// 			bean.planKazoku=0;
// 		}
// 		//一般葬可
// 		if (shisetsu.IppansoKa__c){
// 			bean.planIppan=1;
// 		}else{
// 			bean.planIppan=0;
// 		}	
// 		//施設番号
// 		bean.facilityid=shisetsu.ShisetsuBango__c;
// 		system.debug('***Ctl_ShisetsuTransferService.CovertToSaijoDataBean.end***'); 
// 		return bean;		
// 	}
// 	public kasobaDataBean CovertToKasobaDataBean(Shisetsu__c shisetsu){
// 		system.debug('***Ctl_ShisetsuTransferService.CovertToKasobaDataBean.begin***'); 
// 		kasobaDataBean bean = new kasobaDataBean();
// 		bean.id=shisetsu.id;
// 		bean.facilityKind='kasoba';
// 		//エリアコード
// 		bean.areaCode=shisetsu.AreaCode__c;
// 		//県コード
// 		bean.prefectureId=shisetsu.Shikugun__r.TodoufuKenRef__r.KenCode__c;
// 		//緯度
// 		bean.latitude=shisetsu.IdoKedo__latitude__s;
// 		//経度
// 		bean.longitude=shisetsu.IdoKedo__longitude__s;
// 		//屋号
// 		bean.name=shisetsu.name;		
// 		//屋号(ひらがな)
// 		bean.nameHirakana=shisetsu.ShisetsumeiFurigana__c;
// 		//電話番号		
// 		bean.tel1=shisetsu.Phone1__c;
// 		//電話番号		
// 		bean.tel2=shisetsu.Phone2__C;
// 		//ファックス番号		
// 		bean.fax1=shisetsu.Fax__c;		
// 		//住所		
// 		bean.address=shisetsu.Jusho__c;		
// 		//住所かな		
// 		bean.addressHirakana=shisetsu.AddressFurigana__c;
// 		//郵便番号
// 		bean.zipCode=shisetsu.PostalCode__c;
// 		//
// 		bean.title=shisetsu.TitleKasoba__c;
// 		//
// 		bean.description=shisetsu.TokuchoKasoba__c;	
// 		//駐車場台数	
// 		if (shisetsu.Chushadaisu__c!=null){
// 			bean.parkingLots=(integer)shisetsu.Chushadaisu__c;
// 		}
// 		//遺体安置可能フラグ	
// 		if (shisetsu.Anchika__c){
// 			bean.isAnchi=1;
// 		}else{
// 			bean.isAnchi=0;
// 		}	
// 		//控室有無フラグ
// 		if (shisetsu.ShinzokuHikaeshitsuAri__c){
// 			bean.isShinzokuHikae=1;
// 		}else{
// 			bean.isShinzokuHikae=0;
// 		}
// 		accessClass access=new accessClass();
// 		access.accessTrain = shisetsu.AccessHouhouDensha__c;
// 		access.accessBus=shisetsu.AccessHohoBasu__c;
// 		access.accessCar=shisetsu.AccessHohoKuruma__c;
// 		access.accessOther=shisetsu.AccessHohoSonota__c;
// 		bean.access=access;
		
// 		//シンプル掲載
// 		if (shisetsu.SimpleKeisai__c){
// 			bean.simpleStatus=1;
// 		}else{
// 			bean.simpleStatus=0;
// 		}
//         //葬儀レビ掲載
//         if (shisetsu.SogiRebiKeisai__c){
//         	bean.reviStatus=1;
//         }else{
//         	bean.reviStatus=0;
//         }
		
// 		//併設斎場フラグ
// 		if (shisetsu.ShisetsuShubetsu__c=='併設'){
// 			bean.isSaijoHeisetsu=1;
// 		}else{
// 			bean.isSaijoHeisetsu=0;
// 		}
// 		//安置 市民価格
// 		bean.anchiResidentPrice=shisetsu.AnchiResidentPrice__c;
// 		//安置 Not 市民価格
// 		bean.anchiNonResidentPrice=shisetsu.AnchiNonResidentPrice__c;
// 		//控室 市民価格
// 		bean.sinzokuHikaeResidentPrice=shisetsu.ShinzokuHikaeResidentPrice__c;
// 		//控室 Not 市民価格
// 		bean.sinzokuHikaeNonResidentPrice=shisetsu.ShinzokuHikaeNonResidentPrice__c;
// 		//施設番号
// 		bean.facilityid=shisetsu.ShisetsuBango__c;				
// 		system.debug('***Ctl_ShisetsuTransferService.CovertToKasobaDataBean.end***'); 
		
// 		return bean;		
// 	}	
// 	private void sendRequest(){
// 		system.debug('***Ctl_ShisetsuTransferService.sendRequest.begin***'); 
// 		HttpResponse res;
//         set<Shisetsu__c> retrySet = new set<Shisetsu__c>();
//         map<id,Shisetsu__c> updateShisetsuMap = new map<id,Shisetsu__c>();       
//         system.debug('===saijoDataBeanLst=='+saijoDataBeanLst); 
        
//         //斎場処理
//         for (saijoDataBean data:saijoDataBeanLst){
//         	Shisetsu__c shisetsu=ShisetsuMap.get(data.id);
//         	Shisetsu__c updateShisetsu=new Shisetsu__c();
        	
//         	//更新リストに入れなければ入れる
//         	if (updateShisetsuMap.get(data.id)==null){
//         		updateShisetsu=shisetsu;
//         		updateShisetsuMap.put(data.id,updateShisetsu);
//         	}else{
//         		updateShisetsu=updateShisetsuMap.get(data.id);
//         	}
        	
//         	string jsonBody=json.serialize(data);
//         	system.debug('===斎場jsonBody=='+jsonBody);
//         	try{
// 	        	if (InsertOrUpdateFlag=='Insert'){
// 	        		res = callOutInsert(jsonBody);
// 	        	}else{
// 	        		res = callOutUpdate(jsonBody,data.facilityid);
// 	        	}
// 	        	system.debug('===res1=='+res);
// 	        	//成功
// 	        	if (res.getStatusCode()==200){        		
// 	        		//斎場用処理ステータス
// 	        		updateShisetsu.SaijoShoriStatus__c='連携済';
// 	                //処理ステータス備考
// 	                updateShisetsu.ShoriStatusBiko__c='連携が成功しました！'; 
// 	        	}else{
// 	            //失敗
// 	                if (isRetry(updateShisetsu)){
// 		         		//斎場用処理ステータス
// 		        		updateShisetsu.SaijoShoriStatus__c='連携中';
// 	                    //処理ステータス備考
// 		                updateShisetsu.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
// 		                //リトライ回数
// 		                setTryCount(updateShisetsu);		                             	
// 	                }else{
// 		         		//斎場用処理ステータス
// 		        		updateShisetsu.SaijoShoriStatus__c='エラー';
// 	                    //処理ステータス備考
// 		                updateShisetsu.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
// 		                //連携回数をリセット
// 		                updateShisetsu.TryCount__c=0;		                              	
// 	                }
// 	        	}        		
//         	}catch(exception e){
// 				//斎場用処理ステータス
//         		updateShisetsu.SaijoShoriStatus__c='エラー';
//                 //処理ステータス備考
//                 updateShisetsu.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
//                 //連携回数をリセット
//                 updateShisetsu.TryCount__c=0;		
//         	}

//         }
//         system.debug('===kasobaDataBeanLst=='+kasobaDataBeanLst); 
//         //火葬場処理
//         for (kasobaDataBean data:kasobaDataBeanLst){
//         	Shisetsu__c shisetsu=ShisetsuMap.get(data.id);
//         	Shisetsu__c updateShisetsu=new Shisetsu__c();
        	
//         	//更新リストに入れなければ入れる
//         	if (updateShisetsuMap.get(data.id)==null){
//         		updateShisetsu=shisetsu;
//         		updateShisetsuMap.put(data.id,updateShisetsu);
//         	}else{
//         		updateShisetsu=updateShisetsuMap.get(data.id);
//         	}
//         	updateShisetsu.IdoKedo__latitude__s=shisetsu.IdoKedo__latitude__s;
//         	updateShisetsu.IdoKedo__longitude__s=shisetsu.IdoKedo__longitude__s;
//         	string jsonBody=json.serialize(data);
//         	system.debug('===火葬場jsonBody=='+jsonBody);
//         	try{
// 	        	if (InsertOrUpdateFlag=='Insert'){
// 	        		res = callOutInsert(jsonBody);
// 	        	}else{
// 	        		res = callOutUpdate(jsonBody,data.facilityid);
// 	        	}        	
// 	        	system.debug('===res2=='+res);
// 	        	//成功
// 	        	if (res.getStatusCode()==200){        		
// 	        		//火葬場用処理ステータス
// 	        		updateShisetsu.KasobaShoriStatus__c='連携済';
// 	                //処理ステータス備考
// 	                updateShisetsu.ShoriStatusBiko__c='連携が成功しました！'; 
// 	        	}else{
// 	            //失敗
// 	                if (isRetry(updateShisetsu)){
// 		         		//斎場用処理ステータス
// 		        		updateShisetsu.KasobaShoriStatus__c='連携中';
// 	                    //処理ステータス備考
// 		                updateShisetsu.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
// 		                //リトライ回数
// 		                setTryCount(updateShisetsu);		                             	
// 	                }else{
// 		         		//火葬場用処理ステータス
// 		        		updateShisetsu.KasobaShoriStatus__c='エラー';
// 	                    //処理ステータス備考
// 		                updateShisetsu.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
// 		                //連携回数をリセット
// 		                updateShisetsu.TryCount__c=0;		                
// 	                }
// 	        	}        		
//         	}catch(exception e){
//          		//火葬場用処理ステータス
//         		updateShisetsu.KasobaShoriStatus__c='エラー';
//                 //処理ステータス備考
//                 updateShisetsu.ShoriStatusBiko__c='連携中はエラーが発生しました、エラーコード：'+String.valueOf(res.getStatusCode());
//                 //連携回数をリセット
//                 updateShisetsu.TryCount__c=0;	
//         	}
//         } 
        
//         Savepoint sp = Database.setSavepoint();
        
//         list<Shisetsu__c> updateShisetsuLst=new list<Shisetsu__c>();
//         updateShisetsuLst.addAll(updateShisetsuMap.values());
    
//         try {
//             update updateShisetsuLst;
//         } catch(DMLException e) {
//             Database.rollback(sp);
//             System.debug('DMLException:' + e.getMessage());
//         } catch(Exception e) {
//             Database.rollback(sp);
//             System.debug('saveDto Exception:' + e.getMessage());
//         }
//         // join queue to retry
//         //list<Shisetsu__c> RetryList=new list<Shisetsu__c>();
//         //RetryList.addall(retrySet);
//         //retryRequest(RetryList);    
//         system.debug('***Ctl_ShisetsuTransferService.sendRequest.end***');
        
// 	}
//     private void setTryCount(Shisetsu__c shisetsu) {
//     	Decimal retryCount = shisetsu.TryCount__c == null ? 0 : shisetsu.TryCount__c;
//     	shisetsu.TryCount__c = retryCount + 1;
//     }	
//     private Boolean isRetry(Shisetsu__c shisetsu) {
//     	return (shisetsu.TryCount__c < shisetsu.TryLimit__c);
//     } 
//     /**
//     * リトライ
//     */
//     private void retryRequest(List<Shisetsu__c> shisetsuRetryList){
//     	// add to queue to run 
//     	if(shisetsuRetryList != null && shisetsuRetryList.size() > 0){
//     		Utility_Common.sleep(1000);
//     		new Ctl_Shisetsu().ShisetsuTransfer(shisetsuRetryList,InsertOrUpdateFlag);
//     	}
//     }
    
//      HttpResponse callOutInsert(string jsonBody){
//      	system.debug('***Ctl_ShisetsuTransferService.callOutInsert.begin***');
//      	HttpResponse response;
//      	if(Test.isRunningTest()){
//      		response = new HttpResponse();
//      		response.setStatusCode(200);
//      		return response;
//      	}       	
//     	string EndPointUrl=RsCoreApi_Configs.getConfig().EndPoint__c;
//     	System.debug('EndPointUrl' + EndPointUrl);    	
//     	EndPointUrl = EndPointUrl+'/manager/api/facility/add';    	
//     	HttpRequest request = new HttpRequest(); 
// 		request.setEndpoint(EndPointUrl);
// 		request.setMethod('POST');
// 		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
// 		RsCoreApi_AuthClients.getInstance().setAuthHeader(request);		
// 		request.setBody(jsonBody);  
//         request.setHeader('Content-length',string.valueOf(jsonBody.length()));
//         System.debug('-----test569-----' + request);
//         response = new http().send(request);
//         system.debug('*response='+response);
//         system.debug('***Ctl_ShisetsuTransferService.callOutInsert.end***');
// 		return response;				
//     }
//     private HttpResponse callOutUpdate(string jsonBody,string facilityId){
//     	system.debug('***Ctl_ShisetsuTransferService.callOutUpdate.begin***');
//     	HttpResponse response;
//      	if(Test.isRunningTest()){
//      		response = new HttpResponse();
//      		response.setStatusCode(200);
//      		return response;
//      	}    	
//      	string EndPointUrl=RsCoreApi_Configs.getConfig().EndPoint__c;    	
//     	EndPointUrl = EndPointUrl+'/manager/api/facility/'+facilityId;    	
//     	HttpRequest request = new HttpRequest(); 
// 		request.setEndpoint(EndPointUrl);
// 		request.setMethod('POST');
// 		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
// 		RsCoreApi_AuthClients.getInstance().setAuthHeader(request);		
// 		request.setBody(jsonBody);  
//         request.setHeader('Content-length',string.valueOf(jsonBody.length()));
//         response = new http().send(request);
//         system.debug('*response='+response);
//         system.debug('***Ctl_ShisetsuTransferService.callOutUpdate.end***');
// 		return response;
//     }
// }