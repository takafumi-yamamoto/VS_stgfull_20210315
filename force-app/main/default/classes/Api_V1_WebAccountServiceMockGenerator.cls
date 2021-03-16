@isTest
global class Api_V1_WebAccountServiceMockGenerator implements HttpCalloutMock{

    global HttpResponse respond(HttpRequest req){

        //System.debug('>>>>>HttpResponseMockGenerator start');

        //WebAccountTourokuIraiService.WebAccountTourokuIraiResponseParam responseParam = new WebAccountTourokuIraiService.WebAccountTourokuIraiResponseParam();
        //responseParam.response = new List<WebAccountTourokuIraiService.WebAccountTourokuIraiResponseBean>();
        //WebAccountTourokuIraiService.WebAccountTourokuIraiResponseBean bean = new WebAccountTourokuIraiService.WebAccountTourokuIraiResponseBean();
        
        //bean.irai_id = 'irai_id_10001'; //依頼書Id
        //bean.code = 0; 
        //responseParam.response.add(bean);


        //String responseJsonStr = JSON.serialize(responseParam);
        //System.debug('>>>>>responseJsonStr');
        //System.debug(responseJsonStr);

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        
        //res.setBody(responseJsonStr);
        //res.setStatusCode(200);
        return res;
    }
    
}