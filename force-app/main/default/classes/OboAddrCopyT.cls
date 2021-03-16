@isTest
public class OboAddrCopyT {

    private static void setUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new List<LoggingsConfig__c>{
            new LoggingsConfig__c(
                name='dev', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                ),
            new LoggingsConfig__c(
                name='prod', LevelsToWrite__c='Error, Warn, Info', WriteLogAttributeRecords__c=true,
                DmlStatementsLeftToStopLogging__c = 10, DmlStatementsLeftToWarn__c = 20,
                DmlRowsLeftToStopLogging__c = 100, DmlRowsLeftToWarn__c = 200
                )
        };
        Insert new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('null').getRecordTypeId(),
            FirstName = '_', LastName = '_'
        );
    }

    @isTest
    public static void when_structuredAddress_inserted_then_should_be_Copied_to_textAddress(){
        setUp();

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{
            '1' => new Obosanbin__c(
                hoyo_postcode__c = '001-0001', 
                hoyo_todofuken__c = '法要都道府県', hoyo_shikugun__c = '法要市区郡', 
                hoyo_tyoumei__c = '法要町名', hoyo_banchi__c = '法要町名番地',

                tuika_postcode__c = '002-0002', 
                tuika_todofuken__c = '追加法要都道府県', tuika_shikugun__c = '追加法要市区郡', 
                tuika_tyoumei__c = '追加法要町名', tuika_banchi__c = '追加法要町名番地',
                
                sogi_postcode__c = '003-0003', 
                sogi_todofuken__c = '葬儀都道府県', sogi_shikugun__c = '葬儀市区郡', 
                sogi_tyoumei__c = '葬儀町名', sogi_banchi__c = '葬儀町名番地'
            )
        };
        Test.startTest();
        INSERT theObous.values();
        Test.stopTest();

        Obosanbin__c theActual = 
        [
            SELECT 
            hoyo_postcode__c, hoyo_todofuken__c, hoyo_shikugun__c, hoyo_tyoumei__c, hoyo_banchi__c, HoyoBashoAddress__c, 
            tuika_postcode__c, tuika_todofuken__c, tuika_shikugun__c, tuika_tyoumei__c, tuika_banchi__c, TsuikahoyobashoAddress__c,
            sogi_postcode__c, sogi_todofuken__c, sogi_shikugun__c, sogi_tyoumei__c, sogi_banchi__c, SaijoAddress__c
            FROM Obosanbin__c 
            WHERE Id = : theObous.get('1').Id
        ].get(0);


        System.AssertEquals(
        	'001-0001 法要都道府県法要市区郡法要町名法要町名番地', theActual.HoyoBashoAddress__c,'法要場所 should be copied.'
		);
        System.AssertEquals(
        	'002-0002 追加法要都道府県追加法要市区郡追加法要町名追加法要町名番地', theActual.TsuikahoyobashoAddress__c,'追加法要場所 address should be copied.'
		);
        System.AssertEquals(
        	'003-0003 葬儀都道府県葬儀市区郡葬儀町名葬儀町名番地', theActual.SaijoAddress__c,'葬儀場所 address should be copied.'
		);
    } 

    @isTest
    public static void when_structuredAddress_updated_then_should_be_Copied_to_textAddress(){
        setUp();

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{
            '1' => new Obosanbin__c()
        };
        INSERT theObous.values();

        Test.startTest();
        for(Obosanbin__c aNewOne : [ SELECT Id FROM Obosanbin__c WHERE Id = :theObous.get('1').Id LIMIT 1 ]){
            UPDATE New Obosanbin__c( Id = theObous.get('1').Id,
                hoyo_postcode__c = '001-0001', 
                hoyo_todofuken__c = '法要都道府県', hoyo_shikugun__c = '法要市区郡', 
                hoyo_tyoumei__c = '法要町名', hoyo_banchi__c = '法要町名番地',

                tuika_postcode__c = '002-0002', 
                tuika_todofuken__c = '追加法要都道府県', tuika_shikugun__c = '追加法要市区郡', 
                tuika_tyoumei__c = '追加法要町名', tuika_banchi__c = '追加法要町名番地',
                
                sogi_postcode__c = '003-0003', 
                sogi_todofuken__c = '葬儀都道府県', sogi_shikugun__c = '葬儀市区郡', 
                sogi_tyoumei__c = '葬儀町名', sogi_banchi__c = '葬儀町名番地'
            );
        }
        Test.stopTest();
        
        Obosanbin__c theActual = 
        [
            SELECT 
            hoyo_postcode__c, hoyo_todofuken__c, hoyo_shikugun__c, hoyo_tyoumei__c, hoyo_banchi__c, HoyoBashoAddress__c, 
            tuika_postcode__c, tuika_todofuken__c, tuika_shikugun__c, tuika_tyoumei__c, tuika_banchi__c, TsuikahoyobashoAddress__c,
            sogi_postcode__c, sogi_todofuken__c, sogi_shikugun__c, sogi_tyoumei__c, sogi_banchi__c, SaijoAddress__c
            FROM Obosanbin__c 
            WHERE Id = : theObous.get('1').Id
        ].get(0);


        System.AssertEquals(
        	'001-0001 法要都道府県法要市区郡法要町名法要町名番地', theActual.HoyoBashoAddress__c,'法要場所 should be copied.'
		);
        System.AssertEquals(
        	'002-0002 追加法要都道府県追加法要市区郡追加法要町名追加法要町名番地', theActual.TsuikahoyobashoAddress__c,'追加法要場所 address should be copied.'
		);
        System.AssertEquals(
        	'003-0003 葬儀都道府県葬儀市区郡葬儀町名葬儀町名番地', theActual.SaijoAddress__c,'葬儀場所 address should be copied.'
		);
    } 

    @isTest
    public static void when_textAddress_inserted_then_should_be_Copied_into_banchiOfstructuredAddress(){
        setUp();

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{
            '1' => new Obosanbin__c(
                HoyoBashoAddress__c = '001-0001 法要都道府県法要市区郡法要町名法要町名番地',
                TsuikahoyobashoAddress__c = '002-0002 追加法要都道府県追加法要市区郡追加法要町名追加法要町名番地',
                SaijoAddress__c = '003-0003 葬儀都道府県葬儀市区郡葬儀町名葬儀町名番地'
            )
        };
        Test.startTest();
        INSERT theObous.values();
        Test.stopTest();

        Obosanbin__c theActual = 
        [
            SELECT 
            hoyo_banchi__c, HoyoBashoAddress__c, 
            tuika_banchi__c, TsuikahoyobashoAddress__c,
            sogi_banchi__c, SaijoAddress__c
            FROM Obosanbin__c 
            WHERE Id = : theObous.get('1').Id
        ].get(0);


        System.AssertEquals(
        	'001-0001 法要都道府県法要市区郡法要町名法要町名番地', theActual.hoyo_banchi__c,'法要場所 should be copied.'
		);
        System.AssertEquals(
        	'002-0002 追加法要都道府県追加法要市区郡追加法要町名追加法要町名番地', theActual.tuika_banchi__c,'追加法要場所 address should be copied.'
		);
        System.AssertEquals(
        	'003-0003 葬儀都道府県葬儀市区郡葬儀町名葬儀町名番地', theActual.sogi_banchi__c,'葬儀場所 address should be copied.'
		);
    } 

    @isTest
    public static void when_textAddress_updated_then_should_be_Copied_into_banchiOfstructuredAddress(){
        setUp();

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{
            '1' => new Obosanbin__c()
        };
        INSERT theObous.values();

        Test.startTest();
        for(Obosanbin__c aNewOne : [ SELECT Id FROM Obosanbin__c WHERE Id = :theObous.get('1').Id LIMIT 1 ]){
            UPDATE New Obosanbin__c( Id = theObous.get('1').Id,
                HoyoBashoAddress__c = '001-0001 法要都道府県法要市区郡法要町名法要町名番地',
                TsuikahoyobashoAddress__c = '002-0002 追加法要都道府県追加法要市区郡追加法要町名追加法要町名番地',
                SaijoAddress__c = '003-0003 葬儀都道府県葬儀市区郡葬儀町名葬儀町名番地'
            );
        }
        Test.stopTest();
        
        Obosanbin__c theActual = 
        [
            SELECT 
            hoyo_banchi__c, HoyoBashoAddress__c, 
            tuika_banchi__c, TsuikahoyobashoAddress__c,
            sogi_banchi__c, SaijoAddress__c
            FROM Obosanbin__c 
            WHERE Id = : theObous.get('1').Id
        ].get(0);

        System.AssertEquals(
        	'001-0001 法要都道府県法要市区郡法要町名法要町名番地', theActual.hoyo_banchi__c,'法要場所 should be copied.'
		);
        System.AssertEquals(
        	'002-0002 追加法要都道府県追加法要市区郡追加法要町名追加法要町名番地', theActual.tuika_banchi__c,'追加法要場所 address should be copied.'
		);
        System.AssertEquals(
        	'003-0003 葬儀都道府県葬儀市区郡葬儀町名葬儀町名番地', theActual.sogi_banchi__c,'葬儀場所 address should be copied.'
		);
    } 
}