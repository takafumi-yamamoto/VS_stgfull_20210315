public class Ctl_OkyakusamaSeikyuMeisai {

	// 請求方法 「混合 (要確認)」の値（※チェック用の特殊な請求方法をここで定義）
    private static final String SEIKYUHOUHOU_KONGO = '混合 (要確認)';

    private static final Decimal ATOBARAI_TESURYO_GMO = 12800; //支払通知書　出力用

	public static final Map<String, String> seikyuHohoCodeMap = new Map<String, String>{
																	'' => ''
																	,'Partner' => '1'
																	,'sousai' => '2'
																	,'furikomi' => '3'
																	,'orico_loan' => '4'
																	,'orico_credit' => '5'
																	,'sosaifujo' => '6'
																	,'sagawa_cvs' => '7'
																	,'paydesign_credit' => '8'
																	,'paydesign_cvs_den' => '9'
																	,'paydesign_cvs_tan' => '10'
																	,'paydesign_cvs_den_cancel' => '11'
																	,'paydesign_cvs_tan_cancel' => '12'
																	,'Amazon' => '13'
																	,'Yahoo' => '14'
																	,'remise_credit' => '15'
                                                                    ,'gmo_credit' => '16'
                                                                    , 'NpAtoNegime' => '17'
                                                                    , 'gmo_atobarai' => '20'
																	};

	public void initialProcessing(List<OkyakusamaSeikyuMeisai__c> newList, Map<ID, OkyakusamaSeikyuMeisai__c> oldMap) {

		for(OkyakusamaSeikyuMeisai__c okyakusamaSeikyuMeisai : newList){
			if(oldMap == null || oldMap.get(okyakusamaSeikyuMeisai.Id).SeikyuHouhou__c != okyakusamaSeikyuMeisai.SeikyuHouhou__c){
				okyakusamaSeikyuMeisai.SeikyuHohoCode__c = seikyuHohoCodeMap.get(okyakusamaSeikyuMeisai.SeikyuHouhou__c);
			}
            if(oldMap == null && okyakusamaSeikyuMeisai.SeikyuHouhou__c == 'NpAtoNegime' && okyakusamaSeikyuMeisai.Kessaibi__c == null){
                okyakusamaSeikyuMeisai.Kessaibi__c = Date.today();
            }
		}
	}

    /**
     * コンビニ伝票の場合、請求番号を設定する
     **/
    public void putSeikyuBango(List<OkyakusamaSeikyuMeisai__c> targetList){

        List<OkyakusamaSeikyuMeisai__c> targetSeikyuMeisais = [SELECT
                                                                Id, SeikyuMeisaiNo__c
                                                                FROM OkyakusamaSeikyuMeisai__c
                                                                WHERE Id IN :targetList AND SeikyuHouhou__c = 'paydesign_cvs_den'];
        if(!targetSeikyuMeisais.isEmpty()){
            for(OkyakusamaSeikyuMeisai__c target : targetSeikyuMeisais){
                target.SeikyuBango__c = target.SeikyuMeisaiNo__c;
            }
            update targetSeikyuMeisais;
        }
    }

    /**
     * 支払通知書出力用に以下の項目に値を設定する
     * ・【レポート】支払方法（ReportShiharaihoho__c）
     * ・【レポート】入金額（ReportNyukingaku__c）
     * ・【レポート】入金日（ReportNyukinbi__c）
	 * ・【レポート】前受金（ReportMaeukekin__c）
     **/
    public void setShiharaiKanrenJoho(List<OkyakusamaSeikyuMeisai__c> targetList){

        Set<Id> opportunityIdList = new Set<Id>();
        for(OkyakusamaSeikyuMeisai__c seikyuMeisai : targetList){
            opportunityIdList.add(seikyuMeisai.OpportunityRef__c);
        }

        // トリガーから渡ってきたお客様請求明細から抽出した商談のレコードIDからシンプル安豪のデータを取得
        List<SimpleYasugo__c> upSimpleYasugoList = new List<SimpleYasugo__c>();
		for(Opportunity sltOpportunity : [SELECT
                                            Id,
                                            SimpleYasugoRef__c,
                                            SimpleYasugoRef__r.ReportShiharaihoho__c,
                                            SimpleYasugoRef__r.ReportNyukingaku__c,
                                            SimpleYasugoRef__r.ReportNyukinbi__c,
                                            SimpleYasugoRef__r.ReportMaeukekin__c,
                                            (
                                                SELECT
                                                    Id,
                                                    Kessaibi__c,
                                                    OpportunityRef__c,
                                                    SeikyuKingaku__c,
                                                    SeikyuHohoCode__c,
                                                    tolabel(SeikyuHouhou__c)
                                                FROM KaisyuYoteisOpportunity__r
                                                WHERE OpportunityRef__c in :opportunityIdList
                                                    AND (SeikyuHouhou__c = 'orico_loan'
                                                        OR SeikyuHouhou__c = 'orico_credit'
                                                        OR SeikyuHouhou__c = 'sagawa_cvs'
                                                        OR SeikyuHouhou__c = 'sousai'
                                                        OR SeikyuHouhou__c = 'gmo_credit'
                                                        OR SeikyuHouhou__c = 'gmo_atobarai')
                                                    AND (RecordType.DeveloperName = 'KobetsuSeikyu'
                                                        OR RecordType.DeveloperName = 'Sosai')
                                            )
                                          FROM Opportunity
                                          WHERE Id IN :opportunityIdList
                                            AND RecordType.DeveloperName = 'SimpleYasugo']){

            SimpleYasugo__c simpleYasugo = new SimpleYasugo__c();
            simpleYasugo.Id = sltOpportunity.SimpleYasugoRef__c;
            // 以下、一旦初期化
            simpleYasugo.ReportShiharaihoho__c = '';
            simpleYasugo.ReportNyukingaku__c = 0;
            simpleYasugo.ReportNyukinbi__c = null;
            simpleYasugo.ReportMaeukekin__c = 0;
            simpleYasugo.AtobaraiTesuryoTotal__c = 0;

            for(OkyakusamaSeikyuMeisai__c seikyuMeisai : sltOpportunity.KaisyuYoteisOpportunity__r){
                // 請求金額を処理
                if (seikyuMeisai.SeikyuKingaku__c != null && seikyuMeisai.SeikyuHohoCode__c == Ctl_OkyakusamaSeikyuMeisai.seikyuHohoCodeMap.get('sousai')) {
                    simpleYasugo.ReportMaeukekin__c += seikyuMeisai.SeikyuKingaku__c;
                } else if (seikyuMeisai.SeikyuKingaku__c != null) {
                    simpleYasugo.ReportNyukingaku__c += seikyuMeisai.SeikyuKingaku__c;
                }
                // 請求方法を処理
                // サービス仕様として、クレカ・ローン・コンビニ・後払い・前受相殺の支払方法を併用することはないはずだが、
                // もしあった場合は、支払通知書作成時に気付くために「混合 (要確認)」という文字列にする
                if (simpleYasugo.ReportMaeukekin__c > 0 && simpleYasugo.ReportShiharaihoho__c == '' && seikyuMeisai.SeikyuHohoCode__c != Ctl_OkyakusamaSeikyuMeisai.seikyuHohoCodeMap.get('sousai')) {
                    // ここの条件は請求方法が「1. sousai」「2. sousai 以外」と続いたとき用のチェック
                    simpleYasugo.ReportShiharaihoho__c = SEIKYUHOUHOU_KONGO;
                } else if (simpleYasugo.ReportShiharaihoho__c == '' && seikyuMeisai.SeikyuHohoCode__c != Ctl_OkyakusamaSeikyuMeisai.seikyuHohoCodeMap.get('sousai')) {
                    // 請求方法が、クレカ・ローン・コンビニであればここ、ただし一回目のみ
                    simpleYasugo.ReportShiharaihoho__c = seikyuMeisai.SeikyuHouhou__c;
                } else if (simpleYasugo.ReportShiharaihoho__c != '' && simpleYasugo.ReportShiharaihoho__c != seikyuMeisai.SeikyuHouhou__c) {
                    // クレカ・ローン・コンビニで混合した支払方法が選択されている場合、ここ
                    simpleYasugo.ReportShiharaihoho__c = SEIKYUHOUHOU_KONGO;
                }
                // 決済日を処理
                if (simpleYasugo.ReportNyukinbi__c == null) {
                    simpleYasugo.ReportNyukinbi__c = seikyuMeisai.Kessaibi__c;
                } else if (simpleYasugo.ReportNyukinbi__c < seikyuMeisai.Kessaibi__c) {
                    simpleYasugo.ReportNyukinbi__c = seikyuMeisai.Kessaibi__c;
                }
                //後払手数料
                if (seikyuMeisai.SeikyuKingaku__c != null && seikyuMeisai.SeikyuHohoCode__c == Ctl_OkyakusamaSeikyuMeisai.seikyuHohoCodeMap.get('gmo_atobarai')) {
                    simpleYasugo.AtobaraiTesuryoTotal__c += ATOBARAI_TESURYO_GMO;
                }
            }

            upSimpleYasugoList.add(simpleYasugo);
        }

        update upSimpleYasugoList;
	}

}