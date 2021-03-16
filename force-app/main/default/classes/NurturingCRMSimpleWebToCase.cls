public class NurturingCRMSimpleWebToCase {

	public List<Id> SimplerecordTypeId;
	
	public NurturingCRMSimpleWebToCase() {
		SimplerecordTypeId = new List<Id>();
		SimplerecordTypeId.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId());
		SimplerecordTypeId.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('OsoshikiYoyaku_SiryoSeikyu_Web').getRecordTypeId());
		SimplerecordTypeId.add(Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoJizenJunbiWebForm').getRecordTypeId());
	}

	public void NurturingCRMDATAUPdate(List<Case> newCase){
		for(Case aCase :newCase){
			if(SimplerecordTypeId.contains(aCase.recordTypeId)){
				if(String.isBlank(aCase.TaishoshaKyojuKeitai__c) && String.isBlank(aCase.TaishoshaYomeiKikan__c) && String.isBlank(aCase.ToiawaseKiinsha__c)){
					switch on aCase.TaishoushaJokyo__c {
						when '死亡'{
							aCase.WebShiryoSeikyuTaishoushaJokyo__c = 'すでにご逝去';
							aCase.TaishoshaKyojuKeitai__c = '未聴取により不明';
							aCase.TaishoshaYomeiKikan__c = '未聴取により不明';
							aCase.ToiawaseKiinsha__c = '未聴取により不明';
						}
						when '危篤'{
							aCase.WebShiryoSeikyuTaishoushaJokyo__c = '危篤';
							aCase.TaishoshaKyojuKeitai__c = '未聴取により不明';
							aCase.TaishoshaYomeiKikan__c = '未聴取により不明';
							aCase.ToiawaseKiinsha__c = '未聴取により不明';
						}
						when '余命宣告'{
							aCase.WebShiryoSeikyuTaishoushaJokyo__c = '余命宣告';
							aCase.TaishoshaKyojuKeitai__c = '未聴取により不明';
							aCase.TaishoshaYomeiKikan__c = '未聴取により不明';
							aCase.ToiawaseKiinsha__c = '未聴取により不明';
						}
						when '入院中'{
							aCase.WebShiryoSeikyuTaishoushaJokyo__c = '入院中';
							aCase.TaishoushaJokyo__c = '闘病中（度合不明）';
							aCase.TaishoshaKyojuKeitai__c = '病院（入院中）';
							aCase.TaishoshaYomeiKikan__c = '未聴取により不明';
							aCase.ToiawaseKiinsha__c = '未聴取により不明';
						}
						when '通院中'{
							aCase.WebShiryoSeikyuTaishoushaJokyo__c = '通院中';
							aCase.TaishoushaJokyo__c = '闘病中（軽度）';
							aCase.TaishoshaKyojuKeitai__c = '自宅';
							aCase.TaishoshaYomeiKikan__c = '未聴取により不明';
							aCase.ToiawaseKiinsha__c = '未聴取により不明';
						}
						when '健在'{
							aCase.WebShiryoSeikyuTaishoushaJokyo__c = '健在';
							aCase.TaishoshaKyojuKeitai__c = '未聴取により不明';
							aCase.TaishoshaYomeiKikan__c = '未聴取により不明';
							aCase.ToiawaseKiinsha__c = '未聴取により不明';
						}
						when else{
							aCase.WebShiryoSeikyuTaishoushaJokyo__c = 'なし';
							aCase.TaishoshaKyojuKeitai__c = '未聴取により不明';
							aCase.TaishoshaYomeiKikan__c = '未聴取により不明';
							aCase.ToiawaseKiinsha__c = '未聴取により不明';
						}
					}
				}
			}
		}
	}

}