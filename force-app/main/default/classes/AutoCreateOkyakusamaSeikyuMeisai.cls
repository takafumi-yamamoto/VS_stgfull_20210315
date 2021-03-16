public class AutoCreateOkyakusamaSeikyuMeisai {
    public static boolean isActive = true;

    public static void subscriveOnOpportunityAfterUpdated(list<Opportunity> newOnes, Map<Id, Opportunity> oldOnes){
        if(!isActive) return;

        List<Opportunity> theTargets = new List<Opportunity>();
        Set<Id> theTorihikiShodanIds = new Set<Id>();
        Id theObouRecTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');

        for( Opportunity aNewOne : newOnes ){
            Opportunity aOldOne = oldOnes.get(aNewOne.Id);

            if(aNewOne.RecordTypeId != theObouRecTypeId) continue;

            Boolean theToBeProcessed = false;

            if(
                aNewOne.StageName != aOldOne.StageName
                &&
                !(aOldOne.StageName == '施行待ち' || aOldOne.StageName == '施行完了')
                && 
                (aNewOne.StageName == '施行待ち' || aNewOne.StageName == '施行完了')
            ){
                theToBeProcessed = true;
            }

            if(
                (aNewOne.StageName != aOldOne.StageName || aNewOne.SubPhase__c != aOldOne.SubPhase__c)
                &&
                !(aOldOne.StageName == '決定' && aOldOne.SubPhase__c == '依頼書・手配報告書作成')
                && 
                aNewOne.StageName == '決定' && aNewOne.SubPhase__c == '依頼書・手配報告書作成'
            ){
                theToBeProcessed = true;
            }
            
            if(aNewOne.TorihikiShodanRef__c != null) theTorihikiShodanIds.add(aNewOne.TorihikiShodanRef__c);
            if( theToBeProcessed ) theTargets.add(aNewOne);
        }

        if(theTargets.size() <= 0) return;

        List<OkyakusamaSeikyuMeisai__c> insertOkyakusamaSeikyuMeisai = new List<OkyakusamaSeikyuMeisai__c>();

        Map<Id, Opportunity> theTorihikiShodans = new Map<Id, Opportunity>(
            [
                select Id, RecordType.DeveloperName, AzukariKingakuGoukei__c from Opportunity where Id = :theTorihikiShodanIds
            ]
        );
        Map<Id, Opportunity> theOppsWithOppLineItems = new Map<Id, Opportunity>([
            select Id,
            (select Id from OpportunityLineItems)
            from Opportunity
            where Id = :SobjectsExtension.collectIds(theTargets)
        ]);

        for( Opportunity aNewOne : theTargets ){

            if( String.isBlank(aNewOne.Iriguchi__c) ) {
                aNewOne.addError('流入経路（新規）未入力');
                continue;
            }

            if( theOppsWithOppLineItems.get( aNewOne.Id ).OpportunityLineItems.size() <= 0 ){
                aNewOne.addError('商品未入力');
                continue;
            }

            if(aNewOne.UriageKingakuCustExp__c - aNewOne.KaisyuYoteGokeKingaku__c <= 0) continue;

            OkyakusamaSeikyuMeisai__c createSeikyuMeisai = new OkyakusamaSeikyuMeisai__c(
                ServiceSyubetsu__c = 'お坊さん便',
                SeikyuKingaku__c = aNewOne.UriageKingakuCustExp__c - aNewOne.KaisyuYoteGokeKingaku__c,
                OpportunityRef__c = aNewOne.Id,
                SeikyuHouhou__c = null
            );

            if(createSeikyuMeisai.SeikyuHouhou__c == null && aNewOne.Iriguchi__c == 'Amazon'){
                createSeikyuMeisai.RecordTypeId = 
                    Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId();
                createSeikyuMeisai.SeikyuHouhou__c = 'Amazon';
                createSeikyuMeisai.Kessaibi__c  = aNewOne.Req_Day__c.date();
            }
            if(createSeikyuMeisai.SeikyuHouhou__c == null && aNewOne.Iriguchi__c == 'Yahoo'){
                createSeikyuMeisai.RecordTypeId = 
                    Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId();
                createSeikyuMeisai.SeikyuHouhou__c = 'Yahoo';
                createSeikyuMeisai.Kessaibi__c  = aNewOne.Req_Day__c.date();
            }

            Opportunity theTorihikiShodan = theTorihikiShodans.get(aNewOne.TorihikiShodanRef__c);
            
            if(createSeikyuMeisai.SeikyuHouhou__c == null && theTorihikiShodan != null && theTorihikiShodan.RecordType.DeveloperName == 'Seizenkeiyaku' ){
                Decimal theAzukariKingaku = theTorihikiShodan.AzukariKingakuGoukei__c == null ? 0 : theTorihikiShodan.AzukariKingakuGoukei__c;
                if(theAzukariKingaku > 0){
                    createSeikyuMeisai.RecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('Sosai').getRecordTypeId();
                    createSeikyuMeisai.SeikyuHouhou__c = 'sousai';
                    createSeikyuMeisai.Kessaibi__c  = aNewOne.Utiagebi__c;
                    createSeikyuMeisai.SousaiSakiShodanRef__c  = theTorihikiShodan.Id;          
                }
            }

            if(createSeikyuMeisai.SeikyuHouhou__c == null){
                createSeikyuMeisai.RecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId();
                createSeikyuMeisai.SeikyuHouhou__c = 'Partner';
                createSeikyuMeisai.Kessaibi__c  = aNewOne.Utiagebi__c;
            }
            insertOkyakusamaSeikyuMeisai.add(createSeikyuMeisai);
        }
        Insert insertOkyakusamaSeikyuMeisai;

    }
}