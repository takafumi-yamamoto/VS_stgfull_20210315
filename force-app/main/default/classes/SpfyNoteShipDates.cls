public class SpfyNoteShipDates {
    public class SpfyNoteShipDate {
        public Date getShipDate(String pNote){
            if(String.isBlank(pNote)) return null;

            Date theShipDate = null;
            String theDateString = '';
            String theText = 
                pNote
                .replace('\n','')
                .replace('\r','')
                .replace('/','-')
                .replace('＝','=');
            String regex = '^.*出荷日=([0-9]{4}-[0-9]{2}-[0-9]{2}).*$';
            Matcher m = Pattern.compile(regex).matcher(theText);
            if(m.matches()) { theDateString = m.group(1); }
            try{
                theShipDate = Date.valueOf(theDateString);
            }catch(Exception ex){
                theShipDate = null;
            }
            return theShipDate;
        }
    }
}