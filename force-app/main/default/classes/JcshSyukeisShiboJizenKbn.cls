public class JcshSyukeisShiboJizenKbn {

    public static IShibo_Or_JizenKbn_Mapper get_IShibo_Or_JizenKbn_Mapper_instance(){
        return new Shibo_Or_JizenKbn_Mapper();
    }
    public interface IShibo_Or_JizenKbn_Mapper {
        String get_shibo_or_jizen_kubun(Opportunity pOpp);
    }
    public class Shibo_Or_JizenKbn_Mapper implements IShibo_Or_JizenKbn_Mapper{
        public String get_shibo_or_jizen_kubun(Opportunity pOpp){
            if(pOpp.TaishoushaJokyo__c == '死亡'){ return '死亡'; }
            return '事前(not死亡)';
        }
    }

}