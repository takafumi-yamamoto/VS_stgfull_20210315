public class KrYsLockKeiyaku {
    
    public static IKeiyakuLocker get_IKeiyakuLocker_instance(){
        return new KeiyakuLocker();
    }
    public interface IKeiyakuLocker {
        void on_keiyaku_before_update(List<Keiyaku__c> p_new_ones, Map<Id, Keiyaku__c> p_old_ones);
    }
    public class KeiyakuLocker implements IKeiyakuLocker{
        public void on_keiyaku_before_update(List<Keiyaku__c> p_new_ones, Map<Id, Keiyaku__c> p_old_ones){
            for(Keiyaku__c a_new_one : p_new_ones){
                Keiyaku__c a_old_one = p_old_ones.get(a_new_one.Id);
                if( a_new_one.KeiyakuJokyo__c != a_old_one.KeiyakuJokyo__c ){
                    if( a_new_one.KeiyakuJokyo__c == '契約中' && a_new_one.IsYosinOverStop__c){
                        a_new_one.addError('与信Over限度額Overにより、契約中にできません');
                    }
                }
            }
        }
    }
}