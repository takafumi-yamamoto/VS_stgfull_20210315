public without sharing class SaijoSyncQms implements IHdlQms{
	public static String msgType = 'SaijoSyncQms';

	public class Data{
		public String saijoId;
		public String method;
	}

	public static List<Qms__c> createPostQmses(List<Saijo__c> saijoList){
		List<Qms__c> theQmses = new List<Qms__c>();
		for(Saijo__c aSaijo : saijoList){
			Data theData = new Data();
			theData.saijoId = aSaijo.SaijoKeisaiJohoId__c;
			theData.method = 'POST';
			theQmses.add(
				QmsBld.newRoot().setMsgType( SaijoSyncQms.msgType ).setData( JSON.serialize( theData ) ).build()
			);
		}
		return theQmses;
	}
	public static List<Qms__c> createDeleteQmses(List<Saijo__c> saijoList){
		List<Qms__c> theQmses = new List<Qms__c>();
		for(Saijo__c aSaijo : saijoList){
			Data theData = new Data();
			theData.saijoId = aSaijo.SaijoKeisaiJohoId__c;
			theData.method = 'DELETE';
			theQmses.add(
				QmsBld.newRoot().setMsgType( SaijoSyncQms.msgType ).setData( JSON.serialize( theData ) ).build()
			);
		}
		return theQmses;
	}

	public void handleQms(Qms__c pQms){
		try{
			System.enqueueJob( new jobRun(pQms) );
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20190917-1511', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}

	private class jobRun implements Queueable,Database.AllowsCallouts{
		private Qms__c pQms;

		public jobRun(Qms__c pQms){ this.pQms = pQms; }

		public void execute(QueueableContext context) { this.run(); }

		private void run(){

			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);

			String theEndPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/manager/api/saijo/' + theData.saijoId ;
			String theMethod = '';
			String theMsgBody = '';

			if(theData.method == 'DELETE'){
				theMethod = 'DELETE';
				theMsgBody = 'dummy';
			}

			if(theData.method == 'POST'){
				theMethod = 'POST';

				List<Saijo__c> theSaijos = [
					SELECT 
					SaijoKeisaiJohoId__c, SimpleHPKeisaiAri__c, Name, KeisaiSaijoMeiKana__c, 
					TokuchoSaijo__c, PostalCode__c, TodoufukenCodeExp__c, Street__c, JushoKana__c,
					IdoKedo__latitude__s, IdoKedo__longitude__s, AreaCode__c, 
					ShisetsuKubun__c, KasobaHeisetsuList__c, UneimotoYago__c, TaioShuha__c, ShiminRyokinKubun__c, 
					Kyukanbi__c, AnchiShisetsu__c, KaminShisetsuUmuKokubetsushikiZenjitsu__c, 
					KaminKanoNinzu__c, KurumaisuTaio__c, ShinzokuHikaeshitsu__c, Chushadaisu__c, ElevatorUmu__c, 
					KidsRoomList__c, JunyushitsuList__c, KurumaisuKashidashiList__c,
					AccessHohoKuruma__c, AccessHohoBasu__c, AccessHouhouDensha__c, AccessHohoBiko__c, OmutsuKokandaiList__c, 
					SuishoSaijo__c
					FROM Saijo__c 
					WHERE SaijoKeisaiJohoId__c = :theData.saijoId
					LIMIT 1
				];
				Saijo__c theSaijo = theSaijos.get(0);

				theMsgBody = new RsCoreApi_Saijo().createFacilityInfoSaijoJson(theSaijo);
			}

			Boolean isError = false;
	        try{
	            if(RsCoreApi_Configs.getConfig().IsShisetsuRenkeiYuko__c){  
	                HttpRequest request = new HttpRequest();

	                request.setEndpoint(theEndPoint);
	                request.setMethod(theMethod);
	                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
	                request.setBody(theMsgBody);
	                RsCoreApi_AuthClients.getInstance().setAuthHeader(request);
	                HttpResponse response = new http().send(request);
	                Integer theStatusCode = response.getStatusCode();
	                if(theStatusCode!=200) isError = true;
					Loggings.writeLog(
						Loggings.createLogEntry(Loggings.Level.Info, '20190917-1540', 'SaijoSyncQms')
						.setSubjectRecordId(pQms.Id)
						.putAttr('theStatusCode', String.valueOf(theStatusCode) )
						.putAttr('theMsgBody', theMsgBody )
						.putAttr('theMethod', theMethod )
						.putAttr('theEndPoint', theEndPoint)
					);
	            }
	        }catch(Exception e){
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20190902-1535', 'SaijoSyncQms')
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', e.getMessage())
					.putAttr('LineNumber', '' + e.getLineNumber())
					.putAttr('getStackTraceString', e.getStackTraceString())
				);
	            isError = true;
	        }

	        if(isError){
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20190902-1536', 'SaijoSyncQms')
					.setSubjectRecordId(pQms.Id)
				);
	        	UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
	        }

	        if(!isError) UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}
	}
}