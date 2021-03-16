@isTest
public class SzsdPubCardT {
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

    private class IAssinger_Stub implements SzsdAssign.IAssinger{
        private SzsdAssign.Asigneees m_Asigneees;
        public IAssinger_Stub(SzsdAssign.Asigneees p_Asigneees){
            this.m_Asigneees = p_Asigneees;
        }
        public SzsdAssign.Asigneees resolve_asignnee(String p_opp_id){ return this.m_Asigneees; }
    }
    private class NcpCardCre_ICardCreator_Stub implements NcpCardCre.ICardCreator{
        public String try_publish_card( String p_opp_id, Boolean p_is_hakkou_shijji_directly){ return null; }
    }
    private class KrshCardCre_ICardCreator_Stub implements KrshCardCre.ICardCreator{
        public String try_publish_card( String p_opp_id, Boolean p_is_hakkou_shijji_directly){ return null; }
    }
    @isTest public static void CardPublisher_try_publish_card(){
        beginSetUp();
        Map<String, Account> the_accounts = new Map<String, Account>{
            '客-1' => new Account(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Account','Customer'),
                FirstName = '_', LastName = '_'
            )
        };
        INSERT the_accounts.values();

        Map<String, Opportunity> the_opps = new Map<String, Opportunity>{
            '葬儀商談-1' => new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','SimpleYasugo'),
                Name = '_',
                AccountId = the_accounts.get('客-1').Id,
                StageName = '_',
                CloseDate = Date.newInstance(2000,1,1)
            )
        };
        INSERT the_opps.values();
        endSetUp();

        Test.startTest();
        new SzsdPubCard.CardPublisher(
            new IAssinger_Stub( SzsdAssign.Asigneees.Ncp ),
            new NcpCardCre_ICardCreator_Stub(),
            new KrshCardCre_ICardCreator_Stub()
        )
        .try_publish_card( the_opps.get('葬儀商談-1').Id, true);
        Test.stopTest();
    }

    @isTest public static void get_ICardPublisher_instance(){
        Test.startTest();
        SzsdPubCard.get_ICardPublisher_instance();
        Test.stopTest();
    }
}