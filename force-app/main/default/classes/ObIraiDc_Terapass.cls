public class ObIraiDc_Terapass implements IObIraiDc_Terapass{

    public interface IObIraiDc_Terapass {
        OpFcReq.TemplateData getOpFcTemplateData(String pOppId);
    }
    
    public class Record{
        public String cyui_jiko = '';
        public String issue_date = '';  

        public List<String> getColumns(){
            return new List<String>{
                'cyui_jiko',
                'issue_date'                                          
            };
        }

        public List<String> getValues(){
            return new List<String>{
                this.cyui_jiko,
                this.issue_date                                   
            };
        }
    }

    public OpFcReq.TemplateData getOpFcTemplateData(String pOppId){

        Opportunity theOpp = [
            SELECT Id, 
            Amount,
            Utiagebi__c,
            PartnerSeikyuGakuExp__c, PartnerSiharaiGakuExp__c,
            ObosanbinRef__r.KokubetsuDateTime_Inp__c,
            RyunyumotoService__c,
            ObosanbinRef__r.TeiHehOfuseKingaku__c,
            ObosanbinRef__r.TeiHehTesuryoSogisha__c,
            ObosanbinRef__r.MemorialServicePlan__c,
            ObosanbinRef__r.Sogisha__r.BankName__c,
            ObosanbinRef__r.Sogisha__r.BankBranchName__c,
            ObosanbinRef__r.Sogisha__r.BankAccountType__c,
            ObosanbinRef__r.Sogisha__r.BankAccountNo__c,
            ObosanbinRef__r.Sogisha__r.BankAccountMeigi__c
            FROM Opportunity WHERE Id = :pOppId
            LIMIT 1
        ].get(0);

        Record aRecord = new Record();

        aRecord.issue_date = Datetime.now().format('yyyy年M月d日');
        Decimal theHoyoKingaku = 0;
        Decimal theTesuryo = 0;
        { //金額
            if( theOpp.RyunyumotoService__c == '定額僧侶手配代行'){
                theHoyoKingaku = theOpp.ObosanbinRef__r.TeiHehOfuseKingaku__c == null ? 0 : theOpp.ObosanbinRef__r.TeiHehOfuseKingaku__c;
            }else{
                theHoyoKingaku = theOpp.Amount == null ? 0 : theOpp.Amount;
            }
            
            if( null_to_zero(theOpp.PartnerSeikyuGakuExp__c) != 0 || null_to_zero(theOpp.PartnerSiharaiGakuExp__c) != 0 ){
                theTesuryo = 
                    null_to_zero(theOpp.PartnerSeikyuGakuExp__c) > 0
                    ? null_to_zero(theOpp.PartnerSeikyuGakuExp__c)
                    : null_to_zero(theOpp.Amount) - null_to_zero(theOpp.PartnerSiharaiGakuExp__c);
            }
        }

        { //注意事項
            aRecord.cyui_jiko = '';
            Decimal theSogishaToribun = null_to_zero(theOpp.ObosanbinRef__r.TeiHehTesuryoSogisha__c);

            String theShiharaiKijitsu = '';
            if( OboPlanKeitais.isKaimyo(theOpp.ObosanbinRef__r.MemorialServicePlan__c) ){
                theShiharaiKijitsu = 
                theOpp.Utiagebi__c == null
                ? ''
                : format_datetime( theOpp.Utiagebi__c.addDays(14) );
            }else{
                theShiharaiKijitsu = 
                theOpp.ObosanbinRef__r.KokubetsuDateTime_Inp__c == null
                ? ''
                : format_datetime( theOpp.ObosanbinRef__r.KokubetsuDateTime_Inp__c.addDays(14) );
            }
            
            if( OboPlanKeitais.isSogi(theOpp.ObosanbinRef__r.MemorialServicePlan__c) ){
                aRecord.cyui_jiko += '1. 葬儀社さまからの特別な依頼案件となります。お客様には「お坊さん便」とはお伝えしないようお願い申し上げます。（「お坊さん便から来ました」は控えてください）\r\n';
                aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '2. 当日は、お客様から受け取ったお布施から' + theSogishaToribun.format() + '円に相当する金額を葬儀社様にお渡しください。\r\n';
                aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '3. 上記の金額は葬儀社様がご提示された金額になります。'; aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '当案件の弊社手配手数料は' + theTesuryo.format() + '円となります。通常の案件と併せて月締めでご請求させていただきます。\r\n';
                aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '4. ご依頼受諾後のキャンセルはご遠慮ください。僧侶様理由のキャンセルによりお客様、葬儀社様、弊社等に損害が発生した場合、担当僧侶様にご請求する場合がございます。';
            }else{
                aRecord.cyui_jiko += '1. 葬儀社さまからの特別な依頼案件となります。お客様には「お坊さん便」とはお伝えしないようお願い申し上げます。（「お坊さん便から来ました」は控えてください）\r\n';
                aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '2. お客様から受け取ったお布施から' + theSogishaToribun.format() + '円に相当する金額を以下葬儀社様の口座に' + theShiharaiKijitsu + 'までにお振込みください。\r\n';
                aRecord.cyui_jiko += 'お振込みが遅れた場合は弊社からのご送客を停止させていただく場合もございますので、予めご了承ください。\r\n';
                aRecord.cyui_jiko += '-----------------------------------------------------------\r\n';
                aRecord.cyui_jiko += String.format('銀行名：{0}　支店名：{1}\r\n', new List<String>{ 
                    null_to_blank(theOpp.ObosanbinRef__r.Sogisha__r.BankName__c),
                    null_to_blank(theOpp.ObosanbinRef__r.Sogisha__r.BankBranchName__c)
                });
                aRecord.cyui_jiko += String.format('口座番号：{0} {1}　口座名義：{2}\r\n', new List<String>{ 
                    null_to_blank(theOpp.ObosanbinRef__r.Sogisha__r.BankAccountType__c),
                    null_to_blank(theOpp.ObosanbinRef__r.Sogisha__r.BankAccountNo__c),
                    null_to_blank(theOpp.ObosanbinRef__r.Sogisha__r.BankAccountMeigi__c)
                });
                aRecord.cyui_jiko += '-----------------------------------------------------------\r\n';
                aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '3. 上記の金額は葬儀社様がご提示された金額になります。'; aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '当案件の弊社手配手数料は' + theTesuryo.format() + '円となります。通常の案件と併せて月締めでご請求させていただきます。\r\n';
                aRecord.cyui_jiko += '\r\n';
                aRecord.cyui_jiko += '4. ご依頼受諾後のキャンセルはご遠慮ください。僧侶様理由のキャンセルによりお客様、葬儀社様、弊社等に損害が発生した場合、担当僧侶様にご請求する場合がございます。';           
            }

        }

        return
        new OpFcReq.TemplateData()
        .setTemplateName('live_ObIraiDc_Terapass_v20201110')
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

    private Decimal null_to_zero(Decimal pValue){
        if(pValue == null) return 0;
        return pValue;
    }
    private static String null_to_blank(String pValue){
        if( pValue == null ) return '';
        return pValue;
    }
    public String format_datetime(Datetime pDatetime){
        if(pDatetime == null) return '';
        Datetime theDatetime = pDatetime;
        String theYoubi = '';
        if( theDatetime.format('E') == 'Mon' ) theYoubi = '月';
        if( theDatetime.format('E') == 'Tue' ) theYoubi = '火';
        if( theDatetime.format('E') == 'Wed' ) theYoubi = '水';
        if( theDatetime.format('E') == 'Thu' ) theYoubi = '木';
        if( theDatetime.format('E') == 'Fri' ) theYoubi = '金';
        if( theDatetime.format('E') == 'Sat' ) theYoubi = '土';
        if( theDatetime.format('E') == 'Sun' ) theYoubi = '日';

        return theDatetime.format('yyyy/M/d') + '(' + theYoubi + ')';
    }
}