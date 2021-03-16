public class FreeApiVolumeTestBat implements Database.Batchable<sObject>,Database.AllowsCallouts{

    public static void start(){
		Database.executeBatch(new FreeApiVolumeTestBat(), 1);
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {

		return Database.getQueryLocator(
            [
                SELECT Id, ShodanBango__c, Utiagebi__c,SeikyuZandakaPartnerExp__c,
                SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c
                FROM Opportunity 
                WHERE RecordTypeId =:RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo')
                AND Utiagebi__c != NULL
                AND StageName = '商談クローズ'
                AND SeikyuZandakaPartnerExp__c > 0
                LIMIT 1000
            ]
            
        );
    }
    
	public void execute(Database.BatchableContext bc, List<Opportunity> scope){

        Opportunity aRecord = scope.get(0);

        try{
            List<FreApiDealsGetEx.Deal> theDeals =
            FreApiDealsGetEx.getClient().findDeals_Income(
                aRecord.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c,
                aRecord.Utiagebi__c,
                '#' + aRecord.ShodanBango__c
            );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Info, '20200826-1755', 'FreeApiVolumeTestBat.Success')
                .putAttr('JSON.serializePretty(theDeals)', JSON.serializePretty(theDeals) )
            );
        }
        catch(FreApiDealsGetEx.TooManyApiCallException ex){
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Info, '20200826-1756', 'FreeApiVolumeTestBat.Failed.TooManyApiCallException')
                    .putAttr('ex.getTypeName', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
        }
        catch(FreApiDealsGetEx.ApiErrorException ex){
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Info, '20200826-1757', 'FreeApiVolumeTestBat.Failed.ApiErrorException')
                    .putAttr('ex.getTypeName', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
        }
        catch(Exception ex){
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Info, '20200826-1758', 'FreeApiVolumeTestBat.Failed.Unknown')
                    .putAttr('ex.getTypeName', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString()
            	)
            );
        }
	}

	public void finish(Database.BatchableContext bc){
		//特に処理はしない
	}
}