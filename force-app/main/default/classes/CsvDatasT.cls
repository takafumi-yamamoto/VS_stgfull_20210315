@isTest
public class CsvDatasT {
    @isTest public static void DataSet_get_csv_encoded() {
        Test.startTest();
        new CsvDatas.DataSet(
            new List<CsvDatas.Row>{
                new CsvDatas.Row( new List<String>{'col-1','col-2'} ),
                new CsvDatas.Row( new List<String>{'val-1-1','val-1-2'} )
            }
        )
        .get_csv_encoded();
        Test.stopTest();
    }
}