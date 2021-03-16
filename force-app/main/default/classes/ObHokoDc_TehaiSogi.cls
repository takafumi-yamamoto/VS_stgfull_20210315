public class ObHokoDc_TehaiSogi implements IObHokoDc_TehaiSogi {
    
    public interface IObHokoDc_TehaiSogi {
        OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress);
    }

    public class Record{
        public String biko_01 = '';
        public String biko_02 = '';
        public String biko_03 = '';
        public String bodaiji = '';
        public String iraisha_mobile = '';
        public String iraisha_name = '';
        public String iraisha_name_kana = '';
        public String iraisha_name_label = '';
        public String iraisha_phone = '';
        public String jiin_name = '';
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
        public String shikijo_address = '';
        public String shikijo_name = '';
        public String shodan_bango = '';
        public String shonanoka_timing = '';
        public String shuha = '';
        public String soryo_address = '';
        public String soryo_name = '';
        public String soryo_tel = '';
        public String sosinsaki_address = '';
        public String tsuya_date_time = '';

        public List<String> getColumns(){
            return new List<String>{
                'biko_01',
                'biko_02',
                'biko_03',
                'bodaiji',
                'iraisha_mobile',
                'iraisha_name',
                'iraisha_name_kana',
                'iraisha_name_label',
                'iraisha_phone',
                'jiin_name',
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
                'shikijo_address',
                'shikijo_name',
                'shodan_bango',
                'shonanoka_timing',
                'shuha',
                'soryo_address',
                'soryo_name',
                'soryo_tel',
                'sosinsaki_address',
                'tsuya_date_time'
            };
        }

        public List<String> getValues(){
            return new List<String>{
                this.biko_01,
                this.biko_02,
                this.biko_03,
                this.bodaiji,
                this.iraisha_mobile,
                this.iraisha_name,
                this.iraisha_name_kana,
                this.iraisha_name_label,
                this.iraisha_phone,
                this.jiin_name,
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
                this.shikijo_address,
                this.shikijo_name,
                this.shodan_bango,
                this.shonanoka_timing,
                this.shuha,
                this.soryo_address,
                this.soryo_name,
                this.soryo_tel,
                this.sosinsaki_address,
                this.tsuya_date_time                
            };
        }
    }
    public OpFcReq.TemplateData getOpFcTemplateData(String pOppId, String pSosinsakiMethod, String pSosinsakiAddress){

        Opportunity theOpp = [
            SELECT Id, ShodanBango__c,
            Amount,
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
            ObosanbinRef__r.TehaishoKisaiJiko__c,
            ObosanbinRef__r.SekoTantoSoryoShuha__c,
            ObosanbinRef__r.SekoTantoSoryoShukyoHojinShubetsu__c,
            ObosanbinRef__r.ObosanbinKeiyakuSekotanto__c,
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
        aRecord.shodan_bango = theOpp.ShodanBango__c;

        { //送信先
            if( pSosinsakiMethod == 'fax' && !String.isBlank(pSosinsakiAddress) ){
                aRecord.sosinsaki_address = 'FAX送信先: ' + pSosinsakiAddress;
            }
        }

        Decimal theHoyoKingaku = 0;
        { //金額
            if( theOpp.RyunyumotoService__c == '定額僧侶手配代行'){
                theHoyoKingaku = theOpp.ObosanbinRef__r.TeiHehOfuseKingaku__c == null ? 0 : theOpp.ObosanbinRef__r.TeiHehOfuseKingaku__c;
            }else{
                theHoyoKingaku = theOpp.Amount == null ? 0 : theOpp.Amount;
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
                ? '有　※菩提寺へご連絡ください。'
                : theOpp.ObosanbinRef__r.BodaijinoUmu__c;
        }


        { //葬儀情報
            Boolean kaimyo_kibo = !String.isBlank(theOpp.ObosanbinRef__r.Kaimyo__c) && theOpp.ObosanbinRef__r.Kaimyo__c != '無';

            aRecord.shuha = 
                theSekoTanto != null
                ? null_to_blank(theSekoTanto.Teikeisaki__r.ShozokuSangouSangoJiin__r.SyusiSyuhaExp__c)
                : null_to_blank(theOpp.ObosanbinRef__r.SekoTantoSoryoShuha__c);

            aRecord.plan = null_to_blank(theOpp.ObosanbinRef__r.MemorialServicePlan__c);
            if( kaimyo_kibo  ){ aRecord.plan += ' ＋ 戒名'; }

            aRecord.naiyo = '';
            aRecord.naiyo += String.format('総額\\{0}で以下の項目が全て含まれます。', new List<String>{ theHoyoKingaku.format() });
            aRecord.naiyo += '\r\n';
            aRecord.naiyo += '【含まれる項目】';
            aRecord.naiyo += '\r\n';
            aRecord.naiyo += null_to_blank(theOpp.ObosanbinRef__r.MemorialContent__c);
            
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


        { //僧侶情報


            if(theSekoTanto != null){
                
                aRecord.jiin_name = null_to_blank( theSekoTanto.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name );
                if( !String.isBlank( theSekoTanto.Teikeisaki__r.ShozokuSangouSangoJiin__r.Name ) ){
                    aRecord.jiin_name += '\r\n';
                    aRecord.jiin_name += '(' + null_to_blank(theSekoTanto.SyozokusangojiinmeFurigana__c) + ')';
                }

                aRecord.soryo_name = null_to_blank( theSekoTanto.Teikeisaki__r.Name ) + ' 様';

                if( !String.isBlank( theSekoTanto.Teikeisaki__r.SeiKana__c ) ){
                    aRecord.soryo_name += '\r\n';
                    aRecord.soryo_name += ( 
                        '(' + null_to_blank( theSekoTanto.Teikeisaki__r.SeiKana__c ) + ' ' + null_to_blank( theSekoTanto.Teikeisaki__r.MeiKana__c ) + ')'
                    );
                }
                
                aRecord.soryo_tel = null_to_blank( theSekoTanto.Teikeisaki__r.YusenTelNoFormula__c );

                aRecord.soryo_address = null_to_blank( theSekoTanto.Teikeisaki__r.BillingState );

            }

            if(theSekoTanto == null){

                aRecord.jiin_name = null_to_blank( theOpp.ObosanbinRef__r.SekoTantoSoryoSangoJiinMei__c );
                if( !String.isBlank( theOpp.ObosanbinRef__r.SekoTantoSoryoSangoJiinMeiFurigana__c ) ){
                    aRecord.jiin_name += '\r\n';
                    aRecord.jiin_name += '(' + null_to_blank(theOpp.ObosanbinRef__r.SekoTantoSoryoSangoJiinMeiFurigana__c) + ')';
                }

                aRecord.soryo_name = null_to_blank( theOpp.ObosanbinRef__r.SekotantoSoryoSoryomei__c ) + ' 様';

                aRecord.soryo_tel = null_to_blank( theOpp.ObosanbinRef__r.SekoTantoSoryoSoryoRenrakusaki__c );

                aRecord.soryo_address = null_to_blank( theOpp.ObosanbinRef__r.SekoTantoSoryoSoryoKyojuchi__c );
            }
            
        }

        { //備考1
            aRecord.biko_01 = null_to_blank(theOpp.ObosanbinRef__r.TehaishoKisaiJiko__c);

            if(!String.isBlank(aRecord.biko_01)) aRecord.biko_01 += '\r\n\r\n';
            aRecord.biko_01 += '※事前にお坊さんから確認のお電話をさせて頂きます。';

            Boolean credit_barai = false;
            Boolean okimochi_atobarai = false;
            for( OkyakusamaSeikyuMeisai__c aSeikyuMeisai : theOpp.KaisyuYoteisOpportunity__r ){
                if( aSeikyuMeisai.SeikyuHouhou__c == 'NpAtoNegime') okimochi_atobarai = true;
                if( aSeikyuMeisai.SeikyuHouhou__c == 'gmo_credit') credit_barai = true;
            }

            if(credit_barai){
                if(!String.isBlank(aRecord.biko_01)) aRecord.biko_01 += '\r\n';
                aRecord.biko_01 += 'クレジットカード決済のためお坊さんへのお支払いは不要でございます。';
            }

            if(okimochi_atobarai){
                if(!String.isBlank(aRecord.biko_01)) aRecord.biko_01 += '\r\n';
                aRecord.biko_01 += '「おきもち後払い」で承っておりますのでお坊さんへのお支払いや後払い手数料は不要です。\r\n';
                aRecord.biko_01 += '葬儀から3日前後に「評価の入力画面」を携帯電話にお送りします。\r\n';
                aRecord.biko_01 += 'また、葬儀を行った月の翌月中旬頃に請求書をお送りいたしますので、請求書記載の支払期日までにお支払いください。\r\n';
                aRecord.biko_01 += '後払いのご注文には、株式会社ネットプロテクションズの提供するNP後払いサービスが適用され、\r\n';
                aRecord.biko_01 += 'サービスの範囲内で個人情報を提供し、代金債権を譲渡します。ご利用限度額は累計残高で400,000円（税込）迄です。\r\n';
                aRecord.biko_01 += '後払いについてご不明な点等ありましたら株式会社ネットプロテクションズに直接ご連絡ください。\r\n';
                aRecord.biko_01 += '電話番号：0570-077-015（土日祝日を除く9：00～18：00)';
            }
        }

        { //備考2

            String the_kibo_shuha = null_to_blank(theOpp.ObosanbinRef__r.Taishosha1Ref__r.Syuha__c);
            String the_tehai_shuha = 
                theSekoTanto == null
                ? null_to_blank(theOpp.ObosanbinRef__r.SekoTantoSoryoShuha__c)
                : null_to_blank(theSekoTanto.Teikeisaki__r.ShozokuSangouSangoJiin__r.SyusiSyuhaExp__c);
            Boolean is_tanritsu_jiin = 
                theSekoTanto == null
                ? ( theOpp.ObosanbinRef__r.SekoTantoSoryoShukyoHojinShubetsu__c == '単立' )
                : ( theSekoTanto.Teikeisaki__r.ShozokuSangouSangoJiin__r.HoujinTanniKubun__c == '単立' );

            if(the_kibo_shuha == 'こだわりなし' || String.isBlank(the_kibo_shuha)){
                aRecord.biko_02 = '';
            }else if( the_kibo_shuha == the_tehai_shuha && is_tanritsu_jiin == false ){
                aRecord.biko_02 = '';
            }else if( the_kibo_shuha == the_tehai_shuha && is_tanritsu_jiin == true ){
                aRecord.biko_02 = '手配した寺院は【' + the_tehai_shuha + ' の単立寺院】ですが、同じ流れを汲む宗派ですので、ご安心ください。';
            }else if( the_kibo_shuha != the_tehai_shuha && is_tanritsu_jiin == false ){
                aRecord.biko_02 = '手配した寺院は【' + the_tehai_shuha + ' 】ですが、同じ流れを汲む宗派ですので、ご安心ください。';
            }else if( the_kibo_shuha != the_tehai_shuha && is_tanritsu_jiin == true ){
                aRecord.biko_02 = '手配した寺院は【' + the_tehai_shuha + ' の単立寺院】ですが、同じ流れを汲む宗派ですので、ご安心ください。';
            }

            if(the_kibo_shuha != 'こだわりなし' && is_tanritsu_jiin == true){
                if(!String.isBlank(aRecord.biko_02)) aRecord.biko_02 += '\r\n';
                aRecord.biko_02 += '※単立寺院：◯◯宗という流れを汲むが、◯◯宗という宗派には属さず、独立した組織のこと。';
            }
        }

        if( !String.isBlank(aRecord.biko_02) ){ //備考1に備考2を連結
            if(!String.isBlank(aRecord.biko_01)) aRecord.biko_01 += '\r\n\r\n';
            aRecord.biko_01 += aRecord.biko_02;
            aRecord.biko_02 = '';
        }

        { //備考3

            aRecord.biko_03 += '※上部記載のお坊さんではなく、同じ寺院に所属する別のお坊さんにお勤めいただく場合もございます。予めご了承ください。\r\n';
            aRecord.biko_03 += '※予定日の前日又は当日に法要等をキャンセルした場合、キャンセル料として法要料の100％をお支払いいただきます。\r\n';
            aRecord.biko_03 += 'また、クレジットカード支払いの場合は返金いたしかねます。\r\n';
            aRecord.biko_03 += '※戒名の受領後にキャンセルした場合、キャンセル料として授与料の100%をお支払いいただきます。\r\n';
            if( !String.isBlank( theOpp.RyunyumotoService__c ) && theOpp.RyunyumotoService__c.contains('シンプル') ){
                aRecord.biko_03 += '※お手数ではございますが葬儀社様よりお客様にお伝えください。\r\n';
            }
            aRecord.biko_03 += '<免責事項>\r\n';
            aRecord.biko_03 += '当サービスで提供する情報や内容を利用することで生じた、いかなる損害及び問題に対しても、弊社では一切の責任を負いかねますのでご了承ください。\r\n';
            aRecord.biko_03 += 'また菩提寺がある方は必ず菩提寺にご相談ください。\r\n';
            aRecord.biko_03 += '相談をせずに当サービスを利用することで生じた、いかなる損害及び問題に対しても当社および手配したお坊さんは一切の責任を負いかねます。'; 
        }

        return
        new OpFcReq.TemplateData()
        .setTemplateName('live_ObHokoDc_TehaiSogi_v20201110')
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

    private static String null_to_blank(String pValue){
        if( pValue == null ) return '';
        return pValue;
    }
}