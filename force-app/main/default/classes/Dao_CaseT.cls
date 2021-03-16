@isTest 
public class Dao_CaseT {
    private static void beginSetUp(){
		Utility_Common.isMimicExecAsDataIkouProfile = true;
    }
	private static void endSetUp(){
        Insert new TriggerIsActive__c( name='default', isActive__c=true );
        Insert new JizenWariPlan__c( Code__c='Yoriso' );
        Insert new Account(
            RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','null'),
            FirstName = '_', LastName = '_'
        );
		Utility_Common.isMimicExecAsDataIkouProfile = false;
	}
    @isTest public static void SearchByIds() {
        Test.startTest();
        Dao_Case.SearchByIds( new List<Id>() );
        Test.stopTest();
    }

    @isTest public static void getList_error(){
        String a_whereString = '';
        List<String> a_whereParams = new List<String>{ '', '', '', '', ''};
        List<List<Id>> a_whereArrayableParams = new List<List<Id>>{
            new List<Id>{null},
            new List<Id>{null},
            new List<Id>{null},
            new List<Id>{null},
            new List<Id>{null}
        };
        String a_strOrderByParam = '';
        Test.startTest();
        try{
            Dao_Case.getList(
                a_whereString,
                a_whereParams,
                a_whereArrayableParams,
                a_strOrderByParam
            );
        }catch(Exception ex){
            //ignore
        }
        Test.stopTest();
    }
}