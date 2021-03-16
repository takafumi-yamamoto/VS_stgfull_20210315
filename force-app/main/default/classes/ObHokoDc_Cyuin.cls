public class ObHokoDc_Cyuin implements IObHokoDc_Cyuin{

    public interface IObHokoDc_Cyuin {
        OpFcReq.TemplateData getOpFcTemplateData(String pOppId);
    }
    
    public static Boolean to_include(String pOboPlanName){
        String MemorialServicePlan = pOboPlanName;
        return new List<String>{
            '火葬式','一日葬','一般葬',
            '初七日法要','二七日法要','三七日法要','四七日法要',
            '四十九日法要','五七日法要','六七日法要'
            }
            .contains( MemorialServicePlan );
    }

    public class Record{
        public String futananoka = '';
        public String hyakkanichi = '';
        public String isshuki = '';
        public String itsunanoka = '';
        public String jusankaiki = '';
        public String kojin_age = '';
        public String kojin_death_date = '';
        public String kojin_name = '';
        public String minanoka = '';
        public String munanoka = '';
        public String sankaiki = '';
        public String shijukunichi = '';
        public String shonanoka = '';
        public String sichikaiki = '';
        public String yonanoka = '';        

        public List<String> getColumns(){
            return new List<String>{
                'futananoka',
                'hyakkanichi',
                'isshuki',
                'itsunanoka',
                'jusankaiki',
                'kojin_age',
                'kojin_death_date',
                'kojin_name',
                'minanoka',
                'munanoka',
                'sankaiki',
                'shijukunichi',
                'shonanoka',
                'sichikaiki',
                'yonanoka'                                             
            };
        }

        public List<String> getValues(){
            return new List<String>{
                this.futananoka,
                this.hyakkanichi,
                this.isshuki,
                this.itsunanoka,
                this.jusankaiki,
                this.kojin_age,
                this.kojin_death_date,
                this.kojin_name,
                this.minanoka,
                this.munanoka,
                this.sankaiki,
                this.shijukunichi,
                this.shonanoka,
                this.sichikaiki,
                this.yonanoka                                         
            };
        }
    }

    public OpFcReq.TemplateData getOpFcTemplateData(String pOppId){


        Opportunity theOpp = [
            SELECT Id, 
            ObosanbinRef__r.Taishosha1Ref__r.Name,
            ObosanbinRef__r.Taishosha1Ref__r.FirstName,
            ObosanbinRef__r.Taishosha1Ref__r.BotsunengappiWareki__c,
            ObosanbinRef__r.Taishosha1Ref__r.Age__pc
            FROM Opportunity WHERE Id = :pOppId
            LIMIT 1
        ].get(0);

        Record aRecord = new Record();

        aRecord.kojin_name = theOpp.ObosanbinRef__r.Taishosha1Ref__r.Name;

        Date the_death_date = null;
        if( !String.isBlank(theOpp.ObosanbinRef__r.Taishosha1Ref__r.BotsunengappiWareki__c) ){
            the_death_date = JpCalendar.convertWarekiToSeireki(theOpp.ObosanbinRef__r.Taishosha1Ref__r.BotsunengappiWareki__c);
        }

        aRecord.kojin_death_date = 
            the_death_date == null
            ? '' 
            : Datetime.newInstance( the_death_date.year(), the_death_date.month(), the_death_date.day() ).format('yyyy年M月d日');

        aRecord.kojin_age = 
            theOpp.ObosanbinRef__r.Taishosha1Ref__r.Age__pc == null
            ? ''
            : String.valueOf(theOpp.ObosanbinRef__r.Taishosha1Ref__r.Age__pc);

        aRecord.shonanoka = the_death_date == null ? '' : format_date( the_death_date.addDays(6) );
        aRecord.futananoka = the_death_date == null ? '' : format_date( the_death_date.addDays(13) );
        aRecord.minanoka = the_death_date == null ? '' : format_date( the_death_date.addDays(20) );
        aRecord.yonanoka = the_death_date == null ? '' : format_date( the_death_date.addDays(27) );
        aRecord.itsunanoka = the_death_date == null ? '' : format_date( the_death_date.addDays(34) );
        aRecord.munanoka = the_death_date == null ? '' : format_date( the_death_date.addDays(41) );
        aRecord.shijukunichi = the_death_date == null ? '' : format_date( the_death_date.addDays(48) );
        aRecord.hyakkanichi = the_death_date == null ? '' : format_date( the_death_date.addDays(99) );
        aRecord.isshuki = the_death_date == null ? '' : format_date( the_death_date.addYears(1) );
        aRecord.sankaiki = the_death_date == null ? '' : format_date( the_death_date.addYears(2) );
        aRecord.sichikaiki = the_death_date == null ? '' : format_date( the_death_date.addYears(6) );
        aRecord.jusankaiki = the_death_date == null ? '' : format_date( the_death_date.addYears(12) );

        return
        new OpFcReq.TemplateData()
        .setTemplateName('live_ObHokoDc_Cyuin_v20201110')
        .addDatasets(
            new LIst<OpFcReq.DataSet>{
                new OpFcReq.DataSet()
                .addRows(
                    new List<OpFcReq.CsvRow>{ 
                        new OpFcReq.CsvRow().setColumnValues( aRecord.getColumns() ),
                        new OpFcReq.CsvRow().setColumnValues( aRecord.getValues() )
                    }
                )
            }
        );
    }

    public String format_date(Date pDate){
        if(pDate == null) return '';
        Datetime theDatetime = Datetime.newInstance( pDate.year(), pDate.month(), pDate.day() );
        String theYoubi = '';
        if( theDatetime.format('E') == 'Mon' ) theYoubi = '月';
        if( theDatetime.format('E') == 'Tue' ) theYoubi = '火';
        if( theDatetime.format('E') == 'Wed' ) theYoubi = '水';
        if( theDatetime.format('E') == 'Thu' ) theYoubi = '木';
        if( theDatetime.format('E') == 'Fri' ) theYoubi = '金';
        if( theDatetime.format('E') == 'Sat' ) theYoubi = '土';
        if( theDatetime.format('E') == 'Sun' ) theYoubi = '日';

        return theDatetime.format('yyyy年M月d日') + '(' + theYoubi + ')';
    }
}