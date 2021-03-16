public class TerapSgSeikTasksDst4Seiks {

	public static TerapSgSeikTasksDst4Seiks instance(){
		return new TerapSgSeikTasksDst4Seiks(
			new KakinEntDataPvr(), new KeiyakuDataPvr(),
			new ToiawaseDataPvr(), new SekoDataPvr()
		);
	}
	private IKakinEntDataPvr m_KakinEntDataPvr = null;
	private IKeiyakuDataPvr m_KeiyakuDataPvr = null;
	private IToiawaseDataPvr m_ToiawaseDataPvr = null;
	private ISekoDataPvr m_SekoDataPvr = null;
	public TerapSgSeikTasksDst4Seiks(
		IKakinEntDataPvr pKakinEntDataPvr, IKeiyakuDataPvr pKeiyakuDataPvr,
		IToiawaseDataPvr pToiawaseDataPvr, ISekoDataPvr pSekoDataPvr
	){
		this.m_KakinEntDataPvr = pKakinEntDataPvr; this.m_KeiyakuDataPvr = pKeiyakuDataPvr;
		this.m_ToiawaseDataPvr = pToiawaseDataPvr; this.m_SekoDataPvr = pSekoDataPvr;
	}

	public class Dataset{

		public List<KakinEntData> KakinEntDatas = new List<KakinEntData>();
		private Map<String, KakinEntData> theKakinEntIdToKakinEntData = null;
		private KakinEntData getKakinEntDataByKakinEntId(String pKakinEntId){
			if(theKakinEntIdToKakinEntData == null){
				theKakinEntIdToKakinEntData = new Map<String, KakinEntData>();
				for( KakinEntData aKakinEntData : this.KakinEntDatas){ theKakinEntIdToKakinEntData.put( aKakinEntData.KakinEntId, aKakinEntData ); }
			}
			return theKakinEntIdToKakinEntData.get(pKakinEntId);
		}
 
		public List<KeiyakuData> KeiyakuDatas = new List<KeiyakuData>();
		private Map<String, KeiyakuData> theKeiyakuBangoToKeiyakuData = null;
		private KeiyakuData getKeiyakuDataByKeiyakuBango(String pKeiyakuBango){
			if(theKeiyakuBangoToKeiyakuData == null){
				theKeiyakuBangoToKeiyakuData = new Map<String,KeiyakuData>();
				for( KeiyakuData aKeiyakuData : this.KeiyakuDatas){ 
					theKeiyakuBangoToKeiyakuData.put( aKeiyakuData.KeiyakuBango, aKeiyakuData ); 
				}
			}
			return theKeiyakuBangoToKeiyakuData.get(pKeiyakuBango);
		}

		public List<KakinEntData> NextYmKakinEntDatas = new List<KakinEntData>();
		private Map<String, KakinEntData> theKeiyakuBangoToNextYmKakinEntData = null;
		private KakinEntData getNextYmKakinEntDataByKeiyakuBango(String pKeiyakuBango){
			if(theKeiyakuBangoToNextYmKakinEntData == null){
				theKeiyakuBangoToNextYmKakinEntData = new Map<String, KakinEntData>();
				for( KakinEntData aKakinEntData : this.NextYmKakinEntDatas){ theKeiyakuBangoToNextYmKakinEntData.put( aKakinEntData.KeiyakuBango, aKakinEntData ); }
			}
			return theKeiyakuBangoToNextYmKakinEntData.get(pKeiyakuBango);
		}
		
		public List<SekoData> SekoDatas = new List<SekoData>();
		private Map<String, List<SekoData>> theSogishaToSekoDataList = null;
		private List<SekoData> getSekoDatasBySogisha(String pTorihikiSakiBango){
			if(theSogishaToSekoDataList == null){
				theSogishaToSekoDataList = new Map<String, List<SekoData>>();
				for(SekoData aSekoData : this.SekoDatas){
					String theKey = aSekoData.SogishaTorihikiSakiBango;
					if( !theSogishaToSekoDataList.containsKey(theKey) ) theSogishaToSekoDataList.put( theKey, new List<SekoData>() );
					theSogishaToSekoDataList.get(theKey).add(aSekoData);
				}
			}
			return theSogishaToSekoDataList.get(pTorihikiSakiBango);
		}

		public List<ToiawaseData> ToiawaseDatas = new List<ToiawaseData>();
		private Map<String, List<ToiawaseData>> theSogishaToToiawaseDataList = null;
		private List<ToiawaseData> getToiawaseDatasBySogisha(String pTorihikiSakiBango){
			if(theSogishaToToiawaseDataList == null){
				theSogishaToToiawaseDataList = new Map<String, List<ToiawaseData>>();
				for(ToiawaseData aToiawaseData : this.ToiawaseDatas){
					String theKey = aToiawaseData.SogishaTorihikiSakiBango;
					if( !theSogishaToToiawaseDataList.containsKey(theKey) ) theSogishaToToiawaseDataList.put( theKey, new List<ToiawaseData>() );
					theSogishaToToiawaseDataList.get(theKey).add(aToiawaseData);
				}
			}
			return theSogishaToToiawaseDataList.get(pTorihikiSakiBango);
		}

		private DataForSeikyu getDataForSeikyu(String pKakinEntId){

			DataForSeikyu theDataForSeikyu = new DataForSeikyu();
			theDataForSeikyu.KakinEntData = this.getKakinEntDataByKakinEntId(pKakinEntId);

			theDataForSeikyu.KeiyakuData = this.getKeiyakuDataByKeiyakuBango(theDataForSeikyu.KakinEntData.KeiyakuBango);
			if(theDataForSeikyu.KeiyakuData == null) return null;

			theDataForSeikyu.NextYmKakinEntData = this.getNextYmKakinEntDataByKeiyakuBango(theDataForSeikyu.KakinEntData.KeiyakuBango);

			theDataForSeikyu.SekoDataList = this.getSekoDatasBySogisha(theDataForSeikyu.KeiyakuData.TorihikiSakiBango);
			if(theDataForSeikyu.SekoDataList == null) theDataForSeikyu.SekoDataList = new List<SekoData>();

			theDataForSeikyu.ToiawaseDataList = this.getToiawaseDatasBySogisha(theDataForSeikyu.KeiyakuData.TorihikiSakiBango);
			if(theDataForSeikyu.ToiawaseDataList == null) theDataForSeikyu.ToiawaseDataList = new List<ToiawaseData>();

			return theDataForSeikyu;
		}

		public List<DataForSeikyu> getDataForSeikyus(){
			List<DataForSeikyu> theDataForSeikyus = new List<DataForSeikyu>();
			for( KakinEntData aKakinEntData : this.KakinEntDatas){
				
				DataForSeikyu aDataForSeikyu = null;
				try{
					aDataForSeikyu = this.getDataForSeikyu(aKakinEntData.KakinEntId);
				}catch(Exception ex){
					Loggings.writeLog(
						Loggings.createLogEntry(Loggings.Level.Error, '20200221-1632', 'TerapSgSeikTasksDst4Seiks.getDataForSeikyus')
							.putAttr('aKakinEntData.KakinEntId', aKakinEntData.KakinEntId)
							.putAttr('aKakinEntData.KeiyakuBango', aKakinEntData.KeiyakuBango)
							.putAttr('Exception', ex.getMessage())
							.putAttr('LineNumber', '' + ex.getLineNumber())
							.putAttr('getStackTraceString', ex.getStackTraceString())
					);
					throw ex;
				}
				if(aDataForSeikyu != null) theDataForSeikyus.add(aDataForSeikyu);
			}
			return theDataForSeikyus;
		}
	}

	public Dataset getDataSet(List<String> pKakinEntIds, Date pBillTargetYm){

		Date theBillingYm = pBillTargetYm.toStartOfMonth();

		List<KakinEntData> theKakinEntDatas = 
			this.m_KakinEntDataPvr.selectByIds( pKakinEntIds );
			
		Set<String> theKeiyakuBangos = new Set<String>();
		for(KakinEntData aKakinEntData : theKakinEntDatas){ theKeiyakuBangos.add(aKakinEntData.KeiyakuBango); }

		List<KakinEntData> theNextYmKakinEntDatas =
			this.m_KakinEntDataPvr.selectForKakinByTargetYm( theBillingYm.addMonths(1) , new List<String>(theKeiyakuBangos) );

		List<KeiyakuData> theKeiyakuDatas = this.m_KeiyakuDataPvr.selectByKeiyakuBangos( new List<String>(theKeiyakuBangos) );

		Set<String> theSogishaTorihikiSakiBangos = new Set<String>();
		for(KeiyakuData aKeiyakuData : theKeiyakuDatas){ theSogishaTorihikiSakiBangos.add(aKeiyakuData.TorihikiSakiBango); }

		List<SekoData> theSekoDatas = this.m_SekoDataPvr.selectByTargetYm( theBillingYm, new List<String>(theSogishaTorihikiSakiBangos) );

		List<ToiawaseData> theToiawaseDatas = this.m_ToiawaseDataPvr.selectForToiawaseByTargetYm( theBillingYm.addMonths(1), new List<String>(theSogishaTorihikiSakiBangos) );

		Dataset theDataset = new Dataset();
		theDataset.KeiyakuDatas.addAll(theKeiyakuDatas);
		theDataset.KakinEntDatas.addAll(theKakinEntDatas);
		theDataset.NextYmKakinEntDatas.addAll(theNextYmKakinEntDatas);
		theDataset.SekoDatas.addAll(theSekoDatas);
		theDataset.ToiawaseDatas.addAll(theToiawaseDatas);

		return theDataset;
	}

	public class DataForSeikyu{
		public KakinEntData KakinEntData;
		public KakinEntData NextYmKakinEntData;
		public KeiyakuData KeiyakuData;
		public List<SekoData> SekoDataList;
		public List<ToiawaseData> ToiawaseDataList;
	}

	public class KakinEntData{
		public String KakinEntId; public KakinEntData setKakinEntId(String pValue){ this.KakinEntId = pvalue; return this; }
		public String TorihikiSakiBango; public KakinEntData setTorihikiSakiBango(String pValue){ this.TorihikiSakiBango = pvalue; return this; }
		public String KeiyakuBango; public KakinEntData setKeiyakuBango(String pValue){ this.KeiyakuBango = pvalue; return this; }
		public Date BeginDate; public KakinEntData setBeginDate(Date pValue){ this.BeginDate = pvalue; return this; }
		public String KakinScheme; public KakinEntData setKakinScheme(String pValue){ this.KakinScheme = pvalue; return this; }
		public Decimal TeigakuKakinGaku; public KakinEntData setTeigakuKakinGaku(Decimal pValue){ this.TeigakuKakinGaku = pvalue; return this; }
		public Decimal TesuryoRate; public KakinEntData setTesuryoRate(Decimal pValue){ this.TesuryoRate = pvalue; return this; }
		public Boolean IsFirstMonth; public KakinEntData setIsFirstMonth(Boolean pValue){ this.IsFirstMonth = pvalue; return this; }
	}
	public interface IKakinEntDataPvr{
		List<KakinEntData> selectByIds(List<String> pIds);
		List<KakinEntData> selectForKakinByTargetYm(Date pTargetYearMonth, List<String> pKeiyakuBangos);
	}
	public class KakinEntDataPvr implements IKakinEntDataPvr{
		public List<KakinEntData> selectByIds(List<String> pIds){
			List<KakinEntData> theKakinEntDatas = new List<KakinEntData>();
			for( TeiHehDaiKakinSchEnt__c aEnt : [
				SELECT Id,
				KeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c,
				KeiyakuRef__r.KeiyakuBango__c,
				BeginDate__c, KakinScheme__c, Kingaku__c, SogishaTesuryoToribunRitsu__c, isFirstMonth__c
				FROM TeiHehDaiKakinSchEnt__c
				WHERE Id IN :pIds
			]){
				theKakinEntDatas.add(
					new KakinEntData().setKakinEntId(aEnt.Id)
						.setTorihikiSakiBango(aEnt.KeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c)
						.setKeiyakuBango(aEnt.KeiyakuRef__r.KeiyakuBango__c)
						.setBeginDate(aEnt.BeginDate__c).setKakinScheme(aEnt.KakinScheme__c)
						.setTeigakuKakinGaku(aEnt.Kingaku__c).setTesuryoRate(aEnt.SogishaTesuryoToribunRitsu__c)
						.setIsFirstMonth(aEnt.isFirstMonth__c)
				);
			}
			return theKakinEntDatas;
		}
		public List<KakinEntData> selectForKakinByTargetYm(Date pTargetYearMonth, List<String> pKeiyakuBangos){
			Date theTargetYmFrom = pTargetYearMonth.toStartOfMonth();
			Date theTargetYmTo = theTargetYmFrom.addMonths(1).addDays(-1);

			List<KakinEntData> theKakinEntDatas = new List<KakinEntData>();
			for( TeiHehDaiKakinSchEnt__c aEnt : [
				SELECT Id,
				KeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c,
				KeiyakuRef__r.KeiyakuBango__c,
				BeginDate__c, KakinScheme__c, Kingaku__c, SogishaTesuryoToribunRitsu__c, isFirstMonth__c
				FROM TeiHehDaiKakinSchEnt__c
				WHERE BeginDate__c >= :theTargetYmFrom AND BeginDate__c <= :theTargetYmTo
				AND KeiyakuRef__r.KeiyakuBango__c IN :pKeiyakuBangos
			]){
				theKakinEntDatas.add(
					new KakinEntData().setKakinEntId(aEnt.Id)
						.setTorihikiSakiBango(aEnt.KeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c)
						.setKeiyakuBango(aEnt.KeiyakuRef__r.KeiyakuBango__c)
						.setBeginDate(aEnt.BeginDate__c).setKakinScheme(aEnt.KakinScheme__c)
						.setTeigakuKakinGaku(aEnt.Kingaku__c).setTesuryoRate(aEnt.SogishaTesuryoToribunRitsu__c)
						.setIsFirstMonth(aEnt.isFirstMonth__c)
				);
			}
			return theKakinEntDatas;
		}
	}

	public class KeiyakuData{
		public String KeiyakuBango; public KeiyakuData setKeiyakuBango(String pValue){ this.KeiyakuBango = pvalue; return this; }
		public String KeiyakuId; public KeiyakuData setKeiyakuId(String pValue){ this.KeiyakuId = pvalue; return this; }
		public String TorihikiSakiBango; public KeiyakuData setTorihikiSakiBango(String pValue){ this.TorihikiSakiBango = pvalue; return this; }
		public String TorihikiSakiId; public KeiyakuData setTorihikiSakiId(String pValue){ this.TorihikiSakiId = pvalue; return this; }
		public String TorihikiSakiName; public KeiyakuData setTorihikiSakiName(String pValue){ this.TorihikiSakiName = pvalue; return this; }
		public String ToAddrZipCode; public KeiyakuData setToAddrZipCode(String pValue){ this.ToAddrZipCode = pvalue; return this; }
		public String ToAddrState; public KeiyakuData setToAddrState(String pValue){ this.ToAddrState = pvalue; return this; }
		public String ToAddrCity; public KeiyakuData setToAddrCity(String pValue){ this.ToAddrCity = pvalue; return this; }
		public String ToAddrStreet; public KeiyakuData setToAddrStreet(String pValue){ this.ToAddrStreet = pvalue; return this; }
		public String FrikzBankCode; public KeiyakuData setFrikzBankCode(String pValue){ this.FrikzBankCode = pvalue; return this; }
		public String FrikzBankName; public KeiyakuData setFrikzBankName(String pValue){ this.FrikzBankName = pvalue; return this; }
		public String FrikzShitenCode; public KeiyakuData setFrikzShitenCode(String pValue){ this.FrikzShitenCode = pvalue; return this; }
		public String FrikzShitenName; public KeiyakuData setFrikzShitenName(String pValue){ this.FrikzShitenName = pvalue; return this; }
		public String FrikzKouzaType; public KeiyakuData setFrikzKouzaType(String pValue){ this.FrikzKouzaType = pvalue; return this; }
		public String FrikzKouzaBango; public KeiyakuData setFrikzKouzaBango(String pValue){ this.FrikzKouzaBango = pvalue; return this; }
		public String FrikzKouzaMeigi; public KeiyakuData setFrikzKouzaMeigi(String pValue){ this.FrikzKouzaMeigi = pvalue; return this; }

	}
	public interface IKeiyakuDataPvr{
		List<KeiyakuData> selectByKeiyakuBangos(List<String> pKeiyakuBangos);
	}
	public class KeiyakuDataPvr implements IKeiyakuDataPvr{
		public List<KeiyakuData> selectByKeiyakuBangos(List<String> pKeiyakuBangos){
			List<KeiyakuData> theKeiyakuDatas = new LIst<KeiyakuData>();

			for(Keiyaku__c aKeiyaku : [
				SELECT Id, KeiyakuBango__c, 
				Teikeisaki__r.TorihikisakiBango__c, Teikeisaki__c,
				Teikeisaki__r.Name, 
				Teikeisaki__r.NameShogo__c,
				Teikeisaki__r.BillingPostalCode, Teikeisaki__r.BillingState, 
				Teikeisaki__r.BillingCity, Teikeisaki__r.BillingStreet,
				Teikeisaki__r.SeikyuSakiAtena__c,
				Teikeisaki__r.SeikyuSakiAddrPostalCode__c, Teikeisaki__r.SeikyuSakiAddrState__c, 
				Teikeisaki__r.SeikyuSakiAddrCity__c, Teikeisaki__r.SeikyuSakiAddrStreet__c,
				Teikeisaki__r.KinyukikanCodeTosha__c, Teikeisaki__r.KinyukikanMeiTosha__c,
				Teikeisaki__r.ShitenCodeTosha__c, Teikeisaki__r.ShitenMeiTosha__c,
				Teikeisaki__r.KozaShubetsuTosha__c, Teikeisaki__r.KozaBangoTosha__c,
				Teikeisaki__r.KozaMeigiKanaTosha__c
				FROM Keiyaku__c
				WHERE KeiyakuBango__c IN :pKeiyakuBangos
			]){
				String theToName = aKeiyaku.Teikeisaki__r.Name;
				if( !String.isBlank(aKeiyaku.Teikeisaki__r.NameShogo__c) ) theToName = aKeiyaku.Teikeisaki__r.NameShogo__c;
				if( !String.isBlank(aKeiyaku.Teikeisaki__r.SeikyuSakiAtena__c) ) theToName = aKeiyaku.Teikeisaki__r.SeikyuSakiAtena__c;

				Boolean toUseSeikyuSakiAddress = 
					!String.isBlank(aKeiyaku.Teikeisaki__r.SeikyuSakiAddrState__c)
					&& !String.isBlank(aKeiyaku.Teikeisaki__r.SeikyuSakiAddrCity__c)
					&& !String.isBlank(aKeiyaku.Teikeisaki__r.SeikyuSakiAddrStreet__c)
					;

				String theZipCode, theState, theCity, theStreet;
				if(toUseSeikyuSakiAddress){
					theZipCode = aKeiyaku.Teikeisaki__r.SeikyuSakiAddrPostalCode__c;
					theState = aKeiyaku.Teikeisaki__r.SeikyuSakiAddrState__c;
					theCity = aKeiyaku.Teikeisaki__r.SeikyuSakiAddrCity__c;
					theStreet = aKeiyaku.Teikeisaki__r.SeikyuSakiAddrStreet__c;
				}
				else{
					theZipCode = aKeiyaku.Teikeisaki__r.BillingPostalCode;
					theState = aKeiyaku.Teikeisaki__r.BillingState;
					theCity = aKeiyaku.Teikeisaki__r.BillingCity;
					theStreet = aKeiyaku.Teikeisaki__r.BillingStreet;
				}

				theKeiyakuDatas.add(
					new KeiyakuData()
						.setKeiyakuBango(aKeiyaku.KeiyakuBango__c).setKeiyakuId(aKeiyaku.Id)
						.setTorihikiSakiBango(aKeiyaku.Teikeisaki__r.TorihikisakiBango__c).setTorihikiSakiId(aKeiyaku.Teikeisaki__c)
						.setTorihikiSakiName(theToName)
						.setToAddrZipCode(theZipCode).setToAddrState(theState)
						.setToAddrCity(theCity).setToAddrStreet(theStreet)
						.setFrikzBankCode(aKeiyaku.Teikeisaki__r.KinyukikanCodeTosha__c)
						.setFrikzBankName(aKeiyaku.Teikeisaki__r.KinyukikanMeiTosha__c)
						.setFrikzShitenCode(aKeiyaku.Teikeisaki__r.ShitenCodeTosha__c)
						.setFrikzShitenName(aKeiyaku.Teikeisaki__r.ShitenMeiTosha__c)
						.setFrikzKouzaType(aKeiyaku.Teikeisaki__r.KozaShubetsuTosha__c)
						.setFrikzKouzaBango(aKeiyaku.Teikeisaki__r.KozaBangoTosha__c)
						.setFrikzKouzaMeigi(aKeiyaku.Teikeisaki__r.KozaMeigiKanaTosha__c)
				);
			}
		return theKeiyakuDatas;
		}
	}

	public class ToiawaseData{
		public String ShodanBango; public ToiawaseData setShodanBango(String pValue){ this.ShodanBango = pvalue; return this; }
		public String ShodanId; public ToiawaseData setShodanId(String pValue){ this.ShodanId = pvalue; return this; }
		public String SogishaTorihikiSakiBango; public ToiawaseData setSogishaTorihikiSakiBango(String pValue){ this.SogishaTorihikiSakiBango = pvalue; return this; }
		public Date ToiawaseDate; public ToiawaseData setToiawaseDate(Date pValue){ this.ToiawaseDate = pvalue; return this; }
		public String ObouPlan; public ToiawaseData setObouPlan(String pValue){ this.ObouPlan = pvalue; return this; }
		public String SeshuName; public ToiawaseData setSeshuName(String pValue){ this.SeshuName = pvalue; return this; }
	}
	public interface IToiawaseDataPvr{
		List<ToiawaseData> selectForToiawaseByTargetYm(Date pTargetYearMonth,  List<String> pSogishaTorihikisakiBangos);
	}
	public class ToiawaseDataPvr implements IToiawaseDataPvr{
		public List<ToiawaseData> selectForToiawaseByTargetYm(Date pTargetYearMonth,  List<String> pSogishaTorihikisakiBangos){
			
			List<ToiawaseData> theToiawaseDatas = new List<ToiawaseData>();

			Date theFromDate = pTargetYearMonth.toStartOfMonth();
			Date theToDate = theFromDate.addMonths(1).addDays(-1);
			for( TerapToiRec__c aTerapToiRec : [
			SELECT Id, 
			ShodanBango__c, OppRef__c,
			ToribunRateYmApplyingFor__c,
			SogishaTorihikisakiBango__c, 
			ToiawaseDate__c, 
			SodanshaName__c, OppRef__r.Account.LastName,
			HoyoShubetsu__c
			FROM TerapToiRec__c
			WHERE ToribunRateYmApplyingFor__c >= :theFromDate AND ToribunRateYmApplyingFor__c <= :theToDate
			AND SogishaTorihikisakiBango__c IN :pSogishaTorihikisakiBangos
			]){
				theToiawaseDatas.add(
					new ToiawaseData()
						.setSogishaTorihikiSakiBango(aTerapToiRec.SogishaTorihikiSakiBango__c)
						.setToiawaseDate(aTerapToiRec.ToiawaseDate__c)
						.setShodanBango(aTerapToiRec.ShodanBango__c).setShodanId(aTerapToiRec.OppRef__c)
						.setSeshuName(aTerapToiRec.OppRef__r.Account.LastName)
						.setObouPlan(aTerapToiRec.HoyoShubetsu__c)
				);
			}
			return theToiawaseDatas;
		}
	}

	public class SekoData{
		public String ShodanBango; public SekoData setShodanBango(String pValue){ this.ShodanBango = pvalue; return this; }
		public String ShodanId; public SekoData setShodanId(String pValue){ this.ShodanId = pvalue; return this; }
		public String SogishaTorihikiSakiBango; public SekoData setSogishaTorihikiSakiBango(String pValue){ this.SogishaTorihikiSakiBango = pvalue; return this; }
		public Date SekoDate; public SekoData setSekoDate(Date pValue){ this.SekoDate = pvalue; return this; }
		public String ObouPlan; public SekoData setObouPlan(String pValue){ this.ObouPlan = pvalue; return this; }
		public String SeshuName; public SekoData setSeshuName(String pValue){ this.SeshuName = pvalue; return this; }
	}
	public interface ISekoDataPvr{
		List<SekoData> selectByTargetYm(Date pTargetYearMonth,  List<String> pSogishaTorihikisakiBangos);
	}
	public class SekoDataPvr implements ISekoDataPvr{
		public List<SekoData> selectByTargetYm(Date pTargetYearMonth,  List<String> pSogishaTorihikisakiBangos){
			List<SekoData> theSekoDatas = new List<SekoData>();

			Date theFromDate = pTargetYearMonth.toStartOfMonth();
			Date theToDate = pTargetYearMonth.addMonths(1).addDays(-1);
			for(Opportunity aOpp : [
				SELECT Id,
				ObosanbinRef__r.Sogisha__r.TorihikisakiBango__c,
				Utiagebi__c, ShodanBango__c, Account.LastName, ObosanbinRef__r.MemorialServicePlan__c
				FROM Opportunity
				WHERE Utiagebi__c >= :theFromDate AND Utiagebi__c <= :theToDate
				AND RyunyumotoService__c = '定額僧侶手配代行'
				AND RecordType.DeveloperName = 'Obosanbin' 
				AND ObosanbinRef__r.Sogisha__r.TorihikisakiBango__c IN :pSogishaTorihikisakiBangos
				AND IsWon = true
			]){
				theSekoDatas.add(
					new SekoData()
						.setSogishaTorihikiSakiBango(aOpp.ObosanbinRef__r.Sogisha__r.TorihikisakiBango__c)
						.setSekoDate(aOpp.Utiagebi__c)
						.setShodanBango(aOpp.ShodanBango__c).setShodanId(aOpp.Id)
						.setSeshuName(aOpp.Account.LastName)
						.setObouPlan(aOpp.ObosanbinRef__r.MemorialServicePlan__c)
				);
			}
			return theSekoDatas;
		}
	}

}