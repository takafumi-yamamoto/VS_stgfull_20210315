public class SwitchRyokinhyoCreate {

	private static List<PricebookEntry> pricebookEntryList = [
                                                    select Id, 
                                                        Name, 
                                                        UnitPrice, 
                                                        Product2.ShohinBango__c, 
                                                        Product2.k_Service_Id_exp__c, 
                                                        Product2.k_ShohinSyubetsu_Id_exp__c, 
                                                        Product2.k_ShohinCategory_Id_exp__c 
                                                    from PricebookEntry 
                                                    where Pricebook2.IsStandard = true and 
                                                        Product2.isActive = true and 
                                                        Product2.k_Service_Id_exp__c in ('1','3') 
                                                    order by Product2.ShohinBango__c
                                                ];

    public RyokinhyoShikiData planRyokinData;
    public RyokinhyoShikiData planButsugNashiData;
    public RyokinhyoShikiData jizenAnketoData;
    public RyokinhyoShikiData shikigoAnketoData;
    public Map<String, RyokinhyoShikiData> planWaribikiDataMap;
    public Map<String, Decimal> planSoryoTehaiMap;
    public Map<String, Decimal> planKaimyoHomyoMap;
    public List<SelectOption> standardOpt;
    public Map<String, RyokinhyoShikiData> saidanUpGreadDataMap;
    public Map<String, Decimal> yorisoOptionDataMap;
    public Map<String, Decimal> sogishaOptionDataMap;
    public Decimal kasobaRyokin;

    public RyokinhyoShikiData ryokinhyoShikiData {get;set;}
    private Map<String, PricebookEntry> pbMap;

    public class RyokinhyoShikiData {

        public Decimal kaso {get;set;}
        public Decimal ichinichi {get;set;}
        public Decimal kazoku {get;set;}
        public Decimal ippan {get;set;}

        public Decimal kazoku1Nichi {get; set;}
        public Decimal kazoku2Nichi {get; set;}
        public Decimal kazokuHanayaka {get; set;}
        public Decimal kasoChokuso {get; set;}
        public Decimal kasoHyojun {get; set;}

        public RyokinhyoShikiData(){
            kaso = 0;
            ichinichi = 0;
            kazoku = 0;
            ippan = 0;

            kazoku1Nichi = 0;
            kazoku2Nichi = 0;
            kazokuHanayaka = 0;
            kasoChokuso = 0;
            kasoHyojun = 0;
        }
    }

    public SwitchRyokinhyoCreate(){
        getPlanShikiMstMap();
    }

    public void getPlanShikiMstMap(){
        planRyokinData = new RyokinhyoShikiData();
        planButsugNashiData = new RyokinhyoShikiData();
        planWaribikiDataMap = new Map<String, RyokinhyoShikiData>();
        planWaribikiDataMap.put('', new RyokinhyoShikiData());
        jizenAnketoData = new RyokinhyoShikiData();
        shikigoAnketoData = new RyokinhyoShikiData();
        saidanUpGreadDataMap = new Map<String, RyokinhyoShikiData>();
        saidanUpGreadDataMap.put('', new RyokinhyoShikiData());
        planSoryoTehaiMap = new Map<String, Decimal>();
        planKaimyoHomyoMap = new Map<String, Decimal>();

        standardOpt = new List<SelectOption>();
        standardOpt.add(new SelectOption('', ''));

        yorisoOptionDataMap = new Map<String, Decimal>();
        yorisoOptionDataMap.put('', 0);
        sogishaOptionDataMap = new Map<String, Decimal>();
        sogishaOptionDataMap.put('', 0);

        pbMap = new Map<String, PricebookEntry>();
        for(PricebookEntry p : pricebookEntryList){
            
            pbMap.put(p.Product2.ShohinBango__c, p);
            
            RyokinhyoShikiData tempRyokinhyo = new RyokinhyoShikiData();
            if(p.Product2.ShohinBango__c == 'SBG-0005006') planRyokinData.kazoku1Nichi = p.UnitPrice;
            else if(p.Product2.ShohinBango__c == 'SBG-0005002') planRyokinData.kazoku2Nichi = p.UnitPrice;
            else if(p.Product2.ShohinBango__c == 'SBG-0005003') planRyokinData.kazokuHanayaka = p.UnitPrice;
            else if(p.Product2.ShohinBango__c == 'SBG-0005007') planRyokinData.kasoChokuso = p.UnitPrice;
            else if(p.Product2.ShohinBango__c == 'SBG-0005005') planRyokinData.kasoHyojun = p.UnitPrice;
            else if(p.Product2.ShohinBango__c == 'SBG-0005108'){
                planButsugNashiData.kazoku1Nichi = p.UnitPrice;
                planButsugNashiData.kazoku2Nichi = p.UnitPrice;
                planButsugNashiData.kazokuHanayaka = p.UnitPrice;
                planButsugNashiData.kasoChokuso = 0;
                planButsugNashiData.kasoHyojun = p.UnitPrice;
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005106'){
                jizenAnketoData.kazoku1Nichi = p.UnitPrice;
                jizenAnketoData.kazoku2Nichi = p.UnitPrice;
                jizenAnketoData.kazokuHanayaka = p.UnitPrice;
                jizenAnketoData.kasoChokuso = p.UnitPrice;
                jizenAnketoData.kasoHyojun = p.UnitPrice;
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005107'){
                shikigoAnketoData.kazoku1Nichi = p.UnitPrice;
                shikigoAnketoData.kazoku2Nichi = p.UnitPrice;
                shikigoAnketoData.kazokuHanayaka = p.UnitPrice;
                shikigoAnketoData.kasoChokuso = p.UnitPrice;
                shikigoAnketoData.kasoHyojun = p.UnitPrice;
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000046'){ planSoryoTehaiMap.put('火葬式', getProductUnitPrice('SBG-0000046')); }
            else if(p.Product2.ShohinBango__c == 'SBG-0000047'){ planSoryoTehaiMap.put('家族葬一日', getProductUnitPrice('SBG-0000047')); }
            else if(p.Product2.ShohinBango__c == 'SBG-0000048'){ planSoryoTehaiMap.put('家族葬二日華やか', getProductUnitPrice('SBG-0000048')); }
            else if(p.Product2.ShohinBango__c == 'SBG-0000060'){ 
                planKaimyoHomyoMap.put('釋', getProductUnitPrice('SBG-0000060'));
                planKaimyoHomyoMap.put('釋尼', getProductUnitPrice('SBG-0000060'));
                planKaimyoHomyoMap.put('釋・釋尼', getProductUnitPrice('SBG-0000060'));
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000061'){
                planKaimyoHomyoMap.put('信士', getProductUnitPrice('SBG-0000061'));
                planKaimyoHomyoMap.put('信女', getProductUnitPrice('SBG-0000061'));
                planKaimyoHomyoMap.put('信士・信女', getProductUnitPrice('SBG-0000061'));
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000062'){
                planKaimyoHomyoMap.put('院信士', getProductUnitPrice('SBG-0000062'));
                planKaimyoHomyoMap.put('院信女', getProductUnitPrice('SBG-0000062'));
                planKaimyoHomyoMap.put('院信士・院信女', getProductUnitPrice('SBG-0000062'));
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000063'){
                planKaimyoHomyoMap.put('居士', getProductUnitPrice('SBG-0000063'));
                planKaimyoHomyoMap.put('大姉', getProductUnitPrice('SBG-0000063'));
                planKaimyoHomyoMap.put('居士・大姉', getProductUnitPrice('SBG-0000063'));
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000064'){
                planKaimyoHomyoMap.put('院釋', getProductUnitPrice('SBG-0000064'));
                planKaimyoHomyoMap.put('院釋尼', getProductUnitPrice('SBG-0000064'));
                planKaimyoHomyoMap.put('院釋・院釋尼', getProductUnitPrice('SBG-0000064'));
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000065'){
                planKaimyoHomyoMap.put('院日信士', getProductUnitPrice('SBG-0000065'));
                planKaimyoHomyoMap.put('院日信女', getProductUnitPrice('SBG-0000065'));
                planKaimyoHomyoMap.put('院日信士・院日信女', getProductUnitPrice('SBG-0000065'));
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000066'){
                planKaimyoHomyoMap.put('院居士', getProductUnitPrice('SBG-0000066'));
                planKaimyoHomyoMap.put('院大姉', getProductUnitPrice('SBG-0000066'));
                planKaimyoHomyoMap.put('院居士・院大姉', getProductUnitPrice('SBG-0000066'));
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005401'){
                RyokinhyoShikiData saidanUpGreadData = new RyokinhyoShikiData();
                saidanUpGreadData.kazoku1Nichi = p.UnitPrice;
                saidanUpGreadDataMap.put('M (家族葬 一日プラン)', saidanUpGreadData);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005402'){
                RyokinhyoShikiData saidanUpGreadData = new RyokinhyoShikiData();
                saidanUpGreadData.kazoku1Nichi = p.UnitPrice;
                saidanUpGreadDataMap.put('L (家族葬 一日プラン)', saidanUpGreadData);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005403'){
                RyokinhyoShikiData saidanUpGreadData = new RyokinhyoShikiData();
                saidanUpGreadData.kazoku1Nichi = p.UnitPrice;
                saidanUpGreadDataMap.put('LL (家族葬 一日プラン)', saidanUpGreadData);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005404'){
                RyokinhyoShikiData saidanUpGreadData = new RyokinhyoShikiData();
                saidanUpGreadData.kazoku2Nichi = p.UnitPrice;
                saidanUpGreadDataMap.put('L (家族葬 二日プラン)', saidanUpGreadData);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005405'){
                RyokinhyoShikiData saidanUpGreadData = new RyokinhyoShikiData();
                saidanUpGreadData.kazoku2Nichi = p.UnitPrice;
                saidanUpGreadDataMap.put('LL (家族葬 二日プラン)', saidanUpGreadData);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005406'){
                RyokinhyoShikiData saidanUpGreadData = new RyokinhyoShikiData();
                saidanUpGreadData.kazokuHanayaka = p.UnitPrice;
                saidanUpGreadDataMap.put('LL (家族葬 華やかプラン)', saidanUpGreadData);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0005407'){ yorisoOptionDataMap.put('お別れ花 S', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005408'){ yorisoOptionDataMap.put('お別れ花 M', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005409'){ yorisoOptionDataMap.put('お別れ花 L', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005410'){ yorisoOptionDataMap.put('棺上花束 S', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005411'){ yorisoOptionDataMap.put('棺上花束 M', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005412'){ yorisoOptionDataMap.put('棺上花束 L', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005413'){ yorisoOptionDataMap.put('枕花 S', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005414'){ yorisoOptionDataMap.put('枕花 M', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005415'){ yorisoOptionDataMap.put('枕花 L', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005416'){ yorisoOptionDataMap.put('遺影写真 (大小2枚)', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005417'){ yorisoOptionDataMap.put('付添安置 (1泊)', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005418'){ yorisoOptionDataMap.put('搬送超過料金', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005419'){ yorisoOptionDataMap.put('ご安置追加料金', p.UnitPrice); }
            //else if(p.Product2.ShohinBango__c == 'SBG-0005420'){ yorisoOptionDataMap.put('葬儀用ブーケ', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005501'){ sogishaOptionDataMap.put('料理', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005502'){ sogishaOptionDataMap.put('返礼品', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005503'){ sogishaOptionDataMap.put('祭壇', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005504'){ sogishaOptionDataMap.put('エンバーミング', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005505'){ sogishaOptionDataMap.put('ラストメイク', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005506'){ sogishaOptionDataMap.put('ﾒｲｸ&ﾄﾞﾚｽ(古式湯灌)', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005507'){ sogishaOptionDataMap.put('湯灌', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005508'){ sogishaOptionDataMap.put('枕花', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005509'){ sogishaOptionDataMap.put('棺上花束', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005510'){ sogishaOptionDataMap.put('供花', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005511'){ sogishaOptionDataMap.put('お別れ花', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0005512'){ sogishaOptionDataMap.put('遺影写真', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005513'){ sogishaOptionDataMap.put('外装設備追加', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005514'){ sogishaOptionDataMap.put('骨壷ランクアップ', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005515'){ sogishaOptionDataMap.put('棺', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005516'){ sogishaOptionDataMap.put('看板', p.UnitPrice); }
            // else if(p.Product2.ShohinBango__c == 'SBG-0005517'){ sogishaOptionDataMap.put('その他オプション', p.UnitPrice); }
            else if(p.Product2.ShohinBango__c == 'SBG-0001015'){
                kasobaRyokin = p.UnitPrice;
            }
        }

        planKaimyoHomyoMap = new Map<String, Decimal>{
            '釋' => pbMap.get('SBG-0000060').UnitPrice,
            '釋尼' => pbMap.get('SBG-0000060').UnitPrice,
            '釋・釋尼' => pbMap.get('SBG-0000060').UnitPrice,
            '信士' => pbMap.get('SBG-0000061').UnitPrice,
            '信女' => pbMap.get('SBG-0000061').UnitPrice,
            '信士・信女' => pbMap.get('SBG-0000061').UnitPrice,
            '院信士' => pbMap.get('SBG-0000062').UnitPrice,
            '院信女' => pbMap.get('SBG-0000062').UnitPrice,
            '院信士・院信女' => pbMap.get('SBG-0000062').UnitPrice,
            '居士' => pbMap.get('SBG-0000063').UnitPrice,
            '大姉' => pbMap.get('SBG-0000063').UnitPrice,
            '居士・大姉' => pbMap.get('SBG-0000063').UnitPrice,
            '院釋' => pbMap.get('SBG-0000064').UnitPrice,
            '院釋尼' => pbMap.get('SBG-0000064').UnitPrice,
            '院釋・院釋尼' => pbMap.get('SBG-0000064').UnitPrice,
            '院日信士' => pbMap.get('SBG-0000065').UnitPrice,
            '院日信女' => pbMap.get('SBG-0000065').UnitPrice,
            '院日信士・院日信女' => pbMap.get('SBG-0000065').UnitPrice,
            '院居士' => pbMap.get('SBG-0000066').UnitPrice,
            '院大姉' => pbMap.get('SBG-0000066').UnitPrice,
            '院居士・院大姉' => pbMap.get('SBG-0000066').UnitPrice
        };

        RyokinhyoShikiData hiMember = new RyokinhyoShikiData();
        hiMember.kazoku1nichi = 0;
        hiMember.kazoku2nichi = 0;
        hiMember.kazokuhanayaka = 0;
        hiMember.kasochokuso = 0;
        hiMember.kasohyojun = 0;

        RyokinhyoShikiData kyuYorisoKaiin = new RyokinhyoShikiData();
        kyuYorisoKaiin.kazoku1nichi = getProductUnitPrice('SBG-0005109');
        kyuYorisoKaiin.kazoku2nichi = getProductUnitPrice('SBG-0005110');
        kyuYorisoKaiin.kazokuhanayaka = getProductUnitPrice('SBG-0005111');
        kyuYorisoKaiin.kasochokuso = getProductUnitPrice('SBG-0005112');
        kyuYorisoKaiin.kasohyojun = getProductUnitPrice('SBG-0005113');

        RyokinhyoShikiData yorisoKaiin = new RyokinhyoShikiData();
        yorisoKaiin.kazoku1nichi = getProductUnitPrice('SBG-0005101');
        yorisoKaiin.kazoku2nichi = getProductUnitPrice('SBG-0005102');
        yorisoKaiin.kazokuhanayaka = getProductUnitPrice('SBG-0005103');
        yorisoKaiin.kasochokuso = getProductUnitPrice('SBG-0005104');
        yorisoKaiin.kasohyojun = getProductUnitPrice('SBG-0005105');

        RyokinhyoShikiData ososhikiKaiin = new RyokinhyoShikiData();
        ososhikiKaiin.kazoku1nichi = getProductUnitPrice('SBG-0005114');
        ososhikiKaiin.kazoku2nichi = getProductUnitPrice('SBG-0005115');
        ososhikiKaiin.kazokuhanayaka = getProductUnitPrice('SBG-0005116');
        ososhikiKaiin.kasochokuso = getProductUnitPrice('SBG-0005117');
        ososhikiKaiin.kasohyojun = getProductUnitPrice('SBG-0005118');

        planWaribikiDataMap = new Map<String, RyokinhyoShikiData>{
            '非会員' => hiMember,
            '旧よりそう会員' => kyuYorisoKaiin,
            'よりそう会員' => yorisoKaiin,
            'お葬式予約会員' => ososhikiKaiin
        };
    }

    private Decimal getProductUnitPrice(String productName){ return pbMap.containsKey(productName) ? pbMap.get(productName).UnitPrice : null; }
}