public class MTeianShoBackImgs {
	private static MTeianShoBackImgs__mdt f_cachedData = null;

    private static MTeianShoBackImgs__mdt loadConfig(String Parameter){
    	if(f_cachedData != null) return f_cachedData;

		String theKey = Environments.isSandbox() ? 'dev' : 'prod';
		String theKeyName = theKey + '_' + Parameter;
        f_cachedData =
            [
                select id, 
				Cyokuso__c, Cyokuso_Kingaku__c,
				Kaso_Mushukyo__c, Kaso_Mushukyo_Kingaku__c,
				Kaso_Bussiki__c, Kaso_Bussiki_Kingaku__c,
				Kaso_Hanataba__c, Kaso_Hanataba_Kingaku__c,
				Ichinichi_Mushukyo__c, Ichinichi_Mushukyo_Kingaku__c,
				Ichinichi_Bussiki__c, Ichinichi_Bussiki_Kingaku__c,
				Ichinichi_Ohana__c, Ichinichi_Ohana_Kingaku__c,
				Kazoku_Mushukyo__c, Kazoku_Mushukyo_Kingaku__c,
				Kazoku_Bussiki__c, Kazoku_Bussiki_Kingaku__c,
				Kazoku_Ohana__c, Kazoku_Ohana_Kingaku__c,
				Ippan_Mushukyo__c, Ippan_Mushukyo_Kingaku__c,
				Ippan_Bussiki__c, Ippan_Bussiki_Kingaku__c,
				Ippan_Ohana__c, Ippan_Ohana_Kingaku__c
                from MTeianShoBackImgs__mdt
                where MasterLabel = :theKeyName
                Limit 1
            ]
            .get(0);

        return f_cachedData;
    }

	public static MTeianShoBackImgs__mdt getConfig(String Parameter){
		loadConfig(Parameter);
		return f_cachedData;
	}
}