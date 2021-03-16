public class TesterPhoneEnts {

    public interface ITesterPhoneEntries {
        Boolean hasEntry(String pValue);
    }

    private static Set<String> f_CachedEntries = null;
    public class TesterPhoneEntries implements ITesterPhoneEntries{

        private void loadCache(){
            Set<String> theEntries = new Set<String>();
            for(TesterPhones__mdt aRecord : [SELECT Id, AllowedPhone__c FROM TesterPhones__mdt] ){
                if( String.isBlank(aRecord.AllowedPhone__c) ) continue;
                theEntries.add( formatPhone(aRecord.AllowedPhone__c) );
            }
            f_CachedEntries = theEntries;
        }
        private Set<String> getEntries(){
            if(f_CachedEntries == null) this.loadCache();
            return f_CachedEntries;
        }
        public Boolean hasEntry(String pPhone){
            return this.getEntries().contains(formatPhone(pPhone));
        }
        private String formatPhone(String pPhone){
            if(String.isBlank(pPhone)) return pPhone;
            return pPhone.replace('-','').replace('ー','');
        }
    }
    //Stub for Test
    public class TesterPhoneEntriesStub implements ITesterPhoneEntries{

        private Set<String> f_Entries = new Set<String>();

        @testVisible
        private TesterPhoneEntriesStub(){}
        public TesterPhoneEntriesStub addEntry(String pPhone){ this.f_Entries.add(pPhone); return this; }

        public Boolean hasEntry(String pPhone){
            return this.f_Entries.contains(pPhone);
        }
    }
}