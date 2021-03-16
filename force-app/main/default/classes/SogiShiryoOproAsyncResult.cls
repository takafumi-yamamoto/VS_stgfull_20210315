public class SogiShiryoOproAsyncResult {

    public Integer status {get;set;} 
    public String statusDescription {get;set;} 
    public Headers headers {get;set;} 
    public String body {get;set;} 

	public class Content_type {
		public String key {get;set;} 
		public String value {get;set;} 

		public Content_type(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'key') {
							key = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug('Content_type consuming unrecognized property: '+text);
							break;
						}
					}
				}else if(parser.getCurrentToken() == null){
					break;
				}
			}
		}
	}
	
	public class Headers {
		public List<Content_type> content_type {get;set;} // in json: content-type

		public Headers(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'content-type') {
							content_type = arrayOfContent_type(parser);
						} else {
							System.debug('Headers consuming unrecognized property: '+text);
							break;
						}
					}
				}else if(parser.getCurrentToken() == null){
					break;
				}
			}
		}
	}
	


    public SogiShiryoOproAsyncResult(JSONParser parser) {
		Integer i = 0;
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'status') {
                        status = parser.getIntegerValue();
                    } else if (text == 'statusDescription') {
                        statusDescription = parser.getText();
                    } else if (text == 'headers') {
                        headers = new Headers(parser);
                    } else if (text == 'body') {
                        body = parser.getText();
                    } else {
						System.debug('OproAsyncResult consuming unrecognized property: '+text);
						break;
                    }
                }
			}else if(parser.getCurrentToken() == null){
				break;
			}
		}
    }
	
	
	public static SogiShiryoOproAsyncResult parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new SogiShiryoOproAsyncResult(parser);
	}
	
  private static List<Content_type> arrayOfContent_type(System.JSONParser p) {
      List<Content_type> res = new List<Content_type>();
      if (p.getCurrentToken() == null) p.nextToken();
      while (p.nextToken() != System.JSONToken.END_ARRAY) {
          res.add(new Content_type(p));
      }
      return res;
  }
}