public class SrscFrObOpQms implements IHdlQms{
	public static String msgType = 'SrscFrObOpQms';

	public class Data{
		public String ShodanBango;
	}

	public void handleQms(Qms__c pQms){
		try{
			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
			new SrscFrObOp.SoryoScheduler(
				new SrscFrObOpPhase.StageToSchedule()
			)
			.reschedule(theData.ShodanBango);

			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20200521-2024', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
	}

	public class QueuingByObo{
		public void onOboAfterUpdate(List<Obosanbin__c> pNewOnes, Map<Id, Obosanbin__c> pOldOnes){
			INSERT this.getQueues(pNewOnes, pOldOnes);
		}
		public List<Qms__c> getQueues(List<Obosanbin__c> pNewOnes, Map<Id, Obosanbin__c> pOldOnes){

			Set<String> theOboIds_toBeProcessed = new Set<String>();
			for(Obosanbin__c aNewOne : pNewOnes){
				Obosanbin__c aOldOne = pOldOnes.get(aNewOne.Id);
				
				Boolean toProcess = 
					(
						aNewOne.ObosanbinKeiyakuMadoguchi__c != aOldOne.ObosanbinKeiyakuMadoguchi__c
						||
						aNewOne.KokubetsuDateTime_Inp__c != aOldOne.KokubetsuDateTime_Inp__c
						||
						aNewOne.TsuyaDateTime_Inp__c != aOldOne.TsuyaDateTime_Inp__c
						||
						aNewOne.KokubetsushikiNichiji__c != aOldOne.KokubetsushikiNichiji__c
						||
						aNewOne.KasoDateTime_Inp__c != aOldOne.KasoDateTime_Inp__c
					);
					
				if( toProcess ) theOboIds_toBeProcessed.add(aNewOne.Id);
			}
			
			Set<String> theShodanBangos_ToQueue = new Set<String>();
			{
				for( Opportunity aOpp : [
					SELECT Id, ShodanBango__c
					FROM Opportunity
					WHERE ObosanbinRef__c IN :theOboIds_toBeProcessed
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

	public class QueuingByOpp{

		private SrscFrObOpPhase.StageToSchedule mStageToSchedule;
		public QueuingByOpp(SrscFrObOpPhase.StageToSchedule pStageToSchedule){
			this.mStageToSchedule = pStageToSchedule;
		}
		public void onOppAfterUpdate(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){
			INSERT this.getQueues(pNewOnes, pOldOnes);
		}
		public List<Qms__c> getQueues(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){

			String theOboRecTypeId = 
				RecordTypeCachedDaos.getInstance()
				.SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin');

			Set<String> theShodanBangos_ToQueue = new Set<String>();
			for(Opportunity aNewOne : pNewOnes){
				Opportunity aOldOne = pOldOnes.get(aNewOne.Id);

				Boolean toProcess = 
					aNewOne.RecordTypeId == theOboRecTypeId &&
					this.mStageToSchedule.isInStageToSchedule(aNewOne.StageName) != this.mStageToSchedule.isInStageToSchedule(aOldOne.StageName);
					
				if( toProcess ) theShodanBangos_ToQueue.add(aNewOne.ShodanBango__c);
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