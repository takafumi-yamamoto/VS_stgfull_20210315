@isTest
public class SogiShiryoOproAsyncResultT {

    @isTest
	static void testParse() {
		String json = '{\"status\":200,\"statusDescription\":\"OK\",\"headers\":{\"content-type\":[{\"key\":\"Content-Type\",\"value\":\"application/json\"}]},\"body\":\"{\\\"path\\\":\\\"/7b58bf8a99bb1f8a44f335643018efb349970493.pdf\\\"}\"}';
		SogiShiryoOproAsyncResult r = SogiShiryoOproAsyncResult.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		SogiShiryoOproAsyncResult.Content_type objContent_type = new SogiShiryoOproAsyncResult.Content_type(System.JSON.createParser(json));
		System.assert(objContent_type != null);
		System.assert(objContent_type.key == null);
		System.assert(objContent_type.value == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		SogiShiryoOproAsyncResult.Headers objHeaders = new SogiShiryoOproAsyncResult.Headers(System.JSON.createParser(json));
		System.assert(objHeaders != null);
		System.assert(objHeaders.content_type == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		SogiShiryoOproAsyncResult objOproAsyncResult = new SogiShiryoOproAsyncResult(System.JSON.createParser(json));
		System.assert(objOproAsyncResult != null);
		System.assert(objOproAsyncResult.status == null);
		System.assert(objOproAsyncResult.statusDescription == null);
		System.assert(objOproAsyncResult.headers == null);
		System.assert(objOproAsyncResult.body == null);

		r = SogiShiryoOproAsyncResult.parse('');
		json = '{\"status\":200,\"statusDescription\":\"OK\",\"headers\":\"\",\"body\":\"{\\\"path\\\":\\\"/7b58bf8a99bb1f8a44f335643018efb349970493.pdf\\\"}\"}';
		r = SogiShiryoOproAsyncResult.parse(json);
	}
}