@isTest
public class Ctl_SimpleYasugo_UriageDateTest {
	@isTest(seeAllData=true)
	public static void doTest(){

        Account acc = new Account(
            Name = '_'
        );
        Insert acc;
        
        SimpleYasugo__c SimpleYasugo=new SimpleYasugo__c();
        insert SimpleYasugo;
        
        Opportunity theOpp = new Opportunity(
            AccountId = acc.Id,
            Name = '_',
            StageName = '_',
            CloseDate = Date.valueOf('1900-01-01'),
            TaishoushaJokyo__c = '_',
            SimpleYasugoRef__c = SimpleYasugo.Id
        );
        insert theOpp;
        theOpp.SimpleYasugoRef__c = SimpleYasugo.id;
        update theOpp;
        
        SimpleYasugo.KasoDateTime_Inp__c = DateTime.newInstance(2009, 3, 4, 21, 2, 2);
        update SimpleYasugo;      
          
        Date theActual = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theOpp.Id } ).get(0).Utiagebi__c;
        
        System.Debug('theActual'+ theActual);	
	}
}