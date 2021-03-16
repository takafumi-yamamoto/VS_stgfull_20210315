public class ObStWeekDuations {

    public class Duration {
        public Datetime fromDateTime;
        public Datetime toDateTime;
    }

    private static Integer getDaysToNextMonday(Date pDate){
        Datetime theDateTime = datetime.newInstance(pDate.year(), pDate.month(), pDate.day());
        String theWeek = theDateTime.format('E');
        if(theWeek == 'Mon') return 7;
        if(theWeek == 'Tue') return 6;
        if(theWeek == 'Wed') return 5;
        if(theWeek == 'Thu') return 4;
        if(theWeek == 'Fri') return 3;
        if(theWeek == 'Sat') return 2;
        if(theWeek == 'Sun') return 1;
        return 0;
    }
    private static Date getLastMonday(Date pDate){
        return pDate.addDays(-7).addDays( getDaysToNextMonday(pDate) );
    }

    public static List<Duration> getWeekDaysDurations(Date pStartDate, Date pEndDate){
        List<Duration> theDurations = new List<Duration>();
        if(pStartDate == null || pEndDate == null ) return theDurations;
        if(pStartDate > pEndDate ) return theDurations;

        Date theLastMonday = getLastMonday(pStartDate);
        Date fromDate = theLastMonday;
        while(fromDate <= pEndDate){
            Date theDurationDateFrom = fromDate;
            theDurationDateFrom = theDurationDateFrom < pStartDate ? pStartDate : theDurationDateFrom;
            Date theDurationDateTo = fromDate.addDays(4);
            theDurationDateTo = theDurationDateTo > pEndDate ? pEndDate : theDurationDateTo;

            if(theDurationDateFrom >= pStartDate && theDurationDateTo <= pEndDate && theDurationDateFrom <= theDurationDateTo){
                Duration theDuration = new Duration();
                theDuration.fromDateTime = 
                    Datetime.newInstance(
                        theDurationDateFrom.year(),theDurationDateFrom.month(),theDurationDateFrom.day()
                    );
                theDuration.toDateTime = 
                    Datetime.newInstance(
                        theDurationDateTo.year(),theDurationDateTo.month(),theDurationDateTo.day(),
                        23, 59, 59
                    );
                theDurations.add(theDuration);
            }
            fromDate = fromDate.addDays(7);
        }
        return theDurations;
    }
    public static List<Duration> getWeekEndDaysDurations(Date pStartDate, Date pEndDate){
        List<Duration> theDurations = new List<Duration>();
        if(pStartDate == null || pEndDate == null ) return theDurations;
        if(pStartDate > pEndDate ) return theDurations;

        Date theLastMonday = getLastMonday(pStartDate);
        Date fromDate = theLastMonday;
        while(fromDate <= pEndDate){
            Date theDurationDateFrom = fromDate.addDays(5);
            theDurationDateFrom = theDurationDateFrom < pStartDate ? pStartDate : theDurationDateFrom;
            Date theDurationDateTo = fromDate.addDays(6);
            theDurationDateTo = theDurationDateTo > pEndDate ? pEndDate : theDurationDateTo;

            if(theDurationDateFrom >= pStartDate && theDurationDateTo <= pEndDate && theDurationDateFrom <= theDurationDateTo){
                Duration theDuration = new Duration();
                theDuration.fromDateTime = 
                    Datetime.newInstance(
                        theDurationDateFrom.year(),theDurationDateFrom.month(),theDurationDateFrom.day()
                    );
                theDuration.toDateTime = 
                    Datetime.newInstance(
                        theDurationDateTo.year(),theDurationDateTo.month(),theDurationDateTo.day(),
                        23, 59, 59
                    );
                theDurations.add(theDuration);
            }
            fromDate = fromDate.addDays(7);
        }
        return theDurations;
    }
}