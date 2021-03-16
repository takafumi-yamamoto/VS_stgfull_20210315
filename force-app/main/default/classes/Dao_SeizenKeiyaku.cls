public class Dao_SeizenKeiyaku{

    private static Dao_SeizenKeiyaku instance;
    public static Dao_SeizenKeiyaku getInstance(){
        if(instance ==  null){
            instance = new Dao_SeizenKeiyaku();
        }
        return instance;
    }

    private Dao_SeizenKeiyaku(){}

    private String getSelectBody(){
        return 
        'SELECT'
        + ' '
        + 'Id, KeiyakuSya__c, KeiyakuKaishiBi__c' 
        + ' '
        + 'FROM SeizenKeiyaku__c Where Id != null ';
    }

    public List<SeizenKeiyaku__c> selectByids(List<Id> pIds){
        return Database.query( this.getSelectBody() + ' And Id in :pIds' );
    }

}