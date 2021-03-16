public class TerapSgSeikD3wDataSelect {

    public static ISelector get_ISelector_instance(){
        return new Selector();
    }
    public interface ISelector {
        List<TerapSgSeik__c> select_by_TerapSgSeik_ids(List<String> p_TerapSgSeik_ids );
    }

    public class Selector implements ISelector{

        public List<TerapSgSeik__c> select_by_TerapSgSeik_ids(List<String> p_TerapSgSeik_ids ){
            return [
                SELECT Id, Name, BillingTargetYearMonth__c,
                ToTorihikiSakiBango__c, ToName__c, 
                EmailExp__c,
                ToAddrZipCode__c, ToAddrState__c, City__c, Street__c,
                ZeinukiKingaku__c, Tax__c, ZeikomiKingaku__c,
                ShiharaiKijitsu__c, 
                FriKzGinkoName__c, FriKzGinkoCode__c,
                FriKzShitenName__c, FriKzShitenCode__c,
                FriKzKouzaType__c, FriKzKouzaBango__c, 
                FriKzMeigiName__c,
                TesuryoRate__c, TesuryoRateNextMonth__c, 
                Biko__c,
                (
                    SELECT Id, Descr__c, UnitPrice__c, Quantity__c, Price__c
                    FROM TerapSgSeikLines__r
                ),
                (
                    SELECT Id, ShodanBango__c, SekoDate__c, HoyoShubetsu__c, Seshu__c
                    FROM TerapSgSeikSekoLine__r
                    ORDER BY SekoDate__c
                ),
                (
                    SELECT Id, ShodanBango__c, ToiawaseDate__c, HoyoShubetsu__c, Seshu__c
                    FROM TerapSgSeikCallLines__r
                    ORDER BY ToiawaseDate__c
                )
                FROM TerapSgSeik__c
                WHERE Id IN :p_TerapSgSeik_ids
                AND DocStatus__c = 'Closed'
            ];
        }
    }
}