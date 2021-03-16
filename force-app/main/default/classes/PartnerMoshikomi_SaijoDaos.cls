public class PartnerMoshikomi_SaijoDaos
{
    public static IPartnerMoshikomi_SaijoDao GetInstance(){
        return new PartnerMoshikomi_SaijoDao();
    }

    public interface IPartnerMoshikomi_SaijoDao{
        PartnerMoshikomi_Saijo__c SelectById(Id id);
    }

    public class PartnerMoshikomi_SaijoDao Implements IPartnerMoshikomi_SaijoDao{

        private PartnerMoshikomi_SaijoDao(){}

        private String getQueryBody(){
            return 'SELECT ' +
					'Id, ' +
					'IsDeleted, ' +
					'Name, ' +
					'ShisetsumeiFurigana__c, ' +
					'Saijomei__c, ' +
					'KoeiMinei__c, ' +
					'Organiser__c, ' +
					'PostalCode__c, ' +
					'State__c, ' +
					'City__c, ' +
					'Street__c, ' +
					'Phone1__c, ' +
					'FAX__c, ' +
					'HpUrl__c, ' +
					'CloseDay__c, ' +
					'HoleSetsumeibun__c, ' +
					'AccessHouhouDensha__c, ' +
					'AccessHohoBasu__c, ' +
					'AccessHohoKuruma__c, ' +
					'Bariafuri__c, ' +
					'TsukisoiAnchiKa__c, ' +
					'TaioKanoNinzu__c, ' +
					'ShukuhakuKa__c, ' +
					'ShukuhakuShisetsuRyokin__c, ' +
					'ShukuhakuShisetsuBiko__c, ' +
					'ShinzokuHikaeshitsuAri__c, ' +
					'AnchiMenkaiKa__c, ' +
					'ShawaRoomAri__c, ' +
					'ChushajoAri__c, ' +
					'Chushadaisu__c, ' +
					'KizzuRoomAri__c, ' +
					'HoyoKa__c, ' +
					'ZenShuhaTaioKa__c, ' +
					'BebiRoomAri__c, ' +
					'JunyushitsuAri__c, ' +
					'OmutsuKokandaiAri__c, ' +
					'AnchiKa__c, ' +
					'AnchiResidentPrice__c, ' +
					'AnchiTaioNinzu__c, ' +
					'Horeikosu__c, ' +
					'ChokusoKa__c, ' +
					'KasoshikiKa__c, ' +
					'IchinichisoKa__c, ' +
					'KazokusoKa__c, ' +
					'IppansoKa__c, ' +
					'Sogisha__c, ' +
					'ShisetsuRef__c ' +
					'FROM PartnerMoshikomi_Saijo__c WHERE Id != null ';
        }

        public PartnerMoshikomi_Saijo__c SelectById(Id id){
            List<PartnerMoshikomi_Saijo__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
    }
}