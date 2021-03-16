public class ObIraiDc_IraiKaimyo implements IObIraiDc_IraiKaimyo{

    public interface IObIraiDc_IraiKaimyo {
        OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress);
    }
    
    public class Record{
        public String biko_01 = '';
        public String biko_02 = '';
        public String bodaiji = '';
        public String cyui_jiko = '';
        public String iraisha_addr = '';
        public String iraisha_mobile = '';
        public String iraisha_name = '';
        public String iraisha_name_kana = '';
        public String iraisha_phone = '';
        public String issue_date = '';
        public String kaimyo_igo = '';
        public String kojin_age = '';
        public String kojin_birth_date_w = '';
        public String kojin_death_date_w = '';
        public String kojin_death_date_w_label = '';
        public String kojin_name = '';
        public String kojin_name_kana = '';
        public String kojin_zokugara = '';
        public String naiyo = '';
        public String plan = '';
        public String shiharai_joho_text = '';
        public String shodan_bango = '';
        public String shuha = '';
        public String soryo_name = '';
        public String sosinsaki_address = '';
        

        public List<String> getColumns(){
            return new List<String>{
                'biko_01',
                'biko_02',
                'bodaiji',
                'cyui_jiko',
                'iraisha_addr',
                'iraisha_mobile',
                'iraisha_name',
                'iraisha_name_kana',
                'iraisha_phone',
                'issue_date',
                'kaimyo_igo',
                'kojin_age',
                'kojin_birth_date_w',
                'kojin_death_date_w',
                'kojin_death_date_w_label',
                'kojin_name',
                'kojin_name_kana',
                'kojin_zokugara',
                'naiyo',
                'plan',
                'shiharai_joho_text',
                'shodan_bango',
                'shuha',
                'soryo_name',
                'sosinsaki_address'               
            };
        }

        public List<String> getValues(){
            return new List<String>{
                this.biko_01,
                this.biko_02,
                this.bodaiji,
                this.cyui_jiko,
                this.iraisha_addr,
                this.iraisha_mobile,
                this.iraisha_name,
                this.iraisha_name_kana,
                this.iraisha_phone,
                this.issue_date,
                this.kaimyo_igo,
                this.kojin_age,
                this.kojin_birth_date_w,
                this.kojin_death_date_w,
                this.kojin_death_date_w_label,
                this.kojin_name,
                this.kojin_name_kana,
                this.kojin_zokugara,
                this.naiyo,
                this.plan,
                this.shiharai_joho_text,
                this.shodan_bango,
                this.shuha,
                this.soryo_name,
                this.sosinsaki_address                              
            };
        }
    }

    public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){

        Opportunity theOpp = [
            SELECT Id, ShodanBango__c,
            Amount,
            PartnerSeikyuGakuExp__c, PartnerSiharaiGakuExp__c,
            RyunyumotoService__c,
            Account.Id,
            Account.LastName, 
            Account.FirstName,
            Account.NameFurigana__c,
            Account.MobilePhone__c, 
            Account.Phone,
            Account.BillingPostalCode,
            Account.BillingState,
            Account.BillingCity,
            Account.BillingStreet,
            ObosanbinRef__r.IsTokuteiTaishoshaNashi__c,
            ObosanbinRef__r.Taishosha1Ref__r.NameFurigana__c,
            ObosanbinRef__r.Taishosha1Ref__r.LastName,
            ObosanbinRef__r.Taishosha1Ref__r.FirstName,
            ObosanbinRef__r.Taishosha1Ref__r.SeinengappiWareki__c,
            ObosanbinRef__r.Taishosha1Ref__r.BotsunengappiWareki__c,
            ObosanbinRef__r.Taishosha1Ref__r.Age__pc,
            ObosanbinRef__r.Taishosha1Ref__r.Syuha__c,
            ObosanbinRef__r.BodaijinoUmu__c,
            ObosanbinRef__r.ZokugaraSodanshaNitottenoTaishosha1__c,
            ObosanbinRef__r.MemorialServicePlan__c,
            ObosanbinRef__r.MemorialContent__c,
            ObosanbinRef__r.Kaimyo__c,
            ObosanbinRef__r.SekoTantoSoryoSangoJiinMeiFurigana__c,
            ObosanbinRef__r.SekoTantoSoryoSangoJiinMei__c,
            ObosanbinRef__r.SekotantoSoryoSoryomei__c,
            ObosanbinRef__r.SekoTantoSoryoSoryoRenrakusaki__c,
            ObosanbinRef__r.SekoTantoSoryoSoryoKyojuchi__c,
            ObosanbinRef__r.IraishoKisaiJiko__c,
            ObosanbinRef__r.SekoTantoSoryoShuha__c,
            ObosanbinRef__r.SekoTantoSoryoShukyoHojinShubetsu__c,
            ObosanbinRef__r.ObosanbinKeiyakuSekotanto__c,
            ObosanbinRef__r.Sogisha__r.Name,
            ObosanbinRef__r.SonotaSogisha__c,
            ObosanbinRef__r.SogiTantosha__c,
            ObosanbinRef__r.SogiTantoshaTel__c,
            ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c,
            ObosanbinRef__r.TeiHehOfuseKingaku__c,
            (
                SELECT Id,
                SeikyuHouhou__c
                FROM KaisyuYoteisOpportunity__r
            )
            FROM Opportunity WHERE Id = :pOppId
            LIMIT 1
        ].get(0);

        Keiyaku__c theSekoTanto = (Keiyaku__c)SobjectsExtension.firstOrNull(
            [
                SELECT Id,
                SyozokusangojiinmeFurigana__c,
                Teikeisaki__r.ShozokuSangouSangoJiin__r.Name,
                Teikeisaki__r.Name,
                Teikeisaki__r.SeiKana__c,
                Teikeisaki__r.MeiKana__c,
                Teikeisaki__r.YusenTelNoFormula__c,
                Teikeisaki__r.BillingState,
                Teikeisaki__r.ShozokuSangouSangoJiin__r.SyusiSyuhaExp__c,
                Teikeisaki__r.ShozokuSangouSangoJiin__r.HoujinTanniKubun__c
                FROM Keiyaku__c
                WHERE Id = :theOpp.ObosanbinRef__r.ObosanbinKeiyakuSekotanto__c
                LIMIT 1
            ]
        );

        Record aRecord = new Record();
        aRecord.issue_date = Datetime.now().format('yyyy年M月d日');
        aRecord.shodan_bango = theOpp.ShodanBango__c;

        { //送信先
            if( pSosinsakiMethod == 'fax' && !String.isBlank(pSosinsakiAddress) ){
                aRecord.sosinsaki_address = 'FAX送信先: ' + pSosinsakiAddress;
            }
        }
        
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

        { //僧侶情報

            if(theSekoTanto != null){
                aRecord.soryo_name = 
                    null_to_blank( theSekoTanto.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name ) 
                    + '\r\n'
                    + null_to_blank( theSekoTanto.Teikeisaki__r.Name ) + ' 様';
            }
            if(theSekoTanto == null){
                aRecord.soryo_name =
                    null_to_blank( theOpp.ObosanbinRef__r.SekoTantoSoryoSangoJiinMei__c )
                    + '\r\n'
                    + null_to_blank(theOpp.ObosanbinRef__r.SekotantoSoryoSoryomei__c) + ' 様';
            }
            
        }

        { //依頼者情報
            aRecord.iraisha_name_kana = null_to_blank(theOpp.Account.NameFurigana__c);
            aRecord.iraisha_name = null_to_blank(theOpp.Account.LastName) + null_to_blank(theOpp.Account.FirstName) + ' 様';
            aRecord.iraisha_phone = null_to_blank(theOpp.Account.Phone);
            aRecord.iraisha_mobile = null_to_blank(theOpp.Account.MobilePhone__c);
            aRecord.iraisha_addr = '';
            aRecord.iraisha_addr += String.isBlank(theOpp.Account.BillingPostalCode) ? '' : theOpp.Account.BillingPostalCode + ' ';
            aRecord.iraisha_addr += null_to_blank(theOpp.Account.BillingState);
            aRecord.iraisha_addr += null_to_blank(theOpp.Account.BillingCity);
            aRecord.iraisha_addr += null_to_blank(theOpp.Account.BillingStreet);
        }

        { //故人情報
            if(theOpp.ObosanbinRef__r.IsTokuteiTaishoshaNashi__c){
                aRecord.kojin_name_kana = '―';
                aRecord.kojin_name = '―';
                aRecord.kojin_birth_date_w = '―';
                aRecord.kojin_death_date_w = '―';
                aRecord.kojin_death_date_w_label = '―';
                aRecord.kojin_age = '―';
                aRecord.kojin_zokugara = '―';
            }else{
                aRecord.kojin_name_kana = null_to_blank(theOpp.ObosanbinRef__r.Taishosha1Ref__r.NameFurigana__c);
                aRecord.kojin_name = null_to_blank(theOpp.ObosanbinRef__r.Taishosha1Ref__r.LastName) + null_to_blank(theOpp.ObosanbinRef__r.Taishosha1Ref__r.FirstName) + ' 様';
                aRecord.kojin_birth_date_w = 
                    null_to_blank( Gannens.toGannen(theOpp.ObosanbinRef__r.Taishosha1Ref__r.SeinengappiWareki__c) );

                if( String.isBlank( theOpp.ObosanbinRef__r.Taishosha1Ref__r.BotsunengappiWareki__c) ){
                    aRecord.kojin_death_date_w_label = '―';
                    aRecord.kojin_death_date_w = '―';
                }else{
                    aRecord.kojin_death_date_w_label = '没年月日';
                    aRecord.kojin_death_date_w = null_to_blank( Gannens.toGannen(theOpp.ObosanbinRef__r.Taishosha1Ref__r.BotsunengappiWareki__c) );
                }

                aRecord.kojin_age = 
                    theOpp.ObosanbinRef__r.Taishosha1Ref__r.Age__pc == null 
                    ? ''
                    : String.valueOf( theOpp.ObosanbinRef__r.Taishosha1Ref__r.Age__pc );
                aRecord.kojin_zokugara = null_to_blank(theOpp.ObosanbinRef__r.ZokugaraSodanshaNitottenoTaishosha1__c);
            }

            aRecord.bodaiji =
                theOpp.ObosanbinRef__r.BodaijinoUmu__c == '有'
                ? '有　※菩提寺から許可を得ています。'
                : theOpp.ObosanbinRef__r.BodaijinoUmu__c;
        }

        { //依頼内容
            aRecord.shuha = null_to_blank(theOpp.ObosanbinRef__r.Taishosha1Ref__r.Syuha__c);

            aRecord.plan = '戒名の授与';

            aRecord.naiyo = null_to_blank(theOpp.ObosanbinRef__r.MemorialContent__c);

            aRecord.kaimyo_igo = 
                String.isBlank(theOpp.ObosanbinRef__r.Kaimyo__c)
                ? '―'
                : null_to_blank(theOpp.ObosanbinRef__r.Kaimyo__c);
        }

        { //備考1
            aRecord.biko_01 = '';

            Boolean is_tehai_daiko = 
                new List<String>{ '僧侶手配代行','僧侶手配代行-リピート','僧侶手配代行-リピート(3回目)','僧侶手配代行-リピート(4回目)','定額僧侶手配代行' }
                .contains(theOpp.RyunyumotoService__c);

            if( is_tehai_daiko ){
                aRecord.biko_01 += '※葬儀社からの依頼のため、お坊さん便の名前は出さないようにお願いします。';
            }

            String theSogishaName =
                String.isBlank( theOpp.ObosanbinRef__r.Sogisha__r.Name )
                ? null_to_blank(theOpp.ObosanbinRef__r.SonotaSogisha__c)
                : null_to_blank(theOpp.ObosanbinRef__r.Sogisha__r.Name); 
            if( !String.isBlank( theSogishaName ) ){
                if( !String.isBlank(aRecord.biko_01) ) aRecord.biko_01 += '\r\n\r\n';
                aRecord.biko_01 += '担当葬儀社名:' + null_to_blank(theSogishaName);
                if( !String.isBlank( theOpp.ObosanbinRef__r.SogiTantosha__c ) ){
                    aRecord.biko_01 += '\r\n担当者名:' + null_to_blank(theOpp.ObosanbinRef__r.SogiTantosha__c);
                }
                if( !String.isBlank( theOpp.ObosanbinRef__r.SogiTantoshaTel__c ) ){
                    aRecord.biko_01 += '\r\n葬儀担当者TEL:' + null_to_blank(theOpp.ObosanbinRef__r.SogiTantoshaTel__c);
                }
            }

            if( !String.isBlank( theOpp.ObosanbinRef__r.IraishoKisaiJiko__c ) ){
                if( !String.isBlank(aRecord.biko_01) ) aRecord.biko_01 += '\r\n\r\n';
                aRecord.biko_01 += theOpp.ObosanbinRef__r.IraishoKisaiJiko__c;
            }
        }

        { //備考2
            aRecord.biko_02 = '';
            Boolean is_sogisha_irai = false;
            if( !String.isBlank(theOpp.RyunyumotoService__c) && theOpp.RyunyumotoService__c == '葬儀レビ' ) is_sogisha_irai = true;
            if( !String.isBlank(theOpp.RyunyumotoService__c) && theOpp.RyunyumotoService__c == 'シンプルなお葬式' ) is_sogisha_irai = true;
            if( !String.isBlank(theOpp.RyunyumotoService__c) && theOpp.RyunyumotoService__c.contains('手配代行') ) is_sogisha_irai = true;
            if(is_sogisha_irai){
                aRecord.biko_02 += '弊社サービス（シンプルなお葬式,葬儀レビ,葬儀社あるいは石材店）からの依頼です。';
            }
        }

        { //支払情報
            aRecord.shiharai_joho_text = '';

            Boolean is_shiharai = false;
            for( OkyakusamaSeikyuMeisai__c aSeikyuMeisai : theOpp.KaisyuYoteisOpportunity__r ){
                if( aSeikyuMeisai.SeikyuHouhou__c == 'NpAtoNegime') is_shiharai = true;
                if( aSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit') is_shiharai = true;
                if( aSeikyuMeisai.SeikyuHouhou__c == 'sousai') is_shiharai = true;
            }

            if(is_shiharai){
                aRecord.shiharai_joho_text += '授与料は【' + theHoyoKingaku.format() + '】円となります。\r\n';
                aRecord.shiharai_joho_text += '事前に当社で授与料をお預かりさせていただいているため依頼者へ請求しないでください。\r\n';
                aRecord.shiharai_joho_text += String.format(
                    '本書面の送付日から8日後を起算日として、末締めにて翌月末までに{0} {1}様ご指定の口座に当社規定の手数料を除いた{2}】円をお振込みいたします。', 
                    new List<String>{
                        theSekoTanto == null ? null_to_blank(theOpp.ObosanbinRef__r.SekoTantoSoryoSangoJiinMei__c) : null_to_blank(theSekoTanto.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name),
                        theSekoTanto == null ? null_to_blank(theOpp.ObosanbinRef__r.SekotantoSoryoSoryomei__c) : null_to_blank(theSekoTanto.Teikeisaki__r.Name),
                        (theHoyoKingaku - theTesuryo).format()
                    }
                );
            }
            if(!is_shiharai){
                if( theOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c == '自社手配' ){
                    aRecord.shiharai_joho_text += '別途、月末締めで請求書を送付させていただきますので、　以下手数料を、請求書記載の口座にお振込みください。\r\n';
                    aRecord.shiharai_joho_text += '法要額：' + theHoyoKingaku.format() + '\r\n';
                    aRecord.shiharai_joho_text += '手数料：' + theTesuryo.format();
                }else{
                    aRecord.shiharai_joho_text += '法要額：' + theHoyoKingaku.format();
                }
            }
        }

        { //注意事項
            Boolean is_shiharai = false;
            for( OkyakusamaSeikyuMeisai__c aSeikyuMeisai : theOpp.KaisyuYoteisOpportunity__r ){
                if( aSeikyuMeisai.SeikyuHouhou__c == 'NpAtoNegime') is_shiharai = true;
                if( aSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit') is_shiharai = true;
                if( aSeikyuMeisai.SeikyuHouhou__c == 'sousai') is_shiharai = true;
            }
            if(is_shiharai){
                aRecord.cyui_jiko += '1. 授与料のお支払いは完了しております。依頼者より授与料は絶対に受け取らないでください。\r\n';
            }else{
                aRecord.cyui_jiko += '1. 必ずご依頼者様から料金をいただいた後に、戒名授与を行ってください。\r\n';
                aRecord.cyui_jiko += '先に戒名授与を行ってしまうと法要料金をいただけなくなるリスクが高くなりますので、ご注意ください。\r\n';
            }
            aRecord.cyui_jiko += '2. 戒名/法名授与は必ず郵送にてご対応ください。FAXやメールのみでの授与は禁止させていただきます。\r\n';
        }

        return
        new OpFcReq.TemplateData()
        .setTemplateName('live_ObIraiDc_IraiKaimyo_v20201110')
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

}