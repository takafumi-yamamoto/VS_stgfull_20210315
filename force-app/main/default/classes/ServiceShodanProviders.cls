public class ServiceShodanProviders{
    public class ServiceShodan{
        public String shodanId { get; private set; }
        public ServiceShodan setShodanId(String value){
            this.shodanId = value; return this;
        }
        public String serviceId { get; private set; }
        public ServiceShodan setServiceId(String value){
            this.serviceId = value; return this;
        }
    }

    public static ServiceShodanProvider GetServiceShodanProvider(){
        return new ServiceShodanProvider()
            .RegistSelector(new SimpleYasugoSelector(new SimpleYasugoDao()))
            .RegistSelector(new ObousanbinSelector(ObousanbinDaos.GetInstance()))
            .RegistSelector(new BestButsudanSelector(BestButsudanDaos.GetInstance()))
            .RegistSelector(new JizenwariSelector(JizenwariDaos.GetInstance()))
            .RegistSelector(new KyokaHaitatsuRevSelector(KyokaHaitatsuRevDaos.GetInstance()))
            .RegistSelector(new HakapitaSelector(HakapitaDaos.GetInstance()))
            .RegistSelector(new UchusoSoraeSelector(UchusoSoraeDaos.GetInstance()))
            .RegistSelector(new KakuyasuBosekiSelector(KakuyasuBosekiDaos.GetInstance()))
            .RegistSelector(new EitaiKuyoSelector(EitaiKuyoDaos.GetInstance()))
            .RegistSelector(new KaiyoSankotsuUmieSelector(KaiyoSankotsuUmieDaos.GetInstance()))
            .RegistSelector(new SeizenKeiyakuSelector(SeizenKeiyakuDaos.GetInstance()))
            .RegistSelector(new SougiRevSelector(SougiRevDaos.GetInstance()))
            ;
    }

    public class ServiceShodanProvider{
        List<IServiceShodanSelector> selectors = new List<IServiceShodanSelector>();
        
        public ServiceShodanProvider RegistSelector(IServiceShodanSelector selector){
            this.selectors.add(selector); return this;
        }

        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            selectors.add(new SimpleYasugoSelector(new SimpleYasugoDao()));
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();

            for (IServiceShodanSelector selector: selectors){
                Map<Id,ServiceShodan> aMap = selector.selectServiceShodanByOppIdsAsMapByOppId(oppIds);
                for(String aKey : aMap.keySet()){
                    theMapOfServiceShodanByOppId.put(aKey,aMap.get(aKey));
                }
            }
            return theMapOfServiceShodanByOppId;
        }

    }

    public interface IServiceShodanSelector{
        Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds);
    }
    
    public class SimpleYasugoSelector Implements IServiceShodanSelector{
        SimpleYasugoDao f_SimpleYasugoDao;

        public SimpleYasugoSelector(SimpleYasugoDao simpleYasugoDao){
            this.f_SimpleYasugoDao = simpleYasugoDao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,SimpleYasugo__c> theMapOfSimpleYasugoByOppId = f_SimpleYasugoDao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfSimpleYasugoByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfSimpleYasugoByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class ObousanbinSelector Implements IServiceShodanSelector{
        ObousanbinDaos.IObousanbinDao f_dao;

        public ObousanbinSelector(ObousanbinDaos.IObousanbinDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,Obosanbin__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class BestButsudanSelector Implements IServiceShodanSelector{
        BestButsudanDaos.IBestButsudanDao f_dao;

        public BestButsudanSelector(BestButsudanDaos.IBestButsudanDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,BestButsudan__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class JizenwariSelector Implements IServiceShodanSelector{
        JizenwariDaos.IJizenwariDao f_dao;

        public JizenwariSelector(JizenwariDaos.IJizenwariDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,Jizenwari__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class KyokaHaitatsuRevSelector Implements IServiceShodanSelector{
        KyokaHaitatsuRevDaos.IKyokaHaitatsuRevDao f_dao;

        public KyokaHaitatsuRevSelector(KyokaHaitatsuRevDaos.IKyokaHaitatsuRevDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,KyokaHaitatsuRev__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class HakapitaSelector Implements IServiceShodanSelector{
        HakapitaDaos.IHakapitaDao f_dao;

        public HakapitaSelector(HakapitaDaos.IHakapitaDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,Hakapita__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class UchusoSoraeSelector Implements IServiceShodanSelector{
        UchusoSoraeDaos.IUchusoSoraeDao f_dao;

        public UchusoSoraeSelector(UchusoSoraeDaos.IUchusoSoraeDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,UchusoSorae__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class KakuyasuBosekiSelector Implements IServiceShodanSelector{
        KakuyasuBosekiDaos.IKakuyasuBosekiDao f_dao;

        public KakuyasuBosekiSelector(KakuyasuBosekiDaos.IKakuyasuBosekiDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,KakuyasuBoseki__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class EitaiKuyoSelector Implements IServiceShodanSelector{
        EitaiKuyoDaos.IEitaiKuyoDao f_dao;

        public EitaiKuyoSelector(EitaiKuyoDaos.IEitaiKuyoDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,EitaiKuyo__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class KaiyoSankotsuUmieSelector Implements IServiceShodanSelector{
        KaiyoSankotsuUmieDaos.IKaiyoSankotsuUmieDao f_dao;

        public KaiyoSankotsuUmieSelector(KaiyoSankotsuUmieDaos.IKaiyoSankotsuUmieDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,KaiyoSankotsuUmie__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class SeizenKeiyakuSelector Implements IServiceShodanSelector{
        SeizenKeiyakuDaos.ISeizenKeiyakuDao f_dao;

        public SeizenKeiyakuSelector(SeizenKeiyakuDaos.ISeizenKeiyakuDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,SeizenKeiyaku__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }

    public class SougiRevSelector Implements IServiceShodanSelector{
        SougiRevDaos.ISougiRevDao f_dao;

        public SougiRevSelector(SougiRevDaos.ISougiRevDao dao){
            this.f_dao = dao;
        }
        public Map<Id,ServiceShodan> selectServiceShodanByOppIdsAsMapByOppId(List<Id> oppIds){
            Map<Id,ServiceShodan> theMapOfServiceShodanByOppId = new Map<Id,ServiceShodan>();
            /*Map<Id,SougiRev__c> theMapOfServiceObjByOppId = f_dao.selectByOppIdsAsMapByOppId(oppIds);
            for (String aKey : theMapOfServiceObjByOppId.keySet()) {
                ServiceShodan theServiceShodan =
                    new ServiceShodan()
                        .setShodanId(aKey)
                        .setServiceId((String)theMapOfServiceObjByOppId.get(aKey).Id);

                theMapOfServiceShodanByOppId.put(aKey,theServiceShodan);
            }*/
            return theMapOfServiceShodanByOppId;
        }
    }
}