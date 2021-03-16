@isTest
private class KnowledgePublishingAuraCtlT {
	
	@isTest static void test_method_one() {

		Knowledge__kav objKnowledge = new Knowledge__kav();
		// URL 名
		objKnowledge.UrlName = 'UrlName';
		// タイトル
		objKnowledge.Title = 'Title';
		// 概要
		objKnowledge.Summary = 'Summary	';
		// 言語
		objKnowledge.Language = 'ja';
		// INSERT
		insert objKnowledge;
        
        // テスト開始
        Test.startTest();
        
        KnowledgePublishingAuraCtl.auraDoKnowledgePublishing(objKnowledge.Id); // 正常パターン
        KnowledgePublishingAuraCtl.auraDoKnowledgePublishing(objKnowledge.Id); // エラーパターン
        
        // テスト終了
        Test.stopTest();
	}
}