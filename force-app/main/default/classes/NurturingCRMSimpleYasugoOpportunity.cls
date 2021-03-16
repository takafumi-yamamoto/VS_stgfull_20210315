public class NurturingCRMSimpleYasugoOpportunity {

	public Id SimpleYasugorecordTypeId;
	public MAP<String,SimpleYasugoJokyoStatusInfo__mdt> MAPSimpleYasugoJokyoStatusInfo;
	public List<String> lstProfileId;
	public String NurturingCRMNyuryokuCheckFlg;

	public NurturingCRMSimpleYasugoOpportunity() {

		SimpleYasugorecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

		MAPSimpleYasugoJokyoStatusInfo = new MAP<String,SimpleYasugoJokyoStatusInfo__mdt>();
		List<SimpleYasugoJokyoStatusInfo__mdt> SimpleYasugoJokyoStatusInfo = [SELECT Id, Label, SogiKPI__c, KinkyudoLV__c, SoteiLeadTime__c FROM SimpleYasugoJokyoStatusInfo__mdt];

		if(SimpleYasugoJokyoStatusInfo.size() > 0){
			for(SimpleYasugoJokyoStatusInfo__mdt s :SimpleYasugoJokyoStatusInfo){
				MAPSimpleYasugoJokyoStatusInfo.put(s.Label,s);
			}
		}

		lstProfileId = new List<String>();
		List<Profile> lstProfile = new List<Profile>();
		lstProfile = [Select Id FROM Profile Where Name in ('データ移行','SysAdmin','開発者','システム管理者','開発者(非正社員)')];
		for(Profile sProfile :lstProfile){
			lstProfileId.add(sProfile.id);
		}
		NurturingCRMNyuryokuCheckFlg = System.Label.NurturingCRMNyuryokuCheckFlg;
	}
	
	public void OnBeforeInsert(List<Opportunity> newOppList){

		for(Opportunity newOpp :newOppList){
			if(newOpp.recordTypeId == SimpleYasugorecordTypeId){
				ShokaiToGenzaiCopy(newOpp);
			}
		}

	}

	public boolean checkData(List<Opportunity> newOpptList, Map<ID, Opportunity> oldOppMap){
		Boolean errFlg = false;
		if(NurturingCRMNyuryokuCheckFlg == 'True'){
			for(Opportunity newOpp :newOpptList){
				if(newOpp.recordTypeId == SimpleYasugorecordTypeId){
					if(!lstProfileId.contains(userinfo.getProfileId())){
						if(newOpp.TaishoushaJokyo__c != oldOppMap.get(newOpp.id).TaishoushaJokyo__c ||
							newOpp.TaishoshaKyojuKeitai__c != oldOppMap.get(newOpp.id).TaishoshaKyojuKeitai__c ||
							newOpp.TaishoshaYomeiKikan__c != oldOppMap.get(newOpp.id).TaishoshaYomeiKikan__c ||
							newOpp.TaishoushaJokyoGenzai__c != oldOppMap.get(newOpp.id).TaishoushaJokyoGenzai__c ||
							newOpp.TaishoshaYomeiKikanGenzai__c != oldOppMap.get(newOpp.id).TaishoshaYomeiKikanGenzai__c ||
							newOpp.TaishoshaKyojuKeitaiGenzai__c != oldOppMap.get(newOpp.id).TaishoshaKyojuKeitaiGenzai__c ||
							newOpp.ToiawaseKiinsha__c != oldOppMap.get(newOpp.id).ToiawaseKiinsha__c ){
								if(String.isBlank(newOpp.TaishoushaJokyo__c)){
									newOpp.addError('対象者様のご状態（初回）項目が空白です。値を設定してください。');
									errFlg = true;
									break;
								}
								if(String.isBlank(newOpp.TaishoshaKyojuKeitai__c)){
									newOpp.addError('対象者居住状態（初回）項目が空白です。値を設定してください。');
									errFlg = true;
									break;
								}
								if(String.isBlank(newOpp.TaishoshaYomeiKikan__c)){
									newOpp.addError('余命期間（初回）項目が空白です。値を設定してください。');
									errFlg = true;
									break;
								}
								if(String.isBlank(newOpp.TaishoushaJokyoGenzai__c)){
									newOpp.addError('対象者様のご状態（現在）項目が空白です。値を設定してください。');
									errFlg = true;
									break;
								}
								if(String.isBlank(newOpp.TaishoshaYomeiKikanGenzai__c)){
									newOpp.addError('余命期間（現在）項目が空白です。値を設定してください。');
									errFlg = true;
									break;
								}
								if(String.isBlank(newOpp.TaishoshaKyojuKeitaiGenzai__c)){
									newOpp.addError('対象者居住形態（現在）項目が空白です。値を設定してください。');
									errFlg = true;
									break;
								}
								if(String.isBlank(newOpp.ToiawaseKiinsha__c)){
									newOpp.addError('問い合わせ起因者（初回）項目が空白です。値を設定してください。');
									errFlg = true;
									break;
								}
						}
					}
				}
			}
		}
		return errFlg;
	}

	public void OnBeforeUpdate(List<Opportunity> newOpptList, Map<ID, Opportunity> oldOppMap){

		String StrStatusInformation = '';
		
		List<Opportunity> ShokaiOpptList = new List<Opportunity>();
		
		for(Opportunity newOpp :newOpptList){

			if(newOpp.recordTypeId == SimpleYasugorecordTypeId){

				if(newOpp.TaishoushaJokyo__c != oldOppMap.get(newOpp.id).TaishoushaJokyo__c ||
					newOpp.TaishoshaKyojuKeitai__c != oldOppMap.get(newOpp.id).TaishoshaKyojuKeitai__c ||
					newOpp.TaishoshaYomeiKikan__c != oldOppMap.get(newOpp.id).TaishoshaYomeiKikan__c ){

					ShokaiOpptList.add(newOpp);
						
				}else if(newOpp.TaishoushaJokyoGenzai__c != oldOppMap.get(newOpp.id).TaishoushaJokyoGenzai__c ||
						newOpp.TaishoshaYomeiKikanGenzai__c != oldOppMap.get(newOpp.id).TaishoshaYomeiKikanGenzai__c ||
						newOpp.TaishoshaKyojuKeitaiGenzai__c != oldOppMap.get(newOpp.id).TaishoshaKyojuKeitaiGenzai__c){

					StrStatusInformation = StatusInformation(newOpp.TaishoushaJokyoGenzai__c,newOpp.TaishoshaYomeiKikanGenzai__c,newOpp.TaishoshaKyojuKeitaiGenzai__c);

					if(StrStatusInformation == 'No0'){
						//処理なし
					}else if(StrStatusInformation == 'No24'){
						newOpp.SogiKPIGenzai__c = oldOppMap.get(newOpp.id).SogiKPIGenzai__c;
						newOpp.KinkyudoLVGenzai__c = oldOppMap.get(newOpp.id).KinkyudoLVGenzai__c;
						newOpp.SoteiLeadTimeGenzai__c = oldOppMap.get(newOpp.id).SoteiLeadTimeGenzai__c;
					}else{
						if(MAPSimpleYasugoJokyoStatusInfo.containsKey(StrStatusInformation)){
							newOpp.SogiKPIGenzai__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).SogiKPI__c;
							newOpp.KinkyudoLVGenzai__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).KinkyudoLV__c;
							newOpp.SoteiLeadTimeGenzai__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).SoteiLeadTime__c;
						}
					}
					
					newOpp.SogiKPIGenzaiKoshinbi__c = Date.today();

				}else{
					//処理なし
				}

			}

		}

		if(ShokaiOpptList.size() > 0){

			for(Opportunity Opp :ShokaiOpptList){
				ShokaiToGenzaiCopy(Opp);
			}

		}

	}

	public void ShokaiToGenzaiCopy(Opportunity newOpp){

		String StrStatusInformation = '';

		newOpp.TaishoshaYomeiKikanGenzai__c = newOpp.TaishoshaYomeiKikan__c;
		newOpp.TaishoshaKyojuKeitaiGenzai__c = newOpp.TaishoshaKyojuKeitai__c;
		newOpp.TaishoushaJokyoGenzai__c = newOpp.TaishoushaJokyo__c;

		StrStatusInformation = StatusInformation(newOpp.TaishoushaJokyo__c,newOpp.TaishoshaYomeiKikan__c,newOpp.TaishoshaKyojuKeitai__c);

		if(StrStatusInformation == 'No0'){
			//処理なし
		}else if(StrStatusInformation == 'No24'){
			//処理なし
		}else{
			if(MAPSimpleYasugoJokyoStatusInfo.containsKey(StrStatusInformation)){
				newOpp.SogiKPI__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).SogiKPI__c;
				newOpp.KinkyudoLV__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).KinkyudoLV__c;
				newOpp.SoteiLeadTime__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).SoteiLeadTime__c;
				newOpp.SogiKPIGenzai__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).SogiKPI__c;
				newOpp.KinkyudoLVGenzai__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).KinkyudoLV__c;
				newOpp.SoteiLeadTimeGenzai__c = MAPSimpleYasugoJokyoStatusInfo.get(StrStatusInformation).SoteiLeadTime__c;
			}
		}

		newOpp.SogiKPIGenzaiKoshinbi__c = Date.today();
	}

	public String StatusInformation(String Jokyo,String YomeiKikan,String KyojuKeitai){

		String Strreturn = 'No0';

		switch on Jokyo {
			when '死亡'{
				Strreturn = 'No01';
			}
			when '危篤'{
				Strreturn = 'No02';
			}
			when '余命宣告'{
				switch on YomeiKikan{
					when '2週間以内'{
						Strreturn = 'No03';
					}
					when '1か月以内'{
						Strreturn = 'No04';
					}
					when '未聴取により不明'{
						Strreturn = 'No05';
					}
					when '3か月以内'{
						Strreturn = 'No06';
					}
					when '6か月以内'{
						Strreturn = 'No07';
					}
					when '1年以内'{
						Strreturn = 'No08';
					}
					when '2年以内'{
						Strreturn = 'No09';
					}
					when '3年以内'{
						Strreturn = 'No10';
					}
					when '4年以内'{
						Strreturn = 'No11';
					}
					when '5年以内'{
						Strreturn = 'No12';
					}
					when '10年以内'{
						Strreturn = 'No13';
					}
					when else{
						Strreturn = 'No0';
					}
				}
			}
			when '高齢終末期'{
				Strreturn = 'No14';
			}
			when '闘病中（重度）'{
				Strreturn = 'No15';
			}
			when '闘病中（軽度）'{
				if(KyojuKeitai == '病院（入院中）'){
					Strreturn = 'No16';
				}else{
					Strreturn = 'No17';
				}
			}
			when '闘病中（度合不明）'{
				if(KyojuKeitai == '病院（入院中）'){
					Strreturn = 'No18';
				}else{
					Strreturn = 'No19';
				}
			}
			when '健在'{
				Strreturn = 'No20';
			}
			when '未聴取により不明'{
				if(KyojuKeitai == '老人ホーム'){
					Strreturn = 'No21';
				}else{
					Strreturn = 'No22';
				}
			}
			when 'お骨'{
				Strreturn = 'No23';
			}
			when '病状回復'{
				Strreturn = 'No24';
			}
			when else{
				if(String.isBlank(Jokyo)){
					if(KyojuKeitai == '老人ホーム'){
						Strreturn = 'No21';
					}else{
						Strreturn = 'No22';
					}
				}else{
					Strreturn = 'No0';
				}
			}
		}
		return Strreturn;
	}

}