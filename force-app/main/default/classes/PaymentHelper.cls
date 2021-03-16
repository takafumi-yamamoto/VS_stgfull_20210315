public class PaymentHelper {


    // /**
    // * 新規お客様請求明細画面用データ
    // * サービス商談IDを指定して、関するデータを取得する
    // */
    // public class OpportunityTree {
    //     public Id currentServiceOppId;
    //     public Id torihikiShodanId;
    //     public Account account;
    //     public String accountMail;
    //     public Boolean isWebAccount;
    //     public Boolean sokujiUriage;
    //     public Set<Id> serviceOppIds;
    //     public List<Opportunity> opportunities = new List<Opportunity>();


    //     public OpportunityTree(){
    //     }

    //     public OpportunityTree(String currentServiceOppId){
    //         this.currentServiceOppId = currentServiceOppId;
    //         initOppIds(this.currentServiceOppId);
    //     }

    //     private void initOppIds(String serviceOppId){
    //         Set<Id> ids = new Set<Id>();
    //         List<Opportunity> opps = [Select Id, TorihikiShodanRef__c, Account.Id, Account.TorihikisakiBango__c, Account.Name, Account.YusenMailAddressFormula__c, Account.YusenTelNoFormula__c, RecordType.DeveloperName From Opportunity where Id = :serviceOppId];

    //         if(opps != null && opps.size() > 0){
    //             Opportunity serviceOpp = opps[0];
    //             this.torihikiShodanId = serviceOpp.TorihikiShodanRef__c;
    //             this.account = serviceOpp.Account;
    //             this.sokujiUriage = serviceOpp.RecordType.DeveloperName == 'Obosanbin';
    //             // TODO　条件追加
    //             Opportunity oppTree = [Select Id, Name, Amount,
    //                                       (Select Id, Name, Amount From OpportunitysTorihikiShodan__r)
    //                                       From Opportunity where Id = :torihikiShodanId];

    //             for(Opportunity opp : oppTree.OpportunitysTorihikiShodan__r){
    //                 if(String.isNotBlank(opp.Id)){
    //                     ids.add(opp.Id);
    //                     opportunities.add(opp);
    //                 }
    //             }
    //             setAccountMail(this.account);
    //         }
    //         this.serviceOppIds = ids;
    //     }

    //     private void setAccountMail(Account acc){
    //         List<WebAccount__c> webAccountList = Dao_WebAccount.GetInstance().getWebAccountByAccountIds(new List<String>{acc.Id});
    //         if(webAccountList != null && webAccountList.size()>0){
    //             this.isWebAccount = true;
    //             if(webAccountList[0].NinshoHouhou__c == 'メールアドレス' && String.isNotBlank(webAccountList[0].TourokuChi__c)){
    //                 this.accountMail = webAccountList[0].TourokuChi__c;
    //             } else {
    //                 this.accountMail = Account.YusenMailAddressFormula__c;
    //             }
    //         }else{
    //             this.isWebAccount = false;
    //             this.accountMail = Account.YusenMailAddressFormula__c;
    //         }
    //     }


    // }

    // //コアと連携
    // public class CoreSeikyusRequest {
    // 	public Boolean isSuccess;
    // 	public Map<String, Object> responseData;

    //     //決済情報受付（FromSF）
    // 	public string sendSeikyu(SeikyusyoSakuseiBean bean){
    //         PaymentHelper.CoreSeikiyusyouBuilder builder = new PaymentHelper.CoreSeikiyusyouBuilder(bean);

    // 		String url = RsCoreApi_Configs.getConfig().Endpoint__c + '/payments/seikyuBango/' + bean.seikyusyoBango;
    // 		String requestParams = builder.getKessaiInfoJsonStr();
    // 		System.debug(url);
    // 		RsCoreApi_PaymentClient client = new RsCoreApi_PaymentClient(url, requestParams);
    		
    //         RsCoreApi_Util.doPut(client);
    //         this.isSuccess = client.getIsSuccess();

    //         Loggings.Level level = this.isSuccess ? Loggings.Level.Info : Loggings.Level.Error;
    //         Loggings.writeLog(
    //            Loggings.createLogEntry(level, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'CoreKessai.PaymentHelper.CoreSeikyusRequest', '決済請求書作成コア連携')
    //                .putAttr('params', builder.getKessaiInfoJsonStr())
    //                .putAttr('ResponseCode', client.code + '')
    //                .putAttr('ResponseMsg', client.result)
    //                .putAttr('IsSuccess', this.isSuccess + '')
    //                .putAttr('Description', '決済請求書作成コア連携-決済情報受付（FromSF）sendSeikyu')
    //         );


    // 		if(this.isSuccess){
    // 			new SeikyusyoSakuseiDao().saveSeikyusyo(bean);
    // 		}

    //         // set response
    //         responseData = new Map<String, Object>();
    //         responseData.put('ResponseCode' , client.code);
    //         responseData.put('ResponseMsg' , client.result);
    //         responseData.put('isSuccess' , this.isSuccess);
    //         if(!this.isSuccess){
    //             responseData.put('ResponseMsg' , client.getCoreErrorMsg());
    //             responseData.put('seikyusyoBango' , bean.seikyusyoBango);
    //         }

    //         return JSON.serialize(responseData);

    // 	}
    // }

    // //請求書作成、DB保存
    // public class SeikyusyoSakuseiDao {
    //     public OkyakusamaSeikyuMeisai__c torihikisyoudanSeikyu;
    //     public List<OkyakusamaSeikyuMeisai__c> seikyuList;

    //     public void saveSeikyusyo(SeikyusyoSakuseiBean bean) {

    //         Savepoint sp = Database.setSavepoint();
    //         try {
    //             torihikisyoudanSeikyu = new OkyakusamaSeikyuMeisai__c();
    //             seikyuList = new List<OkyakusamaSeikyuMeisai__c>();

    //             //取引商談の請求書
    //             torihikisyoudanSeikyu.OpportunityRef__c = bean.torihikiShodanId;    // 商談
    //             torihikisyoudanSeikyu.SeikyuHouhou__c = bean.seikyuHouhou;    // 請求方法
    //             torihikisyoudanSeikyu.SeikyuKingaku__c = bean.totalAmount;    // 請求金額
    //             torihikisyoudanSeikyu.SeikyuBango__c = bean.seikyusyoBango;    // 請求番号
    //             torihikisyoudanSeikyu.SeikyuStatus__c = '決済待ち';    // 請求ステータス
    //             torihikisyoudanSeikyu.seikyusaki__c = bean.getSeikyusaki();   //請求先
    //             torihikisyoudanSeikyu.seikyusakiMail__c = bean.getSeikyusakiMail();    // 請求先メールアドレス
    //             torihikisyoudanSeikyu.SeikyuJiTorihikiSakiRef__c = bean.account.Id;    //   請求時取引先
    //             torihikisyoudanSeikyu.sokujiUriage__c = bean.sokujiUriage;    //   取引先と別の請求先への請求
    //             insert torihikisyoudanSeikyu;

    //             List<Opportunity> opportunities = bean.getSelOpportunity();
    //             for (Opportunity opp : opportunities) {

    //                 OkyakusamaSeikyuMeisai__c serviceOppSeikyu = new OkyakusamaSeikyuMeisai__c();
    //                 serviceOppSeikyu.OpportunityRef__c = opp.Id;    // 商談
    //                 serviceOppSeikyu.SeikyuHouhou__c = bean.seikyuHouhou;    // 請求方法
    //                 serviceOppSeikyu.SeikyuKingaku__c = opp.Amount;    // 請求金額
    //                 serviceOppSeikyu.SeikyuOya__c = torihikisyoudanSeikyu.Id;    // 請求親 
    //                 serviceOppSeikyu.SeikyuBango__c = bean.seikyusyoBango;    // 請求番号
    //                 serviceOppSeikyu.SeikyuStatus__c = '決済待ち';    // 請求ステータス
    //                 serviceOppSeikyu.seikyusaki__c = bean.getSeikyusaki();   //請求先
    //                 serviceOppSeikyu.seikyusakiMail__c = bean.getSeikyusakiMail();    // 請求先メールアドレス
    //                 serviceOppSeikyu.SeikyuJiTorihikiSakiRef__c = bean.account.Id;    //   請求時取引先
    //                 serviceOppSeikyu.sokujiUriage__c = bean.sokujiUriage;    //   取引先と別の請求先への請求
    //                 seikyuList.add(serviceOppSeikyu);
    //             }
    //             insert seikyuList;

    //             insert getSeikyuHinmoku(torihikisyoudanSeikyu, opportunities);

    //         }
    //         catch (Exception ex) {
    //             Database.rollback(sp);
    //             Loggings.Level level = Loggings.Level.Error;
    //             Loggings.writeLog(
    //                Loggings.createLogEntry(level, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'CoreKessai.SeikyusyoSakuseiDao', '決済請求書作成Daoエラー')
    //                    .putAttr('seikyusyoBango', bean.seikyusyoBango)
    //                    .putAttr('Exception', ex.getMessage())
    //                    .putAttr('Description', '決済請求書作成Daoエラー')
    //             );
    //             throw new SeikyusyoSakuseiException(ex.getMessage());
    //         }
    //     }

    //     /**
    //     * 請求品目を作成
    //     */
    //     private List<SeikyuHinmoku__c> getSeikyuHinmoku(OkyakusamaSeikyuMeisai__c torihikisyoudanSeikyu, List<Opportunity> opportunities){
    //         List<SeikyuHinmoku__c> seikyuHinmokuList = new List<SeikyuHinmoku__c>();

    //         for (Opportunity opp : opportunities) {
    //             String name = opp.RecordType.DeveloperName == 'Obosanbin' ? 'お坊さん便　商談ID:' + opp.ShodanBangoF__c :
    //                                     opp.RecordType.DeveloperName == 'SimpleYasugo' ? 'シンプルなお葬式　商談ID:' + opp.ShodanBangoF__c : 'UNKNOW_TYPE　商談ID:' + opp.ShodanBangoF__c ;

    //             SeikyuHinmoku__c seikyuHinmoku = new SeikyuHinmoku__c();
    //             seikyuHinmoku.OkyakusamaSeikyuMeisaiRef__c = torihikisyoudanSeikyu.Id;
    //             seikyuHinmoku.Hinmokumei__c = name;
    //             seikyuHinmoku.Quantity__c = 1;
    //             seikyuHinmoku.Kingaku__c = opp.Amount;
    //             // seikyuHinmoku.Product2Ref__c = item.Product2Id;
    //             // seikyuHinmoku.OpportunityLineItem__c = item.Id;
    //             seikyuHinmoku.Syubetu__c = '商品';
                
    //             seikyuHinmokuList.add(seikyuHinmoku);
    //         }

    //         return seikyuHinmokuList;
    //     }

    // }

    // /**
    // * 請求書作成のとき、コアと連携用パラメータ作成クラス
    // * https://docs.google.com/spreadsheets/d/1kGhc2WrqL-nLGK2tbs8WNAzd6FDuBdQH2R-wO_gC5Ww/edit#gid=1127271577
    // */
    // public class CoreSeikiyusyouBuilder {
    //     SeikyusyoSakuseiBean seikyusyoSakuseiBean;
    //     List<Opportunity> opportunities = new List<Opportunity>();
        
    //     public CoreSeikiyusyouBuilder(SeikyusyoSakuseiBean seikyusyoSakuseiBean){
    //         this.seikyusyoSakuseiBean = seikyusyoSakuseiBean;
    //         this.opportunities = this.seikyusyoSakuseiBean.getSelOpportunity();
    //     }

    //     public String getKessaiInfoJsonStr(){
    //         Map<string, Object> info = getKessaiInfo();
    //         JSONGenerator gen = JSON.createGenerator(false);   
    //         gen.writeObject(info);
    //         return gen.getAsString();
    //     }

    //     public String getKessaiInfoPrettyJson(){
    //         Map<string, Object> info = getKessaiInfo();
	//     	return JSON.serializePretty(info);
    //     }

    //     public Map<string, Object> getKessaiInfo(){
    //         Map<string, Object> params = new Map<string, Object>();
    //         params.put('seikyuBango', seikyusyoSakuseiBean.seikyusyoBango);
    //         params.put('torihikisakiBango', seikyusyoSakuseiBean.torihikisakiBango);
    //         params.put('paymentMethod', seikyusyoSakuseiBean.getSeikyuHouhou());
    //         params.put('sokujiUriage', seikyusyoSakuseiBean.sokujiUriage);
    //         params.put('totalAmount', seikyusyoSakuseiBean.totalAmount);
    //         params.put('services', this.getServices());
    //         params.put('title', 'よりそうのお葬式');   //シンプルなお葬式

    //         Seikyusaki seikyusaki = new Seikyusaki();
    //         if(seikyusyoSakuseiBean.seikyusakiType == 'SMS') {
    //             seikyusaki.sms = seikyusyoSakuseiBean.seikyusakiPhone;
    //         } else {
    //             seikyusaki.mailAddress = seikyusyoSakuseiBean.seikyusakiMail;
    //         }
    //         seikyusaki.name = seikyusyoSakuseiBean.seikyusaki;
    //         params.put('seikyusaki', seikyusaki);

    //         //画面に表示する商品名（まとめたやつ）    
    //         // "よりそうのお葬式"、"お坊さん便"、"パック商品"、等

    //         return params;
    //     }

    //     private Boolean hasNotWebAccount(Account acc){
    //         List<WebAccount__c> webAccountList = Dao_WebAccount.GetInstance().getWebAccountByAccountIds(new List<String>{acc.Id});
    //         return webAccountList.size() <= 0;
    //     }

    //     private List<Service> getServices(){
    //         List<Service> services = new List<Service>();
    //         Map<String, List<Opportunity>> itemMap = this.getSelOpportunityMap();
    //         if(itemMap != null){
    //             for(String recordType : itemMap.keySet()){
    //                 List<Opportunity> opps = itemMap.get(recordType);
    //                 if(opps != null && opps.size()>0){

    //                     Service service = new Service();
    //                     service.serviceName = getServiceName(recordType);
    //                     service.totalAmount = 0;
    //                     for(Opportunity opp : opps){
    //                         service.totalAmount += this.getAmount(opp.Amount);
    //                     }

    //                     service.items = this.getServiceItems(opps);
    //                     services.add(service);
    //                 }
    //             }
    //         }
    //         return services;
    //     }

    //     private Map<String, List<Opportunity>> getSelOpportunityMap(){
    //         Map<String, List<Opportunity>> opportunityMap = new Map<String, List<Opportunity>>();
    //         for(Opportunity opp : this.opportunities){
    //             String recordType = opp.RecordType.DeveloperName;
    //             List<Opportunity> opps = opportunityMap.containskey(recordType) ? opportunityMap.get(recordType) : new List<Opportunity>();
    //             opps.add(opp);
    //             opportunityMap.put(recordType, opps);
    //         }
    //         return opportunityMap;
    //     }

    //     private String getServiceName(String developerName){
    //         Map<String, String> serviceNameMap = new Map<String,String>{
    //             'SimpleYasugo' => 'シンプルなお葬式',
    //             'Obosanbin' => 'お坊さん便'
    //         };

    //         return serviceNameMap.get(developerName);
    //     }

    //     private List<Item> getServiceItems(List<Opportunity> opps){
    //         List<Item> items = new List<Item>();
    //         if(opps != null && opps.size() > 0){
    //             for(Opportunity opp : opps){
    //                 String name = opp.RecordType.DeveloperName == 'Obosanbin' ? 'お坊さん便　お客様ID:' + opp.ShodanBangoF__c :
    //                                     opp.RecordType.DeveloperName == 'SimpleYasugo' ? 'シンプルなお葬式　お客様ID:' + opp.ShodanBangoF__c : '';

    //                 Item item = new Item();
    //                 item.type = '商品';
    //                 item.name = name;
    //                 item.price = this.getAmount(opp.Amount);
    //                 items.add(item);
    //             }
    //         }
    //         return items;
    //     }

    //     private Integer getAmount(Decimal amount){
    //         if(amount == null) return null;
    //         return Integer.valueOf(amount);
    //     }
    // }



    // ////////////////////////////////////////
    // // SF画面用：　請求書作成画面からのパラメータ
    // //
    // public class SeikyusyoSakuseiBean {
    //     public String recordId;
    //     public String torihikiShodanId;
    //     //public Date kessaibi;
    //     //public Date nyukinSimekiriBi;

    //     public Integer totalAmount;
    //     public List<String> selectIds;
    //     public String seikyuHouhou;

    //     public String seikyusyoBango;
    //     public String torihikisakiBango;
    //     public String seikyusaki; // 請求先
    //     public String seikyusakiMail;    // 請求先メールアドレス
    //     public String seikyusakiPhone;    // 請求先電話番号
    //     public String seikyusakitype;    // 請求先電話番号

    //     public Boolean sokujiUriage;   

    //     public Account account;

    //     public List<String> validation;

    //     //請求先名を取得
    //     public String getSeikyusaki(){
    //         if(account == null)
    //             return seikyusaki;
    //         return String.isBlank(seikyusaki) ? account.Name : seikyusaki;
    //     }

    //     //請求先メールアドレス
    //     public String getSeikyusakiMail(){
    //         if(account == null)
    //             return seikyusakiMail;
    //         return String.isBlank(seikyusakiMail) ? account.YusenMailAddressFormula__c : seikyusakiMail;
    //     }

    //     //請求方法
    //     public String getSeikyuHouhou(){
    //         if(seikyuHouhou == 'gmo_credit'){
    //             return 'カード（GMOPG）';
    //         }
    //         return seikyuHouhou;
    //     }


    //     public List<Opportunity> getSelOpportunity(){
    //         List<Opportunity> selItems = new List<Opportunity>();
    //         if(this.selectIds == null){
    //             return selItems;
    //         }

    //         List<Opportunity> opportunities = [Select Id, TorihikiShodanRef__c, Name, 
    //                                                     Account.Id, Account.TorihikisakiBango__c, Account.Name, Account.YusenMailAddressFormula__c ,
    //                                                     Amount, ShodanBangoF__c,
    //                                                     RecordType.DeveloperName
    //                                             From Opportunity where Id = :selectIds];
    //         Map<String, Opportunity> oppsMap = new Map<String, Opportunity>();
    //         for(Opportunity opp : opportunities) {
    //              oppsMap.put(opp.Id, opp);
    //         }

    //         for(String aId : this.selectIds){
    //             if(oppsMap.containskey(aId)){
    //                 selItems.add(oppsMap.get(aId));
    //             }
    //         }
    //         return selItems;
    //     }

    // }


    // ////////////////////////////////////////
    // // 決済情報受付 : コアと連携用パラメータ START
    // // https://docs.google.com/spreadsheets/d/1kGhc2WrqL-nLGK2tbs8WNAzd6FDuBdQH2R-wO_gC5Ww/edit#gid=1127271577
    // //
    // public class Item {
    //     public String type;
    //     public String name;
    //     public Integer price;
    // }

    // public class Service {
    //     public List<Item> items;
    //     public String serviceName;
    //     public Integer totalAmount;
    // }

    // public class Seikyusaki {
    //     public String mailAddress;
    //     public String name;
    //     public String sms;
    // }


    // // コアと連携用パラメータ END
    // ////////////////////////////////////////
   
    // public class SeikyusyoSakuseiException extends Exception {}
}

/**
決済情報受付 : コアと連携用パラメータ START
https://docs.google.com/spreadsheets/d/1kGhc2WrqL-nLGK2tbs8WNAzd6FDuBdQH2R-wO_gC5Ww/edit#gid=1127271577

*/