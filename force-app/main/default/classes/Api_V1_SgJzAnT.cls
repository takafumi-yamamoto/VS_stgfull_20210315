@isTest
public class Api_V1_SgJzAnT {

	private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
	}

	private static void endSetUp(){
		Insert new TriggerIsActive__c( name='default', isActive__c=true );
		Insert new JizenWariPlan__c( Code__c='Yoriso' );
		Insert new Account(
			RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
			FirstName = '_', LastName = '_'
		);
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}

	private class Processor_Stub implements Api_V1_SgJzAn.IProcessor{
		public void save( Api_V1_SgJzAn.Data theData ){ 
		}
	}

	private class ProcessorErr_Stub implements Api_V1_SgJzAn.IProcessor{
		public void save( Api_V1_SgJzAn.Data theData ){ 
			throw new Exceptions.AnException();
		}
	}

	private class TESTData{
		public Api_V1_SgJzAn.Data get_TESTData(){
			Api_V1_SgJzAn.Data theData = new Api_V1_SgJzAn.Data();
			theData.gaclient_id = '1111111111.2222222222';
			theData.mail_syori_id = '11111';
			theData.toiawase_date = '2017-04-10';
			theData.sogi_webshiryoseikyu_uniquekey = '0901234123420170410200716';
			theData.customer_sei = 'テスト';
			theData.customer_mei = 'テスト';
			theData.customer_sei_kana = 'テスト';
			theData.customer_mei_kana = 'テスト';
			theData.customer_birthday = '2017-04-10';
			theData.customer_tel = '09012341234';
			theData.customer_mail = 'TEST@TEST.com';
			theData.customer_postal_code = '141-0031';
			theData.customer_state = '東京都';
			theData.customer_city = '品川区';
			theData.customer_street = '五反田';
			theData.taisyosya_jokyo = '健在';
			theData.taisyosya_sei = 'テスト';
			theData.taisyosya_mei = 'テスト';
			theData.taisyosya_sei_kana = 'テスト';
			theData.taisyosya_mei_kana = 'テスト';
			theData.taisyosya_birthday = '2017-04-10';
			theData.taisyosya_tel = '09012341234';
			theData.taisyosya_postal_code = '141-0031';
			theData.taisyosya_state = '東京都';
			theData.taisyosya_city = '品川区';
			theData.taisyosya_street = '五反田';
			theData.taisyosya_juminhyo_state = '東京都';
			theData.taisyosya_juminhyo_city = '品川区';
			theData.taisyosya_syuha = '';
			theData.taisyosya_sonotasyuha = '';
			theData.taisyosya_bodaiji_umu = '';
			theData.taisyosya_from_customer = '';
			theData.taisyosya_from_customer_sonota = '';
			theData.omukae_name = '';
			theData.omukae_postal_code = '';
			theData.omukae_state = '';
			theData.omukae_city = '';
			theData.omukae_street = '';
			theData.anchisaki_kubun = '';
			theData.sogi_yotei_area_state = '';
			theData.sogi_yotei_area_city = '';
			theData.simpleyasugo_plan = '';
			theData.simpleyasugo_obousanbin_plan = '';
			theData.campaign_id = '';
			theData.yoriso_wo_sitta_kikkake = '';
			theData.juminhyo_address_info = '';
			theData.omukae_address_info = '';
			return theData;
		}
		
	}
	
	@isTest
	public static void doPost(){

		Api_V1_SgJzAn.mSogiJizenAncate = new Processor_Stub();
		Api_V1_SgJzAn.Data theData = new TESTData().get_TESTData();
		
		Test.startTest();
			
		try{

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v1/sogi_jizen_ancate';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(JSON.serialize( theData ));

		RestContext.request = req;
		RestContext.response= res;
		
		Api_V1_SgJzAn.doPost();

		}catch(DmlException e) {
		}
			
		Test.stopTest();
	}

	@isTest
	public static void doPostErr(){

		Api_V1_SgJzAn.mSogiJizenAncate = new ProcessorErr_Stub();
		Api_V1_SgJzAn.Data theData = new TESTData().get_TESTData();
		
		Test.startTest();
			
		try{

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/api/v1/sogi_jizen_ancate';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(JSON.serialize( theData ));

		RestContext.request = req;
		RestContext.response= res;
		
		Api_V1_SgJzAn.doPost();

		}catch(DmlException e) {
		}
			
		Test.stopTest();
	}

	@isTest
	public static void Processor_save(){
	
		Test.startTest();

		Api_V1_SgJzAn.Data theData = new TESTData().get_TESTData();
		Api_V1_SgJzAn.Processor theProcessor = new Api_V1_SgJzAn.Processor();
		theProcessor.save(theData);

		Test.stopTest();
	}
}