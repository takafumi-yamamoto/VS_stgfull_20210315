@isTest
public class KnowledgeSearchCtlT {

	@isTest(SeeAllData=true)
    static void testMethod_case1(){

    	DescribeDataCategoryGroupStructures.DescribeDataCategoryGroupStructureResults dr = new DescribeDataCategoryGroupStructures.DescribeDataCategoryGroupStructureResults();
		DescribeDataCategoryGroupStructures.DescribeDataCategoryGroupStructureMaps dm = dr.getDescribeDataCategoryGroupStructureResults();
		Map<String, Map<String, List<String>>> categoryGroupMap = dm.categoryMap;
		Map<String, List<KnowledgeArticleVersion>> dataCategoryMap = dm.dataCategoryMap;

		UserGroup__c ug = new UserGroup__c(Name='test');
		insert ug;

		UserGroupMember__c ugm = new UserGroupMember__c(UserGroupRef__c=ug.Id, UserRef__c=UserInfo.getUserId());
		insert ugm;

    	GyomuRenraku__c gr = new GyomuRenraku__c(
    								Name = '業務連絡', 
    								Category__c = 'システムリリース', 
    								Naiyo__c = '内容', 
    								ShuchiHani__c = 'よりそうのお葬式', 
    								UserGroupRef__c = ug.Id
    							);
    	insert gr;

    	KnowledgeSearchCtl know = new KnowledgeSearchCtl();
    	know.init();

    	ApexPages.currentPage().getParameters().put('gyomuRenrakuId', gr.Id);
    	know.actOpenGyomuRenrakuDetail();

    	List<Knowledge__DataCategorySelection> sltDataCategoryList = [SELECT 
																	    Id,
																	    ParentId,
																	    DataCategoryGroupName,
																	    DataCategoryName,
																	    CreatedDate,
																	    CreatedById,
																	    IsDeleted,
																	    SystemModstamp
																	 FROM Knowledge__DataCategorySelection];
		String manualId = '';
		String faqCategoryName = '';
		String faqId = '';
		for(Knowledge__DataCategorySelection sltDataCategory : sltDataCategoryList){
			if(sltDataCategory.DataCategoryGroupName == 'Manual'){
				if(manualId == ''){
					manualId = sltDataCategory.ParentId;
				}
			}
			else if(sltDataCategory.DataCategoryGroupName == 'Faq'){
				if(faqId == ''){
					faqCategoryName = sltDataCategory.DataCategoryName;
					faqId = sltDataCategory.ParentId;
				}
			}
		}

		ApexPages.currentPage().getParameters().put('manualId', manualId);
    	know.actOpenManualDetail();

    	ApexPages.currentPage().getParameters().put('sltCategoryName', faqCategoryName);
    	know.actOpenFaqList();

    	ApexPages.currentPage().getParameters().put('faqId', faqId);
    	know.actOpenFaqDetail();

    	know.actSearchResult();
    }
}