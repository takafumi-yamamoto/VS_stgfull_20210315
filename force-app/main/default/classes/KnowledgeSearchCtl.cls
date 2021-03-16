public without sharing class KnowledgeSearchCtl {

	public Map<String, Map<String, List<String>>> categoryGroupMap = new Map<String, Map<String, List<String>>>();

	public Map<String, List<KnowledgeArticleVersion>> dataCategoryMap {get;set;}
	
	public Boolean gyomuRenrakuListPanelFlg {get;set;}
	public Boolean gyomuRenrakuDetailPanelFlg {get;set;}
	public Boolean manualDetailPanelFlg {get;set;}
	public Boolean faqListPanelFlg {get;set;}
	public Boolean faqDetailPanelFlg {get;set;}
	public Boolean searchResultPanelFlg {get;set;}
	public List<String> categoryLabelList {get;set;}
	public String categoryLabel {get;set;}

	public List<GyomuRenraku__c> gyomuRenrakuList {get;set;}
	public List<GyomuRenraku__c> gyomuRenrakuAutoList {get;set;}
	public GyomuRenraku__c gyomuRenrakuDetail {get;set;}
	public Knowledge__kav manualDetail {get;set;}
	public List<Knowledge__kav> faqList {get;set;}
	public Knowledge__kav faqDetail {get;set;}

	public List<GyomuRenraku__c> searchResultGyomuRenrakuList {get;set;}
	public List<Knowledge__kav> searchResultResultManualList {get;set;}
	public List<Knowledge__kav> searchResultFaqList {get;set;}

	public String KnowledgeManualRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('Manual').getRecordTypeId();
	public String KnowledgeFaqRecordTypeId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByDeveloperName().get('FAQ').getRecordTypeId();

	public String csIppanProfileId = '';
	public String csLeaderProfileId = '';

	public Map<String, MidokuUserWrap> midokuUserIdMap {get;set;}
	public Map<String, MidokuUserWrap> kidokuUserIdMap {get;set;}
	public class MidokuUserWrap {
		public String userName {get;set;}
		public String midokuStatus {get;set;}
		public MidokuUserWrap(){

		}
	}

	public Date kyo = Date.today();

	public Integer grDisplaySize = 20;
	public Integer grAllSize {get;set;}
	public Integer grPageSize {get;set;}
	public Integer grPageVal {get;set;}
	public Integer grPageFrom {get;set;}
	public Integer grPageTo {get;set;}
	public Integer grPageMax {get;set;}
	public List<SelectOption> grPageOpt {get;set;}
	public Boolean grFirstFlg {get;set;}
	public Boolean grBackFlg {get;set;}
	public Boolean grNextFlg {get;set;}
	public Boolean grLastFlg {get;set;}

	public Boolean editFlg {get;set;}

	public void init (){

		DescribeDataCategoryGroupStructures.DescribeDataCategoryGroupStructureResults dr = new DescribeDataCategoryGroupStructures.DescribeDataCategoryGroupStructureResults();
		DescribeDataCategoryGroupStructures.DescribeDataCategoryGroupStructureMaps dm = dr.getDescribeDataCategoryGroupStructureResults();
		categoryGroupMap = dm.categoryMap;
		dataCategoryMap = dm.dataCategoryMap;

		gyomuRenrakuListPanelFlg = true;
		gyomuRenrakuDetailPanelFlg = false;
		manualDetailPanelFlg = false;
		faqListPanelFlg = false;
		faqDetailPanelFlg = false;
		searchResultPanelFlg = false;
		categoryLabel = '';
		categoryLabelList = new List<String>();

		gyomuRenrakuList = new List<GyomuRenraku__c>();
		gyomuRenrakuAutoList = new List<GyomuRenraku__c>();
		gyomuRenrakuDetail = new GyomuRenraku__c();
		manualDetail = new Knowledge__kav();
		faqList = new List<Knowledge__kav>();
		faqDetail = new Knowledge__kav();

		searchResultGyomuRenrakuList = new List<GyomuRenraku__c>();
		searchResultResultManualList = new List<Knowledge__kav>(); 
		searchResultFaqList = new List<Knowledge__kav>();

		Map<Id, Profile> profileIdMap = new Map<Id, Profile>([select Id, Name from Profile where Name in ('CS一般', 'CS一般(リモートワーク用)','CSリーダ', '開発者')]);
		
		List<String> csProfileIdList = new List<String>();
		Map<Id, profile> editProfileIdMap = new Map<Id, profile>();
		for(Profile theProfile : profileIdMap.values()){
			if(theProfile.Name == 'CS一般' || theProfile.Name == 'CSリーダ' || theProfile.Name == 'CS一般(リモートワーク用)'){
				csProfileIdList.add(theProfile.Id);
			}

			if(theProfile.Name == '開発者' || theProfile.Name == 'CSリーダ'){
				editProfileIdMap.put(theProfile.Id, theProfile);
			}
		}

		editFlg = editProfileIdMap.containskey(UserInfo.getProfileId()) ? true : false;

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
		List<String> knowledgeIdList = new List<String>();
		for(Knowledge__DataCategorySelection sltDataCategory : sltDataCategoryList){
			knowledgeIdList.add(sltDataCategory.ParentId);
		}

		Map<ID, KnowledgeArticleVersion> sltKnowledgeKavMap = new Map<ID, KnowledgeArticleVersion>([SELECT 
																						Id,
																						Title 
																					FROM KnowledgeArticleVersion 
																					WHERE Id = :knowledgeIdList 
																					and PublishStatus = 'Online' 
																					and Language = 'ja'	]);
		
		List<KnowledgeArticleVersion> tempKnowledgeList = new List<KnowledgeArticleVersion>();
		for(Knowledge__DataCategorySelection sltDataCategory : sltDataCategoryList){
			KnowledgeArticleVersion tempKnowledge = new KnowledgeArticleVersion();
			if(sltKnowledgeKavMap.containskey(sltDataCategory.ParentId)){
				tempKnowledge = sltKnowledgeKavMap.get(sltDataCategory.ParentId);
			}
			else{
				continue;
			}

			if(dataCategoryMap.containskey(sltDataCategory.DataCategoryName)){
				tempKnowledgeList = dataCategoryMap.get(sltDataCategory.DataCategoryName);
			}
			
			tempKnowledgeList.add(tempKnowledge);
			dataCategoryMap.put(sltDataCategory.DataCategoryName, tempKnowledgeList);
		}

		actOpenGyomuRenrakuList();
		actOpenGyomuRenrakuKnowledgeList();
	}

	public String pSortItem{get;set;}
	public String pSortKey{get;set;}

	public void actOpenGyomuRenrakuList() {
		gyomuRenrakuList = new List<GyomuRenraku__c>();
		grFirstFlg = false;
		grBackFlg = false;
		grNextFlg = false;
		grLastFlg = false;

		String pCategory = Apexpages.currentPage().getParameters().get('pCategory');
		String pShuchiHani = Apexpages.currentPage().getParameters().get('pShuchiHani');
		String pGrPageVal = Apexpages.currentPage().getParameters().get('pGrPageVal');
		if(pGrPageVal == null || pGrPageVal == ''){
			pGrPageVal = '1';
		}
		pSortItem = Apexpages.currentPage().getParameters().get('pSortItem');
		if(pSortItem == null || pSortItem == ''){
			pSortItem = 'CreatedDate';
		}
		pSortKey = Apexpages.currentPage().getParameters().get('pSortKey');
		if(pSortKey == null || pSortKey == ''){
			pSortKey = 'desc';
		}

		Integer iGrPageVal = Integer.valueOf(pGrPageVal);

		String gyomuRenrakuSearchSOQL = 'select Id, ' + 
											'Name, ' + 
											'Category__c, ' + 
											'Naiyo__c, ' + 
											'ShuchiHani__c, ' + 
											'Shubetsu__c, ' + 
											'KijiId__c, ' + 
											'CreatedDate, ' + 
											'CreatedBy.Name, ' + 
											'LastModifiedBy.Name, ' + 
											'LastModifiedDate, ' + 
											'KidokuUserId__c, ' + 
											'Kidoku__c, ' + 
											'SaishuKoshinshaRef__r.Name, ' + 
											'SaishuKoshinbi__c ' + 
										'from GyomuRenraku__c ' + 
										'where Category__c != \'ナレッジ\'' + 
										' and ShoninStatus__c = \'OK\'' + 
										' and (ShuchiShuryobi__c = null OR ShuchiShuryobi__c >= :kyo)';

		if(pCategory != null && pCategory != ''){
			gyomuRenrakuSearchSOQL += ' and Category__c = \'' + pCategory + '\' ';
		}

		if(pShuchiHani != null && pShuchiHani != ''){
			gyomuRenrakuSearchSOQL += ' and ShuchiHani__c includes (\'' + pShuchiHani + '\') ';
		}

		gyomuRenrakuSearchSOQL += ' order by ' + pSortItem + ' ' + pSortKey;
		gyomuRenrakuSearchSOQL += ' LIMIT 200';

		System.debug('gyomuRenrakuSearchSOQL:' + gyomuRenrakuSearchSOQL);

		List<GyomuRenraku__c> gyomuRenrakuAllList = Database.query(gyomuRenrakuSearchSOQL);

		grAllSize = gyomuRenrakuAllList.size();
		grPageSize = grAllSize / grDisplaySize;
		grPageMax = grPageSize + 1;
		grPageVal = iGrPageVal;
		grPageOpt = new List<SelectOption>();
        for(Integer i = 1; i <= grPageMax; i++){
            grPageOpt.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        grPageFrom = grAllSize == 0 ? 0 : (grPageVal - 1) * grDisplaySize + 1;
		grPageTo = grPageVal * grDisplaySize;

		if(grPageTo >  grAllSize) grPageTo = grAllSize;

		Integer i = 0;
		for(GyomuRenraku__c gyomuRenraku : gyomuRenrakuAllList){
			i++;

			if(i < grPageFrom) continue;

			gyomuRenraku.Kidoku__c = '未読';
			if(gyomuRenraku.KidokuUserId__c != null && gyomuRenraku.KidokuUserId__c.contains(UserInfo.getUserId())){
				gyomuRenraku.Kidoku__c = '済';
			}
			gyomuRenrakuList.add(gyomuRenraku);

			if(i >= grPageTo) break;
		}

		if(grPageMax <= iGrPageVal) grNextFlg = true;
		if(grPageMax == iGrPageVal) grLastFlg = true;
		if(1 >= iGrPageVal) grBackFlg = true;
		if(1 == iGrPageVal) grFirstFlg = true;

		gyomuRenrakuListPanelFlg = true;
	}

	public void actOpenGyomuRenrakuKnowledgeList() {
		gyomuRenrakuAutoList = [select Id, 
										Name, 
										Category__c, 
										Naiyo__c, 
										ShuchiHani__c, 
										Shubetsu__c, 
										KnowledgeUpdateKubun__c, 
										KijiId__c, 
										CreatedDate, 
										CreatedBy.Name, 
										LastModifiedBy.Name, 
										LastModifiedDate, 
										KidokuUserId__c, 
										Kidoku__c, 
										SaishuKoshinshaRef__r.Name, 
										SaishuKoshinbi__c 
									from GyomuRenraku__c 
									where Category__c = 'ナレッジ' 
									order by SaishuKoshinbi__c desc 
									limit 10];
	}


	public void actOpenGyomuRenrakuDetail() {
		displayAllHide();
		gyomuRenrakuDetailPanelFlg = true;

		String gyomuRenrakuId = Apexpages.currentPage().getParameters().get('gyomuRenrakuId');
		gyomuRenrakuDetail = [select Id, Name, Category__c, Naiyo__c, ShuchiHani__c, CreatedDate, CreatedBy.Name, LastModifiedBy.Name, LastModifiedDate, KidokuUserId__c, Kidoku__c, SaishuKoshinbi__c, SaishuKoshinshaRef__r.Name, UserGroupRef__c from GyomuRenraku__c where Id = :gyomuRenrakuId for update];

		if(gyomuRenrakuDetail.KidokuUserId__c == null) gyomuRenrakuDetail.KidokuUserId__c = '';

		if(!gyomuRenrakuDetail.KidokuUserId__c.contains(UserInfo.getUserId())){
			gyomuRenrakuDetail.KidokuUserId__c += UserInfo.getUserId() + ';';
			update gyomuRenrakuDetail;
		}

		midokuUserIdMap = new Map<String, MidokuUserWrap>();
		kidokuUserIdMap = new Map<String, MidokuUserWrap>();
		
		if(gyomuRenrakuDetail.UserGroupRef__c == null) return; 

		Map<String, UserGroupMember__c> userIdMap = new Map<String, UserGroupMember__c>();
		for(UserGroupMember__c aUserGroupMember : [select Id, UserRef__c, UserRef__r.LastName, UserRef__r.FirstName from UserGroupMember__c where UserGroupRef__c = :gyomuRenrakuDetail.UserGroupRef__c]){
			userIdMap.put(aUserGroupMember.UserRef__c, aUserGroupMember);
		}

		for(String userId : userIdMap.keySet()){
			UserGroupMember__c userGroupMemberTemp = userIdMap.get(userId);
			MidokuUserWrap midokuUserWrap = new MidokuUserWrap();
			midokuUserWrap.userName = userGroupMemberTemp.UserRef__r.LastName + ' ' + userGroupMemberTemp.UserRef__r.FirstName;

			if(gyomuRenrakuDetail.KidokuUserID__c.contains(userId)) {
				midokuUserWrap.midokuStatus = '済';
				kidokuUserIdMap.put(userId, midokuUserWrap);
			}
			else{
				midokuUserWrap.midokuStatus = '未読';
				midokuUserIdMap.put(userId, midokuUserWrap);
			}
		}
	}

	public void actOpenManualDetail() {
		displayAllHide();
		manualDetailPanelFlg = true;

		String knowledgeArticleId = Apexpages.currentPage().getParameters().get('manualId');

		manualDetail = [select Id, 
								Title, 
								Detail__c, 
								DetailShagaimuke__c, 
								Summary, 
								CreatedDate, 
								CreatedBy.Name, 
								LastModifiedBy.Name, 
								LastModifiedDate, 
								AttachmentFile1__Name__s, 
								AttachmentFile1__ContentType__s, 
								AttachmentFile1__Body__s, 
								AttachmentFile2__Name__s, 
								AttachmentFile2__ContentType__s, 
								AttachmentFile2__Body__s, 
								AttachmentFile3__Name__s, 
								AttachmentFile3__ContentType__s, 
								AttachmentFile3__Body__s, 
								AttachmentFile4__Name__s, 
								AttachmentFile4__ContentType__s, 
								AttachmentFile4__Body__s, 
								AttachmentFile5__Name__s, 
								AttachmentFile5__ContentType__s, 
								AttachmentFile5__Body__s 
							from Knowledge__kav where Id = :knowledgeArticleId UPDATE VIEWSTAT];
		
		categoryLabelList = new List<String>();
		List<Knowledge__DataCategorySelection> kdsList = [select Id, ParentId, DataCategoryGroupName, DataCategoryName from Knowledge__DataCategorySelection where ParentId = :knowledgeArticleId];
		for(Knowledge__DataCategorySelection kds : kdsList){
			if(categoryGroupMap.containsKey(kds.DataCategoryGroupName)){
				Map<String, List<String>> categoryMap = categoryGroupMap.get(kds.DataCategoryGroupName);
				if(categoryMap.containsKey(kds.DataCategoryName)){
					List<String> categoryList = categoryMap.get(kds.DataCategoryName);
					String categoryLabel = '';
					Integer i = 0;
					for(String category : categoryList){
						i++;
						categoryLabel += category;
						if(i != categoryList.size()){
							categoryLabel += ' > ';
						}
					}
					categoryLabelList.add(categoryLabel);
				}
			}
		}
	}

	public void actOpenFaqList() {
		displayAllHide();
		faqListPanelFlg = true;

		String sltCategoryName = Apexpages.currentPage().getParameters().get('sltCategoryName');

		String strSoql = 'SELECT Id ' + 
							'FROM KnowledgeArticleVersion ' + 
							'WHERE PublishStatus=\'Online\'	AND Language = \'ja\' ' + 
							'WITH DATA CATEGORY Faq__c ABOVE ' + sltCategoryName + '__c';
		List<String> kavIdList = new List<String>();
		for(KnowledgeArticleVersion sltKav : Database.query(strSoql)){
			kavIdList.add(sltKav.Id);
		}
		faqList = [select Id, Title, Detail__c, DetailShagaimuke__c, Summary, CreatedDate, CreatedBy.Name, LastModifiedBy.Name, LastModifiedDate from Knowledge__kav where Id = :kavIdList];
	}

	public void actOpenFaqDetail() {
		displayAllHide();
		faqDetailPanelFlg = true;

		String knowledgeArticleId = Apexpages.currentPage().getParameters().get('faqId');

		faqDetail = [select Id, 
							Title, 
							Detail__c, 
							DetailShagaimuke__c, 
							Summary, 
							CreatedDate, 
							CreatedBy.Name, 
							LastModifiedBy.Name, 
							LastModifiedDate, 
							AttachmentFile1__Name__s, 
							AttachmentFile1__ContentType__s, 
							AttachmentFile1__Body__s, 
							AttachmentFile2__Name__s, 
							AttachmentFile2__ContentType__s, 
							AttachmentFile2__Body__s, 
							AttachmentFile3__Name__s, 
							AttachmentFile3__ContentType__s, 
							AttachmentFile3__Body__s, 
							AttachmentFile4__Name__s, 
							AttachmentFile4__ContentType__s, 
							AttachmentFile4__Body__s, 
							AttachmentFile5__Name__s, 
							AttachmentFile5__ContentType__s, 
							AttachmentFile5__Body__s 
						from Knowledge__kav 
						where Id = :knowledgeArticleId UPDATE VIEWSTAT];
		
		categoryLabelList = new List<String>();
		List<Knowledge__DataCategorySelection> kdsList = [select Id, ParentId, DataCategoryGroupName, DataCategoryName from Knowledge__DataCategorySelection where ParentId = :knowledgeArticleId];
		for(Knowledge__DataCategorySelection kds : kdsList){
			if(categoryGroupMap.containsKey(kds.DataCategoryGroupName)){
				Map<String, List<String>> categoryMap = categoryGroupMap.get(kds.DataCategoryGroupName);
				if(categoryMap.containsKey(kds.DataCategoryName)){
					List<String> categoryList = categoryMap.get(kds.DataCategoryName);
					String categoryLabel = '';
					Integer i = 0;
					for(String category : categoryList){
						i++;
						categoryLabel += category;
						if(i != categoryList.size()){
							categoryLabel += ' > ';
						}
					}
					categoryLabelList.add(categoryLabel);
				}
			}
		}
	}

	public void actSearchResult() {
		displayAllHide();
		searchResultPanelFlg = true;

		searchResultGyomuRenrakuList = new List<GyomuRenraku__c>();
		searchResultResultManualList = new List<Knowledge__kav>(); 
		searchResultFaqList = new List<Knowledge__kav>(); 

		String searchKeyWord = Apexpages.currentPage().getParameters().get('searchKeyWord');
		String searchGyomuRenrakuFlg = Apexpages.currentPage().getParameters().get('searchGyomuRenrakuFlg');
		String searchManualFlg = Apexpages.currentPage().getParameters().get('searchManualFlg');
		String searchFaqFlg = Apexpages.currentPage().getParameters().get('searchFaqFlg');

		String strSosl = 'FIND \'' + searchKeyWord + '\' IN ALL FIELDS RETURNING GyomuRenraku__c(Id, Name, Category__c, Naiyo__c, ShuchiHani__c, CreatedDate, CreatedBy.Name, LastModifiedBy.Name, LastModifiedDate), Knowledge__kav(Id, Title, RecordTypeId, Summary, DetailShagaimuke__c, Detail__c, CreatedDate, CreatedBy.Name, LastModifiedBy.Name, LastModifiedDate WHERE PublishStatus = \'Online\' AND Language = \'ja\') ';
		List<List<sObject>> searchList = search.query(strSosl);
		
		if(searchGyomuRenrakuFlg == 'true'){
			for(GyomuRenraku__c gyomurenraku : (List<GyomuRenraku__c>)searchList[0]){
				if(gyomurenraku.Category__c != 'ナレッジ') searchResultGyomuRenrakuList.add(gyomurenraku);
			}
		}

		List<Knowledge__kav> searchResultKnowledgeList = (List<Knowledge__kav>)searchList[1];
		for(Knowledge__kav searchResultKnowledge : searchResultKnowledgeList){
			if(searchManualFlg == 'true' && searchResultKnowledge.RecordTypeId == KnowledgeManualRecordTypeId){
				searchResultResultManualList.add(searchResultKnowledge);
			}
			
			if(searchFaqFlg == 'true' && searchResultKnowledge.RecordTypeId == KnowledgeFaqRecordTypeId){
				searchResultFaqList.add(searchResultKnowledge);
			}
		}
	}

	private void displayAllHide(){
		gyomuRenrakuListPanelFlg = false;
		gyomuRenrakuDetailPanelFlg = false;
		manualDetailPanelFlg = false;
		faqListPanelFlg = false;
		faqDetailPanelFlg = false;
		searchResultPanelFlg = false;
	}

	public String gyomuRenrakuCategoryVal {get;set;}
	public String shuchiHaniVal {get;set;}

	public List<SelectOption> gyomuRenrakuCategoryOpt{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = GyomuRenraku__c.Category__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            options.add(new SelectOption('', 'すべて'));
            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }

    public List<SelectOption> shuchiHaniOpt{
        get{
            List<SelectOption> options = new List<SelectOption>();

            Schema.DescribeFieldResult fieldResult = GyomuRenraku__c.ShuchiHani__c.getDescribe();
            List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();

            options.add(new SelectOption('', 'すべて'));
            for( Schema.PicklistEntry e : picklistEntries ){
                options.add(new SelectOption(e.getValue(), e.getLabel()));
            }

            return options;
        }
        set;
    }
}