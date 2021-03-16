@isTest
public class Dao_OpportunityTest {

    @isTest
    static void selectByCaseRefIdsTest(){

        Case theCase = new Case();
        Insert theCase;

        Account theAccount = new Account(Name = '_');
        Insert theAccount;

        Opportunity theOpp = new Opportunity(
            AccountId = theAccount.Id,
            CloseDate = Date.valueOf('1900-01-01'),
            Name = 'Test-20180314-1507-01',
            StageName = '_',
            CaseRef__c = theCase.Id,
            TaishoushaJokyo__c = '_'
        );
        Insert theOpp;

        List<Opportunity> theActual = Dao_Opportunity.getInstance().selectByCaseRefIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectByJizenwariIds = Dao_Opportunity.getInstance().selectByJizenwariIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectBySeizenKeiyakuIds = Dao_Opportunity.getInstance().selectBySeizenKeiyakuIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectByObosanbinIds = Dao_Opportunity.getInstance().selectByObosanbinIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectAllDataByObosanbinIds = Dao_Opportunity.getInstance().selectAllDataByObosanbinIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectBySimpleYasugoIds = Dao_Opportunity.getInstance().selectBySimpleYasugoIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectByEitaiKuyoIds = Dao_Opportunity.getInstance().selectByEitaiKuyoIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectByKaiyoSankotsuUmieIds = Dao_Opportunity.getInstance().selectByKaiyoSankotsuUmieIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectBySougiRevIds = Dao_Opportunity.getInstance().selectBySougiRevIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectByBestButsudanIds = Dao_Opportunity.getInstance().selectByBestButsudanIds( new List<Id>{ theCase.Id } );
        List<Opportunity> theselectByIds = Dao_Opportunity.getInstance().selectByIds( new List<Id>{ theCase.Id } );
        String recordId = theCase.Id;
        Opportunity theSearchById = Dao_Opportunity.SearchById(recordId);
        List<Opportunity> theSearchByIds = Dao_Opportunity.SearchByIds( new List<Id>{ theCase.Id } );
        List<String> ListrecordId = new List<String>();
        System.Debug(theActual);
    }
}