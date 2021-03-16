public class Api_V1_SogSok_Soukyaku_Data {

    public class Soukyaku{
        public String soukyaku_bango = '';
        public String shodan_bango = '';
        public String soukyaku_datetime = '';
        public String soukyaku_status = '';
        public String soukyakusaki_torihikisaki_bango = '';
        public String soukyakusaki_name = '';
        public String soudansha_torihikisaki_bango = '';
        public String soudansha_name = '';
        public String soudansha_name_kana = '';
    }

    private String getSelectBody(){
        String theQuery = '';
        theQuery += 'select Id, Name,';
        theQuery += 'OpportunityRef__r.Id, OpportunityRef__r.ShodanBango__c, SoukyakuDateTime__c, SoukyakuStatus__c,' + ' ';
        theQuery += 'SoukyakuSakiKeiyakuRef__r.Id, SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.Id,' + ' ';
        theQuery += 'SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c,' + ' ';
        theQuery += 'SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.Name,' + ' ';
        theQuery += 'OpportunityRef__r.Account.Id,' + ' ';
        theQuery += 'OpportunityRef__r.Account.TorihikisakiBango__c, OpportunityRef__r.Account.Name,' + ' ';
        theQuery += 'OpportunityRef__r.Account.LastNameFurigana__pc, OpportunityRef__r.Account.FirstNameFurigana__pc' + ' ';
        theQuery += 'from SogSok_Sokyaku__c' + ' ';
        theQuery += 'where Id != null' + ' ';
        theQuery += 'and DocStatus__c = \'Activated\'' + ' ';
        return theQuery;
    }

    private Soukyaku createSoukyaku(SogSok_Sokyaku__c pSource){
        SogSok_Sokyaku__c aSoukyaku = pSource;
        Soukyaku theEntry = new Soukyaku();

        theEntry.soukyaku_bango = aSoukyaku.Name;
        theEntry.shodan_bango = String.isBlank(aSoukyaku.OpportunityRef__r.ShodanBango__c) ? '' : aSoukyaku.OpportunityRef__r.ShodanBango__c;
        theEntry.soukyaku_datetime = aSoukyaku.SoukyakuDateTime__c == null ? '' : aSoukyaku.SoukyakuDateTime__c.format('yyyy-MM-dd HH:mm:ss');
        theEntry.soukyaku_status = String.isBlank(aSoukyaku.SoukyakuStatus__c) ? '' : aSoukyaku.SoukyakuStatus__c;
        theEntry.soukyakusaki_torihikisaki_bango = 
            String.isBlank(aSoukyaku.SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c) 
            ? '' 
            : aSoukyaku.SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c;
        theEntry.soukyakusaki_name = 
            String.isBlank(aSoukyaku.SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.Name) 
            ? '' 
            : aSoukyaku.SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.Name;
        theEntry.soudansha_torihikisaki_bango =
            String.isBlank(aSoukyaku.OpportunityRef__r.Account.TorihikisakiBango__c) 
            ? '' 
            : aSoukyaku.OpportunityRef__r.Account.TorihikisakiBango__c;
        theEntry.soudansha_name =
            String.isBlank(aSoukyaku.OpportunityRef__r.Account.Name) 
            ? '' 
            : aSoukyaku.OpportunityRef__r.Account.Name
            ;

        theEntry.soudansha_name_kana = 
            ( String.isBlank(aSoukyaku.OpportunityRef__r.Account.LastNameFurigana__pc) ? '' : aSoukyaku.OpportunityRef__r.Account.LastNameFurigana__pc )
            + ' ' +
            ( String.isBlank(aSoukyaku.OpportunityRef__r.Account.FirstNameFurigana__pc) ? '' : aSoukyaku.OpportunityRef__r.Account.FirstNameFurigana__pc )
            ;
        return theEntry;
    }

    public List<Soukyaku> selectSoukyakuByPartnerTorihikiSakiBango(String pPartnerTorihikiSakiBango){

            List<SogSok_Sokyaku__c> theSogSokSokyakus = Database.query(
                this.getSelectBody()
                + 'and SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.TorihikisakiBango__c = :pPartnerTorihikiSakiBango' + ' '
                + 'order by SoukyakuDateTime__c desc, name desc' + ' '
            );

            List<Soukyaku> theSoukyakus = new List<Soukyaku>();
            for(SogSok_Sokyaku__c aSogSokSokyaku : theSogSokSokyakus){
                theSoukyakus.add( this.createSoukyaku( aSogSokSokyaku )  );
            }
            return theSoukyakus;
    }
    
    public Soukyaku selectSoukyakuBySoukyakuBango(String pSoukyakuBango){
            List<SogSok_Sokyaku__c> theSogSokSokyakus = Database.query(
                this.getSelectBody()
                + 'and Name = :pSoukyakuBango' + ' '
                + 'limit 1' + ' '
            );
            return theSogSokSokyakus.size() <= 0 ? null : this.createSoukyaku( theSogSokSokyakus.get(0) );
    }
}