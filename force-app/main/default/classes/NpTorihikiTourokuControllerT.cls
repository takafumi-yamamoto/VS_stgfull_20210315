@isTest
private class NpTorihikiTourokuControllerT {
	
	@isTest static void test_method_one() {
		// Implement test code
		NpTorihikiTourokuController c = new NpTorihikiTourokuController();
		c.doClick();
	}


	@isTest static void test_method_2() {

		//  test PaginationController
		PaginationController paginationController = new PaginationController();

		List<Opportunity> controllerSObjects = new List<Opportunity>();
		//  test reloadPagination
		paginationController.reloadPagination(controllerSObjects);

		//  test getCurrentRecords
		List<SObject> resultGetCurrentRecords = paginationController.getCurrentRecords();

		//  test first
		paginationController.first();

		//  test previous
		paginationController.previous();

		//  test next
		paginationController.next();

		//  test last
		paginationController.last();

		//  test getHasPrevious
		Boolean resultGetHasPrevious = paginationController.getHasPrevious();

		//  test getHasNext
		Boolean resultGetHasNext = paginationController.getHasNext();

		//  test getResultSize
		Integer resultGetResultSize = paginationController.getResultSize();

		//  test getPageCount
		Integer resultGetPageCount = paginationController.getPageCount();

		//  test getPageNumber
		Integer resultGetPageNumber = paginationController.getPageNumber();

		Integer pageNumber = 10;
		//  test setPageNumber
		paginationController.setPageNumber(pageNumber);

		//  test getRenderResults
		Boolean resultGetRenderResults = paginationController.getRenderResults();

		//  test save
		PageReference resultSave = paginationController.save();

		//  test cancel
		PageReference resultCancel = paginationController.cancel();

		//  test getController
		PaginationController resultGetController = paginationController.getController();

	}

	
}