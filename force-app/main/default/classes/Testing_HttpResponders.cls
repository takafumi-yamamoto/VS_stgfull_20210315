@isTest
public class Testing_HttpResponders{

	public interface IResponder{
		Boolean isMatch(HTTPRequest pRequest);
		HttpResponse respond(HTTPRequest pRequest);
	}

	public class UrlContains implements IResponder{

		private Integer statusCode;
		private String body;
		private String strUrlContains;

		public Boolean isMatch(HTTPRequest pRequest){
			if(strUrlContains == null) return false;
			return pRequest.getEndpoint().contains(this.strUrlContains);
		}
		public HttpResponse respond(HTTPRequest pRequest){
            HttpResponse theResponse = new HttpResponse();
            theResponse.setStatusCode(this.statusCode);
            if(this.body != null) theResponse.setBody( this.body );
            return theResponse;
		}

	    public UrlContains setBody(String pValue){
	        this.body = pValue; return this;
	    }
	    public UrlContains setStatusCode(Integer pValue){
	        this.statusCode = pValue; return this;
	    }
	    public UrlContains setStrUrlContains(String pValue){
	        this.strUrlContains = pValue; return this;
	    }
	}

	public class CatchAll implements IResponder{

		private Integer statusCode;
		private String body;

		public Boolean isMatch(HTTPRequest pRequest){
			return true;
		}
		public HttpResponse respond(HTTPRequest pRequest){
            HttpResponse theResponse = new HttpResponse();
            theResponse.setStatusCode(this.statusCode);
            if(this.body != null) theResponse.setBody( this.body );
            return theResponse;
		}

	    public CatchAll setStatusCode(Integer pValue){
	        this.statusCode = pValue; return this;
	    }

	    public CatchAll setBody(String pValue){
	        this.body = pValue; return this;
	    }
	}
}