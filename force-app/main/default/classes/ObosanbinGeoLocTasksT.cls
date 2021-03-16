@isTest
public class ObosanbinGeoLocTasksT {

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

    private static String sampleGoogleMapResPayload(){
		String google_api_resbody =	'{' +
			'    "status": "OK", ' +
			'    "results": [' +
			'        {' +
			'            "place_id": "ChIJdTtbGAuMGGARnJWRvJ_ngjI", ' +
			'            "geometry": {' +
			'                "bounds": null, ' +
			'                "location_type": "ROOFTOP", ' +
			'                "viewport": {' +
			'                    "southwest": {' +
			'                        "lng": 139.7522495197085, ' +
			'                        "lat": 35.68237311970849' +
			'                    }, ' +
			'                    "northeast": {' +
			'                        "lng": 139.7549474802915, ' +
			'                        "lat": 35.68507108029149' +
			'                    }' +
			'                }, ' +
			'                "location": {' +
			'                    "lng": 139.7535985, ' +
			'                    "lat": 35.6837221' +
			'                }' +
			'            }, ' +
			'            "address_components": [' +
			'                {' +
			'                    "short_name": "１", ' +
			'                    "types": [' +
			'                        "premise"' +
			'                    ], ' +
			'                    "long_name": "１"' +
			'                }, ' +
			'                {' +
			'                    "short_name": "１", ' +
			'                    "types": [' +
			'                        "political", ' +
			'                        "sublocality", ' +
			'                        "sublocality_level_4"' +
			'                    ], ' +
			'                    "long_name": "１"' +
			'                }, ' +
			'                {' +
			'                    "short_name": "千代田", ' +
			'                    "types": [' +
			'                        "political", ' +
			'                        "sublocality", ' +
			'                        "sublocality_level_2"' +
			'                    ], ' +
			'                    "long_name": "千代田"' +
			'                }, ' +
			'                {' +
			'                    "short_name": "千代田区", ' +
			'                    "types": [' +
			'                        "locality", ' +
			'                        "political"' +
			'                    ], ' +
			'                    "long_name": "千代田区"' +
			'                }, ' +
			'                {' +
			'                    "short_name": "東京都", ' +
			'                    "types": [' +
			'                        "administrative_area_level_1", ' +
			'                        "political"' +
			'                    ], ' +
			'                    "long_name": "東京都"' +
			'                }, ' +
			'                {' +
			'                    "short_name": "JP", ' +
			'                    "types": [' +
			'                        "country", ' +
			'                        "political"' +
			'                    ], ' +
			'                    "long_name": "日本"' +
			'                }, ' +
			'                {' +
			'                    "short_name": "100-0001", ' +
			'                    "types": [' +
			'                        "postal_code"' +
			'                    ], ' +
			'                    "long_name": "100-0001"' +
			'                }' +
			'            ], ' +
			'            "types": [' +
			'                "street_address"' +
			'            ], ' +
			'            "formatted_address": "日本、〒100-0001 東京都千代田区千代田１−１"' +
			'        }' +
			'    ]' +
			'}';
        return google_api_resbody;
    }

	@isTest static void when_address_changed_then_geoLocation_should_be_updated() {
		setUp();

        Test.setMock( HttpCalloutMock.class, 
        	new Testing_HttpResMock()
        		.addResponder(
        			new Testing_HttpResponders.UrlContains()
        				.setStrUrlContains( GoogleMapApiConfig.getConfig().Endpoint__c )
        				.setStatusCode(200)
        				.setBody( sampleGoogleMapResPayload() )
    			)
        		.addResponder(
        			new Testing_HttpResponders.CatchAll()
        				.setStatusCode(200)
    			)
    	);

        Map<String, Obosanbin__c> theObous = new Map<String,Obosanbin__c>{
            '1' => new Obosanbin__c(
                hoyo_postcode__c = '100-0001', hoyo_todofuken__c = '東京都', hoyo_shikugun__c = '千代田区', hoyo_tyoumei__c = '千代田', hoyo_banchi__c = '１−１',
                tuika_postcode__c = '100-0001', tuika_todofuken__c = '東京都', tuika_shikugun__c = '千代田区', tuika_tyoumei__c = '千代田', tuika_banchi__c = '１−１',
                sogi_postcode__c = '100-0001', sogi_todofuken__c = '東京都', sogi_shikugun__c = '千代田区', sogi_tyoumei__c = '千代田', sogi_banchi__c = '１−１'
            )
        };
        Test.startTest();
        INSERT theObous.values();
        Test.stopTest();
	}
}