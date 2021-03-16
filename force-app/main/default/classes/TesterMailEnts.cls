public class TesterMailEnts {

    public interface ITesterMailEntries {
        Boolean hasEntry(String pValue);
    }

	private static Set<String> f_CachedEntries = null;
    public class TesterMailEntries implements ITesterMailEntries{

        private void loadCache(){
			Set<String> theEntries = new Set<String>();
			for(TesterMails__mdt aRecord : [SELECT Id, AllowMailAddress__c FROM TesterMails__mdt] ){
				if( String.isBlank(aRecord.AllowMailAddress__c) ) continue;
				theEntries.add( aRecord.AllowMailAddress__c.toLowerCase() );
			}
			f_CachedEntries = theEntries;
		}
		private Set<String> getEntries(){
			if(f_CachedEntries == null) this.loadCache();
			return f_CachedEntries;
		}
		public Boolean hasEntry(String pMailAddress){
			String theMailAddress = String.isBlank(pMailAddress) ? pMailAddress : pMailAddress.toLowerCase();
			return this.getEntries().contains(theMailAddress);
		}
    }
	//Stub for Test
	public class TesterMailEntriesStub implements ITesterMailEntries{

		private Set<String> f_Entries = new Set<String>();

		@testVisible
		private TesterMailEntriesStub(){}
		public TesterMailEntriesStub addEntry(String pMailAddress){ this.f_Entries.add(pMailAddress); return this; }

		public Boolean hasEntry(String pMailAddress){
			return this.f_Entries.contains(pMailAddress);
		}
	}
}