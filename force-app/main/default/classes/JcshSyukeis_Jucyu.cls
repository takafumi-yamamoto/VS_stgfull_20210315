public class JcshSyukeis_Jucyu {

    public static ISyukei_Logic_Of_Jucyu get_ISyukei_Logic_Of_Jucyu_instance(){
        return new Syukei_Logic_Of_Jucyu(
            get_IJucyu_BunruiCode_Mapper_instance()
        );
    }

    public static IJucyu_BunruiCode_Mapper get_IJucyu_BunruiCode_Mapper_instance(){
        return new Jucyu_BunruiCode_Mapper(
            JcshSyukeisPlanKbn.get_IPlanKbn_By_OppLine_Mapper_instance(),
            JcshSyukeisShiboJizenKbn.get_IShibo_Or_JizenKbn_Mapper_instance()
        );
    }

    public class SyukeiResult{
        public Map<String, Decimal> bunrui_code_to_count_map = new Map<String, Decimal>();
        public Set<String> shodan_bango_of_mibunrui = new Set<String>();
    }

    public interface ISyukei_Logic_Of_Jucyu {
        SyukeiResult get_syukei(Date pDate);
    }
    public class Syukei_Logic_Of_Jucyu implements ISyukei_Logic_Of_Jucyu{
        private IJucyu_BunruiCode_Mapper m_IJucyu_BunruiCode_Mapper;
        public Syukei_Logic_Of_Jucyu(IJucyu_BunruiCode_Mapper p_IJucyu_BunruiCode_Mapper){
            this.m_IJucyu_BunruiCode_Mapper = p_IJucyu_BunruiCode_Mapper;
        }

        public SyukeiResult get_syukei(Date pDate){
            SyukeiResult the_SyukeiResult = new SyukeiResult();

            Datetime the_datetime_from = Datetime.newInstance( pDate.year(), pDate.month(), pDate.day(), 0, 0 ,0 );
            Date the_date_to = pDate.addDays(1);
            Datetime the_datetime_to = Datetime.newInstance( the_date_to.year(), the_date_to.month(), the_date_to.day(), 0, 0 ,0 );

            String the_record_type_id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
            for(Opportunity aOpp : [
                SELECT Id, ShodanBango__c, KakuteibiSyodan__c, 
                TaishoushaJokyo__c,
                (
                    SELECT Id, 
                    Product2.ShohinBango__c, Product2.Name, Product2.SougiPlan__c
                    FROM OpportunityLineItems
                    WHERE Product2.SougiPlan__c = TRUE
                    LIMIT 1
                )
                FROM Opportunity
                WHERE KakuteibiSyodan__c >= :the_datetime_from AND KakuteibiSyodan__c < :the_datetime_to
                AND RecordTypeId = :the_record_type_id
                AND ShicchuKakuteibiSyodan__c = NULL
                AND StageName != '除外'
            ]){
                String a_bunrui_code = this.m_IJucyu_BunruiCode_Mapper.get_bunrui_code(aOpp);
                if(a_bunrui_code == '未分類'){ the_SyukeiResult.shodan_bango_of_mibunrui.add(aOpp.ShodanBango__c); }

                Decimal a_current_count = 
                    the_SyukeiResult.bunrui_code_to_count_map.containsKey(a_bunrui_code)
                    ? the_SyukeiResult.bunrui_code_to_count_map.get(a_bunrui_code)
                    : 0;
                a_current_count++;
                the_SyukeiResult.bunrui_code_to_count_map.put(a_bunrui_code, a_current_count);
            }

            return the_SyukeiResult;
        }
    }

    public interface IJucyu_BunruiCode_Mapper {
        String get_bunrui_code(Opportunity pOpp);
        String get_bunrui_code(String p_plan_kubun, String p_shibo_or_jizen_kubun);
    }
    public class Jucyu_BunruiCode_Mapper implements IJucyu_BunruiCode_Mapper{
        private JcshSyukeisPlanKbn.IPlanKbn_By_OppLine_Mapper m_IPlanKbn_By_OppLine_Mapper;
        private JcshSyukeisShiboJizenKbn.IShibo_Or_JizenKbn_Mapper m_IShibo_Or_JizenKbn_Mapper;
        public Jucyu_BunruiCode_Mapper(
            JcshSyukeisPlanKbn.IPlanKbn_By_OppLine_Mapper p_IPlanKbn_By_OppLine_Mapper,
            JcshSyukeisShiboJizenKbn.IShibo_Or_JizenKbn_Mapper p_IShibo_Or_JizenKbn_Mapper
        ){
            this.m_IPlanKbn_By_OppLine_Mapper = p_IPlanKbn_By_OppLine_Mapper;
            this.m_IShibo_Or_JizenKbn_Mapper = p_IShibo_Or_JizenKbn_Mapper;
        }

        public String get_bunrui_code(Opportunity pOpp){
            String a_plan_kubun = null;
            if( pOpp.OpportunityLineItems.size() > 0){
                a_plan_kubun = this.m_IPlanKbn_By_OppLine_Mapper.get_plan_kubun(pOpp);
            }
            String a_shibo_or_jizen_kubun = this.m_IShibo_Or_JizenKbn_Mapper.get_shibo_or_jizen_kubun(pOpp);
            return this.get_bunrui_code(a_plan_kubun, a_shibo_or_jizen_kubun);
        }

        public String get_bunrui_code(String p_plan_kubun, String p_shibo_or_jizen_kubun){
    
            if( p_plan_kubun =='火葬式-シンプル' && p_shibo_or_jizen_kubun == '死亡'){ return '火葬式-シンプル/死亡'; }
            if( p_plan_kubun =='火葬式-シンプル' && p_shibo_or_jizen_kubun == '事前(not死亡)'){ return '火葬式-シンプル/事前(not死亡)'; }

            if( p_plan_kubun =='火葬式-基本' && p_shibo_or_jizen_kubun == '死亡'){ return '火葬式-基本/死亡'; }
            if( p_plan_kubun =='火葬式-基本' && p_shibo_or_jizen_kubun == '事前(not死亡)'){ return '火葬式-基本/事前(not死亡)'; }

            if( p_plan_kubun =='火葬式-仏具セット' && p_shibo_or_jizen_kubun == '死亡'){ return '火葬式-仏具セット/死亡'; }
            if( p_plan_kubun =='火葬式-仏具セット' && p_shibo_or_jizen_kubun == '事前(not死亡)'){ return '火葬式-仏具セット/事前(not死亡)'; }

            if( p_plan_kubun =='火葬式-お花セット' && p_shibo_or_jizen_kubun == '死亡'){ return '火葬式-お花セット/死亡'; }
            if( p_plan_kubun =='火葬式-お花セット' && p_shibo_or_jizen_kubun == '事前(not死亡)'){ return '火葬式-お花セット/事前(not死亡)'; }

            if( p_plan_kubun =='一日' && p_shibo_or_jizen_kubun == '死亡'){ return '一日/死亡'; }
            if( p_plan_kubun =='一日' && p_shibo_or_jizen_kubun == '事前(not死亡)'){ return '一日/事前(not死亡)'; }

            if( p_plan_kubun =='二日' && p_shibo_or_jizen_kubun == '死亡'){ return '二日/死亡'; }
            if( p_plan_kubun =='二日' && p_shibo_or_jizen_kubun == '事前(not死亡)'){ return '二日/事前(not死亡)'; }

            if( p_plan_kubun =='華やか' && p_shibo_or_jizen_kubun == '死亡'){ return '華やか/死亡'; }
            if( p_plan_kubun =='華やか' && p_shibo_or_jizen_kubun == '事前(not死亡)'){ return '華やか/事前(not死亡)'; }

            return '未分類';
        }
    }

}