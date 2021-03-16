public class SrscFrObOp {

	public class SoryoScheduler{

		private SrscFrObOpPhase.StageToSchedule mStageToSchedule;
		public SoryoScheduler(SrscFrObOpPhase.StageToSchedule pStageToSchedule){
			this.mStageToSchedule = pStageToSchedule;
		}

		public void reschedule(String pShodanBango){
			OppData theOppData = this.selectOppData(pShodanBango);
			if(theOppData == null) return;

			UnitOfWork theUnitOfWork = this.getUnitOfWork(theOppData);
			DELETE theUnitOfWork.events_delete;
			INSERT theUnitOfWork.events_insert;
		}

		public UnitOfWork getUnitOfWork(OppData pOppData){
			UnitOfWork theUnitOfWork = new UnitOfWork();

			List<Event> theEvents_Delete = new List<Event>();
			if(pOppData.oppId != null){
				theUnitOfWork.events_delete.addAll(
					[ SELECT Id FROM EVENT WHERE WhatId = :pOppData.oppId ]
				);
			}

			if( this.mStageToSchedule.isInStageToSchedule(pOppData.stageName) ){
				theUnitOfWork.events_insert.addAll( this.createEvents(pOppData) );
			}
			return theUnitOfWork;
		}

		public OppData selectOppData(String pShodanBango){
			Opportunity theOpp = (Opportunity)SobjectsExtension.firstOrNull(
				[
					SELECT Id, ShodanBango__c,
					StageName,
					ObosanbinRef__r.MemorialServicePlan__c,
					ObosanbinRef__r.KokubetsuDateTime_Inp__c,
					ObosanbinRef__r.TsuyaDateTime_Inp__c,
					ObosanbinRef__r.KokubetsushikiNichiji__c,
					ObosanbinRef__r.KasoDateTime_Inp__c,
					ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c,
					ObosanbinRef__r.SekotantoSoryoSoryomei__c,
					ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__c,
					ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name
					FROM Opportunity
					WHERE ShodanBango__c = :pShodanBango
					LIMIT 1
				]
			);
			if(theOpp == null) return null;

			Contact theContact = (Contact)SobjectsExtension.firstOrNull(
				[
					SELECT Id 
					FROM CONTACT 
					WHERE AccountId = :theOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__c 
					AND AccountId != null
					LIMIT 1
				]
			);

			OppData theOppData = new OppData();
			theOppData.oppId = theOpp.Id;
			theOppData.shodanBango = theOpp.ShodanBango__c;
			theOppData.stageName = theOpp.stageName;
			theOppData.contactId = theContact == null ? null : theContact.Id;
			theOppData.oboPlan = theOpp.ObosanbinRef__r.MemorialServicePlan__c;
			theOppData.sekoTantoId = theOpp.ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__c;
			theOppData.sekoTantoName =
				String.isBlank(theOpp.ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name)
				? theOpp.ObosanbinRef__r.SekotantoSoryoSoryomei__c
				: theOpp.ObosanbinRef__r.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Name;
			theOppData.hoyoNichiji = theOpp.ObosanbinRef__r.KokubetsuDateTime_Inp__c;
			theOppData.tuyaNichiji = theOpp.ObosanbinRef__r.TsuyaDateTime_Inp__c;
			theOppData.kokubetsuNichiji = theOpp.ObosanbinRef__r.KokubetsushikiNichiji__c;
			theOppData.kasoNichiji = theOpp.ObosanbinRef__r.KasoDateTime_Inp__c;
			return theOppData;
		}
	
		private List<Event> createEvents(OppData pOppData){
			List<Event> theEvents_toBeInsert = new List<Event>();

			if( String.isBlank(pOppData.contactId) ) return new List<Event>();

			if( pOppData.hoyoNichiji != null && OboPlanKeitais.isHoyo(pOppData.oboPlan) ){
				Boolean isJikanMitei = 
					pOppData.hoyoNichiji.hour() == 0 && pOppData.hoyoNichiji.minute() == 0;
				if(!isJikanMitei){
					theEvents_toBeInsert.add(
						this.createEvent('法要', pOppData.hoyoNichiji, pOppData)
					);
				}
			}

			if( pOppData.tuyaNichiji != null && pOppData.oboPlan == '一般葬' ){
				theEvents_toBeInsert.add(
					this.createEvent('通夜', pOppData.tuyaNichiji, pOppData)
				);
			}
		
			if( pOppData.kokubetsuNichiji != null && 
				( pOppData.oboPlan == '一般葬' || pOppData.oboPlan == '一日葬' )
			){
				theEvents_toBeInsert.add(
					this.createEvent('告別式', pOppData.kokubetsuNichiji, pOppData)
				);
			}

			if( pOppData.kasoNichiji != null && 
				( pOppData.oboPlan == '一般葬' || pOppData.oboPlan == '一日葬' || pOppData.oboPlan == '火葬式' )
			){
				theEvents_toBeInsert.add(
					this.createEvent('火葬', pOppData.kasoNichiji, pOppData)
				);
			}

			return theEvents_toBeInsert;
		}

		private Event createEvent(String SoryoScheduleKubun, Datetime pStartDateTime, OppData pOppData){
			String theSekotantoName = 
				String.isBlank(pOppData.sekoTantoName)
				? '未設定'
				: pOppData.sekoTantoName;

			return 
				new Event(
					Subject = theSekotantoName + '_' + SoryoScheduleKubun,
					WhoId = pOppData.contactId,
					WhatId = pOppData.oppId,
					AtesakiRef__c = pOppData.sekoTantoId,
					StartDateTime = pStartDateTime,
					EndDateTime = pStartDateTime.addHours(1),
					SoryoScheduleKubun__c = SoryoScheduleKubun,
					OwnerId = DefaultOwner.getOwnerId()
				);
		}
	}

	public class UnitOfWork{
		public List<Event> events_delete = new List<Event>();
		public List<Event> events_insert = new List<Event>();
	}

	public class OppData{
		public String oppId;
		public String shodanBango;
		public String stageName;
		public String contactId;
		public String oboPlan;
		public String sekoTantoId;
		public String sekoTantoName;
		public Datetime hoyoNichiji;
		public Datetime tuyaNichiji;
		public Datetime kokubetsuNichiji;
		public Datetime kasoNichiji;
	}

}