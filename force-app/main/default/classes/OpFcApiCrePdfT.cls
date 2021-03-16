@isTest
public class OpFcApiCrePdfT {
    @isTest public static void Client_sendRequest() {

        OpFcApiCrePdf.Res theRes = new OpFcApiCrePdf.Res();
        theRes.path = '/pdf-file-name';
        Test.setMock( HttpCalloutMock.class, 
        new Testing_HttpResMock()
            .addResponder(
                new Testing_HttpResponders.UrlContains()
                    .setStrUrlContains( OpFcApiCrePdf.getEndPoint() )
                    .setStatusCode(200)
                    .setBody( JSON.serialize(theRes) )
            )
            .addResponder(
                new Testing_HttpResponders.CatchAll()
                    .setStatusCode(200)
            )
        );

        OpFcReq.Req theReq = 
        new OpFcReq.Req()
        .setCid('CID')
        .setUid('UID')
        .setUpw('UPW')
        .setFontEmb(true) //font埋め込み
        .setOproPdfPassword('password')//Password; 各データの最後の列に opro_pdf_password として追加される; Opro帳票側でマッピングする必要がある。
        .addTemplateDatas(
            new List<OpFcReq.TemplateData>{
                new OpFcReq.TemplateData()
                .setTemplateName('template_name')
                .addDatasets(
                    new List<OpFcReq.DataSet>{
                        new OpFcReq.DataSet()
                        .addRows(
                            new List<OpFcReq.CsvRow>{
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'co1','co2','col3'} ),
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'data1','data2','data3' } ),
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'data1','data2','data3' } )
                            }
                        )
                    }
                )
            }
        );

        Test.startTest();
        OpFcApiCrePdf.Result theResult = new OpFcApiCrePdf.Client().sendRequest(theReq);
        Test.stopTest();

        String thePdfUrl = OpFcApiCrePdf.getCreatedPdfBaseEndPoint() + theResult.response.path;
    }
}