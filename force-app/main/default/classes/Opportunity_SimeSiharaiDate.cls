public class Opportunity_SimeSiharaiDate {
    public void onOppAfterUpdate(List<Opportunity> newOnes, Map<ID, Opportunity> oldOnes){
        List<Opportunity> theEntriesToProcess = this.getEntriesToProcess(newOnes, oldOnes);
        List<Opportunity> theOppToProcess = this.reloadOpp( theEntriesToProcess );

        List<Opportunity> theOppsToBeUpdated = new List<Opportunity>();
        for(Opportunity aOpp : theOppToProcess){
            Date theNyukinShimeBiPartner = this.calcNyukinShimekiriBi(aOpp);
            Date theShiharaiKijitsuPartner = this.calcShiharaiKijitsu(aOpp);
            Boolean theIsToUpdate = false;

            if(aOpp.NyukinSimekiriBiPartner__c != theNyukinShimeBiPartner) theIsToUpdate = true;
            if(aOpp.ShiharaiKijitsuPartner__c != theShiharaiKijitsuPartner) theIsToUpdate = true;
            if(theIsToUpdate){
                theOppsToBeUpdated.add(
                    new Opportunity(
                        Id = aOpp.Id, 
                        NyukinSimekiriBiPartner__c = theNyukinShimeBiPartner,
                        ShiharaiKijitsuPartner__c = theShiharaiKijitsuPartner
                    )
                );
            }
        }
        update theOppsToBeUpdated;
    }

    @Future(callout=true)
    public static void setYorisoNoOsoshikiSimeShiharaiDate(Id oppId){
        Opportunity opp = [select Id, 
                                    IsWon, 
                                    ShodanBangoF__c, 
                                    SeikyuYoteiGakuPartnerExp__c, 
                                    SeikyushoHassoubiPartner__c, 
                                    Utiagebi__c, 
                                    SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, 
                                    NyukinSimekiriBiPartner__c
                            from Opportunity where Id = :oppId];

        if(opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c == null || 
            opp.NyukinSimekiriBiPartner__c != null || 
            (opp.SeikyushoHassoubiPartner__c == null && opp.Utiagebi__c == null)) {
            return;
        }

        Keiyaku__c keiyaku = [SELECT Id, NyukinSimekiriJouken__c FROM Keiyaku__c WHERE Id = :opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c];
        Map<Date, String> shukujitsuMap = ShukujitsuMapCreate.getShukujitsuMap();

        Date theNyukinShimeBiPartner = calcNyukinShimekiriBi(opp, keiyaku.NyukinSimekiriJouken__c);
        
        if(theNyukinShimeBiPartner == null) return;

        while(true){
            theNyukinShimeBiPartner = Ctl_Opportunity.slideDay(theNyukinShimeBiPartner);
            if(shukujitsuMap.containsKey(theNyukinShimeBiPartner)){
                theNyukinShimeBiPartner = theNyukinShimeBiPartner.addDays(1);
            }else{
                break;
            }
        }
        opp.NyukinSimekiriBiPartner__c = theNyukinShimeBiPartner;
        update opp;
    }

    private List<Opportunity> getEntriesToProcess(List<Opportunity> newOnes, Map<ID, Opportunity> oldOnes){
        List<Opportunity> theEntriesToProcess = new List<Opportunity>();
        for(Opportunity aNewOne : newOnes){
            Opportunity aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isToProcess(aNewOne, aOldOne) ) theEntriesToProcess.add(aNewOne);
        }
        return theEntriesToProcess;
    }

    private Boolean isToProcess(Opportunity pNewOne, Opportunity pOldOne){
        //if(pNewOne.StageName == pOldOne.StageName) return false;
        String theRecTypeName = RecordTypeCachedDaos.getInstance().SelectDeveloperNameById(pNewOne.RecordTypeId);
        List<String> theRecTypeNames = 
            new List<String>{ 'Obosanbin','PerpetualMemorial','KaiyoUmie' };
            
        if( !theRecTypeNames.contains(theRecTypeName) ) return false;
        if(pNewOne.Utiagebi__c != pOldOne.Utiagebi__c) return true;
        if(pNewOne.SeikyuYoteiGakuPartnerExp__c != pOldOne.SeikyuYoteiGakuPartnerExp__c) return true;
        if(pNewOne.ShiharaiYoteiGakuPartnerExp__c != pOldOne.ShiharaiYoteiGakuPartnerExp__c) return true;
        if(pNewOne.KetteiSakiRef__c != pOldOne.KetteiSakiRef__c) return true;
        return false;
    }

    private Date calcNyukinShimekiriBi(Opportunity aOpp){
        if(aOpp.Utiagebi__c == null || aOpp.SeikyuYoteiGakuPartnerExp__c <= 0) return null;
        String theRecTypeName = RecordTypeCachedDaos.getInstance().SelectDeveloperNameById(aOpp.RecordTypeId);
        if(theRecTypeName == 'Obosanbin'){
            if(aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c == null) return null;
            if(aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.NyukinSimekiriJouken__c == '月末締め翌月末') return aOpp.Utiagebi__c.addMonths(2).toStartOfMonth().addDays(-1);
            if(aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.NyukinSimekiriJouken__c == '月末締め翌月10日') return aOpp.Utiagebi__c.addMonths(1).toStartOfMonth().addDays(9);
            //その他の場合
            return aOpp.Utiagebi__c.addDays(3);
        }
        return null;
    }

    private static Date calcNyukinShimekiriBi(Opportunity aOpp, String nyukinJoken){
        if(aOpp.SeikyuYoteiGakuPartnerExp__c <= 0) return null;

        if(String.isBlank(nyukinJoken)) return null;

        //**請求書発送日から起算する場合
        if(nyukinJoken.startsWith('請求書発送日')) {
            if(aOpp.SeikyushoHassoubiPartner__c == null) return null;
            String pastDays = nyukinJoken.substringBetween('請求書発送日から', '日後');
            return aOpp.SeikyushoHassoubiPartner__c.addDays(Integer.valueOf(pastDays));
        }

        //**売上日から起算する場合
        if(aOpp.Utiagebi__c==null) return null;
        Integer addmonthsNum = 1; //翌月払いを基準
        Integer adddaysNum = -1;  //月末算出を基準(当月末)

        if(nyukinJoken.countMatches('締め') >= 2){
            if('当月1-20日締め翌月20日、当月21日-月末締め翌月末'.equals(nyukinJoken)){
                if(aOpp.Utiagebi__c.day() > 20){ //当月の締め日を過ぎていたら翌月の締めとして扱う
                    addmonthsNum = addmonthsNum + 1;
                }else{
                    adddaysNum = 20 - 1;
                }
            }else{
                return null;
            }
        }else{
            //支払い日の算出方法は共通
            //加算する月の計算
            addmonthsNum = calcAddMonths(nyukinJoken, aOpp.Utiagebi__c);
            adddaysNum = calcAddDays(nyukinJoken);

            if(!nyukinJoken.startsWith('当月20日締め') && !nyukinJoken.startsWith('月末締め')){
                return null;
            } 
        }

        return aOpp.Utiagebi__c.addMonths(addmonthsNum).toStartOfMonth().addDays(adddaysNum);
    }

    private static Integer calcAddMonths(String nyukinJoken,Date kijunDate){
        String shiharaiJoken = nyukinJoken.substringAfter('締め');
        Integer addmonthsNum = 1;
        if(shiharaiJoken.startsWith('翌々月')){
            addmonthsNum = addmonthsNum + 1;
        }
        //支払い日の末尾で処理を分ける
        if(shiharaiJoken.endsWith('末')){
            if(!shiharaiJoken.endsWith('当月末')){
                addmonthsNum = addmonthsNum + 1;
            }
        }
        //締め日を過ぎていたら次回の締めとして数える
        if( chkShimebi(nyukinJoken, kijunDate)) addmonthsNum = addmonthsNum + 1;

        return addmonthsNum;
    }

    private static Integer calcAddDays(String nyukinJoken){
        String shiharaiJoken = nyukinJoken.substringAfter('締め');
        Integer addDayNum = -1;
        if(shiharaiJoken.endsWith('日')){
            addDayNum = Integer.valueof(shiharaiJoken.substringBetween('月','日')) -1;
        }
        return addDayNum;
    }
    private static boolean chkShimebi(String nyukinJoken,Date kijunDate){
        if(nyukinJoken.startsWith('月末締め')){
            return false;
        }else{
            if(nyukinJoken.startsWith('当月20日締め')){
                Integer shimebi = Integer.valueOf(nyukinJoken.substringBefore('締め').substringBetween('当月', '日'));
                if(kijunDate.day() > shimebi) return true;
            }
        }
        return false;
    }

    private Date calcShiharaiKijitsu(Opportunity aOpp){
        if(aOpp.Utiagebi__c == null || aOpp.ShiharaiYoteiGakuPartnerExp__c <= 0) return null;
        String theRecTypeName = RecordTypeCachedDaos.getInstance().SelectDeveloperNameById(aOpp.RecordTypeId);
        if(theRecTypeName == 'Obosanbin'){
            if(aOpp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c == null) return null;
            return aOpp.Utiagebi__c.addMonths(2).toStartOfMonth().addDays(-1);
        }
        if(theRecTypeName == 'PerpetualMemorial'){
            if(aOpp.EitaiKuyoRef__r.KetteiJiin__c == null) return null;
            return aOpp.Utiagebi__c.addMonths(2).toStartOfMonth().addDays(-1);
        }
        if(theRecTypeName == 'KaiyoUmie'){
            if(aOpp.KaiyoSankotsuUmieRef__r.KetteiSogisha__c == null) return null;
            return aOpp.Utiagebi__c.addMonths(2).toStartOfMonth().addDays(-1);
        }
        return null;
    }

    private Map<Id,Keiyaku__c> getKeiyaku(Set<Id> keiyakuIdSet){
        return new Map<Id,Keiyaku__c>(
            [
                SELECT
                    ID
                    ,NyukinSimekiriJouken__c
                FROM Keiyaku__c
                WHERE ID in :keiyakuIdSet
            ]
        );
    }

    public List<Opportunity> reloadOpp(List<Opportunity> pOpps){
        if(pOpps.size() == 0) return new List<Opportunity>();
        List<Id> ids = SobjectsExtension.collectIds(pOpps);
        List<Opportunity> opps = [Select 
                                        Id, RecordTypeId, NyukinSimekiriBiPartner__c, ShiharaiKijitsuPartner__c, 
                                        Utiagebi__c, SeikyuYoteiGakuPartnerExp__c, KetteiSakiRef__c,
                                        ShiharaiYoteiGakuPartnerExp__c,
                                        ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__c, //お坊さん便契約(窓口)
                                        ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.NyukinSimekiriJouken__c, //お坊さん便契約(窓口)
                                        KaiyoSankotsuUmieRef__r.KetteiSogisha__c,  //決定葬儀社
                                        EitaiKuyoRef__r.KetteiJiin__c   //決定寺院
                                  From Opportunity Where id =: ids];


        return opps;
    }

}