public class SmsTemplates {
	private static Map<String, Template> m_Cache = new Map<String, Template>();

    public Template getTemplate(String pTemplateName){
        if( !m_Cache.containsKey(pTemplateName) ){
            this.loadTemplate(pTemplateName);
        }
        return m_Cache.get(pTemplateName);
    }

    private void loadTemplate(String pTemplateName){
        
        List<SmsTemplates__mdt> theMdtRecords = [
            SELECT 
            DeveloperName, Body__c
            FROM SmsTemplates__mdt
            WHERE DeveloperName = :pTemplateName
        ];
        if(theMdtRecords.size() <= 0) return;

        SmsTemplates__mdt theMdtRecord = theMdtRecords.get(0);
        Template theTemplate = new Template();
        theTemplate.TemplateName = theMdtRecord.DeveloperName;
        theTemplate.Body = theMdtRecord.Body__c;

        m_Cache.put( pTemplateName, theTemplate);
    }

    public class Template{
        protected String TemplateName = '';
        protected String Body = '';
        public String getTemplateName(){ return this.TemplateName; }
        public String getBody(){ return this.Body; }
    }
}