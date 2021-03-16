public class KnowledgePublishingAuraCtl {

	@AuraEnabled
	public static void auraDoKnowledgePublishing(String recordId) {
		Knowledge__kav kav = [select Id, KnowledgeArticleId, ArticleNumber, RecordTypeId, Title, LastModifiedBy.Name from Knowledge__kav where Id = :recordId and Language = 'ja'];
		List<KnowledgeArticleVersion> kavOnline = [select Id, VersionNumber FROM KnowledgeArticleVersion WHERE ArticleNumber = :kav.ArticleNumber and PublishStatus = 'Online'];

		try{
			if(kav.RecordTypeId == null){
				kav.RecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Manual').getRecordTypeId();
				update kav;
			}

			KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
		}
		catch(Exception e){
			Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20191105-1443-01', 'ナレッジ公開処理')
                    .setSubjectRecordId(kav.KnowledgeArticleId)
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
            return;
		}

		Schema.DescribeSObjectResult d = Schema.SObjectType.Knowledge__kav;
		Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
		String recordTypeDeveloperName = rtMapById.get(kav.RecordTypeId).getName();
		GyomuRenraku__c insGyomuRenraku = new GyomuRenraku__c();
		insGyomuRenraku.Category__c = 'ナレッジ';
		insGyomuRenraku.Shubetsu__c = recordTypeDeveloperName;
		insGyomuRenraku.Name = kav.Title;
		insGyomuRenraku.KijiId__c = kav.Id;
		String kubun = '更新';
		if(kavOnline.size() == 0){
			kubun = '新規';
		}
		insGyomuRenraku.KnowledgeUpdateKubun__c = kubun;
		insert insGyomuRenraku;
	}
}