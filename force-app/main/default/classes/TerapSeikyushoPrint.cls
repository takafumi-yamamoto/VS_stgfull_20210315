public class TerapSeikyushoPrint {
    public TerapSgSeik__c seikyusho {get; set;}
    public List<TerapSgSeikLine__c> terapSgSeikLines {get; set;}
    public List<TerapSgSeikCallLine__c> terapSgSeikCallLines {get; set;}
    public List<TerapSgSeikSekoLine__c> terapSgSeikSekoLines {get; set;}
    public Integer terapSgSeikCallLineSize {get; set;}
    public Integer terapSgSeikSekoLineSize {get; set;}
    public Integer month {get; set;}
    public Integer nextMonth {get; set;}
    public Boolean isShowSeikyusho {get; set;}

    public TerapSeikyushoPrint() {
        try {
            string SeikyuShoBango = ApexPages.CurrentPage().getParameters().get('no');
            this.seikyusho = [
                SELECT 
                        Id ,
                        Name,
                        BillingTargetYearMonthExp__c,
                        BillingTargetYearMonth__c,
                        IssueDate__c ,
                        ToTorihikiSakiBango__c ,
                        ToName__c ,
                        ToAddrZipCode__c ,
                        ToAddrState__c ,
                        City__c ,
                        Street__c ,
                        ZeinukiKingaku__c ,
                        Tax__c ,
                        ZeikomiKingaku__c ,
                        ShiharaiKijitsu__c ,
                        Biko__c ,
                        TesuryoRate__c ,
                        TesuryoRateNextMonth__c,
                        FriKzGinkoCode__c, FriKzGinkoName__c,
                        FriKzShitenCode__c, FriKzShitenName__c,
                        FriKzKouzaType__c, FriKzKouzaBango__c,
                        FriKzMeigiName__c,
                        (
                            SELECT 
                                    Id ,
                                    Descr__c ,
                                    Quantity__c ,
                                    UnitPrice__c ,
                                    Price__c
                            FROM TerapSgSeikLines__r
                            Order By CreatedDate
                        ),
                        (
                            SELECT 
                                    ToiawaseDate__c ,
                                    HoyoShubetsu__c ,
                                    Seshu__c 
                            FROM TerapSgSeikCallLines__r
                            Order By ToiawaseDate__c
                        ),
                        (
                            SELECT 
                                HoyoShubetsu__c,
                                Seshu__c,
                                SekoDate__c,
                                TerapSgSeikRef__c,
                                ShodanBango__c,
                                OppRef__c
                            FROM TerapSgSeikSekoLine__r
                        )
                        TerapSgSeikSekoLine__c
                FROM TerapSgSeik__c
                WHERE Name = :SeikyuShoBango
                LIMIT 1
                ].get(0);
            isShowSeikyusho = this.seikyusho.ZeikomiKingaku__c > 0;
            month = this.seikyusho.BillingTargetYearMonth__c == null ? null : this.seikyusho.BillingTargetYearMonth__c.month();
            nextMonth = this.seikyusho.BillingTargetYearMonth__c == null ? null : this.seikyusho.BillingTargetYearMonth__c.addMonths(1).month();
            terapSgSeikLines = this.seikyusho.TerapSgSeikLines__r;
            terapSgSeikCallLines = this.seikyusho.TerapSgSeikCallLines__r;
            terapSgSeikCallLineSize = this.seikyusho.TerapSgSeikCallLines__r.size();
            terapSgSeikSekoLines = this.seikyusho.TerapSgSeikSekoLine__r;
            terapSgSeikSekoLineSize = this.seikyusho.TerapSgSeikSekoLine__r.size();
            for(Integer i = terapSgSeikLines.size(); i < 10; i++) {
                terapSgSeikLines.add(new TerapSgSeikLine__c());
            }
            for(Integer i = terapSgSeikCallLineSize; i < 10; i++) {
                terapSgSeikCallLines.add(new TerapSgSeikCallLine__c());
            }
            for(Integer i = terapSgSeikSekoLineSize; i < 30; i++) {
                terapSgSeikSekoLines.add(new TerapSgSeikSekoLine__c());
            }
        } catch (Exception ex) {
            this.seikyusho = null;
        }
    }

}