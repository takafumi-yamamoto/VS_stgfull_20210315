public class TcmsTaioRkImpSogiShiryo {
    
    public static ISogiShiryoSofuCreator get_ISogiShiryoSofuCreator_instance(){
        return new SogiShiryoSofuCreator(
            new ShikugunResolver(),
            new TeianShisetsuResolver()
        );
    }

    public interface ISogiShiryoSofuCreator {
        void createSogiShiryoSofu(String pOppId, TcmsTaioRkImpData__c pTcmsTaioRkImpData);
    }
    public class SogiShiryoSofuCreator implements ISogiShiryoSofuCreator{

        private IShikugunResolver m_IShikugunResolver;
        private ITeianShisetsuResolver m_ITeianShisetsuResolver;

        public SogiShiryoSofuCreator(
            IShikugunResolver p_IShikugunResolver,
            ITeianShisetsuResolver p_ITeianShisetsuResolver
        ){
            this.m_IShikugunResolver = p_IShikugunResolver;
            this.m_ITeianShisetsuResolver = p_ITeianShisetsuResolver;
        }
        public void createSogiShiryoSofu(String pOppId, TcmsTaioRkImpData__c pTcmsTaioRkImpData){

            if( !new List<String>{'完了/資料送付1', '完了/資料送付2'}.contains(pTcmsTaioRkImpData.Kanryo_Shubetsu__c) ) return;

            Boolean is_panflet_only = String.isBlank(pTcmsTaioRkImpData.SogiKiboAreaCode__c);

            if(is_panflet_only){
                this.insert_SogiShiryoSofu_for_yoriso_sofu_panflet_only(pOppId, pTcmsTaioRkImpData);
            }else{
                this.insert_SogiShiryoSofu_for_yoriso_sofu(pOppId, pTcmsTaioRkImpData);
            }
        }

        private void insert_SogiShiryoSofu_for_yoriso_sofu_panflet_only(String pOppId, TcmsTaioRkImpData__c pTcmsTaioRkImpData){

            SogiShiryoSofu__c the_SogiShiryoSofu = new SogiShiryoSofu__c();
            { //Meta
                the_SogiShiryoSofu.OpportunityRef__c = pOppId;
                the_SogiShiryoSofu.SofuJokyo__c = '資料作成中';
            }

            { //印刷物
                the_SogiShiryoSofu.PamphletYohi__c = '要';

                List<String> the_docs_to_include = new List<string>();
                the_docs_to_include.add('送付状');
                the_SogiShiryoSofu.InsatsubutsuIchiran__c = String.join(the_docs_to_include,';');
            }

            { //送付先
                the_SogiShiryoSofu.Atena__c = pTcmsTaioRkImpData.Sofusaki_Atena__c;
                the_SogiShiryoSofu.SofuShubetsu__c = '郵便';
                the_SogiShiryoSofu.YusoShubetsu__c = '通常';
                the_SogiShiryoSofu.PostalCode__c = 
                    String.isBlank(pTcmsTaioRkImpData.Sofusaki_ZipCode__c) 
                    ? '' 
                    : pTcmsTaioRkImpData.Sofusaki_ZipCode__c.Replace('#','');
                the_SogiShiryoSofu.State__c = pTcmsTaioRkImpData.Sofusaki_State__c;
                the_SogiShiryoSofu.City__c = pTcmsTaioRkImpData.Sofusaki_City__c;
                the_SogiShiryoSofu.Street__c = 
                    ( String.isBlank(pTcmsTaioRkImpData.Sofusaki_Street__c) ? '' : pTcmsTaioRkImpData.Sofusaki_Street__c )
                    +
                    ( String.isBlank(pTcmsTaioRkImpData.Sofusaki_Room__c) ? '' : (' ' + pTcmsTaioRkImpData.Sofusaki_Room__c) );
            } 

            INSERT the_SogiShiryoSofu;
        }
        private void insert_SogiShiryoSofu_for_yoriso_sofu(String pOppId, TcmsTaioRkImpData__c pTcmsTaioRkImpData){

            Shikugun__c the_Shikugun = 
                this.m_IShikugunResolver.resolveShikugun( pTcmsTaioRkImpData.SogiKiboAreaCode__c, pTcmsTaioRkImpData.Sodansha_Addr_ZipCode__c);

            TeianShisetsuSet the_TeianShisetsuSet = new TeianShisetsuSet();
            if( the_Shikugun != null ){
                the_TeianShisetsuSet = this.m_ITeianShisetsuResolver.resolve(the_Shikugun.Id);
            }

            SogiShiryoSofu__c the_SogiShiryoSofu = new SogiShiryoSofu__c();
            { //Meta
                the_SogiShiryoSofu.OpportunityRef__c = pOppId;
                the_SogiShiryoSofu.SofuJokyo__c = '資料作成中';
            }

            { //印刷物
                the_SogiShiryoSofu.PamphletYohi__c = '要';

                List<String> the_docs_to_include = new List<string>();
                the_docs_to_include.add('送付状');
                if( the_TeianShisetsuSet.isShutoken ) the_docs_to_include.add('首都圏案内文');
                if( the_Shikugun != null ) the_docs_to_include.add('斎場資料');
                the_SogiShiryoSofu.InsatsubutsuIchiran__c = String.join(the_docs_to_include,';');
            }

            { //送付先
                the_SogiShiryoSofu.Atena__c = pTcmsTaioRkImpData.Sofusaki_Atena__c;
                the_SogiShiryoSofu.SofuShubetsu__c = '郵便';
                the_SogiShiryoSofu.YusoShubetsu__c = '通常';
                the_SogiShiryoSofu.PostalCode__c = 
                    String.isBlank(pTcmsTaioRkImpData.Sofusaki_ZipCode__c) 
                    ? '' 
                    : pTcmsTaioRkImpData.Sofusaki_ZipCode__c.Replace('#','');
                the_SogiShiryoSofu.State__c = pTcmsTaioRkImpData.Sofusaki_State__c;
                the_SogiShiryoSofu.City__c = pTcmsTaioRkImpData.Sofusaki_City__c;
                the_SogiShiryoSofu.Street__c = 
                    ( String.isBlank(pTcmsTaioRkImpData.Sofusaki_Street__c) ? '' : pTcmsTaioRkImpData.Sofusaki_Street__c )
                    +
                    ( String.isBlank(pTcmsTaioRkImpData.Sofusaki_Room__c) ? '' : (' ' + pTcmsTaioRkImpData.Sofusaki_Room__c) );
            } 

            INSERT the_SogiShiryoSofu;

            List<SogiShiryoSofuMeisai__c> theSofuMeisas =this.createSofuMeisais(the_SogiShiryoSofu.Id, the_TeianShisetsuSet);
            INSERT theSofuMeisas;
        }

        private List<SogiShiryoSofuMeisai__c> createSofuMeisais(String pShiryoSofuId, TeianShisetsuSet pTeianShisetsuSet){
            List<SogiShiryoSofuMeisai__c> insSogiShiryoSofuMeisaiList = new List<SogiShiryoSofuMeisai__c>();

            Integer indexKasobaTeian = 0;
            for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap standardKasoba : pTeianShisetsuSet.kasobas){
                indexKasobaTeian++;
                insSogiShiryoSofuMeisaiList.add(
                    new SogiShiryoSofuMeisai__c(
                            SogiShiryoSofuRef__c = pShiryoSofuId,
                            ShisetsuRef__c = standardKasoba.shisetsuId,
                            Hyojijun__c = indexKasobaTeian,
                            ShisetsuKubun__c = '火葬場',
                            Name = pShiryoSofuId + '_' + '火葬場' + '_' + standardKasoba.shisetsuName
                    )
                );
            }

            Integer indexSaijoTeian = 0;
            for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap standardSaijo : pTeianShisetsuSet.saijos){
                indexSaijoTeian++;
                insSogiShiryoSofuMeisaiList.add(
                    new SogiShiryoSofuMeisai__c(
                        SogiShiryoSofuRef__c = pShiryoSofuId,
                        SaijoRef__c = standardSaijo.shisetsuId,
                        Hyojijun__c = indexSaijoTeian,
                        ShisetsuKubun__c = '斎場',
                        Name = pShiryoSofuId + '_' + '斎場' + '_' + standardSaijo.shisetsuName
                    )
                );
            }

            return insSogiShiryoSofuMeisaiList;
        }
    }

    public interface IShikugunResolver {
        Shikugun__c resolveShikugun(String pSogiKiboAreaCode, String pSodanshaZipCode);
    }
    
    @TestVisible
    private class ShikugunResolver implements IShikugunResolver{
        public Shikugun__c resolveShikugun(String pSogiKiboAreaCode, String pSodanshaZipCode){
            Shikugun__c the_Shikugun = null;
            String the_area_code = this.resolveAreaCode(pSogiKiboAreaCode, pSodanshaZipCode);
            if( !String.isBlank(the_area_code) ){
                the_Shikugun = (Shikugun__c)SobjectsExtension.firstOrNull([
                    SELECT Id FROM Shikugun__c WHERE AreaCode__c = :the_area_code LIMIT 1
                ]);
            }
            return the_Shikugun;
        }
        private String resolveAreaCode(String pSogiKiboAreaCode, String pSodanshaZipCode){

            String the_area_code = null;
            the_area_code = pSogiKiboAreaCode;

            return the_area_code;
        }
    }

    public class TeianShisetsuSet{
        public List<ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap> kasobas = new List<ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap>();
        public List<ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap> saijos = new List<ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap>();
        public Boolean isShutoken = false;
    }

    public interface ITeianShisetsuResolver {
        TeianShisetsuSet resolve(String pShikugunId);
    }

    @TestVisible
    private class TeianShisetsuResolver implements ITeianShisetsuResolver{

        public TeianShisetsuSet resolve(String pShikugunId){
            TeianShisetsuSet the_result = new TeianShisetsuSet();

            if( String.isBlank(pShikugunId) ) return the_result;

            ShiryoSofuTeianShisetsuTrial.TeianShisetsuListWrap standardTeianListWrap = new ShiryoSofuTeianShisetsuTrial().getShiryoSofuTeianShisetsu(pShikugunId);
            if( standardTeianListWrap == null ) return the_result;

            if( standardTeianListWrap.standardKasobaList != null ){ the_result.kasobas.addAll( standardTeianListWrap.standardKasobaList ); }
            if( standardTeianListWrap.standardSaijoList != null ){ the_result.saijos.addAll( standardTeianListWrap.standardSaijoList ); }
    
            the_result.isShutoken = this.any_shutoken_ryokin_kasoba( the_result.kasobas );

            return the_result;
        }

        private Boolean any_shutoken_ryokin_kasoba( List<ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap> pKasobas ){
            Set<String> the_shisetsu_ids = new Set<String>();
            for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap aKasoba : pKasobas){
                the_shisetsu_ids.add( aKasoba.shisetsuId );
            }
            
            return [ SELECT Id FROM Shisetsu__c WHERE Id = :the_shisetsu_ids AND IsShutokenRyokin__c = TRUE LIMIT 1 ].size() > 0;
        }
    }
}