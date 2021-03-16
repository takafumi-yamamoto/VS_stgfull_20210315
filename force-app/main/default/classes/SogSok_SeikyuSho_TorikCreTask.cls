public class SogSok_SeikyuSho_TorikCreTask implements Queueable{
    //logic result
    public class CreationTaskResult{
        public Boolean isSuccess = false;
    }
    public class TorikomiShoriException extends Exception{}

    public SogSok_SeikyuSho_TorikCreTask(){}

    public CreationTaskResult run(Id pSogSokSeikyuShoId){

        SogSok_SeikyuSho__c theSogSokSeikyuSho =  (SogSok_SeikyuSho__c)SobjectsExtension.firstOrNull(
            [
                select Id, SokyakuBango__c, ShodanBango__c,
                JuryoDateTime__c,
                SodanSha_TorihikiSakiBango__c, 
                SodanSha_Sei__c, SodanSha_Mei__c, 
                TaishoSha_TorihikiSakiBango__c, 
                TaishoSha_Sei__c, TaishoSha_Mei__c, 
                TaishoSha_BirthDate__c, TaishoSha_DeathDate__c, TaishoSha_Age__c, TaishoSha_Gender__c, 
                Taishosha_Addr_PostalCode__c, TaishoSha_Addr_State__c, TaishoSha_Addr_City__c, TaishoSha_Addr_Street__c, 
                TaishoSha_JumHyo_State__c, TaishoSha_JumHyo_City__c, 
                TaishoSha_Shuha__c, TaishoSha_Shuha_Sonota__c, TaishoSha_Bodaiji_Umu__c, 
                Moshu_TorihikiSakiBango__c, 
                Moshu_Sei__c, Moshu_Mei__c, Moshu_SeiKana__c, Moshu_MeiKana__c,
                Moshu_BirthDate__c, Moshu_Gender__c,
                Moshu_Mobile__c, Moshu_Phone__c,
                Moshu_Addr_PostalCode__c, Moshu_Addr_State__c, Moshu_Addr_City__c, Moshu_Addr_Street__c,
                Moshu_ZokugaraFromSoudanSha__c, 
                SoukyakuSaki_Tantosha_Name__c, 
                Sogi_TsuyaDateTime__c, Sogi_KokubetsuDateTime__c, Sogi_ShukkanDateTime__c, Sogi_KasoDateTime__c, 
                Sogi_Shikijo_Name__c,
                Sogi_Kasoba_Name__c,
                SogiPlan_ShohinBango__c, SogiPlan_Amount__c,
                SoryoTehai__c, SoryoTehai_Kaimyo__c, 
                ShiharaiSha_Name__c, ShiharaiSha_Mail__c,
                ShiharaiSha_Addr_PostalCode__c, ShiharaiSha_Addr_State__c, ShiharaiSha_Addr_City__c, ShiharaiSha_Addr_Street__c,
                ShiharaiSha_RyosyuAtena__c,
                Shiharai_GenkinKingaku__c,
                (
                    select HinmokuBunrui__c, Amount__c, ShohinBango__c, Quantity__c, UnitPrice__c 
                    from SogSok_Seikyusho_TsuikaHinLines__r
                ),
                (
                    select ShohinBango__c, Quantity__c, UnitPrice__c, Amount__c
                    from SogSok_Seikyusho_WaribikiLines__r
                )
                from SogSok_SeikyuSho__c where Id = :pSogSokSeikyuShoId
                limit 1
            ]
        );
        if( theSogSokSeikyuSho == null ){
            CreationTaskResult theResult = new CreationTaskResult();
            theResult.isSuccess = true;
            return theResult;
        }

        SogSok_Sokyaku__c theSogSokSokyaku = (SogSok_Sokyaku__c)SobjectsExtension.firstOrNull(
            [
                select Id,
                OpportunityRef__c,
                OpportunityRef__r.AccountId,
                OpportunityRef__r.Account.TorihikisakiBango__c,
                OpportunityRef__r.SimpleYasugoRef__r.TaishoshaRef__c,
                OpportunityRef__r.SimpleYasugoRef__r.TaishoshaRef__r.TorihikisakiBango__c,
                OpportunityRef__r.SimpleYasugoRef__r.MoshuRef__c,
                OpportunityRef__r.SimpleYasugoRef__r.MoshuRef__r.TorihikisakiBango__c,
                SokyakuShoRef__r.SogiPlan_ShohinBango__c
                from SogSok_Sokyaku__c
                where Name = :theSogSokSeikyuSho.SokyakuBango__c
                limit 1
            ]
        );
        if( theSogSokSokyaku == null ){
            CreationTaskResult theResult = new CreationTaskResult();
            theResult.isSuccess = true;
            return theResult;
        }

        List<OpportunityLineItem> sogiPlanItem = [Select Id, 
                                                        Product2.HanbaiKaishiBi__c 
                                                    from OpportunityLineItem 
                                                    where Product2.k_Service_Id_exp__c in ('1','2') 
                                                        and Product2.k_ShohinSyubetsu_Id_exp__c = '1' 
                                                        and Opportunity.Id = :theSogSokSokyaku.OpportunityRef__c];

        SogSok_SeikyuSho_Torik__c thTorik = new SogSok_SeikyuSho_Torik__c();
        thTorik.Status__c = '未取込';
        thTorik.SeikyuShoRef__c = theSogSokSeikyuSho.Id;
        thTorik.syop_Ref__c = theSogSokSokyaku.OpportunityRef__c;

        //喪主
        thTorik.syop_Moshu_Sei__c = theSogSokSeikyuSho.Moshu_Sei__c;
        thTorik.syop_Moshu_Mei__c = theSogSokSeikyuSho.Moshu_Mei__c;
        thTorik.syop_Moshu_SeiKana__c = theSogSokSeikyuSho.Moshu_SeiKana__c;
        thTorik.syop_Moshu_MeiKana__c = theSogSokSeikyuSho.Moshu_MeiKana__c;
        thTorik.syop_Moshu_BirthDate__c = theSogSokSeikyuSho.Moshu_BirthDate__c;
        thTorik.syop_Moshu_Gender__c = new SogSok_Gender().tryGetCustomerAccountGender(theSogSokSeikyuSho.Moshu_Gender__c);
        thTorik.syop_Moshu_Mobile__c = theSogSokSeikyuSho.Moshu_Mobile__c;
        thTorik.syop_Moshu_Phone__c = theSogSokSeikyuSho.Moshu_Phone__c;
        thTorik.syop_Moshu_Addr_PostalCode__c = theSogSokSeikyuSho.Moshu_Addr_PostalCode__c;
        thTorik.syop_Moshu_Addr_State__c = theSogSokSeikyuSho.Moshu_Addr_State__c;
        thTorik.syop_Moshu_Addr_City__c = theSogSokSeikyuSho.Moshu_Addr_City__c;
        thTorik.syop_Moshu_Addr_Street__c = theSogSokSeikyuSho.Moshu_Addr_Street__c;
        thTorik.syop_MoshuZokugaraFromSoudanSha__c = 
            new SogSok_Zokugara().tryGetSimpleYasugoTaishoshaZokugara(theSogSokSeikyuSho.Moshu_ZokugaraFromSoudanSha__c);

        //葬儀
        thTorik.syop_TsuyaDateTime__c = theSogSokSeikyuSho.Sogi_TsuyaDateTime__c;
        thTorik.syop_KokubetsuDateTime__c = theSogSokSeikyuSho.Sogi_KokubetsuDateTime__c;
        thTorik.syop_ShukkanDateTime__c = theSogSokSeikyuSho.Sogi_ShukkanDateTime__c;
        thTorik.syop_KasoDateTime__c = theSogSokSeikyuSho.Sogi_KasoDateTime__c;

        //支払
        thTorik.syop_GenkinKingaku__c = theSogSokSeikyuSho.Shiharai_GenkinKingaku__c;
        
        Insert thTorik;

        //商品ライン
        List<SogSok_SeikyuSho_TorikShohin__c> theShohinLines = new List<SogSok_SeikyuSho_TorikShohin__c>();
        //商品ライン / プランと割引
        Set<String> theShohinCodes = new Set<String>{theSogSokSeikyuSho.SogiPlan_ShohinBango__c};
        for(SogSok_Seikyusho_WaribikiLine__c aWrbLine : theSogSokSeikyuSho.SogSok_Seikyusho_WaribikiLines__r){
            theShohinCodes.add(aWrbLine.ShohinBango__c);
        }
        List<Product2> theProds = [
            select Id, ShohinBango__c, k_Service_Id_exp__c from Product2 where ShohinBango__c = : new List<String>(theShohinCodes)
        ];
        Map<String,Product2> theMapOfShohinBangoToProduct = new Map<String,Product2>();
        for(Product2 aProd : theProds){
            theMapOfShohinBangoToProduct.put(aProd.ShohinBango__c, aProd);
        }
        if( !String.isBlank(theSogSokSeikyuSho.SogiPlan_ShohinBango__c) ){
            theShohinLines.add(
                new SogSok_SeikyuSho_TorikShohin__c(
                    SogSok_SeikyuSho_TorikRef__c = thTorik.Id,
                    ShohinRef__c = theMapOfShohinBangoToProduct.get(theSogSokSeikyuSho.SogiPlan_ShohinBango__c).Id,
                    Quantity__c = 1,
                    UnitPrice__c = theSogSokSeikyuSho.SogiPlan_Amount__c,
                    Amount__c = theSogSokSeikyuSho.SogiPlan_Amount__c
                )
            );
        }
        
        for(SogSok_Seikyusho_WaribikiLine__c aWrbLine : theSogSokSeikyuSho.SogSok_Seikyusho_WaribikiLines__r){
            theShohinLines.add(
                new SogSok_SeikyuSho_TorikShohin__c(
                    SogSok_SeikyuSho_TorikRef__c = thTorik.Id,
                    ShohinRef__c = theMapOfShohinBangoToProduct.get(aWrbLine.ShohinBango__c).Id,
                    Quantity__c = aWrbLine.Quantity__c,
                    UnitPrice__c = aWrbLine.UnitPrice__c,
                    Amount__c = aWrbLine.Amount__c
                )
            );
        }
        
        //商品ライン / 追加品目
        for(SogSok_Seikyusho_TsuikaHinLine__c aLine : theSogSokSeikyuSho.SogSok_Seikyusho_TsuikaHinLines__r){
            SogSok_SeikyuSho_TorikShohin__c tempSeikyuShoTorikShohin = new SogSok_SeikyuSho_TorikShohin__c();
            tempSeikyuShoTorikShohin.SogSok_SeikyuSho_TorikRef__c = thTorik.Id;
            tempSeikyuShoTorikShohin.ShohinRef__c = Sogsok_TsuikaHinBunrui_201101.getProduct(aLine.ShohinBango__c).Id;
            tempSeikyuShoTorikShohin.Quantity__c = aLine.Quantity__c;
            tempSeikyuShoTorikShohin.UnitPrice__c = aLine.UnitPrice__c;
            tempSeikyuShoTorikShohin.Amount__c = aLine.Amount__c;
            theShohinLines.add(tempSeikyuShoTorikShohin);
        }
        Insert theShohinLines;

        //取込処理の実行
        Savepoint sp = Database.setSavepoint();
        try{
            thTorik.Status__c = '取込';
            update thTorik;
        }catch(Exception e){
            Database.rollback(sp);
            throw new TorikomiShoriException(e.getMessage());
        }

        CreationTaskResult theResult = new CreationTaskResult();
        theResult.isSuccess = true;
        //System.Debug(thTorik);
        return theResult;
    }

    //AsyncBegin
    public SogSok_SeikyuSho_TorikCreTask(Id pTaskId){ this.f_TaskId = pTaskId; }
    private Id f_TaskId = null;
    public void runTask(Id pTaskId){
        SogSok_SeikyuSho_TorikCreTask__c theTask = (SogSok_SeikyuSho_TorikCreTask__c)SobjectsExtension.firstOrNull(
            [
                select 
                Id, SogSok_SeikyuShoRef__c
                from SogSok_SeikyuSho_TorikCreTask__c 
                where Id = :pTaskId
                limit 1
            ]
        );
        if(theTask == null || theTask.SogSok_SeikyuShoRef__c == null){
            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;
            return;
        }

        try{
            CreationTaskResult theResult = this.run(theTask.SogSok_SeikyuShoRef__c);
            if( !theResult.isSuccess ){
                theTask.ShoriStatus__c = 'Faulted'; 
                Update theTask;
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20180830-1533-01', 'SogSok_SeikyuSho_TorikCre')
                        .setSubjectRecordId(theTask.Id)
                );
                return;
            }

            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;

        } catch(TorikomiShoriException e){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            System.Debug( e.getMessage() );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20180830-1534-01', 'SogSok_SeikyuSho_TorikCre.TorikomiShori')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
            return;
        } catch (Exception e){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            System.Debug( e.getMessage() );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20180830-1535-01', 'SogSok_SeikyuSho_TorikCre')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
            return;
        }
    }

    public void execute(QueueableContext context) {
        this.runTask( this.f_TaskId );
    }
    //AsyncEnd
}