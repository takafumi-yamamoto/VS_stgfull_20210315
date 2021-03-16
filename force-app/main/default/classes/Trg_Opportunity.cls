public class Trg_Opportunity {

    public static boolean isActive = true;
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public Trg_Opportunity(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnBeforeInsert(List<Opportunity> newList){

        List<ID> accountIdList = new List<ID>();
        for(Opportunity opportunity : newList){
            accountIdList.add(opportunity.AccountId);
            
            if(String.isBlank(String.valueOf(opportunity.Req_Day__c))){
                opportunity.Req_Day__c = datetime.now();
            }
        }
        Map<ID, Account> accountMap =AccountDaos.GetInstance().SelectByIdsAsMapById(accountIdList);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeInsert.01;' + Limits.getQueries());
        new Ctl_Opportunity().OpportunityInitialize(newList, null, accountMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeInsert.02;' + Limits.getQueries());
        //取引商談作成
        new Ctl_Opportunity().CreateTorihikiShodanFromServiceShodan(newList, accountMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeInsert.03;' + Limits.getQueries());
        //サービスオブジェクト作成
        OpportunityToServiceSave(newList);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeInsert.04;' + Limits.getQueries());
        //取引商談とサービス商談を紐づく
        //ConnectTorihikiShodanAndServiceShodan(newList);
        //priceBook設定
        setPriceBook(newList);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeInsert.05;' + Limits.getQueries());
        // 検索用テキスト更新
        new Ctl_Opportunity().setSearchTxt(newList,null);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeInsert.06;' + Limits.getQueries());

        //issues3806--Start--
        new NurturingCRMSimpleYasugoOpportunity().OnBeforeInsert(newList);
        //issues3806--End--

    }

    public void OnBeforeUpdate(List<Opportunity> newList, Map<ID, Opportunity> oldMap){

        //issues3806--Start--
        NurturingCRMSimpleYasugoOpportunity NurturingCRM = new NurturingCRMSimpleYasugoOpportunity();
        NurturingCRM.OnBeforeUpdate(newList, oldMap);
        if(NurturingCRM.checkData(newList, oldMap)) return;
        //issues3806--End--

        new ObOppCloseValids.ClosingValidation().onOppBeforeUpdate(newList, oldMap);
        new LwsnShopCdValids(LwsnIsLwsnKeiyakus.getInstance()).onOppBeforeUpdate(newList, oldMap);
        new SimpleOppValidation.KetteiValidation().onOppBeforeUpdate(newList, oldMap);

        // 葬儀レビの場合にフェーズが決定以降で決定葬儀社の入力がなければエラーにする
        if(chkKetteiSougisha(newList, oldMap)) return;

        Map<Id, Obosanbin__c> obousanbins = this.selectObosanbins(newList, oldMap);

        new Ctl_ShodanCopy().copyZennkaiOboOpp(newList,oldMap); //お坊さん便/前回お坊商談の反映
        new Ctl_ShodanCopy().copySougiSyoudan(newList,oldMap); //お坊さん便/前回葬儀商談の反映
        new ZnObOpBest.ZenkaiOboOppBest().onOppBeforeUpdate(newList,oldMap);

        List<ID> accountIdList = new List<ID>();
        for(Opportunity opportunity : newList){
            accountIdList.add(opportunity.AccountId);
        }
        Map<ID, Account> accountMap =AccountDaos.GetInstance().SelectByIdsAsMapById(accountIdList);

        //new Ctl_Opportunity().putShiryoSoufuSaki(newList, oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeUpdate.01;' + Limits.getQueries());
        new Ctl_Opportunity().OpportunityInitialize(newList, oldMap, accountMap);
        new TesuryoPartnerKeisan().OnBeforeUpdateTesuryouKeisan(newList, oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeUpdate.02;' + Limits.getQueries());
        List<Opportunity> changeOppRecordTypeList = Ctl_Opportunity_RecTypeChanging.getInstance().onOpportunityBeforeUpdate(newList, oldMap);
        List<Opportunity> insertSeizenKeiyakuList = new List<Opportunity>();
        for(Opportunity changeOppRecordType : changeOppRecordTypeList){
            if(changeOppRecordType.SeizenKeiyakuRef__c == null) insertSeizenKeiyakuList.add(changeOppRecordType);
        }
        OpportunityToServiceSave(insertSeizenKeiyakuList);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeUpdate.03;' + Limits.getQueries());
        //取引商談作成
        new Ctl_Opportunity().opportunityInitialValue(newList, oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeUpdate.04;' + Limits.getQueries());
        // LTVユニットの設定
        new Ctl_Opportunity().putLtvUnit(newList,oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeUpdate.05;' + Limits.getQueries());
        // 流入経路（新規） を更新
        new Ctl_Opportunity().setIriguchi(newList,oldMap);

        RyunyuBaitaiBangos.get_IRyunyuBaitaiBango_Is_Mandatory_instance()
            .on_opp_before_update(newList, oldMap);

        // 検索用テキスト更新
        new Ctl_Opportunity().setSearchTxt(newList,oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnBeforeUpdate.06;' + Limits.getQueries());

        new OpportunitySimpleUpdateReportPhase().onOppBeforeUpdate(newList, oldMap);
        new OpportunityOboUpdateReportPhase().onOppBeforeUpdate(newList, oldMap);
        new ObosanbinOppKakuteibiSet().onOppBeforeUpdate(newList, oldMap);
        OboZidoSiryoSofu.onOpportunityBeforeUpdated(newList, oldMap, obousanbins);
        new ObosanbinOppUriagebiSet().onOppBeforeUpdate(newList, oldMap, obousanbins);
        KeirSimeLocks.onOpportunityBeforeUpdate(newList, oldMap);
        new StageNameShicchu().onOpportunityBeforeUpdate(newList, oldMap);

        //issues4005--Start--
        new NebikiShoninOpportunity().OnBeforeUpdate(newList, oldMap);
        //issues4005--End--)

        new SpfyOppName.OnOppBeforeUpdate().appendShopifyOrderNo_To_OppName(newList,oldMap);

    }

    public void OnAfterInsert(List<Opportunity> newList){
        //メールToケースの時に、商談商品を作成
        System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterInsert.01;' + Limits.getQueries());
        new Ctl_OpportunityLineItem().createOpportunityLineItemByMail(newList);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterInsert.02;' + Limits.getQueries());

        // 事前割の場合
        new Ctl_Jizenwari.ProcessingOfJizenwariWebUketsuke().onOpportunityAfterInserted(newList);
         System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterInsert.03;' + Limits.getQueries());
                
		// 商談 取引先責任者の役割（相談者と喪主の役割の設定）
        AddOpportunityContactRoleQms.OnAfterInsert(newList);

        new SogiShiryoSofuQms.QueuingOnOpportunityAfterInsert().enqueOpportunityLocationUpdates(newList);

    }
    public void OnAfterUpdate(List<Opportunity> newList, List<Opportunity> oldList, Map<Id, Opportunity> oldMap){
        Map<Id, Obosanbin__c> obousanbins = this.selectObosanbins(newList, oldMap);

        new OppLineItemJidoToroku().onOppAfterUpdated(newList, oldMap);

        new SrscFrObOpQms.QueuingByOpp(
            new SrscFrObOpPhase.StageToSchedule()
        )
        .onOppAfterUpdate(newList, oldMap);//僧侶スケジュール更新

        //お坊さん便 お客様請求明細を自動作成
        AutoCreateOkyakusamaSeikyuMeisai.subscriveOnOpportunityAfterUpdated(newList,oldMap);

        //お客様請求明細の決済日の自動補完
        OkyakusamaSeikyuMeisaiKessaibi.onOpportunityAfterUpdated(newList);

        System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterUpdate.01;' + Limits.getQueries());

        new Ctl_Opportunity().insertAccountChangedTask(newList, oldMap);

        System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterUpdate.02' + Limits.getQueries());
        //　アチーブメント作成
        Ctl_Achievement_Obosanbin.getInstance().onOpportunityAfterUpdate(newList, oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterUpdate.03;' + Limits.getQueries());
        new Opportunity_SimeSiharaiDate().onOppAfterUpdate(newList, oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterUpdate.04;' + Limits.getQueries());
        //Coreへ受注情報を連携する
        new Ctl_Opportunity().OrderTransferToCore(newList, oldMap);
        System.Debug('Limits.getQueries().Trg_Opportunity.OnAfterUpdate.05;' + Limits.getQueries());

        KeirDenVers.onOppAfterUpdated(newList, oldMap);
        
        //売上日が設定された場合、クロスセル先の商談の項目に日付を設定する
        updateCrossSeliingSakiOpportunity(newList, oldMap);
		// 商談 取引先責任者の役割（相談者と喪主の役割の設定）
        AddOpportunityContactRoleQms.OnAfterUpdate(newList, oldMap);
        
    }

    /**
     * サービス商談からサービスオブジェクトを作成
     * @param List<Opportunity> newList　商談のNewリスト
     * @return null
     */
    private void OpportunityToServiceSave(List<Opportunity> newList) {
        system.debug('====================OpportunityToServiceSave.begin===================');
        Ctl_OpportunityToServiceBuildProcessor processor = new Ctl_OpportunityToServiceBuildProcessor();

        // 各種ヘルパー初期化
        //シンプル安豪
        Ctl_OpportunityToSimpleYasugoBuilder simpleYasugoBuilder = new Ctl_OpportunityToSimpleYasugoBuilder();
        //生前契約（事前契約）
        Ctl_OpportunityToseizenKeiyakuBuilder seizenKeiyakuBuilder = new Ctl_OpportunityToseizenKeiyakuBuilder();
        //お坊さん便
        Ctl_OpportunityToObosanbinBuilder obosanbinBuilder = new Ctl_OpportunityToObosanbinBuilder();
        //永代供養
        Ctl_OpportunityToPerpetualMemoBuilder perpetualMemorialBuilder = new Ctl_OpportunityToPerpetualMemoBuilder();
        //ベスト仏壇
        Ctl_OpportunityToBestButsudanBuilder bestButsudanBuilder = new Ctl_OpportunityToBestButsudanBuilder();
        //供花配達レビ
        Ctl_OpportunityToKyoukaBuilder kyoukaBuilder = new Ctl_OpportunityToKyoukaBuilder();
        //Umie
        Ctl_OpportunityToKaiyoUmieBuilder kaiyoUmieBuilder = new Ctl_OpportunityToKaiyoUmieBuilder();
        //Sorae
        Ctl_OpportunityToSpaceFuneralBuilder spaceFuneralBuilder = new Ctl_OpportunityToSpaceFuneralBuilder();
        //墓ピタ
        Ctl_OpportunityToHakapitaBuilder hakapitaBuilder = new Ctl_OpportunityToHakapitaBuilder();
        //格安墓石
        Ctl_OpportunityToKakuyasuBosekiBuilder kakuyasuBosekiBuilder = new Ctl_OpportunityToKakuyasuBosekiBuilder();
        // 事前割
        Ctl_OpportunityToJizenwariBuilder jizenwariBuilder = new Ctl_OpportunityToJizenwariBuilder();
        // お迎えフリー
        Ctl_OpportunityToOmukaeFreeBuilder omukaeFreeBuilder = new Ctl_OpportunityToOmukaeFreeBuilder();
        // 対面相談
        //Ctl_OpportunityToTaimenSodanBuilder taimenSodanBuilder = new Ctl_OpportunityToTaimenSodanBuilder();
        // 喪主代行
        Ctl_OpportunityToMoshuDaikoBuilder moshuDaikoBuilder = new Ctl_OpportunityToMoshuDaikoBuilder();
        // 葬儀レビ
        Ctl_OpportunityToSogiRevBuilder sogiRevBuilder = new Ctl_OpportunityToSogiRevBuilder();


        for(Opportunity opp : newList) {

            // シンプル安豪（資料請求 / 問合せ)
            System.debug('Opportunity.RecordType : ' +  opp.RecordTypeId);

            // シンプル安豪
            if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo') ) {
                simpleYasugoBuilder.addopp(opp);
                System.debug('サービス作成：シンプル安豪');
            }
            // 生前契約（事前契約）
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku') ) {
                     seizenKeiyakuBuilder.addopp(opp);
                     System.debug('サービス作成：生前契約');
            }
            // お坊さん便
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin') ) {
                     obosanbinBuilder.addopp(opp);
                     System.debug('サービス作成：お坊さん便');
            }
            // 永代供養
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','PerpetualMemorial') ) {
                     perpetualMemorialBuilder.addopp(opp);
                     System.debug('サービス作成：永代供養');
            }
            // ベスト仏壇
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan') ) {
                     bestButsudanBuilder.addopp(opp);
                     System.debug('サービス作成：ベスト仏壇');
            }
            // 供花配達レビ
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Kyouka') ) {
                     kyoukaBuilder.addopp(opp);
                     System.debug('サービス作成：供花配達レビ');
            }
            // Umie
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KaiyoUmie') ) {
                     kaiyoUmieBuilder.addopp(opp);
                     System.debug('サービス作成：海洋散骨');
            }
            // Sorae
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SpaceFuneral') ) {
                     spaceFuneralBuilder.addopp(opp);
                     System.debug('サービス作成：宇宙葬');
            }
            // 墓ピタ
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Hakapita') ) {
                     hakapitaBuilder.addopp(opp);
                     System.debug('サービス作成：墓ピタ');
            }
            // 格安墓石
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuBoseki') ) {
                     kakuyasuBosekiBuilder.addopp(opp);
                     System.debug('サービス作成：格安墓石');
            }
            // 事前割
            if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Simple_Jizenwari') ) {
                     System.debug('----279Entrytest----' + Limits.getQueries());
                     jizenwariBuilder.addopp(opp);
                     System.debug('サービス作成：事前割');
            }
            // お迎えフリー
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','OmukaeFree') ) {
                     omukaeFreeBuilder.addopp(opp);
                     System.debug('サービス作成：お迎えフリー');
            }
            // 対面相談
            /*else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TaimenSodan') ) {
                     taimenSodanBuilder.addopp(opp);
                     System.debug('サービス作成：対面相談');
            }*/
            // 喪主代行
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','MosyuDaiko') ) {
                     moshuDaikoBuilder.addopp(opp);
                     System.debug('サービス作成：喪主代行');
            }
            // 葬儀レビ
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev') ) {
                     sogiRevBuilder.addopp(opp);
                     System.debug('サービス作成：葬儀レビ');
            }
            else {
                System.debug('サービス作成：対象外');
            }
        }

        // ヘルパーのセット
        // シンプル安豪
        if(simpleYasugoBuilder.opps.size() > 0){
            processor.addBuilder(simpleYasugoBuilder);
        }
        //生前契約（事前契約）
        if(seizenKeiyakuBuilder.opps.size() > 0){
            processor.addBuilder(seizenKeiyakuBuilder);
        }
        //お坊さん便
        if(obosanbinBuilder.opps.size() > 0){
            processor.addBuilder(obosanbinBuilder);
        }
        //永代供養
        if(perpetualMemorialBuilder.opps.size() > 0){
            processor.addBuilder(perpetualMemorialBuilder);
        }
        //ベスト仏壇
        if(bestButsudanBuilder.opps.size() > 0){
            processor.addBuilder(bestButsudanBuilder);
        }
        //供花配達レビ
        if(kyoukaBuilder.opps.size() > 0){
            processor.addBuilder(kyoukaBuilder);
        }
        //Umie
        if(kaiyoUmieBuilder.opps.size() > 0){
            processor.addBuilder(kaiyoUmieBuilder);
        }
        //Sorae
        if(spaceFuneralBuilder.opps.size() > 0){
            processor.addBuilder(spaceFuneralBuilder);
        }
        //墓ピタ
        if(hakapitaBuilder.opps.size() > 0){
            processor.addBuilder(hakapitaBuilder);
        }
        //格安墓石
        if(kakuyasuBosekiBuilder.opps.size() > 0){
            processor.addBuilder(kakuyasuBosekiBuilder);
        }
        // 事前割
        if(jizenwariBuilder.opps.size() > 0){
            processor.addBuilder(jizenwariBuilder);
        }
        // お迎えフリー
        if(omukaeFreeBuilder.opps.size() > 0){
            processor.addBuilder(omukaeFreeBuilder);
        }
        // 喪主代行
        if(moshuDaikoBuilder.opps.size() > 0){
            processor.addBuilder(moshuDaikoBuilder);
        }
        // 葬儀レビ
        if(sogiRevBuilder.opps.size() > 0){
            processor.addBuilder(sogiRevBuilder);
        }
        // ケースとサービスの保存
        processor.save();

        system.debug('====================OpportunityToServiceSave.end===================');
    }

    /**
     * 取引商談とサービス商談を紐づく
     * @param List<Opportunity> newList　商談のNewリスト
     * @return null
     */
    /*private void ConnectTorihikiShodanAndServiceShodan(List<Opportunity> newList) {
        system.debug('====================ConnectTorihikiShodanAndServiceShodan.begin===================');
        Set<ID> accountIdSet=new Set<ID>();

        //サービス商談と紐づく取引先IDをセットに取得
        for (opportunity opp:newList){
            accountIdSet.add(opp.accountid);
        }
        //取引商談のレコードタイプIDを取得
        String recordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TorihikiShodan');
        //既存の取引商談を取得
        Map<ID, opportunity> torihikiShodanMap = new Map<ID, opportunity>();
        for (opportunity torihikiShodan:[select id,accountid from Opportunity where recordtypeid=:recordTypeid and accountId in :accountIdSet]){
            torihikiShodanMap.put(torihikiShodan.accountid,torihikiShodan);
        }
        //system.debug('***recordTypeId='+recordTypeId);
        system.debug('***newList='+newList);
        system.debug('***torihikiShodanMap='+torihikiShodanMap);
        for (opportunity opp:newList){
            opportunity torihikiShodan=torihikiShodanMap.get(opp.accountid);
            if ((torihikiShodanMap.get(opp.accountid)!=null) && (opp.recordtypeid!=recordTypeId)){
                //取引商談
                opp.TorihikiShodanRef__c=torihikiShodan.id;
            }
        }
        system.debug('====================ConnectTorihikiShodanAndServiceShodan.end===================');
    }*
    /**
     * サービス商談のPriceBookの設定
     * @param List<Opportunity> newList　商談のNewリスト
     * @return null
     */
    private void setPriceBook(List<Opportunity> newList) {
        system.debug('====================Trg_Opportunity.setPriceBook.begin===================');
        Ctl_Pricebook ctr =new Ctl_Pricebook();
        String pbId = ctr.getPriceBookId();

        for (opportunity opp:newList){
            opp.Pricebook2Id = pbId;
        }

        system.debug('====================Trg_Opportunity.setPriceBook.end===================');
    }

    private Map<Id, Obosanbin__c> selectObosanbins(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){

        Set<Id> obouIds = new Set<Id>();

        for(Opportunity aNewOne : pNewOnes){
            if( aNewOne.ObosanbinRef__c != null ) obouIds.add(aNewOne.ObosanbinRef__c);
        }

        if(pOldOnes != null){
            for(Opportunity aOldOne : pOldOnes.values() ){
                if( aOldOne.ObosanbinRef__c != null ) obouIds.add(aOldOne.ObosanbinRef__c);
            }
        }

        if( obouIds.size() <= 0 ) return new Map<Id, Obosanbin__c>();

        Map<Id, Obosanbin__c> theEntries = new Map<Id, Obosanbin__c>(
            [
                select Id,
                MemorialServicePlan__c,
                IraiTehaiDate__c,
                KasoDateTime_Inp__c,
                KokubetsuDateTime_Inp__c,
                TsuyaDateTime_Inp__c ,
                ShukkanDateTimei_Inp__c ,
                KokubetsushikiNichiji__c,
                (select Id, StageName from OpportunitiesObosanbin__r)
                from Obosanbin__c
                where Id = :obouIds
            ]
        );
        return theEntries;
    }

    @TestVisible
    private void updateCrossSeliingSakiOpportunity(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){
        Map<Id,Opportunity> targetNewMap = new Map<Id,Opportunity>();
        for(Opportunity newone:pNewOnes){
            Opportunity oldOpportunity = pOldOnes.get(newone.Id);
            if(newone.Utiagebi__c!=null && oldOpportunity.Utiagebi__c==null){
                targetNewMap.put(newone.Id,newone);
            }
        }
        if(targetNewMap.size()>0){
            //クロスセル提案のオブジェクトを取得する
            List<CrossSellingTeian__c> crossSellTeianList = [
                SELECT
                    ID
                    ,CrossSellingSakiOpportunityRef__c
                    ,OpportunityRef__r.Utiagebi__c
                FROM CrossSellingTeian__c
                WHERE OpportunityRef__c in :targetNewMap.keySet()
                ];

            //クロスセル提案先のオブジェクトを更新する
            List<Opportunity> updateOpportunityList = new List<Opportunity>();
            for(CrossSellingTeian__c crosssellTeian:crossSellTeianList){
                if(crosssellTeian.CrossSellingSakiOpportunityRef__c!=null){
                    Opportunity updateOpportunity = new Opportunity();
                    updateOpportunity.Id = crosssellTeian.CrossSellingSakiOpportunityRef__c;
                    updateOpportunity.YorisonoOsoshikiSekobi__c = crosssellTeian.OpportunityRef__r.Utiagebi__c;
                    updateOpportunityList.add(updateOpportunity);
                }
            }
            if(updateOpportunityList.size()>0) update updateOpportunityList;
        }
    }

    private boolean chkKetteiSougisha(List<Opportunity> pNewOnes, Map<Id, Opportunity> pOldOnes){
        Boolean errFlg = false;
        Map<Id,Opportunity> sogshaMap = new Map<Id,Opportunity>([
                                            SELECT
                                                Id
                                                ,SogiReviRef__r.KetteiSogisya__c
                                            FROM Opportunity
                                            WHERE Id in :pNewOnes
                                        ]);
        final List<String> PHASE_KETTEI_AFTER_SOUGIREV = new List<String>{'決定-葬儀レビ','施行待ち','施行完了','商談クローズ'};
        for(Opportunity newone:pNewOnes){
            Opportunity oldOpportunity = pOldOnes.get(newone.Id);

            if(newone.recordtypeId == Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SougiRev').getRecordTypeId()){
                if(PHASE_KETTEI_AFTER_SOUGIREV.contains(newone.StageName)
                    && oldOpportunity.StageName!=newone.StageName
                    && (newone.SogiReviRef__c==null ||
                    (newone.SogiReviRef__c!=null && String.isBlank(sogshaMap.get(newone.Id).SogiReviRef__r.KetteiSogisya__c)))) {
                    newone.addError('【フェーズ】を「決定」以降（決定-葬儀レビ、施行待ち、施行完了、商談クローズ）にする場合は【決定葬儀社】を入力してください。');
                    errFlg = true;
                    break;
                }
            }

        }
        return errFlg;
    }
}