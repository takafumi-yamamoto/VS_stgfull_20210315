public class SgTgAnSmsSendCtl {

	@TestVisible
	private static SgTgAnSms.IMessageCreater mSgTgAnSms = new SgTgAnSms.MessageCreater(new SgTgAnSms.OppLineItemDataPvdr()); 

	@TestVisible
	private static AcrtSmsSender.IClient mAcrtSmsSenderClient = AcrtSmsSender.getClient();

	@TestVisible
	private static AcrtDrTackRegister.IRegister mIAcrtDrTackRegister = new AcrtDrTackRegister.Register();

	@TestVisible
	private static AcrtSmsSendHistLogr.IAcrtSmsSendHistLogr mIAcrtSmsSendHistLogr = AcrtSmsSendHistLogr.get_IAcrtSmsSendHistLogr_instance();

	public String OppId = '';
	public String AccountId = '';
	public String TelNo {get;set;}
	public String MessageText {get;set;}

	public SgTgAnSmsSendCtl(ApexPages.StandardController controller) {
		OppId = controller.getRecord().id;
	}

	public void init(){
		Opportunity theOpp = [SELECT Id, Account.Id, Account.MobilePhone__c FROM Opportunity WHERE Id =: OppId].get(0);
		AccountId = theOpp.Account.Id;
		TelNo = this.mobilePhoneToOnlyNumbe(theOpp.Account.MobilePhone__c);
		MessageText = mSgTgAnSms.createMsg(OppId);
	}

	public pagereference submit(){
		if(String.isBlank(TelNo)){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning, '携帯電話番号をご入力ください。' ));
			return null;
		}
		if(!this.isMobilePhone(this.mobilePhoneToOnlyNumbe(TelNo))){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.warning, '入力された携帯電話番号ではSMS送信できません。090、080、070から始まる携帯電話番号を入力してください。' ));
			return null;
		}
		SendReq theReq = new SendReq();
		theReq.opp_id = OppId;
		theReq.account_id = AccountId;
		theReq.theTelno = TelNo;
		theReq.theMsg = MessageText;
		SendRes mRes = this.send(theReq);
		ApexPages.addMessage(new ApexPages.Message(mRes.severity, mRes.msg ));
		return null;
	}

	public SendRes send(SendReq pReq){
		SendRes theRes = new SendRes();
		AcrtSmsSender.Req theAcrtSmsSenderReq = new AcrtSmsSender.Req()
			.set_telno(pReq.theTelno)
			.set_text_long(pReq.theMsg)
			.set_shorten_url(true)
			.set_user_ref(null)
			.set_msg_type('SgTgAnSms')
			.set_msg_meta_data(null)
			.set_account_id(pReq.account_id)
			.set_opp_id(pReq.opp_id);
		try{
			AcrtSmsSender.Result theSendResult = mAcrtSmsSenderClient.sendSms(theAcrtSmsSenderReq);
			mIAcrtSmsSendHistLogr.logSmsHistory(theSendResult);
			mIAcrtDrTackRegister.InsertEntry(theSendResult);
			theRes.is_success = true;
			theRes.severity = ApexPages.Severity.confirm ;
			theRes.msg = '追加料金・決済方法案内を送信しました。';
		}catch(Exception ex){
			theRes.is_success = false;
			theRes.severity = ApexPages.Severity.error;
			theRes.msg = '送信エラーが発生しました。正しい携帯電話番号を入力しているか、ご確認をしてください。正しい電話番号で再度送信してもエラーとなった場合には、システム部にご連絡ください。';
		}
		return theRes;
	}

	public void cancel(){
	}

	private Boolean isMobilePhone(String pTelno){
		return 
		pTelno != null
		&& new List<String>{'090', '080', '070'}.contains( pTelno.left(3) )
		&& pTelno.length() == 11;
	}

	private String mobilePhoneToOnlyNumbe(String pTelNo){
		if(String.isBlank(pTelNo)) return null;
		String regEx = '[^0-9]';
		Pattern p = Pattern.compile(regEx);
		Matcher m = p.matcher(pTelNo);
		String theReplaced = m.replaceAll('').trim();
		return String.isBlank(theReplaced) ? null : theReplaced;
	}

	public class SendReq {
		public String opp_id = '';
		public String account_id = '';
		public String theTelno= '';
		public String theMsg= '';
	}

	public class SendRes {
		public Boolean is_success = false;
		public ApexPages.Severity severity;
		public String msg = '';
	}

}