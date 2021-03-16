@isTest
public class OpFcReqT {

    @isTest public static void Req_getParamString() {

        Test.startTest();
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
                .setTemplateName('live_ume_dev_001')
                .addDatasets(
                    new List<OpFcReq.DataSet>{
                        new OpFcReq.DataSet()
                        .addRows(
                            new List<OpFcReq.CsvRow>{
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'name','address','備考'} ),
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'梅崎 丈晴','1410031　東京都品川区西五反田１－１','これはサンプルです' } )
                            }
                        ),
                        new OpFcReq.DataSet()
                        .addRows(
                            new List<OpFcReq.CsvRow>{
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'name','unit_price','quantity','price'} ),
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'はぶらし','1000','2','2000' } ),
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'はみがきこ','1000','1','1000' } )
                            }
                        ),
                        new OpFcReq.DataSet()
                        .addRows(
                            new List<OpFcReq.CsvRow>{
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'name','unit_price','quantity','price'} ),
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'割引A','1000','2','2000' } ),
                                new OpFcReq.CsvRow().setColumnValues( new List<String>{'割引B','1000','1','1000' } )
                            }
                        )
                    }
                ),
                new OpFcReq.TemplateData()
                .setTemplateName('live_ume_excel_001')
                .addDatasets(
                    new List<OpFcReq.DataSet>{
                        new OpFcReq.DataSet()
                        .addRows(
                            new List<OpFcReq.CsvRow>{
                                new OpFcReq.CsvRow()
                                .setColumnValues(
                                    new List<String>{'data01'}
                                ),
                                new OpFcReq.CsvRow()
                                .setColumnValues(
                                    new List<String>{'data of data01'}
                                )
                            }
                        )
                    }
                )
            }
        );

        theReq.getParamString(); // http request の body

        Test.stopTest();
    }
}