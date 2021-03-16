public class ObosanbinGeoLocTask implements Queueable, Database.AllowsCallouts{
    private Id f_TaskId = null;
	private GeoLocs m_GeoLocs = new GeoLocs();

	public ObosanbinGeoLocTask(Id pTaskId) {
		this.f_TaskId = pTaskId;
	}

	private String getAddrStr(String pState, String pCity, String pStreet, String pBlock){
		return String.format('{0}{1}{2}{3}', new List<String>{
			String.isBlank(pState) ? '' : pState,
			String.isBlank(pCity) ? '' : pCity,
			String.isBlank(pStreet) ? '' : pStreet,
			String.isBlank(pBlock) ? '' : pBlock
			}
		);
	}
    public void runTask(Id pTaskId){

		ObosanbinGeoLocTask__c theTask = (ObosanbinGeoLocTask__c)SobjectsExtension.firstOrNull(
			[
				SELECT 
				Id, OboRef__c,
				IsHoyoAddrChg__c, isTsuikaHoyoAddrChg__c, isSogiAddrChg__c
				FROM ObosanbinGeoLocTask__c 
				WHERE Id = :pTaskId
				Limit 1				
			]
		);
        if(theTask == null) return;
		if(theTask.OboRef__c == null){ theTask.ShoriStatus__c = 'Completed'; Update theTask; return; }
		
		Obosanbin__c theObosanbin = (Obosanbin__c)SobjectsExtension.firstOrNull(
			[
				SELECT Id,
				hoyo_postcode__c, hoyo_todofuken__c, hoyo_shikugun__c, hoyo_tyoumei__c, hoyo_banchi__c,
				tuika_postcode__c, tuika_todofuken__c, tuika_shikugun__c, tuika_tyoumei__c, tuika_banchi__c,
				sogi_postcode__c, sogi_todofuken__c, sogi_shikugun__c, sogi_tyoumei__c, sogi_banchi__c
				FROM Obosanbin__c
				WHERE Id = :theTask.OboRef__c
				LIMIT 1
			]
		);
		if(theObosanbin == null){ theTask.ShoriStatus__c = 'Completed'; Update theTask; return; }

		Obosanbin__c theUpdate = new Obosanbin__c(Id = theObosanbin.Id);

		if(theTask.IsHoyoAddrChg__c){
			theUpdate.hoyo_location__Latitude__s = null; theUpdate.hoyo_location__Longitude__s = null;

			Boolean theAddrHasValue = 
				!String.isBlank(theObosanbin.hoyo_postcode__c) ||
				!String.isBlank(theObosanbin.hoyo_todofuken__c) || !String.isBlank(theObosanbin.hoyo_shikugun__c) ||
				!String.isBlank(theObosanbin.hoyo_tyoumei__c) || !String.isBlank(theObosanbin.hoyo_banchi__c);

			if(theAddrHasValue){
				GeoLocs.Result theGeoRes = 
					this.m_GeoLocs.getGeoLocation(
						String.isBlank(theObosanbin.hoyo_postcode__c) ? null : theObosanbin.hoyo_postcode__c,
						this.getAddrStr(
							theObosanbin.hoyo_todofuken__c, theObosanbin.hoyo_shikugun__c,
							theObosanbin.hoyo_tyoumei__c, theObosanbin.hoyo_banchi__c					
						)
					);
				if(theGeoRes.isSuccess){
					theUpdate.hoyo_location__Latitude__s = theGeoRes.geoLocation.lat; theUpdate.hoyo_location__Longitude__s = theGeoRes.geoLocation.lng;
				}
			}
		}
		if(theTask.isTsuikaHoyoAddrChg__c){
			theUpdate.tuika_location__Latitude__s = null; theUpdate.tuika_location__Longitude__s = null;

			Boolean theAddrHasValue = 
				!String.isBlank(theObosanbin.tuika_postcode__c) ||
				!String.isBlank(theObosanbin.tuika_todofuken__c) || !String.isBlank(theObosanbin.tuika_shikugun__c) ||
				!String.isBlank(theObosanbin.tuika_tyoumei__c) || !String.isBlank(theObosanbin.tuika_banchi__c);

			if(theAddrHasValue){
				GeoLocs.Result theGeoRes = 
					this.m_GeoLocs.getGeoLocation(
						String.isBlank(theObosanbin.tuika_postcode__c) ? null : theObosanbin.tuika_postcode__c,
						this.getAddrStr(
							theObosanbin.tuika_todofuken__c, theObosanbin.tuika_shikugun__c,
							theObosanbin.tuika_tyoumei__c, theObosanbin.tuika_banchi__c					
						)
					);
				if(theGeoRes.isSuccess){
					theUpdate.tuika_location__Latitude__s = theGeoRes.geoLocation.lat; theUpdate.tuika_location__Longitude__s = theGeoRes.geoLocation.lng;
				}
			}
		}
		if(theTask.isSogiAddrChg__c){
			theUpdate.sogi_location__Latitude__s = null; theUpdate.sogi_location__Longitude__s = null;

			Boolean theAddrHasValue = 
				!String.isBlank(theObosanbin.sogi_postcode__c) ||
				!String.isBlank(theObosanbin.sogi_todofuken__c) || !String.isBlank(theObosanbin.sogi_shikugun__c) ||
				!String.isBlank(theObosanbin.sogi_tyoumei__c) || !String.isBlank(theObosanbin.sogi_banchi__c);

			if(theAddrHasValue){
				GeoLocs.Result theGeoRes = 
					this.m_GeoLocs.getGeoLocation(
						String.isBlank(theObosanbin.sogi_postcode__c) ? null : theObosanbin.sogi_postcode__c,
						this.getAddrStr(
							theObosanbin.sogi_todofuken__c, theObosanbin.sogi_shikugun__c,
							theObosanbin.sogi_tyoumei__c, theObosanbin.sogi_banchi__c					
						)
					);
				if(theGeoRes.isSuccess){
					theUpdate.sogi_location__Latitude__s = theGeoRes.geoLocation.lat; theUpdate.sogi_location__Longitude__s = theGeoRes.geoLocation.lng;
				}
			}
		}
		UPDATE theUpdate;
		theTask.ShoriStatus__c = 'Completed'; Update theTask;
    }

    public void execute(QueueableContext context) {
    	try{
    		this.runTask( this.f_TaskId );
    	}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(Loggings.Level.Error, '20190604-1443', 'ObosanbinGeoLocTask')
	                .setSubjectRecordId(this.f_TaskId)
                    .putAttr( 'e.getMessage()', e.getMessage() )
                    .putAttr( 'e.getLineNumber()', String.valueOf(e.getLineNumber())  )
                    .putAttr( 'e.getStackTraceString()', e.getStackTraceString() )
	        );
			UPDATE New ObosanbinGeoLocTask__c(Id = this.f_TaskId, ShoriStatus__c = 'Faulted');
    	}
    }
}