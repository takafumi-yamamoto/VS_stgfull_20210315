/**
 * シンプル安豪のサービスビルダー
 */
public class Ctl_OpportunityToSimpleYasugoBuilder implements Ctl_IOpportunityToServiceBuilder{
  public List<Opportunity> opps;
    public Ctl_OpportunityToSimpleYasugoBuilder () {
        opps = new List<Opportunity>();
    }  
    public void addOpp(Opportunity opp) {
        opps.add(opp);
    }    
  
  public List<Dto_OpportunityServicePair> getOpportunityServicePairList() {
    List<Dto_OpportunityServicePair> pairList = new List<Dto_OpportunityServicePair>();
    set<id> caseIdset = new set<id>();
    for(Opportunity opp : opps) {
      caseIdset.add(opp.CaseRef__c);
    }
    map<id,case> caseMap=new map<id,case>([select id,
                                                  recordtypeid,
                                                  //希望エリア都道府県
                                                  KiboAreaState__c,
                                                  //希望エリア市区群
                                                  KiboAreaCity__c,
                                                  //資料送付方法
                                                  ShiryoSoufuHoho__c,
                                                  //重要連絡事項
                                                  ImporantMessage__c,
                                                  //エンディングノートの有無
                                                  EndingNoteFlg__c,
                                                  //対象者状況
                                                  TaishoushaJokyo__c,
                                                  //issues3806--Start--
                                                  //対象者居住状態（初回）
                                                  TaishoshaKyojuKeitai__c,
                                                  //余命期間（初回）
                                                  TaishoshaYomeiKikan__c,
                                                  //問い合わせ起因者（初回）
                                                  ToiawaseKiinsha__c,
                                                  //issues3806--End--
                                                  //対象者
                                                  TaishoshaRef__c,
                                                  // お客様コメント
                                                  OkyakusamaCommnet__c,
                                                  // お葬式対象者
                                                  TaishoshaGaMoshikomishaToDoitsu__c,
                                                  ZokugaraSodanshaNitottenoTaishosha__c,
                                                  ZokugaraSodanshaNitottenoTaishoshaSonota__c,
                                                  OmukaesakiMeisho__c,
                                                  OmukaesakiZipCode__c,
                                                  OmukaesakiState__c,
                                                  OmukaesakiCity__c,
                                                  OmukaesakiStreet__c,
                                                  AnchiKubun__c,
                                                  KiboPlan__c,
                                                  ObosanbinOption__c, 
                                                  Origin 
                                             from case 
                                            where id in :caseIdset]);

    for(Opportunity opp : opps) {
            SimpleYasugo__c service = new SimpleYasugo__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
              // 希望エリア
              service.KiboAreaRef__c = getKiboAreaId(c.KiboAreaState__c, c.KiboAreaCity__c);
              //資料送付方法
              if(c.ShiryoSoufuHoho__c == 'メール希望' || c.ShiryoSoufuHoho__c == 'メール（自動）希望'){
                service.MailSofuYohi__c = true;
              }

              if(c.ShiryoSoufuHoho__c == '郵送希望'){
                service.YusoYohiShubetsu__c = '通常';
              }

              //エンディングノートの有無
              service.EndingNoteFlg__c = c.EndingNoteFlg__c;
              // 対象者
              service.TaishoshaRef__c = c.TaishoshaRef__c;
              // お葬式対象者
              service.TaishoshaGaMoshikomishaToDoitsu__c = c.TaishoshaGaMoshikomishaToDoitsu__c;
              //issues3806--Start--
              // 対象者状態(現在)のコメントアウト
              //service.TaishoshasamaNoGojotaiGenzai__c = c.TaishoushaJokyo__c;
              //issues3806--End--

              // if(c.TaishoushaJokyo__c == '危篤' || c.TaishoushaJokyo__c == '余命宣告'){
              //   service.MailSofuYohi__c = true;
              // }

              //issues3806--Start--
              // 自動更新処理がなくなったためコメントアウト
              //if(c.ShiryoSoufuHoho__c == 'メール希望' || c.ShiryoSoufuHoho__c == 'メール（自動）希望'){
              //  service.YusoYohiShubetsu__c = '不要';
              //}
              //else if(c.ShiryoSoufuHoho__c == '郵送希望' && (c.TaishoushaJokyo__c == '危篤' || c.TaishoushaJokyo__c == '余命宣告')){
              //  service.YusoYohiShubetsu__c = '速達';
              //}
              //else if(c.ShiryoSoufuHoho__c == '郵送希望' && (c.TaishoushaJokyo__c != '危篤' && c.TaishoushaJokyo__c != '余命宣告')){
              //  service.YusoYohiShubetsu__c = '通常';
              //}

              //if(service.YusoYohiShubetsu__c == '速達' || service.YusoYohiShubetsu__c == '通常'){
              //  service.ShiryoSofuJokyo__c = '未送付';
              //}
              //issues3806--End--

              service.ZokugaraSodanshaNitottenoTaishosha__c = c.ZokugaraSodanshaNitottenoTaishosha__c;
              service.ZokugaraSodanshaNitottenoTaishoshaSonota__c = c.ZokugaraSodanshaNitottenoTaishoshaSonota__c;
              service.OmukaeSakiName__c = c.OmukaesakiMeisho__c;
              String strAddress = '';
              if(String.isNotBlank(c.OmukaesakiZipCode__c)){
                strAddress += c.OmukaesakiZipCode__c + ' ';
              }
              if(String.isNotBlank(c.OmukaesakiState__c)){
                strAddress += c.OmukaesakiState__c;
              }
              if(String.isNotBlank(c.OmukaesakiCity__c)){
                strAddress += c.OmukaesakiCity__c;
              }
              if(String.isNotBlank(c.OmukaesakiStreet__c)){
                strAddress += c.OmukaesakiStreet__c;
              }
              service.OmukaeSakiStreet__c = strAddress;
              
              if(c.AnchiKubun__c == '自宅安置') service.KiboGoanchisaki__c = '自宅';
              else if(c.AnchiKubun__c == '葬儀社預かり安置') service.KiboGoanchisaki__c = '預かり安置';
              else service.KiboGoanchisaki__c = '';

              service.SogiPlanUketsuke__c = c.KiboPlan__c;
              System.debug('getOpportunityServicePairList c.ObosanbinOption__c:' + c.ObosanbinOption__c);
              if(c.ObosanbinOption__c == ''){
                service.MonkArrangements__c = '無';
                service.Kaimyojuyo__c = '戒名の授与を希望しない';
              }
              else if(c.ObosanbinOption__c == '葬儀読経のみ'){
                service.MonkArrangements__c = '有';
                service.Kaimyojuyo__c = '戒名の授与を希望しない';
              }
              else if(c.ObosanbinOption__c == '葬儀読経＋戒名授与'){
                service.MonkArrangements__c = '有';
                service.Kaimyojuyo__c = '戒名の授与を希望する';
              }

              //issues3806--Start--
                if(c.Origin == 'Web' && 
                (c.TaishoushaJokyo__c == '死亡' || 
                c.TaishoushaJokyo__c == 'すでにご逝去' || 
                c.TaishoushaJokyo__c == '危篤' || 
                c.TaishoushaJokyo__c == '余命宣告' || 
                c.TaishoushaJokyo__c == '闘病中（度合不明）' || 
                c.TaishoushaJokyo__c == '闘病中（軽度）')){
                service.X3CallJishiKekka__c = '未実施';
              }
              else{
                service.X3CallJishiKekka__c = '対象外';
              }
              //issues3806--End--

              // お客様コメント
              Opp.JuyoRenrakuJiko__c = c.OkyakusamaCommnet__c;
            }

            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
      
    }
    return pairList;
  }

    /**
     * 希望エリアID取得
     * @param  state 都道府県
     * @param  city  市区群(+町名、市区群Name項目形式)
     * @return       市区群ID
     */ 
    private Id getKiboAreaId(String state, String city) {
        List<Shikugun__c> kiboAreaList = Dao_Shikugun.SearchShikugunByFullName(state + city);
        if(!kiboAreaList.isEmpty()) {
            return kiboAreaList[0].id;
        }
        return null;
    }  
}