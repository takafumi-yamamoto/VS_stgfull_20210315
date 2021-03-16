public class OpportunityLinqs{

    public static Map<Id, Opportunity> ListToMapBySimpleYasugoRef(List<Opportunity> entries){
        Map<Id, Opportunity> theMap = new Map<Id, Opportunity>();
        for(Opportunity aEntry : entries){
            if(aEntry.SimpleYasugoRef__c != null) theMap.put( aEntry.SimpleYasugoRef__c,  aEntry);
        }
        return theMap;
    }
    public static Map<Id, Opportunity> ListToMapByObouRef(List<Opportunity> entries){
        Map<Id, Opportunity> theMap = new Map<Id, Opportunity>();
        for(Opportunity aEntry : entries){
            if(aEntry.ObosanbinRef__c != null) theMap.put( aEntry.ObosanbinRef__c,  aEntry);
        }
        return theMap;
    }
    public static Opportunity FirstOrDefault(List<Opportunity> entries){
        return entries.size() > 0 ? entries.get(0) : null;
    }

    public static Map<Id, Opportunity> ListToMapByEitaiKuyoRef(List<Opportunity> entries){
        Map<Id, Opportunity> theMap = new Map<Id, Opportunity>();
        for(Opportunity aEntry : entries){
            if(aEntry.EitaiKuyoRef__c != null) theMap.put( aEntry.EitaiKuyoRef__c,  aEntry);
        }
        return theMap;
    }

    public static Map<Id, Opportunity> ListToMapByUmieRef(List<Opportunity> entries){
        Map<Id, Opportunity> theMap = new Map<Id, Opportunity>();
        for(Opportunity aEntry : entries){
            if(aEntry.KaiyoSankotsuUmieRef__c != null) theMap.put( aEntry.KaiyoSankotsuUmieRef__c,  aEntry);
        }
        return theMap;
    }

    public static Map<Id, Opportunity> ListToMapByBestButsudanRef(List<Opportunity> entries){
        Map<Id, Opportunity> theMap = new Map<Id, Opportunity>();
        for(Opportunity aEntry : entries){
            if(aEntry.BestButsudanRef__c != null) theMap.put( aEntry.BestButsudanRef__c,  aEntry);
        }
        return theMap;
    }

    public static Map<Id, Opportunity> ListToMapByReviRef(List<Opportunity> entries){
        Map<Id, Opportunity> theMap = new Map<Id, Opportunity>();
        for(Opportunity aEntry : entries){
            if(aEntry.SogiReviRef__c != null) theMap.put( aEntry.SogiReviRef__c,  aEntry);
        }
        return theMap;
    }

    public static List<Id> collectKetteiSakiRef(List<Opportunity> entries){
        Set<Id> theIds = new Set<Id>();
        for(Opportunity aEntry : entries){
            if(aEntry.KetteiSakiRef__c != null) theIds.add(aEntry.KetteiSakiRef__c);
        }
        return new List<Id>( theIds );
    }

    public class OpportunityLinq{

        private List<Opportunity> f_Entries = new List<Opportunity>();
        private List<IWhereCond> f_WhereConds = new List<IWhereCond>();
        private List<IOrderByCond> f_OrderByConds = new List<IOrderByCond>();

        public OpportunityLinq(List<Opportunity> entries){
            f_Entries = entries;
        }

        public OpportunityLinq AddWhere(IWhereCond whereCond){
            this.f_WhereConds.add(whereCond);
            return this;
        }
        public OpportunityLinq AddOrderBy(IOrderByCond orderByCond){
            this.f_OrderByConds.add(orderByCond);
            return this;
        }

        private List<Opportunity> ApplyWhereConds(List<Opportunity> entries, List<IWhereCond> conds){
            List<Opportunity> entriesFiltered = new List<Opportunity>();
            for(Opportunity aEntry: entries){
                
                Boolean isMatch = true;
                for(IWhereCond whereCond: conds){
                    if(!whereCond.IsMatch(aEntry)){
                        isMatch = false;
                    }
                    if (!isMatch){break;}
                }
                if(isMatch){entriesFiltered.add(aEntry);}
            }
            return entriesFiltered;
        }

        private List<Opportunity> ApplyOrderByConds(List<Opportunity> entries, List<IOrderByCond> conds){
            List<SortEntry> theSortEntries = new List<SortEntry>();
            for(Opportunity aEntry : entries){
                theSortEntries.add(new SortEntry(aEntry, conds));
            }
            theSortEntries.sort();
            List<Opportunity> entriesFiltered = new List<Opportunity>();
            for(SortEntry aSortEntry : theSortEntries){
                entriesFiltered.add(aSortEntry.entry);
            }
            return entriesFiltered;
        }
        public List<Opportunity> ToList(){
            return this.ApplyOrderByConds(
                this.ApplyWhereConds(this.f_Entries, this.f_WhereConds),
                this.f_OrderByConds
            );
        }
    }

    public class SortEntry implements Comparable{
        public Opportunity entry { get; private set; }
        public List<IOrderByCond> orderByConds {private get; private set; }

        public SortEntry(Opportunity entry, List<IOrderByCond> orderByConds){
            this.entry = entry;
            this.orderByConds = orderByConds;
        }

        public String GetSortKey(){
            String theSortKey = '';
            for(IOrderByCond aOrderByCond : this.orderByConds){
                theSortKey = theSortKey + aOrderByCond.GetSortKey(this.entry);
            }
            return theSortKey;
        }

        public Integer compareTo(Object another) {
            SortEntry theAnother = (SortEntry)another;
            Integer theResult = 0;
            for(IOrderByCond aOrderByCond:orderByConds){
                String theSortKeyThis = aOrderByCond.GetSortKey(this.entry);
                String theSortKeyAnother = aOrderByCond.GetSortKey(theAnother.entry);
                Integer theAscDesc = (aOrderByCond.IsDesc() ? -1 : 1);
                if (theSortKeyThis > theSortKeyAnother) { theResult = 1 * theAscDesc; break; }
                if (theSortKeyThis < theSortKeyAnother) { theResult = -1* theAscDesc; break; }
            }
            return theResult;        
        }
    }

    public interface IWhereCond{
        Boolean IsMatch(Opportunity entry);
    }
    public interface IOrderByCond{
        String GetSortKey(Opportunity entry);
        Boolean IsDesc();
    }

    public class WhereCloseDate Implements IWhereCond{
        private LinqOpes.IDateOperator f_Operator;
        private Date f_CondValue;
        public WhereCloseDate(LinqOpes.IDateOperator operator, Date condValue){
            f_Operator = operator;
            f_CondValue = condValue;
        }
        public Boolean IsMatch(Opportunity entry){
            return f_Operator.IsMatch(entry.CloseDate, f_CondValue);
        }
    }

    public class OrderByCloseDate Implements IOrderByCond{
        private Boolean f_IsDesc = false;
        public OrderByCloseDate(Boolean isDesc){
            f_IsDesc = isDesc;
        }
        public String GetSortKey(Opportunity entry){
            return entry.CloseDate.format();
        }
        public Boolean IsDesc(){
            return this.f_IsDesc;
        }
    }
    public class OrderByShodanBango Implements IOrderByCond{
        private Boolean f_IsDesc = false;
        public OrderByShodanBango(Boolean isDesc){
            f_IsDesc = isDesc;
        }
        public String GetSortKey(Opportunity entry){
            String theValue = (entry.ShodanBangoF__c == null ? '' : entry.ShodanBangoF__c);
            return ('12345678901234567890' + theValue).right(20);
        }
        public Boolean IsDesc(){
            return this.f_IsDesc;
        }
    }
}
/*
new OpportunityLinqs.OpportunityLinq(theOpps)
    .AddWhere(new OpportunityLinqs.WhereCloseDate(new LinqOpes.DateGtOrEq(),Date.newInstance(2017,12,01)))
    .AddWhere(new OpportunityLinqs.WhereCloseDate(new LinqOpes.DateLtOrEq(),Date.newInstance(2017,12,22)))
    .AddOrderBy(new OpportunityLinqs.OrderByCloseDate(true))
    .AddOrderBy(new OpportunityLinqs.OrderByShodanBango(false))
    .ToList()
*/