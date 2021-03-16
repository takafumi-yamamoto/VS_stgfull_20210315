/**
 * 墓ピタのサービスビルダー
 */
public class Ctl_OpportunityToHakapitaBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToHakapitaBuilder() {
        opps = new List<Opportunity>();
    }   
    public void addOpp(Opportunity opp) {
        opps.add(opp);
    }    
    
    public List<Dto_OpportunityServicePair> getOpportunityServicePairList() {
		List<Dto_OpportunityServicePair> pairList = new List<Dto_OpportunityServicePair>();
		set<id> caseIdset = new set<id>();
		for(Opportunity opp : opps) {
			caseIdset.add(opp.CaseRef__c);
		}
		map<id,case> caseMap=new map<id,case>([select id,
		                                              accountid,
		                                              //希望エリア都道府県
                                                      KiboAreaState__c,
		                                              //希望エリア市区群
                                                      KiboAreaCity__c,
                                                      //宗派
                                                      Shuha__c,
                                                      Description,
                                                      recordtypeid                                           
                                                      //お墓の種類
                                                      //ご遺骨について
                                                      //こだわり条件
                                                      //ご予算
                                                      //備考
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            Hakapita__c service = new Hakapita__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
            	// 希望エリア
            	//service.KiboAreaRef__c = getKiboAreaId(c.KiboAreaState__c, c.KiboAreaCity__c);
                //宗旨・宗派
                service.Religion__c = c.Shuha__c;
              //お墓の種類
              //ご遺骨について
              //こだわり条件
              //ご予算
              //service.Budget__c= c.Shuha__c?
              //備考         
              //
              
              //墓ピタWeb受付の場合
              if (c.recordtypeid==RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','HakapitaWebForm')){
                 	DataHakapita theData = (DataHakapita)JSON.deserialize(c.Description, DataHakapita.class);
                  	service.Status__c = '新規'; 
                  	service.StageName__c='問合せ受付';
					 //メール処理Id
					service.Uniq_Id__c = theData.uniq_id;
					//入口
					service.Entrance__c= Api_V1_ItemValueMaster.getEntrance(theData.entrance);
					//最終見学日
					service.Lasttourday__c= Com_Utility.toDate(theData.last_tour_day);
					//申込者
					service.SodansyaRef__c= c.accountid;
					//資料請求_依頼先霊園01
					service.Siryoseikyu_Requestcemetery01__c= theData.siryoseikyu_requestcemetery01;
					//資料請求_依頼先霊園02
					service.Siryoseikyu_Requestcemetery02__c= theData.siryoseikyu_requestcemetery02;
					//資料請求_依頼先霊園03
					service.Siryoseikyu_Requestcemetery03__c= theData.siryoseikyu_requestcemetery03;
					//資料請求_依頼先霊園04
					service.Siryoseikyu_Requestcemetery04__c= theData.siryoseikyu_requestcemetery04;
					//資料請求_依頼先霊園05
					service.Siryoseikyu_Requestcemetery05__c= theData.siryoseikyu_requestcemetery05;
					//資料請求_依頼先霊園06
					service.Siryoseikyu_Requestcemetery06__c= theData.siryoseikyu_requestcemetery06;
					//資料請求_依頼先霊園07
					service.Siryoseikyu_Requestcemetery07__c= theData.siryoseikyu_requestcemetery07;
					//資料請求_依頼先霊園08
					service.Siryoseikyu_Requestcemetery08__c= theData.siryoseikyu_requestcemetery08;
					//資料請求_依頼先霊園09
					service.Siryoseikyu_Requestcemetery09__c= theData.siryoseikyu_requestcemetery09;
					//資料請求_依頼先霊園10
					service.Siryoseikyu_Requestcemetery10__c= theData.siryoseikyu_requestcemetery10;
					//資料請求_依頼先霊園11
					service.Siryoseikyu_Requestcemetery11__c= theData.siryoseikyu_requestcemetery11;
					//資料請求_依頼先霊園12
					service.Siryoseikyu_Requestcemetery12__c= theData.siryoseikyu_requestcemetery12;
					//資料請求_依頼先霊園13
					service.Siryoseikyu_Requestcemetery13__c= theData.siryoseikyu_requestcemetery13;
					//資料請求_依頼先霊園14
					service.Siryoseikyu_Requestcemetery14__c= theData.siryoseikyu_requestcemetery14;
					//資料請求_依頼先霊園15
					service.Siryoseikyu_Requestcemetery15__c= theData.siryoseikyu_requestcemetery15;
					//資料請求_依頼先霊園16
					service.Siryoseikyu_Requestcemetery16__c= theData.siryoseikyu_requestcemetery16;
					//資料請求_依頼先霊園17
					service.Siryoseikyu_Requestcemetery17__c= theData.siryoseikyu_requestcemetery17;
					//資料請求_依頼先霊園18
					service.Siryoseikyu_Requestcemetery18__c= theData.siryoseikyu_requestcemetery18;
					//資料請求_依頼先霊園19
					service.Siryoseikyu_Requestcemetery19__c= theData.siryoseikyu_requestcemetery19;
					//資料請求_依頼先霊園20 
					service.Siryoseikyu_Requestcemetery20__c= theData.siryoseikyu_requestcemetery20;
					//資料請求_依頼先霊園21
					service.Siryoseikyu_Requestcemetery21__c= theData.siryoseikyu_requestcemetery21;
					//資料請求_依頼先霊園22
					service.Siryoseikyu_Requestcemetery22__c= theData.siryoseikyu_requestcemetery22;
					//資料請求_依頼先霊園23
					service.Siryoseikyu_Requestcemetery23__c= theData.siryoseikyu_requestcemetery23;
					//資料請求_依頼先霊園24
					service.Siryoseikyu_Requestcemetery24__c= theData.siryoseikyu_requestcemetery24;
					//資料請求_依頼先霊園25
					service.Siryoseikyu_Requestcemetery25__c= theData.siryoseikyu_requestcemetery25;
					//資料請求_依頼先霊園26
					service.Siryoseikyu_Requestcemetery26__c= theData.siryoseikyu_requestcemetery26;
					//資料請求_依頼先霊園27
					service.Siryoseikyu_Requestcemetery27__c= theData.siryoseikyu_requestcemetery27;
					//資料請求_依頼先霊園28
					service.Siryoseikyu_Requestcemetery28__c= theData.siryoseikyu_requestcemetery28;
					//資料請求_依頼先霊園29
					service.Siryoseikyu_Requestcemetery29__c= theData.siryoseikyu_requestcemetery29;
					//資料請求_依頼先霊園30
					service.Siryoseikyu_Requestcemetery30__c= theData.siryoseikyu_requestcemetery30;
					//資料請求_対応石材店01
					service.Siryoseikyu_RequestStoneShop01__c= theData.siryoseikyu_requestStoneShop01;
					//資料請求_対応石材店02
					service.Siryoseikyu_RequestStoneShop02__c= theData.siryoseikyu_requestStoneShop02;
					//資料請求_対応石材店03
					service.Siryoseikyu_RequestStoneShop03__c= theData.siryoseikyu_requestStoneShop03;
					//資料請求_対応石材店04
					service.Siryoseikyu_RequestStoneShop04__c= theData.siryoseikyu_requestStoneShop04;
					//資料請求_対応石材店05
					service.Siryoseikyu_RequestStoneShop05__c= theData.siryoseikyu_requestStoneShop05;
					//資料請求_対応石材店06
					service.Siryoseikyu_RequestStoneShop06__c= theData.siryoseikyu_requestStoneShop06;
					//資料請求_対応石材店07
					service.Siryoseikyu_RequestStoneShop07__c= theData.siryoseikyu_requestStoneShop07;
					//資料請求_対応石材店08
					service.Siryoseikyu_RequestStoneShop08__c= theData.siryoseikyu_requestStoneShop08;
					//資料請求_対応石材店09
					service.Siryoseikyu_RequestStoneShop09__c= theData.siryoseikyu_requestStoneShop09; 
					//資料請求_対応石材店10
					service.Siryoseikyu_RequestStoneShop10__c= theData.siryoseikyu_requestStoneShop10;
					//資料請求_対応石材店11
					service.Siryoseikyu_RequestStoneShop11__c= theData.siryoseikyu_requestStoneShop11;
					//資料請求_対応石材店12
					service.Siryoseikyu_RequestStoneShop12__c= theData.siryoseikyu_requestStoneShop12;
					//資料請求_対応石材店13
					service.Siryoseikyu_RequestStoneShop13__c= theData.siryoseikyu_requestStoneShop13;
					//資料請求_対応石材店14
					service.Siryoseikyu_RequestStoneShop14__c= theData.siryoseikyu_requestStoneShop14;
					//資料請求_対応石材店15
					service.Siryoseikyu_RequestStoneShop15__c= theData.siryoseikyu_requestStoneShop15;
					//資料請求_対応石材店16
					service.Siryoseikyu_RequestStoneShop16__c= theData.siryoseikyu_requestStoneShop16;
					//資料請求_対応石材店17
					service.Siryoseikyu_RequestStoneShop17__c= theData.siryoseikyu_requestStoneShop17;
					//資料請求_対応石材店18
					service.Siryoseikyu_RequestStoneShop18__c= theData.siryoseikyu_requestStoneShop18;
					//資料請求_対応石材店19
					service.Siryoseikyu_RequestStoneShop19__c= theData.siryoseikyu_requestStoneShop19; 
					//資料請求_対応石材店20
					service.Siryoseikyu_RequestStoneShop20__c= theData.siryoseikyu_requestStoneShop20;
					//資料請求_対応石材店21
					service.Siryoseikyu_RequestStoneShop21__c= theData.siryoseikyu_requestStoneShop21;
					//資料請求_対応石材店22
					service.Siryoseikyu_RequestStoneShop22__c= theData.siryoseikyu_requestStoneShop22;
					//資料請求_対応石材店23
					service.Siryoseikyu_RequestStoneShop23__c= theData.siryoseikyu_requestStoneShop23; 
					//資料請求_対応石材店24 
					service.Siryoseikyu_RequestStoneShop24__c= theData.siryoseikyu_requestStoneShop24;
					//資料請求_対応石材店25
					service.Siryoseikyu_RequestStoneShop25__c= theData.siryoseikyu_requestStoneShop25;
					//資料請求_対応石材店26
					service.Siryoseikyu_RequestStoneShop26__c= theData.siryoseikyu_requestStoneShop26;
					//資料請求_対応石材店27
					service.Siryoseikyu_RequestStoneShop27__c= theData.siryoseikyu_requestStoneShop27;
					//資料請求_対応石材店28
					service.Siryoseikyu_RequestStoneShop28__c= theData.siryoseikyu_requestStoneShop28;
					//資料請求_対応石材店29
					service.Siryoseikyu_RequestStoneShop29__c= theData.siryoseikyu_requestStoneShop29;
					//資料請求_対応石材店30
					service.Siryoseikyu_RequestStoneShop30__c= theData.siryoseikyu_requestStoneShop30;
					//見学申込_依頼先霊園01
					service.Tour_Requestcemetery01__c= theData.tour_requestcemetery01;
					//見学申込_依頼先霊園02
					service.Tour_Requestcemetery02__c= theData.tour_requestcemetery02;
					//見学申込_依頼先霊園03
					service.Tour_Requestcemetery03__c= theData.tour_requestcemetery03;
					//見学申込_依頼先霊園04
					service.Tour_Requestcemetery04__c= theData.tour_requestcemetery04;
					//見学申込_依頼先霊園05
					service.Tour_Requestcemetery05__c= theData.tour_requestcemetery05;
					//見学申込_依頼先霊園06
					service.Tour_Requestcemetery06__c= theData.tour_requestcemetery06;
					//見学申込_依頼先霊園07
					service.Tour_Requestcemetery07__c= theData.tour_requestcemetery07;
					//見学申込_依頼先霊園08
					service.Tour_Requestcemetery08__c= theData.tour_requestcemetery08;
					//見学申込_依頼先霊園09
					service.Tour_Requestcemetery09__c= theData.tour_requestcemetery09;
					//見学申込_依頼先霊園10
					service.Tour_Requestcemetery10__c= theData.tour_requestcemetery10;
					//見学申込_依頼先霊園11
					service.Tour_Requestcemetery11__c= theData.tour_requestcemetery11;
					//見学申込_依頼先霊園12
					service.Tour_Requestcemetery12__c= theData.tour_requestcemetery12;
					//見学申込_依頼先霊園13
					service.Tour_Requestcemetery13__c= theData.tour_requestcemetery13;
					//見学申込_依頼先霊園14
					service.Tour_Requestcemetery14__c= theData.tour_requestcemetery14;
					//見学申込_依頼先霊園15
					service.Tour_Requestcemetery15__c= theData.tour_requestcemetery15;
					//見学申込_依頼先霊園16
					service.Tour_Requestcemetery16__c= theData.tour_requestcemetery16;
					//見学申込_依頼先霊園17
					service.Tour_Requestcemetery17__c= theData.tour_requestcemetery17;
					//見学申込_依頼先霊園18
					service.Tour_Requestcemetery18__c= theData.tour_requestcemetery18;
					//見学申込_依頼先霊園19
					service.Tour_Requestcemetery19__c= theData.tour_requestcemetery19;
					//見学申込_依頼先霊園20
					service.Tour_Requestcemetery20__c= theData.tour_requestcemetery20; 
					//見学申込_対応石材店01 
					service.Tour_RequestStoneShop01__c= theData.tour_requestStoneShop01;
					//見学申込_対応石材店02
					service.Tour_RequestStoneShop02__c= theData.tour_requestStoneShop02;
					//見学申込_対応石材店03
					service.Tour_RequestStoneShop03__c= theData.tour_requestStoneShop03;
					//見学申込_対応石材店04
					service.Tour_RequestStoneShop04__c= theData.tour_requestStoneShop04;
					//見学申込_対応石材店05
					service.Tour_RequestStoneShop05__c= theData.tour_requestStoneShop05;
					//見学申込_対応石材店06
					service.Tour_RequestStoneShop06__c= theData.tour_requestStoneShop06;
					//見学申込_対応石材店07
					service.Tour_RequestStoneShop07__c= theData.tour_requestStoneShop07;
					//見学申込_対応石材店08
					service.Tour_RequestStoneShop08__c= theData.tour_requestStoneShop08;
					//見学申込_対応石材店09
					service.Tour_RequestStoneShop09__c= theData.tour_requestStoneShop09;
					//見学申込_対応石材店10
					service.Tour_RequestStoneShop10__c= theData.tour_requestStoneShop10;
					//見学申込_対応石材店11
					service.Tour_RequestStoneShop11__c= theData.tour_requestStoneShop11;
					//見学申込_対応石材店12
					service.Tour_RequestStoneShop12__c= theData.tour_requestStoneShop12;
					//見学申込_対応石材店13
					service.Tour_RequestStoneShop13__c= theData.tour_requestStoneShop13;
					//見学申込_対応石材店14
					service.Tour_RequestStoneShop14__c= theData.tour_requestStoneShop14;
					//見学申込_対応石材店15
					service.Tour_RequestStoneShop15__c= theData.tour_requestStoneShop15;
					//見学申込_対応石材店16
					service.Tour_RequestStoneShop16__c= theData.tour_requestStoneShop16;
					//見学申込_対応石材店17
					service.Tour_RequestStoneShop17__c= theData.tour_requestStoneShop17;
					//見学申込_対応石材店18
					service.Tour_RequestStoneShop18__c= theData.tour_requestStoneShop18;
					//見学申込_対応石材店19
					service.Tour_RequestStoneShop19__c= theData.tour_requestStoneShop19;
					//見学申込_対応石材店20
					service.Tour_RequestStoneShop20__c= theData.tour_requestStoneShop20;              	
              }
              //墓ピタ包括問合せWeb受付の場合
              if (c.recordtypeid==RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','HakapitaHokatsutoiawase')){
					DataHokatsutoiawase theData = (DataHokatsutoiawase)JSON.deserialize(c.Description, DataHokatsutoiawase.class);
                  	service.Status__c = '新規';
                  	service.StageName__c='問合せ受付';
					//メール処理Id
					service.Uniq_Id__c = theData.uniq_id;
					//入口
                    service.Entrance__c= Api_V1_ItemValueMaster.getEntrance(theData.entrance);
                    //お墓の種類
                    service.GraveType__c= theData.GraveType;
                    //ご遺骨の場所
                    service.LocationOfRemains__c= theData.LocationOfRemains;
                    //宗旨・宗派
                    service.Religion__c= theData.Religion;
                    //こだわり条件
                    service.AttentionCondition__c= theData.AttentionCondition;
                    //ご予算
                    service.Budget__c= theData.Budget;
                    //備考
                    service.Remarks__c= theData.Remarks;
                    //お墓を建てる場所
                    service.BuildGraveArea__c= theData.BuildGraveArea;
                    //申込者
                    service.SodansyaRef__c= c.accountid;
					//資料請求_依頼先霊園01
					service.Siryoseikyu_Requestcemetery01__c= theData.siryoseikyu_requestcemetery01;
					//資料請求_依頼先霊園02
					service.Siryoseikyu_Requestcemetery02__c= theData.siryoseikyu_requestcemetery02;
					//資料請求_依頼先霊園03
					service.Siryoseikyu_Requestcemetery03__c= theData.siryoseikyu_requestcemetery03;
					//資料請求_依頼先霊園04
					service.Siryoseikyu_Requestcemetery04__c= theData.siryoseikyu_requestcemetery04;
					//資料請求_依頼先霊園05
					service.Siryoseikyu_Requestcemetery05__c= theData.siryoseikyu_requestcemetery05;
					//資料請求_依頼先霊園06
					service.Siryoseikyu_Requestcemetery06__c= theData.siryoseikyu_requestcemetery06;
					//資料請求_依頼先霊園07
					service.Siryoseikyu_Requestcemetery07__c= theData.siryoseikyu_requestcemetery07;
					//資料請求_依頼先霊園08
					service.Siryoseikyu_Requestcemetery08__c= theData.siryoseikyu_requestcemetery08;
					//資料請求_依頼先霊園09
					service.Siryoseikyu_Requestcemetery09__c= theData.siryoseikyu_requestcemetery09;
					//資料請求_依頼先霊園10
					service.Siryoseikyu_Requestcemetery10__c= theData.siryoseikyu_requestcemetery10;
					//資料請求_依頼先霊園11
					service.Siryoseikyu_Requestcemetery11__c= theData.siryoseikyu_requestcemetery11;
					//資料請求_依頼先霊園12
					service.Siryoseikyu_Requestcemetery12__c= theData.siryoseikyu_requestcemetery12;
					//資料請求_依頼先霊園13
					service.Siryoseikyu_Requestcemetery13__c= theData.siryoseikyu_requestcemetery13;
					//資料請求_依頼先霊園14
					service.Siryoseikyu_Requestcemetery14__c= theData.siryoseikyu_requestcemetery14;
					//資料請求_依頼先霊園15
					service.Siryoseikyu_Requestcemetery15__c= theData.siryoseikyu_requestcemetery15;
					//資料請求_依頼先霊園16
					service.Siryoseikyu_Requestcemetery16__c= theData.siryoseikyu_requestcemetery16;
					//資料請求_依頼先霊園17
					service.Siryoseikyu_Requestcemetery17__c= theData.siryoseikyu_requestcemetery17;
					//資料請求_依頼先霊園18
					service.Siryoseikyu_Requestcemetery18__c= theData.siryoseikyu_requestcemetery18;
					//資料請求_依頼先霊園19
					service.Siryoseikyu_Requestcemetery19__c= theData.siryoseikyu_requestcemetery19;
					//資料請求_依頼先霊園20 
					service.Siryoseikyu_Requestcemetery20__c= theData.siryoseikyu_requestcemetery20;                    
					//資料請求_対応石材店01
					service.Siryoseikyu_RequestStoneShop01__c= theData.siryoseikyu_requestStoneShop01;
					//資料請求_対応石材店02
					service.Siryoseikyu_RequestStoneShop02__c= theData.siryoseikyu_requestStoneShop02;
					//資料請求_対応石材店03
					service.Siryoseikyu_RequestStoneShop03__c= theData.siryoseikyu_requestStoneShop03;
					//資料請求_対応石材店04
					service.Siryoseikyu_RequestStoneShop04__c= theData.siryoseikyu_requestStoneShop04;
					//資料請求_対応石材店05
					service.Siryoseikyu_RequestStoneShop05__c= theData.siryoseikyu_requestStoneShop05;
					//資料請求_対応石材店06
					service.Siryoseikyu_RequestStoneShop06__c= theData.siryoseikyu_requestStoneShop06;
					//資料請求_対応石材店07
					service.Siryoseikyu_RequestStoneShop07__c= theData.siryoseikyu_requestStoneShop07;
					//資料請求_対応石材店08
					service.Siryoseikyu_RequestStoneShop08__c= theData.siryoseikyu_requestStoneShop08;
					//資料請求_対応石材店09
					service.Siryoseikyu_RequestStoneShop09__c= theData.siryoseikyu_requestStoneShop09; 
					//資料請求_対応石材店10
					service.Siryoseikyu_RequestStoneShop10__c= theData.siryoseikyu_requestStoneShop10;
					//資料請求_対応石材店11
					service.Siryoseikyu_RequestStoneShop11__c= theData.siryoseikyu_requestStoneShop11;
					//資料請求_対応石材店12
					service.Siryoseikyu_RequestStoneShop12__c= theData.siryoseikyu_requestStoneShop12;
					//資料請求_対応石材店13
					service.Siryoseikyu_RequestStoneShop13__c= theData.siryoseikyu_requestStoneShop13;
					//資料請求_対応石材店14
					service.Siryoseikyu_RequestStoneShop14__c= theData.siryoseikyu_requestStoneShop14;
					//資料請求_対応石材店15
					service.Siryoseikyu_RequestStoneShop15__c= theData.siryoseikyu_requestStoneShop15;
					//資料請求_対応石材店16
					service.Siryoseikyu_RequestStoneShop16__c= theData.siryoseikyu_requestStoneShop16;
					//資料請求_対応石材店17
					service.Siryoseikyu_RequestStoneShop17__c= theData.siryoseikyu_requestStoneShop17;
					//資料請求_対応石材店18
					service.Siryoseikyu_RequestStoneShop18__c= theData.siryoseikyu_requestStoneShop18;
					//資料請求_対応石材店19
					service.Siryoseikyu_RequestStoneShop19__c= theData.siryoseikyu_requestStoneShop19; 
					//資料請求_対応石材店20
					service.Siryoseikyu_RequestStoneShop20__c= theData.siryoseikyu_requestStoneShop20;
              }              
                     
            }
            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
    }  
    
    
    public class DataHakapita{
    	//メール処理Id
        public String uniq_id { get;  set; }
        //問合せ日
        public String req_day { get;  set; }
        //入口
        public String entrance	{ get;  set; }
        //管理画面URL
        public String manage_screen_url	{ get;  set; } 
        //最終見学日
        public String last_tour_day	{ get;  set; } 
        //申込者姓
        public String last_name	{ get;  set; } 
        //申込者名
        public String first_name	{ get;  set; } 
        //申込者姓(カナ)
        public String last_name_kana	{ get;  set; } 
        //申込者名(カナ)
        public String first_name_kana	{ get;  set; } 
        //申込者電話番号
        public String mobile	{ get;  set; } 
        //申込者メールアドレス
        public String email	{ get;  set; } 
        //申込者住所.郵便番号
        public String address_zip_code	{ get;  set; } 
        //申込者住所.都道府県
        public String address_state	{ get;  set; }  
        //申込者住所.市区郡      
        public String address_city	{ get;  set; } 
        //申込者住所.町名番地
        public String address_street	{ get;  set; } 
        //資料請求_依頼先霊園01
        public String siryoseikyu_requestcemetery01	{ get;  set; } 
        //資料請求_依頼先霊園02
        public String siryoseikyu_requestcemetery02	{ get;  set; } 
        //資料請求_依頼先霊園03
        public String siryoseikyu_requestcemetery03	{ get;  set; } 
        //資料請求_依頼先霊園04
        public String siryoseikyu_requestcemetery04	{ get;  set; } 
        //資料請求_依頼先霊園05
        public String siryoseikyu_requestcemetery05	{ get;  set; } 
        //資料請求_依頼先霊園06
        public String siryoseikyu_requestcemetery06	{ get;  set; } 
        //資料請求_依頼先霊園07
        public String siryoseikyu_requestcemetery07	{ get;  set; } 
        //資料請求_依頼先霊園08
        public String siryoseikyu_requestcemetery08	{ get;  set; } 
        //資料請求_依頼先霊園09
        public String siryoseikyu_requestcemetery09	{ get;  set; } 
        //資料請求_依頼先霊園10
        public String siryoseikyu_requestcemetery10	{ get;  set; } 
        //資料請求_依頼先霊園11
        public String siryoseikyu_requestcemetery11	{ get;  set; }
        //資料請求_依頼先霊園12 
        public String siryoseikyu_requestcemetery12	{ get;  set; } 
        //資料請求_依頼先霊園13
        public String siryoseikyu_requestcemetery13	{ get;  set; } 
        //資料請求_依頼先霊園14
        public String siryoseikyu_requestcemetery14	{ get;  set; } 
        //資料請求_依頼先霊園15
        public String siryoseikyu_requestcemetery15	{ get;  set; } 
        //資料請求_依頼先霊園16
        public String siryoseikyu_requestcemetery16	{ get;  set; } 
        //資料請求_依頼先霊園17
        public String siryoseikyu_requestcemetery17	{ get;  set; } 
        //資料請求_依頼先霊園18
        public String siryoseikyu_requestcemetery18	{ get;  set; }    
        //資料請求_依頼先霊園19    
        public String siryoseikyu_requestcemetery19	{ get;  set; } 
        //資料請求_依頼先霊園20
        public String siryoseikyu_requestcemetery20	{ get;  set; } 
        //資料請求_依頼先霊園21
        public String siryoseikyu_requestcemetery21	{ get;  set; } 
        //資料請求_依頼先霊園22        
        public String siryoseikyu_requestcemetery22	{ get;  set; } 
        //資料請求_依頼先霊園23
        public String siryoseikyu_requestcemetery23	{ get;  set; } 
        //資料請求_依頼先霊園24
        public String siryoseikyu_requestcemetery24	{ get;  set; } 
        //資料請求_依頼先霊園25
        public String siryoseikyu_requestcemetery25	{ get;  set; } 
        //資料請求_依頼先霊園26
        public String siryoseikyu_requestcemetery26	{ get;  set; } 
        //資料請求_依頼先霊園27
        public String siryoseikyu_requestcemetery27	{ get;  set; } 
        //資料請求_依頼先霊園28
        public String siryoseikyu_requestcemetery28	{ get;  set; }
        //資料請求_依頼先霊園29
        public String siryoseikyu_requestcemetery29	{ get;  set; }
        //資料請求_依頼先霊園30
        public String siryoseikyu_requestcemetery30	{ get;  set; } 
        //資料請求_対応石材店01
        public String siryoseikyu_requestStoneShop01	{ get;  set; } 
        //資料請求_対応石材店02
        public String siryoseikyu_requestStoneShop02	{ get;  set; } 
        //資料請求_対応石材店03
        public String siryoseikyu_requestStoneShop03	{ get;  set; } 
        //資料請求_対応石材店04
        public String siryoseikyu_requestStoneShop04	{ get;  set; } 
        //資料請求_対応石材店05
        public String siryoseikyu_requestStoneShop05	{ get;  set; } 
        //資料請求_対応石材店06
        public String siryoseikyu_requestStoneShop06	{ get;  set; } 
        //資料請求_対応石材店07
        public String siryoseikyu_requestStoneShop07	{ get;  set; } 
        //資料請求_対応石材店08
        public String siryoseikyu_requestStoneShop08	{ get;  set; } 
        //資料請求_対応石材店09
        public String siryoseikyu_requestStoneShop09	{ get;  set; }    
        //資料請求_対応石材店10  
        public String siryoseikyu_requestStoneShop10	{ get;  set; } 
        //資料請求_対応石材店11
        public String siryoseikyu_requestStoneShop11	{ get;  set; } 
        //資料請求_対応石材店12
        public String siryoseikyu_requestStoneShop12	{ get;  set; } 
        //資料請求_対応石材店13
        public String siryoseikyu_requestStoneShop13	{ get;  set; } 
        //資料請求_対応石材店14
        public String siryoseikyu_requestStoneShop14	{ get;  set; } 
        //資料請求_対応石材店15
        public String siryoseikyu_requestStoneShop15	{ get;  set; } 
        //資料請求_対応石材店16
        public String siryoseikyu_requestStoneShop16	{ get;  set; } 
        //資料請求_対応石材店17
        public String siryoseikyu_requestStoneShop17	{ get;  set; } 
        //資料請求_対応石材店18
        public String siryoseikyu_requestStoneShop18	{ get;  set; } 
        //資料請求_対応石材店19
        public String siryoseikyu_requestStoneShop19	{ get;  set; } 
        //資料請求_対応石材店20
        public String siryoseikyu_requestStoneShop20	{ get;  set; } 
        //資料請求_対応石材店21
        public String siryoseikyu_requestStoneShop21	{ get;  set; } 
        //資料請求_対応石材店22
        public String siryoseikyu_requestStoneShop22	{ get;  set; } 
        //資料請求_対応石材店23
        public String siryoseikyu_requestStoneShop23	{ get;  set; } 
        //資料請求_対応石材店24
        public String siryoseikyu_requestStoneShop24	{ get;  set; } 
        //資料請求_対応石材店25
        public String siryoseikyu_requestStoneShop25	{ get;  set; } 
        //資料請求_対応石材店26
        public String siryoseikyu_requestStoneShop26	{ get;  set; } 
        //資料請求_対応石材店27
        public String siryoseikyu_requestStoneShop27	{ get;  set; } 
        //資料請求_対応石材店28
        public String siryoseikyu_requestStoneShop28	{ get;  set; } 
        //資料請求_対応石材店29
        public String siryoseikyu_requestStoneShop29	{ get;  set; }  
        //資料請求_対応石材店30      
        public String siryoseikyu_requestStoneShop30	{ get;  set; } 
        //見学申込_依頼先霊園01
        public String tour_requestcemetery01	{ get;  set; } 
        //見学申込_依頼先霊園02
        public String tour_requestcemetery02	{ get;  set; } 
        //見学申込_依頼先霊園03
        public String tour_requestcemetery03	{ get;  set; } 
        //見学申込_依頼先霊園04
        public String tour_requestcemetery04	{ get;  set; } 
        //見学申込_依頼先霊園05
        public String tour_requestcemetery05	{ get;  set; } 
        //見学申込_依頼先霊園06
        public String tour_requestcemetery06	{ get;  set; } 
        //見学申込_依頼先霊園07
        public String tour_requestcemetery07	{ get;  set; } 
        //見学申込_依頼先霊園08
        public String tour_requestcemetery08	{ get;  set; } 
        //見学申込_依頼先霊園09
        public String tour_requestcemetery09	{ get;  set; } 
        //見学申込_依頼先霊園10
        public String tour_requestcemetery10	{ get;  set; }
        //見学申込_依頼先霊園11
        public String tour_requestcemetery11	{ get;  set; } 
        //見学申込_依頼先霊園12
        public String tour_requestcemetery12	{ get;  set; } 
        //見学申込_依頼先霊園13
        public String tour_requestcemetery13	{ get;  set; } 
        //見学申込_依頼先霊園14
        public String tour_requestcemetery14	{ get;  set; } 
        //見学申込_依頼先霊園15
        public String tour_requestcemetery15	{ get;  set; } 
        //見学申込_依頼先霊園16
        public String tour_requestcemetery16	{ get;  set; } 
        //見学申込_依頼先霊園17
        public String tour_requestcemetery17	{ get;  set; } 
        //見学申込_依頼先霊園18
        public String tour_requestcemetery18	{ get;  set; } 
        //見学申込_依頼先霊園19
        public String tour_requestcemetery19	{ get;  set; } 
        //見学申込_依頼先霊園20
        public String tour_requestcemetery20	{ get;  set; }  
        //見学申込_対応石材店01      
        public String tour_requestStoneShop01	{ get;  set; } 
        //見学申込_対応石材店02
        public String tour_requestStoneShop02	{ get;  set; } 
        //見学申込_対応石材店03
        public String tour_requestStoneShop03	{ get;  set; } 
        //見学申込_対応石材店04
        public String tour_requestStoneShop04	{ get;  set; } 
        //見学申込_対応石材店05
        public String tour_requestStoneShop05	{ get;  set; } 
        //見学申込_対応石材店06
        public String tour_requestStoneShop06	{ get;  set; } 
        //見学申込_対応石材店07
        public String tour_requestStoneShop07	{ get;  set; } 
        //見学申込_対応石材店08
        public String tour_requestStoneShop08	{ get;  set; } 
        //見学申込_対応石材店09
        public String tour_requestStoneShop09	{ get;  set; } 
        //見学申込_対応石材店10
        public String tour_requestStoneShop10	{ get;  set; } 
        //見学申込_対応石材店11
        public String tour_requestStoneShop11	{ get;  set; } 
        //見学申込_対応石材店12
        public String tour_requestStoneShop12	{ get;  set; } 
        //見学申込_対応石材店13
        public String tour_requestStoneShop13	{ get;  set; } 
        //見学申込_対応石材店14
        public String tour_requestStoneShop14	{ get;  set; } 
        //見学申込_対応石材店15
        public String tour_requestStoneShop15	{ get;  set; } 
        //見学申込_対応石材店16
        public String tour_requestStoneShop16	{ get;  set; } 
        //見学申込_対応石材店17
        public String tour_requestStoneShop17	{ get;  set; } 
        //見学申込_対応石材店18
        public String tour_requestStoneShop18	{ get;  set; } 
        //見学申込_対応石材店19
        public String tour_requestStoneShop19	{ get;  set; } 
        //見学申込_対応石材店20
        public String tour_requestStoneShop20	{ get;  set; }                                     
    }  
    public class DataHokatsutoiawase{
    	//メール処理Id
        public String uniq_id { get;  set; }
        //問合せ日
        public String req_day { get;  set; }
        //入口
        public String entrance	{ get;  set; }
        //お墓の種類
        public String GraveType	{ get;  set; }
        //ご遺骨の場所
        public String LocationOfRemains	{ get;  set; }
        //宗旨・宗派
        public String Religion	{ get;  set; }
        //こだわり条件
        public String AttentionCondition	{ get;  set; }
        //ご予算
        public String Budget	{ get;  set; }
        //備考
        public String Remarks	{ get;  set; }
        //お墓を建てる場所
        public String BuildGraveArea	{ get;  set; }
        //申込者姓
        public String last_name	{ get;  set; } 
        //申込者名
        public String first_name	{ get;  set; } 
        //申込者姓(カナ)
        public String last_name_kana	{ get;  set; } 
        //申込者名(カナ)
        public String first_name_kana	{ get;  set; } 
        //申込者電話番号
        public String mobile	{ get;  set; } 
        //申込者メールアドレス
        public String email	{ get;  set; } 
        //申込者住所.郵便番号
        public String address_zip_code	{ get;  set; } 
        //申込者住所.都道府県
        public String address_state	{ get;  set; }  
        //申込者住所.市区郡      
        public String address_city	{ get;  set; } 
        //申込者住所.町名番地
        public String address_street	{ get;  set; } 
        //資料請求_依頼先霊園01
        public String siryoseikyu_requestcemetery01	{ get;  set; } 
        //資料請求_依頼先霊園02
        public String siryoseikyu_requestcemetery02	{ get;  set; } 
        //資料請求_依頼先霊園03
        public String siryoseikyu_requestcemetery03	{ get;  set; } 
        //資料請求_依頼先霊園04
        public String siryoseikyu_requestcemetery04	{ get;  set; } 
        //資料請求_依頼先霊園05
        public String siryoseikyu_requestcemetery05	{ get;  set; } 
        //資料請求_依頼先霊園06
        public String siryoseikyu_requestcemetery06	{ get;  set; } 
        //資料請求_依頼先霊園07
        public String siryoseikyu_requestcemetery07	{ get;  set; } 
        //資料請求_依頼先霊園08
        public String siryoseikyu_requestcemetery08	{ get;  set; } 
        //資料請求_依頼先霊園09
        public String siryoseikyu_requestcemetery09	{ get;  set; } 
        //資料請求_依頼先霊園10
        public String siryoseikyu_requestcemetery10	{ get;  set; } 
        //資料請求_依頼先霊園11
        public String siryoseikyu_requestcemetery11	{ get;  set; }
        //資料請求_依頼先霊園12 
        public String siryoseikyu_requestcemetery12	{ get;  set; } 
        //資料請求_依頼先霊園13
        public String siryoseikyu_requestcemetery13	{ get;  set; } 
        //資料請求_依頼先霊園14
        public String siryoseikyu_requestcemetery14	{ get;  set; } 
        //資料請求_依頼先霊園15
        public String siryoseikyu_requestcemetery15	{ get;  set; } 
        //資料請求_依頼先霊園16
        public String siryoseikyu_requestcemetery16	{ get;  set; } 
        //資料請求_依頼先霊園17
        public String siryoseikyu_requestcemetery17	{ get;  set; } 
        //資料請求_依頼先霊園18
        public String siryoseikyu_requestcemetery18	{ get;  set; }    
        //資料請求_依頼先霊園19    
        public String siryoseikyu_requestcemetery19	{ get;  set; } 
        //資料請求_依頼先霊園20
        public String siryoseikyu_requestcemetery20	{ get;  set; }       
        //資料請求_対応石材店01
        public String siryoseikyu_requestStoneShop01	{ get;  set; } 
        //資料請求_対応石材店02
        public String siryoseikyu_requestStoneShop02	{ get;  set; } 
        //資料請求_対応石材店03
        public String siryoseikyu_requestStoneShop03	{ get;  set; } 
        //資料請求_対応石材店04
        public String siryoseikyu_requestStoneShop04	{ get;  set; } 
        //資料請求_対応石材店05
        public String siryoseikyu_requestStoneShop05	{ get;  set; } 
        //資料請求_対応石材店06
        public String siryoseikyu_requestStoneShop06	{ get;  set; } 
        //資料請求_対応石材店07
        public String siryoseikyu_requestStoneShop07	{ get;  set; } 
        //資料請求_対応石材店08
        public String siryoseikyu_requestStoneShop08	{ get;  set; } 
        //資料請求_対応石材店09
        public String siryoseikyu_requestStoneShop09	{ get;  set; }    
        //資料請求_対応石材店10  
        public String siryoseikyu_requestStoneShop10	{ get;  set; } 
        //資料請求_対応石材店11
        public String siryoseikyu_requestStoneShop11	{ get;  set; } 
        //資料請求_対応石材店12
        public String siryoseikyu_requestStoneShop12	{ get;  set; } 
        //資料請求_対応石材店13
        public String siryoseikyu_requestStoneShop13	{ get;  set; } 
        //資料請求_対応石材店14
        public String siryoseikyu_requestStoneShop14	{ get;  set; } 
        //資料請求_対応石材店15
        public String siryoseikyu_requestStoneShop15	{ get;  set; } 
        //資料請求_対応石材店16
        public String siryoseikyu_requestStoneShop16	{ get;  set; } 
        //資料請求_対応石材店17
        public String siryoseikyu_requestStoneShop17	{ get;  set; } 
        //資料請求_対応石材店18
        public String siryoseikyu_requestStoneShop18	{ get;  set; } 
        //資料請求_対応石材店19
        public String siryoseikyu_requestStoneShop19	{ get;  set; } 
        //資料請求_対応石材店20
        public String siryoseikyu_requestStoneShop20	{ get;  set; }                                      
    }                              
}