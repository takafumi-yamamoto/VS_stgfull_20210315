public with sharing class ShodanShohinNaviController {

    @AuraEnabled
    public static DataContext getDataContext(String recordId) {

        return new DataContextProvider
            (
            new OpportunityDao(),
            new OpportunityLineItemDao()
            )
            .GetDataCtx(recordId);
    }

    public class DataContextProvider{
    	private OpportunityDao f_OpportunityDao;
        private OpportunityLineItemDao f_OpportunityLineItemDao;

        public DataContextProvider(
        	OpportunityDao opportunityDao,
            OpportunityLineItemDao opportunityLineItemDao
            ){
        	this.f_OpportunityDao = opportunityDao;
            this.f_OpportunityLineItemDao = opportunityLineItemDao;
        }

        public DataContext GetDataCtx(String recordId){

        	List<Opportunity> opps = this.f_OpportunityDao.SelectBytorihikiShodanId(recordId);

            List<OpportunityLineItem> oppLIs = this.f_OpportunityLineItemDao.SelectByTehaiShodanId(this.f_OpportunityDao.ListToMapById(opps).keySet());
            
            List<ShodanShohinNaviTorihiki> shodanShohinNaviTorihikis = new List<ShodanShohinNaviTorihiki>();

            for (OpportunityLineItem aOppLI : oppLIs) {
                shodanShohinNaviTorihikis.add(
                    new ShodanShohinNaviTorihiki()
                    	.SetShodanName(aOppLI.Opportunity.Name)
                        .SetShohinId(aOppLI.Id)
                        .SetShohinBango(aOppLI.ProductCode)
                        .SetShohinName(aOppLI.Product2.Name)
                        .SetShohinSubtotal(aOppLI.Subtotal)
                        .SetShohinQuantity(aOppLI.Quantity)
                        .SetShohinUnitPrice(aOppLI.UnitPrice)
                        .SetShohinSyodanWaribikimoto(aOppLI.SyodanWaribikimoto__r.Name)
                );
            }

            return new DataContext()
                	.SetViewContext(new ViewContext()
                    .SetTorihikiShodanId(recordId)
                )
                .SetShodanShohinNaviTorihikis(shodanShohinNaviTorihikis)
                ;
        }
    }

    public class DataContext{
        @AuraEnabled public ViewContext viewContext {
            get { 
                if(this.viewContext == null) this.viewContext = new ViewContext();
                return this.viewContext; 
            }
            set { viewContext = value; }
        }
        @AuraEnabled public List<ShodanShohinNaviTorihiki> shodanShohinNaviTorihikis {
            get { 
                if(this.shodanShohinNaviTorihikis == null) this.shodanShohinNaviTorihikis = new List<ShodanShohinNaviTorihiki>();
                return this.shodanShohinNaviTorihikis; 
            }
            set { shodanShohinNaviTorihikis = value; }
        }
        public DataContext SetViewContext(ViewContext viewContext){
            this.viewContext = viewContext; return this;
        }
        public DataContext SetShodanShohinNaviTorihikis(List<ShodanShohinNaviTorihiki> shodanShohinNaviTorihikis){
            this.shodanShohinNaviTorihikis = shodanShohinNaviTorihikis;
            return this;
        }
    }

    public class ViewContext{

        @AuraEnabled public String torihikiShodanId {
            get { return torihikiShodanId; }
            set { torihikiShodanId = value; }
        }
        @AuraEnabled public String currentViewingShodanId {
            get { return currentViewingShodanId; }
            set { currentViewingShodanId = value; }
        }

        public ViewContext SetTorihikiShodanId(String recordId){
            this.torihikiShodanId = recordId; return this;
        }
    }

    public class ShodanShohinNaviTorihiki{
    	@AuraEnabled public String shodanName {
            get { return shodanName; }
            set { shodanName = value; }
        }
        @AuraEnabled public String shohinId {
            get { return shohinId; }
            set { shohinId = value; }
        }
        @AuraEnabled public String shohinBango {
            get { return shohinBango; }
            set { shohinBango = value; }
        }
        @AuraEnabled public String shohinName {
            get { return shohinName; }
            set { shohinName = value; }
        }
        @AuraEnabled public Decimal shohinSubtotal {
            get { return shohinSubtotal; }
            set { shohinSubtotal = value; }
        }
        @AuraEnabled public Decimal shohinQuantity {
            get { return shohinQuantity; }
            set { shohinQuantity = value; }
        }
        @AuraEnabled public Decimal shohinUnitPrice {
            get { return shohinUnitPrice; }
            set { shohinUnitPrice = value; }
        }
        @AuraEnabled public String shohinSyodanWaribikimoto {
            get { return shohinSyodanWaribikimoto; }
            set { shohinSyodanWaribikimoto = value; }
        }
        public ShodanShohinNaviTorihiki SetShodanName(String shodanName){
            this.shodanName = shodanName; return this;
        }
        public ShodanShohinNaviTorihiki SetShohinId(String recordId){
            this.shohinId = recordId; return this;
        }
        public ShodanShohinNaviTorihiki SetShohinBango(String shohinBango){
            this.shohinBango = shohinBango; return this;
        }
        public ShodanShohinNaviTorihiki SetShohinName(String shohinName){
            this.shohinName = shohinName; return this;
        }
        public ShodanShohinNaviTorihiki SetShohinSubtotal(Decimal shohinSubtotal){
            this.shohinSubtotal = shohinSubtotal; return this;
        }
        public ShodanShohinNaviTorihiki SetShohinQuantity(Decimal shohinQuantity){
            this.shohinQuantity = shohinQuantity; return this;
        }
        public ShodanShohinNaviTorihiki SetShohinUnitPrice(Decimal shohinUnitPrice){
            this.shohinUnitPrice = shohinUnitPrice; return this;
        }
        public ShodanShohinNaviTorihiki SetShohinSyodanWaribikimoto(String shohinSyodanWaribikimoto){
            this.shohinSyodanWaribikimoto = shohinSyodanWaribikimoto; return this;
        }
    }
}