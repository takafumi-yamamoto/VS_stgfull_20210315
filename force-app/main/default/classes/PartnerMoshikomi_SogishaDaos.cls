public class PartnerMoshikomi_SogishaDaos
{
    public static IPartnerMoshikomi_SogishaDao GetInstance(){
        return new PartnerMoshikomi_SogishaDao();
    }

    public interface IPartnerMoshikomi_SogishaDao{
        PartnerMoshikomi_Sogisha__c SelectById(Id id);
    }

    public class PartnerMoshikomi_SogishaDao Implements IPartnerMoshikomi_SogishaDao{

        private PartnerMoshikomi_SogishaDao(){}

        private String getQueryBody(){
            return 'SELECT ' +
					'Id, ' +
					'OwnerId, ' +
					'IsDeleted, ' +
					'Name, ' +
					'NameShogoFurigana__c, ' +
					'NameShogo__c, ' +
					'NameYagouFurigana__c, ' +
					'UneiKeitai__c, ' +
					'UneiKeitaiSonota__c, ' +
					'BillingPostalCode__c, ' +
					'BillingState__c, ' +
					'BillingCity__c, ' +
					'BillingStreet__c, ' +
					'Phone__c, ' +
					'Fax__c, ' +
					'MailAddress__c, ' +
					'Website__c, ' +
					'DaihyoshaseiKana__c, ' +
					'DaihyoshameiKana__c, ' +
					'Daihyoshasei__c, ' +
					'Daihyoshamei__c, ' +
					'KeiriTantoshaseiKana__c, ' +
					'KeiriTantoshameiKana__c, ' +
					'KeiriTantoshasei__c, ' +
					'KeiriTantoshamei__c, ' +
					'KeiriTantoshaTel__c, ' +
					'KeiyakuTantoshaseiKana__c, ' +
					'KeiyakuTantoshameiKana__c, ' +
					'KeiyakuTantoshasei__c, ' +
					'KeiyakuTantoshamei__c, ' +
					'KeiyakuTantoYakuShoku__c, ' +
					'KeiyakuTantoTelNo__c, ' +
					'ShuyoRenrakusaki__c, ' +
					'ShindaishaShoyusu__c, ' +
					'JisyaSaijoSyoyuSu__c, ' +
					'UnsoKyokasyoKubun__c, ' +
					'TokkijikoPartnerKinyu__c, ' +
					'SeikyusakiShogoKana__c, ' +
					'SeikyusakiShogo__c, ' +
					'SeikyusakiYagokana__c, ' +
					'SeikyusakiYago__c, ' +
					'SeikyuSakiAddrPostalCode__c, ' +
					'SeikyuSakiAddrState__c, ' +
					'SeikyuSakiAddrCity__c, ' +
					'SeikyuSakiAddrStreet__c, ' +
					'SeikyusakiTel__c, ' +
					'SeikyusakiFax__c, ' +
					'SeikyusakiTantoshaseiKana__c, ' +
					'SeikyusakiTantoshameiKana__c, ' +
					'SeikyusakiTantoshasei__c, ' +
					'SeikyusakiTantoshamei__c, ' +
					'BankName__c, ' +
					'BankBranchName__c, ' +
					'BankAccountType__c, ' +
					'BankAccountNo__c, ' +
					'BankAccountMeigi__c, ' +
					'HekinSekoKensuNen__c, ' +
					'SekoStaffNinzu__c, ' +
					'SekoKanoKensuTsuki__c, ' +
					'SosaiPlannerNinzu__c, ' +
					'SosaiDirectorNinzu__c, ' +
					'TaiouKanouArea__c, ' +
					'JishaSyukyakujiTaiokanoNaiyo__c, ' +
					'ShiharaiHoho__c, ' +
					'ShiharaiHohoSonota__c, ' +
					'SekoRyunyuHiritsuJishaShukaku__c, ' +
					'SekorRyunyuHiritsuByoinKesatsuKaigo__c, ' +
					'SekoRyunyuHiritsuInternet__c, ' +
					'SekoRyunyuHiritsuSonota__c, ' +
					'SekoHiritsuChokuso__c, ' +
					'SekoHiritsuIchinichiso__c, ' +
					'SekoHiritsuKazokuso__c, ' +
					'SekoHiritsuIppanso__c, ' +
					'SekoHiritsuHansoAnken__c, ' +
					'SekoHiritsuSonota__c, ' +
					'SekoHekinTanka__c, ' +
					'SogiBrandTaioKanoNaiyo__c, ' +
					'SaidaiEnkiNissuKasoshiki__c, ' +
					'SaidaiBunkatuKaisuKasoshiki__c, ' +
					'SaidaiEnkiNissuShikiari__c, ' +
					'SaidaiBunkatsuKaisuShikiari__c, ' +
					'TeikeisakiName__c, ' +
					'KeiyakuTantoEmail__c, ' +
					'OkyakusamaTeikeisaki__c, ' +
					'MoshikomiService__c ' +
					'FROM PartnerMoshikomi_Sogisha__c WHERE Id != null ';
        }

        public PartnerMoshikomi_Sogisha__c SelectById(Id id){
            List<PartnerMoshikomi_Sogisha__c> theEntities = Database.query(getQueryBody() + 'AND Id = :id');
            if(theEntities.size()>0){
                return theEntities.get(0);
            }
            return null;
        }
    }
}