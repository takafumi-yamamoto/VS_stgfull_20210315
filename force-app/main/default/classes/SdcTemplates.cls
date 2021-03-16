public class SdcTemplates {
	private static Map<String, Template> m_Cache = new Map<String, Template>();

    public Template getTemplate(String pTemplateName){
        if( !m_Cache.containsKey(pTemplateName) ){
            this.loadTemplate(pTemplateName);
        }
        return m_Cache.get(pTemplateName);
    }

    private void loadTemplate(String pTemplateName){
        
        List<SdcTemplates__mdt> theSdcTemplates = [
            SELECT 
            DeveloperName, Body__c
            FROM SdcTemplates__mdt
            WHERE DeveloperName = :pTemplateName
        ];
        if(theSdcTemplates.size() <= 0) return;

        SdcTemplates__mdt theSdcTemplate = theSdcTemplates.get(0);
        Template theTemplate = new Template();
        theTemplate.TemplateName = theSdcTemplate.DeveloperName;
        theTemplate.Body = theSdcTemplate.Body__c;

        m_Cache.put( pTemplateName, theTemplate);
    }

    public class Template{
        protected String TemplateName = '';
        protected String Body = '';
        public String getTemplateName(){ return this.TemplateName; }
        public String getBody(){ return this.Body; }
    }
}