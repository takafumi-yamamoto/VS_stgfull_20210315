public class SaijoHallAuraCtl {
	
	@AuraEnabled
    public static List<SaijoHall__c> auraGetSaijoHallListBySaijoId(String recordId) {
        return [select Id, 
        				Name, 
        				SaijoHallKana__c, 
        				TaioShikishubetsu__c, 
        				JogenKaisoshasu__c, 
        				Sekisu__c, 
                        ShikijonoYokohabaShaku__c, 
        				X1ShiyoRyokinIppan__c, 
        				X1ShiyoRyokinShimin__c, 
        				X1ShiyoRyokinSonota__c, 
        				X2ShiyoRyokinIppan__c, 
        				X2ShiyoRyokinShimin__c, 
        				X2ShiyoRyokinSonota__c, 
                        ShiyoRyokinBiko__c 
        			from SaijoHall__c 
        			where SaijoRef__c = :recordId 
                    order by JogenKaisoshasu__c desc
        		];
    }
}