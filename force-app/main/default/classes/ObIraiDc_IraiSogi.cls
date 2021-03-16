public class ObIraiDc_IraiSogi implements IObIraiDc_IraiSogi{

    public interface IObIraiDc_IraiSogi{
        OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress);
    }

    public class Record{
        public String biko_01 = '';
        public String biko_02 = '';
        public String bodaiji = '';
        public String cyui_jiko = '';
        public String iraisha_mobile = '';
        public String iraisha_name = '';
        public String iraisha_name_kana = '';
        public String iraisha_name_label = '';
        public String iraisha_phone = '';
        public String issue_date = '';
        public String kaimyo_igo = '';
        public String kaimyo_juyo = '';
        public String kaso_date_time = '';
        public String kasoba_name = '';
        public String kojin_age = '';
        public String kojin_birth_date_w = '';
        public String kojin_death_date_w = '';
        public String kojin_death_date_w_label = '';
        public String kojin_name = '';
        public String kojin_name_kana = '';
        public String kojin_zokugara = '';
        public String kokubetsu_date_time = '';
        public String makurakyo_date_time = '';
        public String naiyo = '';
        public String plan = '';
        public String shiharai_joho_text = '';
        public String shikijo_address = '';
        public String shikijo_name = '';
        public String shodan_bango = '';
        public String shonanoka_timing = '';
        public String shuha = '';
        public String sogisha_name = '';
        public String sogisha_tanto_name = '';
        public String sogisha_tanto_tel = '';
        public String soryo_name = '';
        public String sosinsaki_address = '';
        public String tsuya_date_time = '';

        public List<String> getColumns(){
            return new List<String>{
                'biko_01',
                'biko_02',
                'bodaiji',
                'cyui_jiko',
                'iraisha_mobile',
                'iraisha_name',
                'iraisha_name_kana',
                'iraisha_name_label',
                'iraisha_phone',
                'issue_date',
                'kaimyo_igo',
                'kaimyo_juyo',
                'kaso_date_time',
                'kasoba_name',
                'kojin_age',
                'kojin_birth_date_w',
                'kojin_death_date_w',
                'kojin_death_date_w_label',
                'kojin_name',
                'kojin_name_kana',
                'kojin_zokugara',
                'kokubetsu_date_time',
                'makurakyo_date_time',
                'naiyo',
                'plan',
                'shiharai_joho_text',
                'shikijo_address',
                'shikijo_name',
                'shodan_bango',
                'shonanoka_timing',
                'shuha',
                'sogisha_name',
                'sogisha_tanto_name',
                'sogisha_tanto_tel',
                'soryo_name',
                'sosinsaki_address',
                'tsuya_date_time'                                
            };
        }

        public List<String> getValues(){
            return new List<String>{
                this.biko_01,
                this.biko_02,
                this.bodaiji,
                this.cyui_jiko,
                this.iraisha_mobile,
                this.iraisha_name,
                this.iraisha_name_kana,
                this.iraisha_name_label,
                this.iraisha_phone,
                this.issue_date,
                this.kaimyo_igo,
                this.kaimyo_juyo,
                this.kaso_date_time,
                this.kasoba_name,
                this.kojin_age,
                this.kojin_birth_date_w,
                this.kojin_death_date_w,
                this.kojin_death_date_w_label,
                this.kojin_name,
                this.kojin_name_kana,
                this.kojin_zokugara,
                this.kokubetsu_date_time,
                this.makurakyo_date_time,
                this.naiyo,
                this.plan,
                this.shiharai_joho_text,
                this.shikijo_address,
                this.shikijo_name,
                this.shodan_bango,
                this.shonanoka_timing,
                this.shuha,
                this.sogisha_name,
                this.sogisha_tanto_name,
                this.sogisha_tanto_tel,
                this.soryo_name,
                this.sosinsaki_address,
                this.tsuya_date_time                          
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
            ObosanbinRef__r.MoshuRef__c,
            ObosanbinRef__r.MoshuRef__r.LastName,
            ObosanbinRef__r.MoshuRef__r.FirstName,
            ObosanbinRef__r.MoshuRef__r.NameFurigana__c,
            ObosanbinRef__r.MoshuRef__r.MobilePhone__c,
            ObosanbinRef__r.MoshuRef__r.Phone,
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
            ObosanbinRef__r.ZokugaraMoshuNitottenoTaishosha1__c,
            ObosanbinRef__r.MemorialServicePlan__c,
            ObosanbinRef__r.MemorialContent__c,
            ObosanbinRef__r.Kaimyo__c,
            ObosanbinRef__r.Makurakyo__c,
            ObosanbinRef__r.TsuyaDateTime_Inp__c,
            ObosanbinRef__r.KokubetsushikiNichiji__c,
            ObosanbinRef__r.KasoDateTime_Inp__c,
            ObosanbinRef__r.Shonanoka__c,
            ObosanbinRef__r.Kasoba__c,
            ObosanbinRef__r.Saijo__c,
            ObosanbinRef__r.sogi_todofuken__c,
            ObosanbinRef__r.sogi_shikugun__c,
            ObosanbinRef__r.sogi_tyoumei__c,
            ObosanbinRef__r.sogi_banchi__c,
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

        Boolean moshu_is_iraisha = false; 
        { //依頼者情報
            if( theOpp.ObosanbinRef__r.MoshuRef__c != null ){
                moshu_is_iraisha = true;
                aRecord.iraisha_name_label = '喪主名';
                aRecord.iraisha_name_kana = null_to_blank(theOpp.ObosanbinRef__r.MoshuRef__r.NameFurigana__c);
                aRecord.iraisha_name = null_to_blank(theOpp.ObosanbinRef__r.MoshuRef__r.LastName) + null_to_blank(theOpp.ObosanbinRef__r.MoshuRef__r.FirstName) + ' 様';
                aRecord.iraisha_phone = null_to_blank(theOpp.ObosanbinRef__r.MoshuRef__r.Phone);
                aRecord.iraisha_mobile = null_to_blank(theOpp.ObosanbinRef__r.MoshuRef__r.MobilePhone__c);
            }else{
                moshu_is_iraisha = false;
                aRecord.iraisha_name_label = '依頼者名';
                aRecord.iraisha_name_kana = null_to_blank(theOpp.Account.NameFurigana__c);
                aRecord.iraisha_name = null_to_blank(theOpp.Account.LastName) + null_to_blank(theOpp.Account.FirstName) + ' 様';
                aRecord.iraisha_phone = null_to_blank(theOpp.Account.Phone);
                aRecord.iraisha_mobile = null_to_blank(theOpp.Account.MobilePhone__c);
            }

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
                
                aRecord.kojin_zokugara = 
                    moshu_is_iraisha
                    ? null_to_blank(theOpp.ObosanbinRef__r.ZokugaraMoshuNitottenoTaishosha1__c)
                    : null_to_blank(theOpp.ObosanbinRef__r.ZokugaraSodanshaNitottenoTaishosha1__c);
            }

            aRecord.bodaiji =
                theOpp.ObosanbinRef__r.BodaijinoUmu__c == '有'
                ? '有　※菩提寺から許可を得ています。'
                : theOpp.ObosanbinRef__r.BodaijinoUmu__c;
        }


        { //葬儀情報
            Boolean kaimyo_kibo = !String.isBlank(theOpp.ObosanbinRef__r.Kaimyo__c) && theOpp.ObosanbinRef__r.Kaimyo__c != '無';

            aRecord.shuha = null_to_blank(theOpp.ObosanbinRef__r.Taishosha1Ref__r.Syuha__c);

            aRecord.plan = null_to_blank(theOpp.ObosanbinRef__r.MemorialServicePlan__c);
            if( kaimyo_kibo  ){ aRecord.plan += ' ＋ 戒名'; }

            aRecord.naiyo = null_to_blank(theOpp.ObosanbinRef__r.MemorialContent__c);
            
            aRecord.kaimyo_juyo = kaimyo_kibo
                ? '戒名授与を希望する'
                : '戒名授与を希望しない';

            aRecord.kaimyo_igo = 
                String.isBlank(theOpp.ObosanbinRef__r.Kaimyo__c)
                ? '―'
                : null_to_blank(theOpp.ObosanbinRef__r.Kaimyo__c);

            aRecord.makurakyo_date_time = 
                theOpp.ObosanbinRef__r.Makurakyo__c == null 
                ? '無' 
                : theOpp.ObosanbinRef__r.Makurakyo__c.format('yyyy/M/d HH:mm');

            aRecord.tsuya_date_time = 
                theOpp.ObosanbinRef__r.TsuyaDateTime_Inp__c == null 
                ? '無' 
                : theOpp.ObosanbinRef__r.TsuyaDateTime_Inp__c.format('yyyy/M/d HH:mm');

            aRecord.kokubetsu_date_time = 
                ( theOpp.ObosanbinRef__r.KokubetsushikiNichiji__c == null || theOpp.ObosanbinRef__r.MemorialServicePlan__c == '火葬式' )
                ? '無' 
                : theOpp.ObosanbinRef__r.KokubetsushikiNichiji__c.format('yyyy/M/d HH:mm');
            
            aRecord.kaso_date_time = 
                theOpp.ObosanbinRef__r.KasoDateTime_Inp__c == null
                ? '無' 
                : theOpp.ObosanbinRef__r.KasoDateTime_Inp__c.format('yyyy/M/d HH:mm');
            
            aRecord.shonanoka_timing = 
                String.isBlank( theOpp.ObosanbinRef__r.Shonanoka__c )
                ? '無'
                : theOpp.ObosanbinRef__r.Shonanoka__c;
            
            aRecord.kasoba_name = null_to_blank( theOpp.ObosanbinRef__r.Kasoba__c );

            aRecord.shikijo_name = null_to_blank( theOpp.ObosanbinRef__r.Saijo__c );
            
            aRecord.shikijo_address = 
                null_to_blank(theOpp.ObosanbinRef__r.sogi_todofuken__c) + 
                null_to_blank(theOpp.ObosanbinRef__r.sogi_shikugun__c) + 
                null_to_blank(theOpp.ObosanbinRef__r.sogi_tyoumei__c) + 
                null_to_blank(theOpp.ObosanbinRef__r.sogi_banchi__c);
        }


        { //葬儀社情報
            aRecord.sogisha_name = 
                String.isBlank( theOpp.ObosanbinRef__r.Sogisha__r.Name )
                ? null_to_blank(theOpp.ObosanbinRef__r.SonotaSogisha__c)
                : null_to_blank(theOpp.ObosanbinRef__r.Sogisha__r.Name);
            
            aRecord.sogisha_tanto_name = null_to_blank( theOpp.ObosanbinRef__r.SogiTantosha__c );
            aRecord.sogisha_tanto_tel = null_to_blank( theOpp.ObosanbinRef__r.SogiTantoshaTel__c );
        }

        { //備考1
            aRecord.biko_01 = '';

            Boolean is_tehai_daiko = 
                new List<String>{ '僧侶手配代行','僧侶手配代行-リピート','僧侶手配代行-リピート(3回目)','僧侶手配代行-リピート(4回目)','定額僧侶手配代行' }
                .contains(theOpp.RyunyumotoService__c);

            if( is_tehai_daiko ){
                aRecord.biko_01 += '※葬儀社からの依頼のため、お坊さん便の名前は出さないようにお願いします。';
            }

            if( !String.isBlank( theOpp.ObosanbinRef__r.IraishoKisaiJiko__c ) ){
                if( !String.isBlank(aRecord.biko_01) ) aRecord.biko_01 += '\r\n\r\n';
                aRecord.biko_01 += theOpp.ObosanbinRef__r.IraishoKisaiJiko__c;
            }

            if( !String.isBlank(aRecord.biko_01) ) aRecord.biko_01 += '\r\n\r\n';
            aRecord.biko_01 += '※現地には施行30分～40分前にお入りください。到着の際、弊社までご連絡ください。\r\n';
            aRecord.biko_01 += '【葬儀社様へご連絡の際は以下をご確認ください】\r\n';
            aRecord.biko_01 += '① 白木位牌が葬儀社にて用意されるかどうか \r\n';
            aRecord.biko_01 += '② 待ち合わせ場所、時間などの詳細情報';
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
                aRecord.shiharai_joho_text += '総額は【' + theHoyoKingaku.format() + '】円となります。\r\n';
                aRecord.shiharai_joho_text += '事前に当社で法要料をお預かりさせていただいているため葬儀当日に依頼者様から法要料をいただかないでください。\r\n';
                aRecord.shiharai_joho_text += String.format(
                    '施行日を起算日として、末締めにて翌月末までに{0} {1}様ご指定の口座に当社規定の手数料を除いた{2}】円をお振込みいたします。', 
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
                    aRecord.shiharai_joho_text += '総額：' + theHoyoKingaku.format() + '\r\n';
                    aRecord.shiharai_joho_text += '手数料：' + theTesuryo.format();
                }else{
                    aRecord.shiharai_joho_text += '総額：' + theHoyoKingaku.format();
                }
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

        { //注意事項
            aRecord.cyui_jiko = '';
            aRecord.cyui_jiko += '1. 助法者にお勤めいただく場合、お勤めいただく方を必ず弊社へご報告ください。\r\n';
            aRecord.cyui_jiko += '2. 本依頼書が到着しましたら、ご依頼者様にご挨拶の連絡を忘れずにお願いいたします。\r\n';
            aRecord.cyui_jiko += '依頼後、お坊さんから連絡がなく、不安が募るケースが多々あります。\r\n';
            aRecord.cyui_jiko += 'また、お手数ではございますが、葬儀社への連絡、打合せ等も併せてお願いいたします。\r\n';

            Boolean is_shiharai = false;
            for( OkyakusamaSeikyuMeisai__c aSeikyuMeisai : theOpp.KaisyuYoteisOpportunity__r ){
                if( aSeikyuMeisai.SeikyuHouhou__c == 'NpAtoNegime') is_shiharai = true;
                if( aSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit') is_shiharai = true;
                if( aSeikyuMeisai.SeikyuHouhou__c == 'sousai') is_shiharai = true;
            }
            if(is_shiharai){
                aRecord.cyui_jiko += '3. 法要料金のお支払いは完了しております。当日、依頼者より法要料金は絶対に受け取らないでください。';
            }else{
                aRecord.cyui_jiko += '3. 手数料の支払いが遅れると今後のご依頼を控えさせていただくことがありますので、ご注意ください。\r\n';
                aRecord.cyui_jiko += 'なお、やむを得ない事情により支払いが遅れてしまう場合はあらかじめ当社へその旨、お伝えください。';
            }
        }

        return
        new OpFcReq.TemplateData()
        .setTemplateName('live_ObIraiDc_IraiSogi_v20201110')
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