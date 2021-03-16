public class Ctl_TesuryoTekiyo{

	public void initTesuryoTekiyo(list<TesuryoTekiyo__c> newList){
		map<id,string> recordtypeAndIDMap=new map<id,string>();
		recordtypeAndIDMap.put(RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','Obosanbin'),'3');
		recordtypeAndIDMap.put(RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','SimpleYasugo'),'1');
		recordtypeAndIDMap.put(RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Keiyaku__c','TokuyakuTen'),'20');
 
		map<string,id> ServiceMap=new map<string,id>();
		for (k_Service__c k_Service: Dao_k_Service.getAllRecords()){
			ServiceMap.put(k_Service.ID__c,k_Service.id);
		}

        set<id> keiyakuIds=new set<id>();
		for (TesuryoTekiyo__c TesuryoTekiyo:newList){
			keiyakuIds.add(TesuryoTekiyo.KeiyakuRef__c);
		}
		map<id,Keiyaku__c>  KeiyakuMap=new map<id,Keiyaku__c>(Dao_Keiyaku.getListByIds(new list<id>(keiyakuIds)));
		for (TesuryoTekiyo__c TesuryoTekiyo:newList){
			id keiyakuRecordTypeId=KeiyakuMap.get(TesuryoTekiyo.KeiyakuRef__c).recordtypeID;
			if (keiyakuRecordTypeId==null){
				continue;
			}
			string IDc=recordtypeAndIDMap.get(keiyakuRecordTypeId);
			if (IDc==null){
				continue;
			}
			id servicId=ServiceMap.get(IDc);
			TesuryoTekiyo.ServiceRef__c=servicId;
		}
	}

	public void checkTekiyoKaishiBi(list<TesuryoTekiyo__c> newList,map<id,TesuryoTekiyo__c> OldMap){
        set<Id> KeiyakuIds =new set<Id>();
		for (TesuryoTekiyo__c TesuryoTekiyo: newList){
			KeiyakuIds.add(TesuryoTekiyo.KeiyakuRef__c);
		}
		map<id,list<TesuryoTekiyo__c>> TesuryoTekiyoMap=new map<id,list<TesuryoTekiyo__c>>();
		
		for (TesuryoTekiyo__c TesuryoTekiyo:Dao_TesuryoTekiyo.getListByKeiyakuIds(new List<id>(KeiyakuIds))){
			list<TesuryoTekiyo__c> tempTesuryoTekiyoLst=TesuryoTekiyoMap.get(TesuryoTekiyo.KeiyakuRef__c);
			if (tempTesuryoTekiyoLst==null){
				tempTesuryoTekiyoLst=new list<TesuryoTekiyo__c>();
				TesuryoTekiyoMap.put(TesuryoTekiyo.KeiyakuRef__c,tempTesuryoTekiyoLst);
			}
			tempTesuryoTekiyoLst.add(TesuryoTekiyo);
		}
		for (TesuryoTekiyo__c newTesuryoTekiyo:newList){
			list<TesuryoTekiyo__c> TesuryoTekiyoLst=TesuryoTekiyoMap.get(newTesuryoTekiyo.KeiyakuRef__c);
			if (TesuryoTekiyoLst==null) continue;
			for (TesuryoTekiyo__c TesuryoTekiyo:TesuryoTekiyoLst){
				if (newTesuryoTekiyo.id!=TesuryoTekiyo.id && newTesuryoTekiyo.TekiyoKaishiBi__c==TesuryoTekiyo.TekiyoKaishiBi__c){
					newTesuryoTekiyo.addError('同じパートナー契約では適用開始日は重複してはいけないです。');
				}
			}
		}
	}
	public void checkValidation(list<TesuryoTekiyo__c> newList,map<id,TesuryoTekiyo__c> OldMap){
		for (TesuryoTekiyo__c TesuryoTekiyo: newList){
			if (TesuryoTekiyo.ShoninStatus__c=='承認済'){
				if (TesuryoTekiyo.KeiyakuRef__c==null){
					TesuryoTekiyo.addError('パートナー契約を入力してください。');
				}
				if (TesuryoTekiyo.TekiyoKaishiBi__c==null){
					TesuryoTekiyo.addError('適用開始日を入力してください。');
				}
				if (TesuryoTekiyo.TekiyoSyuryoBi__c==null){
					TesuryoTekiyo.addError('適用終了日を入力してください。');
				}				
				if (TesuryoTekiyo.ServiceRef__c==null){
					TesuryoTekiyo.addError('サービスを入力してください。');
				}
				if (TesuryoTekiyo.TesuryoPlanRef__c==null){
					TesuryoTekiyo.addError('手数料プランを入力してください。');
				}
			}
		}

	}

	public void checkIsEditableTesuryoTekiyo(list<TesuryoTekiyo__c> newList,map<id,TesuryoTekiyo__c> OldMap){
		for (TesuryoTekiyo__c newTesuryoTekiyo:newList){
			TesuryoTekiyo__c oldTesuryoTekiyo=OldMap.get(newTesuryoTekiyo.id);
			if (oldTesuryoTekiyo.ShoninStatus__c=='承認済'){
				if (oldTesuryoTekiyo.KeiyakuRef__c!=newTesuryoTekiyo.KeiyakuRef__c||
				    oldTesuryoTekiyo.TesuryoPlanRef__c!=newTesuryoTekiyo.TesuryoPlanRef__c||
					oldTesuryoTekiyo.TekiyoKaishiBi__c!=newTesuryoTekiyo.TekiyoKaishiBi__c||
					oldTesuryoTekiyo.TekiyoSyuryoBi__c!=newTesuryoTekiyo.TekiyoSyuryoBi__c||
					oldTesuryoTekiyo.OptionTesuryoAri__c!=newTesuryoTekiyo.OptionTesuryoAri__c||
					oldTesuryoTekiyo.CardLoanTesuryoAri__c!=newTesuryoTekiyo.CardLoanTesuryoAri__c||
					oldTesuryoTekiyo.AtobaraiTesuryoAri__c!=newTesuryoTekiyo.AtobaraiTesuryoAri__c||
					oldTesuryoTekiyo.RyoriTesuryoAri__c!=newTesuryoTekiyo.RyoriTesuryoAri__c||
					oldTesuryoTekiyo.HenreihinTesuryoAri__c!=newTesuryoTekiyo.HenreihinTesuryoAri__c){
						newTesuryoTekiyo.addError('承認済の手数料適用は変更できません。');
				}
			}
		}

	}
	
}