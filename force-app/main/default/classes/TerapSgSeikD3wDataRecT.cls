@isTest public class TerapSgSeikD3wDataRecT {
    @isTest public static void CsvConverter_get_csv(){
        Test.startTest();
        TerapSgSeikD3wDataRec.get_ICsvConverter_instance()
        .get_csv(
            new List<TerapSgSeikD3wDataRec.Record>{
                new TerapSgSeikD3wDataRec.Record()
            }, 
            true
        );
        Test.stopTest();
    }
}