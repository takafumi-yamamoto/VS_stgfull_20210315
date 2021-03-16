/**
 * クロスセル提案からサービス商談を作成する
 * ・クロスセル提案のトリガーから呼ばれる
 *
 */
public with sharing class CrossSellingTeianOpportunityCreate {
    public static final String TEIAN_EITAI = '永代供養';
    public static final String TEIAN_IHAI = '位牌';
    public static final String TEIAN_UMIE = '海洋散骨Umie';
    public static final String FROM_SIMPLEYASUGO = 'シンプル安豪';
    public static final String STR_PRICEBOOKID = '01s7F0000064fmI';
    public static final Map<String,String> MAP_SHIBORIKOMI = new Map<String,String>{
        Trg_CrossSellingTeian.PHASE_KIBOUARI => 'フォロー：クロスセル希望あり',
        Trg_CrossSellingTeian.PHASE_KENTOCHU => 'フォロー：クロスセル検討中'
    };
    public CrossSellingTeianOpportunityCreate() {

    }

    public void initialProcessing(List<CrossSellingTeian__c> newList, Map<ID, CrossSellingTeian__c> oldMap){
        Map<Id, Id> crossSellIdMap = new Map<Id, Id>();
        for(CrossSellingTeian__c crossSell : newList){
            if(crossSell.OtaiShienSogiyoRef__c == null){
                crossSellIdMap.put(crossSell.Id, crossSell.OpportunityRef__c);
            }
        }
        
        Map<Id, Opportunity> oppIdMap = new Map<Id, Opportunity>([select Id, (select Id from OpportunityOtoShienSogiyos__r) from Opportunity where Id = :crossSellIdMap.values()]);
        for(CrossSellingTeian__c crossSell : newList){
            if(crossSell.OtaiShienSogiyoRef__c == null && crossSellIdMap.containsKey(crossSell.Id)){
                String oppId = crossSellIdMap.get(crossSell.Id);
                if(oppIdMap.containsKey(oppId)){
                    Opportunity oppTemp = oppIdMap.get(oppId);
                    if(oppTemp.OpportunityOtoShienSogiyos__r.size() > 0){
                        OtaiShienSogiyo__c otaiTemp = oppTemp.OpportunityOtoShienSogiyos__r.get(0);
                        crossSell.OtaiShienSogiyoRef__c = otaiTemp.Id;
                    }
                }
            }
        }
        
        Trg_CrossSellingTeian.isActive = true;
    }

    /**
     * クロスセル提案用からサービス商談作成
     *　クロスセル提案の作成・更新時にサービス商談を作成する
     * @param list<CrossSellingTeian__c> クロスセル提案リスト
     * @return null
     */
    public void CreateServiceOpportunityFromCrossSellingTeian(List<CrossSellingTeian__c> CrossSellTeianLst){
        List<opportunity> insOppLst=new List<opportunity>();
        List<ID> opportunityIdList = new List<ID>();
        for(CrossSellingTeian__c c:CrossSellTeianLst){
            opportunityIdList.add(c.OpportunityRef__c);
        }
        //商談の詳細を取得
        Map<Id,Opportunity> opportunityMap = new Map<Id,Opportunity>([
                                            SELECT
                                                Id
                                                ,AccountId
                                                ,Account.Name
                                                ,Account.PersonContactId
                                                ,Utiagebi__c
                                                ,SimpleYasugoRef__c
                                                ,SimpleYasugoRef__r.TaishoshaRef__c
                                                ,SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c
                                            FROM Opportunity
                                            WHERE Id in:opportunityIdList
        ]);

        //クロスセル毎にクロスセル先の商談を作成する
        Map<Id,Opportunity> toOpportunityByCrossCellMap = new Map<Id,Opportunity>();
        for(CrossSellingTeian__c csteian:CrossSellTeianLst){
            if(csteian.OpportunityRef__c != null){
                Opportunity opportunity = new Opportunity();
                String serviceName='';
                String stageName = 'フォロー';

                //サービス商談のレコードタイプID
                String recordTypeId;
                if(TEIAN_EITAI.equals(csteian.TeianShohin__c)){
                    serviceName='永代供養';
                    recordTypeId= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('PerpetualMemorial').getRecordTypeId();
                }else if(TEIAN_IHAI.equals(csteian.TeianShohin__c)){
                    serviceName='ベスト仏壇';
                    recordTypeId= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KakuyasuButsudan').getRecordTypeId();
                }else if(TEIAN_UMIE.equals(csteian.TeianShohin__c)){
                    serviceName='海洋散骨';
                    recordTypeId= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('KaiyoUmie').getRecordTypeId();
                }else{
                    System.debug('サービス作成：対象外');
                    return;
                }
                Opportunity opp= new Opportunity();
                Opportunity motoOpportunity = opportunityMap.get(csteian.OpportunityRef__c);
                
                opp.recordTypeId = recordTypeId;
                opp.AccountId = motoOpportunity.accountId;
                opp.Name = motoOpportunity.account.Name + '_' + serviceName;
                opp.StageName = stageName;
                opp.CloseDate = date.Today();
                opp.SubPhase__c = csteian.TeianKekka__c;
                opp.RyunyumotoService__c = FROM_SIMPLEYASUGO;
                opp.Pricebook2Id = STR_PRICEBOOKID;
                opp.YorisonoOsoshikiSekobi__c = motoOpportunity.Utiagebi__c;

                toOpportunityByCrossCellMap.put(csteian.Id,opp);
            }
        }

        if(toOpportunityByCrossCellMap.size() > 0){
            upsert toOpportunityByCrossCellMap.values();
        }

        //作成した商談をクロスセルに設定する
        Map<Id,CrossSellingTeian__c> updateCrossSellingTeianMap = new Map<Id,CrossSellingTeian__c>();
        List<Id> insertOpportunityIdList = new List<Id>();
        for(CrossSellingTeian__c csteian:CrossSellTeianLst){
            if(toOpportunityByCrossCellMap.containsKey(csteian.Id)){
                CrossSellingTeian__c crossSellingTeian = new CrossSellingTeian__c();
                crossSellingTeian.Id = csteian.Id;
                crossSellingTeian.CrossSellingSakiOpportunityRef__c = toOpportunityByCrossCellMap.get(csteian.Id).Id;
                insertOpportunityIdList.add(crossSellingTeian.CrossSellingSakiOpportunityRef__c);
                updateCrossSellingTeianMap.put(crossSellingTeian.Id,crossSellingTeian);
            }
        }
        if(updateCrossSellingTeianMap.size() > 0) update updateCrossSellingTeianMap.values();

        //クロスセル先の永代供養・海洋散骨Umieに元の商談の対象者情報を設定する
        Map<Id,Opportunity> insertOpportunityMap = new Map<Id,Opportunity>([
            SELECT
                Id
                ,EitaiKuyoRef__c
                ,KaiyoSankotsuUmieRef__c
            FROM Opportunity
            WHERE id in:insertOpportunityIdList
        ]);

        Map<Id,EitaiKuyo__c> toEitaiKuyoByCrossCellMap = new Map<Id,EitaiKuyo__c>();
        Map<Id,KaiyoSankotsuUmie__c> toKaiyoSankotsuByCrossCellMap = new Map<Id,KaiyoSankotsuUmie__c>();

        for(CrossSellingTeian__c csteian:CrossSellTeianLst){
            if(csteian.OpportunityRef__c != null){
                Opportunity motoOpportunity = opportunityMap.get(csteian.OpportunityRef__c);
                Opportunity insertyOpportunity = insertOpportunityMap.get(updateCrossSellingTeianMap.get(csteian.Id).CrossSellingSakiOpportunityRef__c);
                //永代供養の場合
                if(motoOpportunity.SimpleYasugoRef__c!=null && insertyOpportunity.EitaiKuyoRef__c!=null){
                    EitaiKuyo__c eitaikuyo = new EitaiKuyo__c();
                    eitaikuyo.Id = insertyOpportunity.EitaiKuyoRef__c;
                    eitaikuyo.TaishoshaRef__c = motoOpportunity.SimpleYasugoRef__r.TaishoshaRef__c;
                    eitaikuyo.ZokugaraSodanshaNitottenoTaishosha__c = motoOpportunity.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c;

                    toEitaiKuyoByCrossCellMap.put(csteian.Id,eitaikuyo);
                }
                //海洋散骨Umieの場合
                if(motoOpportunity.SimpleYasugoRef__c!=null && insertyOpportunity.KaiyoSankotsuUmieRef__c!=null){
                    KaiyoSankotsuUmie__c kaiyosankotsu = new KaiyoSankotsuUmie__c();
                    kaiyosankotsu.Id = insertyOpportunity.KaiyoSankotsuUmieRef__c;
                    kaiyosankotsu.TaishoshaRef__c = motoOpportunity.SimpleYasugoRef__r.TaishoshaRef__c;
                    kaiyosankotsu.ZokugaraSodanshaNitottenoTaishosha__c = motoOpportunity.SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c;

                    toKaiyoSankotsuByCrossCellMap.put(csteian.Id,kaiyosankotsu);
                }
            }
        }

        if(toEitaiKuyoByCrossCellMap.size() > 0){
            update toEitaiKuyoByCrossCellMap.values();
        }
        if(toKaiyoSankotsuByCrossCellMap.size() > 0){
            update toKaiyoSankotsuByCrossCellMap.values();
        }

        //コンタクトを作成する
        List<Task> tasklist = new List<Task>();
        for(CrossSellingTeian__c crossteian:CrossSellTeianLst){
            if(toOpportunityByCrossCellMap.containsKey(crossteian.Id)){
                Task insTask = new Task();
                insTask.WhatId = toOpportunityByCrossCellMap.get(crossteian.Id).Id;
                insTask.WhoId = toOpportunityByCrossCellMap.get(crossteian.Id).Account.PersonContactId;
                insTask.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId();
                insTask.Status = '完了';
                insTask.ShiborikomiJoken__c = MAP_SHIBORIKOMI.get(crossteian.TeianKekka__c);
                insTask.YokenSyubetsu__c = '受電（お客様）';
                insTask.Description = crossteian.Comment__c;
                insTask.TaskSubtype = 'Call';
                tasklist.add(insTask);
            }
        }
        if(tasklist.size()>0) insert tasklist;
    }
    
}