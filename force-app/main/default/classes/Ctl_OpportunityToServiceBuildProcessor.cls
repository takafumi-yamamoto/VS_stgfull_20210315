public class Ctl_OpportunityToServiceBuildProcessor {
	
	List<Ctl_IOpportunityToServiceBuilder> builderList;
	
	public Ctl_OpportunityToServiceBuildProcessor() {
		builderList = new List<Ctl_IOpportunityToServiceBuilder>();
	}
	
    /**
     * 商談より
     *
     * @Auther Mizuno
     * @param  builder サービス情報とマッピングを行うヘルパーオブジェクト
     */
    public void addBuilder(Ctl_IOpportunityToServiceBuilder builder) {
        builderList.add(builder);
    }	
    
    /**
     * サービス商談とサービス情報を登録する。
     *
     * @Auther Mizuno
     */
    public void save() {
    	system.debug('====================Ctl_OpportunityToServiceBuildProcessor.save.begin===================');
        // 各種ヘルパーに登録されたケースとサービス情報を取得
        List<Dto_OpportunityServicePair> pairList = getPairList();        
        List<SObject> insertServiceList = getInsertServiceList(pairList);
        insert insertServiceList;
        
        //サービスオブジェクトとサービス商談を紐づく
        connectServiceOpportunityAndService(insertServiceList,pairList);
        system.debug('====================Ctl_OpportunityToServiceBuildProcessor.save.end===================');
    }  
    
    /**
     * 各種ヘルパーに登録されたケース情報より、更新ケースと作成サービス情報のペアを取得
     *
     * @Auther Mizuno
     * @return ケース-サービスペア
     */ 
    private List<Dto_OpportunityServicePair> getPairList() {
        List<Dto_OpportunityServicePair> pairList = new List<Dto_OpportunityServicePair>();

        for(Ctl_IOpportunityToServiceBuilder Builder : builderList) {
            pairList.addAll(Builder.getOpportunityServicePairList());
        }
        return pairList;
    } 
    
    /**
     * 更新対象サービス商談取得
     *
     * @Auther Mizuno 
     * @param  pairList サービス商談とサービスのペア(リスト)
     * @return          更新対象ケースリスト
     */
    private List<Opportunity> getUpdateOpportunityList(List<Dto_OpportunityServicePair> pairList) {
        List<Opportunity> opps = new List<Opportunity>();
        for(Dto_OpportunityServicePair pair : pairList) {
            opps.add(pair.oppObj);
        }
        return opps;
    }
    
    /**
     * 作成対象サービスリスト取得
     *
     * @Auther Mizuno 
     * @param  pairList サービス商談とサービスのペア(リスト)
     * @return          作成対象サービスリスト(シンプル安豪・お坊さん便等...)
     */
    private List<SObject> getInsertServiceList(List<Dto_OpportunityServicePair> pairList) {
        List<SObject> services = new List<SObject>();
        for(Dto_OpportunityServicePair pair : pairList) {
            services.add(pair.serviceObj);
        }
        return services;
    }   
    
    /**
     * サービスオブジェクトとサービス商談を紐づく
     *
     * @Auther Mizuno 
     * @param  insertServiceList 挿入したサービスオブジェクトリスト
     * @param  pairList サービス商談とサービスのペア(リスト)
     * @return          サービスリスト(シンプル安豪・お坊さん便等...)
     */    
    
    private void connectServiceOpportunityAndService(List<SObject> insertServiceList,List<Dto_OpportunityServicePair> pairList){
        
        List<Opportunity> updateOpportunityList = getUpdateOpportunityList(pairList);
        for (integer index=0;index<updateOpportunityList.size();index++){
        	Opportunity opp=updateOpportunityList[index];
        	SObject service=insertServiceList[index];
        	//シンプル安豪
        	if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo') ) {
        		opp.SimpleYasugoRef__c=service.id;
        	}
        	// 生前契約（事前契約）            
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Seizenkeiyaku') ) {
        		opp.SeizenKeiyakuRef__c=service.id;
        	}
            // お坊さん便           
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Obosanbin') ) {
        		opp.ObosanbinRef__c=service.id;
        	}
            // 永代供養           
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','PerpetualMemorial') ) {
        		opp.EitaiKuyoRef__c=service.id;
        	} 
            // ベスト仏壇           
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan') ) {
        		opp.BestButsudanRef__c=service.id;
        	}
            // 供花配達レビ           
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Kyouka') ) {
        		opp.KyokaHaitatsuRevRef__c=service.id;
        	}     
            // Umie           
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KaiyoUmie') ) {
        		opp.KaiyoSankotsuUmieRef__c=service.id;
        	}
            // Sorae           
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SpaceFuneral') ) {
        		opp.UchusoSoraeRef__c=service.id;
        	}
            // 墓ピタ 
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Hakapita') ) {
        		opp.HakaPitaRef__c=service.id;
        	} 
            // 格安墓石
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuBoseki') ) {
        		opp.KakuyasuBosekiRef__c=service.id;
        	}          	       	        	      	   	        	         	        	  	
            // 事前割
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','Simple_Jizenwari') ) {
                opp.JizenwariRef__c=service.id;
            }
            // お迎えフリー
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','OmukaeFree') ) {
                opp.OmukaeFreeRef__c=service.id;
            }
            // 対面相談
            /*else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','TaimenSodan') ) {
                opp.TaimenSodanRef__c=service.id;
            }*/
            // 喪主代行
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','MosyuDaiko') ) {
                opp.MosyuDaikoRef__c=service.id;
            }
            // 喪主代行
            else if(opp.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SougiRev') ) {
                opp.SogiReviRef__c=service.id;
            }
        }    	
    } 
         
}