global class ComparableSoryo implements Comparable {

    public SoryoWrapper sw;

    public ComparableSoryo(SoryoWrapper sw) {
        this.sw = sw;
    }

    global Integer compareTo(Object compareTo) {

        ComparableSoryo compareToSw = (ComparableSoryo)compareTo;

        Integer returnValue = 0;
        if (sw.distance > compareToSw.sw.distance && compareToSw.sw.distance != null) returnValue = 1;
        else if (sw.distance < compareToSw.sw.distance || compareToSw.sw.distance == null) returnValue = -1;

        return returnValue;      
    }
}