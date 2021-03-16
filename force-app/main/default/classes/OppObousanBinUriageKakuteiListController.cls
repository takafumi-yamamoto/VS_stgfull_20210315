/*お坊さん便売上確定一覧コントローラー*/
public with sharing class OppObousanBinUriageKakuteiListController{
	private static String DATA_KUBUN_1 = '1:通常商品';
    private static String DATA_KUBUN_2 = '2:割引プラン';
    private static String DATA_KUBUN_3 = '3:クーポン';
    public Date     searchFromDate{get;set;}    //検索条件From日付
    public Date     searchToDate{get;set;}      //検索条件To日付

    public String   searchNegoId{get;set;} //検索条件　内部商談ID

    public Integer  rsltSize{get;set;} //検索結果件数
    public Integer  pageSizeNum =Integer.valueOf(UriagehyouSetting__c.getInstance(UserInfo.getUserId()).pageSizeNum__c);
    //ページング用コントローラー
    private ApexPages.StandardSetController Controller {get; set;}

    //チェックボックスで選択されたオブジェクトのIDの集合（ページングしても維持され続ける）
    public Set<Id> EntireSelectedIds {get; set;}
    //ラッパーのリスト（1画面分。ページング毎にリフレッシュ）
    private List<UriageShowWrapper> uriageList;
    //コンストラクタ
    public OppObousanBinUriageKakuteiListController() {
    	system.debug('==========OppObousanBinUriageKakuteiListController.begin==============');

        ApexPages.getMessages().clear();

        //検索条件パラメタ取得
        String param_from_date  = ApexPages.currentPage().getParameters().get('param_from_date');//施行日日付
        String param_to_date    = ApexPages.currentPage().getParameters().get('param_To_date');//施行日日付
        String search_negoId    = ApexPages.currentPage().getParameters().get('search_negoId');//内部商談ID
        String s_flg            = ApexPages.currentPage().getParameters().get('s_flg');//検索画面遷移フラグ

        String messe            = ApexPages.currentPage().getParameters().get('messe');//確定処理OKメッセージ用

        //検索条件パラメタ設定 役務提供予定日
        if( param_from_date!=null ){
            searchFromDate = Date.valueOf(param_from_date); 
        }else{
            //初期表示
            if(s_flg ==null){
                searchFromDate = Date.today().toStartOfMonth();//月初設定
            }else if(s_flg =='true'){
                searchFromDate = null;
            }           
        }

        if( param_To_date!=null ){
            searchToDate = Date.valueOf(param_To_date); 
        }else{
            //初期表示
            if(s_flg ==null){
                searchToDate = Date.today()-1;
            //検索から遷移
            }else if(s_flg =='true'){
                searchToDate = null;
            }               
        }

        if(!String.isBlank(search_negoId)){
            searchNegoId = search_negoId;
        }else if(searchNegoId == null){
            searchNegoId =null;
        }

        if(messe=='success'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Utility_Message.SUCCESS_KAKUTEI));
        }   

        //検索実行・画面描画
        system.debug('==========検索実行・画面描画.begin==============');
        this.Controller = new ApexPages.StandardSetController(Database.getQueryLocator(createQuery()));
        system.debug('==========検索実行・画面描画.end==============');
        rsltSize = this.Controller.getResultSize();//検索結果件数表示      
        if(rsltSize >= 1000){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Utility_Message.OVERLISTSIZELIMIT ));
        }   
        system.debug('**rsltSize='+rsltSize);

        this.Controller.setPageSize(pageSizeNum);//1ページ表示件数設定
        this.EntireSelectedIds = new Set<Id>();//選択
        system.debug('==========OppObousanBinUriageKakuteiListController.end==============');

    }
   //SOQL生成
   private String createQuery() {
        String sQuery =  'SELECT  id,'
            +' Utiagebi__c, '//売上日
        	//お坊さん便の窓口契約→提携先→所属寺院→取引先番号
            +' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.TorihikisakiBango__c, '        
            //お坊さん便の窓口契約→提携先→所属寺院名
            +' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.name, '   
            //お坊さん便の窓口契約→手配区分
            +' ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c, '
            //商談番号
            +' ShodanBango__c,ShodanBangoF__c,'
            //レコードタイプ
            +' recordtype.name, '
            //確定日
            +' KakuteibiSyodan__c, '
            //商談のフェーズとサブフェーズ
             +' StageName, '
             +' SubPhase__c, '
            //流入経路（他サービス経由）
            +' RyunyumotoService__c, '
            //お坊さん便-プラン
            +' ObosanbinRef__r.MemorialServicePlan__c, '
            //法要日
            +' ObosanbinRef__r.KokubetsuDateTime_Inp__c, '
            //依頼書・手配報告書送付日
            +' ObosanbinRef__r.IraiTehaiDate__c, '
            //手数料計
            +' UriageGakuPartnerExp__c, '
            //流入経路（新規）
            +' Iriguchi__c, '
            //入金締切日(パートーナー)
            +' NyukinSimekiriBiPartner__c, '
            //チケット送付日
            +' ObosanbinRef__r.TicketSendingDate__c, '
            //支払予定額(パートナー)
            +' ShiharaiYoteiGakuPartnerExp__c, '
            //支払期日(パートナー)
            +' ShiharaiKijitsuPartner__c, ' 
            //請求残高
            +' SeikyuZandaka__c, ' 
            //請求予定額(パートナー)
            +' SeikyuYoteiGakuPartnerExp__c, '                   
            //金額 
            +' Amount'  
            +' FROM Opportunity '
            +' WHERE '
            +' IsClosed!=true and recordtype.developername=\''+'Obosanbin'+ '\'';        

        /*検索条件設定*/                
        //検索条件：売上日
        if( searchFromDate!=null ){
            sQuery+=' AND Utiagebi__c >= '+ Datetime.newInstance(searchFromDate.year(), searchFromDate.month(),searchFromDate.day()).format('yyyy-MM-dd');
        }

        if( searchToDate!=null ){
            sQuery+=' AND Utiagebi__c <= ' + Datetime.newInstance(searchToDate.year(), searchToDate.month(),searchToDate.day()).format('yyyy-MM-dd');
        }       


        //検索条件：内部商談ID
        if(!String.isBlank(searchNegoId)){
            sQuery+= ' AND ShodanBango__c =\'' + searchNegoId + '\'';
        }

        sQuery+= ' ORDER BY Utiagebi__c ASC LIMIT 1000';

        return sQuery;
    }
    
  //SOQL生成
   private list<opportunity> getSelectedList(list<id> oppids) {
   		list<opportunity> oppLst=new list<opportunity>();
   		oppLst=[select id,
   		               Utiagebi__c,
   		               SeikyuZandaka__c,
   		               SeikyuYoteiGakuPartnerExp__c,
   		               ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.TorihikisakiBango__c,
   		               ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.name,
   		               ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c,
   		               ShodanBango__c,ShodanBangoF__c,
   		               recordtype.name,
   		               KakuteibiSyodan__c,
   		               StageName,
   		               SubPhase__c, 
   		               RyunyumotoService__c,
   		               ObosanbinRef__r.MemorialServicePlan__c, 
   		               ObosanbinRef__r.KokubetsuDateTime_Inp__c, 
   		               ObosanbinRef__r.IraiTehaiDate__c,
   		               UriageGakuPartnerExp__c, 
   		               Iriguchi__c,
   		               NyukinSimekiriBiPartner__c, 
   		               ObosanbinRef__r.TicketSendingDate__c,
   		               ShiharaiYoteiGakuPartnerExp__c,
   		               ShiharaiKijitsuPartner__c,
   		               Amount, 
   		               TorihikiShodanRef__r.ShodanBangoF__c, 
   		               Account.TorihikisakiBangoF__c, 
   		               Account.name,Account.LastName,Account.FirstName,
   		               ObosanbinRef__r.Taishosha1Ref__r.LastName,ObosanbinRef__r.Taishosha1Ref__r.FirstName,
   		               ObosanbinRef__r.PartnerTorihikiSakiBangoExp__c,
   		               JucyuGokeiKingakuWaribikiJogai__c,
   		                                (SELECT Id,
   		                             OpportunityId,
   		                             Product2.KaikeiHinmokuCode__c,
   		                             Product2.ProductCode,
   		                             Product2.Name,
   		                             Product2.SyohinKategoriCode__c,
   		                             Product2.k_ShohinSyubetsuRef__r.ID__c,
   		                             Product2.k_ShohinCategory_Id_exp__c,
   		                             product2.k_WaribikiPlan_Id_exp__c,
   		                             Product2.k_Coupon_Id_exp__c,
   		                             Product2.k_ShohinCategory_Name_exp__c,
   		                             TotalPrice,Product2.KuponCode__c,
   		                             UnitPrice,Product2.SougiPlan__c,
   		                             Product2.ShohinBango__c,
   		                             Product2.k_Service_Name_exp__c,
   		                             Product2.DataKubun__c,
   		                             Product2.WaribikiPlanCode__c,
   		                             Product2.k_WaribikiPlan_Name_exp__c FROM OpportunityLineItems)
   		            FROM Opportunity 
   		            WHERE id in :oppids
   		               
   		];
        return oppLst;
    }           
    /*検索処理(検索条件パラメタ設定)*/    
    public PageReference search() {
    	system.debug('==========search begin================');

        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());

        pageRef.getParameters().put('s_flg','true');//検索ボタン遷移フラグ

        //検索条件：チケット送付日From　条件設定維持
        if(searchFromDate!=null){
            pageRef.getParameters().put('param_from_date',String.valueOf(searchFromDate));
        }else{
            pageRef.getParameters().put('param_from_date',null);
        }

        //検索条件：チケット送付日To　条件設定維持
        if(searchToDate!=null){
            pageRef.getParameters().put('param_to_date',String.valueOf(searchToDate));
        }else{
            pageRef.getParameters().put('param_to_date',null);
        }

        //検索条件：内部商談ID　条件設定維持
        if(!String.isBlank(searchNegoId)){
            pageRef.getParameters().put('search_negoId',String.valueOf(searchNegoId));
        }else{
            pageRef.getParameters().put('search_negoId','');            
        }

        pageRef.getParameters().put('messe','null');//確定処理OKメッセージ用パラメタ

        pageRef.setRedirect(true);
        system.debug('==========search end================');
        return pageRef;
    } 
    
    /*売上確定処理*/
    public PageReference doUriageKakutei(){

        Savepoint sp = Database.setSavepoint();

        try {

            /*選択データ抽出*/
            List<Opportunity>selecteduriageList =new List<Opportunity>();
            List<id>selectedOppidList =new List<id>();
           for(Integer idx=0; idx<uriageList.size(); idx++){
                  if( uriageList[idx].IsSelected ){
                    selectedOppidList.add(uriageList[idx].record.id);
                  }
           }
           selecteduriageList=getSelectedList(selectedOppidList);
           

            /*選択チェック：選択有->伝票データ作成 選択無し->エラーメッセージ表示　*/
            if(selecteduriageList.size() > 0){

                /*入力チェック*/
                Set<boolean> chkRsltSet = chkInput(selecteduriageList);
                if ( chkRsltSet.contains(false)){
                    return null;
                }
                
                /*商談クローズ*/
                CloseOpp(selecteduriageList);

                /*画面遷移　パラメタ設定*/
                PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
                pageRef.getParameters().put('s_flg','true');//検索ボタン遷移フラグ
        
                if(searchFromDate!=null){
                    pageRef.getParameters().put('param_from_date',String.valueOf(searchFromDate));
                }

                if(searchToDate!=null){
                    pageRef.getParameters().put('param_to_date',String.valueOf(searchToDate));
                }
                if(!String.isBlank(searchNegoId)){
                    pageRef.getParameters().put('search_negoId',searchNegoId);
                }

                pageRef.getParameters().put('messe','success');//確定処理OKメッセージ用パラメタ

                pageRef.setRedirect(true);
                return pageRef;

            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Utility_Message.NO_SELECT_URIAGE_TARGET));
                return null;
            }

        } catch (Exception e) {
            Database.rollback(sp);
            Utility_Common.msgError(e);
            return null;
        } 

    }  
    /*入力チェック*/
    public  Set<boolean> chkInput(List<Opportunity> targetList){

        Set<boolean> rsltSet = new Set<boolean>();
        boolean rsltFlg = true;
        list<id> oppIds=new list<id>();
        for (Opportunity opp : targetList){
        	oppIds.add(opp.id);
        }
        map<id,list<PatnerUriage__c>> PatnerUriagesMap = new map<id,list<PatnerUriage__c>>();
        list<PatnerUriage__c> PatnerUriageLst= Dao_PatnerUriage.getPatnerUriageByOppids(oppIds);
        for (PatnerUriage__c PatnerUriage:PatnerUriageLst){
        	if (PatnerUriagesMap.get(PatnerUriage.Syodan__c)==null){
        		list<PatnerUriage__c> PatnerUriageLstTmp=new list<PatnerUriage__c>();
        		PatnerUriageLstTmp.add(PatnerUriage);
        		PatnerUriagesMap.put(PatnerUriage.Syodan__c,PatnerUriageLstTmp);
        	}else{
        		list<PatnerUriage__c> PatnerUriageLstTmp=PatnerUriagesMap.get(PatnerUriage.Syodan__c);
        		PatnerUriageLstTmp.add(PatnerUriage);
        	}
        }
        map<id,list<OkyakusamaSeikyuMeisai__c>> OkyakusamaSeikyuMeisaiMap = new map<id,list<OkyakusamaSeikyuMeisai__c>>();
        list<OkyakusamaSeikyuMeisai__c> OkyakusamaSeikyuMeisaiLst=Dao_OkyakusamaSeikyuMeisai.getOkyakusamaSeikyuMeisaiByOppids(oppIds);
        for (OkyakusamaSeikyuMeisai__c OkyakusamaSeikyuMeisai:OkyakusamaSeikyuMeisaiLst){
        	if (OkyakusamaSeikyuMeisaiMap.get(OkyakusamaSeikyuMeisai.OpportunityRef__c)==null){
        		list<OkyakusamaSeikyuMeisai__c> OkyakusamaSeikyuMeisaiLstTmp=new list<OkyakusamaSeikyuMeisai__c>();
        		OkyakusamaSeikyuMeisaiLstTmp.add(OkyakusamaSeikyuMeisai);
        		OkyakusamaSeikyuMeisaiMap.put(OkyakusamaSeikyuMeisai.OpportunityRef__c,OkyakusamaSeikyuMeisaiLstTmp);
        	}else{
        		list<OkyakusamaSeikyuMeisai__c> OkyakusamaSeikyuMeisaiLstTmp=OkyakusamaSeikyuMeisaiMap.get(OkyakusamaSeikyuMeisai.OpportunityRef__c);
        		OkyakusamaSeikyuMeisaiLstTmp.add(OkyakusamaSeikyuMeisai);
        	}
        }
        

        for(Opportunity opp : targetList){
    
            rsltFlg = true;
            String messe ='';
            //支払予定額 > 0 && 支払期日 = null -> 支払期日が未入力です
            //商談番号
            if (opp.ShiharaiYoteiGakuPartnerExp__c>0 && opp.ShiharaiKijitsuPartner__c==null){
            	messe += Utility_Message.INPUT_CHK_NO_SHIHARAIKIJITSUPARTNER; 
            	rsltFlg = false;
            }           
            //請求予定額(パートナー) > 0 && 入金締切日 = null -> 入金締切日が未入力です
            if (opp.SeikyuYoteiGakuPartnerExp__c>0 && opp.NyukinSimekiriBiPartner__c==null){
            	messe += Utility_Message.INPUT_CHK_NO_NYUKINSIMEKIRIBIPARTNER; 
            	rsltFlg = false;
            }       
            //お客様請求残高 != 0 -> お客様請求残高が残っています。        
            if (opp.SeikyuZandaka__c!=0){
            	messe += Utility_Message.INPUT_CHK_NOTZERO_SEIKYUZANDAKA; 
            	rsltFlg = false;
            }  
            //手数料計 == 0 -> 手数料計が0円です
            if (opp.UriageGakuPartnerExp__c==0){
            	messe += Utility_Message.INPUT_CHK_ZERO_URIAGEGAKUPARTNEREXP; 
            	rsltFlg = false;
            }  
            
            //お坊さん便-プラン == null -> お坊さん便プラン未入力
            if (opp.ObosanbinRef__r.MemorialServicePlan__c==null){
            	messe += Utility_Message.INPUT_CHK_NO_MEMORIALSERVICEPLAN; 
            	rsltFlg = false;
            }    
            //所属寺院取引先番号 == null -> 寺院未入力
            if (opp.ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.TorihikisakiBango__c==null){
            	messe += Utility_Message.INPUT_CHK_NO_JIINTORIHIKISAKIBANGO; 
            	rsltFlg = false;
            }            
                                
            
            //商談番号
            if (opp.ShodanBangoF__c==null){
            	messe += Utility_Message.INPUT_CHK_NO_SHODANBANGO; 
            	rsltFlg = false;
            }
            //親商談番号
            if (opp.TorihikiShodanRef__r.ShodanBangoF__c==null){
            	messe += Utility_Message.INPUT_CHK_NO_TORIHIKISHODANSHODANBANGO; 
            	rsltFlg = false;
            }            
            
            //取引先番号
            if (opp.Account.TorihikisakiBangoF__c==null){
            	messe += Utility_Message.INPUT_CHK_NO_TORIHIKIBANGO; 
            	rsltFlg = false;
            }  
            //取引先名
            if (opp.Account.name==null &&opp.Account.LastName==null && opp.Account.FirstName==null){
            	messe += Utility_Message.INPUT_CHK_NO_TORIHIKINAME; 
            	rsltFlg = false;
            } 
            //対象者            
            /*if (opp.ObosanbinRef__r.Taishosha1Ref__r.LastName==null &&opp.ObosanbinRef__r.Taishosha1Ref__r.FirstName==null){
            	messe += Utility_Message.INPUT_CHK_NO_TAISHOSHA; 
            	rsltFlg = false;
            }*/        
 
            //売上日
            if(opp.Utiagebi__c==null){
                messe += Utility_Message.INPUT_CHK_NO_UTIAGEBI; 
                rsltFlg = false;
            }
            //提携先マスタID
            if(opp.ObosanbinRef__r.PartnerTorihikiSakiBangoExp__c==null){
                messe += Utility_Message.INPUT_CHK_NO_PARTNERTORIHIKISAKIBANGOEXP; 
                rsltFlg = false;
            }   
            //受注合計金額(割引除外)
            if(opp.JucyuGokeiKingakuWaribikiJogai__c==null){
                messe += Utility_Message.INPUT_CHK_NO_JUCYUGOKEIKINGAKUWARIBIKIJOGAI; 
                rsltFlg = false;
            }                     
            //金額
            if(opp.Amount==null){
                messe += Utility_Message.INPUT_CHK_NO_AMOUNT; 
                rsltFlg = false;
            }

            //確定日
            if(opp.KakuteibiSyodan__c==null){
                messe += Utility_Message.INPUT_CHK_NO_KAKUTEIBISYODAN; 
                rsltFlg = false;
            }
                        
            //本体商品の判断
            List<OpportunityLineItem> HontaiUriages=readHontaiUriages(Opp);
            if (HontaiUriages.size()<=0){
                messe += Utility_Message.INPUT_CHK_NO_HONTAIURIAGE; 
                rsltFlg = false;           	
            }else{
            	for (OpportunityLineItem hontaiUriage:HontaiUriages){
                    //商品番号
            		if (hontaiUriage.Product2.ShohinBango__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_SHOHINBANGO; 
		                rsltFlg = false;            			
            		}
                    //商品名
            		if (hontaiUriage.Product2.Name==null){
		                messe += Utility_Message.INPUT_CHK_NO_PRODUCT2NAME; 
		                rsltFlg = false;            			
            		}
                    //商品カテゴリーコード
            		if (hontaiUriage.Product2.k_ShohinCategory_Id_exp__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_PRODUCT2SHOHINCATEGORY; 
		                rsltFlg = false;            			
            		}             		
                    //商品カテゴリーコード
            		if (hontaiUriage.Product2.k_ShohinCategory_Id_exp__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_PRODUCT2SHOHINCATEGORY; 
		                rsltFlg = false;            			
            		}
                    //定価
            		if (hontaiUriage.TotalPrice==null){
		                messe += Utility_Message.INPUT_CHK_NO_TOTALPRICE; 
		                rsltFlg = false;            			
            		}            		            		            		
            	}
            }
            
            //オプション商品の判断
            List<OpportunityLineItem> OptionUriages=readOptionUriages(Opp);
            if (OptionUriages.size()>0){
            	for (OpportunityLineItem OptionUriage:OptionUriages){
                    //商品番号
            		if (OptionUriage.Product2.ShohinBango__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_SHOHINBANGO; 
		                rsltFlg = false;            			
            		}
                    //商品名
            		if (OptionUriage.Product2.Name==null){
		                messe += Utility_Message.INPUT_CHK_NO_PRODUCT2NAME; 
		                rsltFlg = false;            			
            		}
                    //商品カテゴリーコード
            		if (OptionUriage.Product2.k_ShohinCategory_Id_exp__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_PRODUCT2SHOHINCATEGORY; 
		                rsltFlg = false;            			
            		}             		
                    //商品カテゴリーコード
            		if (OptionUriage.Product2.k_ShohinCategory_Id_exp__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_PRODUCT2SHOHINCATEGORY; 
		                rsltFlg = false;            			
            		}
                    //定価
            		if (OptionUriage.TotalPrice==null){
		                messe += Utility_Message.INPUT_CHK_NO_TOTALPRICE; 
		                rsltFlg = false;            			
            		}            		            		            		
            	}                
            }
            
            //waribiki商品の判断
            List<OpportunityLineItem> Waribikis=readWaribikis(Opp);
            if (Waribikis.size()>1){
                messe += Utility_Message.INPUT_CHK_NO_WARIBIKINUMBERS; 
                rsltFlg = false;              	
            }else if (Waribikis.size()==1){
            	for (OpportunityLineItem Waribiki:Waribikis){
            		if (Waribiki.Product2.k_WaribikiPlan_Id_exp__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_WARIBIKIPLANID; 
		                rsltFlg = false;              		
	            		
	            	}
            		if (Waribiki.TotalPrice==null){
		                messe += Utility_Message.INPUT_CHK_NO_WARIBIKIPLANID; 
		                rsltFlg = false;              		
	            		
	            	}	            	
            	}
            }
           //Coupon商品の判断
           List<OpportunityLineItem> Coupons=readCoupons(Opp);
           if (Coupons.size()>0){
            	for (OpportunityLineItem Coupon:Coupons){
            		if (Coupon.Product2.k_Coupon_Id_exp__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_COUPONID; 
		                rsltFlg = false;              		
	            		
	            	}
            		if (Coupon.TotalPrice==null){
		                messe += Utility_Message.INPUT_CHK_NO_WARIBIKIPLANID; 
		                rsltFlg = false;              		
	            		
	            	}		            	
            	}
           }
           //パートナチェック
           list<PatnerUriage__c> thePatnerUriageLst=PatnerUriagesMap.get(Opp.id);
           if (thePatnerUriageLst!=null){
	           for (PatnerUriage__c PatnerUriage:thePatnerUriageLst){
	           	   //パートナ商品名
	               if (PatnerUriage.Syohin__r.name==null){
		                messe += Utility_Message.INPUT_CHK_NO_PARTNERDISCOUNTSYOHINNAME; 
		                rsltFlg = false;                        		
	               }
	           	   //パートナ金額
	               if (PatnerUriage.Kingaku__c==null){
		                messe += Utility_Message.INPUT_CHK_NO_PARTNERDISCOUNTKINGAKU; 
		                rsltFlg = false;                        		
	               }               
	           	
	           }           	
           }

           
           //Paymentチェック
           list<OkyakusamaSeikyuMeisai__c> theOkyakusamaSeikyuMeisaiLst=OkyakusamaSeikyuMeisaiMap.get(Opp.id);
           if (theOkyakusamaSeikyuMeisaiLst!=null){
	           for (OkyakusamaSeikyuMeisai__c OkyakusamaSeikyuMeisai:theOkyakusamaSeikyuMeisaiLst){
	           	   if (OkyakusamaSeikyuMeisai.SeikyuHouhou__c!='sousai'){
	           	   	
	           	   	   //決済日
	           	       if (OkyakusamaSeikyuMeisai.Kessaibi__c==null){
		 	                messe += Utility_Message.INPUT_CHK_NO_KESSAIBI; 
			                rsltFlg = false;
	           	       }
	           	   	   //請求金額
	           	       if (OkyakusamaSeikyuMeisai.SeikyuKingaku__c==null){
		 	                messe += Utility_Message.INPUT_CHK_NO_SEIKYUKINGAKU; 
			                rsltFlg = false;
	           	       }
	           	   	   //請求方法コード
	           	       if (OkyakusamaSeikyuMeisai.SeikyuHohoCode__c==null){
		 	                messe += Utility_Message.INPUT_CHK_NO_SEIKYUHOHOCODE; 
			                rsltFlg = false;
	           	       }	           	                  	   	
	           	   }else{
	           	   	   //相殺先相談番号
	           	       if (OkyakusamaSeikyuMeisai.SousaiSakiShodanRef__r.ShodanBangoF__c==null){
		 	                messe += Utility_Message.INPUT_CHK_NO_SOUSAISAKISHODANREFSHODANBANGO; 
			                rsltFlg = false;
	           	       }
	           	   	   //請求金額
	           	       if (OkyakusamaSeikyuMeisai.SeikyuKingaku__c==null){
		 	                messe += Utility_Message.INPUT_CHK_NO_SEIKYUKINGAKU; 
			                rsltFlg = false;
	           	       }            	                  	   	
	           	   }           	   
	           }           	
           }

                                                          
            if(!rsltFlg){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '【 商談番号：'+opp.ShodanBango__c+' 】　'+ messe));
            }
            rsltSet.add(rsltFlg);
        }

        return rsltSet;        
    }
    
    List<OpportunityLineItem> readHontaiUriages(Opportunity Opp){
    	List<OpportunityLineItem> hontaiUriages=new List<OpportunityLineItem>();
    	for (OpportunityLineItem item:Opp.OpportunityLineItems){
    		if ((item.Product2.k_ShohinSyubetsuRef__r.ID__c=='1'||item.Product2.k_ShohinSyubetsuRef__r.ID__c=='2' ) && item.Product2.DataKubun__c==DATA_KUBUN_1){
    			hontaiUriages.add(item);
    		}        		
    	}
    	return hontaiUriages;
    }
    List<OpportunityLineItem> readWaribikis(Opportunity Opp){
    	List<OpportunityLineItem> waribikis=new List<OpportunityLineItem>();
    	for (OpportunityLineItem item:Opp.OpportunityLineItems){
    		if (item.Product2.DataKubun__c==DATA_KUBUN_2){
    			waribikis.add(item);
    		}        		
    	}
    	return waribikis;
	}   
    List<OpportunityLineItem> readOptionUriages(Opportunity Opp){
    	List<OpportunityLineItem> optionUriages=new List<OpportunityLineItem>();
    	for (OpportunityLineItem item:Opp.OpportunityLineItems){
    		if ((item.Product2.k_ShohinSyubetsuRef__r.ID__c=='3'||item.Product2.k_ShohinSyubetsuRef__r.ID__c=='4') && item.Product2.DataKubun__c==DATA_KUBUN_1){
    			optionUriages.add(item);
    		}        		
    	}
    	return optionUriages;  	
    }	
    List<OpportunityLineItem> readCoupons(Opportunity Opp){
    	List<OpportunityLineItem> coupons=new List<OpportunityLineItem>();
    	for (OpportunityLineItem item:Opp.OpportunityLineItems){
    		if (item.Product2.DataKubun__c==DATA_KUBUN_3){
    			coupons.add(item);
    		}        		
    	}
    	return coupons;        	
    }	         
    /*商談をクローズ*/
    public void CloseOpp(List<Opportunity> targetList){

       try {

           for(Integer i=0; i <targetList.size(); i++){
                targetList[i].StageName = '商談クローズ';
            }
            update targetList;
			System.debug(targetList);

        } catch (Exception e) {
            //Utility_Common.msgError(e);
            throw e;
        }   
    }      
    //==================================================================//
    //                  画面表示用ラッパークラス               
    //==================================================================//

    public class UriageShowWrapper {

        public opportunity Record  { get; private set; }
        public boolean IsSelected  { get; set; }

        public UriageShowWrapper ( opportunity record ){
            this.Record = record;
            this.IsSelected = false;
        }
    }        
    //==================================================================//
    //                  画面描画処理(ページング対応、チェックボックス)               
    //==================================================================//
    //「次へ」ボタンの表示可否
    public Boolean getHasNext() {
        return this.Controller.getHasNext();
    }

    //「前へ」ボタンの表示可否
    public Boolean getHasPrevious() {
        return this.Controller.getHasPrevious();
    }

    //ラッパーリストを画面に返す
    public List<UriageShowWrapper> geturiageList() {

        if (this.uriageList == null) {
          this.uriageList = new List<UriageShowWrapper>();
          List<Opportunity> rawList = (List<Opportunity>)Controller.getRecords();
          for (Opportunity o : rawList) {
            UriageShowWrapper w = new UriageShowWrapper(o);
            if (this.EntireSelectedIds.contains(o.Id)) {
              w.IsSelected = true;
            }
            this.uriageList.add(w);
          }
        }
        return this.uriageList;
    }

    //現在の画面の選択or非選択内容をEntireSelectedIdsに反映（ページング等の画面遷移時に実施）
    private void updateEntireSelectedIds() {
        if (this.uriageList != null) {
            for (UriageShowWrapper w : this.uriageList) {
                if (w.IsSelected) {
                    EntireSelectedIds.add(w.Record.Id);
                } else {
                    EntireSelectedIds.remove(w.Record.Id);
                }
            }
        }
    }

    //ページング前のリフレッシュ
    private void refreshBeforePaging() {
        updateEntireSelectedIds();
        this.uriageList = null;
    }

    //「次へ」
    public void next() {
        if (getHasNext()) {
          refreshBeforePaging();
          this.Controller.next();
        }
    }

    //「前へ」
    public void previous() {
        if (getHasPrevious()) {
          refreshBeforePaging();
          this.Controller.previous();
        }
    }       
}