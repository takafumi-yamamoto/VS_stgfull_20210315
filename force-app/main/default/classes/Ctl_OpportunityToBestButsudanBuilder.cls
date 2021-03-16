/**
 * ベスト仏壇のサービスビルダー
 */
public class Ctl_OpportunityToBestButsudanBuilder implements Ctl_IOpportunityToServiceBuilder{
    public List<Opportunity> opps;
    public Ctl_OpportunityToBestButsudanBuilder() {
        opps = new List<Opportunity>();
    }   
    public void addOpp(Opportunity opp) {
		if(opp.BestButsudanRef__c == null) opps.add(opp);
    }
    public List<Dto_OpportunityServicePair> getOpportunityServicePairList() {
		List<Dto_OpportunityServicePair> pairList = new List<Dto_OpportunityServicePair>();
		set<id> caseIdset = new set<id>();
		for(Opportunity opp : opps) {
			caseIdset.add(opp.CaseRef__c);
		}
		map<id,case> caseMap=new map<id,case>([select id,
		                                              Origin,
		                                              subject,
		                                              description
                                                      //ご質問・ご要望                                                      
		                                         from case 
		                                        where id in :caseIdset]);
		for(Opportunity opp : opps) {
            BestButsudan__c service = new BestButsudan__c();
            // ------------- 値の設定 ----------------------            
            case c=caseMap.get(opp.CaseRef__c);
            if (c!=null){
            	//WebTOケースの場合
            	if (c.Origin=='Web'){
                //質問・ご要望
                //service.JuyoRenrakuJiko__c = c.ImporantMessage__c;
                }
                //メールTOケースの場合
                else if (c.Origin=='メール'){
                	integer a=1;
                	BestButsudanMailBodyAnalysis MailBodyAnalysis=new BestButsudanMailBodyAnalysis(c);
                	//お届け先氏名
                	service.TodokesakiName__c=MailBodyAnalysis.todokesakiName;
                	//お届け先町名・番地以降
                	service.TodokesakiStreet__c=MailBodyAnalysis.todokesakiAddress;
                	//お届け先郵便番号
                	service.TodokesakiZipCode__c=MailBodyAnalysis.todokesakiZipCode;
                	//お届け先電話番号
                	service.TodokesakiTelNo__c=MailBodyAnalysis.todokesakiTelNo;
                	//支払方法
                	service.Shiharaihoho__c=MailBodyAnalysis.shiharaihoho;
                }
            }
            // ------------- 後処理 ----------------------
            Dto_OpportunityServicePair pair = new Dto_OpportunityServicePair(opp, service);
            pairList.add(pair);
			
		}
		return pairList;
    }   
}