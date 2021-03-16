public without sharing class SaijoHallSyncQms implements IHdlQms{
	public static String msgType = 'SaijoHallSyncQms';

	public class Data{
		public String saijoId;
		public String saijoHallId;
		public String method;
	}

	public static List<Qms__c> createPostQmses(List<SaijoHall__c> saijoHallList){
		List<Qms__c> theQmses = new List<Qms__c>();
		for(SaijoHall__c aSaijoHall : saijoHallList){
			Data theData = new Data();
			theData.saijoId = aSaijoHall.SaijoKeisaiJohoId__c;
			theData.saijoHallId = aSaijoHall.HallKeisaiJohoId__c;
			theData.method = 'POST';
			theQmses.add(
				QmsBld.newRoot().setMsgType( SaijoHallSyncQms.msgType ).setData( JSON.serialize( theData ) ).build()
			);
		}
		return theQmses;
	}
	public static List<Qms__c> createDeleteQmses(List<SaijoHall__c> saijoHallList){
		List<Qms__c> theQmses = new List<Qms__c>();
		for(SaijoHall__c aSaijoHall : saijoHallList){
			Data theData = new Data();
			theData.saijoId = aSaijoHall.SaijoKeisaiJohoId__c;
			theData.saijoHallId = aSaijoHall.HallKeisaiJohoId__c;
			theData.method = 'DELETE';
			theQmses.add(
				QmsBld.newRoot().setMsgType( SaijoHallSyncQms.msgType ).setData( JSON.serialize( theData ) ).build()
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

			String theEndPoint = RsCoreApi_Configs.getConfig().EndPoint__c + '/manager/api/saijo/' + theData.saijoId + '/hall/' + theData.saijoHallId;
			String theMethod = '';
			String theMsgBody = '';

			if(theData.method == 'DELETE'){
				theMethod = 'DELETE';
				theMsgBody = 'dummy';
			}

			if(theData.method == 'POST'){
				theMethod = 'POST';

				List<SaijoHall__c> theSaijoHalls = [
					SELECT 
					SaijoKeisaiJohoId__c, HallKeisaiJohoId__c, Name, SaijoHallKana__c, TaioShikishubetsu__c, 
					Sekisu__c, JogenKaisoshasu__c, X1ShiyoRyokinIppan__c, X1ShiyoRyokinShimin__c, X1ShiyoRyokinSonota__c, 
					X2ShiyoRyokinIppan__c, X2ShiyoRyokinShimin__c, X2ShiyoRyokinSonota__c, ShiyoRyokinBiko__c 
					FROM SaijoHall__c 
					WHERE HallKeisaiJohoId__c = :theData.saijoHallId
					LIMIT 1
				];
				SaijoHall__c theSaijoHall = theSaijoHalls.get(0);

				theMsgBody = new RsCoreApi_SaijoHall().createFacilityInfoSaijoHallJson(theSaijoHall);
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
						Loggings.createLogEntry(Loggings.Level.Info, '20190917-1540', 'SaijoHallSyncQms')
						.setSubjectRecordId(pQms.Id)
						.putAttr('theStatusCode', String.valueOf(theStatusCode) )
						.putAttr('theMsgBody', theMsgBody )
						.putAttr('theMethod', theMethod )
						.putAttr('theEndPoint', theEndPoint)
					);
	            }
	        }catch(Exception e){
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20190902-1535', 'SaijoHallSyncQms')
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', e.getMessage())
					.putAttr('LineNumber', '' + e.getLineNumber())
					.putAttr('getStackTraceString', e.getStackTraceString())
				);
	            isError = true;
	        }

	        if(isError){
				Loggings.writeLog(
					Loggings.createLogEntry(Loggings.Level.Error, '20190902-1535', 'SaijoHallSyncQms')
					.setSubjectRecordId(pQms.Id)
				);
	        	UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
	        }

	        if(!isError) UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}
	}
}