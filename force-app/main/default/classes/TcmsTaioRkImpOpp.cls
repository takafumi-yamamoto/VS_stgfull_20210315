public class TcmsTaioRkImpOpp {

    public static IKanryoShubetsus get_IKanryoShubetsus_instance(){ return new KanryoShubetsus(); }
    public static IOppCreator get_IOppCreator_instance(){ 
        return new OppCreator( 
            AcntCustRslvr.get_IAccountRelver_instance(), 
            new Todays.Today(),
            new KanryoShubetsuMapper(),
            new KanryoShubetsus()
        ); 
    }

    public interface IOppCreator{
        String createOpp(TcmsTaioRkImpData__c pTcmsTaioRkImpData);
    }
    public class OppCreator implements IOppCreator{

        private AcntCustRslvr.IAccountRelver m_IAccountRelver;
        private Todays.IToday m_IToday;
        private IKanryoShubetsuMapper m_IKanryoShubetsuMapper;
        private IKanryoShubetsus m_IKanryoShubetsus;

        public OppCreator(
            AcntCustRslvr.IAccountRelver p_IAccountRelver,
            Todays.IToday p_IToday,
            IKanryoShubetsuMapper p_IKanryoShubetsuMapper,
            IKanryoShubetsus p_IKanryoShubetsus
        ){
            this.m_IAccountRelver = p_IAccountRelver;
            this.m_IToday = p_IToday;
            this.m_IKanryoShubetsuMapper = p_IKanryoShubetsuMapper;
            this.m_IKanryoShubetsus = p_IKanryoShubetsus;
        }

        public String createOpp(TcmsTaioRkImpData__c pTcmsTaioRkImpData){
            if( !this.m_IKanryoShubetsus.get_Kanryo_Shubetsu_to_create_opps().contains(pTcmsTaioRkImpData.Kanryo_Shubetsu__c) ){
                return null;
            }
            
            String theOppId = this.insertOpp(pTcmsTaioRkImpData);
            this.updateOpp(pTcmsTaioRkImpData, theOppId);
            return theOppId;
        }

        public String insertOpp(TcmsTaioRkImpData__c pTcmsTaioRkImpData){
    
                String the_Name_Sei = pTcmsTaioRkImpData.Sodansha_Sei__c; 
                if( String.isBlank(the_Name_Sei) ){
                    the_Name_Sei = pTcmsTaioRkImpData.Sodansha_Sei_Kana__c;
                }
                if( String.isBlank(the_Name_Sei) ){
                    throw new InvalidValueException('取引先名なし');
                }

                AcntCustRslvr.Result theAccountRelver_Result = this.m_IAccountRelver.try_insert(
                    new AcntCustRslvr.Req()
                    .set_last_name( the_Name_Sei)
                    .set_first_name( pTcmsTaioRkImpData.Sodansha_Mei__c )
                    .set_last_name_kana( pTcmsTaioRkImpData.Sodansha_Sei_Kana__c )
                    .set_first_name_kana( pTcmsTaioRkImpData.Sodansha_Mei_Kana__c )
                    .set_phone( String.isBlank(pTcmsTaioRkImpData.Sodansha_Phone__c) ? null : pTcmsTaioRkImpData.Sodansha_Phone__c.replace('#','') )
                    .set_mobile( String.isBlank(pTcmsTaioRkImpData.Sodansha_Mobile__c) ? null : pTcmsTaioRkImpData.Sodansha_Mobile__c.replace('#','') )
                    .set_postal_code( String.isBlank(pTcmsTaioRkImpData.Sodansha_Addr_ZipCode__c) ? null : pTcmsTaioRkImpData.Sodansha_Addr_ZipCode__c.replace('#','') )
                    .set_state( pTcmsTaioRkImpData.Sodansha_Addr_State__c )
                    .set_city( pTcmsTaioRkImpData.Sodansha_Addr_City__c )
                    .set_street( 
                        ( String.isBlank(pTcmsTaioRkImpData.Sodansha_Addr_Street__c) ? '' : pTcmsTaioRkImpData.Sodansha_Addr_Street__c )
                        + 
                        ( String.isBlank(pTcmsTaioRkImpData.Sodansha_Addr_Room__c) ? '' : ' ' + pTcmsTaioRkImpData.Sodansha_Addr_Room__c)
                    )
                );

                AccDml.updates(
                    new List<Account>{ 
                        new Account(Id = theAccountRelver_Result.account_id, Tcms_SmsPermission__c = pTcmsTaioRkImpData.SmsPermission__c) 
                    },
                    true
                );

                String theOppNameLabel = 'Tcms:' + pTcmsTaioRkImpData.TcmsSeqNo__c;

                String theOppName = 
                    ( String.isBlank(the_Name_Sei) ? '' : the_Name_Sei )
                    +
                    ( String.isBlank(pTcmsTaioRkImpData.Sodansha_Mei__c) ? '' : pTcmsTaioRkImpData.Sodansha_Mei__c )
                    + '_シンプル安豪'
                    + ' '
                    + theOppNameLabel;


                Opportunity the_Opportunity_toBeInserted = new Opportunity(
                    RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                    Name = theOppName,
                    OppNameLabel__c = theOppNameLabel,
                    AccountId = theAccountRelver_Result.account_id,
                    StageName = 'フォロー',
                    Req_Day__c = this.parseDatetime(pTcmsTaioRkImpData.ToiawaseDt__c),
                    CloseDate = this.m_IToday.Date()
                );
                INSERT the_Opportunity_toBeInserted;
    
                return the_Opportunity_toBeInserted.Id;
        }

        public void updateOpp(TcmsTaioRkImpData__c pTcmsTaioRkImpData, String pOppId){

           
            Opportunity aOpp = [SELECT Id, SimpleYasugoRef__c FROM Opportunity WHERE Id = :pOppId LIMIT 1].get(0);
            SimpleYasugo__c aSimpleyasugo = new SimpleYasugo__c(Id = aOpp.SimpleYasugoRef__c);

            aOpp.JudenItakuSaki__c = 'トランスコスモス';

            if( String.isBlank(pTcmsTaioRkImpData.SiryoKibo__c) ){ aSimpleyasugo.YusoYohiShubetsu__c = null; }
            else if(pTcmsTaioRkImpData.SiryoKibo__c == 'はい'){ aSimpleyasugo.YusoYohiShubetsu__c = '通常'; }
            else if(pTcmsTaioRkImpData.SiryoKibo__c == 'いいえ'){ aSimpleyasugo.YusoYohiShubetsu__c = '不要'; }
            else { throw new InvalidValueException(); }
            
            aOpp.TaishoushaJokyo__c = String.isBlank(pTcmsTaioRkImpData.Taishosha_Joutai__c) ? '未聴取により不明' : pTcmsTaioRkImpData.Taishosha_Joutai__c;

            aSimpleyasugo.KiboAreaRef__r = String.isBlank(pTcmsTaioRkImpData.SogiKiboAreaCode__c) ? null : new Shikugun__c(AreaCode__c = pTcmsTaioRkImpData.SogiKiboAreaCode__c);

            if( String.isBlank(pTcmsTaioRkImpData.SogiType1__c) ){ aSimpleyasugo.SogiPlanUketsuke__c = null; }
            else if( pTcmsTaioRkImpData.SogiType1__c == '直葬' && pTcmsTaioRkImpData.SogiType2__c == '仏式'){ 
                aSimpleyasugo.SogiPlanUketsuke__c = '【21.04】よりそう火葬式 仏具セットプラン'; 
            }
            else if( pTcmsTaioRkImpData.SogiType1__c == '直葬'){ 
                aSimpleyasugo.SogiPlanUketsuke__c = '【21.04】よりそう火葬式 シンプルプラン'; 
            }
            else if( pTcmsTaioRkImpData.SogiType1__c == '火葬式' && pTcmsTaioRkImpData.SogiType2__c == '仏式'){ 
                aSimpleyasugo.SogiPlanUketsuke__c = '【21.04】よりそう火葬式 仏具セットプラン'; 
            }
            else if( pTcmsTaioRkImpData.SogiType1__c == '火葬式'){ 
                aSimpleyasugo.SogiPlanUketsuke__c = '【21.04】よりそう火葬式 基本プラン'; 
            }
            else if( pTcmsTaioRkImpData.SogiType1__c == '一日葬' ){ aSimpleyasugo.SogiPlanUketsuke__c = '【21.04】よりそう家族葬 一日プラン'; }
            else if( pTcmsTaioRkImpData.SogiType1__c == '家族葬' ){ aSimpleyasugo.SogiPlanUketsuke__c = '【21.04】よりそう家族葬 二日プラン'; }
            else if( pTcmsTaioRkImpData.SogiType1__c == '一般葬' ){ aSimpleyasugo.SogiPlanUketsuke__c = '【21.04】よりそう家族葬 華やかプラン'; }
            else { throw new InvalidValueException(); }

            if(String.isBlank(pTcmsTaioRkImpData.SogiType2__c)){ aSimpleyasugo.ButsuguNashiKibo__c = null; }
            else if( pTcmsTaioRkImpData.SogiType2__c == '無宗教' ){ aSimpleyasugo.ButsuguNashiKibo__c = '仏具なし'; }
            else if( pTcmsTaioRkImpData.SogiType2__c == '仏式' ){ aSimpleyasugo.ButsuguNashiKibo__c = '仏具あり'; }
            else { throw new InvalidValueException(); }
            
            if(String.isBlank(pTcmsTaioRkImpData.SoryoTehaiUmu__c)){ aSimpleyasugo.MonkArrangements__c = null; }
            else { aSimpleyasugo.MonkArrangements__c = pTcmsTaioRkImpData.SoryoTehaiUmu__c; }

            if(String.isBlank(pTcmsTaioRkImpData.AnchiSaki__c)){ aSimpleyasugo.KiboGoanchisaki__c = null; }
            else { aSimpleyasugo.KiboGoanchisaki__c = pTcmsTaioRkImpData.AnchiSaki__c; }

            if(String.isBlank(pTcmsTaioRkImpData.Taishosha_Zokugara_From_Sodansha__c)){ aSimpleyasugo.ZokugaraSodanshaNitottenoTaishosha__c = null; }
            else { aSimpleyasugo.ZokugaraSodanshaNitottenoTaishosha__c = pTcmsTaioRkImpData.Taishosha_Zokugara_From_Sodansha__c; }
            
            if(String.isBlank(pTcmsTaioRkImpData.Taishosha_Yomei__c)){ aOpp.TaishoshaYomeiKikan__c = '未聴取により不明'; }
            else { aOpp.TaishoshaYomeiKikan__c = pTcmsTaioRkImpData.Taishosha_Yomei__c; }

            if(String.isBlank(pTcmsTaioRkImpData.Taishosha_KyojuKeitai__c)){ aOpp.TaishoshaKyojuKeitai__c = '未聴取により不明'; }
            else { aOpp.TaishoshaKyojuKeitai__c = pTcmsTaioRkImpData.Taishosha_KyojuKeitai__c; }
            
            String the_juyo_renraku_jiko = '';
            if( !String.isBlank(pTcmsTaioRkImpData.TcmsSeqNo__c) ){
                the_juyo_renraku_jiko += 'トランスコスモス管理番号:' + pTcmsTaioRkImpData.TcmsSeqNo__c;
            }  
            if( !String.isBlank(pTcmsTaioRkImpData.HikitsugiJiko__c) ){
                if( !String.isBlank(the_juyo_renraku_jiko) ){ the_juyo_renraku_jiko += '\r\n'; }
                the_juyo_renraku_jiko += pTcmsTaioRkImpData.HikitsugiJiko__c;
            }
            aOpp.JuyoRenrakuJiko__c = the_juyo_renraku_jiko;
            
            this.m_IKanryoShubetsuMapper.applyKnaryoShubetsu(
                aOpp, 
                pTcmsTaioRkImpData.Kanryo_Shubetsu__c, 
                pTcmsTaioRkImpData.Taishosha_Joutai__c,
                pTcmsTaioRkImpData.SogiKiboAreaCode__c);

            String the_comments = '';
            if( !String.isBlank(pTcmsTaioRkImpData.TcmsSeqNo__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += 'トランスコスモス管理番号:' + pTcmsTaioRkImpData.TcmsSeqNo__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Kanryo_Shubetsu__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '完了種別:' + pTcmsTaioRkImpData.Kanryo_Shubetsu__c;
            }
            if( new List<String>{'完了/資料送付1','完了/資料送付2'}.contains(pTcmsTaioRkImpData.Kanryo_Shubetsu__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '資料送付担当:よりそう';
            }


            if( !String.isBlank(pTcmsTaioRkImpData.Sofusaki_Atena__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '資料送付先_宛名:' + pTcmsTaioRkImpData.Sofusaki_Atena__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Sofusaki_ZipCode__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '資料送付先_郵便番号:' + pTcmsTaioRkImpData.Sofusaki_ZipCode__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Sofusaki_State__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '資料送付先_都道府県:' + pTcmsTaioRkImpData.Sofusaki_State__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Sofusaki_City__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '資料送付先_市区郡:' + pTcmsTaioRkImpData.Sofusaki_City__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Sofusaki_Street__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '資料送付先_町名・番地:' + pTcmsTaioRkImpData.Sofusaki_Street__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Sofusaki_Room__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '資料送付先_建物名・部屋番号:' + pTcmsTaioRkImpData.Sofusaki_Room__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.TaishoshaUmu__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '対象者有無:' + pTcmsTaioRkImpData.TaishoshaUmu__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.BodaijiUmu__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '菩提寺有無:' + pTcmsTaioRkImpData.BodaijiUmu__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Taishosha_Jumin_State__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '対象者住民票_都道府県:' + pTcmsTaioRkImpData.Taishosha_Jumin_State__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Taishosha_Jumin_City__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += '対象者住民票_市区郡:' + pTcmsTaioRkImpData.Taishosha_Jumin_City__c;
            }
            if( !String.isBlank(pTcmsTaioRkImpData.Comment__c) ){
                if( !String.isBlank(the_comments) ){ the_comments += '\r\n'; }
                the_comments += 'コメント:' + pTcmsTaioRkImpData.Comment__c;
            }
            
            Update aSimpleyasugo;
            UPDATE aOpp;

            if( !String.isBlank(the_comments) ){
                Task aTask = new Task(
                    WhatId = aOpp.Id,
                    RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId(),
                    ShiborikomiJoken__c = 'トランスコスモスコメント',
                    Status = '完了',
                    Description = the_comments,
                    TaskSubtype = 'Call',
                    OwnerId = DefaultOwner.getOwnerId()
                );
                INSERT aTask;
            }
        }

        private Datetime parseDatetime(String pValue){
            if( String.isBlank(pValue) ) return null;
            return Datetime.valueOf(pValue.replace('#','') + ':00');
        }
    }

    public class InvalidValueException extends Exception{}

    public interface IKanryoShubetsuMapper {
        void applyKnaryoShubetsu(Opportunity p_Opp, String p_KanryoShubetsu, String p_Taishosha_Joutai, String p_SogiKiboAreaCode );
    }
    @TestVisible 
    private class KanryoShubetsuMapper implements IKanryoShubetsuMapper{
        public void applyKnaryoShubetsu(Opportunity p_Opp, String p_KanryoShubetsu, String p_Taishosha_Joutai, String p_SogiKiboAreaCode ){
            Opportunity aOpp = p_Opp;

            if( p_KanryoShubetsu == '完了/資料送付1' || p_KanryoShubetsu == '完了/資料送付2'){
                if( !String.isBlank(p_SogiKiboAreaCode) ){
                    aOpp.StageName = '問合せ受付';
                    aOpp.SubPhase__c = 'お客様情報一時聴取/入力中';
                }
                else if( String.isBlank(p_Taishosha_Joutai) || p_Taishosha_Joutai == '健在' ){
                    aOpp.StageName = 'フォロー';
                    aOpp.SubPhase__c = '資料到着確認待ち（健在/余命宣告［不急］）';
                }
                else{
                    aOpp.StageName = 'フォロー';
                    aOpp.SubPhase__c = '資料到着確認待ち（危篤/余命宣告［急］）';
                }                
            }
            else if( p_KanryoShubetsu == '完了/SMS許諾' ){
                if( String.isBlank(p_Taishosha_Joutai) || p_Taishosha_Joutai == '健在' ){
                    aOpp.StageName = 'フォロー';
                    aOpp.SubPhase__c = 'フォロー（健在/余命宣告［不急］）';
                }
                else{
                    aOpp.StageName = 'フォロー';
                    aOpp.SubPhase__c = 'フォロー（危篤/余命宣告［急］）';
                }                
            }
            else if( p_KanryoShubetsu == '完了/お断り' ){
                aOpp.StageName = '失注';
                aOpp.ShitchuKubun__c = '問合せのみ';
                aOpp.ShitchuYoin__c = '不明・その他';
                aOpp.SonotaShitchuYoinHosoku__c = 'トランスコスモス対応履歴:完了種別=完了/お断り';
            }
            else if( p_KanryoShubetsu == '完了/間違い、イタズラ' ){
                aOpp.StageName = '除外';
                aOpp.JogaiKubun__c = 'イタズラ案件';       
            }
            else if( p_KanryoShubetsu == '完了/3回目完了' ){
                aOpp.StageName = '除外';
                aOpp.JogaiKubun__c = 'コールバック繋がらず';       
            }
            else{
                throw new InvalidValueException();
            }
        }
    }


    public interface IKanryoShubetsus{
        Set<String> get_Kanryo_Shubetsu_to_create_opps();
    }

    @TestVisible
    private class KanryoShubetsus implements IKanryoShubetsus{
        public Set<String> get_Kanryo_Shubetsu_to_create_opps(){
            return new Set<String>{
                '完了/資料送付1','完了/資料送付2', '完了/SMS許諾', '完了/お断り', '完了/間違い、イタズラ', '完了/3回目完了'
            };
        }
    }
}