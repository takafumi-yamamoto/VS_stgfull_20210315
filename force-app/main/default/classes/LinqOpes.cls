public class LinqOpes{
    
    public interface IDateOperator{
        Boolean IsMatch(Date value, Date condValue);
    }
    public class DateGtOrEq Implements IDateOperator{
        public Boolean IsMatch(Date value, Date condValue){
            if(value >= condValue){ return true;}
            return false;
        }
    }
    public class DateEq Implements IDateOperator{
        public Boolean IsMatch(Date value, Date condValue){
            if(value == condValue){ return true;}
            return false;
        }
    }
    public class DateLtOrEq Implements IDateOperator{
        public Boolean IsMatch(Date value, Date condValue){
            if(value <= condValue){ return true;}
            return false;
        }
    }

    public interface IStringsOperator{
        Boolean IsMatch(String value, List<String> condValue);
    }
    public class StringIn Implements IStringsOperator{
        public Boolean IsMatch(String value, List<String> condValues){
            for(String aCondValue : condValues){
                if(aCondValue == value) return true;
            }
            return false;
        }
    }
}