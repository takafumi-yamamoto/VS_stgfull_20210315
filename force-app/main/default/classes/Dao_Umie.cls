public class Dao_Umie{

    private static Dao_Umie f_Dao_Umie;
    public static Dao_Umie getInstance(){
        if(f_Dao_Umie == null){ 
            f_Dao_Umie = new Dao_Umie();
        }
        return f_Dao_Umie;
    }

    private Dao_Umie(){}
    private String getSelectBody(){
        return 'select '
        + 'TaishoshaRef__c,'
        + 'Id '
        + 'from KaiyoSankotsuUmie__c where (id != null) '
        ;
    }

    public KaiyoSankotsuUmie__c selectByid(Id pId){
        List<KaiyoSankotsuUmie__c> theEntities = Database.query(this.getSelectBody() + 'and Id = :pId');
        return theEntities.size() <= 0 ? null : theEntities.get(0);
    }
}