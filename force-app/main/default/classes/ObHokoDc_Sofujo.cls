public class ObHokoDc_Sofujo implements IObHokoDc_Sofujo{

    public interface IObHokoDc_Sofujo {
        OpFcReq.TemplateData getOpFcTemplateData(String pOppId, Boolean p_NoPanf);
    }

    public class Record{
        public String shodan_bango = '';
        public String issue_date = '';
        public String sofusaki_name = '';
        public String sofusaki_zip = '';
        public String sofusaki_address = '';
        public String dofu_shoruis = '';
        public String comment = '';     

        public List<String> getColumns(){
            return new List<String>{
                'shodan_bango',
                'issue_date',
                'sofusaki_name',
                'sofusaki_zip',
                'sofusaki_address',
                'dofu_shoruis',
                'comment'                                     
            };
        }

        public List<String> getValues(){
            return new List<String>{
                this.shodan_bango,
                this.issue_date,
                this.sofusaki_name,
                this.sofusaki_zip,
                this.sofusaki_address,
                this.dofu_shoruis,
                this.comment                         
            };
        }
    }

    public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, Boolean p_NoPanf){

        Opportunity theOpp = [
            SELECT Id, ShodanBango__c,
            ShiryoSoufuSakiAtena__c,
            ShiryoSoufuSakiPostalCode__c, ShiryoSoufuSakiState__c, ShiryoSoufuSakiCity__c, ShiryoSoufuSakiStreet__c,
            Account.LastName, Account.FirstName,
            Account.BillingPostalCode, Account.BillingState, Account.BillingCity, Account.BillingStreet,
            ObosanbinRef__r.MemorialServicePlan__c,
            (
                SELECT Id,
                SeikyuHouhou__c
                FROM KaisyuYoteisOpportunity__r
            )
            FROM Opportunity WHERE Id = :pOppId
            LIMIT 1
        ].get(0);

        Record aRecord = new Record();

        aRecord.shodan_bango = theOpp.ShodanBango__c;
        aRecord.issue_date = Date.today().format();

        {//資料送付先/宛名
            String sofusaki_name = 
                String.isBlank(theOpp.ShiryoSoufuSakiAtena__c)
                ? null_to_blank(theOpp.Account.LastName) + ' ' + null_to_blank(theOpp.Account.FirstName)
                : null_to_blank(theOpp.ShiryoSoufuSakiAtena__c);
                sofusaki_name += ' 様';

                aRecord.sofusaki_name = sofusaki_name;
        }

        {//資料送付先/住所
            String sofusaki_zip = '';
            String sofusaki_address = '';

            Boolean toUseSiryoSofuAddr = 
                !String.isBlank(theOpp.ShiryoSoufuSakiPostalCode__c)
                && !String.isBlank(theOpp.ShiryoSoufuSakiState__c)
                && !String.isBlank(theOpp.ShiryoSoufuSakiCity__c)
                && !String.isBlank(theOpp.ShiryoSoufuSakiStreet__c)
                ;

            if(toUseSiryoSofuAddr){
                sofusaki_zip = theOpp.ShiryoSoufuSakiPostalCode__c;
                sofusaki_address = 
                    null_to_blank(theOpp.ShiryoSoufuSakiState__c) + null_to_blank(theOpp.ShiryoSoufuSakiCity__c)
                    + '\r\n'
                    + null_to_blank(theOpp.ShiryoSoufuSakiStreet__c);
            }else{
                sofusaki_zip = theOpp.Account.BillingPostalCode;
                sofusaki_address = 
                    null_to_blank(theOpp.Account.BillingState) + null_to_blank(theOpp.Account.BillingCity)
                    + '\r\n'
                    + null_to_blank(theOpp.Account.BillingStreet);
            }

            aRecord.sofusaki_zip = sofusaki_zip;
            aRecord.sofusaki_address = sofusaki_address;
        }

        //同封書類
        aRecord.dofu_shoruis = new DofuShoruis().getText(theOpp, p_NoPanf);
        aRecord.comment = new Comment().getText(null);

        return
        new OpFcReq.TemplateData()
        .setTemplateName('live_ObHokoDc_Sofujo_v20201110')
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

    private class DofuShoruis{
        public String getText(Opportunity pOpp, Boolean p_NoPanf){
            Opportunity theOpp = pOpp;

            List<String> the_dofu_shoruis = new List<String>{'同封書類\r\n'};

            if( OboPlanKeitais.isSogi(theOpp.ObosanbinRef__r.MemorialServicePlan__c) ){
                the_dofu_shoruis.addAll(
                    new List<String>{
                        '・お坊さん手配報告書'
                    }
                );
                if(!p_NoPanf){
                    the_dofu_shoruis.addAll(
                        new List<String>{
                            '・お坊さん便サービスパンフレット',
                            '・よりそうパンフレット',
                            '・各申込書一式'
                        }
                    );
                }
            }else{
                the_dofu_shoruis.addAll(
                    new List<String>{
                        '・お坊さん手配報告書'
                    }
                );
                if(!p_NoPanf){
                    the_dofu_shoruis.addAll(
                        new List<String>{
                            '・各パンフレット'
                        }
                    );
                }
            }

            { //中陰表
                if(!p_NoPanf){
                    Boolean include_cyuinhyo = ObHokoDc_Cyuin.to_include(theOpp.ObosanbinRef__r.MemorialServicePlan__c);
                    if( include_cyuinhyo ) the_dofu_shoruis.add('・中陰早見表');
                }
            }

            { //のし袋
                if(!p_NoPanf){
                    Boolean exclude_noshi_bukuro = false;
                    
                    if( OboPlanKeitais.isKaimyo( theOpp.ObosanbinRef__r.MemorialServicePlan__c ) ) exclude_noshi_bukuro = true;
                    for( OkyakusamaSeikyuMeisai__c aSeikyuMeisai : pOpp.KaisyuYoteisOpportunity__r ){
                        if( aSeikyuMeisai.SeikyuHouhou__c == 'NpAtoNegime') exclude_noshi_bukuro = true;
                        if( aSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit') exclude_noshi_bukuro = true;
                    }
                    if( !exclude_noshi_bukuro ) the_dofu_shoruis.add('・のし袋');                
                }
            }
            
            return String.join(the_dofu_shoruis, '\r\n' );
        }
    }

    private class Comment{
        public String getText(Opportunity pOpp){
            String theText = '';
            theText += 'この度は「よりそうお坊さん便」へご依頼頂き、誠にありがとうございます。'; theText += '\r\n';
            theText += '下記の資料を送付致しますので、ご査収頂きますようお願い申し上げます。';
            return theText;
        }
    }

    private static String null_to_blank(String pValue){
        if( pValue == null ) return '';
        return pValue;
    }
}