public class OpportunityOboUpdateReportPhase {
    public void onOppBeforeUpdate(List<Opportunity> newOnes, Map<ID, Opportunity> oldOnes){
        for(Opportunity opp : this.getEntriesToProcess(newOnes, oldOnes)){
        	opp.ReportPhaseSubPhase__c = getReportPhaseSubPhase(opp.StageName , opp.SubPhase__c);
        }
    }

    private List<Opportunity> getEntriesToProcess(List<Opportunity> newOnes, Map<ID, Opportunity> oldOnes){
        List<Opportunity> theEntriesToProcess = new List<Opportunity>();
        for(Opportunity aNewOne : newOnes){
            Opportunity aOldOne = oldOnes.get(aNewOne.Id);
            if( this.isToProcess(aNewOne, aOldOne) ) theEntriesToProcess.add(aNewOne);
        }
        return theEntriesToProcess;
    }

    private Boolean isToProcess(Opportunity pNewOne, Opportunity pOldOne){
        String theRecTypeName = RecordTypeCachedDaos.getInstance().SelectDeveloperNameById(pNewOne.RecordTypeId);
        List<String> theRecTypeNames = 
            new List<String>{ 'Obosanbin' };
        if( !theRecTypeNames.contains(theRecTypeName) ) return false;

        if(pNewOne.StageName != pOldOne.StageName) return true;
        if(pNewOne.SubPhase__c != pOldOne.SubPhase__c) return true;
        return false;
    }

    private static String getReportPhaseSubPhase(String stageName, String subPhase){
    	if(ReportPhaseSubPhaseMap.containskey(stageName) && ReportPhaseSubPhaseMap.get(stageName).containskey(subPhase)){
    		return ReportPhaseSubPhaseMap.get(stageName).get(subPhase);
    	} else if(ReportPhaseSubPhase2Map.containskey(stageName)){
    		return ReportPhaseSubPhase2Map.get(stageName);
    	} else {
    		return 'Y-99-01. 不明：‐' ;
    	}
    }

    private static Map<String, Map<String, String>> ReportPhaseSubPhaseMap = new Map<String, Map<String, String>>{
		'問合せ受付' => new Map<String, String>{
			'問合せ受付'	=> 'O-01-01. 問合せ受付：問合せ受付' ,
			'状況伺い'	=> 'O-01-02. 問合せ受付：状況伺い'
		},
		'フォロー' => new Map<String, String>{
			'資料送付'	=> 'O-02-01. フォロー：資料送付' ,
			'フォロー'	=> 'O-02-02. フォロー：フォロー' 
		},
		'予約' => new Map<String, String>{
			'仮受注'	=> 'O-03-01. 予約：仮受注' ,
			'予約確認'	=> 'O-03-02. 予約：予約確認' 
		},
		'決定' => new Map<String, String>{
			'僧侶手配'	=> 'O-06-01. 決定：僧侶手配' ,
			'スケジュール確認中'	=> 'O-06-02. 決定：スケジュール確認中' ,
			'依頼書・手配報告書作成'	=> 'O-06-03. 決定：依頼書・手配報告書作成' ,
			'依頼書・手配報告書送付'	=> 'O-06-04. 決定：依頼書・手配報告書送付'
		},
		'施行待ち' => new Map<String, String>{
			'請求書受領待ち'	=> 'O-07-01. 施行待ち：請求書受領待ち' ,
			'事前確認連絡7日前（SMS）'	=> 'O-07-02. 施行待ち：事前確認連絡7日前（SMS）' ,
			'事前確認連絡1日前（SMS）'	=> 'O-07-03. 施行待ち：事前確認連絡1日前（SMS）' ,
			'事前確認連絡（電話）'	=> 'O-07-04. 施行待ち：事前確認連絡（電話）' ,
			'現地到着確認'	=> 'O-07-05. 施行待ち：現地到着確認' ,
			'施行完了確認'	=> 'O-07-06. 施行待ち：施行完了確認'
		},
		'施行完了' => new Map<String, String>{
			'Yahooステータス変更'	=> 'O-08-01. 施行完了：Yahooステータス変更' ,
			'商談確定承認待ち'	=> 'O-08-02. 施行完了：商談確定承認待ち' 
		}
    };

    private static Map<String, String> ReportPhaseSubPhase2Map = new Map<String, String>{
		'問合せ受付' => 'O-01-03. 問合せ受付：‐' ,
		'フォロー' => 'O-02-03. フォロー：‐' ,
		'予約'	=> 'O-03-03. 予約：‐' ,
		'決定'	=> 'O-06-05. 決定：‐' ,
		'施行待ち'	=> 'O-07-07. 施行待ち：‐' ,
		'施行完了' =>  'O-08-03. 施行完了：‐' ,
		'生前契約商談'	=> 'O-04-01. 生前契約商談：‐',
		'生前契約成立'	=> 'O-05-01. 生前契約成立：‐',
		'商談クローズ'	=> 'O-09-01. 商談クローズ：‐',
		'失注'	=> 'O-10-01. 失注：‐',
		'キャンセル処理'	=> 'O-11-01. キャンセル処理：‐',
		'キャンセル'	=> 'O-12-01. キャンセル：‐',
		'除外'	=> 'O-13-01. 除外：‐'
    };
}