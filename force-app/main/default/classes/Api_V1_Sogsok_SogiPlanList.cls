@RestResource(urlMapping='/api/v1/sogsok/sogiplanlist/*')
global class Api_V1_Sogsok_SogiPlanList {

    public class SogiPlan{
        public String code = '';
        public String label = '';
        public String service_id = '';
        public Decimal unit_price = 0;
    }

    @Testvisible
    private static List<SogiPlan>  getEntries(String theShodanBango){

        System.debug('theShodanBango:' + theShodanBango);

        List<Product2> productList = new List<Product2>();
        List<SogiPlan> theEntries = new List<SogiPlan>();
        if(theShodanBango != null && theShodanBango != ''){
            List<OpportunityLineItem> sogiPlanItem = [Select Id, Product2.HanbaiKaishiBi__c, Opportunity.KakuteibiSyodan__c from OpportunityLineItem where Product2.k_Service_Id_exp__c in ('1','2') and Product2.k_ShohinSyubetsu_Id_exp__c = '1' and Opportunity.ShodanBango__c = :theShodanBango];
            if(sogiPlanItem.size() != 1){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20191018-1121-01', 'Api_V1_Sogsok_SogiPlanList')
                        .putAttr( 'Pertner Web 葬儀プランリスト取得エラー', '商談番号：' + theShodanBango )
                );
                return theEntries;
            }

            OpportunityLineItem sogiPlanData = sogiPlanItem.get(0);
            if(sogiPlanData.Opportunity.KakuteibiSyodan__c.addHours(9) < datetime.newInstance(2021, 3, 1, 12, 00, 00)){
                productList = [select 
                                    ShohinBango__c, 
                                    Name, 
                                    k_Service_Id_exp__c, 
                                    SireKingaku__c, 
                                    NameForCustomerExp__c 
                                from Product2 
                                where k_Service_Id_exp__c in ('1','2') and 
                                    k_ShohinSyubetsu_Id_exp__c = '1' and 
                                    IsActive = true and 
                                    HanbaiKaishiBi__c >= 2020-11-01 and 
                                    (LatestFlg__c = true or ShohinBango__c in ('SBG-0005006', 'SBG-0005007')) and //旧直葬、旧一日葬
                                    ShohinBango__c not in ('SBG-0005004', 'SBG-0005008', 'SBG-0005009') //新直葬、新一日葬、新シンプル
                                order by SireKingaku__c];
            }
            else{
                if(sogiPlanData.Product2.HanbaiKaishiBi__c >= date.newInstance(2020, 11, 1)){
                    productList = [select ShohinBango__c, Name, k_Service_Id_exp__c, SireKingaku__c, NameForCustomerExp__c from Product2 where k_Service_Id_exp__c in ('1','2') and k_ShohinSyubetsu_Id_exp__c = '1' and IsActive = true and HanbaiKaishiBi__c >= 2020-11-01 and LatestFlg__c = true order by SireKingaku__c];
                }
                else if(sogiPlanData.Product2.HanbaiKaishiBi__c >= date.newInstance(2019, 12, 1)){
                    if(sogiPlanData.Opportunity.KakuteibiSyodan__c >= datetime.newInstance(2020, 6, 11, 16, 00, 00)){
                        productList = [select ShohinBango__c, Name, k_Service_Id_exp__c, SireKingaku__c, NameForCustomerExp__c from Product2 where k_Service_Id_exp__c in ('1','2') and k_ShohinSyubetsu_Id_exp__c = '1' and IsActive = true and HanbaiKaishiBi__c >= 2019-12-01 and ShohinBango__c != 'SBG-0003001' order by SireKingaku__c];
                    }
                    else{
                        productList = [select ShohinBango__c, Name, k_Service_Id_exp__c, SireKingaku__c, NameForCustomerExp__c from Product2 where k_Service_Id_exp__c in ('1','2') and k_ShohinSyubetsu_Id_exp__c = '1' and IsActive = true and HanbaiKaishiBi__c >= 2019-12-01 and ShohinBango__c != 'SBG-0004001' order by SireKingaku__c];
                    }
                }
                else if(sogiPlanData.Product2.HanbaiKaishiBi__c >= date.newInstance(2019, 9, 30) && sogiPlanData.Product2.HanbaiKaishiBi__c < date.newInstance(2019, 12, 1)){
                    productList = [select ShohinBango__c, Name, k_Service_Id_exp__c, SireKingaku__c, NameForCustomerExp__c from Product2 where k_Service_Id_exp__c in ('1','2') and k_ShohinSyubetsu_Id_exp__c = '1' and IsActive = true and HanbaiKaishiBi__c >= 2019-09-30 and HanbaiKaishiBi__c < 2019-12-01 order by ShohinBango__c];
                }
                else{
                    productList = [select ShohinBango__c, Name, k_Service_Id_exp__c, SireKingaku__c, NameForCustomerExp__c from Product2 where k_Service_Id_exp__c in ('1','2') and k_ShohinSyubetsu_Id_exp__c = '1' and IsActive = true and HanbaiKaishiBi__c < 2019-09-30 order by ShohinBango__c];
                }
            }
        }
        else{
            productList = [select ShohinBango__c, Name, k_Service_Id_exp__c, SireKingaku__c, NameForCustomerExp__c from Product2 where k_Service_Id_exp__c in ('1','2') and k_ShohinSyubetsu_Id_exp__c = '1' and IsActive = true order by ShohinBango__c];
        }

        for(Product2 p : productList ){
            SogiPlan theEntrie = new SogiPlan();
            theEntrie.code = p.ShohinBango__c;
            theEntrie.label = p.NameForCustomerExp__c;
            theEntrie.service_id = p.k_Service_Id_exp__c;
            theEntrie.unit_price = p.SireKingaku__c;
            theEntries.add(theEntrie);
        }
        return theEntries;
    }

    @HttpGet
    global static void doGet(){

    	RestRequest theReq = RestContext.request;
        System.debug('theReq:' + theReq);
        RestResponse theRes = RestContext.response;
        String theShodanBango = theReq.params.get('opp_code');
        theRes.addHeader('Content-Type', 'application/json');

        List<SogiPlan> theEntries = getEntries(theShodanBango);
        theRes.responseBody = Blob.valueOf(JSON.serialize(theEntries));
    }
}