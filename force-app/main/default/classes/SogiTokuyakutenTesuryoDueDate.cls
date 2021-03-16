public class SogiTokuyakutenTesuryoDueDate {

    public static IDueDateResolver get_IDueDateResolver_incetance(){
        return new DueDateResolver();
    }

    public interface IDueDateResolver {
        Date get_due_date (Date p_uriagebi);
    }

    public class DueDateResolver implements IDueDateResolver {
        public Date get_due_date (Date p_uriagebi) {
            Date yokugetumatu = Date.newInstance(p_uriagebi.year(), p_uriagebi.month() + 2, 0);
            if(yokugetumatu.month() == 12){
                yokugetumatu = slide12Month(yokugetumatu);
            }
            Map<Date, String> shukujitsuMap = ShukujitsuMapCreate.getShukujitsuMap();
            while(true){
                yokugetumatu = slideDay(yokugetumatu);
                if(shukujitsuMap.containsKey(yokugetumatu)){
                  yokugetumatu = yokugetumatu.addDays(1);
                }
                else{
                  break;
                }
            }
            return yokugetumatu;
        }
        private Date slide12Month(Date d){
            return d.addDays(4);
        }
        private Date slideDay(Date d){
            datetime tDate = datetime.newInstance(d.year(), d.month(), d.day());
            switch on  tDate.format('E') {
              when 'Sun' {
                  return d.addDays(1);
                }
              when 'Sat' {
                  return d.addDays(2);
                }
              when else {
                  return d;
                }
            }
        }
    }
}