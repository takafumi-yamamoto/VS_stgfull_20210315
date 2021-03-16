@RestResource(urlMapping='/jizenwari_moushikomi/*')
global with sharing class Ctl_JizenwariRestResource {

	@HttpPost
	global static void create(){
		String requestBody = RestContext.request.requestBody.toString();
		Case jizenwariCase = createCaseByJsonString(requestBody);

		try{
			insert jizenwariCase;
		}
		catch(Exception e){
			String err = '[エラーメッセージ]\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString();
            RestContext.response.responseBody = Blob.valueOf(err);
            RestContext.response.statusCode = 500;

            String strText = 'ケースの作成が失敗しました。\r\n\r\n' + err + '\r\n\r\n' + '[問合せ内容]\r\n' + requestBody;
            Utility_Common.sendEmail(System.Label.ErrorNotificationEmailAddress, '【事前割申込ケース作成エラー】', strText);
		}
	}

	@TestVisible
	public static Case createCaseByJsonString(String pJson){
		Ctl_JizenwariJson2Apex j2Ap = Ctl_JizenwariJson2Apex.parse(pJson);

		String jizenwariRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','JizenwariWebMoshikomi');

		Case jizenwariCase = new Case();

		jizenwariCase.Status = '新規';
		jizenwariCase.Origin = 'Web';

		jizenwariCase.GaClientId__c             = j2Ap.gaclient_id;
		jizenwariCase.Lastname__c               = j2Ap.last_name;
		jizenwariCase.Firstname__c              = j2Ap.first_name;
		jizenwariCase.LastNameKana__c           = j2Ap.last_name_kana;
		jizenwariCase.FirstNameKana__c          = j2Ap.first_name_kana;
		jizenwariCase.PostalCode__c             = j2Ap.address_post;
		jizenwariCase.State__c                  = j2Ap.address_state;
		jizenwariCase.City__c                   = j2Ap.address_city;
		jizenwariCase.Street__c                 = j2Ap.address_street;
		jizenwariCase.MailAddress__c            = j2Ap.email;
		jizenwariCase.uniq_id__c                = j2Ap.uniq_id;
		jizenwariCase.LoginTorihikisakiBango__c = j2Ap.customer_bango;
		jizenwariCase.MemberTourokuKibo__c      = j2Ap.member_touroku_kibo;
		jizenwariCase.WebAccountKibo__c         = j2Ap.web_account_kibo;
		jizenwariCase.JizewariPlan__c           = j2Ap.plan;
		jizenwariCase.PaymentType__c            = j2Ap.payment_type;
		jizenwariCase.KiboAreaState__c          = j2Ap.areaState;
		jizenwariCase.KiboAreaCity__c           = j2Ap.areaCity;
		jizenwariCase.KiboPlan__c               = j2Ap.sogi_planHope;
		jizenwariCase.TaishoushaJokyo__c        = j2Ap.taisyosya_jokyo;
		jizenwariCase.ShiryoHoyu__c             = j2Ap.simpleJizenwariOwns_material;
        jizenwariCase.Description               = pJson;
        jizenwariCase.RecordTypeId              = jizenwariRecordTypeId;
        jizenwariCase.ToiawaseDate__c           = Com_Utility.toDateTime(j2Ap.req_Day);
        if(Com_Utility.isMobile(j2Ap.phone)){
			jizenwariCase.KeitaiDenwa__c = j2Ap.phone;        	
        } else {
        	jizenwariCase.TelNo__c = j2Ap.phone;	
        }
		return jizenwariCase;
	}


    @HttpPut
	global static void edit(){

		String requestBody = RestContext.request.requestBody.toString();
		PutJizenwariJson2Apex j2Ap = new PutJizenwariJson2Apex().parse(requestBody);


		String seikyuBango;
		if(String.isNotBlank(j2Ap.sid)){
			seikyuBango = j2Ap.sid;
		}

		if(String.isNotBlank(j2Ap.request_number)){
			seikyuBango = j2Ap.request_number;	
		}

		String seikyuHouhou = j2Ap.getSeikyuHouhou();
		OkyakusamaSeikyuMeisai__c targetOkyakusamaSeikyuMeisai = selectTargetOkyakusamaSeikyuMeisai(seikyuBango, seikyuHouhou);
		Jizenwari__c targetJizenwari   = selectTargetJizenwari(targetOkyakusamaSeikyuMeisai.OpportunityRef__r.JizenwariRef__c);
		Opportunity  targetOpportunity = selectTargetOpportunity(targetJizenwari.Id);

		List<SObject> updates = new List<SObject>();


		// 決済完了の場合
		if(String.isBlank(j2Ap.cancelReceiptDate)){
	        
	        // 決済完了日の更新
	        if(String.isNotBlank(j2Ap.settleCompleteDate)){
	        	targetOkyakusamaSeikyuMeisai.Kessaibi__c = Date.parse(j2Ap.settleCompleteDate);
	        	updates.add(targetOkyakusamaSeikyuMeisai);
	        }
		}

		// キャンセルの場合
		if(String.isNotBlank(j2Ap.cancelReceiptDate)){

			// キャンセル受付日更新
	        if(String.isNotBlank(j2Ap.cancelReceiptDate)){
	        	targetJizenwari.CancelReceiptDate__c = Date.parse(j2Ap.cancelReceiptDate);
	        	updates.add(targetJizenwari);
	        }

	        // 商談フェーズ更新
			targetOpportunity.StageName = 'キャンセル';
 	        updates.add(targetOpportunity);


 	        // // キャンセルお客様請求明細作成
		    // Id kobetsuSeikyuMeisaiRecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('OkyakusamaSeikyuMeisai__c','KobetsuSeikyu');
	        // OkyakusamaSeikyuMeisai__c cancelSeikyuMeisai = new OkyakusamaSeikyuMeisai__c();
	        // cancelSeikyuMeisai.ServiceSyubetsu__c = '事前割';
            // cancelSeikyuMeisai.RecordTypeId      = kobetsuSeikyuMeisaiRecordTypeId;
            // cancelSeikyuMeisai.SeikyuHouhou__c   = j2Ap.getCancelSeikyuHouhou();
            // cancelSeikyuMeisai.SeikyuBango__c    = seikyuBango;
            // cancelSeikyuMeisai.SeikyuKingaku__c  = -500;
            // cancelSeikyuMeisai.OpportunityRef__c = targetOkyakusamaSeikyuMeisai.OpportunityRef__c;
            // cancelSeikyuMeisai.Kessaibi__c       = date.Today();

            // insert cancelSeikyuMeisai;
		}

		try{
			update updates;
		}
		catch(Exception e){
			String err = '[エラーメッセージ]\r\n' + e.getMessage() + '\r\n' + e.getStackTraceString();
            RestContext.response.responseBody = Blob.valueOf(err);
            RestContext.response.statusCode = 500;

            String strText = 'ケースの作成が失敗しました。\r\n\r\n' + err + '\r\n\r\n' + '[問合せ内容]\r\n' + requestBody;
            Utility_Common.sendEmail(System.Label.ErrorNotificationEmailAddress, '【事前割更新エラー】', strText);
		}
    }

    private static OkyakusamaSeikyuMeisai__c selectTargetOkyakusamaSeikyuMeisai(String seikyuBango, String seikyuHouhou){
    	System.debug('---seikyuBango---' + seikyuBango);
    	System.debug('---seikyuHouhou---' + seikyuHouhou);

    	OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai = [    SELECT
			    													Id,
			    													Kessaibi__c,
			    													OpportunityRef__c,
																	OpportunityRef__r.JizenwariRef__c
																FROM 
																	OkyakusamaSeikyuMeisai__c
																WHERE 
																	SeikyuBango__c = :seikyuBango
																AND 
																	SeikyuHouhou__c = :seikyuHouhou
																LIMIT
																	1
	        												];
	    System.debug('--okyakusamaSeikyuMeisai---' + okyakusamaSeikyuMeisai);
      
        return okyakusamaSeikyuMeisai;
    }


    private static Jizenwari__c selectTargetJizenwari(Id targetJizenwariId){

		Jizenwari__c targetJizenwari = [  SELECT
											Id,
											StageName__c,
											CancelReceiptDate__c
										  FROM
										  	Jizenwari__c
										  WHERE
										  	Id = :targetJizenwariId
										  LIMIT
										  	1
										];
		return targetJizenwari;
    }

    private static Opportunity selectTargetOpportunity(Id targetJizenwariId){

    	Opportunity targetOpportunity = [  SELECT
    										  Id,
    										  StageName
    									   FROM
    									   	  Opportunity
    									   	WHERE
    									   	  JizenwariRef__c = :targetJizenwariId
    									   	LIMIT
    									   	  1
    									];
    	return targetOpportunity;
    }


    public class PutJizenwariJson2Apex {

    	public String settleCompleteDate; // 決済完了日
    	public String cancelReceiptDate;  // キャンセル受付日
    	public String payment_status;     // 入金状況
    	public String request_number;     // 請求番号
    	public String sid;                // sId;
    	public String payment_type;       // 請求方法
 
	    public PutJizenwariJson2Apex parse(String json) {
	        return (PutJizenwariJson2Apex) System.JSON.deserialize(json, PutJizenwariJson2Apex.class);
	    }


	    public String getStageName(){
	    	String stageName;

	    	if(this.payment_status == '事前割-申込完了' || this.payment_status == '事前割-決済完了（証書発送待ち）'){
	    		stageName = '決済';
	    	}

	    	if(this.payment_status == '事前割-キャンセル（返金不要）'){
	    		stageName = 'キャンセル';
	    	}

	    	return stageName;
	    }

	    public String getSeikyuHouhou(){

	    	String seikyuHouhou;

	    	if(this.payment_type == 'cvs_den'){
	    		seikyuHouhou = 'paydesign_cvs_den';
	    	}

	    	if(this.payment_type == 'cvs_tan'){
	    		seikyuHouhou = 'paydesign_cvs_tan';
	    	}
	    	
	    	if(this.payment_type == 'credit'){
	    		seikyuHouhou = 'paydesign_credit';
	    	}

	    	return seikyuHouhou;
	    }

	    public String getCancelSeikyuHouhou(){

	    	String cancelSeikyuHouhou;

	    	if(this.payment_type == 'cvs_den'){
	    		cancelSeikyuHouhou = 'paydesign_cvs_den_cancel';
	    	}

	    	if(this.payment_type == 'cvs_tan'){
	    		cancelSeikyuHouhou = 'paydesign_cvs_tan_cancel';
	    	}
	    	
	    	return cancelSeikyuHouhou;
	    }
    }

}