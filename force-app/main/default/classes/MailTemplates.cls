public class MailTemplates {

    private static Map<String, Template> m_Cache = new Map<String, Template>();

    public Template getTemplate(String pTemplateName){
        if( !m_Cache.containsKey(pTemplateName) ){
            this.loadTemplate(pTemplateName);
        }
        return m_Cache.get(pTemplateName);
    }

    private void loadTemplate(String pTemplateName){
        
        List<MailTemplates__mdt> theMailTemplates = [
            SELECT 
            DeveloperName, Title__c, Body__c, 
            Sender__c, 
            To__c, To2__c, To3__c
            FROM MailTemplates__mdt
            WHERE DeveloperName = :pTemplateName
        ];
        if(theMailTemplates.size() <= 0) return;

        MailTemplates__mdt theMailTemplate = theMailTemplates.get(0);
        Template theTemplate = new Template();
        theTemplate.TemplateName = theMailTemplate.DeveloperName;
        theTemplate.Title = theMailTemplate.Title__c;
        theTemplate.Body = theMailTemplate.Body__c;
        theTemplate.Sender = theMailTemplate.Sender__c;
        theTemplate.To = theMailTemplate.To__c;
        theTemplate.To2 = theMailTemplate.To2__c;
        theTemplate.To3 = theMailTemplate.To3__c;

        m_Cache.put( pTemplateName, theTemplate);
    }

    public class Template{
        protected String TemplateName = '';
        protected String Sender = '';
        protected String To = '';
        protected String To2 = '';
        protected String To3 = '';
        protected String Title = '';
        protected String Body = '';
        public String getTemplateName(){ return this.TemplateName; }
        public String getSender(){ return this.Sender; }
        public String getTo(){ return this.To; }
        public String getTo2(){ return this.To2; }
        public String getTo3(){ return this.To3; }
        public String getTitle(){ return this.Title; }
        public String getBody(){ return this.Body; }
    }
}