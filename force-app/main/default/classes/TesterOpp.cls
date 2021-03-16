public class TesterOpp {

    public static ITestDataJudger get_ITestDataJudger_instance(){
        return new TestDataJudger();
    }
    public interface ITestDataJudger{
        Boolean isTestData( Opportunity pOpp );
        List<Opportunity> select_opps(List<String> p_opp_ids);
        Boolean isTestData( String p_opp_id );
    }
    public class TestDataJudger implements ITestDataJudger{
        public List<Opportunity> select_opps(List<String> p_opp_ids){
            return [
                SELECT Id, Name,
                Account.Name,
                Account.NameFurigana__c
                FROM Opportunity
                WHERE Id = :p_opp_ids
            ];
        }
		public Boolean isTestData( Opportunity pOpp ){
			if( this.containsTestKeywords(pOpp.Name) ) return true;
			if( this.containsTestKeywords(pOpp.Account.Name) ) return true;
			if( this.containsTestKeywords(pOpp.Account.NameFurigana__c) ) return true;
			return false;
        }
		public Boolean isTestData( String p_opp_id ){
            return this.isTestData(
                this.select_opps( new List<String>{ p_opp_id } ).get(0)
            );
        }

		private Boolean containsTestKeywords(String pValue){
			if( String.isBlank( pValue ) ) return false;
			if( pValue.contains('テスト') ) return true;
			if( pValue.contains('てすと') ) return true;
			if( pValue.toLowerCase().contains('test') ) return true;
			return false;
		}
    }
}