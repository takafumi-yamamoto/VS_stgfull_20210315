public class DashinSoryoLookup {

    @AuraEnabled 
    public static String searchDB(Integer lim, String searchText){
        searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';

        
        String query = 'SELECT Id, KeiyakuBango__c, Teikeisaki__r.Name FROM Keiyaku__c ' +
                            ' WHERE (( Teikeisaki__r.Name LIKE ' + searchText + ' ) ' +
                            ' OR ( KeiyakuBango__c LIKE ' + searchText + ' )) ' +
                            ' AND KeiyakuJokyo__c = \'契約中\'' +
                            ' AND RecordType.DeveloperName = \'Obosanbin\'' +
                        ' LIMIT '+lim;
        
        List<ResultWrapper> lstRet = new List<ResultWrapper>();
        
        for(Keiyaku__c s : Database.query(query)){
            ResultWrapper obj = new ResultWrapper();
            obj.id = s.Id;
            obj.keiyakuBango = s.KeiyakuBango__c ;
            obj.teikeisaki = s.Teikeisaki__r.Name;
            lstRet.add(obj);
        }
        return JSON.serialize(lstRet) ;
    }
    
    public class ResultWrapper{
        public String id {get;set;}
        public String keiyakuBango {get;set;}
        public String teikeisaki {get;set;}
        public String text{
            get {
                return this.keiyakuBango + ' ' + this.teikeisaki;
            }
        }
        public String val{
            get {
                return this.keiyakuBango;
            }
        }
    }
}