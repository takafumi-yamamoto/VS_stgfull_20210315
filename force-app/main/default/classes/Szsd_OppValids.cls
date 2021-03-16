public class Szsd_OppValids {

    public static IOppBasicVallidator get_IOppBasicVallidator_instance(){
        return new OppBasicVallidator();
    }

    public enum Invalid_Reasons{
        RecordType,
        StageName,
        UriageDate,
        Account_Name,
        Account_TelNo
    }

    public interface IOppBasicVallidator {
        List<Opportunity> select_opps( List<String> p_opp_ids);
        Boolean is_valid(Opportunity p_opp);
        Boolean is_valid( String p_opp_id);
    }
    public class OppBasicVallidator implements IOppBasicVallidator{
        public List<Opportunity> select_opps( List<String> p_opp_ids){
            return[
                SELECT Id,
                StageName,
                Utiagebi__c,
                RecordType.DeveloperName,
                Account.Name,
                Account.Phone, Account.MobilePhone__c,
                Account.PersonDeathDate__pc,
                SimpleYasugoRef__r.ZokugaraSodanshaNitottenoTaishosha__c,
                SimpleYasugoRef__r.TaishoshaRef__r.Name,
                SimpleYasugoRef__r.TaishoshaRef__r.PersonDeathDate__pc
                FROM Opportunity
                WHERE Id IN :p_opp_ids
            ];
        }
        public Set<Invalid_Reasons> get_Invalid_Reason(Opportunity p_opp){
            Set<Invalid_Reasons> a_reasons = new Set<Invalid_Reasons>();

            if( p_opp.RecordType.DeveloperName != 'SimpleYasugo' ) { a_reasons.add(Invalid_Reasons.RecordType); }
            if( !new List<String>{'決定','施行完了', '施行待ち','商談クローズ'}.contains(p_opp.StageName) ) { a_reasons.add(Invalid_Reasons.StageName); }
            if( String.isBlank( p_opp.Account.Name ) ) { a_reasons.add(Invalid_Reasons.Account_Name); }
            if( String.isBlank( p_opp.Account.Phone ) && String.isBlank( p_opp.Account.MobilePhone__c ) ) { a_reasons.add(Invalid_Reasons.Account_TelNo); }
            if( p_opp.Utiagebi__c == null ) { a_reasons.add(Invalid_Reasons.UriageDate); }
            
            return a_reasons;
        }
		public Boolean is_valid(Opportunity p_opp){
			return this.get_Invalid_Reason(p_opp).size() == 0;
        }
        public Boolean is_valid( String p_opp_id){
            return this.is_valid(
                this.select_opps( new List<String>{p_opp_id} ).get(0)
            );
        }
    }
}