public class SogSok_SrthIraiSho_TorikCreTask implements Queueable{

    public class CreationTaskResult{
        public Boolean isSuccess = false;
    }

    public class TorikomiShoriException extends Exception{}

    public SogSok_SrthIraiSho_TorikCreTask(){}
    public CreationTaskResult run(Id pSogSokSrthIraiSho){

        SogSok_SrthIraiSho__c theSogSokSrthIraiSho = (SogSok_SrthIraiSho__c)SobjectsExtension.firstOrNull(
            [
                select Id, SokyakuBango__c, ShodanBango__c, JuryoDateTime__c,
                SodanSha_TorihikiSakiBango__c, 
                SodanSha_Sei__c, SodanSha_Mei__c,
                TaishoSha_TorihikiSakiBango__c,
                TaishoSha_Sei__c, TaishoSha_Mei__c, 
                TaishoSha_BirthDate__c, TaishoSha_DeathDate__c, TaishoSha_Age__c,
                TaishoSha_Shuha__c, TaishoSha_Shuha_Sonota__c, TaishoSha_Bodaiji_Umu__c,
                TaishoSha_ZokugaraFromMoshu__c, 
                Moshu_TorihikiSakiBango__c,
                Moshu_Sei__c, Moshu_Mei__c, Moshu_SeiKana__c, Moshu_MeiKana__c, 
                Moshu_Mobile__c, Moshu_Phone__c, 
                Moshu_Addr_PostalCode__c, Moshu_Addr_State__c, Moshu_Addr_City__c, Moshu_Addr_Street__c,
                SoryoTehai_Plan__c, SoryoTehai_Kaimyo__c, SoryoTehai_Makurakyo__c,
                Sogi_TsuyaDateTime__c, Sogi_KokubetsuDateTime__c, Sogi_KasoDateTime__c, Sogi_Shonanoka__c,
                Sogi_Shikijo_Name__c, Sogi_Shikijo_Phone__c, Sogi_Shikijo_Address__c,
                Sogi_Kasoba_Name__c, 
                Sogi_Kasoba_Address__c,
                Soukyakusaki_TorihikisakiBango__c,
                SoukyakuSaki_Tantosha_Name__c,
                SoukyakuSaki_Tantosha_Tel__c, SoukyakuSaki_Tantosha_Fax__c,
                SogiPlan_PlanName__c,
                RenrakuJiko__c
                from SogSok_SrthIraiSho__c where Id = :pSogSokSrthIraiSho
                limit 1
            ]
        );
        if( theSogSokSrthIraiSho == null ){
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
                OpportunityRef__r.SimpleYasugoRef__r.MoshuRef__r.TorihikisakiBango__c
                from SogSok_Sokyaku__c
                where Name = :theSogSokSrthIraiSho.SokyakuBango__c
                limit 1
            ]
        );
        if( theSogSokSokyaku == null ){
            CreationTaskResult theResult = new CreationTaskResult();
            theResult.isSuccess = true;
            return theResult;
        }

        SogSok_SrthIraiSho_Torik__c thTorik = new SogSok_SrthIraiSho_Torik__c();
        thTorik.Status__c = '未取込';
        thTorik.SogSok_SrthIraiShoRef__c = theSogSokSrthIraiSho.Id;
        thTorik.syop_Ref__c = theSogSokSokyaku.OpportunityRef__c;
        //thTorik.obop_RyunyuMotoService__c = use Default value
        //thTorik.obop_StageName__c = use Default value
        //thTorik.obop_SubPhase__c = use Default value
        
        thTorik.obop_ToiawaseDate__c = 
            date.newinstance(
                theSogSokSrthIraiSho.JuryoDateTime__c.year(), 
                theSogSokSrthIraiSho.JuryoDateTime__c.month(), 
                theSogSokSrthIraiSho.JuryoDateTime__c.day()
            );
        
        //相談者
        Id theSoudanShaAccountId = 
            theSogSokSrthIraiSho.SodanSha_TorihikiSakiBango__c == theSogSokSokyaku.OpportunityRef__r.Account.TorihikisakiBango__c
            ? theSogSokSokyaku.OpportunityRef__r.AccountId
            : null;
        thTorik.obop_SoudanshaRef__c = theSoudanShaAccountId;
        thTorik.obop_Soudansha_Sei__c = theSogSokSrthIraiSho.SodanSha_Sei__c;
        thTorik.obop_Soudansha_Mei__c = theSogSokSrthIraiSho.SodanSha_Mei__c;

        //対象者
        Id theTaishoShaAccountId = 
            theSogSokSrthIraiSho.TaishoSha_TorihikiSakiBango__c == theSogSokSokyaku.OpportunityRef__r.SimpleYasugoRef__r.TaishoshaRef__r.TorihikisakiBango__c
            ? theSogSokSokyaku.OpportunityRef__r.SimpleYasugoRef__r.TaishoshaRef__c
            : null;
        thTorik.obop_TaishoShaRef__c = theTaishoShaAccountId;
        thTorik.obop_TaishoSha_Sei__c = theSogSokSrthIraiSho.TaishoSha_Sei__c;
        thTorik.obop_TaishoSha_Mei__c = theSogSokSrthIraiSho.TaishoSha_Mei__c;
        thTorik.obop_TaishoSha_BirthDate__c = theSogSokSrthIraiSho.TaishoSha_BirthDate__c;
        thTorik.obop_TaishoSha_DeathDate__c = theSogSokSrthIraiSho.TaishoSha_DeathDate__c;
        thTorik.obop_TaishoSha_Age__c = theSogSokSrthIraiSho.TaishoSha_Age__c;
        thTorik.obop_TaishoSha_Shuha__c = Sogsok_ShushiShuha.tryGetCustomerAccountShuhaFromShuha(theSogSokSrthIraiSho.TaishoSha_Shuha__c,null);
        thTorik.obop_TaishoSha_Shuha_SonotaShuha__c = theSogSokSrthIraiSho.TaishoSha_Shuha_Sonota__c;
        thTorik.obop_TaishoSha_Bodaiji_Umu__c = new SogSok_BodaijiUmu().tryGetCustomerAccountBodaijiUmu(theSogSokSrthIraiSho.TaishoSha_Bodaiji_Umu__c);
        thTorik.obop_TaishoShaZokugaraFromMoshu__c = 
            new SogSok_Zokugara().tryGetSimpleYasugoTaishoshaZokugara(theSogSokSrthIraiSho.TaishoSha_ZokugaraFromMoshu__c);


        
        //喪主
        Id theMoshuAccountId = 
            theSogSokSrthIraiSho.Moshu_TorihikiSakiBango__c == theSogSokSokyaku.OpportunityRef__r.SimpleYasugoRef__r.MoshuRef__r.TorihikisakiBango__c
            ? theSogSokSokyaku.OpportunityRef__r.SimpleYasugoRef__r.MoshuRef__c
            : null;

        thTorik.obop_MoshuRef__c = theMoshuAccountId;
        thTorik.obop_Moshu_Sei__c = theSogSokSrthIraiSho.Moshu_Sei__c;
        thTorik.obop_Moshu_Mei__c = theSogSokSrthIraiSho.Moshu_Mei__c;
        thTorik.obop_Moshu_SeiKana__c = theSogSokSrthIraiSho.Moshu_SeiKana__c;
        thTorik.obop_Moshu_MeiKana__c = theSogSokSrthIraiSho.Moshu_MeiKana__c;
        thTorik.obop_Moshu_Mobile__c = theSogSokSrthIraiSho.Moshu_Mobile__c;
        thTorik.obop_Moshu_Phone__c = theSogSokSrthIraiSho.Moshu_Phone__c;
        thTorik.obop_Moshu_Addr_PostalCode__c = theSogSokSrthIraiSho.Moshu_Addr_PostalCode__c;
        thTorik.obop_Moshu_Addr_State__c = theSogSokSrthIraiSho.Moshu_Addr_State__c;
        thTorik.obop_Moshu_Addr_City__c = theSogSokSrthIraiSho.Moshu_Addr_City__c;
        thTorik.obop_Moshu_Addr_Street__c = theSogSokSrthIraiSho.Moshu_Addr_Street__c;

        //葬儀
        thTorik.obop_TsuyaDateTime__c = theSogSokSrthIraiSho.Sogi_TsuyaDateTime__c;
        thTorik.obop_KokubetsuDateTime__c = theSogSokSrthIraiSho.Sogi_KokubetsuDateTime__c;
        thTorik.obop_KasoDateTime__c = theSogSokSrthIraiSho.Sogi_KasoDateTime__c;
        thTorik.obop_Shonanoka__c = theSogSokSrthIraiSho.Sogi_Shonanoka__c;
        thTorik.obop_SaijoName__c = theSogSokSrthIraiSho.Sogi_Shikijo_Name__c;
        thTorik.obop_SaijoPhone__c = theSogSokSrthIraiSho.Sogi_Shikijo_Phone__c;
        thTorik.obop_SaijoAddress__c = theSogSokSrthIraiSho.Sogi_Shikijo_Address__c;
        thTorik.obop_KasobaName__c =theSogSokSrthIraiSho.Sogi_Kasoba_Name__c;


        if (theSogSokSrthIraiSho.SoryoTehai_Plan__c == 'kaso') {
            thTorik.obop_SaijoName__c = theSogSokSrthIraiSho.Sogi_Kasoba_Name__c;
            thTorik.obop_SaijoAddress__c = theSogSokSrthIraiSho.Sogi_Kasoba_Address__c;
        }

        //僧侶手配
        thTorik.obop_ObouPlan__c = new SogSok_SrthRyokin().tryGetObouPlanFromSrth
            ( theSogSokSrthIraiSho.SoryoTehai_Plan__c , theSogSokSrthIraiSho.SoryoTehai_Kaimyo__c, theSogSokSrthIraiSho.SoryoTehai_Makurakyo__c );
        thTorik.obop_Kaimyo__c = new SogSok_Kaimyo().tryGetSimpleYasugoKaimyo(theSogSokSrthIraiSho.SoryoTehai_Kaimyo__c);
        thTorik.obop_KaimyoKiboUmu__c = new SogSok_Kaimyo().tryGetSimpleYasugoKaimyoJuyo(theSogSokSrthIraiSho.SoryoTehai_Kaimyo__c);

        //送客先
        Account theSoukyakuSakiAccount =
            String.isBlank(theSogSokSrthIraiSho.Soukyakusaki_TorihikisakiBango__c)
            ? null
            : (Account)SObjectsExtension.firstOrNull(
                [
                    select Id
                    from Account
                    where TorihikisakiBango__c = :theSogSokSrthIraiSho.Soukyakusaki_TorihikisakiBango__c
                    limit 1
                ]
            );
        thTorik.obop_SougishaRef__c = theSoukyakuSakiAccount == null ? null : theSoukyakuSakiAccount.Id;
        thTorik.obop_SogiTantoName__c = theSogSokSrthIraiSho.SoukyakuSaki_Tantosha_Name__c;
        thTorik.obop_SogiTantoTel__c = theSogSokSrthIraiSho.SoukyakuSaki_Tantosha_Tel__c;
        thTorik.obop_SogiTantoFax__c = theSogSokSrthIraiSho.SoukyakuSaki_Tantosha_Fax__c;
        thTorik.obop_RenrakuJiko__c = theSogSokSrthIraiSho.RenrakuJiko__c;
        
        Insert thTorik;

        //商品
        Set<String> theShohinCodes = new SogSok_SrthShohinCd().getShohinCodes(
            theSogSokSrthIraiSho.SoryoTehai_Plan__c , theSogSokSrthIraiSho.SoryoTehai_Kaimyo__c, theSogSokSrthIraiSho.SoryoTehai_Makurakyo__c
        );
        List<Product2> theProducts = [select id from Product2 where ShohinBango__c = :theShohinCodes];
        List<SogSok_SrthIraiSho_TorikShohin__c> theShohinLines = new List<SogSok_SrthIraiSho_TorikShohin__c>();
        for(Product2 aProduct : theProducts){
            theShohinLines.add(
                new SogSok_SrthIraiSho_TorikShohin__c(SogSok_SrthIraiSho_TorikRef__c = thTorik.Id, ShohinRef__c = aProduct.Id)
            );
        }
        Insert theShohinLines;

        if(thTorik.obop_SoudanshaRef__c == null || thTorik.obop_TaishoShaRef__c == null){
            thTorik.Status__c = '自動取込不可';
            if(thTorik.obop_SoudanshaRef__c == null) thTorik.StatusDescr__c = '相談者を登録してください; ';
            if(thTorik.obop_TaishoShaRef__c == null) thTorik.StatusDescr__c = '対象者を登録してください; ';
            //if(thTorik.obop_MoshuRef__c == null) thTorik.StatusDescr__c = '喪主を登録してください; ';
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
        //System.Debug(theShohinLines);
        return theResult;
    }

    //Async Beging
    public SogSok_SrthIraiSho_TorikCreTask(Id pTaskId){ this.f_TaskId = pTaskId; }
    private Id f_TaskId = null;
    public void runTask(Id pTaskId){
        SogSok_SrthIraiSho_TorikCreTask__c theTask = (SogSok_SrthIraiSho_TorikCreTask__c)SobjectsExtension.firstOrNull(
            [
                select 
                Id, SogSok_SrthIraiShoRef__c
                from SogSok_SrthIraiSho_TorikCreTask__c 
                where Id = :pTaskId
                limit 1
            ]
        );
        if(theTask == null || theTask.SogSok_SrthIraiShoRef__c == null){
            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;
            return;
        }

        try{
            CreationTaskResult theResult = this.run(theTask.SogSok_SrthIraiShoRef__c);

            if( !theResult.isSuccess ){
                theTask.ShoriStatus__c = 'Faulted'; 
                Update theTask;
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20180828-1720-01', 'SogSok_SrthIraiSho_TorikCre')
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
                Loggings.createLogEntry(Loggings.Level.Error, '20180828-1718-01', 'SogSok_SrthIraiSho_TorikCre.TorikomiShori')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
            return;
        } catch (Exception e){
            theTask.ShoriStatus__c = 'Faulted'; 
            Update theTask;
            System.Debug( e.getMessage() );
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20180817-1056-01', 'SogSok_SrthIraiSho_TorikCre')
                    .setSubjectRecordId(theTask.Id)
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
            return;
        }
    }

    public void execute(QueueableContext context) {
        this.runTask( this.f_TaskId);
    }
    //Async End
}