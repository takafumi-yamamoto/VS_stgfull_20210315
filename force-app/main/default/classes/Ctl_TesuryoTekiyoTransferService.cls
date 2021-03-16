public class Ctl_TesuryoTekiyoTransferService {
	private class JsonWrapper{
		public list<KeiyakuWrapper> items {get; set;}
	}
    private class KeiyakuWrapper {
		//手数料適用ID
		public String commissionId {get; set;}
		//契約ID
		public String contractId {get; set;}
		//取引先ID
		public String partnerId {get; set;}
		//取引先名
		public String partnerName {get; set;}
		//対象サービス シンプル:1　特約店：20
		public String serviceId {get; set;}
		//0:無効（契約解除等) 1:有効
		public String validity {get; set;}
		//通常プランID（1,2,3…）　サービス共通で2018/04現在適用プランは1、シンプル旧手数料、お坊さん便旧手数料は2、シンプル旧旧手数料、お坊さん便八正会もんじゅ会は3
		public String planId {get; set;}
		//通常プランに対する手数料割引有無 手数料割引なしの場合：0　ある場合:契約IDを送信（契約ID=割引プランIDという構造）
		public String chargeDiscountPlanId {get; set;}
		//料理手数料課金有無　0:課金無し 1:通常課金 デフォルト1 ※5%以外は個別手動対応
		public String foodFee {get; set;}
		//返礼品課金有無　0:課金無し 1:通常課金 デフォルト1 ※10%以外は個別手動対応
		public String returnGoodsFee {get; set;}
		//骨壷手数料適用有無　0:無 1:有 デフォルト1
		public String urnOptionFee {get; set;}
		//よりそうオプション花一式手数料適用有無　0:無 1:有 デフォルト1
		public String yorisoOptionFlowersFee {get; set;}
		//その他オプション手数料課金有無　0:課金無し 1:通常課金 デフォルト1 ※10%以外は個別手動対応
		public String optionFee {get; set;}
		//クレカ決済+ローン手数料課金有無　0:課金無し 1:通常課金 デフォルト1 ※2.2%以外は個別手動対応
		public String cardOption {get; set;}
		//佐川コンビニ払い（後払い）手数料課金有無 0:課金無し 1:通常課金 デフォルト 1※5%以外は個別手動対応
		public String atobaraiOption {get; set;}
    	//適用開始日
    	public String startDate {get; set;}
    	//適用終了日
    	public String endDate {get; set;} 
    }

    public string getJsonBody(TesuryoTekiyo__c TesuryoTekiyo){
    	list<KeiyakuWrapper> KeiyakuWrapperLst=new list<KeiyakuWrapper>();
    	KeiyakuWrapper oKeiyakuWrapper=new KeiyakuWrapper();

		//手数料適用ID
		oKeiyakuWrapper.commissionId=TesuryoTekiyo.Name;
		//契約ID
		oKeiyakuWrapper.contractId=TesuryoTekiyo.KeiyakuRef__r.KeiyakuBango__c;
		//取引先ID
		oKeiyakuWrapper.partnerId=TesuryoTekiyo.KeiyakuRef__r.TeikesakiTorihikisakiBango__c;

		oKeiyakuWrapper.partnerName=TesuryoTekiyo.KeiyakuRef__r.Teikeisaki__r.name;
    	//契約.サービスID（数式）
    	oKeiyakuWrapper.serviceId=TesuryoTekiyo.KeiyakuRef__r.ServiceId__c;	
    	//契約有効
    	if (TesuryoTekiyo.ShoninStatus__c=='承認済'){
    		oKeiyakuWrapper.validity='1';
    	}else{
    		oKeiyakuWrapper.validity='0';
    	} 
		//通常プランID（1,2,3…）　サービス共通で2018/04現在適用プランは1、シンプル旧手数料、お坊さん便旧手数料は2、シンプル旧旧手数料、お坊さん便八正会もんじゅ会は3
        oKeiyakuWrapper.planId=string.valueof(TesuryoTekiyo.TesuryoPlanRef__r.CoreTesuryoPlanId__c);
    	//通常プランに対する手数料割引有無 手数料割引なしの場合：0　ある場合:契約IDを送信（契約ID=割引プランIDという構造）
    	list<TesuryoNebikiEntry__c> TesuryoNebikiEntryLst= TesuryoTekiyo.TesuryoTekiyo_TesuryoNebikiEntry__R;
    	if (TesuryoNebikiEntryLst.size()>0){
    		oKeiyakuWrapper.chargeDiscountPlanId=TesuryoTekiyo.KeiyakuRef__r.KeiyakuBango__c;
    	}else{
    		oKeiyakuWrapper.chargeDiscountPlanId='0';
    	}
		//料理手数料課金有無　0:課金無し 1:通常課金 デフォルト1 ※5%以外は個別手動対応
		if (TesuryoTekiyo.RyoriTesuryoAri__c){
			oKeiyakuWrapper.foodFee='1';
		}else{
			oKeiyakuWrapper.foodFee='0';
		}
		//返礼品課金有無　0:課金無し 1:通常課金 デフォルト1 ※10%以外は個別手動対応
		if (TesuryoTekiyo.HenreihinTesuryoAri__c){
			oKeiyakuWrapper.returnGoodsFee='1';
		}else{
			oKeiyakuWrapper.returnGoodsFee='0';
		}
		//骨壷手数料適用有無　0:無 1:有 デフォルト1
		if (TesuryoTekiyo.UrnOptionTesuryoFlg__c){
			oKeiyakuWrapper.urnOptionFee = '1';
		}else{
			oKeiyakuWrapper.urnOptionFee = '0';
		}
		//よりそうオプション花一式手数料適用有無　0:無 1:有 デフォルト1
		if (TesuryoTekiyo.YorisoOptionFlowersTesuryoFlg__c) {
			oKeiyakuWrapper.yorisoOptionFlowersFee = '1';
		} else {
			oKeiyakuWrapper.yorisoOptionFlowersFee = '0';
		}
		//その他オプション手数料課金有無　0:課金無し 1:通常課金 デフォルト1 ※10%以外は個別手動対応
		if (TesuryoTekiyo.OptionTesuryoAri__c){
			oKeiyakuWrapper.optionFee='1';
		}else{
			oKeiyakuWrapper.optionFee='0';
		}
		//クレカ決済+ローン手数料課金有無　0:課金無し 1:通常課金 デフォルト1 ※2.2%以外は個別手動対応
		if (TesuryoTekiyo.CardLoanTesuryoAri__c){
			oKeiyakuWrapper.cardOption='1';
		}else{
			oKeiyakuWrapper.cardOption='0';
		}
		//佐川コンビニ払い（後払い）手数料課金有無 0:課金無し 1:通常課金 デフォルト 1※5%以外は個別手動対応
		if (TesuryoTekiyo.AtobaraiTesuryoAri__c){
			oKeiyakuWrapper.atobaraiOption='1';
		}else{
			oKeiyakuWrapper.atobaraiOption='0';
		}

		//適用開始日
    	oKeiyakuWrapper.startDate=datetime.newInstance(TesuryoTekiyo.TekiyoKaishiBi__c.year(), TesuryoTekiyo.TekiyoKaishiBi__c.month(),TesuryoTekiyo.TekiyoKaishiBi__c.day()).format('yyyy/MM/dd HH:mm:ss');
    	//適用終了日
    	oKeiyakuWrapper.endDate=datetime.newInstance(TesuryoTekiyo.TekiyoSyuryoBi__c.year(), TesuryoTekiyo.TekiyoSyuryoBi__c.month(),TesuryoTekiyo.TekiyoSyuryoBi__c.day()).format('yyyy/MM/dd HH:mm:ss');
    	KeiyakuWrapperLst.add(oKeiyakuWrapper);    	
    	JsonWrapper oJsonJsonWrapper=new JsonWrapper();
    	oJsonJsonWrapper.items=KeiyakuWrapperLst;
    	
    	return JSON.serializePretty(oJsonJsonWrapper);
    }    
}