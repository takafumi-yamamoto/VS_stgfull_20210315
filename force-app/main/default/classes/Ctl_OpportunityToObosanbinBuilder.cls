/**
 * お坊さん便のサービスビルダー
 */
public class Ctl_OpportunityToObosanbinBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToObosanbinBuilder() {
        opps = new List<Opportunity>();
    }   
    public void addOpp(Opportunity opp) {
        opps.add(opp);
    }
    public List<Dto_OpportunityServicePair> getOpportunityServicePairList() {
    System.debug('---Ctl_OpportunityToObosanbinBuilder---');
        List<Dto_OpportunityServicePair> pairList = new List<Dto_OpportunityServicePair>();
        set<id> caseIdset = new set<id>();
        for(Opportunity opp : opps) {
            caseIdset.add(opp.CaseRef__c);
        }
        map<id,case> caseMap=new map<id,case>([select id,
                                                      recordtypeid,
                                                  HoyobashoMei__c,
                                                  HoyobashoZipCode__c,
                                                  HoyobashoState__c,
                                                  HoyobashoCity__c,
                                                  HoyobashoTyoumei__c,
                                                  HoyobashoStreet__c,
                                                  HojiHoyo__c,
                                                  TsuikahoyobashoMei__c,
                                                  TsuikahoyobashoZipCode__c,
                                                  TsuikahoyobashoState__c,
                                                  TsuikahoyobashoCity__c,
                                                  TsuikahoyobashoStreet__c,
                                                  HoyoKiboDate1__c,
                                                  HoyoKiboDate2__c,
                                                  HoyoKiboDate3__c,
                                                  HoyoKiboTime1__c,
                                                  HoyoKiboTime2__c,
                                                  HoyoKiboTime3__c,
                                                  HoyoKiboMinute1__c,
                                                  HoyoKiboMinute2__c,
                                                  HoyoKiboMinute3__c,
                                                  KaimyoHomeijuyo__c,
                                                  KakuninRenrakuNoKiboUmu__c,
                                                  Riyokaisu__c,
                                                  TaishoshaRef__c,
                                                  OkyakusamaCommnet__c,
                                                  HoyouYoteiStaus__c,
                                                  KaimyoPlan__c,
                                                  TsuikaHoyo__c,
                                                  Obonset__c,
                                                  ProductPlaceSelect__c,
                                                  ZokugaraSodanshaNitottenoTaishosha__c,
                                                  ShikijoName__c,
                                                  ShikijoZipCode__c,
                                                  ShikijoState__c,
                                                  ShikijoCity__c,
                                                  ShikijoTyoumei__c,
                                                  ShikijoStreet__c,
                                                  KasoDateTime_Inp__c,
                                                  TsuyaDateTime_Inp__c,
                                                  KokubetsushikiNichiji__c,
                                                  Shonanoka__c,
                                                  Kasoba__c
                                                 from case 
                                                where id in :caseIdset]);
    Map<Id, ObosanbinNittei__c> obosanbinNitteiMap = this.getObosanbinNitteiMap();

        for(Opportunity opp : opps) {
            Obosanbin__c service = new Obosanbin__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){

              
              service.HoyoBashoMei__c = c.HoyobashoMei__c; // 法要場所名

              //法要場所Begin
              Boolean isHoyoBashoTyomeiBanchiSeparatedFromat = !String.isBlank(c.HoyobashoTyoumei__c);
              if(isHoyoBashoTyomeiBanchiSeparatedFromat){
                // 法要郵便番号
                service.hoyo_postcode__c = c.HoyobashoZipCode__c;
                // 法要都道府県
                service.hoyo_todofuken__c = c.HoyobashoState__c;
                // 法要市区郡
                service.hoyo_shikugun__c = c.HoyobashoCity__c;
                // 法要町名
                service.hoyo_tyoumei__c = c.HoyobashoTyoumei__c;
                // 法要番地以降
                service.hoyo_banchi__c = c.HoyobashoStreet__c;
              }else{
                // 法要場所　住所
                String hoyoBashoAddress = String.Format('{0} {1}{2}{3}', 
                  new String[]{
                    String.isBlank(c.HoyobashoZipCode__c) ? '' : c.HoyobashoZipCode__c,
                    String.isBlank(c.HoyobashoState__c) ? '' : c.HoyobashoState__c,
                    String.isBlank(c.HoyobashoCity__c) ? '' : c.HoyobashoCity__c,
                    String.isBlank(c.HoyobashoStreet__c) ? '' : c.HoyobashoStreet__c
                  }
                );
                service.HoyobashoAddress__c = hoyoBashoAddress.replace('null', '');
              }

              //法要場所End

              // 追加法要場所名
              service.TsuikahoyobashoMei__c = c.TsuikahoyobashoMei__c;
              // 追加法要場所 住所
              String tsuikahoyobashoAddress = c.TsuikahoyobashoZipCode__c  +' '+ c.TsuikahoyobashoState__c + c.TsuikahoyobashoCity__c + c.TsuikahoyobashoStreet__c;
              service.TsuikahoyobashoAddress__c = tsuikahoyobashoAddress.replace('null', '');

              if(c.HoyoKiboDate1__c != null && c.HoyoKiboTime1__c != null && c.HoyoKiboMinute1__c != null){
                // 第一希望 告別式・法要日時
                service.KokubetsuDateTime_Inp1__c = createDateTimegHoyoKiboDate(c.HoyoKiboDate1__c, c.HoyoKiboTime1__c, c.HoyoKiboMinute1__c);
                // 法要日時
              }
             if(c.HoyoKiboDate2__c != null && c.HoyoKiboTime2__c != null && c.HoyoKiboMinute2__c != null){
                // 第二希望 告別式・法要日時
                service.KokubetsuDateTime_Inp2__c = createDateTimegHoyoKiboDate(c.HoyoKiboDate2__c, c.HoyoKiboTime2__c, c.HoyoKiboMinute2__c);                  
              }
              if(c.HoyoKiboDate3__c != null && c.HoyoKiboTime3__c != null && c.HoyoKiboMinute3__c != null){
                // 第三希望 告別式・法要日時
                service.KokubetsuDateTime_Inp3__c = createDateTimegHoyoKiboDate(c.HoyoKiboDate3__c, c.HoyoKiboTime3__c, c.HoyoKiboMinute3__c);                
              }
              // 戒名・法名の授与
              service.Kaimyojuyo__c = c.KaimyoHomeijuyo__c;
              // 確認連絡の希望有無
              service.KakuninRenrakuNoKiboUmu__c = c.KakuninRenrakuNoKiboUmu__c;
              // 利用回数
              service.Riyokaisu__c = c.Riyokaisu__c;
              // 対象者状況
              service.Taishosha1Ref__c = c.TaishoshaRef__c;
              // 法要予定状況
              service.HoyouYoteiStaus__c = c.HoyouYoteiStaus__c;
              // お客様コメント
              opp.JuyoRenrakuJiko__c = c.OkyakusamaCommnet__c;
              // お坊さん便プラン
              service.MemorialServicePlan__c = c.HojiHoyo__c;
              // 戒名・法名
              service.Kaimyo__c = c.KaimyoPlan__c;
              // 追加法要
              service.TsuikaHoyo__c = c.TsuikaHoyo__c;
              // お盆セット
              service.Obonset__c       = c.Obonset__c;
              // 商品送付先
              service.ProductPlaceSelect__c       = c.ProductPlaceSelect__c;
              // 続柄：相談者にとっての対象者1
              service.ZokugaraSodanshaNitottenoTaishosha1__c = c.ZokugaraSodanshaNitottenoTaishosha__c;
              // 斎場名
              service.Saijo__c = c.ShikijoName__c;
              // 斎場　住所
              String saijoAddress = c.ShikijoZipCode__c + ' ' +  c.ShikijoState__c + c.ShikijoCity__c + c.ShikijoTyoumei__c + ' ' + c.ShikijoStreet__c;
              service.SaijoAddress__c = saijoAddress.replace('null','');
              // 火葬日時
              service.KasoDateTime_Inp__c = c.KasoDateTime_Inp__c;
              // 通夜日時
              service.TsuyaDateTime_Inp__c = c.TsuyaDateTime_Inp__c;
              // 告別式日時
              service.KokubetsushikiNichiji__c = c.KokubetsushikiNichiji__c;
              // 初七日
              service.Shonanoka__c = c.Shonanoka__c;
              // 火葬場
              if(c.HojiHoyo__c == '火葬式'){
                service.Kasoba__c = c.ShikijoName__c;
              }
              if(c.HojiHoyo__c == '一般葬' || c.HojiHoyo__c == '一日葬'){
                service.Kasoba__c = c.Kasoba__c;
              }

              //斎場Begin
              Boolean isShikijoTyomeiBanchiSeparatedFromat = !String.isBlank(c.ShikijoTyoumei__c);
              if(isShikijoTyomeiBanchiSeparatedFromat){
                // 斎場郵便番号
                service.sogi_postcode__c = c.ShikijoZipCode__c;
                // 斎場都道府県
                service.sogi_todofuken__c = c.ShikijoState__c;
                // 斎場市区郡
                service.sogi_shikugun__c = c.ShikijoCity__c;
                // 斎場町名
                service.sogi_tyoumei__c = c.ShikijoTyoumei__c;
                // 斎場番地以降
                service.sogi_banchi__c = c.ShikijoStreet__c;
              }else{
                // 斎場場所　住所
                String shikijoBashoAddress = String.Format('{0} {1}{2}{3}', 
                  new String[]{
                    String.isBlank(c.ShikijoZipCode__c) ? '' : c.ShikijoZipCode__c,
                    String.isBlank(c.ShikijoState__c) ? '' : c.ShikijoState__c,
                    String.isBlank(c.ShikijoCity__c) ? '' : c.ShikijoCity__c,
                    String.isBlank(c.ShikijoStreet__c) ? '' : c.ShikijoStreet__c
                  }
                );
                service.SaijoAddress__c = shikijoBashoAddress.replace('null', '');
              }
              //斎場End

              this.setObosanbinNitteiYoyaku(obosanbinNitteiMap, opp, service);

            }
            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
            
        }
          return pairList;
    }

    private DateTime createDateTimegHoyoKiboDate(Date hoyoKiboDate, String hoyoKiboTime, String hoyoKiboMinute){

      List<String> strHoyoKiboDates = String.valueOf(hoyoKiboDate).split('-', 0);

      Integer intYear   = Integer.valueOf(strHoyoKiboDates.get(0));
      Integer intMonth  = Integer.valueOf(strHoyoKiboDates.get(1));
      Integer intDate   = Integer.valueOf(strHoyoKiboDates.get(2));
      Integer intHour   = Integer.valueOf(hoyoKiboTime);
      Integer intMinute = Integer.valueOf(hoyoKiboMinute);
      Integer intSecond = 0;
      
      DateTime changedHoyoKiboDate = DateTime.newInstance(intYear, intMonth, intDate, intHour, intMinute, intSecond);

      return changedHoyoKiboDate;
    }

    /*未来の法要予約がされた場合、メインSF商談を予約分だけ複製する」
    複製された場合の主な変更箇所は以下を参照してください*/
    private void setObosanbinNitteiYoyaku(Map<Id, ObosanbinNittei__c> obosanbinNitteiMap, Opportunity opp, Obosanbin__c service){
        if(String.isNotBlank(opp.ObosanbinNitteiRef__c) && obosanbinNitteiMap.containsKey(opp.ObosanbinNitteiRef__c)){
            ObosanbinNittei__c obosanbinNittei = obosanbinNitteiMap.get(opp.ObosanbinNitteiRef__c);
            service.MemorialServicePlan__c = obosanbinNittei.plan_name__c; //お坊さん便-プラン
            service.TsuikaHoyo__c = null; // 追加法要(Web)
            service.Kaimyojuyo__c = null; // 戒名の授与
            service.Kaimyo__c = null; // 戒名・法名
            service.KakuninRenrakuNoKiboUmu__c = null; // 確認連絡の希望有無
            service.Obon__c = false; // お盆
            service.Hatsubon__c = false; // 初盆
            service.Obonset__c = null; // お盆セット
            service.ProductPlaceSelect__c = null; // 商品送付先
            service.KokubetsuDateTime_Inp__c = null;  // 法要日時
            service.KokubetsuDateTime_Inp1__c = null;  // 告別式・法要日時（第1希望）
            service.KokubetsuDateTime_Inp2__c = null;  // 告別式・法要日時（第2希望）
            service.KokubetsuDateTime_Inp3__c = null;  // 告別式・法要ｃぉ日時（第3希望）
            service.HoyoBashoMei__c = null;  // 法要場所名
            service.HoyoBashoAddress__c = null;  // 法要場所住所
            service.TsuikahoyobashoMei__c = null;  // 追加法要場所名
            service.TsuikahoyobashoAddress__c = null;  // 追加法要場所住所
            service.HoyoBashoTEL__c = null;  // 法要場所TEL
            service.Yoteibi__c = obosanbinNittei.yotei_date__c; //予定日
            service.RenrakuKiboubi__c = obosanbinNittei.jizen_tsuchi_yotei_date__c; //事前通知予定日 連絡希望日
            service.YoyakuUketsukebi__c = Date.today(); //予約受付日
            service.Saijo__c = null; //斎場名
            service.SaijoAddress__c = null; //斎場住所
            service.KasoDateTime_Inp__c = null; //火葬日時
            service.TsuyaDateTime_Inp__c = null; //通夜日時
            service.KokubetsushikiNichiji__c = null; //告別式日時
            service.Shonanoka__c = null; //初七日
            service.Kasoba__c = null; //火葬場
            service.hoyo_postcode__c = null; // 法要郵便番号
            service.hoyo_todofuken__c = null; // 法要都道府県
            service.hoyo_shikugun__c = null; // 法要市区郡
            service.hoyo_tyoumei__c = null; // 法要町名
            service.hoyo_banchi__c = null; // 法要番地以降
            service.sogi_postcode__c = null; // 斎場郵便番号
            service.sogi_todofuken__c = null; // 斎場都道府県
            service.sogi_shikugun__c = null; // 斎場市区郡
            service.sogi_tyoumei__c = null; // 斎場町名
            service.sogi_banchi__c =null; // 斎場番地以降
        }
    }

    private Map<Id, ObosanbinNittei__c> getObosanbinNitteiMap(){
        Set<Id> niteiIds = new Set<Id>();
        for(Opportunity opp : this.opps) {
            if(String.isNotBlank(opp.ObosanbinNitteiRef__c))
               niteiIds.add(opp.ObosanbinNitteiRef__c);
        }

        return new Map<Id, ObosanbinNittei__c>([SELECT 
                              Id ,    // カスタムオブジェクト ID
                              Name ,    // お坊さん便日程名
                              plan_name__c ,    // プラン名
                              yotei_date__c ,    // 予定日
                              jizen_tsuchi_yotei_date__c     // 事前通知予定日
                       FROM ObosanbinNittei__c]);
    }
}