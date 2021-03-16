public class Ctl_OpportunityLineItem {
    //メールToケースの時に、商談商品を作成
    public void createOpportunityLineItemByMail(list<Opportunity> oppLst) {

        list<OpportunityLineItem> OpportunityLineItemLst=new list<OpportunityLineItem>();
        //Product2 shohinPlan = [SELECT Id FROM Product2 WHERE ShohinBango__c = 'SBG-0000075' LIMIT 1];
        set<id> caseIdSet=new set<id>();
        map<id,case> caseMap=new map<id,case>();
        for (Opportunity opp:oppLst){            
            caseIdSet.add(opp.CaseRef__c);
        }
        for (case c:[select id,
                            Origin,
                            subject,
                            description,
                            recordtypeid
                       from case 
                      where id in :caseIdSet]){
            if (c.Origin!='メール'){
                continue;
            }
            caseMap.put(c.id,c);
        }
        for (Opportunity opp:oppLst){
        	//system.debug('***opp='+opp);
            case c=caseMap.get(opp.CaseRef__c);
            if (c==null) continue;
            if (c.recordtypeid==RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','BestButsudanOtoiawase')){
            //ベスト仏壇 
            	BestButsudanMailBodyAnalysis MailBodyAnalysis=new BestButsudanMailBodyAnalysis(c);
	            list<string> productNames=MailBodyAnalysis.shohinmeiLst;
	            for (integer index=0;index<productNames.size();index++){	         	
	                OpportunityLineItem oppItem=new OpportunityLineItem();
	                //商品名
	                oppItem.Shohinmei__c=MailBodyAnalysis.shohinmeiLst[index];
	                //商品型番
	                oppItem.ShohinKataban__c=MailBodyAnalysis.shohinKatabanLst[index];
	                //商品詳細
	                oppItem.ShohinShosai__c=MailBodyAnalysis.shohinShosaiLst[index];
	                //数量
	                oppItem.Quantity=MailBodyAnalysis.quantityLst[index];
	                //販売価格
	                oppItem.UnitPrice=MailBodyAnalysis.unitPriceLst[index];
	                //商品URL
	                oppItem.ShohinUrl__c=MailBodyAnalysis.shohinUrlLst[index];
	                //商品名
	                oppItem.Shohinmei__c=MailBodyAnalysis.shohinmeiLst[index];	
	                //商談
	                oppItem.Opportunityid=opp.id;  
	                
	                oppItem.PricebookEntryId=getPricebookEntryId('ベスト仏壇');
	                OpportunityLineItemLst.add(oppItem);
	            }            
            }    
        }        
        insert OpportunityLineItemLst;
    }
    
    public id getPricebookEntryId(string PricebookEntryName){
    	list<string> productNameLst=new list<string>();
    	map<string,id> PricebookEntryMap = new map<string,id>();
    	list<id> productIdLst=new list<string>();
    	productNameLst.add('ベスト仏壇');
    	for (product2 p:[select id,name from product2 where name in :productNameLst]){
    		productIdLst.add(p.id);
    	}
    	pricebook2 pk=[select id,name from pricebook2 where IsStandard=true];
    	system.debug('***pk.id='+pk.id);
    	system.debug('***productIdLst='+productIdLst);
    	for (PricebookEntry pke:[select id,name from PricebookEntry where pricebook2id=:pk.id and product2id in :productIdLst]){
    		PricebookEntryMap.put(pke.name,pke.id);
    	}
    	return PricebookEntryMap.get(PricebookEntryName);
    }

	private static ApplyingProductDefaultToLineItems f_applyingProductDefaultToLineItems;
	public static ApplyingProductDefaultToLineItems getInstanceOfApplyingProductDefaultToLineItems(){
		return new ApplyingProductDefaultToLineItems( Dao_Product2.getInstance() );
	}
	public class ApplyingProductDefaultToLineItems{
		private Dao_Product2 f_Dao_Product2;
		private ApplyingProductDefaultToLineItems(Dao_Product2 pDao_Product2){
			this.f_Dao_Product2 = pDao_Product2;
		}

		public void onOpportunityLineItemBeforeInsert(List<OpportunityLineItem> newOnes){
			
			Map<Id,SObject> theProductsMapByid
				= SobjectsExtension.listToMap(
					this.f_Dao_Product2.selectByIds( OpportunityLineItemLinq.collectProductIds(newOnes) )
				);
		
			for(OpportunityLineItem aLineItem : newOnes){
				Product2 theProduct = (Product2)theProductsMapByid.get(aLineItem.Product2Id);
				this.applyProductDefaults(aLineItem, theProduct);
			}
		}

		public void onOpportunityLineItemBeforeUpdate(List<OpportunityLineItem> newOnes, Map<Id,OpportunityLineItem> oldOnes){
			
			Map<Id,SObject> theProductsMapByid
				= SobjectsExtension.listToMap(
					this.f_Dao_Product2.selectByIds( OpportunityLineItemLinq.collectProductIds(newOnes) )
				);

			for(OpportunityLineItem aNewOne : newOnes){
				OpportunityLineItem aOldOne = oldOnes.get(aNewOne.Id);
				Boolean toProcess = aOldOne.UnitPrice != aNewOne.UnitPrice || aOldOne.Quantity != aNewOne.Quantity;

				if(toProcess){
					Product2 theProduct = (Product2)theProductsMapByid.get(aNewOne.Product2Id);

					Boolean theSireChangedThisTime = aOldOne.SireKingaku__c != aNewOne.SireKingaku__c;
					if(!theSireChangedThisTime){
						aNewOne.SireKingaku__c = calculateSireKingaku(aNewOne, theProduct);
					}

					Boolean theTesuryoChangedThisTime = aOldOne.TesuryoPartner__c != aNewOne.TesuryoPartner__c;
					if(!theTesuryoChangedThisTime){
						aNewOne.TesuryoPartner__c = calculateTesuryoKingaku(aNewOne, theProduct);
					}
				}
			}
		}

		private void applyProductDefaults(OpportunityLineItem pLineItem, Product2 pProduct){
			pLineItem.ShohinKamoku__c = pProduct.ShohinKamoku__c;
			pLineItem.HinmokuBunrui__c = pProduct.HinmokuBunrui__c;
			pLineItem.SireKingaku__c = this.calculateSireKingaku(pLineItem, pProduct);
			pLineItem.TesuryoPartner__c = this.calculateTesuryoKingaku(pLineItem, pProduct);
		}
		private Decimal calculateSireKingaku(OpportunityLineItem pOppLineItem, Product2 pProduct){
			if(pProduct.SireKingakuKeisanHousiki__c == '販売金額') return pOppLineItem.UnitPrice * pOppLineItem.Quantity;
			if(pProduct.SireKingakuKeisanHousiki__c == '設定金額') return pProduct.SireKingaku__c * pOppLineItem.Quantity;
			return pOppLineItem.SireKingaku__c;
		}
		private Decimal calculateTesuryoKingaku(OpportunityLineItem pOppLineItem, Product2 pProduct){
			return pProduct.TesuryoKingakuKeisanHoushiki__c == '設定金額' 
				? pProduct.TesuryoKingaku__c * pOppLineItem.Quantity 
				: pOppLineItem.TesuryoPartner__c;
		}


	}

	public class RegisteringTesuryoCyoseiMeisais{

		@TestVisible private Map<Id,SObject> f_ProductsMapByid = null;
		private Dao_Product2 f_Dao_Product2 = Dao_Product2.getInstance();
		public void onOpportunityLineItemAfterInsert(List<OpportunityLineItem> newOnes){
			
			this.f_ProductsMapByid
				= SobjectsExtension.listToMap(
					this.f_Dao_Product2.selectByIds( OpportunityLineItemLinq.collectProductIds(newOnes) )
				);

			List<OpportunityLineItem> theEntriestoProcess = this.getEntriestoProcess(newOnes);
			List<PatnerUriage__c> theTesuryoCyoseiMeisais = this.createTesuryoCyoseiMeisais(theEntriestoProcess);
			Insert theTesuryoCyoseiMeisais;
		}

		@TestVisible
		private List<OpportunityLineItem> getEntriestoProcess(List<OpportunityLineItem> pLineItems){
	
			List<OpportunityLineItem> theEntries = new List<OpportunityLineItem>();

			for(OpportunityLineItem aLineItem : pLineItems){
				if( this.isToProcess( aLineItem ) ) theEntries.add(aLineItem);
			}
			return theEntries;
		}

		private Boolean isToProcess(OpportunityLineItem aLineItem){
			Product2 theProduct = (Product2)this.f_ProductsMapByid.get(aLineItem.Product2Id);
			return theProduct.TesuryoCyoseiKingakuKeisanHoushiki__c == '販売金額_符号反転';
		}

		@TestVisible
		private List<PatnerUriage__c> createTesuryoCyoseiMeisais(List<OpportunityLineItem> pLineItems){
			List<PatnerUriage__c> theTesuryoCyoseiMeisais = new List<PatnerUriage__c>();
			for(OpportunityLineItem aLineItem : pLineItems){
				theTesuryoCyoseiMeisais.add( this.createTesuryoCyoseiMeisai(aLineItem) );
			}
			return theTesuryoCyoseiMeisais;
		}

		private PatnerUriage__c createTesuryoCyoseiMeisai(OpportunityLineItem aLineItem){
			Product2 theProduct = (Product2)this.f_ProductsMapByid.get(aLineItem.Product2Id);
			Decimal theKingaku = 
				theProduct.TesuryoCyoseiKingakuKeisanHoushiki__c == '販売金額_符号反転'
				? (aLineItem.UnitPrice * aLineItem.Quantity) * -1
				: 0;
			return new PatnerUriage__c(
				Syodan__c = aLineItem.OpportunityId,
				Syohin__c = theProduct.TesuryoCyoseiShohin__c,
				Kingaku__c = theKingaku,
				MeisaiSetsumei__c = theProduct.Name
			);
		}


	}
}