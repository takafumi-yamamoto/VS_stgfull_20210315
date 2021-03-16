public class Dao_EitaiKuyo{

    private static Dao_EitaiKuyo f_Dao_EitaiKuyo;
    public static Dao_EitaiKuyo getInstance(){
        if(f_Dao_EitaiKuyo == null){ 
            f_Dao_EitaiKuyo = new Dao_EitaiKuyo();
        }
        return f_Dao_EitaiKuyo;
    }

    private Dao_EitaiKuyo(){}
    private String getSelectBody(){
        return 'select '
        + 'TaishoshaRef__c,'
        + 'Id '
        + 'from EitaiKuyo__c where (id != null) '
        ;
    }

    public EitaiKuyo__c selectByid(Id pId){
        List<EitaiKuyo__c> theEntities = Database.query(this.getSelectBody() + 'and Id = :pId');
        return theEntities.size() <= 0 ? null : theEntities.get(0);
    }
}