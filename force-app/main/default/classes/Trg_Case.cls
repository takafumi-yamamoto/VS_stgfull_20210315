/**
 * ケーストリガーハンドラー
 * ・WebToケース時、対応するサービスのオブジェクトを作成
 * ・WebToケース時、対応するサービスのTodoを作成
 *
 * @Auther Mizuno
 */

public class Trg_Case 
{	
    public static Boolean isActive = True;

	public Trg_Case(){
	}

	public void OnBeforeDelete(List<Case> oldList){
		
	}

	public void OnBeforeInsert(List<Case> newList){
        System.debug('----OnBeforeInsert----' + newList);
        new Ctl_Case().CaseInitialize(newList, null);
        // new Ctl_Case().MailToCase(newList);
        new Ctl_Account().searchForExistenceOfAccount(newList);
        new Ctl_Account().searchForExistenceTaishoshaOfAccount(newList);
	}
    
    public void OnBeforeUpdate(List<Case> oldList, List<Case> newList, Map<Id,Case> oldMap){
        new Ctl_Case().updateOwnerByChangeStatus(newList,oldMap);
    }

	public void OnAfterInsert(List<Case> newList){

        // ケースに対応するサービスを作成
		caseToServiceOpportunitySave(reload(newList));

        // issues-4195 --Start--
        new Ctl_Achievement_Campaign().onCaseAfterInsert(newList);
        new JizenSurvey().JizenSurveyUpdate(newList);
        // issues-4195 --End--

        // 2018.01.24 exia.huang
        // case to 会員登録
        new Ctl_Account.MemberTouroku().onCaseAfterInsert(newList);
        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterInsert(newList);
        // case to アチーブメント
        // issues-4195 --Start--
        // Ctl_Achievement_JizenJunbiWeb.getInstance().onCaseAfterInsert(newList);
        new Ctl_Achievement_JizenJunbiWeb().onCaseAfterInsert(newList);
        // issues-4195 --End--

        //new Ctl_Affiliate().onCaseAfterInsert(newList);
        AffiCaseCre.subscriveOnCaseAfterInserted(newList);
	}

	public void OnAfterUpdate(List<Case> newList, Map<ID, Case> oldMap){
        new Ctl_Account.MemberTouroku().onCaseAfterUpdate(newList, oldMap);
        new Ctl_WebAccountTourokuIrai.CaseToWebAccountTorokuIrai().onCaseAfterUpdate(newList, oldMap);
        // case to アチーブメント
        // issues-4195 --Start--
        // Ctl_Achievement_JizenJunbiWeb.getInstance().onCaseAfterUpdate(newList,oldMap);
        new Ctl_Achievement_JizenJunbiWeb().onCaseAfterUpdate(newList,oldMap);
        // issues-4195 --End--

	}

    /**
     * ケースに対応するサービス商談を作成する。
     * @param  newList 対象ケース(Update処理が入るため、再取得済)
     */ 
    private void caseToServiceOpportunitySave(List<Case> newList) {
    	system.debug('====================caseToServiceOpportunitySave.begin===================');
        
    	Ctl_Opportunity Ctl_Opp=new Ctl_Opportunity();
    	Ctl_Opp.CreateServiceOpportunityFromCases(newList);
    	system.debug('====================caseToServiceOpportunitySave.end===================');
    }

    // AfterInsert / Update向けに、レコード再取得
    private List<Case> reload(List<Case> newList) {
        List<Case> newList2 = new List<Case>();
        for(Case aCase : newList){
            if(isObousanbinNetYoyaku(aCase)){
                continue;
            }
            newList2.add(aCase);
        }
        if(newList2.size() == 0) return newList2;

        // レコードID配列取得
        List<Id> newIds = new List<Id>(new Map<Id,Case>(newList2).keySet());
        List<Case> reloadedList = Dao_Case.SearchByIds(newIds);
        return reloadedList;
    } 

    private Boolean isObousanbinNetYoyaku(Case aCase){
        return aCase.RecordTypeId == RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Case','ObousanbinNetYoyaku');
    }

}