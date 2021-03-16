public class JcshSyukeis {
    
    public static ISyukeier get_ISyukeier_instance(){
        return new Syukeier(
            new Syukei_Logic_Of_Toiawase(),
            new Syukei_Logic_Of_OnakunariTaio(),
            JcshSyukeis_Jucyu.get_ISyukei_Logic_Of_Jucyu_instance(),
            new Syukei_Logic_Of_Shiccyu()
        );
    }

    public class SyukeiResult{
        public Datetime syukei_date_time;

        private Decimal m_tooiawase_cnt = 0;
        public Decimal tooiawase_cnt{ get { return this.m_tooiawase_cnt;} }

        private Decimal m_onakunari_taio_cnt = 0;
        public Decimal onakunari_taio_cnt { get { return this.m_onakunari_taio_cnt;} }

        public Decimal jucyu_cnt { 
            get {
                Decimal the_count = 0;
                for( Decimal a_count : this.m_bunrui_code_to_count_map.values() ){ the_count += a_count; }
                return the_count;
            } 
        }

        private Decimal m_jucyu_plus_onakunari_taio_cnt = 0;
        public Decimal jucyu_plus_onakunari_taio_cnt { get { return this.jucyu_cnt + this.m_onakunari_taio_cnt; } }

        private Decimal m_shiccyu_cnt = 0;
        public Decimal shiccyu_cnt{ get{ return this.m_shiccyu_cnt; } }

        public Decimal jucyu_rate{ 
            get { 
                if( tooiawase_cnt == 0) return -1;
                return jucyu_cnt / tooiawase_cnt; 
            } 
        }

        private Map<String, Decimal> m_bunrui_code_to_count_map = new Map<String, Decimal>();
        public Map<String, Decimal> bunrui_code_to_count_map{ 
            get { return this.m_bunrui_code_to_count_map; }
        }
    }

    public interface ISyukeier{
        SyukeiResult getSyukei(Datetime pSyukeiDateTime);
    }
    public class Syukeier implements ISyukeier{
        private ISyukei_Logic_Of_Toiawase m_ISyukei_Logic_Of_Toiawase;
        private ISyukei_Logic_Of_OnakunariTaio m_ISyukei_Logic_Of_OnakunariTaio;
        private JcshSyukeis_Jucyu.ISyukei_Logic_Of_Jucyu m_ISyukei_Logic_Of_Jucyu;
        private ISyukei_Logic_Of_Shiccyu m_ISyukei_Logic_Of_Shiccyu;
        public Syukeier(
            ISyukei_Logic_Of_Toiawase p_ISyukei_Logic_Of_Toiawase,
            ISyukei_Logic_Of_OnakunariTaio p_ISyukei_Logic_Of_OnakunariTaio,
            JcshSyukeis_Jucyu.ISyukei_Logic_Of_Jucyu p_ISyukei_Logic_Of_Jucyu,
            ISyukei_Logic_Of_Shiccyu p_ISyukei_Logic_Of_Shiccyu
        ){
            this.m_ISyukei_Logic_Of_Toiawase = p_ISyukei_Logic_Of_Toiawase;
            this.m_ISyukei_Logic_Of_OnakunariTaio = p_ISyukei_Logic_Of_OnakunariTaio;
            this.m_ISyukei_Logic_Of_Jucyu = p_ISyukei_Logic_Of_Jucyu;
            this.m_ISyukei_Logic_Of_Shiccyu = p_ISyukei_Logic_Of_Shiccyu;
        }
    
        public SyukeiResult getSyukei(Datetime pSyukeiDateTime){

            SyukeiResult the_SyukeiResult = new SyukeiResult();
            the_SyukeiResult.syukei_date_time = pSyukeiDateTime;
            the_SyukeiResult.m_tooiawase_cnt = 
                this.m_ISyukei_Logic_Of_Toiawase.get_count( pSyukeiDateTime.date() );
            the_SyukeiResult.m_onakunari_taio_cnt = 
                this.m_ISyukei_Logic_Of_OnakunariTaio.get_count( pSyukeiDateTime.date() );
            the_SyukeiResult.m_bunrui_code_to_count_map = 
                this.m_ISyukei_Logic_Of_Jucyu.get_syukei( pSyukeiDateTime.date() ).bunrui_code_to_count_map;
            the_SyukeiResult.m_shiccyu_cnt = 
                this.m_ISyukei_Logic_Of_Shiccyu.get_count( pSyukeiDateTime.date() );

            return the_SyukeiResult;
        }
    }

    public interface ISyukei_Logic_Of_Toiawase{
        Decimal get_count(Date pDate);
    }
    public class Syukei_Logic_Of_Toiawase implements ISyukei_Logic_Of_Toiawase{
        public Decimal get_count(Date pDate){
            Datetime the_datetime_from = Datetime.newInstance( pDate.year(), pDate.month(), pDate.day(), 0, 0 ,0 );
            Date the_date_to = pDate.addDays(1);
            Datetime the_datetime_to = Datetime.newInstance( the_date_to.year(), the_date_to.month(), the_date_to.day(), 0, 0 ,0 );
            String the_record_type_id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

            return (Decimal)
            [
                SELECT COUNT(Id) cnt
                FROM Opportunity
                WHERE Req_Day__c >= :the_datetime_from AND Req_Day__c < :the_datetime_to
                AND RecordTypeId = :the_record_type_id
                AND StageName != '除外'
            ][0].get('cnt');
        }
    }

    public interface ISyukei_Logic_Of_OnakunariTaio{
        Decimal get_count(Date pDate);
    }
    public class Syukei_Logic_Of_OnakunariTaio implements ISyukei_Logic_Of_OnakunariTaio{
        public Decimal get_count(Date pDate){
            Date the_date_from = pDate.addMonths(-6);
            Datetime the_datetime_from = Datetime.newInstance( the_date_from.year(), the_date_from.month(), the_date_from.day(), 0, 0 ,0 );
            Date the_date_to = pDate.addDays(1);
            Datetime the_datetime_to = Datetime.newInstance( the_date_to.year(), the_date_to.month(), the_date_to.day(), 0, 0 ,0 );
            String the_record_type_id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

            return (Decimal)
            [
                SELECT COUNT(Id) cnt
                FROM Opportunity
                WHERE Req_Day__c >= :the_datetime_from AND Req_Day__c < :the_datetime_to
                AND RecordTypeId = :the_record_type_id
                AND StageName = 'お亡くなり対応'
                AND KakuteibiSyodan__c = NULL
                AND ShicchuKakuteibiSyodan__c = NULL
            ][0].get('cnt');
        }
    }

    public interface ISyukei_Logic_Of_Shiccyu {
        Decimal get_count(Date pDate);
    }
    public class Syukei_Logic_Of_Shiccyu implements ISyukei_Logic_Of_Shiccyu{
        public Decimal get_count(Date pDate){
            Datetime the_datetime_from = Datetime.newInstance( pDate.year(), pDate.month(), pDate.day(), 0, 0 ,0 );
            Date the_date_to = pDate.addDays(1);
            Datetime the_datetime_to = Datetime.newInstance( the_date_to.year(), the_date_to.month(), the_date_to.day(), 0, 0 ,0 );
            String the_record_type_id = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

            return (Decimal)
            [
                SELECT COUNT(Id) cnt
                FROM Opportunity
                WHERE ShicchuKakuteibiSyodan__c >= :the_datetime_from AND ShicchuKakuteibiSyodan__c < :the_datetime_to
                AND RecordTypeId = :the_record_type_id
                AND StageName != '除外'
            ][0].get('cnt');
        }
    }

}