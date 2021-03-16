public class JizenwariShodanLinqs{

    public static List<Id> collectOppIds(List<JizenwariShodan> pJizenwariShodans){
        Set<Id> theIds = new Set<Id>();
        for(JizenwariShodan aJizenwariShodan : pJizenwariShodans){
            theIds.add( aJizenwariShodan.Opp.Id );
        }
        return new List<Id>(theIds);
    }

    public class JizenwariShodanLinq{

        private List<JizenwariShodan> f_Entries = new List<JizenwariShodan>();
        private List<IWhereCond> f_WhereConds = new List<IWhereCond>();
        private List<IOrderByCond> f_OrderByConds = new List<IOrderByCond>();

        public JizenwariShodanLinq(List<JizenwariShodan> entries){
            f_Entries = entries;
        }

        public JizenwariShodanLinq AddWhere(IWhereCond whereCond){
            this.f_WhereConds.add(whereCond);
            return this;
        }
        public JizenwariShodanLinq AddOrderBy(IOrderByCond orderByCond){
            this.f_OrderByConds.add(orderByCond);
            return this;
        }

        private List<JizenwariShodan> ApplyWhereConds(List<JizenwariShodan> entries, List<IWhereCond> conds){
            List<JizenwariShodan> entriesFiltered = new List<JizenwariShodan>();
            for(JizenwariShodan aEntry: entries){
                
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

        private List<JizenwariShodan> ApplyOrderByConds(List<JizenwariShodan> entries, List<IOrderByCond> conds){
            List<SortEntry> theSortEntries = new List<SortEntry>();
            for(JizenwariShodan aEntry : entries){
                theSortEntries.add(new SortEntry(aEntry, conds));
            }
            theSortEntries.sort();
            List<JizenwariShodan> entriesFiltered = new List<JizenwariShodan>();
            for(SortEntry aSortEntry : theSortEntries){
                entriesFiltered.add(aSortEntry.entry);
            }
            return entriesFiltered;
        }
        public List<JizenwariShodan> ToList(){
            return this.ApplyOrderByConds(
                this.ApplyWhereConds(this.f_Entries, this.f_WhereConds),
                this.f_OrderByConds
            );
        }

        public JizenwariShodan FirstOrDefault(){
            List<JizenwariShodan> theJizenwariShodans = this.ApplyOrderByConds(
                this.ApplyWhereConds(this.f_Entries, this.f_WhereConds),
                this.f_OrderByConds
            );
            return theJizenwariShodans.size() > 0 ? theJizenwariShodans.get(0) : null;
        }
    }

    public class SortEntry implements Comparable{
        public JizenwariShodan entry { get; private set; }
        public List<IOrderByCond> orderByConds {private get; private set; }

        public SortEntry(JizenwariShodan entry, List<IOrderByCond> orderByConds){
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
        Boolean IsMatch(JizenwariShodan entry);
    }
    public interface IOrderByCond{
        String GetSortKey(JizenwariShodan entry);
        Boolean IsDesc();
    }

    public class WhereKeiyakuStatusCds Implements IWhereCond{
        private LinqOpes.IStringsOperator f_Operator;
        private List<String> f_CondValues;
        public WhereKeiyakuStatusCds(LinqOpes.IStringsOperator operator, List<String> condValues){
            f_Operator = operator;
            f_CondValues = condValues;
        }
        public Boolean IsMatch(JizenwariShodan entry){
            return f_Operator.IsMatch(entry.Jizenwari.KeiyakuStatusCdExp__c, f_CondValues);
        }
    }

    public class WhereJizenWariPlanCodes Implements IWhereCond{
        private LinqOpes.IStringsOperator f_Operator;
        private List<String> f_CondValues;
        public WhereJizenWariPlanCodes(LinqOpes.IStringsOperator operator, List<String> condValues){
            f_Operator = operator;
            f_CondValues = condValues;
        }
        public Boolean IsMatch(JizenwariShodan entry){
            return f_Operator.IsMatch(entry.Jizenwari.JizenWariPlanCodeExp__c, f_CondValues);
        }
    }

    public class OrderByShodanBango Implements IOrderByCond{
        private Boolean f_IsDesc = false;
        public OrderByShodanBango(Boolean isDesc){
            f_IsDesc = isDesc;
        }
        public String GetSortKey(JizenwariShodan entry){
            String theValue = (entry.Opp.ShodanBangoF__c == null ? '' : entry.Opp.ShodanBangoF__c);
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