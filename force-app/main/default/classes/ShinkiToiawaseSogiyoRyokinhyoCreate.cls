public class ShinkiToiawaseSogiyoRyokinhyoCreate {

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
                                                        Product2.k_Service_Id_exp__c in ('1','2','3') 
                                                ];

    public Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData> planShikiDataMap;
    public Map<String, Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>>> planWaribikiDataMap;
    public Map<String, Decimal> planSoryoTehaiMap;
    public Map<String, Decimal> planKaimyoHomyoMap;
    public List<SelectOption> standardOpt;
    public Map<String, String> standardOptJson;
    public Decimal kasobaRyokin;

    public ShinkiToiawaseSogiyoRyokinhyoCreate(){
        getPlanShikiMstMap();
    }

    public void getPlanShikiMstMap(){
        planShikiDataMap = new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>();
        planShikiDataMap.put('', new ShinkiToiawaseSogiyoRyokinhyoShikiData());

        planWaribikiDataMap = new Map<String, Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>>>();

        ShinkiToiawaseSogiyoRyokinhyoShikiData tempRyokinhyoWribiki = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        tempRyokinhyoWribiki.setKaso(0);
        tempRyokinhyoWribiki.setIchinichi(0);
        tempRyokinhyoWribiki.setKazoku(0);
        tempRyokinhyoWribiki.setIppan(0);

        Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData> tempRyokinhyoWaribikiNullMap = new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>();
        tempRyokinhyoWaribikiNullMap.put('', tempRyokinhyoWribiki);
        tempRyokinhyoWaribikiNullMap.put('直葬', tempRyokinhyoWribiki);
        tempRyokinhyoWaribikiNullMap.put('無宗教', tempRyokinhyoWribiki);
        tempRyokinhyoWaribikiNullMap.put('仏式', tempRyokinhyoWribiki);
        tempRyokinhyoWaribikiNullMap.put('花束', tempRyokinhyoWribiki);
        tempRyokinhyoWaribikiNullMap.put('お花増量', tempRyokinhyoWribiki);
        Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>> temptempRyokinhyoWaribikiNullMap = new Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>>();
        temptempRyokinhyoWaribikiNullMap.put('', tempRyokinhyoWaribikiNullMap);
        planWaribikiDataMap.put('', temptempRyokinhyoWaribikiNullMap);
        
        planSoryoTehaiMap = new Map<String, Decimal>();
        planKaimyoHomyoMap = new Map<String, Decimal>();

        standardOpt = new List<SelectOption>();
        standardOpt.add(new SelectOption('', ''));
        standardOptJson = new Map<String, String>();
        standardOptJson.put('', '');

        Map<String, PricebookEntry> pbMap = new Map<String, PricebookEntry>();
        for(PricebookEntry p : pricebookEntryList){
            
            pbMap.put(p.Product2.ShohinBango__c, p);
            
            ShinkiToiawaseSogiyoRyokinhyoShikiData tempRyokinhyo = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
            if(p.Product2.ShohinBango__c == 'SBG-0004001'){
                if(planShikiDataMap.containskey('直葬')){
                    tempRyokinhyo = planShikiDataMap.get('直葬');
                }

                tempRyokinhyo.setKaso(p.UnitPrice);
                planShikiDataMap.put('直葬', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003002'){
                if(planShikiDataMap.containskey('無宗教')){
                    tempRyokinhyo = planShikiDataMap.get('無宗教');
                }

                tempRyokinhyo.setKaso(p.UnitPrice);
                planShikiDataMap.put('無宗教', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003005'){
                if(planShikiDataMap.containskey('無宗教')){
                    tempRyokinhyo = planShikiDataMap.get('無宗教');
                }

                tempRyokinhyo.setIchinichi(p.UnitPrice);
                planShikiDataMap.put('無宗教', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003008'){
                if(planShikiDataMap.containskey('無宗教')){
                    tempRyokinhyo = planShikiDataMap.get('無宗教');
                }

                tempRyokinhyo.setKazoku(p.UnitPrice);
                planShikiDataMap.put('無宗教', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003011'){
                if(planShikiDataMap.containskey('無宗教')){
                    tempRyokinhyo = planShikiDataMap.get('無宗教');
                }

                tempRyokinhyo.setIppan(p.UnitPrice);
                planShikiDataMap.put('無宗教', tempRyokinhyo);
            }

            else if(p.Product2.ShohinBango__c == 'SBG-0003003'){
                if(planShikiDataMap.containskey('仏式')){
                    tempRyokinhyo = planShikiDataMap.get('仏式');
                }

                tempRyokinhyo.setKaso(p.UnitPrice);
                planShikiDataMap.put('仏式', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003006'){
                if(planShikiDataMap.containskey('仏式')){
                    tempRyokinhyo = planShikiDataMap.get('仏式');
                }

                tempRyokinhyo.setIchinichi(p.UnitPrice);
                planShikiDataMap.put('仏式', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003009'){
                if(planShikiDataMap.containskey('仏式')){
                    tempRyokinhyo = planShikiDataMap.get('仏式');
                }

                tempRyokinhyo.setKazoku(p.UnitPrice);
                planShikiDataMap.put('仏式', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003012'){
                if(planShikiDataMap.containskey('仏式')){
                    tempRyokinhyo = planShikiDataMap.get('仏式');
                }

                tempRyokinhyo.setIppan(p.UnitPrice);
                planShikiDataMap.put('仏式', tempRyokinhyo);
            }

            else if(p.Product2.ShohinBango__c == 'SBG-0003004'){
                if(planShikiDataMap.containskey('花束')){
                    tempRyokinhyo = planShikiDataMap.get('花束');
                }

                tempRyokinhyo.setKaso(p.UnitPrice);
                planShikiDataMap.put('花束', tempRyokinhyo);
            }

            else if(p.Product2.ShohinBango__c == 'SBG-0003007'){
                if(planShikiDataMap.containskey('お花増量')){
                    tempRyokinhyo = planShikiDataMap.get('お花増量');
                }

                tempRyokinhyo.setIchinichi(p.UnitPrice);
                planShikiDataMap.put('お花増量', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003010'){
                if(planShikiDataMap.containskey('お花増量')){
                    tempRyokinhyo = planShikiDataMap.get('お花増量');
                }

                tempRyokinhyo.setKazoku(p.UnitPrice);
                planShikiDataMap.put('お花増量', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003013'){
                if(planShikiDataMap.containskey('お花増量')){
                    tempRyokinhyo = planShikiDataMap.get('お花増量');
                }

                tempRyokinhyo.setIppan(p.UnitPrice);
                planShikiDataMap.put('お花増量', tempRyokinhyo);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000046'){
                planSoryoTehaiMap.put('火葬式', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000047'){
                planSoryoTehaiMap.put('一日葬', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000048'){
                planSoryoTehaiMap.put('家族葬', p.UnitPrice);
                planSoryoTehaiMap.put('一般葬', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000060'){
                planKaimyoHomyoMap.put('釋', p.UnitPrice);
                planKaimyoHomyoMap.put('釋尼', p.UnitPrice);
                planKaimyoHomyoMap.put('釋・釋尼', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000061'){
                planKaimyoHomyoMap.put('信士', p.UnitPrice);
                planKaimyoHomyoMap.put('信女', p.UnitPrice);
                planKaimyoHomyoMap.put('信士・信女', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000062'){
                planKaimyoHomyoMap.put('院信士', p.UnitPrice);
                planKaimyoHomyoMap.put('院信女', p.UnitPrice);
                planKaimyoHomyoMap.put('院信士・院信女', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000063'){
                planKaimyoHomyoMap.put('居士', p.UnitPrice);
                planKaimyoHomyoMap.put('大姉', p.UnitPrice);
                planKaimyoHomyoMap.put('居士・大姉', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000064'){
                planKaimyoHomyoMap.put('院釋', p.UnitPrice);
                planKaimyoHomyoMap.put('院釋尼', p.UnitPrice);
                planKaimyoHomyoMap.put('院釋・院釋尼', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000065'){
                planKaimyoHomyoMap.put('院日信士', p.UnitPrice);
                planKaimyoHomyoMap.put('院日信女', p.UnitPrice);
                planKaimyoHomyoMap.put('院日信士・院日信女', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0000066'){
                planKaimyoHomyoMap.put('院居士', p.UnitPrice);
                planKaimyoHomyoMap.put('院大姉', p.UnitPrice);
                planKaimyoHomyoMap.put('院居士・院大姉', p.UnitPrice);
            }
            else if(p.Product2.ShohinBango__c == 'SBG-0003020' || 
                    p.Product2.ShohinBango__c == 'SBG-0003021' || 
                    p.Product2.ShohinBango__c == 'SBG-0003022' || 
                    p.Product2.ShohinBango__c == 'SBG-0003024' || 
                    p.Product2.ShohinBango__c == 'SBG-0003025' || 
                    p.Product2.ShohinBango__c == 'SBG-0003026' || 
                    p.Product2.ShohinBango__c == 'SBG-0003027'){
                String n = p.Name.replace('【19.12】よりそうのお葬式 オプション ', '');
                standardOpt.add(new SelectOption(n, n));
                standardOptJson.put(n, n);
            }
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

        ShinkiToiawaseSogiyoRyokinhyoShikiData hiMember = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        hiMember.setKaso(0);
        hiMember.setIchinichi(0);
        hiMember.setKazoku(0);
        hiMember.setIppan(0);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberChokuD0 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberChokuD0.setKaso(pbMap.get('SBG-0003500').UnitPrice);
        jizenMemberChokuD0.setIchinichi(0);
        jizenMemberChokuD0.setKazoku(0);
        jizenMemberChokuD0.setIppan(0);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberD0 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberD0.setKaso(pbMap.get('SBG-0003501').UnitPrice);
        jizenMemberD0.setIchinichi(pbMap.get('SBG-0003505').UnitPrice);
        jizenMemberD0.setKazoku(pbMap.get('SBG-0003509').UnitPrice);
        jizenMemberD0.setIppan(pbMap.get('SBG-0003513').UnitPrice);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberHanatabaD0 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberHanatabaD0.setKaso(pbMap.get('SBG-0003501').UnitPrice);
        jizenMemberHanatabaD0.setIchinichi(0);
        jizenMemberHanatabaD0.setKazoku(0);
        jizenMemberHanatabaD0.setIppan(0);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberD30 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberD30.setKaso(pbMap.get('SBG-0003502').UnitPrice);
        jizenMemberD30.setIchinichi(pbMap.get('SBG-0003506').UnitPrice);
        jizenMemberD30.setKazoku(pbMap.get('SBG-0003510').UnitPrice);
        jizenMemberD30.setIppan(pbMap.get('SBG-0003514').UnitPrice);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberHanatabaD30 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberHanatabaD30.setKaso(pbMap.get('SBG-0003502').UnitPrice);
        jizenMemberHanatabaD30.setIchinichi(0);
        jizenMemberHanatabaD30.setKazoku(0);
        jizenMemberHanatabaD30.setIppan(0);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberY1 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberY1.setKaso(pbMap.get('SBG-0003503').UnitPrice);
        jizenMemberY1.setIchinichi(pbMap.get('SBG-0003507').UnitPrice);
        jizenMemberY1.setKazoku(pbMap.get('SBG-0003511').UnitPrice);
        jizenMemberY1.setIppan(pbMap.get('SBG-0003515').UnitPrice);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberHanatabaY1 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberHanatabaY1.setKaso(pbMap.get('SBG-0003503').UnitPrice);
        jizenMemberHanatabaY1.setIchinichi(0);
        jizenMemberHanatabaY1.setKazoku(0);
        jizenMemberHanatabaY1.setIppan(0);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberY2 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberY2.setKaso(pbMap.get('SBG-0003504').UnitPrice);
        jizenMemberY2.setIchinichi(pbMap.get('SBG-0003508').UnitPrice);
        jizenMemberY2.setKazoku(pbMap.get('SBG-0003512').UnitPrice);
        jizenMemberY2.setIppan(pbMap.get('SBG-0003516').UnitPrice);

        ShinkiToiawaseSogiyoRyokinhyoShikiData jizenMemberHanatabaY2 = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        jizenMemberHanatabaY2.setKaso(pbMap.get('SBG-0003504').UnitPrice);
        jizenMemberHanatabaY2.setIchinichi(0);
        jizenMemberHanatabaY2.setKazoku(0);
        jizenMemberHanatabaY2.setIppan(0);

        ShinkiToiawaseSogiyoRyokinhyoShikiData ososhikiMember = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        ososhikiMember.setKaso(pbMap.get('SBG-0003196').UnitPrice);
        ososhikiMember.setIchinichi(pbMap.get('SBG-0003197').UnitPrice);
        ososhikiMember.setKazoku(pbMap.get('SBG-0003198').UnitPrice);
        ososhikiMember.setIppan(pbMap.get('SBG-0003199').UnitPrice);

        ShinkiToiawaseSogiyoRyokinhyoShikiData ososhikiMemberHanataba = new ShinkiToiawaseSogiyoRyokinhyoShikiData();
        ososhikiMemberHanataba.setKaso(pbMap.get('SBG-0003196').UnitPrice);
        ososhikiMemberHanataba.setIchinichi(0);
        ososhikiMemberHanataba.setKazoku(0);
        ososhikiMemberHanataba.setIppan(0);

        planWaribikiDataMap = new Map<String, Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>>>{
            '非メンバー' => new Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>>{
                '直葬' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => hiMember,
                    'D30' => hiMember,
                    'Y1' => hiMember,
                    'Y2' => hiMember
                },
                '無宗教' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => hiMember,
                    'D30' => hiMember,
                    'Y1' => hiMember,
                    'Y2' => hiMember
                },
                '仏式' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => hiMember,
                    'D30' => hiMember,
                    'Y1' => hiMember,
                    'Y2' => hiMember
                },
                'お花増量' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => hiMember,
                    'D30' => hiMember,
                    'Y1' => hiMember,
                    'Y2' => hiMember
                },
                '花束' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => hiMember,
                    'D30' => hiMember,
                    'Y1' => hiMember,
                    'Y2' => hiMember
                }
            },
            '事前割メンバー' => new Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>>{
                '直葬' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => jizenMemberChokuD0,
                    'D30' => jizenMemberChokuD0,
                    'Y1' => jizenMemberChokuD0,
                    'Y2' => jizenMemberChokuD0
                },
                '無宗教' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => jizenMemberD0,
                    'D30' => jizenMemberD30,
                    'Y1' => jizenMemberY1,
                    'Y2' => jizenMemberY2
                },
                '仏式' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => jizenMemberD0,
                    'D30' => jizenMemberD30,
                    'Y1' => jizenMemberY1,
                    'Y2' => jizenMemberY2
                },
                'お花増量' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => jizenMemberD0,
                    'D30' => jizenMemberD30,
                    'Y1' => jizenMemberY1,
                    'Y2' => jizenMemberY2
                },
                '花束' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    'D0' => jizenMemberHanatabaD0,
                    'D30' => jizenMemberHanatabaD30,
                    'Y1' => jizenMemberHanatabaY1,
                    'Y2' => jizenMemberHanatabaY2
                }
            },
            'お葬式予約メンバー' => new Map<String, Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>>{
                '無宗教' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    '' => ososhikiMember
                },
                '仏式' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    '' => ososhikiMember
                },
                'お花増量' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    '' => ososhikiMember
                },
                '花束' => new Map<String, ShinkiToiawaseSogiyoRyokinhyoShikiData>{
                    '' => ososhikiMemberHanataba
                }
            }
        };
    }
}