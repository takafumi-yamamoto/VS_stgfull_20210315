public class Ctl_Case {

    public void CaseInitialize(List<Case> newList, Map<ID, Case> oldMap){

        for(Case c : newList){
            if(c.TaishoushaJokyo__c == 'すでにご逝去'){
                c.TaishoushaJokyo__c = '死亡';
            }
            
            if(Com_Utility.isMobile(c.TelNo__c) && (c.KeitaiDenwa__c == null || c.KeitaiDenwa__c == 'null')){
                c.KeitaiDenwa__c = c.TelNo__c;
                c.TelNo__c = '';
            }
            if(String.isBlank(String.valueOf(c.ToiawaseDate__c))){
                c.ToiawaseDate__c = datetime.now();
            }
        }
        //issues3806--Start--
        new NurturingCRMSimpleWebToCase().NurturingCRMDATAUPdate(newList);
        //issues3806--End--
    }

    public void updateOwnerByChangeStatus(List<Case> newList,Map<Id,Case> oldMap){

        //レコードタイプがメールの場合に状態が変わったら、所有者を最終更新者で更新する
        Id mailRecordId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mail').getRecordTypeId();
        //新組織のユーザーを取得する
        List<User> sinsoshikiUserList = [SELECT Id FROM User Where Username like 'system-admin@minrevi.jp%'];
        List<Case> updateOwnerMailCases = new List<Case>();
        for(Case newCase:newList){
            Case oldCase = oldMap.get(newCase.Id);
            if(mailRecordId == newcase.RecordTypeId && oldCase.Status != newCase.Status){
                newCase.OwnerId = UserInfo.getUserId();
                if('新規'.equals(newCase.Status)){
                    //新規に変わった場合は新組織を設定する
                    if(sinsoshikiUserList.size() > 0){
                        newCase.OwnerId = sinsoshikiUserList.get(0).Id;
                    }
                }
                
            }
        }
    }

    // public void MailToCase(List<Case> newList){      
    //  for (Case c:newList){
    //      if (c.Origin!='メール'){
    //          continue;
    //      }
            
    //      if (getMailTypeFromTitle(c)=='ベスト仏壇'){
    //          BestButsudanMailBodyAnalysis MailBodyAnalysis=new BestButsudanMailBodyAnalysis(c);
                
    //          c.Firstname__c=MailBodyAnalysis.torihikisakiFirstName;
    //          c.Lastname__c=MailBodyAnalysis.torihikisakiLastname;
    //          c.FirstNameKana__c=MailBodyAnalysis.torihikisakiFirstKatakana;
    //          c.LastNameKana__c=MailBodyAnalysis.torihikisakiLastKatakana;
    //          c.TelNo__c=MailBodyAnalysis.todokesakiTelNo;
    //          //c.MailAddress__c=MailBodyAnalysis.torihikisakiFirstName;メールToCaseの場合、メール設定必要がない
    //          c.recordtypeid=RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','BestButsudanOtoiawase');   
    //      }           
    //  }
        
    // }    
    // public string getMailTypeFromTitle(case c){
    //  if (c.Origin!='メール'){
    //      return null;
    //  }
    //  if (c.Subject.contains('ベスト仏壇')){
    //      return 'ベスト仏壇';
    //  }
    //  return null;        
    // }
}