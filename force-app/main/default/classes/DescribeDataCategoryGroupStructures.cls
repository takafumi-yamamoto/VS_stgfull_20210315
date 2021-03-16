public without sharing class DescribeDataCategoryGroupStructures {

	public class DescribeDataCategoryGroupStructureMaps{

		public List<DescribeDataCategoryGroupStructureResult> dataCategoryGroupStructureResult = new List<DescribeDataCategoryGroupStructureResult>();
		public Map<String, List<KnowledgeArticleVersion>> dataCategoryMap = new Map<String, List<KnowledgeArticleVersion>>();
		public Map<String, Map<String, List<String>>> categoryMap = new Map<String, Map<String, List<String>>>();

		public void putCategoryMap(String key, Map<String, List<String>> val){
			categoryMap.put(key, val);
		}
	}

	
	public class DescribeDataCategoryGroupStructureResults{
		public DescribeDataCategoryGroupStructureMaps getDescribeDataCategoryGroupStructureResults(){

			DescribeDataCategoryGroupStructureMaps ddcgsMaps = new DescribeDataCategoryGroupStructureMaps();

			try {
				List<String> objType = new List<String>{'KnowledgeArticleVersion'};
				List<DataCategoryGroupSobjectTypePair> pairs = new List<DataCategoryGroupSobjectTypePair>();
				for(DescribeDataCategoryGroupResult singleResult : Schema.describeDataCategoryGroups(objType)){
					DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
					p.setSobject(singleResult.getSobject());
					p.setDataCategoryGroupName(singleResult.getName());
					pairs.add(p);
				}

				List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);
				ddcgsMaps.dataCategoryGroupStructureResult = describeCategoryStructureResult;
				for(DescribeDataCategoryGroupStructureResult categoryGroupResult : describeCategoryStructureResult){
			        Map<String, List<String>> tempDataCategoryMap = new Map<String, List<String>>();
					
					for(DataCategory category0 : categoryGroupResult.getTopCategories()) {

						for(DataCategory childCategorie1 : category0.getChildCategories()){
							List<String> tempCategory0List = new List<String>();
							tempCategory0List.add(categoryGroupResult.getLabel());
							tempDataCategoryMap.put(childCategorie1.getName(), tempCategory0List);

							for(DataCategory childCategorie2 : childCategorie1.getChildCategories()){
								List<String> tempCategory1List = new List<String>();
								tempCategory1List.add(categoryGroupResult.getLabel());
								tempCategory1List.add(childCategorie1.getLabel());
								tempCategory1List.add(childCategorie2.getLabel());
								tempDataCategoryMap.put(childCategorie2.getName(), tempCategory1List);

								for(DataCategory childCategorie3 : childCategorie2.getChildCategories()){
									List<String> tempCategory2List = new List<String>();
									tempCategory2List.add(categoryGroupResult.getLabel());
									tempCategory2List.add(childCategorie1.getLabel());
									tempCategory2List.add(childCategorie2.getLabel());
									tempCategory2List.add(childCategorie3.getLabel());
									tempDataCategoryMap.put(childCategorie3.getName(), tempCategory2List);

									for(DataCategory childCategorie4 : childCategorie3.getChildCategories()){
										List<String> tempCategory3List = new List<String>();
										tempCategory3List.add(categoryGroupResult.getLabel());
										tempCategory3List.add(childCategorie1.getLabel());
										tempCategory3List.add(childCategorie2.getLabel());
										tempCategory3List.add(childCategorie3.getLabel());
										tempCategory3List.add(childCategorie4.getLabel());
										tempDataCategoryMap.put(childCategorie4.getName(), tempCategory3List);
									}
								}
							}
						}
					}

					ddcgsMaps.putCategoryMap(categoryGroupResult.getName(), tempDataCategoryMap);

					DataCategory [] toplevelCategories = categoryGroupResult.getTopCategories();
		            List<DataCategory> allCategories = getAllCategories(toplevelCategories);
		            for(DataCategory category : allCategories) {
		        		ddcgsMaps.dataCategoryMap.put(category.getName(), new List<KnowledgeArticleVersion>());
		            }
				}
			} catch (Exception e){
				System.debug('e.getLineNumber():' + e.getLineNumber());
				System.debug('e.getMessage():' + e.getMessage());
			}
	    	return ddcgsMaps;
		}

		private DataCategory[] getAllCategories(DataCategory [] categories){
	    	if(categories.isEmpty()){
	        	return new DataCategory[]{};
	    	} else {
	        	DataCategory [] categoriesClone = categories.clone();
	        	DataCategory category = categoriesClone[0];
		        DataCategory[] allCategories = new DataCategory[]{category};
	    	    categoriesClone.remove(0);
	        	categoriesClone.addAll(category.getChildCategories());
	        	allCategories.addAll(getAllCategories(categoriesClone));
	        	return allCategories;
	    	}
		}
	}
}