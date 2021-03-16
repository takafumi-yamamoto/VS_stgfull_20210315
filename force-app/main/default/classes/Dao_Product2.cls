public class Dao_Product2{

    private static Dao_Product2 f_Dao_Product2;
    public static Dao_Product2 getInstance(){
        if(f_Dao_Product2 == null) f_Dao_Product2 = new Dao_Product2();
        return f_Dao_Product2;
    }
    private Dao_Product2(){}

    private String getSelectBody(){
        return 'SELECT '
            + 'Name, SireKingakuKeisanHousiki__c, SireKingaku__c, TesuryoKingakuKeisanHoushiki__c, TesuryoKingaku__c, ShohinKamoku__c, HinmokuBunrui__c,HanbaiSyuryoBi__c,'
            + 'Id ,TesuryoCyoseiKingakuKeisanHoushiki__c, TesuryoCyoseiShohin__c, ShohinBango__c, k_Service_Id_exp__c, k_WaribikiPlan_Id_exp__c, k_Coupon_Id_exp__c, NameForCustomerExp__c '
            + 'FROM Product2 Where Id != null ';
    }

    public List<Product2> selectByIds(List<Id> pIds){
        return Database.query(this.getSelectBody() + 'and Id in :pIds');
    }

    public List<Product2> selectByNames(List<String> shohinmeis){
        return Database.query(this.getSelectBody() + 'and Shohinmei__c in :shohinmeis');
    }

    public Product2 selectByShohinBango(String shohinBango){
        List<Product2> olist =  Database.query(this.getSelectBody() + 'and ShohinBango__c = :shohinBango');
        if(olist.size() > 0) return olist.get(0);
        else return null;
    }

    public List<Product2> selectByShohinBangos(Set<String> shohinBangos){
        return Database.query(this.getSelectBody() + 'and ShohinBango__c = :shohinBangos');
    }

    public Product2 selectById(Id id){
        List<Product2> olist =  Database.query(this.getSelectBody() + 'and id = :id');
        if(olist.size() > 0) return olist.get(0);
        else return null;
    }

    public List<Product2> getWaribikiProduct(){
        return Database.query(this.getSelectBody() + ' and DataKubun__c in (\'2:割引プラン\', \'3:クーポン\') ');
    }

}