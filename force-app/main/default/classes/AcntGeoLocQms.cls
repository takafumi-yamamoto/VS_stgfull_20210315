public class AcntGeoLocQms implements IHdlQms{
    public static String msgType = 'AcntGeoLocQms';

	public class Data{
		public String account_id;
    }

    public void handleQms(Qms__c pQms){
		try{
			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
			new Runner( new GeoLocs() ).run( theData.account_id );
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20200630-1554', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
    }

    public class Runner{
        private IGeoLocs mGeoLocs;
        public Runner(IGeoLocs pGeoLocs){
            this.mGeoLocs = pGeoLocs;
        }
		public void run(String pAccountId){
            Account theAccountUpdate = this.getUpdate(pAccountId);
			UPDATE theAccountUpdate;
		}
		public Account getUpdate(String pAccountId){
			Account theAccount = (Account)SobjectsExtension.firstOrNull(
				[
                    SELECT Id,
                    BillingPostalCode,
                    BillingState,
                    BillingCity,
                    BillingStreet
					FROM Account 
                    WHERE Id = :pAccountId
				]
            );
            if(theAccount == null) return null;

            String thePostalCoe = String.isBlank(theAccount.BillingPostalCode) ? null : theAccount.BillingPostalCode;
            String theAddress = 
                String.join(new List<String>{
                    String.isBlank(theAccount.BillingState) ? '' : theAccount.BillingState,
                    String.isBlank(theAccount.BillingCity) ? '' : theAccount.BillingCity,
                    String.isBlank(theAccount.BillingStreet) ? '' : theAccount.BillingStreet
                }, '');

            if( String.isBlank(thePostalCoe) && String.isBlank(theAddress) ){
                return new Account(
                    Id = theAccount.Id,
                    BillingLatitude = null,
                    BillingLongitude = null
                ); 
            }
            GeoLocs.Result theGeoLocsResult = this.mGeoLocs.getGeoLocation(thePostalCoe, theAddress, true);

            if(!theGeoLocsResult.isSuccess){
                throw new Exceptions.AnException('GeoLocs.getGeoLocation is failed');
            }

			return new Account(
                Id = theAccount.Id,
                BillingLatitude = theGeoLocsResult.geoLocation.lat,
                BillingLongitude = theGeoLocsResult.geoLocation.lng	
			);
		}
    }
    
	public class QueuingOnAccountAfterUpdate{
		public void enqueAccountLocationUpdates(List<Account> pNewOnes, Map<Id, Account> pOldOnes){
			INSERT this.getQueues(pNewOnes, pOldOnes);
		}

		public List<Qms__c> getQueues(List<Account> pNewOnes, Map<Id, Account> pOldOnes){

			Set<String> theAccountIds_toBeProcessed = new Set<String>();
			for(Account aNewOne : pNewOnes){
				Account aOldOne = pOldOnes.get(aNewOne.Id);
				
				Boolean toProcess = 
					(
						aNewOne.BillingPostalCode != aOldOne.BillingPostalCode
						||
						aNewOne.BillingState != aOldOne.BillingState
						||
						aNewOne.BillingCity != aOldOne.BillingCity
						||
						aNewOne.BillingStreet != aOldOne.BillingStreet
					);
					
				if( toProcess ) theAccountIds_toBeProcessed.add(aNewOne.Id);
			}

			List<Qms__c> theQmses = new List<Qms__c>();
			for(String aAccountId : theAccountIds_toBeProcessed){
				Data theData = new Data();
				theData.account_id = aAccountId;
				theQmses.add(
					QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build()
				);
			}

			return theQmses;
		}
    }

    public class QueuingOnAccountAfterInsert{
		public void enqueAccountLocationUpdates(List<Account> pNewOnes){
			INSERT this.getQueues(pNewOnes);
		}

		public List<Qms__c> getQueues(List<Account> pNewOnes){

			Set<String> theAccountIds_toBeProcessed = new Set<String>();
			for(Account aNewOne : pNewOnes){
				
                Boolean toProcess = 
                    !String.isBlank(aNewOne.BillingPostalCode)
                    ||
                    !String.isBlank(aNewOne.BillingState)
                    ||
                    !String.isBlank(aNewOne.BillingCity)
                    ||
                    !String.isBlank(aNewOne.BillingStreet);
					
				if( toProcess ) theAccountIds_toBeProcessed.add(aNewOne.Id);
			}

			List<Qms__c> theQmses = new List<Qms__c>();
			for(String aAccountId : theAccountIds_toBeProcessed){
				Data theData = new Data();
				theData.account_id = aAccountId;
				theQmses.add(
					QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build()
				);
			}

			return theQmses;
		}
	}
}