@isTest
public class Testing_HttpResMock implements HttpCalloutMock{

	private List<Testing_HttpResponders.IResponder> responders = new List<Testing_HttpResponders.IResponder>();

	public Testing_HttpResMock addResponder(Testing_HttpResponders.IResponder pResponder){
		this.responders.add(pResponder);
		return this;
	}

	public HttpResponse respond(HTTPRequest pRequest) {
		System.Debug('Testing_HttpResMock/CallOutDetected/Endpoint=' + pRequest.getEndpoint());
		Testing_HttpResponders.IResponder theResponder = this.resolveResponder(pRequest);
		if(theResponder == null){
			System.Debug('Testing_HttpResMock/ResponderNotFound/Endpoint=' + pRequest.getEndpoint());
		}
		return theResponder.respond(pRequest);
	}

	private Testing_HttpResponders.IResponder resolveResponder(HTTPRequest pRequest){
		for(Testing_HttpResponders.IResponder aResponder : this.responders){
			if( aResponder.isMatch(pRequest) ) return aResponder;
		}
		return null;
	}
}