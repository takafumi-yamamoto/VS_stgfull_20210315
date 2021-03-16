public class NpTorihikiTourokuController extends PaginationController {

    public List<Opportunity> allrecords {get; set;}
    public String utiagebi {get; set;}
    public Boolean isSearch {get; set;}
    public String LINE_CODE {
        get { return '\r\n'; }
    }

    public NpTorihikiTourokuController() {
        this.isSearch = false;
        this.utiagebi = Datetime.now().format('YYYY-MM');
        this.allrecords = new List<Opportunity>();
        this.reloadPagination(allrecords);
    }

    private Date getFirstDateOfMonth(String dateStr){
        List<String> tmp = dateStr.split('-');
        return Date.newInstance(Integer.valueOf(tmp[0]), Integer.valueOf(tmp[1]), 1);
    }
    private Date getLastDateOfMonth(String dateStr){
        return this.getFirstDateOfMonth(dateStr).addMonths(1).addDays(-1);
    }
    
    public void doSearch() {
        if(String.isBlank(this.utiagebi)) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, '検索月を選択してください。'));
            this.isSearch = false;
            return;
        }
        this.isSearch = true;
        Date utiagebiStart = this.getFirstDateOfMonth(this.utiagebi);
        Date utiagebiEnd = this.getLastDateOfMonth(this.utiagebi);

        this.allrecords = [select ShodanBangoF__c , KetteiPlanName__c, Utiagebi__c , ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.TorihikisakiBangoF__c , SeikyuZandakaPartnerExp__c, SekouTantoRef__r.Teikeisaki__r.Name 
                        from Opportunity 
                        Where ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.TorihikisakiBangoF__c <> null
                        AND ObosanbinRef__r.ObosanbinKeiyakuMadoguchi__r.ObousanBinTehaiKubun__c = '自社手配'
                        AND KakuteibiSyodan__c <> null
                        AND RecordType.DeveloperName = 'Obosanbin'
                        AND Utiagebi__c >= :utiagebiStart
                        AND Utiagebi__c <= :utiagebiEnd
                        AND StageName = '商談クローズ'
                        AND SeikyuZandakaPartnerExp__c > 0
                        AND NyukinGakuParterExp__c = 0
                        AND Iriguchi__c not in ('Yahoo', 'Amazon')
                        limit 3000
                        ];
        this.reloadPagination(allRecords);
    }

    public List<Opportunity> getRecords() {
        return (List<Opportunity>)this.getCurrentRecords();
    }
    
    public PageReference doClick() {
        return Page.NpTorihikiTourokuDownloadPage.setRedirect(false);
    }
}