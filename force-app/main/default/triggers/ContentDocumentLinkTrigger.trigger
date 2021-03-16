trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
	System.debug('Trigger.new[0]' + Trigger.new[0]);
}