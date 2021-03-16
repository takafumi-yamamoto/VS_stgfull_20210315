public class shimizudev {
// SogiTokuyakutenTesuryoDueDate
    public static void test(){
        System.debug(SogiTokuyakutenTesuryoCalc.get_ITesuryoCalculator_incetance().get_tokuyakuten_tesuryo('0061s000005RuR7AAK'));
        Date a_date = date.newInstance(2021, 12, 1);
        System.debug(SogiTokuyakutenTesuryoDueDate.get_IDueDateResolver_incetance().get_due_date(a_date));
        
        // Date yokugetumatu = Date.newInstance(a_date.year(), a_date.month() + 2, 0);
        // System.debug(yokugetumatu);
    }

    public class sogi_tokuyakuten_nyukinshimekiri_date {
        public Date get_date (Date uriagebi) {
            Date yokugetumatu = Date.newInstance(uriagebi.year(), uriagebi.month() + 2, 0);
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