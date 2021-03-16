//a task
public class SogSok_MitsumoriSho_TorikCreTask implements Queueable{

    //logic result
    public class CreationTaskResult{
        public Boolean isSuccess = false;
    }
    public class TorikomiShoriException extends Exception{}

    public SogSok_MitsumoriSho_TorikCreTask(){}
    public CreationTaskResult run(Id pSogSokMitsumoriShoId){

        SogSok_MitsumoriSho__c theSogSokMitsumoriSho =  (SogSok_MitsumoriSho__c)SobjectsExtension.firstOrNull(
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
                    from SogSok_Mitsumorisho_TsuikaHinLines__r
                ),
                (
                    select ShohinBango__c, Quantity__c, UnitPrice__c, Amount__c
                    from Mitsumorisho_WaribikiLines__r
                )
                from SogSok_MitsumoriSho__c where Id = :pSogSokMitsumoriShoId
                limit 1
            ]
        );
        if( theSogSokMitsumoriSho == null ){
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
                where Name = :theSogSokMitsumoriSho.SokyakuBango__c
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

        SogSok_MitsumoriSho_Torik__c thTorik = new SogSok_MitsumoriSho_Torik__c();
        thTorik.Status__c = '未取込';
        thTorik.MitsumoriShoRef__c = theSogSokMitsumoriSho.Id;
        thTorik.syop_Ref__c = theSogSokSokyaku.OpportunityRef__c;
        thTorik.syop_MitsumoriJuryoDate__c = 
            theSogSokMitsumoriSho.JuryoDateTime__c == null
            ? null 
            : Date.newInstance(
                theSogSokMitsumoriSho.JuryoDateTime__c.year(), 
                theSogSokMitsumoriSho.JuryoDateTime__c.month(), 
                theSogSokMitsumoriSho.JuryoDateTime__c.day()
            ); 
        

        //相談者
        Id theSoudanShaAccountId = 
            theSogSokMitsumoriSho.SodanSha_TorihikiSakiBango__c == theSogSokSokyaku.OpportunityRef__r.Account.TorihikisakiBango__c
            ? theSogSokSokyaku.OpportunityRef__r.AccountId
            : null;
        thTorik.syop_SoudanshaRef__c = theSoudanShaAccountId;
        thTorik.syop_Soudansha_Sei__c = theSogSokMitsumoriSho.SodanSha_Sei__c;
        thTorik.syop_Soudansha_Mei__c = theSogSokMitsumoriSho.SodanSha_Mei__c;

        //対象者
        Id theTaishoShaAccountId = 
            theSogSokMitsumoriSho.TaishoSha_TorihikiSakiBango__c == theSogSokSokyaku.OpportunityRef__r.SimpleYasugoRef__r.TaishoshaRef__r.TorihikisakiBango__c
            ? theSogSokSokyaku.OpportunityRef__r.SimpleYasugoRef__r.TaishoshaRef__c
            : null;
        thTorik.syop_TaishoShaRef__c = theTaishoShaAccountId;
        thTorik.syop_TaishoSha_Sei__c = theSogSokMitsumoriSho.TaishoSha_Sei__c;
        thTorik.syop_TaishoSha_Mei__c = theSogSokMitsumoriSho.TaishoSha_Mei__c;
        thTorik.syop_TaishoSha_BirthDate__c = theSogSokMitsumoriSho.TaishoSha_BirthDate__c;
        thTorik.syop_TaishoSha_DeathDate__c = theSogSokMitsumoriSho.TaishoSha_DeathDate__c;
        thTorik.syop_TaishoSha_Age__c = theSogSokMitsumoriSho.TaishoSha_Age__c;
        thTorik.syop_TaishoSha_Gender__c = new SogSok_Gender().tryGetCustomerAccountGender(theSogSokMitsumoriSho.TaishoSha_Gender__c);
        thTorik.syop_TaishoSha_Addr_PostalCode__c = theSogSokMitsumoriSho.Taishosha_Addr_PostalCode__c;
        thTorik.syop_TaishoSha_Addr_State__c = theSogSokMitsumoriSho.TaishoSha_Addr_State__c;
        thTorik.syop_TaishoSha_Addr_City__c = theSogSokMitsumoriSho.TaishoSha_Addr_City__c;
        thTorik.syop_TaishoSha_Addr_Street__c = theSogSokMitsumoriSho.TaishoSha_Addr_Street__c;
        thTorik.syop_TaishoSha_Jumh_State__c = theSogSokMitsumoriSho.TaishoSha_JumHyo_State__c;
        thTorik.syop_TaishoSha_Jumh_City__c = theSogSokMitsumoriSho.TaishoSha_JumHyo_City__c;
        thTorik.syop_TaishoSha_Shuha__c = Sogsok_ShushiShuha.tryGetCustomerAccountShuhaFromShuha(theSogSokMitsumoriSho.TaishoSha_Shuha__c,null);
        thTorik.syop_TaishoSha_Shuha_Sonota__c = theSogSokMitsumoriSho.TaishoSha_Shuha_Sonota__c;
        thTorik.syop_TaishoSha_Bodaiji_Umu__c = new SogSok_BodaijiUmu().tryGetCustomerAccountBodaijiUmu(theSogSokMitsumoriSho.TaishoSha_Bodaiji_Umu__c);

        //喪主
        thTorik.syop_Moshu_Sei__c = theSogSokMitsumoriSho.Moshu_Sei__c;
        thTorik.syop_Moshu_Mei__c = theSogSokMitsumoriSho.Moshu_Mei__c;
        thTorik.syop_Moshu_SeiKana__c = theSogSokMitsumoriSho.Moshu_SeiKana__c;
        thTorik.syop_Moshu_MeiKana__c = theSogSokMitsumoriSho.Moshu_MeiKana__c;
        thTorik.syop_Moshu_BirthDate__c = theSogSokMitsumoriSho.Moshu_BirthDate__c;
        thTorik.syop_Moshu_Gender__c = new SogSok_Gender().tryGetCustomerAccountGender(theSogSokMitsumoriSho.Moshu_Gender__c);
        thTorik.syop_Moshu_Mobile__c = theSogSokMitsumoriSho.Moshu_Mobile__c;
        thTorik.syop_Moshu_Phone__c = theSogSokMitsumoriSho.Moshu_Phone__c;
        thTorik.syop_Moshu_Addr_PostalCode__c = theSogSokMitsumoriSho.Moshu_Addr_PostalCode__c;
        thTorik.syop_Moshu_Addr_State__c = theSogSokMitsumoriSho.Moshu_Addr_State__c;
        thTorik.syop_Moshu_Addr_City__c = theSogSokMitsumoriSho.Moshu_Addr_City__c;
        thTorik.syop_Moshu_Addr_Street__c = theSogSokMitsumoriSho.Moshu_Addr_Street__c;
        thTorik.syop_MoshuZokugaraFromSoudanSha__c = 
            new SogSok_Zokugara().tryGetSimpleYasugoTaishoshaZokugara(theSogSokMitsumoriSho.Moshu_ZokugaraFromSoudanSha__c);

        //葬儀
        thTorik.syop_PlanHenkouUmu__c = theSogSokSokyaku.SokyakuShoRef__r.SogiPlan_ShohinBango__c != theSogSokMitsumoriSho.SogiPlan_ShohinBango__c;
        thTorik.syop_TsuyaDateTime__c = theSogSokMitsumoriSho.Sogi_TsuyaDateTime__c;
        thTorik.syop_KokubetsuDateTime__c = theSogSokMitsumoriSho.Sogi_KokubetsuDateTime__c;
        thTorik.syop_ShukkanDateTime__c = theSogSokMitsumoriSho.Sogi_ShukkanDateTime__c;
        thTorik.syop_KasoDateTime__c = theSogSokMitsumoriSho.Sogi_KasoDateTime__c;
        thTorik.syop_SonotaSaijoName__c = theSogSokMitsumoriSho.Sogi_Shikijo_Name__c;
        thTorik.syop_SonotaKasobaName__c =theSogSokMitsumoriSho.Sogi_Kasoba_Name__c;

        //送客先
        thTorik.syop_SogiTantoName__c = theSogSokMitsumoriSho.SoukyakuSaki_Tantosha_Name__c;

        //僧侶手配
        thTorik.syop_SoryoTehaiKiboUmu__c = theSogSokMitsumoriSho.SoryoTehai__c;
        thTorik.syop_Kaimyo__c = new SogSok_Kaimyo().tryGetSimpleYasugoKaimyo(theSogSokMitsumoriSho.SoryoTehai_Kaimyo__c);
        thTorik.syop_KaimyoKiboUmu__c = new SogSok_Kaimyo().tryGetSimpleYasugoKaimyoJuyo(theSogSokMitsumoriSho.SoryoTehai_Kaimyo__c);
        
        //領収
        thTorik.syop_Ryos_RyosyuShoHitsuyo__c = !String.isBlank(theSogSokMitsumoriSho.ShiharaiSha_RyosyuAtena__c);
        thTorik.syop_Ryos_Atena__c = theSogSokMitsumoriSho.ShiharaiSha_RyosyuAtena__c;
        thTorik.syop_Ryos_PostalCode__c = theSogSokMitsumoriSho.ShiharaiSha_Addr_PostalCode__c;
        thTorik.syop_Ryos_State__c = theSogSokMitsumoriSho.ShiharaiSha_Addr_State__c;
        thTorik.syop_Ryos_City__c = theSogSokMitsumoriSho.ShiharaiSha_Addr_City__c;
        thTorik.syop_Ryos_Street__c = theSogSokMitsumoriSho.ShiharaiSha_Addr_Street__c;

        //支払
        thTorik.syop_GenkinKingaku__c = theSogSokMitsumoriSho.Shiharai_GenkinKingaku__c;
        
        Insert thTorik;

        //商品ライン
        List<SogSok_MitsumoriSho_TorikShohin__c> theShohinLines = new List<SogSok_MitsumoriSho_TorikShohin__c>();
        //商品ライン / プランと割引
        Set<String> theShohinCodes = new Set<String>{theSogSokMitsumoriSho.SogiPlan_ShohinBango__c};
        for(SogSok_Mitsumorisho_WaribikiLine__c aWrbLine : theSogSokMitsumoriSho.Mitsumorisho_WaribikiLines__r){
            theShohinCodes.add(aWrbLine.ShohinBango__c);
        }
        List<Product2> theProds = [
            select Id, ShohinBango__c, k_Service_Id_exp__c from Product2 where ShohinBango__c = : new List<String>(theShohinCodes)
        ];
        Map<String,Product2> theMapOfShohinBangoToProduct = new Map<String,Product2>();
        for(Product2 aProd : theProds){
            theMapOfShohinBangoToProduct.put(aProd.ShohinBango__c, aProd);
        }
        if( !String.isBlank(theSogSokMitsumoriSho.SogiPlan_ShohinBango__c) ){
            theShohinLines.add(
                new SogSok_MitsumoriSho_TorikShohin__c(
                    SogSok_MitsumoriSho_TorikRef__c = thTorik.Id,
                    ShohinRef__c = theMapOfShohinBangoToProduct.get(theSogSokMitsumoriSho.SogiPlan_ShohinBango__c).Id,
                    Quantity__c = 1,
                    UnitPrice__c = theSogSokMitsumoriSho.SogiPlan_Amount__c,
                    Amount__c = theSogSokMitsumoriSho.SogiPlan_Amount__c
                )
            );
        }
        
        for(SogSok_Mitsumorisho_WaribikiLine__c aWrbLine : theSogSokMitsumoriSho.Mitsumorisho_WaribikiLines__r){
            theShohinLines.add(
                new SogSok_MitsumoriSho_TorikShohin__c(
                    SogSok_MitsumoriSho_TorikRef__c = thTorik.Id,
                    ShohinRef__c = theMapOfShohinBangoToProduct.get(aWrbLine.ShohinBango__c).Id,
                    Quantity__c = aWrbLine.Quantity__c,
                    UnitPrice__c = aWrbLine.UnitPrice__c,
                    Amount__c = aWrbLine.Amount__c
                )
            );
        }

        //商品ライン / 追加品目
        for(SogSok_Mitsumorisho_TsuikaHinLine__c aLine : theSogSokMitsumoriSho.SogSok_Mitsumorisho_TsuikaHinLines__r){
            SogSok_MitsumoriSho_TorikShohin__c tempMitsumoriShoTorikShohin = new SogSok_MitsumoriSho_TorikShohin__c();
            tempMitsumoriShoTorikShohin.SogSok_MitsumoriSho_TorikRef__c = thTorik.Id;
            tempMitsumoriShoTorikShohin.ShohinRef__c = Sogsok_TsuikaHinBunrui_201101.getProduct(aLine.ShohinBango__c).Id;
            tempMitsumoriShoTorikShohin.Quantity__c = aLine.Quantity__c;
            tempMitsumoriShoTorikShohin.UnitPrice__c = aLine.UnitPrice__c;
            tempMitsumoriShoTorikShohin.Amount__c = aLine.Amount__c;
            theShohinLines.add(tempMitsumoriShoTorikShohin);
        }
        Insert theShohinLines;

        if(thTorik.syop_SoudanshaRef__c == null || thTorik.syop_TaishoShaRef__c == null){
            thTorik.Status__c = '自動取込不可';
            if(thTorik.syop_SoudanshaRef__c == null) thTorik.StatusDescr__c = '相談者を登録してください; ';
            if(thTorik.syop_TaishoShaRef__c == null) thTorik.StatusDescr__c = '対象者を登録してください; ';
            update thTorik;
        }else{
            //取込処理の実行
            Savepoint sp = Database.setSavepoint();
            try{
                thTorik.Status__c = '取込';
                update thTorik;
            }catch(Exception e){
                Database.rollback(sp);
                throw new TorikomiShoriException(e.getMessage());
            }
        }

        CreationTaskResult theResult = new CreationTaskResult();
        theResult.isSuccess = true;
        //System.Debug(thTorik);
        return theResult;
    }

    //AsyncBegin
    public SogSok_MitsumoriSho_TorikCreTask(Id pTaskId){ this.f_TaskId = pTaskId; }
    private Id f_TaskId = null;
    public void runTask(Id pTaskId){
        SogSok_MitsumoriSho_TorikCreTask__c theTask = (SogSok_MitsumoriSho_TorikCreTask__c)SobjectsExtension.firstOrNull(
            [
                select 
                Id, SogSok_MitsumoriShoRef__c
                from SogSok_MitsumoriSho_TorikCreTask__c 
                where Id = :pTaskId
                limit 1
            ]
        );
        if(theTask == null || theTask.SogSok_MitsumoriShoRef__c == null){
            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;
            return;
        }

        try{
            CreationTaskResult theResult = this.run(theTask.SogSok_MitsumoriShoRef__c);
            if( !theResult.isSuccess ){
                theTask.ShoriStatus__c = 'Faulted'; 
                Update theTask;
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20180829-2020-01', 'SogSok_MitsumoriSho_TorikCre')
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
                Loggings.createLogEntry(Loggings.Level.Error, '20180829-2021-01', 'SogSok_MitsumoriSho_TorikCre.TorikomiShori')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
            return;
        } catch (Exception e){
            System.Debug( e.getMessage() );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20180829-2022-01', 'SogSok_MitsumoriSho_TorikCre')
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