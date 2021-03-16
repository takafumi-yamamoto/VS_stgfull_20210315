@isTest
private class GoogleMapApiT {
	@isTest static void test_method_one() {
		Insert new Ken_all__c(post_code__c='1500001',todofuken__c='東京',shikugun__c='品川区',tyoumei__c='五反田');

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

		Test.setMock( HttpCalloutMock.class, new HttpResponseMock().setStatusCode(200).setBody(google_api_resbody) );
		Test.startTest();


		KenSearchController.Location loc = KenSearchController.getLocation('150-0001', '', '', '', '');
		System.debug(loc);

		Test.stopTest();
	}
}