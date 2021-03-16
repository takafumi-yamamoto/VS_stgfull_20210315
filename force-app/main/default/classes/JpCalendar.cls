public class JpCalendar {
   static map<string,integer> JpCalendarMap=new Map<string,integer>{
     '明治' => 1868,
     '大正' => 1912,
     '昭和' => 1926,
     '平成' => 1989,
     '令和' => 2019
   };

    private static string getNengouFromJpCalendar(string JpDate){
      for (string str:JpCalendarMap.keySet()){
        if (JpDate.contains(str)){
          return str;
        }
      }
      return null;
    }
    private static integer getJpYearFromJpCalendar(string JpDate,string inNengou){
      integer endIndexOfNengou=JpDate.indexOf(inNengou)+inNengou.length();
      integer startIndexOfYear=JpDate.indexOf('年');
      string yearStr=JpDate.mid(endIndexOfNengou,startIndexOfYear-endIndexOfNengou);
      if (yearStr.isNumeric()){
        return integer.valueof(yearStr);
      }else if (yearStr == '元'){
        return 1;
      }else{
        return null;
      }      
    }
    private static integer getMonthFromJpCalendar(string JpDate){      
      integer IndexOfYear=JpDate.indexOf('年');
      integer IndexOfMonth=JpDate.indexOf('月');
      string monthStr=JpDate.mid(IndexOfYear+1,IndexOfMonth-IndexOfYear-1);
      if (monthStr.isNumeric()){
        return integer.valueof(monthStr);
      }else{
        return null;
      }      
    }  
    private static integer getDayFromJpCalendar(string JpDate){      
      integer IndexOfMonth=JpDate.indexOf('月');
      integer IndexOfDay=JpDate.indexOf('日');
      string dayStr=JpDate.mid(IndexOfMonth+1,IndexOfDay-IndexOfMonth-1);
      if (dayStr.isNumeric()){
        return integer.valueof(dayStr);
      }else{
        return null;
      }      
    }   

    public static String convertSeirekiToWareki(Date d) {
        
        if(d == null ) return null;
    
        String  nengou;
        Integer base;
        String[] element = String.valueOf(d).split('-', 0);
        Integer   wareki = Integer.valueOf(element[0]);

        if(1868 <= wareki && wareki <= 1911) {
            nengou = '明治';
            base   = 1868;
        }
        else if(1912 <= wareki && wareki <= 1925) {
            nengou = '大正';
            base   = 1912;
        }
        else if(1926 <= wareki && wareki <= 1988) {
            nengou = '昭和';
            base   = 1926;
        }
        else if((1989 <= wareki && wareki <= 2018) || (wareki == 2019 && (element[1] == '01' || element[1] == '02' || element[1] == '03' || element[1] == '04'))){
            nengou = '平成';
            base   = 1989;
        }
        else {
            nengou = '令和';
            base   = 2019;
        }
        
        return nengou + (wareki - base + 1) + '年' + element[1] + '月' + element[2] + '日';

    }
    
    public static date convertWarekiToSeireki(string JpDate){
      if (String.isblank(JpDate)||JpDate=='昭和年月日'|| !checkWarekiFormat(JpDate)) return null;
      string nengou=getNengouFromJpCalendar(JpDate);
      integer jpYear=getJpYearFromJpCalendar(JpDate,nengou);
      integer westernYear=JpCalendarMap.get(nengou)+jpYear-1;
      integer westernMonth=getMonthFromJpCalendar(JpDate);
      integer westernDay=getDayFromJpCalendar(JpDate);
      if (westernYear!=null && westernMonth!=null && westernDay!=null){
        return date.newInstance(westernYear, westernMonth, westernDay);
      }
      return null;  
    }

    public static boolean checkWarekiFormat(string strWareki){
    Pattern p = Pattern.compile('^(明治|大正|昭和|平成|令和)([0-9元]{1,2})年(0[1-9]|1[0-2]|[1-9])月([1-9]|0[1-9]|[12][0-9]|3[01])日$');
    Matcher m = p.matcher(strWareki);
    boolean result= m.matches();
    return result;      
    } 

}