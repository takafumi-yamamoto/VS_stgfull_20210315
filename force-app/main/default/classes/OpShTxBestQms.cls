public class OpShTxBestQms implements IHdlQms {
	public static String msgType = 'OpShTxBestQms';

	public class Data{
		public String ShodanBango;
	}

	public void handleQms(Qms__c pQms){
		try{
			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
			new Runner().run( theData.ShodanBango );
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20200513-1842', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}

	public class Runner{
		public void run(String pShodanBango){
			UPDATE this.getUpdate(pShodanBango);
		}
		public Opportunity getUpdate(String pShodanBango){
			Opportunity theOpp = (Opportunity)SobjectsExtension.firstOrNull(
				[
					SELECT Id,
					BestButsudanRef__r.TodokesakiName__c, BestButsudanRef__r.TodokesakiKana__c,
					BestButsudanRef__r.TodokesakiTelNo__c,
					BestButsudanRef__r.TodokesakiZipCode__c, 
					BestButsudanRef__r.TodokesakiState__c,
					BestButsudanRef__r.TodokesakiCity__c,
					BestButsudanRef__r.TodokesakiStreet__c
					FROM Opportunity 
					WHERE ShodanBango__c = :pShodanBango
				]
			);

			return new Opportunity(
				Id = theOpp.Id,
				NohinSakiMei__c = theOpp.BestButsudanRef__r.TodokesakiName__c,
				NohinSakiMeiKana__c = theOpp.BestButsudanRef__r.TodokesakiKana__c,
				NohinSakiPostalCode__c = theOpp.BestButsudanRef__r.TodokesakiZipCode__c,
				NohinSakiState__c = theOpp.BestButsudanRef__r.TodokesakiState__c,
				NohinSakiCity__c = theOpp.BestButsudanRef__r.TodokesakiCity__c,
				NohinSakiStreet__c = theOpp.BestButsudanRef__r.TodokesakiStreet__c,
				NohinSakiTelNo__c = theOpp.BestButsudanRef__r.TodokesakiTelNo__c 	
			);
		}
	}

	public class Queuing{
		public void onBestAfterUpdate(List<BestButsudan__c> pNewOnes, Map<Id, BestButsudan__c> pOldOnes){
			INSERT this.getQueues(pNewOnes, pOldOnes);
		}

		public List<Qms__c> getQueues(List<BestButsudan__c> pNewOnes, Map<Id, BestButsudan__c> pOldOnes){

			Set<String> theBestIds_toBeProcessed = new Set<String>();
			for(BestButsudan__c aNewOne : pNewOnes){
				BestButsudan__c aOldOne = pOldOnes.get(aNewOne.Id);
				
				Boolean toProcess = 
					(
						aNewOne.TodokesakiName__c != aOldOne.TodokesakiName__c
						||
						aNewOne.TodokesakiKana__c != aOldOne.TodokesakiKana__c
						||
						aNewOne.TodokesakiZipCode__c != aOldOne.TodokesakiZipCode__c
						||
						aNewOne.TodokesakiState__c != aOldOne.TodokesakiState__c
						||
						aNewOne.TodokesakiCity__c != aOldOne.TodokesakiCity__c
						||
						aNewOne.TodokesakiStreet__c != aOldOne.TodokesakiStreet__c
						||
						aNewOne.TodokesakiTelNo__c != aOldOne.TodokesakiTelNo__c
					);
					
				if( toProcess ) theBestIds_toBeProcessed.add(aNewOne.Id);
			}
			
			Set<String> theShodanBangos_ToQueue = new Set<String>();
			{
				String theBestRecTypeId = 
					RecordTypeCachedDaos.getInstance()
					.SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan');

				for( Opportunity aOpp : [
					SELECT Id, ShodanBango__c
					FROM Opportunity
					WHERE BestButsudanRef__c IN :theBestIds_toBeProcessed
					AND RecordTypeId = :theBestRecTypeId
				] ){
					theShodanBangos_ToQueue.add(aOpp.ShodanBango__c);
				}
			}

			List<Qms__c> theQmses = new List<Qms__c>();
			for(String aShodanBango : theShodanBangos_ToQueue){
				Data theData = new Data();
				theData.ShodanBango = aShodanBango;
				theQmses.add(
					QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build()
				);
			}

			return theQmses;
		}
	}
}