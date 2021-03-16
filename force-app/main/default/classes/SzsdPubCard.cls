public class SzsdPubCard {

    public static ICardPublisher get_ICardPublisher_instance(){
        return new CardPublisher(
            SzsdAssign.get_IAssinger_instance(),
            NcpCardCre.get_ICardCreator_instance(),
            KrshCardCre.get_ICardCreator_instance()
        );
    }
    public interface ICardPublisher {
        String try_publish_card( String p_opp_id, Boolean p_is_hakkou_shijji_directly);
    }
    public class CardPublisher implements ICardPublisher{
        private SzsdAssign.IAssinger m_IAssinger;
        private NcpCardCre.ICardCreator m_NcpCardCre_ICardCreator;
        private KrshCardCre.ICardCreator m_KrshCardCre_ICardCreator;
        public CardPublisher(
            SzsdAssign.IAssinger p_IAssinger,
            NcpCardCre.ICardCreator p_NcpCardCre_ICardCreator,
            KrshCardCre.ICardCreator p_KrshCardCre_ICardCreator
        ){
            this.m_IAssinger = p_IAssinger;
            this.m_NcpCardCre_ICardCreator = p_NcpCardCre_ICardCreator;
            this.m_KrshCardCre_ICardCreator = p_KrshCardCre_ICardCreator;
        }

        public String try_publish_card( String p_opp_id, Boolean p_is_hakkou_shijji_directly){
            String the_card_id = null;
            if( m_IAssinger.resolve_asignnee(p_opp_id) == SzsdAssign.Asigneees.Ncp ){
                the_card_id = this.m_NcpCardCre_ICardCreator.try_publish_card(p_opp_id, p_is_hakkou_shijji_directly);
            }
            else{
                the_card_id = this.m_KrshCardCre_ICardCreator.try_publish_card(p_opp_id, p_is_hakkou_shijji_directly);
            }
            return the_card_id;
        }
    }
}