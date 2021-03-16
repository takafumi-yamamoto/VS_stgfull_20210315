public class SogiMitsumoriNyuryokuFormCtl {

	private String opportunityId;

	private Opportunity beforeOpportunity = new Opportunity();
	private SimpleYasugo__c beforeSimpleYasugo = new SimpleYasugo__c();
	private Account beforeSodansha = new Account();
	private Account beforeTaishosha = new Account();
	private Account beforeMoshu = new Account();
	private List<OpportunityLineItem> beforeOpportunityLineItems = new List<OpportunityLineItem>();

	//  issues4217--Start--
	private Keiyaku__c beforeKeiyaku = new Keiyaku__c();
	private TesuryoTekiyo__c beforeTesuryoTekiyo = new TesuryoTekiyo__c();
	//  issues4217--End--

	// issues4228--Start-- 商談商品について、ユーザが変更した商品のみを更新する対応
	private List<OptionItemWrap> beforeoptionItemWraps {get;set;}
	// issues4228--End--

	public Boolean nullAccountFlg {get;set;}
	public OpportunityWrap opportunityWrap {get;set;}
	public SodanshaWrap sodanshaWrap {get;set;}
	public TaishoshaWrap taishoshaWrap {get;set;}
	public MoshuWrap moshuWrap {get;set;}
	public PlanItemWrap planItemWrap {get;set;}
	public SogiItemWrap sogiItemWrap {get;set;}
	public NebikiWrap nebikiWrap {get;set;}
	public List<WaribikiSummary.WaribikiSummaryEntry> waribikiList {get;set;}

	public String mitsumorishoKisaiNebikiKingaku {get;set;}
	public String mitsumorishoKisaiMitsumoriKingaku {get;set;}
	public Decimal sfMitsumoriKingaku {get;set;}

	public ShiharaiWrap shiharaiWrap {get;set;}
	public PahseWrap pahseWrap {get;set;}

	// issues4156--Start-- 

	public GMOAtobaraiWrap GMOWrap {get;set;}

	public Boolean SaveButtonDisabled {get;set;}

	public YorisoItemWrap yorisoItemWrap {get;set;}

	private List<YorisoOptionItemWrap> beforeyorisoItemWraps {get;set;}

	private Map<String, Map<String, Product2>> oldserviceIdHinmokuPrductMap = new Map<String, Map<String, Product2>>();

	public Decimal sfSeikyuKingaku {get;set;}

	public Decimal sfSabunKingaku {get;set;}

	// issues4156--End-- 

	private Map<String, Map<String, Product2>> serviceIdHinmokuPrductMap = new Map<String, Map<String, Product2>>();

	public Boolean shoriKekkaFlg {get;set;}
	List<OpportunityLineItem> delOpportunityLineItems;

	// issues4228--Start-- 依頼人、対象者、喪主などで、重複データによるエラーの対応
	public String msg {get;set;}
	public Boolean alertFlg {get;set;}
	// issues4228--End--

	private String ShokiJyotaiButsuguNashiKibo = '';
	
	// issues4156--Start-- 

	public List<SelectOption> yorisoOption {get;set;}

	private List<SelectOption> m_yorisoOption  = new List<SelectOption> {
		new SelectOption('',''),
		new SelectOption('SBG-0005401','祭壇 M(家族葬 一日)'),
		new SelectOption('SBG-0005402','祭壇 L(家族葬 一日)'),
		new SelectOption('SBG-0005403','祭壇 LL(家族葬 一日)'),
		new SelectOption('SBG-0005404','祭壇 L(家族葬 二日)'),
		new SelectOption('SBG-0005405','祭壇 LL(家族葬 二日)'),
		new SelectOption('SBG-0005406','祭壇 LL(家族葬 華やか)'),
		new SelectOption('SBG-0005407','お別れ花 S'),
		new SelectOption('SBG-0005408','お別れ花 M'),
		new SelectOption('SBG-0005409','お別れ花 L'),
		new SelectOption('SBG-0005410','棺上花束 S'),
		new SelectOption('SBG-0005411','棺上花束 M'),
		new SelectOption('SBG-0005412','棺上花束 L'),
		new SelectOption('SBG-0005413','枕花 S'),
		new SelectOption('SBG-0005414','枕花 M'),
		new SelectOption('SBG-0005415','枕花 L'),
		new SelectOption('SBG-0005416','遺影写真 (大小2枚)'),
		new SelectOption('SBG-0005417','付添安置 (1泊)'),
		new SelectOption('SBG-0005418','搬送超過料金'),
		new SelectOption('SBG-0005419','ご安置追加料金')
	};

	public Map<String, PricebookEntry> YorisouPricebookEntryMap = new Map<String, PricebookEntry>();

	private Map< String, List<String> > YorisoUPgradeSaidanMap = new Map<String, List<String> >{
		'SBG-0005401' => new List<String>{'SBG-0005001','SBG-0005006','SBG-0005008','SBG-0005010'},             // 祭壇 M(家族葬 一日)
		'SBG-0005402' => new List<String>{'SBG-0005001','SBG-0005006','SBG-0005008','SBG-0005010'},             // 祭壇 L(家族葬 一日)
		'SBG-0005403' => new List<String>{'SBG-0005001','SBG-0005006','SBG-0005008','SBG-0005010'},             // 祭壇 LL(家族葬 一日)
		'SBG-0005404' => new List<String>{'SBG-0005002','SBG-0005011'},                                         // 祭壇 L(家族葬 二日)
		'SBG-0005405' => new List<String>{'SBG-0005002','SBG-0005011'},                                         // 祭壇 LL(家族葬 二日)
		'SBG-0005406' => new List<String>{'SBG-0005003','SBG-0005012'}                                          // 祭壇 LL(家族葬 華やか)
	};

	// issues4156--End-- 

	public class OpportunityWrap {

		public Opportunity opportunity {get;set;}
		public SimpleYasugo__c simpleYasugo {get;set;}

		// issues4228--Start-- カレンダーのui表示の変更
		public Datetime tsuyaYMD {get;set;}
		public Datetime kokubetsushikiYMD {get;set;}
		public Datetime kasoYMD {get;set;}
		public Date MitsumorijuryoDay {get;set;}
		public Date SoryoTehaiIraishoJuryobi {get;set;}
		public Date SeikyushojuryoDay {get;set;}
		// issues4228--End--

		//  issues4217--Start--
		public Keiyaku__c Keiyaku {get;set;}
		public TesuryoTekiyo__c TesuryoTekiyo {get;set;}
		public String seikyukanotesueyo {get;set;}
		public String SurveyDiscountAgreeStatus {get;set;}
		//  issues4217--End--

		public OpportunityWrap(){}

		private void setDate(){

			// issues4228--Start-- カレンダーのui表示の変更
			tsuyaYMD = null;
			kokubetsushikiYMD = null;
			kasoYMD = null;

			MitsumorijuryoDay = null;
			SoryoTehaiIraishoJuryobi = null;
			SeikyushojuryoDay = null;
			// issues4228--End--


			if(simpleYasugo.TsuyaDateTime_Inp__c != null){
				// issues4228--Start-- カレンダーのui表示の変更
				tsuyaYMD = simpleYasugo.TsuyaDateTime_Inp__c;
				// issues4228--End--
			}

			if(simpleYasugo.KokubetsuDateTime_Inp__c != null){
				// issues4228--Start-- カレンダーのui表示の変更
				kokubetsushikiYMD = simpleYasugo.KokubetsuDateTime_Inp__c;
				// issues4228--End--
			}

			if(simpleYasugo.KasoDateTime_Inp__c != null){
				// issues4228--Start-- カレンダーのui表示の変更
				kasoYMD = simpleYasugo.KasoDateTime_Inp__c;
				// issues4228--End--
			}

			// issues4228--Start-- カレンダーのui表示の変更
			if(simpleYasugo.MitsumorijuryoDay__c != null){
				MitsumorijuryoDay = simpleYasugo.MitsumorijuryoDay__c;
			}

			if(simpleYasugo.SoryoTehaiIraishoJuryobi__c != null){
				SoryoTehaiIraishoJuryobi = simpleYasugo.SoryoTehaiIraishoJuryobi__c;
			}

			if(simpleYasugo.SeikyushojuryoDay__c != null){
				SeikyushojuryoDay = simpleYasugo.SeikyushojuryoDay__c;
			}
			// issues4228--End--

		}
	}

	public class SodanshaWrap {

		public String sodanshaLastName {get;set;}
		public String sodanshaFirstName {get;set;}
		public String nengoValue {get; set;}
		public String warekiNen {get;set;}
		public String warekiTsuki {get;set;}
		public String warekiHi {get;set;}
		public String botsunenNengoValue {get; set;}
		public String botsunenWarekiNen {get;set;}
		public String botsunenWarekiTsuki {get;set;}
		public String botsunenWarekiHi {get;set;}
		public Account sodansha {get;set;}

		// issues4228--Start-- カレンダーのui表示の変更
		public Date sodanshaDeathDate {get;set;}
		// issues4228--End--


		public SodanshaWrap(){}

		private void setSeinengappiWareki(){

			nengoValue = '昭和';
			warekiNen = '';
			warekiTsuki = '';
			warekiHi = '';
			if(sodansha.SeinengappiWareki__c != null && sodansha.SeinengappiWareki__c != ''){
				try{
					String tempNengo = sodansha.SeinengappiWareki__c.trim().substring(0,2);
					if(tempNengo == '明治' || 
						tempNengo == '大正' ||
						tempNengo == '昭和' ||
						tempNengo == '平成' ||
						tempNengo == '令和'){
						nengoValue = tempNengo;
					}
					String tempNenTsukiHi = sodansha.SeinengappiWareki__c.substring(2);
					Integer indexNen = tempNenTsukiHi.indexOf('年');
					Integer indexTsuki = tempNenTsukiHi.indexOf('月');
					Integer indexHi = tempNenTsukiHi.indexOf('日');
					String tempNen = tempNenTsukiHi.substring(0, indexNen);
					String tempTsuki = tempNenTsukiHi.substring(indexNen + 1, indexTsuki);
					String tempHi = tempNenTsukiHi.substring(indexTsuki + 1, indexHi);
					warekiNen = tempNen;
					warekiTsuki = tempTsuki;
					warekiHi = tempHi;
				}
				catch(Exception e){

				}
			}
		}

		private void setBotsunengappiWareki(){

			botsunenNengoValue = '令和';
			botsunenWarekiNen = '';
			botsunenWarekiTsuki = '';
			botsunenWarekiHi = '';
			if(sodansha.BotsunengappiWareki__c != null && sodansha.BotsunengappiWareki__c != ''){
				try{
					String tempNengo = sodansha.BotsunengappiWareki__c.trim().substring(0,2);
					if(tempNengo == '明治' || 
						tempNengo == '大正' ||
						tempNengo == '昭和' ||
						tempNengo == '平成' ||
						tempNengo == '令和'){
						botsunenNengoValue = tempNengo;
					}
					String tempNenTsukiHi = sodansha.BotsunengappiWareki__c.substring(2);
					Integer indexNen = tempNenTsukiHi.indexOf('年');
					Integer indexTsuki = tempNenTsukiHi.indexOf('月');
					Integer indexHi = tempNenTsukiHi.indexOf('日');
					String tempNen = tempNenTsukiHi.substring(0, indexNen);
					String tempTsuki = tempNenTsukiHi.substring(indexNen + 1, indexTsuki);
					String tempHi = tempNenTsukiHi.substring(indexTsuki + 1, indexHi);
					botsunenWarekiNen = tempNen;
					botsunenWarekiTsuki = tempTsuki;
					botsunenWarekiHi = tempHi;
				}
				catch(Exception e){

				}
			}
		}

		public void setSeinengappiSeirekiNenTsukiHi(){
			sodansha.PersonBirthdate = JpCalendar.convertWarekiToSeireki(nengoValue + warekiNen + '年' + warekiTsuki + '月' + warekiHi + '日');
		}
		
		public void setBotsunengappiWarekiNenTsukiHi(){
			// issues4228--Start-- カレンダーのui表示の変更
			sodansha.BotsunengappiWareki__c = JpCalendar.convertSeirekiToWareki(sodanshaDeathDate);
			// issues4228--End--
			setBotsunengappiWareki();
		}

		public void setSeinengappiWarekiNenTsukiHi(){
			sodansha.SeinengappiWareki__c = JpCalendar.convertSeirekiToWareki(sodansha.PersonBirthdate);
			setSeinengappiWareki();
		}

		public void setBotsunengappiSeirekiNenTsukiHi(){
			// issues4228--Start-- カレンダーのui表示の変更
			sodanshaDeathDate = JpCalendar.convertWarekiToSeireki(botsunenNengoValue + botsunenWarekiNen + '年' + botsunenWarekiTsuki + '月' + botsunenWarekiHi + '日');
			// issues4228--End--
		}
	}

	public class TaishoshaWrap {

		public Boolean sodanshaOnajiFlg {get; set;}
		public String taishoshaLastName {get;set;}
		public String taishoshaFirstName {get;set;}
		public String nengoValue {get; set;}
		public String warekiNen {get;set;}
		public String warekiTsuki {get;set;}
		public String warekiHi {get;set;}
		public String botsunenNengoValue {get; set;}
		public String botsunenWarekiNen {get;set;}
		public String botsunenWarekiTsuki {get;set;}
		public String botsunenWarekiHi {get;set;}
		public Account taishosha {get;set;}

		// issues4228--Start-- カレンダーのui表示の変更
		public Date taishoshaDeathDate {get;set;}
		// issues4228--End--

		public TaishoshaWrap(){
			sodanshaOnajiFlg = false;
		}

		private void setSeinengappiWareki(){

			nengoValue = '昭和';
			warekiNen = '';
			warekiTsuki = '';
			warekiHi = '';
			if(taishosha.SeinengappiWareki__c != null && taishosha.SeinengappiWareki__c != ''){
				try{
					String tempNengo = taishosha.SeinengappiWareki__c.trim().substring(0,2);
					if(tempNengo == '明治' || 
						tempNengo == '大正' ||
						tempNengo == '昭和' ||
						tempNengo == '平成' ||
						tempNengo == '令和'){
						nengoValue = tempNengo;
					}
					String tempNenTsukiHi = taishosha.SeinengappiWareki__c.substring(2);
					Integer indexNen = tempNenTsukiHi.indexOf('年');
					Integer indexTsuki = tempNenTsukiHi.indexOf('月');
					Integer indexHi = tempNenTsukiHi.indexOf('日');
					String tempNen = tempNenTsukiHi.substring(0, indexNen);
					String tempTsuki = tempNenTsukiHi.substring(indexNen + 1, indexTsuki);
					String tempHi = tempNenTsukiHi.substring(indexTsuki + 1, indexHi);
					warekiNen = tempNen;
					warekiTsuki = tempTsuki;
					warekiHi = tempHi;
				}
				catch(Exception e){

				}
			}
		}

		private void setBotsunengappiWareki(){

			botsunenNengoValue = '令和';
			botsunenWarekiNen = '';
			botsunenWarekiTsuki = '';
			botsunenWarekiHi = '';
			if(taishosha.BotsunengappiWareki__c != null && taishosha.BotsunengappiWareki__c != ''){
				try{
					String tempNengo = taishosha.BotsunengappiWareki__c.trim().substring(0,2);
					if(tempNengo == '明治' || 
						tempNengo == '大正' ||
						tempNengo == '昭和' ||
						tempNengo == '平成' ||
						tempNengo == '令和'){
						botsunenNengoValue = tempNengo;
					}
					String tempNenTsukiHi = taishosha.BotsunengappiWareki__c.substring(2);
					Integer indexNen = tempNenTsukiHi.indexOf('年');
					Integer indexTsuki = tempNenTsukiHi.indexOf('月');
					Integer indexHi = tempNenTsukiHi.indexOf('日');
					String tempNen = tempNenTsukiHi.substring(0, indexNen);
					String tempTsuki = tempNenTsukiHi.substring(indexNen + 1, indexTsuki);
					String tempHi = tempNenTsukiHi.substring(indexTsuki + 1, indexHi);
					botsunenWarekiNen = tempNen;
					botsunenWarekiTsuki = tempTsuki;
					botsunenWarekiHi = tempHi;
				}
				catch(Exception e){

				}
			}
		}

		public void setSeinengappiSeirekiNenTsukiHi(){
			taishosha.PersonBirthdate = JpCalendar.convertWarekiToSeireki(nengoValue + warekiNen + '年' + warekiTsuki + '月' + warekiHi + '日');
		}

		public void setBotsunengappiWarekiNenTsukiHi(){
			// issues4228--Start-- カレンダーのui表示の変更
			taishosha.BotsunengappiWareki__c = JpCalendar.convertSeirekiToWareki(taishoshaDeathDate);
			// issues4228--End--
			setBotsunengappiWareki();
		}

		public void setSeinengappiWarekiNenTsukiHi(){
			taishosha.SeinengappiWareki__c = JpCalendar.convertSeirekiToWareki(taishosha.PersonBirthdate);
			setSeinengappiWareki();
		}

		public void setBotsunengappiSeirekiNenTsukiHi(){
			// issues4228--Start-- カレンダーのui表示の変更
			taishoshaDeathDate = JpCalendar.convertWarekiToSeireki(botsunenNengoValue + botsunenWarekiNen + '年' + botsunenWarekiTsuki + '月' + botsunenWarekiHi + '日');
			// issues4228--End--
		}
	}

	public class MoshuWrap {

		public Boolean sodanshaOnajiFlg {get; set;}
		public String moshuLastName {get;set;}
		public String moshuFirstName {get;set;}
		public String nengoValue {get; set;}
		public String warekiNen {get;set;}
		public String warekiTsuki {get;set;}
		public String warekiHi {get;set;}
		public Account moshu {get;set;}

		public MoshuWrap(){
			sodanshaOnajiFlg = false;
		}

		private void setSeinengappiWareki(){

			nengoValue = '昭和';
			warekiNen = '';
			warekiTsuki = '';
			warekiHi = '';
			if(moshu.SeinengappiWareki__c != null && moshu.SeinengappiWareki__c != ''){
				try{
					String tempNengo = moshu.SeinengappiWareki__c.trim().substring(0,2);
					if(tempNengo == '明治' || 
						tempNengo == '大正' ||
						tempNengo == '昭和' ||
						tempNengo == '平成' ||
						tempNengo == '令和'){
						nengoValue = tempNengo;
					}
					String tempNenTsukiHi = moshu.SeinengappiWareki__c.substring(2);
					Integer indexNen = tempNenTsukiHi.indexOf('年');
					Integer indexTsuki = tempNenTsukiHi.indexOf('月');
					Integer indexHi = tempNenTsukiHi.indexOf('日');
					String tempNen = tempNenTsukiHi.substring(0, indexNen);
					String tempTsuki = tempNenTsukiHi.substring(indexNen + 1, indexTsuki);
					String tempHi = tempNenTsukiHi.substring(indexTsuki + 1, indexHi);
					warekiNen = tempNen;
					warekiTsuki = tempTsuki;
					warekiHi = tempHi;
				}
				catch(Exception e){

				}
			}
		}

		public void setSeinengappiSeirekiNenTsukiHi(){
			moshu.PersonBirthdate = JpCalendar.convertWarekiToSeireki(nengoValue + warekiNen + '年' + warekiTsuki + '月' + warekiHi + '日');
		}

		public void setSeinengappiWarekiNenTsukiHi(){
			moshu.SeinengappiWareki__c = JpCalendar.convertSeirekiToWareki(moshu.PersonBirthdate);
			setSeinengappiWareki();
		}
	}

	public List<SelectOption> nengoPickList{
		get{
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('明治', '明治'));
			options.add(new SelectOption('大正', '大正'));
			options.add(new SelectOption('昭和', '昭和'));
			options.add(new SelectOption('平成', '平成'));
			options.add(new SelectOption('令和', '令和'));
			return options;
		}
		set;
	}

	public class PlanItemWrap {

		public String planShohinIdBefore {get;set;}
		public String planShohinIdAfter {get;set;}
		public String planShohinName {get;set;}
		public String planShohinBango {get;set;}
		public String planShohinServiceId {get;set;}
		public Decimal planShohinKingaku {get;set;}

		// issues4156--Start-- 
		public Boolean LatestFlg {get;set;}
		public Boolean LatestFlgBefore {get;set;}
		public String planShohinServiceIdBefore {get;set;}
		public Boolean YorisoUPgradeSaidanFlg {get;set;}
		// issues4156--End-- 


		public PlanItemWrap(){
			planShohinKingaku = 0;
		}
	}

	public class SogiItemWrap {
		
		public List<OptionItemWrap> optionItemWraps {get;set;}
		public Decimal optionItemAllTotalPrice {get;set;}

		public SogiItemWrap(){
			optionItemAllTotalPrice = 0;
		}
	}

	public class OptionItemWrap {

		// issues4228--Start-- 商談商品について、ユーザが変更した商品のみを更新する対応
		public id OptionItemid {get;set;}
		// issues4228--End--
		public Integer indexOptionItem {get;set;}
		public String optionItemName {get;set;}
		public Decimal unitPriceCustom {get;set;}
		public Decimal quantityCustom {get;set;}
		public Decimal totalPriceCustom {get;set;}
		public OpportunityLineItem opportunityLineItem {get;set;}

		public OptionItemWrap(){

			// issues4228--Start-- 商談商品について、ユーザが変更した商品のみを更新する対応
			OptionItemid = null;
			// issues4228--End-- 
			indexOptionItem = 0;
			optionItemName = '';
			unitPriceCustom = null;
			quantityCustom = null;
			totalPriceCustom = null;
			opportunityLineItem = new OpportunityLineItem();
			opportunityLineItem.Quantity = 1;
		}
	}

	public class NebikiWrap{

		public List<NebikiItemWrap> nebikiItemWraps {get;set;}
		public Decimal nebikiItemAllTotalPrice {get;set;}
		public List<NebikiItemWrap> CouponItemWraps {get;set;}

		public NebikiWrap(){
			nebikiItemAllTotalPrice = 0;
		}
	}

	public class NebikiItemWrap {

		public String itemDataKubun {get;set;}
		public String itemName {get;set;}
		public Decimal itemPrice {get;set;}
		
		// issues4156--Start-- 
		public String itemShohinBango {get;set;}
		// issues4156--End-- 

		public NebikiItemWrap(){
		}
	}

	// issues4156--Start-- 
	public class GMOAtobaraiWrap{

		public String itemName {get;set;}
		public Decimal GMOItemAllTotalPrice {get;set;}
		public String itemShohinBango {get;set;}

		public GMOAtobaraiWrap(){
			itemName = '';
			GMOItemAllTotalPrice = 0;
			itemShohinBango = '';
		}
	}

	public class YorisoItemWrap {
		
		public List<YorisoOptionItemWrap> yorisoOptionItemWraps {get;set;}
		public Decimal YorisooptionItemAllTotalPrice {get;set;}

		public YorisoItemWrap(){
			YorisooptionItemAllTotalPrice = 0;
		}
	}

	public class YorisoOptionItemWrap {

		public id OptionItemid {get;set;}
		public Integer indexOptionItem {get;set;}
		public String optionItemName {get;set;}
		public Decimal unitPriceCustom {get;set;}
		public Decimal quantityCustom {get;set;}
		public Decimal totalPriceCustom {get;set;}
		public OpportunityLineItem opportunityLineItem {get;set;}

		public YorisoOptionItemWrap(){

			OptionItemid = null;
			indexOptionItem = 0;
			optionItemName = '';
			unitPriceCustom = null;
			quantityCustom = null;
			totalPriceCustom = null;
			opportunityLineItem = new OpportunityLineItem();
			opportunityLineItem.Quantity = 1;
		}
	}
	// issues4156--End-- 

	public class ShiharaiWrap {

		public OkyakusamaSeikyuMeisaiWrap kurekaOrikoWrap {get;set;}
		public OkyakusamaSeikyuMeisaiWrap loanOrikoWrap {get;set;}
		public OkyakusamaSeikyuMeisaiWrap furikomiOrikoWrap {get;set;}
		public OkyakusamaSeikyuMeisaiWrap sosaiFujoWrap {get;set;}
		public OkyakusamaSeikyuMeisaiWrap atobaraiGmo {get;set;}
		public OkyakusamaSeikyuMeisaiWrap ososhikiyoyaku {get;set;}
		public OkyakusamaSeikyuMeisaiWrap kurekaGmo {get;set;}

		public ShiharaiWrap(){}
	}

	public class OkyakusamaSeikyuMeisaiWrap {

		public Boolean isRiyo {get;set;}
		public OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai {get;set;}
		public OkyakusamaSeikyuMeisai__c beforeOkyakusamaSeikyuMeisai {get;set;}

		public OkyakusamaSeikyuMeisaiWrap(){
			isRiyo = false;
			okyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
			beforeOkyakusamaSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
		}
	}

	public class PahseWrap {

		private Map<String, List<String>> phaseSubPahseMap = new Map<String, List<String>>{
			'その他' => new List<String>{'その他'},
			// issues4228--Start--フェーズ：決定　の際にサブフェーズ：売上計上待ち　の追加
			'決定' => new List<String>{'葬儀社手配','見積書受領待ち（お打合わせ中）','カード決済/与信待ち','売上計上待ち'},
			// issues4228--End--
			'施行待ち' => new List<String>{'請求書受領待ち'},
			//  issues4217--Start--
			'施行完了' => new List<String>{'商談確定承認待ち'}
			//'商談クローズ' => new List<String>{'-- なし --'}
			//見積書入力フォームのフェーズに商談クローズにすることがないため、コメントアウト
			//  issues4217--End--
		};
		public String phaseValue {get;set;}
		public List<SelectOption> phaseOptions{
			get{
				List<SelectOption> options = new List<SelectOption>();

				options.add(new SelectOption('その他', 'その他'));
				options.add(new SelectOption('決定', '決定'));
				options.add(new SelectOption('施行待ち', '施行待ち'));
				options.add(new SelectOption('施行完了', '施行完了'));
				//  issues4217--Start--
				// options.add(new SelectOption('商談クローズ', '商談クローズ'));
				//  issues4217--End--
				return options;
			}
			set;
		}

		public String subPhaseValue {get;set;}
		public List<SelectOption> subPhaseOptions{
			get{
				List<SelectOption> options = new List<SelectOption>();
				for(String subPhaseValue : phaseSubPahseMap.get(phaseValue)){
					options.add(new SelectOption(subPhaseValue, subPhaseValue));
				}
				return options;
			}
			set;
		}

		public PahseWrap(){
			phaseValue = '';
			subPhaseValue = '';
		}

		private void setPhaseSubPahse(Opportunity opp){
			String pPhase = opp.StageName;
			String pSubPahse = opp.SubPhase__c;
			//  issues4217--Start--
			// if(pPhase == '決定' || pPhase == '施行待ち' || pPhase == '施行完了' || pPhase == '商談クローズ') {
			if(pPhase == '決定' || pPhase == '施行待ち' || pPhase == '施行完了') {
			//  issues4217--End--
				phaseValue = pPhase;
				subPhaseValue = pSubPahse;
			}
			else{
				phaseValue = 'その他';
				subPhaseValue = 'その他';
			}
		}
	}

	public SogiMitsumoriNyuryokuFormCtl(ApexPages.StandardController controller){
		opportunityId = controller.getId();
	}

	public void init() {

		mitsumorishoKisaiNebikiKingaku = null;
		mitsumorishoKisaiMitsumoriKingaku = null;
		shoriKekkaFlg = false;
		
		beforeOpportunity = [select Id, 
										StageName, 
										SubPhase__c, 
										ShodanBangoF__c, 
										SimpleYasugoRef__c, 
										SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.Name, 
										AccountId, 
										KiboShiharaiHouhou__c, 
										ShiharaiHohoMikakuteiRiyu__c, 
										PriceBook2Id, 
										SurveyDiscountAgreeStatus__c, 
										AllianceRef__r.Teikeisaki__r.Name, 
										Utiagebi__c,
										TesuryoKeisanzumi__c
									from Opportunity 
									where Id = :opportunityId 
							];

		beforeSimpleYasugo = [select Id, 
										MitsumorijuryoDay__c, 
										SoryoTehaiIraishoJuryobi__c, 
										SeikyushojuryoDay__c, 
										ZokugaraTaishoshaKaramitaSodansha__c, 
										ZokugaraMoshuNitottenoTaishosha__c, 
										TaishoshaRef__c, 
										MoshuRef__c, 
										TsuyaDateTime_Inp__c, 
										KokubetsuDateTime_Inp__c, 
										KasoDateTime_Inp__c, 
										SaijoRef__c, 
										SonotaSaijoShisetsu__c, 
										KasobaShisetsu__c, 
										SonotaKasobaShisetsu__c, 
										MonkArrangements__c, 
										Kaimyojuyo__c, 
										ShiharaiTaioBiko__c, 
										SogishagawaTantoshamei__c, 
										// issues4156--Start-- 
										SimpleYasugoKeiyakuRef__c, 
										SogishaTsuikaEigyoNg__c, 
										ButsuguNashiKibo__c
										// issues4156--End-- 
									from SimpleYasugo__c 
									where Id = :beforeOpportunity.SimpleYasugoRef__c 
							];

		opportunityWrap = new OpportunityWrap();
		opportunityWrap.opportunity = beforeOpportunity;
		opportunityWrap.simpleYasugo = beforeSimpleYasugo;
		opportunityWrap.setDate();

		ShokiJyotaiButsuguNashiKibo = beforeSimpleYasugo.ButsuguNashiKibo__c;

		//  issues4217--Start--
		opportunityWrap.SurveyDiscountAgreeStatus = 'なし';
		if(String.isNotBlank(opportunityWrap.opportunity.SurveyDiscountAgreeStatus__c)){
			opportunityWrap.SurveyDiscountAgreeStatus = opportunityWrap.opportunity.SurveyDiscountAgreeStatus__c;
		}
		//  issues4217--End--

		beforeSodansha =  [select Id, 
									RecordTypeId, 
									LastNameFurigana__pc, 
									FirstNameFurigana__pc, 
									LastName, 
									FirstName, 
									PersonBirthdate, 
									SeinengappiWareki__c, 
									BotsunengappiWareki__c, 
									PersonDeathDate__pc, 
									Gender__pc, 
									BillingPostalCode, 
									BillingState, 
									BillingCity, 
									BillingStreet, 
									Phone, 
									// issues4156--Start-- 
									MobilePhone__c, 
									JizenwariKekaKikan__c, 
									MemberKubunCode__c, 
									AcvmJizenJunbiMinDate__c 
									// issues4156--End-- 
							from Account 
							where Id = :beforeOpportunity.AccountId 
						];

		if(beforeSodansha.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId()) {
			nullAccountFlg = true;
			return;
		}
		
		sodanshaWrap = new SodanshaWrap();
		sodanshaWrap.sodansha = beforeSodansha;
		sodanshaWrap.sodanshaLastName = beforeSodansha.LastName;
		sodanshaWrap.sodanshaFirstName = beforeSodansha.FirstName;
		// issues4228--Start-- カレンダーのui表示の変更
		sodanshaWrap.sodanshaDeathDate = beforeSodansha.PersonDeathDate__pc;
		// issues4228--End--
		sodanshaWrap.setSeinengappiWareki();
		sodanshaWrap.setBotsunengappiWareki();

		beforeTaishosha = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId());
		if(opportunityWrap.simpleYasugo.TaishoshaRef__c != null) {
			beforeTaishosha = [select Id, 
										LastNameFurigana__pc, 
										FirstNameFurigana__pc, 
										LastName, 
										FirstName, 
										PersonBirthdate, 
										SeinengappiWareki__c, 
										BotsunengappiWareki__c, 
										PersonDeathDate__pc, 
										Gender__pc, 
										BillingPostalCode, 
										BillingState, 
										BillingCity, 
										// issues4156--Start-- 
										BillingStreet, 
										JizenwariKekaKikan__c, 
										MemberKubunCode__c, 
										AcvmJizenJunbiMinDate__c 
										// issues4156--End-- 
								from Account 
								where Id = :beforeSimpleYasugo.TaishoshaRef__c 
							];
		}

		taishoshaWrap = new TaishoshaWrap();
		taishoshaWrap.taishosha = beforeTaishosha.clone(true, true);
		taishoshaWrap.taishoshaLastName = taishoshaWrap.taishosha.LastName;
		taishoshaWrap.taishoshaFirstName = taishoshaWrap.taishosha.FirstName;
		// issues4228--Start-- カレンダーのui表示の変更
		taishoshaWrap.taishoshaDeathDate = taishoshaWrap.taishosha.PersonDeathDate__pc;
		// issues4228--End--
		taishoshaWrap.setSeinengappiWareki();
		taishoshaWrap.setBotsunengappiWareki();
		if(sodanshaWrap.sodansha.Id == taishoshaWrap.taishosha.Id) taishoshaWrap.sodanshaOnajiFlg = true;
		
		beforeMoshu = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId());
		if(opportunityWrap.simpleYasugo.MoshuRef__c != null) {
			beforeMoshu = [select Id, 
									LastNameFurigana__pc, 
									FirstNameFurigana__pc, 
									LastName, 
									FirstName, 
									PersonBirthdate, 
									SeinengappiWareki__c, 
									Gender__pc, 
									BillingPostalCode, 
									BillingState, 
									BillingCity, 
									BillingStreet, 
									Phone, 
									MobilePhone__c
							from Account 
							where Id = :beforeSimpleYasugo.MoshuRef__c 
						];
		}

		moshuWrap = new MoshuWrap();
		moshuWrap.moshu = beforeMoshu.clone(true, true);
		moshuWrap.moshuLastName = moshuWrap.moshu.LastName;
		moshuWrap.moshuFirstName = moshuWrap.moshu.FirstName;
		moshuWrap.setSeinengappiWareki();
		if(sodanshaWrap.sodansha.Id == moshuWrap.moshu.Id) moshuWrap.sodanshaOnajiFlg = true;

		beforeOpportunityLineItems = [select Id, 
												OpportunityId, 
												UnitPrice, 
												Quantity, 
												TotalPrice, 
												Product2Id, 
												Product2.Name, 
												Product2.ShohinBango__c, 
												Product2.HinmokuBunrui__c, 
												Product2.k_Service_Id_exp__c,	
												Product2.k_ShohinSyubetsu_Id_exp__c, 
												Product2.k_Coupon_Id_exp__c, 
												Product2.k_WaribikiPlan_Id_exp__c, 
												// issues4156--Start-- 
												Product2.DataKubun__c, 
												Product2.k_ShohinCategory_Id_exp__c, 
												Product2.LatestFlg__c
												// issues4156--End--
											from OpportunityLineItem 
											where OpportunityId = :opportunityId 
											ORDER BY Product2.DataKubun__c asc, UnitPrice asc, Product2.Name asc
									];

		planItemWrap = new PlanItemWrap();
		planItemWrap.planShohinIdBefore = '';
		planItemWrap.planShohinIdAfter = '';
		planItemWrap.planShohinName = '';
		planItemWrap.planShohinBango = '';
		planItemWrap.planShohinServiceId = '';

		// issues4156--Start-- 
		planItemWrap.LatestFlg = false;
		planItemWrap.LatestFlgBefore = false;
		planItemWrap.planShohinServiceIdBefore = '';
		planItemWrap.YorisoUPgradeSaidanFlg = false;
		// issues4156--End-- 

		sogiItemWrap = new SogiItemWrap();
		sogiItemWrap.optionItemWraps = new List<OptionItemWrap>();

		// issues4228--Start-- 商談商品について、ユーザが変更した商品のみを更新する対応
		beforeoptionItemWraps = new List<OptionItemWrap>();
		// issues4228--End--

		nebikiWrap = new NebikiWrap();
		nebikiWrap.nebikiItemWraps = new List<NebikiItemWrap>();
		nebikiWrap.nebikiItemAllTotalPrice = 0;
		nebikiWrap.CouponItemWraps = new List<NebikiItemWrap>();

		// issues4156--Start-- 
		
		GMOWrap = new GMOAtobaraiWrap();
		GMOWrap.GMOItemAllTotalPrice = 0;

		SaveButtonDisabled = False;

		if(opportunityWrap.opportunity.TesuryoKeisanzumi__c){SaveButtonDisabled = True;}

		yorisoItemWrap = new YorisoItemWrap();
		yorisoItemWrap.yorisoOptionItemWraps = new List<YorisoOptionItemWrap>();
		beforeyorisoItemWraps = new List<YorisoOptionItemWrap>();
		
		yorisoOption = new List<SelectOption>();
		yorisoOption = m_yorisoOption;

		List<PricebookEntry> ListYorisouPricebookEntry = new List<PricebookEntry>();
		Set<String> YorisoOptionShohinBangos = new Set<String>();
		for(SelectOption aSelectOption : m_yorisoOption){
			if(String.isNotBlank(aSelectOption.getValue())){
				YorisoOptionShohinBangos.add(aSelectOption.getValue()); 
			}
		}
		ListYorisouPricebookEntry = [SELECT Id,
								Product2Id, 
								Product2.ShohinBango__c, 
								Product2.Name, 
								Product2.k_Service_Id_exp__c, 
								Product2.NameForCustomerExp__c, 
								UnitPrice, 
								Product2.DataKubun__c 
							FROM PricebookEntry
							WHERE Product2.ShohinBango__c IN :YorisoOptionShohinBangos
							ORDER BY UnitPrice asc, Product2.Name asc];
		for(PricebookEntry aPricebookEntry :ListYorisouPricebookEntry){
			YorisouPricebookEntryMap.put(aPricebookEntry.Product2.ShohinBango__c,aPricebookEntry);
		}


		// issues4156--End-- 


		for(OpportunityLineItem opportunityLineItem : beforeOpportunityLineItems){

			if(opportunityLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '1') {
				planItemWrap.planShohinIdBefore = opportunityLineItem.Product2.Id;
				planItemWrap.planShohinIdAfter = opportunityLineItem.Product2.Id;
				planItemWrap.planShohinName = opportunityLineItem.Product2.Name;
				planItemWrap.planShohinBango = opportunityLineItem.Product2.ShohinBango__c;
				planItemWrap.planShohinServiceId = opportunityLineItem.Product2.k_Service_Id_exp__c;
				planItemWrap.planShohinKingaku = opportunityLineItem.TotalPrice;
				// issues4156--Start-- 
				planItemWrap.LatestFlg = opportunityLineItem.Product2.LatestFlg__c;
				planItemWrap.LatestFlgBefore = opportunityLineItem.Product2.LatestFlg__c;
				planItemWrap.planShohinServiceIdBefore = opportunityLineItem.Product2.k_Service_Id_exp__c;
				// issues4156--End-- 
			}
			
			// 葬儀社オプションの初期設定
			if((opportunityLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '3' || opportunityLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '4') && 
				opportunityLineItem.Product2.k_ShohinCategory_Id_exp__c != 'yoriso-option' && opportunityLineItem.Product2.k_ShohinCategory_Id_exp__c != 'yoriso-option-campaign' && 
				opportunityLineItem.Product2.HinmokuBunrui__c != '決済手数料(GMO後払い)') {

				OptionItemWrap optionItemWrap = new OptionItemWrap();
				// issues4228--Start-- 商談商品について、ユーザが変更した商品のみを更新する対応
				optionItemWrap.OptionItemid = opportunityLineItem.id;
				// issues4228--End--
				optionItemWrap.unitPriceCustom = opportunityLineItem.UnitPrice;
				optionItemWrap.quantityCustom = opportunityLineItem.Quantity.round(System.RoundingMode.HALF_DOWN);
				optionItemWrap.totalPriceCustom = optionItemWrap.unitPriceCustom * optionItemWrap.quantityCustom;
				optionItemWrap.optionItemName = opportunityLineItem.Product2.HinmokuBunrui__c != null ? opportunityLineItem.Product2.HinmokuBunrui__c : 'その他オプション';
				optionItemWrap.opportunityLineItem = opportunityLineItem;
				sogiItemWrap.optionItemWraps.add(optionItemWrap);
				
				// issues4228--Start-- 商談商品について、ユーザが変更した商品のみを更新する対応
				OptionItemWrap beforetemWrap = new OptionItemWrap();
				beforetemWrap.OptionItemid = opportunityLineItem.id;
				beforetemWrap.unitPriceCustom = opportunityLineItem.UnitPrice;
				beforetemWrap.quantityCustom = opportunityLineItem.Quantity.round(System.RoundingMode.HALF_DOWN);
				beforetemWrap.totalPriceCustom = beforetemWrap.unitPriceCustom * beforetemWrap.quantityCustom;
				beforetemWrap.optionItemName = opportunityLineItem.Product2.HinmokuBunrui__c != null ? opportunityLineItem.Product2.HinmokuBunrui__c : 'その他オプション';
				optionItemWrap.opportunityLineItem = opportunityLineItem;
				beforeoptionItemWraps.add(beforetemWrap);
				// issues4228--End--
			}

			// よりそうオプションの初期設定
			if((opportunityLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '3' || opportunityLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '4') && 
				opportunityLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yoriso-option' && opportunityLineItem.Product2.HinmokuBunrui__c != '決済手数料(GMO後払い)') {

				YorisoOptionItemWrap yorisoWrap = new YorisoOptionItemWrap();
				yorisoWrap.OptionItemid = opportunityLineItem.id;
				yorisoWrap.unitPriceCustom = opportunityLineItem.UnitPrice;
				yorisoWrap.quantityCustom = opportunityLineItem.Quantity.round(System.RoundingMode.HALF_DOWN);
				yorisoWrap.totalPriceCustom = yorisoWrap.unitPriceCustom * yorisoWrap.quantityCustom;
				yorisoWrap.optionItemName = opportunityLineItem.Product2.ShohinBango__c;
				yorisoWrap.opportunityLineItem = opportunityLineItem;
				yorisoItemWrap.yorisoOptionItemWraps.add(yorisoWrap);
				
				YorisoOptionItemWrap beforeYorisoWrap = new YorisoOptionItemWrap();
				beforeYorisoWrap.OptionItemid = opportunityLineItem.id;
				beforeYorisoWrap.unitPriceCustom = opportunityLineItem.UnitPrice;
				beforeYorisoWrap.quantityCustom = opportunityLineItem.Quantity.round(System.RoundingMode.HALF_DOWN);
				beforeYorisoWrap.totalPriceCustom = beforeYorisoWrap.unitPriceCustom * beforeYorisoWrap.quantityCustom;
				beforeYorisoWrap.optionItemName = opportunityLineItem.Product2.ShohinBango__c;
				beforeYorisoWrap.opportunityLineItem = opportunityLineItem;
				beforeyorisoItemWraps.add(beforeYorisoWrap);

				}


			if((opportunityLineItem.Product2.k_ShohinSyubetsu_Id_exp__c == '6') || 
				(opportunityLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yoriso-option-campaign')){
				NebikiItemWrap nebikiItemWrap = new NebikiItemWrap();
				if(opportunityLineItem.Product2.DataKubun__c == '2:割引プラン') nebikiItemWrap.itemDataKubun = '割引';
				if(opportunityLineItem.Product2.DataKubun__c == '3:クーポン') nebikiItemWrap.itemDataKubun = 'クーポン';
				if(opportunityLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yoriso-option-campaign') nebikiItemWrap.itemDataKubun = 'キャンペーン';
				nebikiItemWrap.itemName = opportunityLineItem.Product2.Name;
				nebikiItemWrap.itemPrice = opportunityLineItem.TotalPrice;
				// issues4156--Start-- 
				nebikiItemWrap.itemShohinBango = opportunityLineItem.Product2.ShohinBango__c;
				// issues4156--End-- 
				
				nebikiWrap.nebikiItemWraps.add(nebikiItemWrap);

				nebikiWrap.nebikiItemAllTotalPrice += opportunityLineItem.TotalPrice;

				if( opportunityLineItem.Product2.DataKubun__c == '3:クーポン' ){
					nebikiWrap.CouponItemWraps.add(nebikiItemWrap);
				}

			}

			if(opportunityLineItem.Product2.HinmokuBunrui__c == '決済手数料(GMO後払い)') {
				GMOWrap.itemName = opportunityLineItem.Product2.Name;
				GMOWrap.itemShohinBango = opportunityLineItem.Product2.ShohinBango__c;
				GMOWrap.GMOItemAllTotalPrice = opportunityLineItem.TotalPrice;
			}

		}

		

		// issues4228--Start-- オプションの＋ボタン押下時、個数項目に「１」をデフォルト設定する対応
		if(sogiItemWrap.optionItemWraps.size() ==0){
			OptionItemWrap addoptionItemWraps = new OptionItemWrap();
			addoptionItemWraps.quantityCustom = 1;
			sogiItemWrap.optionItemWraps.add(addoptionItemWraps);
		}
		// issues4228--End--
		
		setOptionItemIndex();
		
		// issues4156--Start-- 

		if(yorisoItemWrap.yorisoOptionItemWraps.size() ==0){
			YorisoOptionItemWrap addyorisoWrap = new YorisoOptionItemWrap();
			addyorisoWrap.unitPriceCustom = 0;
			addyorisoWrap.quantityCustom = 1;
			yorisoItemWrap.yorisoOptionItemWraps.add(addyorisoWrap);
		}

		chkYorisoUPgradeSaidan();

		setYorisoItemIndex();

		sfMitsumoriKingaku = 0;
		sfSeikyuKingaku = 0;
		sfSabunKingaku =0;
		
		// issues4156--End-- 
		
		calcShodanKingaku();
		

		WaribikiSummary.DataContext dc = new WaribikiSummary.DataCtxProvider().getDataCtx(opportunityId);
		waribikiList = dc.entries;

		String okyakusamaSeikyuMeisaiKobetsuRecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId();
		String okyakusamaSeikyuMeisaiSosaiRecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('Sosai').getRecordTypeId();

		shiharaiWrap = new ShiharaiWrap();
		shiharaiWrap.kurekaOrikoWrap = new OkyakusamaSeikyuMeisaiWrap();
		shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai.RecordTypeId = okyakusamaSeikyuMeisaiKobetsuRecordTypeId;
		shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai.OpportunityRef__c = opportunityId;
		shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai.ServiceSyubetsu__c = 'シンプル安豪';
		shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_credit';

		shiharaiWrap.loanOrikoWrap = new OkyakusamaSeikyuMeisaiWrap();
		shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai.RecordTypeId = okyakusamaSeikyuMeisaiKobetsuRecordTypeId;
		shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai.OpportunityRef__c = opportunityId;
		shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai.ServiceSyubetsu__c = 'シンプル安豪';
		shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'orico_loan';

		shiharaiWrap.furikomiOrikoWrap = new OkyakusamaSeikyuMeisaiWrap();
		shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai.RecordTypeId = okyakusamaSeikyuMeisaiKobetsuRecordTypeId;
		shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai.OpportunityRef__c = opportunityId;
		shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'Partner';

		shiharaiWrap.sosaiFujoWrap = new OkyakusamaSeikyuMeisaiWrap();
		shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai.RecordTypeId = okyakusamaSeikyuMeisaiKobetsuRecordTypeId;
		shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai.OpportunityRef__c = opportunityId;
		shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'sosaifujo';

		shiharaiWrap.atobaraiGmo = new OkyakusamaSeikyuMeisaiWrap();
		shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai.RecordTypeId = okyakusamaSeikyuMeisaiKobetsuRecordTypeId;
		shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai.OpportunityRef__c = opportunityId;
		shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'gmo_atobarai';

		shiharaiWrap.ososhikiyoyaku = new OkyakusamaSeikyuMeisaiWrap();
		shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai.RecordTypeId = okyakusamaSeikyuMeisaiSosaiRecordTypeId;
		shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai.OpportunityRef__c = opportunityId;
		shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'sousai';

		shiharaiWrap.kurekaGmo = new OkyakusamaSeikyuMeisaiWrap();
		shiharaiWrap.kurekaGmo.okyakusamaSeikyuMeisai.RecordTypeId = okyakusamaSeikyuMeisaiSosaiRecordTypeId;
		shiharaiWrap.kurekaGmo.okyakusamaSeikyuMeisai.OpportunityRef__c = opportunityId;
		shiharaiWrap.kurekaGmo.okyakusamaSeikyuMeisai.ServiceSyubetsu__c = 'シンプル安豪';
		shiharaiWrap.kurekaGmo.okyakusamaSeikyuMeisai.SeikyuHouhou__c = 'gmo_credit';

		for(OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai : [select Id, SeikyuHouhou__c, SeikyuKingaku__c, Kessaibi__c, SousaiSakiShodanRef__c, SeikyuStatus__c, ServiceSyubetsu__c 
																	from OkyakusamaSeikyuMeisai__c
																	where OpportunityRef__c = :opportunityId]){
			OkyakusamaSeikyuMeisaiWrap okyakusamaSeikyuMeisaiWrap = new OkyakusamaSeikyuMeisaiWrap();
			okyakusamaSeikyuMeisaiWrap.isRiyo = true;
			okyakusamaSeikyuMeisaiWrap.okyakusamaSeikyuMeisai = okyakusamaSeikyuMeisai;
			okyakusamaSeikyuMeisaiWrap.beforeOkyakusamaSeikyuMeisai = okyakusamaSeikyuMeisai.clone(true, false);

			if(okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'orico_credit') shiharaiWrap.kurekaOrikoWrap = okyakusamaSeikyuMeisaiWrap;
			if(okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'orico_loan') shiharaiWrap.loanOrikoWrap = okyakusamaSeikyuMeisaiWrap;
			if(okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'Partner') shiharaiWrap.furikomiOrikoWrap = okyakusamaSeikyuMeisaiWrap;
			if(okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'sosaifujo') shiharaiWrap.sosaiFujoWrap = okyakusamaSeikyuMeisaiWrap;
			if(okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'gmo_atobarai') shiharaiWrap.atobaraiGmo = okyakusamaSeikyuMeisaiWrap;
			if(okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'sousai') shiharaiWrap.ososhikiyoyaku = okyakusamaSeikyuMeisaiWrap;
			if(okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit') shiharaiWrap.kurekaGmo = okyakusamaSeikyuMeisaiWrap;
		}

		// issues4156--Start-- 
		
		calcSeikyuKingaku();
		
		// 葬儀オプションのみを取得するための対応
		List<Product2> ListSogiOption = new List<Product2>();
		ListSogiOption = [select Id, 
								k_Service_Id_exp__c, 
								HinmokuBunrui__c, 
								ShohinBango__c, 
								LatestFlg__c 
						from Product2 
						where k_ShohinSyubetsu_Id_exp__c in ('3','4') 
						and k_ShohinCategory_Id_exp__c != 'yoriso-option'
						and HanbaiKaishiBi__c >= 2020-10-01];
		for(Product2 product : ListSogiOption){

			Map<String, Product2> hinmokuPrductMapTemp = new Map<String, Product2>();
			Map<String, Product2> oldhinmokuPrductMapTemp = new Map<String, Product2>();

			if(product.LatestFlg__c){
				if(serviceIdHinmokuPrductMap.containsKey(product.k_Service_Id_exp__c)){
					hinmokuPrductMapTemp = serviceIdHinmokuPrductMap.get(product.k_Service_Id_exp__c);
				}
			}else{
				if(oldserviceIdHinmokuPrductMap.containsKey(product.k_Service_Id_exp__c)){
					oldhinmokuPrductMapTemp = oldserviceIdHinmokuPrductMap.get(product.k_Service_Id_exp__c);
				}
			}

			String hinmoku = product.HinmokuBunrui__c;
			if(product.ShohinBango__c == 'SBG-0003016') hinmoku = 'その他オプション'; // 【19.12】よりそうのお葬式 オプション その他オプション
			if(product.ShohinBango__c == 'SBG-0003125') hinmoku = 'その他オプション'; // 【19.12】お花いっぱいのお葬式 オプション その他オプション
			if(product.ShohinBango__c == 'SBG-0005517') hinmoku = 'その他オプション'; // 【20.11】葬儀社オプション その他オプション

			if(product.LatestFlg__c){
				hinmokuPrductMapTemp.put(hinmoku, product);
				serviceIdHinmokuPrductMap.put(product.k_Service_Id_exp__c, hinmokuPrductMapTemp);
			}else{
				oldhinmokuPrductMapTemp.put(hinmoku, product);
				oldserviceIdHinmokuPrductMap.put(product.k_Service_Id_exp__c, oldhinmokuPrductMapTemp);
			}
		}

		// issues4156--End-- 

		pahseWrap = new PahseWrap();
		pahseWrap.setPhaseSubPahse(opportunityWrap.opportunity);

		delOpportunityLineItems = new List<OpportunityLineItem>();
		
		//  issues4217--Start--
		if(opportunityWrap.simpleYasugo.SimpleYasugoKeiyakuRef__c != null) {
			beforeKeiyaku = [select Id, 
									SeikyushoHassoCycle__c, 
									NyukinSimekiriJouken__c, 
									MitsumoriSeikyuChui__c 
							from Keiyaku__c 
							where Id = :beforeSimpleYasugo.SimpleYasugoKeiyakuRef__c 
							];
		}
		opportunityWrap.Keiyaku = beforeKeiyaku;
		if(opportunityWrap.Keiyaku != null) {
			List<TesuryoTekiyo__c> sTesuryoTekiyo = new List<TesuryoTekiyo__c>();
			sTesuryoTekiyo = [SELECT Id,
										name, 
										KeiyakuRef__c, 
										OptionTesuryoAri__c, 
										CardLoanTesuryoAri__c, 
										AtobaraiTesuryoAri__c, 
										HenreihinTesuryoAri__c, 
										RyoriTesuryoAri__c, 
										TesuryoPlanRef__c, 
										// issues4156--Start-- 
										TesuryoPlanRef__r.name, 
										YorisoOptionFlowersTesuryoFlg__c, 
										UrnOptionTesuryoFlg__c 
										// issues4156--End-- 
									FROM TesuryoTekiyo__c 
									WHERE KeiyakuRef__c = :beforeKeiyaku.Id
									AND ShoninStatus__c = '承認済'
									ORDER BY TekiyoKaishiBi__c DESC 
									Limit 1];
			if(sTesuryoTekiyo.size() > 0){
				beforeTesuryoTekiyo = sTesuryoTekiyo[0];
			}
		}
		opportunityWrap.TesuryoTekiyo = beforeTesuryoTekiyo;

		String strseikyukanotesueyo = '';
		// issues4273--Start-- 
		if(opportunityWrap.TesuryoTekiyo.RyoriTesuryoAri__c) {
			strseikyukanotesueyo = strseikyukanotesueyo + '料理';
		}
		if(opportunityWrap.TesuryoTekiyo.HenreihinTesuryoAri__c) {
			if(String.isNotBlank(strseikyukanotesueyo)){
				strseikyukanotesueyo = strseikyukanotesueyo + '、';
			}
			strseikyukanotesueyo = strseikyukanotesueyo + '返礼品';
		}
		// issues4273--End-- 
		// issues4156--Start-- 
		if(opportunityWrap.TesuryoTekiyo.YorisoOptionFlowersTesuryoFlg__c) {
			if(String.isNotBlank(strseikyukanotesueyo)){
				strseikyukanotesueyo = strseikyukanotesueyo + '、';
			}
			strseikyukanotesueyo = strseikyukanotesueyo + 'よりそうオプション花一式';
		}
		if(opportunityWrap.TesuryoTekiyo.UrnOptionTesuryoFlg__c) {
			if(String.isNotBlank(strseikyukanotesueyo)){
				strseikyukanotesueyo = strseikyukanotesueyo + '、';
			}
			strseikyukanotesueyo = strseikyukanotesueyo + '骨壷';
		}
		// issues4156--End-- 
		if(opportunityWrap.TesuryoTekiyo.OptionTesuryoAri__c) {
			if(String.isNotBlank(strseikyukanotesueyo)){
				strseikyukanotesueyo = strseikyukanotesueyo + '、';
			}
			strseikyukanotesueyo = strseikyukanotesueyo + 'その他オプション';
		}
		if(opportunityWrap.TesuryoTekiyo.CardLoanTesuryoAri__c) {
			if(String.isNotBlank(strseikyukanotesueyo)){
				strseikyukanotesueyo = strseikyukanotesueyo + '、';
			}
			strseikyukanotesueyo = strseikyukanotesueyo + 'カードローン';
		}
		if(opportunityWrap.TesuryoTekiyo.AtobaraiTesuryoAri__c) {
			if(String.isNotBlank(strseikyukanotesueyo)){
				strseikyukanotesueyo = strseikyukanotesueyo + '、';
			}
			strseikyukanotesueyo = strseikyukanotesueyo + '後払';
		}

		opportunityWrap.seikyukanotesueyo = strseikyukanotesueyo;
		//  issues4217--End--

	}

	public void addStandardItem(){

		Integer iIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('ojbAddIndex'));

		OptionItemWrap addoptionItemWraps = new OptionItemWrap();
		addoptionItemWraps.quantityCustom = 1;
		// issues4273--Start-- 

		if(sogiItemWrap.optionItemWraps.size() <= iIndex){
			sogiItemWrap.optionItemWraps.add(addoptionItemWraps);
		}else{
			sogiItemWrap.optionItemWraps.add(iIndex, addoptionItemWraps);
		}

		// issues4273--End-- 

		setOptionItemIndex();
		calcShodanKingaku();

	}

	public void delStandardItem(){

		Integer iIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('ojbDelIndex'));
		
		// issues4273--Start-- 
		if(sogiItemWrap.optionItemWraps.size() >= iIndex){

			OpportunityLineItem delOli = sogiItemWrap.optionItemWraps.get(iIndex - 1).opportunityLineItem;
			if(delOli.Id != null) delOpportunityLineItems.add(delOli);

			if(beforeoptionItemWraps.size() > 0){
				if((iIndex - 1) < beforeoptionItemWraps.size()){
					beforeoptionItemWraps.remove(iIndex - 1);
				}
			}

			sogiItemWrap.optionItemWraps.remove(iIndex - 1);
			setOptionItemIndex();
			calcShodanKingaku();
		}
		// issues4273--End-- 
	}

	// issues4156--Start-- 

	public void chkYorisoUPgradeSaidan(){
		planItemWrap.YorisoUPgradeSaidanFlg = false;
		List<String> theShohinBango = new List<String>();
		for(YorisoOptionItemWrap aYorisoOption :yorisoItemWrap.yorisoOptionItemWraps){
			if(YorisoUPgradeSaidanMap.containsKey(aYorisoOption.optionItemName)){
				theShohinBango = YorisoUPgradeSaidanMap.get(aYorisoOption.optionItemName);
			}
			if(theShohinBango.size() > 0){
				if( !theShohinBango.contains(planItemWrap.planShohinBango) ){
					planItemWrap.YorisoUPgradeSaidanFlg = true;
					break; 
				}
			}
		}
	}
	
	public void addYorisoItem(){

		Integer iIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('ojbAddIndex'));


		YorisoOptionItemWrap addYorisoOptionItemWraps = new YorisoOptionItemWrap();
		addYorisoOptionItemWraps.quantityCustom = 1;
		addYorisoOptionItemWraps.unitPriceCustom = 0;

		if(yorisoItemWrap.yorisoOptionItemWraps.size() <= iIndex){
			yorisoItemWrap.yorisoOptionItemWraps.add(addYorisoOptionItemWraps);
		}else{
			yorisoItemWrap.yorisoOptionItemWraps.add(iIndex, addYorisoOptionItemWraps);
		}

		setYorisoItemIndex();
		calcShodanKingaku();
	}

	public void delYorisoItem(){

		Integer iIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('ojbDelIndex'));
		
		if(yorisoItemWrap.yorisoOptionItemWraps.size() >= iIndex){

			OpportunityLineItem delOli = yorisoItemWrap.yorisoOptionItemWraps.get(iIndex - 1).opportunityLineItem;
			if(delOli.Id != null) delOpportunityLineItems.add(delOli);

			if(beforeyorisoItemWraps.size() > 0){
				if((iIndex - 1) < beforeyorisoItemWraps.size()){
					beforeyorisoItemWraps.remove(iIndex - 1);
				}
			}

			yorisoItemWrap.yorisoOptionItemWraps.remove(iIndex - 1);
			setYorisoItemIndex();
			calcShodanKingaku();
		}
	}

	private void setYorisoItemIndex(){
		Integer i = 1;
		for(YorisoOptionItemWrap aItemWrap : yorisoItemWrap.yorisoOptionItemWraps){
			aItemWrap.indexOptionItem = i;
			i++;
		}

		calcYorisoItemPrice();
	}

	public void setRyokinhyoYorisoOption(){
			Integer iIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('ojbIndex'));
			if(String.isBlank(yorisoItemWrap.yorisoOptionItemWraps.get(iIndex - 1).optionItemName)){
					yorisoItemWrap.yorisoOptionItemWraps.get(iIndex - 1).unitPriceCustom = 0;
			}else{
				String ShohinBango = yorisoItemWrap.yorisoOptionItemWraps.get(iIndex - 1).optionItemName;
				if(String.isNotBlank(ShohinBango)){
					planItemWrap.YorisoUPgradeSaidanFlg = false;
					List<String> theShohinBango = new List<String>();
					String StrOptionItemName = yorisoItemWrap.yorisoOptionItemWraps.get(iIndex - 1).optionItemName;
					if(YorisoUPgradeSaidanMap.containsKey(StrOptionItemName)){
						theShohinBango = YorisoUPgradeSaidanMap.get(StrOptionItemName);
					}
					if(theShohinBango.size() > 0){
						if( !theShohinBango.contains(planItemWrap.planShohinBango) ){
							planItemWrap.YorisoUPgradeSaidanFlg = true;
						}
					}
					yorisoItemWrap.yorisoOptionItemWraps.get(iIndex - 1).unitPriceCustom = YorisouPricebookEntryMap.get(ShohinBango).UnitPrice;
				}
			}
			
			calcYorisoItemPrice();
			calcShodanKingaku();
	}

	public void calcYorisoItemPrice(){

		yorisoItemWrap.YorisooptionItemAllTotalPrice = 0;
		for(YorisoOptionItemWrap aItemWrap : yorisoItemWrap.yorisoOptionItemWraps){
			if(aItemWrap.unitPriceCustom == null || aItemWrap.quantityCustom == null) aItemWrap.totalPriceCustom = 0;
			else aItemWrap.totalPriceCustom = aItemWrap.unitPriceCustom * aItemWrap.quantityCustom;

			yorisoItemWrap.YorisooptionItemAllTotalPrice += aItemWrap.totalPriceCustom;
		}
	}

	public void changePlanItem(){

		String planItemBango = Apexpages.currentPage().getParameters().get('planItemBango');

		Product2 planItem = [select Id, Name, ShohinBango__c, k_Service_Id_exp__c, LatestFlg__c from Product2 where ShohinBango__c = :planItemBango];

		planItemWrap.planShohinIdAfter = planItem.Id;
		planItemWrap.planShohinName = planItem.Name;
		planItemWrap.planShohinBango = planItem.ShohinBango__c;
		planItemWrap.planShohinServiceId = planItem.k_Service_Id_exp__c;
		planItemWrap.LatestFlg = planItem.LatestFlg__c;


		PriceBookDao.PriceBookEnt thePriceBookEnt = PriceBookDao.instance().getEntry(opportunityWrap.opportunity.PriceBook2Id, planItem.ShohinBango__c);
		planItemWrap.planShohinKingaku = thePriceBookEnt.UnitPrice;

		String jsonNebikiItems = '';
		List<Object> jsonNebikiItemObjs = new List<Object>();

		WrTkCtxs.ContextData theWaribikiContext = new WrTkCtxs().selectContextDataByOppIds( new List<String>{opportunityWrap.opportunity.Id} ).values().get(0);
		Set<String> theWaribikiShohinBangos = new WrTks().getWaribikiShohinBangos(theWaribikiContext, planItem.ShohinBango__c);
		Set<String> ButsuguNashiKiboShohinBango = new Set<String>();
		ButsuguNashiKiboShohinBango = new WrTkSdButsuguNashi().getWaribikiShohinBangos(planItemWrap.planShohinBango);

		if(ButsuguNashiKiboShohinBango.size() > 0){
			if(opportunityWrap.simpleYasugo.ButsuguNashiKibo__c == '仏具なし'){
				theWaribikiShohinBangos.addAll(ButsuguNashiKiboShohinBango);
			}else{
				theWaribikiShohinBangos.removeAll(ButsuguNashiKiboShohinBango);
			}
		}
		jsonNebikiItems = addWaribikiShouhin(theWaribikiShohinBangos);

		if(String.isNotBlank(jsonNebikiItems)){
			jsonNebikiItemObjs = (List<Object>) JSON.deserializeUntyped(jsonNebikiItems);
		}

		nebikiWrap.nebikiItemWraps = new List<NebikiItemWrap>();
		nebikiWrap.nebikiItemAllTotalPrice = 0;

		for(Object jsonNebikiItemObj : jsonNebikiItemObjs){
			Map<String, Object> jsonNebikiItemMap = (Map<String, Object>)jsonNebikiItemObj;

			String dataKubun = (String)jsonNebikiItemMap.get('data_kubun');
			String Strcode = (String)jsonNebikiItemMap.get('code');

				System.debug('jsonNebikiItemObj ' + jsonNebikiItemObj);

			if((dataKubun == '2:割引プラン') || (dataKubun == '3:クーポン') || (Strcode == 'SBG-0005420')){
				NebikiItemWrap nebikiItemWrap = new NebikiItemWrap();
				nebikiItemWrap.itemName = (String)jsonNebikiItemMap.get('label_formalname');
				nebikiItemWrap.itemPrice = (Decimal)jsonNebikiItemMap.get('unit_price');
				nebikiItemWrap.itemShohinBango = (String)jsonNebikiItemMap.get('code');
				if(dataKubun == '2:割引プラン') nebikiItemWrap.itemDataKubun = '割引';
				if(dataKubun == '3:クーポン') nebikiItemWrap.itemDataKubun = 'クーポン';
				if(Strcode == 'SBG-0005420') nebikiItemWrap.itemDataKubun = 'キャンペーン';
				if(Strcode == 'SBG-0000214') nebikiItemWrap.itemPrice = -2200;
				nebikiWrap.nebikiItemWraps.add(nebikiItemWrap);

				System.debug('label_formalname ' + (String)jsonNebikiItemMap.get('label_formalname'));

				nebikiWrap.nebikiItemAllTotalPrice += nebikiItemWrap.itemPrice;
			}

		}

		for(NebikiItemWrap aCouponItem : nebikiWrap.CouponItemWraps){
			nebikiWrap.nebikiItemWraps.add(aCouponItem);
			nebikiWrap.nebikiItemAllTotalPrice += aCouponItem.itemPrice;
		}

		chkYorisoUPgradeSaidan();
		
		addGMOTesuryo();

	}

	public String addWaribikiShouhin(Set<String> theWaribikiShohinBangos ) {

		String returnStrig = '';
		List<Data> ListWaribiki = new List<Data>();
		List<PricebookEntry> ListPricebookEntry = new List<PricebookEntry>();

		if(theWaribikiShohinBangos.size() > 0 ){
			ListPricebookEntry = [SELECT Id,
									Product2Id, 
									Product2.ShohinBango__c, 
									Product2.Name, 
									Product2.k_Service_Id_exp__c, 
									Product2.NameForCustomerExp__c, 
									UnitPrice, 
									Product2.DataKubun__c 
								FROM PricebookEntry
								WHERE Product2.ShohinBango__c IN :theWaribikiShohinBangos
								ORDER BY UnitPrice asc, Product2.Name asc];

			for(PricebookEntry aPricebookEntry :ListPricebookEntry){
				Data theData = new Data();
				theData.unit_price = aPricebookEntry.UnitPrice;
				theData.service_id = aPricebookEntry.Product2.k_Service_Id_exp__c;
				theData.label_formalname = aPricebookEntry.Product2.Name;
				theData.label = aPricebookEntry.Product2.NameForCustomerExp__c;
				theData.code = aPricebookEntry.Product2.ShohinBango__c;
				theData.data_kubun = aPricebookEntry.Product2.DataKubun__c;
				ListWaribiki.add(theData);
			}

			if(ListWaribiki.size() > 0){
				returnStrig = JSON.serialize(ListWaribiki);
			}
		}

		return returnStrig;

	}

	// addWaribikiShouhinで利用する商談商品の情報を格納するクラス
	public class Data{
		public Decimal unit_price = 0;
		public String service_id = '';
		public String label_formalname = '';
		public String label = '';
		public String code = '';
		public String waribiki_id = '';
		public String coupon_id = '';
		public String data_kubun = '';
	}

	
	// GOM後払い手数料設定処理
	public void addGMOTesuryo() {

		Set<String> GMOShohinBango = new Set<String>();
		String jsonNebikiItems = '';
		List<Object> jsonNebikiItemObjs = new List<Object>();

		if(opportunityWrap.opportunity.KiboShiharaiHouhou__c == '後払い（GMO）'){
			GMOShohinBango = new WrTkSdAtobarai().getWaribikiShohinBangos(planItemWrap.planShohinBango);
			jsonNebikiItems = addWaribikiShouhin(GMOShohinBango);
			if(String.isNotBlank(jsonNebikiItems)){
				jsonNebikiItemObjs = (List<Object>) JSON.deserializeUntyped(jsonNebikiItems);
				if(jsonNebikiItemObjs.size() > 0){
					Map<String, Object> jsonNebikiItemMap = (Map<String, Object>)jsonNebikiItemObjs[0];
					GMOWrap.itemName = (String)jsonNebikiItemMap.get('label_formalname');
					GMOWrap.itemShohinBango = (String)jsonNebikiItemMap.get('code');
					GMOWrap.GMOItemAllTotalPrice = (Decimal)jsonNebikiItemMap.get('unit_price');
				}else{
					GMOTesuryoShokika();
				}
			}else{
				GMOTesuryoShokika();
			}
		}else{
			GMOTesuryoShokika();
		}

		calcShodanKingaku();

	}

	// GOM後払い手数料初期化処理
	public void GMOTesuryoShokika() {
		GMOWrap.itemName = '';
		GMOWrap.itemShohinBango = '';
		GMOWrap.GMOItemAllTotalPrice = 0;
	}

	public void calcSeikyuKingaku(){
	
		String strkurekaGmo = String.valueOf(shiharaiWrap.kurekaGmo.okyakusamaSeikyuMeisai.SeikyuKingaku__c);
		String strkurekaOriko = String.valueOf(shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c); 
		String strloanOriko = String.valueOf(shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c);
		String strfurikomiOriko = String.valueOf(shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c);
		String strsosaiFujo = String.valueOf(shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c);
		String stratobaraiGmo = String.valueOf(shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai.SeikyuKingaku__c);
		String strososhikiyoyaku = String.valueOf(shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai.SeikyuKingaku__c);

		sfSeikyuKingaku = 0;
		sfSabunKingaku =0;

		if(shiharaiWrap.kurekaGmo.isRiyo){
			if(String.isNotBlank(strkurekaGmo)){
				sfSeikyuKingaku = shiharaiWrap.kurekaGmo.okyakusamaSeikyuMeisai.SeikyuKingaku__c;
			}
		}

		if(shiharaiWrap.kurekaOrikoWrap.isRiyo){
			if(String.isNotBlank(strkurekaOriko)){
				sfSeikyuKingaku = sfSeikyuKingaku + shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c;
			}
		}

		if(shiharaiWrap.loanOrikoWrap.isRiyo){
			if(String.isNotBlank(strloanOriko)){
				sfSeikyuKingaku = sfSeikyuKingaku + shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c;
			}
		}

		if(shiharaiWrap.furikomiOrikoWrap.isRiyo){
			if(String.isNotBlank(strfurikomiOriko)){
				sfSeikyuKingaku = sfSeikyuKingaku + shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c;
			}
		}

		if(shiharaiWrap.sosaiFujoWrap.isRiyo){
			if(String.isNotBlank(strsosaiFujo)){
				sfSeikyuKingaku = sfSeikyuKingaku + shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai.SeikyuKingaku__c;
			}
		}

		if(shiharaiWrap.atobaraiGmo.isRiyo){
			if(String.isNotBlank(stratobaraiGmo)){
				sfSeikyuKingaku = sfSeikyuKingaku + shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai.SeikyuKingaku__c;
			}
		}

		if(shiharaiWrap.ososhikiyoyaku.isRiyo){
			if(String.isNotBlank(strososhikiyoyaku)){
				sfSeikyuKingaku = sfSeikyuKingaku + shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai.SeikyuKingaku__c;
			}
		}

		sfSabunKingaku =  sfSeikyuKingaku - sfMitsumoriKingaku;
	}

	// issues4156--End-- 

	public void calcShodanKingaku(){
		
		sfMitsumoriKingaku = 0;

		sfMitsumoriKingaku = planItemWrap.planShohinKingaku + sogiItemWrap.optionItemAllTotalPrice + nebikiWrap.nebikiItemAllTotalPrice + GMOWrap.GMOItemAllTotalPrice + yorisoItemWrap.YorisooptionItemAllTotalPrice;

		sfSabunKingaku =  sfSeikyuKingaku - sfMitsumoriKingaku;
	}

	private void setOptionItemIndex(){
		Integer i = 1;
		for(OptionItemWrap aOptionItemWrap : sogiItemWrap.optionItemWraps){
			aOptionItemWrap.indexOptionItem = i;
			i++;
		}

		calcOptionItemPrice();
	}

	public void calcOptionItemPrice(){

		sogiItemWrap.optionItemAllTotalPrice = 0;
		for(OptionItemWrap aOptionItemWrap : sogiItemWrap.optionItemWraps){
			if(aOptionItemWrap.unitPriceCustom == null || aOptionItemWrap.unitPriceCustom == 0 || aOptionItemWrap.quantityCustom == null || aOptionItemWrap.quantityCustom == 0){
				aOptionItemWrap.totalPriceCustom = 0;
				if(aOptionItemWrap.unitPriceCustom == 0){ aOptionItemWrap.unitPriceCustom = null; }
			}else{ aOptionItemWrap.totalPriceCustom = aOptionItemWrap.unitPriceCustom * aOptionItemWrap.quantityCustom;}

			sogiItemWrap.optionItemAllTotalPrice += aOptionItemWrap.totalPriceCustom;
		}
	}

	public void doSave() {

		alertFlg = false;
		msg = '';

		opportunity OpportunityTesuryoKeisanzumiKakunin = new opportunity();
		OpportunityTesuryoKeisanzumiKakunin = [SELECT Id, TesuryoKeisanzumi__c FROM Opportunity WHERE Id = :opportunityWrap.opportunity.id];
		if(OpportunityTesuryoKeisanzumiKakunin.TesuryoKeisanzumi__c){
			msg = '手数料計算が実行されたため、見積入力フォームでは、データ保存できません。見積入力フォームの閉じるボタンを押下して、見積入力フォームを終了してください。';
			alertFlg = true;
			return;
		}

		Savepoint sp = Database.setSavepoint();

		shoriKekkaFlg = false;

		try{
			// List<Account> upsertAcc = new List<Account>();

			// issues4228--Start-- カレンダーのui表示の変更
			sodanshaWrap.sodansha.PersonDeathDate__pc = sodanshaWrap.sodanshaDeathDate;
			// issues4228--End--
			
			//  相談者情報の名前｛姓(漢字)名(漢字)｝が保存ボタン押下後、お客様・取引先に反映されないに伴う対応
			if(sodanshaWrap.sodanshaLastName != null && sodanshaWrap.sodanshaFirstName != ''){
				sodanshaWrap.sodansha.LastName = sodanshaWrap.sodanshaLastName;
				sodanshaWrap.sodansha.FirstName = sodanshaWrap.sodanshaFirstName;
			}
			// issues4228--End--

			// issues4228--Start-- 依頼人、対象者、喪主などで、重複データによるエラーの対応
			// upsertAcc.add(sodanshaWrap.sodansha);
			Database.SaveResult saveResultsodansha = Database.update(sodanshaWrap.sodansha, false);
			if (!saveResultsodansha.isSuccess()) {
				for (Database.Error error : saveResultsodansha.getErrors()) {
					if (error instanceof Database.DuplicateError) {
						msg += '\r\n依頼人情報が重複しています。マージをお願いします。';
						Database.DMLOptions dml = new Database.DMLOptions();
						dml.DuplicateRuleHeader.AllowSave = true;
						Database.SaveResult sr = Database.update(sodanshaWrap.sodansha, dml);
						alertFlg = true;
					}
				}
			}
			// issues4228--End--
			Account taishoshaTemp = new Account();
			if(taishoshaWrap.sodanshaOnajiFlg) {
				taishoshaTemp = sodanshaWrap.sodansha;
			}
			else if(taishoshaWrap.taishoshaLastName != null && taishoshaWrap.taishoshaLastName != ''){
				taishoshaWrap.taishosha.LastName = taishoshaWrap.taishoshaLastName;
				taishoshaWrap.taishosha.FirstName = taishoshaWrap.taishoshaFirstName;

				// issues4228--Start-- カレンダーのui表示の変更
				taishoshaWrap.taishosha.PersonDeathDate__pc = taishoshaWrap.taishoshaDeathDate;
				// issues4228--End--

				if(sodanshaWrap.sodansha.Id == taishoshaWrap.taishosha.Id) taishoshaTemp = taishoshaWrap.taishosha.clone(false, true);
				if(sodanshaWrap.sodansha.Id != taishoshaWrap.taishosha.Id) taishoshaTemp = taishoshaWrap.taishosha;

				// issues4228--Start-- 依頼人、対象者、喪主などで、重複データによるエラーの対応
				if(taishoshaWrap.taishosha.Id == null){
					Database.SaveResult insertResultsodansha = Database.insert(taishoshaTemp, false);
					if (!insertResultsodansha.isSuccess()) {
						for (Database.Error error : insertResultsodansha.getErrors()) {
							if (error instanceof Database.DuplicateError) {
								msg += '\r\n対象者情報が重複しています。マージをお願いします。';
								Database.DMLOptions dml = new Database.DMLOptions();
								dml.DuplicateRuleHeader.AllowSave = true;
								Database.SaveResult sr = Database.insert(taishoshaTemp, dml);
								alertFlg = true;
							}
						}
					}
				}else{
					Database.SaveResult updateResulttaishosha = Database.update(taishoshaTemp, false);
					if (!updateResulttaishosha.isSuccess()) {
						for (Database.Error error : updateResulttaishosha.getErrors()) {
							if (error instanceof Database.DuplicateError) {
								msg += '\r\n対象者情報が重複しています。マージをお願いします。';
								Database.DMLOptions dml = new Database.DMLOptions();
								dml.DuplicateRuleHeader.AllowSave = true;
								Database.SaveResult sr = Database.update(taishoshaTemp, dml);
								alertFlg = true;
							}
						}
					}
				}
				// issues4228--End--
			}

			Account moshuTemp = new Account();
			if(moshuWrap.sodanshaOnajiFlg) {
				moshuTemp = sodanshaWrap.sodansha;
			}
			else if(moshuWrap.moshuLastName != null && moshuWrap.moshuLastName != ''){
				moshuWrap.moshu.LastName = moshuWrap.moshuLastName;
				moshuWrap.moshu.FirstName = moshuWrap.moshuFirstName;

				if(sodanshaWrap.sodansha.Id == moshuWrap.moshu.Id) moshuTemp = moshuWrap.moshu.clone(false, true);
				if(sodanshaWrap.sodansha.Id != moshuWrap.moshu.Id) moshuTemp = moshuWrap.moshu;

				// issues4228--Start-- 依頼人、対象者、喪主などで、重複データによるエラーの対応
				if(moshuWrap.moshu.Id == null){
					Database.SaveResult insertResultmoshu = Database.insert(moshuTemp, false);
					if (!insertResultmoshu.isSuccess()) {
						for (Database.Error error : insertResultmoshu.getErrors()) {
							if (error instanceof Database.DuplicateError) {
								msg += '\r\n喪主情報が重複しています。マージをお願いします。';
								Database.DMLOptions dml = new Database.DMLOptions();
								dml.DuplicateRuleHeader.AllowSave = true;
								Database.SaveResult sr = Database.insert(moshuTemp, dml);
								alertFlg = true;
							}
						}
					}
				}else{
					Database.SaveResult updateResultmoshu = Database.update(moshuTemp, false);
					if (!updateResultmoshu.isSuccess()) {
						for (Database.Error error : updateResultmoshu.getErrors()) {
							if (error instanceof Database.DuplicateError) {
								msg += '\r\n喪主情報が重複しています。マージをお願いします。';
								Database.DMLOptions dml = new Database.DMLOptions();
								dml.DuplicateRuleHeader.AllowSave = true;
								Database.SaveResult sr = Database.update(moshuTemp, dml);
								alertFlg = true;
							}
						}
					}
				}
				// issues4228--End--
			}

			List<OpportunityLineItem> upsertOppLineItems = new List<OpportunityLineItem>();

			// issues4228--Start-- 商談商品について、ユーザが変更した商品のみを更新する対応
			if(planItemWrap.planShohinIdBefore != planItemWrap.planShohinIdAfter) {

				// 保存ボタンの処理にて、保存時にこのロジックで落ちているため、改修する
				List<OpportunityLineItem> delPlanItems = new List<OpportunityLineItem>();
				
				// issues4156--Start-- 
				// 葬儀プランが以下のように変更された場合には、登録されている商談商品のデータをすべて削除する
				// 1.旧プランから新プランへの変更
				// 2.新プランから旧プランへの変更
				// 3.シンプルなお葬式から安くて豪華なお葬式への変更
				// 4.安くて豪華なお葬式からシンプルなお葬式への変更
				if((planItemWrap.LatestFlgBefore != planItemWrap.LatestFlg) || 
					(planItemWrap.planShohinServiceIdBefore != planItemWrap.planShohinServiceId)){
					delPlanItems = [select Id, OpportunityId from OpportunityLineItem where OpportunityId = :opportunityId];
					beforeoptionItemWraps = new List<OptionItemWrap>();
				
				}else{

				// 上記以外の葬儀プラン変更の場合には、葬儀プラン、割引 ＆ クーポン、GMO後払い手数料にて登録されている商談商品のデータを削除する
					delPlanItems = [select Id, OpportunityId from OpportunityLineItem where OpportunityId = :opportunityId and 
									(Product2.k_ShohinSyubetsu_Id_exp__c = '1' or
									Product2.ShohinBango__c = 'SBG-0003620' or 
									// issues4156--Start-- 
									// アライアンス対象のデータも削除するために追加
									Product2.ShohinBango__c = 'SBG-0003537' or 
									Product2.ShohinBango__c = 'SBG-0003538' or 
									// 後払いご利用料金のデータも削除するために追加
									Product2.ShohinBango__c = 'SBG-0002010' or 
									Product2.ShohinBango__c = 'SBG-0002011' or 
									// キャンペーンのデータも削除するために追加
									Product2.ShohinBango__c = 'SBG-0005420' or 
									// issues4156--End-- 
									Product2.DataKubun__c = '2:割引プラン' 
									)];
				}
				// issues4156--End-- 


				for(OpportunityLineItem delPlan :delPlanItems){
					delOpportunityLineItems.add(delPlan);
				}

				// 新しい葬儀プランの登録
				upsertOppLineItems.add(new OpportunityLineItem(
											OpportunityId = opportunityId,
											Product2Id = planItemWrap.planShohinIdAfter, 
											Quantity = 1
										)
									);

				System.debug('upsertOppLineItems:' + upsertOppLineItems);
			}else{
				if(opportunityWrap.simpleYasugo.ButsuguNashiKibo__c != ShokiJyotaiButsuguNashiKibo){
					if(opportunityWrap.simpleYasugo.ButsuguNashiKibo__c == '仏具なし'){
						List<PricebookEntry> ButsugunashiEntry = new List<PricebookEntry>();
						ButsugunashiEntry = [SELECT Id,
												Product2Id, 
												Product2.ShohinBango__c, 
												Product2.Name, 
												Product2.k_Service_Id_exp__c, 
												Product2.NameForCustomerExp__c, 
												UnitPrice, 
												Product2.DataKubun__c 
											FROM PricebookEntry
											WHERE Product2.ShohinBango__c = 'SBG-0005108'];
						if(ButsugunashiEntry.size() > 0){
							upsertOppLineItems.add(new OpportunityLineItem(
														OpportunityId = opportunityId,
														Product2Id = ButsugunashiEntry[0].Product2Id,
														UnitPrice = ButsugunashiEntry[0].UnitPrice,
														Quantity = 1
													)
												);
						}
					}else{
						List<OpportunityLineItem> delButsugunashiItems = new List<OpportunityLineItem>();
						delButsugunashiItems = [select Id, 
														OpportunityId 
												from OpportunityLineItem 
												where OpportunityId = :opportunityId 
												and Product2.ShohinBango__c = 'SBG-0005108'];
						for(OpportunityLineItem delButsugunashi :delButsugunashiItems){
							delOpportunityLineItems.add(delButsugunashi);
						}
					}
				}
			}

			Integer i = 0;
	   		Map<String, Product2> hinmokuProductMap = new Map<String, Product2>();
	   		for(OptionItemWrap optItemWrap : sogiItemWrap.optionItemWraps) {
				
				// 保存ボタンの処理にて、オプションの品目に値なし、単価に値なし、個数に値なし、単価が「０」、個数が「０」の場合エラーが発生するための改修
				Boolean boptionItemName = String.isBlank(optItemWrap.optionItemName);
				Boolean bUnitPrice = String.isBlank(optItemWrap.unitPriceCustom.toPlainString());
				Boolean bQuantity = String.isBlank(optItemWrap.quantityCustom.toPlainString());
				Integer intUnitPrice = optItemWrap.unitPriceCustom.intValue();
				Integer intQuantity = optItemWrap.quantityCustom.intValue();

				if (boptionItemName || bUnitPrice || bQuantity || intUnitPrice == 0 || intQuantity == 0){

					OpportunityLineItem delOli = optItemWrap.opportunityLineItem;
					if(delOli.Id != null) delOpportunityLineItems.add(delOli);

					i = i + 1;

					continue;

				}

				if(planItemWrap.LatestFlg){
					hinmokuProductMap = serviceIdHinmokuPrductMap.get(planItemWrap.planShohinServiceId);
				}else{
					hinmokuProductMap = oldserviceIdHinmokuPrductMap.get(planItemWrap.planShohinServiceId);
				}

				Product2 productTemp = new Product2();

				if(hinmokuProductMap.containsKey(optItemWrap.optionItemName)) productTemp = hinmokuProductMap.get(optItemWrap.optionItemName);
				else productTemp = hinmokuProductMap.get('その他オプション');

				OpportunityLineItem addOpportunityLineItem = new OpportunityLineItem();
				if(beforeoptionItemWraps.size() > 0){
					if(i <  beforeoptionItemWraps.size()){
						if(optItemWrap.optionItemName != beforeoptionItemWraps.get(i).optionItemName){
							
							OpportunityLineItem delOli2 = optItemWrap.opportunityLineItem;
							if(delOli2.Id != null) delOpportunityLineItems.add(delOli2);
							
							addOpportunityLineItem.OpportunityId = opportunityId;
							addOpportunityLineItem.Product2Id = productTemp.Id;
							addOpportunityLineItem.UnitPrice = optItemWrap.unitPriceCustom;
							addOpportunityLineItem.Quantity = optItemWrap.quantityCustom;
							upsertOppLineItems.add(addOpportunityLineItem);

						}else if(optItemWrap.unitPriceCustom != beforeoptionItemWraps.get(i).unitPriceCustom){

							addOpportunityLineItem.id = optItemWrap.OptionItemid;
							addOpportunityLineItem.UnitPrice = optItemWrap.unitPriceCustom;
							addOpportunityLineItem.Quantity = optItemWrap.quantityCustom;
							upsertOppLineItems.add(addOpportunityLineItem);

						}else if(optItemWrap.quantityCustom != beforeoptionItemWraps.get(i).quantityCustom){

							addOpportunityLineItem.id = optItemWrap.OptionItemid;
							addOpportunityLineItem.UnitPrice = optItemWrap.unitPriceCustom;
							addOpportunityLineItem.Quantity = optItemWrap.quantityCustom;
							upsertOppLineItems.add(addOpportunityLineItem);

						}
					}
				}
				if(i >= beforeoptionItemWraps.size()){
					addOpportunityLineItem.OpportunityId = opportunityId;
					addOpportunityLineItem.Product2Id = productTemp.Id;
					addOpportunityLineItem.UnitPrice = optItemWrap.unitPriceCustom;
					addOpportunityLineItem.Quantity = optItemWrap.quantityCustom;
					upsertOppLineItems.add(addOpportunityLineItem);
				}

				i = i + 1;
			}
			// issues4228--End--

		// よりそうオプション設定
		Integer k = 0;
		for(YorisoOptionItemWrap aOptionItem : yorisoItemWrap.yorisoOptionItemWraps) {

			// 保存ボタンの処理にて、オプションの品目に値なし、個数に値なし、個数が「０」の場合、データの削除処理
			Boolean boptionItemName = String.isBlank(aOptionItem.optionItemName);
			Boolean bQuantity = String.isBlank(aOptionItem.quantityCustom.toPlainString());
			Integer intQuantity = aOptionItem.quantityCustom.intValue();

			if (boptionItemName || bQuantity || intQuantity == 0){

				OpportunityLineItem delOli = aOptionItem.opportunityLineItem;
				if(delOli.Id != null) delOpportunityLineItems.add(delOli);

				k = k + 1;

				continue;

			}

			String ShohinBango = aOptionItem.optionItemName;
			PricebookEntry aProduct = new PricebookEntry();
			if(String.isNotBlank(ShohinBango)){
				aProduct= YorisouPricebookEntryMap.get(ShohinBango);
			}

			OpportunityLineItem addYorisoLineItem = new OpportunityLineItem();
			if(beforeyorisoItemWraps.size() > 0){
				if(k <  beforeyorisoItemWraps.size()){
					if(aOptionItem.optionItemName != beforeyorisoItemWraps.get(k).optionItemName){

						OpportunityLineItem delOli2 = aOptionItem.opportunityLineItem;
						if(delOli2.Id != null) delOpportunityLineItems.add(delOli2);

						addYorisoLineItem.OpportunityId = opportunityId;
						addYorisoLineItem.Product2Id = aProduct.Product2Id;
						addYorisoLineItem.UnitPrice = aOptionItem.unitPriceCustom;
						addYorisoLineItem.Quantity = aOptionItem.quantityCustom;
						upsertOppLineItems.add(addYorisoLineItem);

					}else if(aOptionItem.quantityCustom != beforeyorisoItemWraps.get(k).quantityCustom){
						addYorisoLineItem.id = aOptionItem.OptionItemid;
						addYorisoLineItem.UnitPrice = aOptionItem.unitPriceCustom;
						addYorisoLineItem.Quantity = aOptionItem.quantityCustom;
						upsertOppLineItems.add(addYorisoLineItem);

					}
				}

			}
			if(k >= beforeyorisoItemWraps.size()){
				addYorisoLineItem.OpportunityId = opportunityId;
				addYorisoLineItem.Product2Id = aProduct.Product2Id;
				addYorisoLineItem.UnitPrice = aOptionItem.unitPriceCustom;
				addYorisoLineItem.Quantity = aOptionItem.quantityCustom;
				upsertOppLineItems.add(addYorisoLineItem);
			}

			k = k + 1;
		}
			


			// issues4228--Start-- 「System.LimitException: Too many SOQL queries: 101」エラー対応
			List<String> ListDelOppLineItems = new List<String>();
			if(delOpportunityLineItems.size() > 0){
				for(OpportunityLineItem delItem :delOpportunityLineItems){
					ListDelOppLineItems.add(delItem.Id);
				}
			}

			Integer j = 0;
			List<Integer> ListIntCut = new List<Integer>();
			Map<Integer,String> MapUpId = new Map<Integer,String>();
			Map<Integer,String> MapUpProduct2Id = new Map<Integer,String>();
			Map<Integer,Decimal> MapUpunitPriceCustom = new Map<Integer,Decimal> ();
			Map<Integer,Decimal> MapUpquantityCustom = new Map<Integer,Decimal>(); 
			if(upsertOppLineItems.size() > 0){
				for(OpportunityLineItem upItem :upsertOppLineItems){
					ListIntCut.add(j);
					if(String.isNotBlank(upItem.id)){
						MapUpId.put(j,upItem.Id);
					}else{
						MapUpProduct2Id.put(j,upItem.Product2Id);
					}
					MapUpunitPriceCustom.put(j,upItem.UnitPrice);
					MapUpquantityCustom.put(j,upItem.Quantity);
					j = j + 1;
				}
			}

			updateOpportunityLineItem(opportunityId,ListDelOppLineItems,ListIntCut,MapUpId,MapUpProduct2Id,MapUpunitPriceCustom,MapUpquantityCustom);

			// issues4228--End--
			
			List<OkyakusamaSeikyuMeisai__c> delOkyakusamaSeikyuMeisais = new List<OkyakusamaSeikyuMeisai__c>();
			List<OkyakusamaSeikyuMeisai__c> upstOkyakusamaSeikyuMeisais = new List<OkyakusamaSeikyuMeisai__c>();

			if(shiharaiWrap.kurekaOrikoWrap.isRiyo && chkOkyakusamaSeikyuMeisaiIsChange(shiharaiWrap.kurekaOrikoWrap.beforeOkyakusamaSeikyuMeisai, shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai)) upstOkyakusamaSeikyuMeisais.add(shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai);
			else if(!shiharaiWrap.kurekaOrikoWrap.isRiyo && shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai.Id != null) delOkyakusamaSeikyuMeisais.add(shiharaiWrap.kurekaOrikoWrap.okyakusamaSeikyuMeisai);

			if(shiharaiWrap.loanOrikoWrap.isRiyo && chkOkyakusamaSeikyuMeisaiIsChange(shiharaiWrap.loanOrikoWrap.beforeOkyakusamaSeikyuMeisai, shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai)) upstOkyakusamaSeikyuMeisais.add(shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai);
			else if(!shiharaiWrap.loanOrikoWrap.isRiyo && shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai.Id != null) delOkyakusamaSeikyuMeisais.add(shiharaiWrap.loanOrikoWrap.okyakusamaSeikyuMeisai);

			if(shiharaiWrap.furikomiOrikoWrap.isRiyo && chkOkyakusamaSeikyuMeisaiIsChange(shiharaiWrap.furikomiOrikoWrap.beforeOkyakusamaSeikyuMeisai, shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai)) upstOkyakusamaSeikyuMeisais.add(shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai);
			else if(!shiharaiWrap.furikomiOrikoWrap.isRiyo && shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai.Id != null) delOkyakusamaSeikyuMeisais.add(shiharaiWrap.furikomiOrikoWrap.okyakusamaSeikyuMeisai);

			if(shiharaiWrap.sosaiFujoWrap.isRiyo && chkOkyakusamaSeikyuMeisaiIsChange(shiharaiWrap.sosaiFujoWrap.beforeOkyakusamaSeikyuMeisai, shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai)) upstOkyakusamaSeikyuMeisais.add(shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai);
			else if(!shiharaiWrap.sosaiFujoWrap.isRiyo && shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai.Id != null) delOkyakusamaSeikyuMeisais.add(shiharaiWrap.sosaiFujoWrap.okyakusamaSeikyuMeisai);

			if(shiharaiWrap.atobaraiGmo.isRiyo && chkOkyakusamaSeikyuMeisaiIsChange(shiharaiWrap.atobaraiGmo.beforeOkyakusamaSeikyuMeisai, shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai)) upstOkyakusamaSeikyuMeisais.add(shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai);
			else if(!shiharaiWrap.atobaraiGmo.isRiyo && shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai.Id != null) delOkyakusamaSeikyuMeisais.add(shiharaiWrap.atobaraiGmo.okyakusamaSeikyuMeisai);

			if(shiharaiWrap.ososhikiyoyaku.isRiyo && chkOkyakusamaSeikyuMeisaiIsChange(shiharaiWrap.ososhikiyoyaku.beforeOkyakusamaSeikyuMeisai, shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai)) upstOkyakusamaSeikyuMeisais.add(shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai);
			else if(!shiharaiWrap.ososhikiyoyaku.isRiyo && shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai.Id != null) delOkyakusamaSeikyuMeisais.add(shiharaiWrap.ososhikiyoyaku.okyakusamaSeikyuMeisai);

			if(delOkyakusamaSeikyuMeisais.size() > 0) delete delOkyakusamaSeikyuMeisais;
			if(upstOkyakusamaSeikyuMeisais.size() > 0) upsert upstOkyakusamaSeikyuMeisais;

			// issues4228--Start-- カレンダーのui表示の変更
			if(opportunityWrap.tsuyaYMD != null){
				opportunityWrap.simpleYasugo.TsuyaDateTime_Inp__c = opportunityWrap.tsuyaYMD;
			}
			else opportunityWrap.simpleYasugo.TsuyaDateTime_Inp__c = null;

			if(opportunityWrap.kokubetsushikiYMD != null){
				opportunityWrap.simpleYasugo.KokubetsuDateTime_Inp__c = opportunityWrap.kokubetsushikiYMD;
			}
			else opportunityWrap.simpleYasugo.KokubetsuDateTime_Inp__c = null;

			if(opportunityWrap.kasoYMD != null){
				opportunityWrap.simpleYasugo.KasoDateTime_Inp__c = opportunityWrap.kasoYMD;
			}
			else opportunityWrap.simpleYasugo.KasoDateTime_Inp__c = null;

			if(opportunityWrap.MitsumorijuryoDay != null){
				opportunityWrap.simpleYasugo.MitsumorijuryoDay__c = opportunityWrap.MitsumorijuryoDay; 
			}
			else opportunityWrap.simpleYasugo.MitsumorijuryoDay__c = null;

			if(opportunityWrap.SoryoTehaiIraishoJuryobi != null){
				opportunityWrap.simpleYasugo.SoryoTehaiIraishoJuryobi__c = opportunityWrap.SoryoTehaiIraishoJuryobi; 
			}
			else opportunityWrap.simpleYasugo.SoryoTehaiIraishoJuryobi__c = null;

			if(opportunityWrap.SeikyushojuryoDay != null){
				opportunityWrap.simpleYasugo.SeikyushojuryoDay__c = opportunityWrap.SeikyushojuryoDay; 
			}
			else opportunityWrap.simpleYasugo.SeikyushojuryoDay__c = null;
			// issues4228--End--

			update opportunityWrap.simpleYasugo;

			if(pahseWrap.phaseValue != 'その他'){
				opportunityWrap.opportunity.StageName = pahseWrap.phaseValue;
				opportunityWrap.opportunity.SubPhase__c = pahseWrap.subPhaseValue;
			}

			// issues4156--Start-- 
			if(opportunityWrap.kasoYMD != null){
				opportunityWrap.opportunity.Utiagebi__c = opportunityWrap.kasoYMD.date();
			}
			// issues4156--End-- 
			update opportunityWrap.opportunity;

			shoriKekkaFlg = true;

			if((taishoshaTemp.Id != null && taishoshaTemp.Id != beforeSimpleYasugo.TaishoshaRef__c) || 
				(moshuTemp.Id != null && moshuTemp.Id != beforeSimpleYasugo.MoshuRef__c)){
				updateSimpleyasugo(opportunityWrap.simpleYasugo.Id, taishoshaTemp.Id, moshuTemp.Id);
			}
		}
		catch(DmlException e){
			System.debug('e.getLineNumber():' + e.getLineNumber());
			System.debug('e.getMessage():' + e.getMessage());

			List<String> msgList = e.getMessage().split(',');
			String errMsg = msgList.size() > 1 ? msgList.get(1) : '';
			ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, errMsg + ' lineNumber:' + String.valueOf(e.getLineNumber())); 
			ApexPages.addMessage(message);
			
			Database.rollback(sp);

		}
		catch(Exception e){
			System.debug('e.getLineNumber():' + e.getLineNumber());
			System.debug('e.getMessage():' + e.getMessage());

			ApexPages.Message message = new ApexPages.Message( ApexPages.severity.ERROR, 'システムエラーが発生しました。開発者に通知されました。'); 
			ApexPages.addMessage(message);

			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20200508-1744-01', 'SogiMitsumoriNyuryokuFormCtl','見積入力画面でエラーが発生しました。')
					.putAttr('e.getMessage()',e.getMessage())
					.putAttr('e.getLineNumber()',String.valueOf(e.getLineNumber()))
				//  issues4217--Start--
					.putAttr('e.getStackTraceString()',String.valueOf(e.getStackTraceString()))
					.putAttr('e.getTypeNmae()',String.valueOf(e.getTypeName()))
				//  issues4217--End--
			);

			Database.rollback(sp);

		}
	}

	private Boolean chkOkyakusamaSeikyuMeisaiIsChange(OkyakusamaSeikyuMeisai__c before, OkyakusamaSeikyuMeisai__c after){
		System.debug('before:' + before);
		System.debug('after:' + after);
		if(before == null && after == null) return false;
		if(before == null || after == null) return true;

		if(before.SeikyuKingaku__c != after.SeikyuKingaku__c) return true;
		if(before.Kessaibi__c != after.Kessaibi__c) return true;
		if(before.SeikyuStatus__c != after.SeikyuStatus__c) return true;
		if(before.SousaiSakiShodanRef__c != after.SousaiSakiShodanRef__c) return true;
		return false;
	}

	@RemoteAction
	public static list<Product2> rmtActGetPlanShohin(String pParam) {
		list<Product2> product2List = new list<Product2>();
		if(pParam != '') {
			String soql = 'SELECT Id,Name,ShohinBango__c FROM Product2 ';
			soql += '	   	WHERE k_Service_Id_exp__c in (\'1\',\'2\') ';
			soql += '			AND k_ShohinSyubetsu_Id_exp__c = \'1\'';
			soql += '			AND Name Like \'%' + pParam + '%\'';
			soql += '			AND HanbaiKaishiBi__c >= 2020-10-01 ';
			soql += '		   ORDER BY LatestFlg__c DESC ,HanbaiKaishiBi__c DESC NULLS LAST , Name ASC';
			soql += '		   LIMIT 10';
			product2List = database.query(soql);
		}
		return product2List;
	}

	@RemoteAction
	public static PostalCodeSearchCtl.Result getJSONByPostCD(String postalCode){
		PostalCodeSearchCtl.Result resultAddress = new PostalCodeSearchCtl().getJSONByPostCD(postalCode);
		return resultAddress;
	}

	@future
	public static void updateSimpleyasugo(String simpleId, String taishoshaId, String moshuId){
		update new SimpleYasugo__c(Id = simpleId, TaishoshaRef__c = taishoshaId, MoshuRef__c = moshuId);
	}

	// issues4228--Start-- 「System.LimitException: Too many SOQL queries: 101」エラー対応
	@future
	public static void updateOpportunityLineItem(String OppId, List<String> ListDelOppLineItems, List<Integer> ListIntCut, Map<Integer,String> MapUpId, Map<Integer,String> MapUpProduct2Id , Map<Integer,Decimal> MapUpunitPriceCustom, Map<Integer,Decimal> MapUpquantityCustom ){

		try{

			if(ListDelOppLineItems.size() > 0){
				List<OpportunityLineItem> delOpportunityLineItems = new List<OpportunityLineItem>();
				delOpportunityLineItems = [select Id from OpportunityLineItem where Id in :ListDelOppLineItems];
				if(delOpportunityLineItems.size() > 0){
					delete delOpportunityLineItems;
				}
			}
	
			if(ListIntCut.size() > 0){
				List<OpportunityLineItem> upsertOppLineItems = new List<OpportunityLineItem>();
				for(Integer IntCut : ListIntCut) {
					OpportunityLineItem addOpportunityLineItem = new OpportunityLineItem();
					if(String.isNotBlank(MapUpId.get(IntCut))){
						addOpportunityLineItem.Id = MapUpId.get(IntCut);
					}else{
						addOpportunityLineItem.OpportunityId = OppId;
						addOpportunityLineItem.Product2Id = MapUpProduct2Id.get(IntCut);
					}
					addOpportunityLineItem.UnitPrice = MapUpunitPriceCustom.get(IntCut);
					addOpportunityLineItem.Quantity = MapUpquantityCustom.get(IntCut);
					upsertOppLineItems.add(addOpportunityLineItem);
				}
				if(upsertOppLineItems.size() > 0){
					OpportunityLineItemCheck.is_kyu_shohin_protect_enabled = false;
					upsert upsertOppLineItems;
					OpportunityLineItemCheck.is_kyu_shohin_protect_enabled = true;
				}
			}

		}catch(Exception ex){
			Loggings.writeLog(
				Loggings.createLogEntry(
					Loggings.Level.Error, '20210301-1203', 'SogiMitsumoriNyuryokuFormCtl.updateOpportunityLineItem')
					.putAttr('ex.getTypeName()', ex.getTypeName() )
					.putAttr('ex.getMessage()', ex.getMessage())
					.putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
					.putAttr('ex.getStackTraceString', ex.getStackTraceString())
			);
		}
	}
	// issues4228--End--

	public class Addres{
		public String name {get; set;}
		public String post_code {get; set;}
		public String todofuken {get; set;}
		public String shikugun {get; set;}
		public String tyoumei {get; set;}
	}

	@RemoteAction
	public static List<Addres> searchAddress(String SearchString){

		List<Addres> returnAddres = new List<Addres>();
		List<Ken_all__c> Ken_allList = new List<Ken_all__c>();
		if(String.isNotBlank(SearchString)){
			List<List<sObject>>SearchList = new List<List<sObject>>();
			String StrSearch = '';
			StrSearch = '*' + SearchString + '*';
			SearchList = [FIND :StrSearch IN ALL FIELDS RETURNING Ken_all__c(post_code__c, todofuken__c, shikugun__c, tyoumei__c order by name ASC,post_code__c ASC, todofuken__c ASC , shikugun__c ASC , tyoumei__c ASC NULLS LAST) limit 10 ];
			Ken_allList = searchList[0];
		}

		for(Ken_all__c aKen :Ken_allList){
			Addres aAddres = new Addres();
			aAddres.post_code = add_zero_padding_if_not(aKen.post_code__c);
			aAddres.todofuken = aKen.todofuken__c;
			aAddres.shikugun = aKen.shikugun__c;
			aAddres.tyoumei = aKen.tyoumei__c;
			aAddres.name = aAddres.post_code + ' ' + aAddres.todofuken + ' ' + aAddres.shikugun + ' ' + aAddres.tyoumei;
			returnAddres.add(aAddres);
		}
		return returnAddres;
	}

	private static String add_zero_padding_if_not(String p_postal_code){
		String returnPostalCode = '';
		if(p_postal_code.length() == 6){
			returnPostalCode = '0' + p_postal_code;
		}else if(p_postal_code.length() == 5){
			returnPostalCode = '00' + p_postal_code;
		}else{
			returnPostalCode = p_postal_code;
		}
		return returnPostalCode;
	}

}