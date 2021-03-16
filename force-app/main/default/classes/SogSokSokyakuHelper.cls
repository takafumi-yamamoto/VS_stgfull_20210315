public class SogSokSokyakuHelper {

    public class SogSokSokyakuDao {
        public SogSok_Sokyaku__c get_SogSok_Sokyaku(String id){
            List<SogSok_Sokyaku__c> sokyakuList = [
                      select 
                          Id,       //カスタムオブジェクト ID
                          Name,       //SogSok_Sokyaku名
                          OpportunityRef__c,        //OpportunityRef
                          SokyakuShoRef__c,       //SokyakuShoRef
                          SokyakuShoRef__r.Id,        // カスタムオブジェクト ID
                          SokyakuShoRef__r.Name,        // SogSok_SokyakuSho名
                          SokyakuShoRef__r.SokyakuBango__c,       // SokyakuBango
                          SokyakuShoRef__r.ShodanBango__c,        // ShodanBango
                          SokyakuShoRef__r.SoukyakuSaki_KeiyakuBango__c,        // SoukyakuSaki_KeiyakuBango
                          SokyakuShoRef__r.Soukyakusaki_TorihikisakiBango__c,       // Soukyakusaki_TorihikisakiBango
                          SokyakuShoRef__r.SoukyakuSaki_TorihikiSakiName__c,        // SoukyakuSaki_TorihikiSakiName
                          SokyakuShoRef__r.SodanSha_TorihikiSakiBango__c,       // SodanSha_TorihikiSakiBango
                          SokyakuShoRef__r.SodanSha_Sei__c,       // SodanSha_Sei
                          SokyakuShoRef__r.SodanSha_Mei__c,       // SodanSha_Mei
                          SokyakuShoRef__r.SodanSha_SeiKana__c,       // SodanSha_SeiKana
                          SokyakuShoRef__r.SodanSha_MeiKana__c,       // SodanSha_MeiKana
                          SokyakuShoRef__r.SodanSha_Phone__c,       // SodanSha_Phone
                          SokyakuShoRef__r.SodanSha_Mobile__c,        // SodanSha_Mobile
                          SokyakuShoRef__r.SodanSha_Addr_State__c,        // SodanSha_Addr_State
                          SokyakuShoRef__r.SodanSha_Addr_City__c,       // SodanSha_Addr_City
                          SokyakuShoRef__r.SodanSha_Addr_Street__c,       // SodanSha_Addr_Street
                          SokyakuShoRef__r.SoukyakuDate__c,       // SoukyakuDate
                          SokyakuShoRef__r.TaishoSha_TorihikiSakiBango__c,        // TaishoSha_TorihikiSakiBango
                          SokyakuShoRef__r.TaishoSha_Sei__c,        // TaishoSha_Sei
                          SokyakuShoRef__r.TaishoSha_Mei__c,        // TaishoSha_Mei
                          SokyakuShoRef__r.TaishoSha_SeiKana__c,        // TaishoSha_SeiKana
                          SokyakuShoRef__r.TaishoSha_MeiKana__c,        // TaishoSha_MeiKana
                          SokyakuShoRef__r.TaishoSha_BirthDate__c,        // TaishoSha_BirthDate
                          SokyakuShoRef__r.TaishoSha_DeathDate__c,        // TaishoSha_DeathDate
                          SokyakuShoRef__r.TaishoSha_Age__c,        // TaishoSha_Age
                          SokyakuShoRef__r.TaishoSha_Gender__c,       // TaishoSha_Gender
                          SokyakuShoRef__r.TaishoSha_Addr_State__c,       // TaishoSha_Addr_State
                          SokyakuShoRef__r.TaishoSha_Addr_City__c,        // TaishoSha_Addr_City
                          SokyakuShoRef__r.TaishoSha_Addr_Street__c,        // TaishoSha_Addr_Street
                          SokyakuShoRef__r.TaishoSha_Shuha__c,        // TaishoSha_Shuha
                          SokyakuShoRef__r.TaishoSha_ZokugaraFromSoudanSha__c,        // TaishoSha_ZokugaraFromSoudanSha
                          SokyakuShoRef__r.Moshu_TorihikiSakiBango__c,        // Moshu_TorihikiSakiBango
                          SokyakuShoRef__r.Moshu_Sei__c,        // Moshu_Sei
                          SokyakuShoRef__r.Moshu_Mei__c,        // Moshu_Mei
                          SokyakuShoRef__r.Moshu_SeiKana__c,        // Moshu_SeiKana
                          SokyakuShoRef__r.Moshu_MeiKana__c,        // Moshu_MeiKana
                          SokyakuShoRef__r.Moshu_Addr_State__c,       // Moshu_Addr_State
                          SokyakuShoRef__r.Moshu_Addr_City__c,        // Moshu_Addr_City
                          SokyakuShoRef__r.Moshu_Addr_Street__c,        // Moshu_Addr_Street
                          SokyakuShoRef__r.OmukaeSaki_Addr_City__c,       // OmukaeSaki_Addr_City
                          SokyakuShoRef__r.OmukaeSaki_Addr_State__c,        // OmukaeSaki_Addr_State
                          SokyakuShoRef__r.OmukaeSaki_Addr_Street__c,       // OmukaeSaki_Addr_Street
                          SokyakuShoRef__r.OmukaeSaki_Name__c,        // OmukaeSaki_Name
                          SokyakuShoRef__r.AnchiSaki__c,        // AnchiSaki
                          SokyakuShoRef__r.SogiPlan_KiboArea__c,        // SogiPlan_KiboArea
                          SokyakuShoRef__r.SogiPlan_ShohinBango__c,       // SogiPlan_ShohinBango
                          SokyakuShoRef__r.SogiPlan_PlanName__c,        // SogiPlan_PlanName
                          SokyakuShoRef__r.SogiPlan_Amount__c,        // SogiPlan_Amount
                          SokyakuShoRef__r.Shiharai_MaeukeKingaku__c,       // Shiharai_MaeukeKingaku
                          SokyakuShoRef__r.Shiharai_KiboShiharaiHoho__c,        // Shiharai_KiboShiharaiHoho
                          SokyakuShoRef__r.SoryoTehai_KiboUmu__c,       // SoryoTehai_KiboUmu
                          SokyakuShoRef__r.TaishoSha_BodaijiUmu__c,       // TaishoSha_BodaijiUmu
                          SokyakuShoRef__r.RenrakuJiko__c,        // RenrakuJiko
                          SokyakuShoRef__r.SodanSha_Addr_PostalCode__c,       // SodanSha_Addr_PostalCode
                          SokyakuShoRef__r.TaishoSha_Addr_PostalCode__c,        // TaishoSha_Addr_PostalCode
                          SokyakuShoRef__r.Moshu_Addr_PostalCode__c,        // Moshu_Addr_PostalCode
                          DocStatus__c,       //DocStatus
                          SoukyakuDateTime__c       //SoukyakuDateTime
                    from SogSok_Sokyaku__c
                    where id = :id
            ];

            if(sokyakuList.size() > 0){
              return sokyakuList[0];
            }else{
              return null;
            }
        }


        public List<SogSok_SokyakuSho_WaribikiLine__c> get_SogSok_SokyakuSho_WaribikiLines(String sokyakuShoRef){
            return  [select 
                        Id,       //カスタムオブジェクト ID
                        Name,       //SogSok_SokyakuSho_WaribikiLine名
                        ShohinBango__c,       //ShohinBango
                        Hinmei__c,        //Hinmei
                        UnitPrice__c,       //UnitPrice
                        Quantity__c,        //Quantity
                        SokyakuShoRef__c,       //SokyakuShoRef
                        Amount__c       //Amount
                    from SogSok_SokyakuSho_WaribikiLine__c
                    where SokyakuShoRef__c = :SokyakuShoRef
                  ];
        }

    }

  	public class SokyakushoSakuseiParamsBuilder {
	  }



    //コアと連携
    public class SokyakushoSakuseiRequest {

    	public Boolean isSuccess;
    	public Map<String, Object> responseData;

        //ユーザ発行依頼
    	public string createSokyakusho(){
    		String url = PtWebApi_Configs.getConfig().BaseEndPoint__c + '/api/sf/account/issue';
    		String requestParams = '';
    		System.debug(url);
    		PtWebApi_Client client = new PtWebApi_Client(url, requestParams);
    		HttpResponse res = PtWebApi_Util.doPost(client);
    		return 'TODO';

      //       Loggings.Level level = client.getIsSuccess() ? Loggings.Level.Info : Loggings.Level.Error;
      //       Loggings.writeLog(
      //          Loggings.createLogEntry(level, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'CoreKessai.PaymentHelper.CoreSeikyusRequest', '決済請求書作成コア連携')
      //              .putAttr('params', builder.getKessaiInfoJsonStr())
      //              .putAttr('ResponseCode', client.code + '')
      //              .putAttr('ResponseMsg', client.result)
      //              .putAttr('IsSuccess', client.getIsSuccess() + '')
      //              .putAttr('Description', '決済請求書作成コア連携-決済情報受付（FromSF）createSeikyu')
      //       );

    		// this.isSuccess = client.getIsSuccess();

    		// if(client.getIsSuccess()){
    		// 	SeikyusyoSakuseiDao dao = new SeikyusyoSakuseiDao();
    		// 	dao.saveSeikyusyo(bean, builder.items);
    		// }

      //       // set response
      //       responseData = new Map<String, Object>();
      //       responseData.put('ResponseCode' , client.code);
      //       responseData.put('ResponseMsg' , client.result);
      //       responseData.put('isSuccess' , client.getIsSuccess());
      //       if(!client.getIsSuccess()){
      //           responseData.put('ResponseMsg' , client.getCoreErrorMsg());
      //       }

      //       return JSON.serialize(responseData);

    	}

    	//ユーザ停止依頼
    	public String userStopIrai(){
    		String url = PtWebApi_Configs.getConfig().BaseEndPoint__c + '/api/sf/account/invalidate';
    		String requestParams = '';
    		System.debug(url);
    		PtWebApi_Client client = new PtWebApi_Client(url, requestParams);
    		HttpResponse res = PtWebApi_Util.doPost(client);

    		return '';
    	}

    }
	

}