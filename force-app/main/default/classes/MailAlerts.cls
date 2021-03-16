public class MailAlerts {

	public static void applyTemplate(MailTemplates.Template pTemplate, MailAlert__c pMailAlert){
		if( !String.isBlank(pTemplate.getTemplateName()) ) pMailAlert.TemplateName__c = pTemplate.getTemplateName();
		if( !String.isBlank(pTemplate.getSender()) ) pMailAlert.SashidashininMail__c = pTemplate.getSender();
		if( !String.isBlank(pTemplate.getTitle()) ) pMailAlert.Title__c = pTemplate.getTitle();
		if( !String.isBlank(pTemplate.getBody()) ) pMailAlert.Body__c = pTemplate.getBody();
		if( !String.isBlank(pTemplate.getTo()) ) pMailAlert.ToAddress__c = pTemplate.getTo();
		if( !String.isBlank(pTemplate.getTo2()) ) pMailAlert.ToAddress2__c = pTemplate.getTo2();
		if( !String.isBlank(pTemplate.getTo3()) ) pMailAlert.ToAddress3__c = pTemplate.getTo3();
	}
}