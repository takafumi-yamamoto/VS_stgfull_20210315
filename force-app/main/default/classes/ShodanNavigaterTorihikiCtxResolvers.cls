public class ShodanNavigaterTorihikiCtxResolvers{

    public class TorihikiCtx{
        // public String torihikiSakiId { 
        //     get; private set; }
        public String torihikiSakiId {
            get { if(torihikiSakiId == null){torihikiSakiId = '';} return torihikiSakiId; }
            set { torihikiSakiId = value; }
        }
        public TorihikiCtx SetTorihikiSakiId(String value){
            this.torihikiSakiId = value; return this;
        }
        // public String torihikiShodanId { get; private set; }
        public String torihikiShodanId {
            get { if(torihikiShodanId == null){torihikiShodanId = '';} return torihikiShodanId; }
            set { torihikiShodanId = value; }
        }
        public TorihikiCtx SetTorihikiShodanId(String value){
            this.torihikiShodanId = value; return this;
        }
    }

    public static ITorihikiCtxResolver GetResolver(String recordId){
        ITorihikiCtxResolver theResolver = null;
        String objectTypeName = SobjectsExtension.GetObjectApiNameById(recordId);
        if(objectTypeName == 'Account'){
            return new TorihikiCtxResolverOnAccount();
        }
        if(objectTypeName == 'Case'){
            return new TorihikiCtxResolverOnCase(CaseDaos.GetInstance());
        }
        if(objectTypeName == 'Opportunity'){
            return new TorihikiCtxResolverOnOpportunity(new OpportunityDao());
        }
        /*if(objectTypeName == 'SimpleYasugo__c'){
            return new TorihikiCtxResolverOnSimpleYasugo(
                new SimpleYasugoDao(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'Obosanbin__c'){
            return new TorihikiCtxResolverOnObousanbin(
                ObousanbinDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'SeizenKeiyaku__c'){
            return new TorihikiCtxResolverOnSeizenKeiyaku(
                SeizenKeiyakuDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'EitaiKuyo__c'){
            return new TorihikiCtxResolverOnEitaiKuyo(
                EitaiKuyoDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'BestButsudan__c'){
            return new TorihikiCtxResolverOnBestButsudan(
                BestButsudanDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'Jizenwari__c'){
            return new TorihikiCtxResolverOnJizenwari(
                JizenwariDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'KyokaHaitatsuRev__c'){
            return new TorihikiCtxResolverOnKyokaHaitatsuRev(
                KyokaHaitatsuRevDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'Hakapita__c'){
            return new TorihikiCtxResolverOnHakapita(
                HakapitaDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'UchusoSorae__c'){
            return new TorihikiCtxResolverOnUchusoSorae(
                UchusoSoraeDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'KakuyasuBoseki__c'){
            return new TorihikiCtxResolverOnKakuyasuBoseki(
                KakuyasuBosekiDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'KaiyoSankotsuUmie__c'){
            return new TorihikiCtxResolverOnKaiyoSankotsuUmie(
                KaiyoSankotsuUmieDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }
        if(objectTypeName == 'SougiRev__c'){
            return new TorihikiCtxResolverOnSougiRev(
                SougiRevDaos.GetInstance(),
                new OpportunityDao(),
                RecordTypeCachedDaos.GetInstance());
        }*/
        return theResolver;
        return null;
    }

    public interface ITorihikiCtxResolver{
        TorihikiCtx ResolveTorihikiCtx(String recordId);
    }

    public class TorihikiCtxResolverOnAccount Implements ITorihikiCtxResolver{
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx().SetTorihikiSakiId(recordId);
        }
    }

    public class TorihikiCtxResolverOnCase Implements ITorihikiCtxResolver{
        private CaseDaos.ICaseDao f_CaseDao;

        public TorihikiCtxResolverOnCase(CaseDaos.ICaseDao caseDao){
            f_CaseDao = caseDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            Case theCase = f_CaseDao.SelectById(recordId);
            return new TorihikiCtx().SetTorihikiSakiId(theCase.AccountId == null ? '' : theCase.AccountId);
        }
    }

    public class TorihikiCtxResolverOnOpportunity Implements ITorihikiCtxResolver{
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnOpportunity(OpportunityDao opportunityDao){
            f_OpportunityDao = opportunityDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            Opportunity theOpp = f_OpportunityDao.SelectById(recordId);
            TorihikiCtx theCtx = new TorihikiCtx().SetTorihikiSakiId(theOpp.AccountId);
            theCtx = theCtx.SetTorihikiShodanId(
                theOpp.TorihikiShodanFlag__c ? theOpp.Id : theOpp.TorihikiShodanRef__c
                );
            return theCtx;
        }
    }

    /*public class TorihikiCtxResolverOnSimpleYasugo Implements ITorihikiCtxResolver{
        private SimpleYasugoDao f_SimpleYasugoDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnSimpleYasugo(
            SimpleYasugoDao simpleYasugoDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_SimpleYasugoDao = simpleYasugoDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            SimpleYasugo__c theSimpleYasugo = f_SimpleYasugoDao.selectById(recordId);
            System.debug('----- theSimpleYasugo.OpportunityRef__c -----' + theSimpleYasugo.OpportunityRef__c);
            if(theSimpleYasugo == null || theSimpleYasugo.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theSimpleYasugo.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnObousanbin Implements ITorihikiCtxResolver{
        private ObousanbinDaos.IObousanbinDao f_ObousanbinDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnObousanbin(
            ObousanbinDaos.IObousanbinDao obousanbinDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_ObousanbinDao = obousanbinDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            Obosanbin__c theObousanbin = f_ObousanbinDao.selectById(recordId);
            if(theObousanbin == null || theObousanbin.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theObousanbin.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnSeizenKeiyaku Implements ITorihikiCtxResolver{
        private SeizenKeiyakuDaos.ISeizenKeiyakuDao f_SeizenKeiyakuDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnSeizenKeiyaku(
            SeizenKeiyakuDaos.ISeizenKeiyakuDao seizenKeiyakuDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_SeizenKeiyakuDao = seizenKeiyakuDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            SeizenKeiyaku__c theSeizenKeiyaku = f_SeizenKeiyakuDao.selectById(recordId);
            if(theSeizenKeiyaku == null || theSeizenKeiyaku.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theSeizenKeiyaku.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnEitaiKuyo Implements ITorihikiCtxResolver{
        private EitaiKuyoDaos.IEitaiKuyoDao f_EitaiKuyoDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnEitaiKuyo(
            EitaiKuyoDaos.IEitaiKuyoDao eitaiKuyoDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_EitaiKuyoDao = eitaiKuyoDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            EitaiKuyo__c theEitaiKuyo = f_EitaiKuyoDao.selectById(recordId);
            if(theEitaiKuyo == null || theEitaiKuyo.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theEitaiKuyo.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnBestButsudan Implements ITorihikiCtxResolver{
        private BestButsudanDaos.IBestButsudanDao f_BestButsudanDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnBestButsudan(
            BestButsudanDaos.IBestButsudanDao bestButsudanDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_BestButsudanDao = bestButsudanDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            BestButsudan__c theBestButsudan = f_BestButsudanDao.selectById(recordId);
            if(theBestButsudan == null || theBestButsudan.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theBestButsudan.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnJizenwari Implements ITorihikiCtxResolver{
        private JizenwariDaos.IJizenwariDao f_JizenwariDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnJizenwari(
            JizenwariDaos.IJizenwariDao jizenwariDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_JizenwariDao = jizenwariDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            Jizenwari__c theJizenwari = f_JizenwariDao.selectById(recordId);
            if(theJizenwari == null || theJizenwari.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theJizenwari.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnKyokaHaitatsuRev Implements ITorihikiCtxResolver{
        private KyokaHaitatsuRevDaos.IKyokaHaitatsuRevDao f_KyokaHaitatsuRevDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnKyokaHaitatsuRev(
            KyokaHaitatsuRevDaos.IKyokaHaitatsuRevDao kyokaHaitatsuRevDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_KyokaHaitatsuRevDao = kyokaHaitatsuRevDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            KyokaHaitatsuRev__c theKyokaHaitatsuRev = f_KyokaHaitatsuRevDao.selectById(recordId);
            if(theKyokaHaitatsuRev == null || theKyokaHaitatsuRev.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theKyokaHaitatsuRev.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnHakapita Implements ITorihikiCtxResolver{
        private HakapitaDaos.IHakapitaDao f_HakapitaDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnHakapita(
            HakapitaDaos.IHakapitaDao hakapitaDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_HakapitaDao = hakapitaDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            Hakapita__c theHakapita = f_HakapitaDao.selectById(recordId);
            if(theHakapita == null || theHakapita.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theHakapita.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnUchusoSorae Implements ITorihikiCtxResolver{
        private UchusoSoraeDaos.IUchusoSoraeDao f_UchusoSoraeDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnUchusoSorae (
            UchusoSoraeDaos.IUchusoSoraeDao uchusoSoraeDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_UchusoSoraeDao = uchusoSoraeDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            UchusoSorae__c theUchusoSorae = f_UchusoSoraeDao.selectById(recordId);
            if(theUchusoSorae == null || theUchusoSorae.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theUchusoSorae.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnKakuyasuBoseki Implements ITorihikiCtxResolver{
        private KakuyasuBosekiDaos.IKakuyasuBosekiDao f_KakuyasuBosekiDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnKakuyasuBoseki(
            KakuyasuBosekiDaos.IKakuyasuBosekiDao kakuyasuBosekiDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_KakuyasuBosekiDao = kakuyasuBosekiDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            KakuyasuBoseki__c theKakuyasuBoseki = f_KakuyasuBosekiDao.selectById(recordId);
            if(theKakuyasuBoseki == null || theKakuyasuBoseki.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theKakuyasuBoseki.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnKaiyoSankotsuUmie Implements ITorihikiCtxResolver{
        private KaiyoSankotsuUmieDaos.IKaiyoSankotsuUmieDao f_KaiyoSankotsuUmieDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnKaiyoSankotsuUmie(
            KaiyoSankotsuUmieDaos.IKaiyoSankotsuUmieDao kaiyoSankotsuUmieDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_KaiyoSankotsuUmieDao = kaiyoSankotsuUmieDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            KaiyoSankotsuUmie__c theKaiyoSankotsuUmie = f_KaiyoSankotsuUmieDao.selectById(recordId);
            if(theKaiyoSankotsuUmie == null || theKaiyoSankotsuUmie.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theKaiyoSankotsuUmie.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }

    public class TorihikiCtxResolverOnSougiRev Implements ITorihikiCtxResolver{
        private SougiRevDaos.ISougiRevDao f_SougiRevDao;
        private OpportunityDao f_OpportunityDao;
        private RecordTypeCachedDaos.IRecordTypeCachedDao f_RecordTypeCachedDao;

        public TorihikiCtxResolverOnSougiRev(
            SougiRevDaos.ISougiRevDao sougiRevDao,
            OpportunityDao opportunityDao,
            RecordTypeCachedDaos.IRecordTypeCachedDao recordTypeCachedDao){
            f_SougiRevDao = sougiRevDao;
            f_OpportunityDao = opportunityDao;
            f_RecordTypeCachedDao = recordTypeCachedDao;
        }
        public TorihikiCtx ResolveTorihikiCtx(String recordId){
            return new TorihikiCtx();
            SougiRev__c theSougiRev = f_SougiRevDao.selectById(recordId);
            if(theSougiRev == null || theSougiRev.OpportunityRef__c == null){ return new TorihikiCtx();}
            Opportunity theServiceOpp = f_OpportunityDao.SelectById(theSougiRev.OpportunityRef__c);
            TorihikiCtx theCtx = new TorihikiCtx()
                .SetTorihikiSakiId(theServiceOpp.AccountId)
                .SetTorihikiShodanId(theServiceOpp.TorihikiShodanRef__c);
            return theCtx;
        }
    }*/
}