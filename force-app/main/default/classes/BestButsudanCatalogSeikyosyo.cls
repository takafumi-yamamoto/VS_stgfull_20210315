/**
* クラス名      :   BestButsudanCatalogSeikyosyo
* クラス概要     :   ベスト仏壇カタログ請求書作成コントローラ
* @created  :   2019/04/15
* @modified :   
*/
public with sharing class BestButsudanCatalogSeikyosyo {
    String shodanId;
    public String shodanBango {get;set;}
    public String bestButsudanseikyosyoId {get;set;}
    public String furiganaChkFlg {get;set;}
    public String addrChkFlg {get;set;}
    public String chumonIdChkFlg {get;set;}
    
    public BestButsudanCatalogSeikyosyo(ApexPages.StandardController controller) {
        shodanId = controller.getId();
        furiganaChkFlg = 'false';
        addrChkFlg = 'false';
        chumonIdChkFlg = 'false';

        Opportunity opp = [
                            select Id
                                    ,ShodanBango__c
                                    ,Account.NameFurigana__c
                                    ,Account.BillingPostalCode
                                    ,Account.BillingState
                                    ,Account.BillingCity
                                    ,Account.BillingStreet                           
                                    ,SubPhase__c                                 
                                    ,BestButsudanRef__r.ChumonId__c                                 
                                    from Opportunity where id = :shodanId
                        ];

        if(opp.Account.NameFurigana__c == null){
            furiganaChkFlg = 'true';
        }
        if(opp.Account.BillingPostalCode == null || opp.Account.BillingState == null 
        || opp.Account.BillingCity == null || opp.Account.BillingStreet == null){
            addrChkFlg = 'true';
        }
        if(opp.BestButsudanRef__r.ChumonId__c  == null){
            chumonIdChkFlg = 'true';
        }
        shodanBango = opp.ShodanBango__c;
    }
    public PageReference createBestButsudanSeikyusyo(){

        Opportunity searchResultOpportunity = searchOppByShodanId(shodanId);

        if(searchResultOpportunity!=null){
            BestButsudanSeikyusyo__c bs = putBestButsudanSeikyusyo(searchResultOpportunity);
            insert bs;
            bestButsudanseikyosyoId = bs.Id;
            
            putBestButsudanSeikyusyoMeisai(searchResultOpportunity,bs.Id);
        }
 
        return null;
    }
    private Opportunity searchOppByShodanId(String shodanId){
        List<Opportunity> oppList = [
                            select Id
                                    ,ShodanBango__c
                                    ,Account.Name
                                    ,Account.NameFurigana__c
                                    ,Account.Phone
                                    ,Account.MobilePhone__c
                                    ,Account.Fax
                                    ,Account.BillingPostalCode
                                    ,Account.BillingState
                                    ,Account.BillingCity
                                    ,Account.BillingStreet                             
                                    ,SubPhase__c                                 
                                    ,BestButsudanRef__r.ChumonId__c                                 
                                    ,(SELECT Id,OpportunityId,Product2.NameForCustomerExp__c,Product2.Color__c,Product2.Size__c,Product2.ShohinBango__c,Quantity,UnitPrice,TotalPrice FROM OpportunityLineItems)
                                from Opportunity where id = :shodanId
        ];
        Opportunity returnOpp = null;
        if(oppList.size() > 0){
            returnOpp = oppList.get(0);
        }
        return returnOpp;
    }
    private BestButsudanSeikyusyo__c putBestButsudanSeikyusyo(Opportunity anOpportunity){
        BestButsudanSeikyusyo__c bs = new BestButsudanSeikyusyo__c();
        bs.ShodanNumber__c = anOpportunity.ShodanBango__c;
        bs.TorihikisakiName__c = anOpportunity.Account.Name;
        bs.SodanshaFurigana__c	 = anOpportunity.Account.NameFurigana__c;
        bs.Phone__c = anOpportunity.Account.Phone;
        bs.MobilePhone__c = anOpportunity.Account.MobilePhone__c;
        bs.Fax__c = anOpportunity.Account.Fax;
        bs.SeikyuSakiAddrPostalCode__c = anOpportunity.Account.BillingPostalCode;
        bs.SeikyuSakiAddrState__c = anOpportunity.Account.BillingState;
        bs.SeikyuSakiAddrCity__c = anOpportunity.Account.BillingCity;
        bs.SeikyuSakiAddrStreet__c = anOpportunity.Account.BillingStreet;
        //bs.SubPhase__c = anOpportunity.SubPhase__c; //TODO 必要か確認中
        bs.ChumonId__c = anOpportunity.BestButsudanRef__r.ChumonId__c;

        return bs;
    }

    private void putBestButsudanSeikyusyoMeisai(Opportunity anOpportunity,Id bestButsudanSeikyushoId){
        List<BestButsudanSeikyusyoMeisai__c> insertBsmList = new List<BestButsudanSeikyusyoMeisai__c>();
        for(OpportunityLineItem olineitem:anOpportunity.OpportunityLineItems){
            BestButsudanSeikyusyoMeisai__c bm = new BestButsudanSeikyusyoMeisai__c();
            bm.BestButsudanSeikyusyo__c = bestButsudanSeikyushoId;
            bm.ChumonBango__c = olineitem.Product2.ShohinBango__c;
            bm.ShohinMei__c = olineitem.Product2.NameForCustomerExp__c;
            bm.Color__c = olineitem.Product2.Color__c;
            bm.Size__c = olineitem.Product2.Size__c;
            bm.Suryo__c = olineitem.Quantity;
            bm.Tanka__c = olineitem.UnitPrice;
            if(bm.Suryo__c!=null && bm.Tanka__c!=null) bm.Kingaku__c = olineitem.Quantity*olineitem.UnitPrice;
            

            insertBsmList.add(bm);
        }
        
        insert(insertBsmList);

        return;
    }
}