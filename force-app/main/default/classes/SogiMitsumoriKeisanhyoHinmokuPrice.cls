public class SogiMitsumoriKeisanhyoHinmokuPrice {

    private SogiMitsumoriKeisanhyoHinmokuPrice(){}

    private static IPrice_Calculator m_IPrice_Calculator_instance = null;
    public static IPrice_Calculator get_IPrice_Calculator_instance(){
        if(m_IPrice_Calculator_instance == null) m_IPrice_Calculator_instance = new Price_Calculator();
        return m_IPrice_Calculator_instance;
    }

    public class HinmokuPrice {
        public Decimal kazoku1Nichi {get; set;}
        public Decimal kazoku2Nichi {get; set;}
        public Decimal kazokuHanayaka {get; set;}
        public Decimal kasoSimple {get; set;}
        public Decimal kasoKihon {get; set;}
        public Decimal kasoButsugu {get; set;}
        public Decimal kasoOhana {get; set;}
        public PriceBookEntry priceBookEntry {get; set;}

        public HinmokuPrice(){
            kazoku1Nichi = 0;
            kazoku2Nichi = 0;
            kazokuHanayaka = 0;
            kasoSimple = 0;
            kasoKihon = 0;
            kasoButsugu = 0;
            kasoOhana = 0;
            priceBookEntry = new PriceBookEntry();
        }
    }

    public enum Hinmoku{
        Plan, 
        ButsuguNashiWaribiki,
        JizenAnketoWaribiki,
        ShikigoAnketoWaribiki,
        KaiinWaribiki,
        SoryoTehai,
        KaimyoHomyo,
        SaidanUpGread,
        YorisoOption,
        AllianceWaribiki
    }

    @TestVisible public class OppData{
        public Hinmoku hinmoku;
        public String kaiinKubun;
        public String kaimyoHomyoKubun;
        public String shohinCode;
    }

    public interface IPrice_Calculator{
        Map<String, PricebookEntry> get_priceBookEntry_map();
        HinmokuPrice get_hinmoku_price(OppData p_opp_data);
    }

    public class Price_Calculator implements IPrice_Calculator{
        private Map<String, PricebookEntry> shohinCode_to_pricebookEntry_map = null;

        private void load_pricebook_entrys(){

            if(shohinCode_to_pricebookEntry_map != null) return;
            
            shohinCode_to_pricebookEntry_map = new Map<String, PricebookEntry>();

            for(PricebookEntry p : [
                select Id, 
                    Name, 
                    UnitPrice, 
                    Product2.ShohinBango__c, 
                    Product2.k_Service_Id_exp__c, 
                    Product2.k_ShohinSyubetsu_Id_exp__c, 
                    Product2.k_ShohinCategory_Id_exp__c, 
                    Product2.NameForCustomer__c 
                from PricebookEntry 
                where Pricebook2.IsStandard = true and 
                    Product2.isActive = true and 
                    Product2.k_Service_Id_exp__c in ('1','3') 
                order by Product2.ShohinBango__c
            ]){
                shohinCode_to_pricebookEntry_map.put(p.Product2.ShohinBango__c, p);
            }
        }

        public Map<String, PricebookEntry> get_priceBookEntry_map(){
            load_pricebook_entrys();
            return shohinCode_to_pricebookEntry_map;
        }

        public HinmokuPrice get_hinmoku_price(OppData p_opp_data){
            load_pricebook_entrys();
            HinmokuPrice hinmokuPrice = new HinmokuPrice();
            switch on p_opp_data.hinmoku {
                when Plan {
                    hinmokuPrice.kazoku1Nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005010') ? shohinCode_to_pricebookEntry_map.get('SBG-0005010').UnitPrice : 0;
                    hinmokuPrice.kazoku2Nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005011') ? shohinCode_to_pricebookEntry_map.get('SBG-0005011').UnitPrice : 0;
                    hinmokuPrice.kazokuHanayaka = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005012') ? shohinCode_to_pricebookEntry_map.get('SBG-0005012').UnitPrice : 0;
                    hinmokuPrice.kasoSimple = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005013') ? shohinCode_to_pricebookEntry_map.get('SBG-0005013').UnitPrice : 0;
                    hinmokuPrice.kasoKihon = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005014') ? shohinCode_to_pricebookEntry_map.get('SBG-0005014').UnitPrice : 0;
                    hinmokuPrice.kasoButsugu = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005015') ? shohinCode_to_pricebookEntry_map.get('SBG-0005015').UnitPrice : 0;
                    hinmokuPrice.kasoOhana = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005016') ? shohinCode_to_pricebookEntry_map.get('SBG-0005016').UnitPrice : 0;
                }
                when KaiinWaribiki {
                    switch on p_opp_data.kaiinKubun {
                        when 'よりそう会員' {
                            hinmokuPrice.kazoku1nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005216') ? shohinCode_to_pricebookEntry_map.get('SBG-0005216').UnitPrice : 0;
                            hinmokuPrice.kazoku2nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005217') ? shohinCode_to_pricebookEntry_map.get('SBG-0005217').UnitPrice : 0;
                            hinmokuPrice.kazokuhanayaka = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005218') ? shohinCode_to_pricebookEntry_map.get('SBG-0005218').UnitPrice : 0;
                            hinmokuPrice.kasoSimple = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005219') ? shohinCode_to_pricebookEntry_map.get('SBG-0005219').UnitPrice : 0;
                            hinmokuPrice.kasoKihon = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005220') ? shohinCode_to_pricebookEntry_map.get('SBG-0005220').UnitPrice : 0;
                            hinmokuPrice.kasoButsugu = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005221') ? shohinCode_to_pricebookEntry_map.get('SBG-0005221').UnitPrice : 0;
                            hinmokuPrice.kasoOhana = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005222') ? shohinCode_to_pricebookEntry_map.get('SBG-0005222').UnitPrice : 0;
                        }
                        when '旧よりそう会員' {
                            hinmokuPrice.kazoku1nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005226') ? shohinCode_to_pricebookEntry_map.get('SBG-0005226').UnitPrice : 0;
                            hinmokuPrice.kazoku2nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005227') ? shohinCode_to_pricebookEntry_map.get('SBG-0005227').UnitPrice : 0;
                            hinmokuPrice.kazokuhanayaka = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005228') ? shohinCode_to_pricebookEntry_map.get('SBG-0005228').UnitPrice : 0;
                            hinmokuPrice.kasoSimple = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005229') ? shohinCode_to_pricebookEntry_map.get('SBG-0005229').UnitPrice : 0;
                            hinmokuPrice.kasoKihon = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005230') ? shohinCode_to_pricebookEntry_map.get('SBG-0005230').UnitPrice : 0;
                            hinmokuPrice.kasoButsugu = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005231') ? shohinCode_to_pricebookEntry_map.get('SBG-0005231').UnitPrice : 0;
                            hinmokuPrice.kasoOhana = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005232') ? shohinCode_to_pricebookEntry_map.get('SBG-0005232').UnitPrice : 0;
                        }
                        when 'お葬式予約会員' {
                            hinmokuPrice.kazoku1nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005233') ? shohinCode_to_pricebookEntry_map.get('SBG-0005233').UnitPrice : 0;
                            hinmokuPrice.kazoku2nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005234') ? shohinCode_to_pricebookEntry_map.get('SBG-0005234').UnitPrice : 0;
                            hinmokuPrice.kazokuhanayaka = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005235') ? shohinCode_to_pricebookEntry_map.get('SBG-0005235').UnitPrice : 0;
                            hinmokuPrice.kasoSimple = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005236') ? shohinCode_to_pricebookEntry_map.get('SBG-0005236').UnitPrice : 0;
                            hinmokuPrice.kasoKihon = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005237') ? shohinCode_to_pricebookEntry_map.get('SBG-0005237').UnitPrice : 0;
                            hinmokuPrice.kasoButsugu = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005238') ? shohinCode_to_pricebookEntry_map.get('SBG-0005238').UnitPrice : 0;
                            hinmokuPrice.kasoOhana = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005239') ? shohinCode_to_pricebookEntry_map.get('SBG-0005239').UnitPrice : 0;
                        }
                    }
                }
                when ButsuguNashiWaribiki { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005225') ? shohinCode_to_pricebookEntry_map.get('SBG-0005225') : new PriceBookEntry(); }
                when JizenAnketoWaribiki { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005223') ? shohinCode_to_pricebookEntry_map.get('SBG-0005223') : new PriceBookEntry(); }
                when ShikigoAnketoWaribiki { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005224') ? shohinCode_to_pricebookEntry_map.get('SBG-0005224') : new PriceBookEntry(); }
                when SoryoTehai { 
                    hinmokuPrice.kazoku1nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000047') ? shohinCode_to_pricebookEntry_map.get('SBG-0000047').UnitPrice : 0;
                    hinmokuPrice.kazoku2nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000048') ? shohinCode_to_pricebookEntry_map.get('SBG-0000048').UnitPrice : 0;
                    hinmokuPrice.kazokuhanayaka = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000048') ? shohinCode_to_pricebookEntry_map.get('SBG-0000048').UnitPrice : 0;
                    hinmokuPrice.kasoSimple = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000046') ? shohinCode_to_pricebookEntry_map.get('SBG-0000046').UnitPrice : 0;
                    hinmokuPrice.kasoKihon = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000046') ? shohinCode_to_pricebookEntry_map.get('SBG-0000046').UnitPrice : 0;
                    hinmokuPrice.kasoButsugu = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000046') ? shohinCode_to_pricebookEntry_map.get('SBG-0000046').UnitPrice : 0;
                    hinmokuPrice.kasoOhana = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000046') ? shohinCode_to_pricebookEntry_map.get('SBG-0000046').UnitPrice : 0;
                }
                when KaimyoHomyo {
                    switch on p_opp_data.kaimyoHomyoKubun {
                        when '釋', '釋尼', '釋・釋尼' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000060') ? shohinCode_to_pricebookEntry_map.get('SBG-0000060') : new PriceBookEntry(); }
                        when '信士', '信女', '信士・信女' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000061') ? shohinCode_to_pricebookEntry_map.get('SBG-0000061') : new PriceBookEntry(); }
                        when '院信士', '院信女', '院信士・院信女' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000062') ? shohinCode_to_pricebookEntry_map.get('SBG-0000062') : new PriceBookEntry(); }
                        when '居士', '大姉', '居士・大姉' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000063') ? shohinCode_to_pricebookEntry_map.get('SBG-0000063') : new PriceBookEntry(); }
                        when '院釋', '院釋尼', '院釋・院釋尼' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000064') ? shohinCode_to_pricebookEntry_map.get('SBG-0000064') : new PriceBookEntry(); }
                        when '院日信士', '院日信女', '院日信士・院日信女' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000065') ? shohinCode_to_pricebookEntry_map.get('SBG-0000065') : new PriceBookEntry(); }
                        when '院居士', '院大姉', '院居士・院大姉' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0000066') ? shohinCode_to_pricebookEntry_map.get('SBG-0000066') : new PriceBookEntry(); }
                    }
                }
                when SaidanUpGread {
                    switch on p_opp_data.shohinCode {
                        when 'SBG-0005401' { hinmokuPrice.kazoku1Nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005401') ? shohinCode_to_pricebookEntry_map.get('SBG-0005401').UnitPrice : 0; }
                        when 'SBG-0005402' { hinmokuPrice.kazoku1Nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005402') ? shohinCode_to_pricebookEntry_map.get('SBG-0005402').UnitPrice : 0; }
                        when 'SBG-0005403' { hinmokuPrice.kazoku1Nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005403') ? shohinCode_to_pricebookEntry_map.get('SBG-0005403').UnitPrice : 0; }
                        when 'SBG-0005404' { hinmokuPrice.kazoku2Nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005404') ? shohinCode_to_pricebookEntry_map.get('SBG-0005404').UnitPrice : 0; }
                        when 'SBG-0005405' { hinmokuPrice.kazoku2Nichi = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005405') ? shohinCode_to_pricebookEntry_map.get('SBG-0005405').UnitPrice : 0; }
                        when 'SBG-0005406' { hinmokuPrice.kazokuHanayaka = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005406') ? shohinCode_to_pricebookEntry_map.get('SBG-0005406').UnitPrice : 0; }
                    }
                }
                when YorisoOption {
                    switch on p_opp_data.shohinCode {
                        when 'SBG-0005407' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005407') ? shohinCode_to_pricebookEntry_map.get('SBG-0005407') : new PriceBookEntry(); }
                        when 'SBG-0005408' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005408') ? shohinCode_to_pricebookEntry_map.get('SBG-0005408') : new PriceBookEntry(); }
                        when 'SBG-0005409' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005409') ? shohinCode_to_pricebookEntry_map.get('SBG-0005409') : new PriceBookEntry(); }
                        when 'SBG-0005410' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005410') ? shohinCode_to_pricebookEntry_map.get('SBG-0005410') : new PriceBookEntry(); }
                        when 'SBG-0005411' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005411') ? shohinCode_to_pricebookEntry_map.get('SBG-0005411') : new PriceBookEntry(); }
                        when 'SBG-0005412' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005412') ? shohinCode_to_pricebookEntry_map.get('SBG-0005412') : new PriceBookEntry(); }
                        when 'SBG-0005413' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005413') ? shohinCode_to_pricebookEntry_map.get('SBG-0005413') : new PriceBookEntry(); }
                        when 'SBG-0005414' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005414') ? shohinCode_to_pricebookEntry_map.get('SBG-0005414') : new PriceBookEntry(); }
                        when 'SBG-0005415' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005415') ? shohinCode_to_pricebookEntry_map.get('SBG-0005415') : new PriceBookEntry(); }
                        when 'SBG-0005416' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005416') ? shohinCode_to_pricebookEntry_map.get('SBG-0005416') : new PriceBookEntry(); }
                        when 'SBG-0005417' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005417') ? shohinCode_to_pricebookEntry_map.get('SBG-0005417') : new PriceBookEntry(); }
                        when 'SBG-0005418' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005418') ? shohinCode_to_pricebookEntry_map.get('SBG-0005418') : new PriceBookEntry(); }
                        when 'SBG-0005419' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0005419') ? shohinCode_to_pricebookEntry_map.get('SBG-0005419') : new PriceBookEntry(); }
                    }
                }
                when AllianceWaribiki {
                    switch on p_opp_data.shohinCode {
                        when 'SBG-0003537' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0003537') ? shohinCode_to_pricebookEntry_map.get('SBG-0003537') : new PriceBookEntry(); }
                        when 'SBG-0003620' { hinmokuPrice.priceBookEntry = shohinCode_to_pricebookEntry_map.containsKey('SBG-0003620') ? shohinCode_to_pricebookEntry_map.get('SBG-0003620') : new PriceBookEntry(); }
                    }
                }
            }

            return hinmokuPrice;
        }
    }
}