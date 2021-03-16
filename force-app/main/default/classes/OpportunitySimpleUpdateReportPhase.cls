public class OpportunitySimpleUpdateReportPhase {
	
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
        if( pNewOne.RecordTypeId != Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId() ) return false;

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
    		return 'Y-99-01. 不明：‐';
    	}
    }

    private static Map<String, Map<String, String>> ReportPhaseSubPhaseMap = new Map<String, Map<String, String>>{
		'問合せ受付' => new Map<String, String>{
			'3分コール接続待'	=>	'Y-01-01. 問合せ受付：3分コール接続待' ,
			'お客様情報一時聴取/入力中'	=>	'Y-01-02. 問合せ受付：お客様情報一時聴取/入力中' ,
			'資料作成/発送待ち'	=>	'Y-01-03. 問合せ受付：資料作成/発送待ち' 
		},
		'フォロー' => new Map<String, String>{
			'資料到着確認待ち（危篤/余命宣告［急］）'	=>	'Y-02-01. フォロー：資料到着確認待ち（危篤/余命宣告［急］）' ,
			'資料到着確認待ち（健在/余命宣告［不急］）'	=>	'Y-02-02. フォロー：資料到着確認待ち（健在/余命宣告［不急］）' ,
			'フォロー（危篤/余命宣告［急］）'	=>	'Y-02-03. フォロー：フォロー（危篤/余命宣告［急］）' ,
			'フォロー（健在/余命宣告［不急］）'	=>	'Y-02-04. フォロー：フォロー（健在/余命宣告［不急］）'
		},
		'事前準備処理中' => new Map<String, String>{
			'事前割申込中/発効待ち'	=>	'Y-03-01. 事前準備処理中：事前割申込中/発効待ち' ,
			'お葬式予約お申込中'	=>	'Y-03-02. 事前準備処理中：お葬式予約お申込中' 
		},
		'事前準備完了' => new Map<String, String>{
			'無料メンバー（事前準備シート提出済）'	=>	'Y-04-01. 事前準備完了：無料メンバー（事前準備シート提出済）' ,
			'事前割メンバー'	=>	'Y-04-02. 事前準備完了：事前割メンバー' ,
			'お葬式予約メンバー'	=>	'Y-04-03. 事前準備完了：お葬式予約メンバー' 
		},
		'お亡くなり対応' => new Map<String, String>{
			'ご提案/後追い'	=>	'Y-05-01. お亡くなり対応：ご提案/後追い',
            '後追い不要'   =>  'Y-05-02. お亡くなり対応：後追い不要'
		},
		'決定' => new Map<String, String>{
			'葬儀社手配'	=>	'Y-06-01. 決定：葬儀社手配' ,
			'見積書受領待ち（お打合わせ中）'	=>	'Y-06-02. 決定：見積書受領待ち（お打合わせ中）' ,
			'カード決済/与信待ち'	=>	'Y-06-03. 決定：カード決済/与信待ち',
			'売上計上待ち'	=>	'Y-06-04. 決定：売上計上待ち'
		},
		'施行待ち' => new Map<String, String>{
			'請求書受領待ち'	=>	'Y-07-01. 施行待ち：請求書受領待ち'
		},
		'施行完了' => new Map<String, String>{
			'商談確定承認待ち'	=>	'Y-08-01. 施行完了：商談確定承認待ち'
		},
		'商談クローズ' => new Map<String, String>{
			'請求書未送付'	=>	'Y-09-01. 商談クローズ：請求書未送付'
		}
    };

    private static Map<String, String> ReportPhaseSubPhase2Map = new Map<String, String>{
    	'問合せ受付' 			=> 'Y-01-99. 問合せ受付：‐',
    	'フォロー' 				=> 'Y-02-99. フォロー：‐',
    	'事前準備処理中' 		=> 'Y-03-99. 事前準備処理中：‐',
    	'事前準備完了' 		=> 'Y-04-99. 事前準備完了：‐',
    	'お亡くなり対応' 		=> 'Y-05-99. お亡くなり対応：‐',
    	'決定' 				=> 'Y-06-99. 決定：‐',
    	'施行待ち' 			=> 'Y-07-99. 施行待ち：‐',
    	'施行完了' 			=> 'Y-08-99. 施行完了：‐',
		'失注'				=> 'Y-10-01. 失注：‐', 
		'キャンセル処理'		=> 'Y-11-01. キャンセル処理：‐', 
		'キャンセル'			=> 'Y-12-01. キャンセル：‐', 
		'除外'				=> 'Y-13-01. 除外：‐'
    };
}