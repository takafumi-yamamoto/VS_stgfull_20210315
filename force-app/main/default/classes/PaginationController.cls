public virtual class PaginationController {
	private ApexPages.StandardSetController controller;
    private static final Integer DEFALUT_PAGE_SIZE = 20;

    //** constructor
    public PaginationController() {
    }

    //** search methods
    public void reloadPagination(List<sObject> controllerSObjects) {
        // reboot standard set controller
        this.controller = new ApexPages.StandardSetController(controllerSObjects);
        // reset pageSize
        this.controller.setPageSize(this.pageSize);
    }


    //** pageable methods
    // get records on current page 
    public List<SObject> getCurrentRecords() {
        return controller.getRecords();
    }

    public void first() {
        controller.first();
    }

    public void previous() {
        controller.previous();
    }

    public void next() {
        controller.next();
    }

    public void last() {
        controller.last();
    }

    public Boolean getHasPrevious() {
        return controller.getHasPrevious();
    }

    public Boolean getHasNext() {
        return controller.getHasNext();
    }

    public Integer getResultSize() {
        return controller.getResultSize();
    }

    public Integer getPageCount() {
        Integer resultSize = getResultSize();

        Integer oddRecordCount = Math.mod(resultSize, pageSize);
        return ((resultSize - oddRecordCount) / pageSize) + (oddRecordCount > 0 ? 1 : 0);
    }

    public Integer getPageNumber() {
        return controller.getPageNumber();
    }

    public void setPageNumber(Integer pageNumber) {
        controller.setPageNumber(pageNumber);
    }

    public Integer pageSize {
        get {
            if(pageSize == null){
                pageSize = DEFALUT_PAGE_SIZE; 
            }
            return pageSize;
        }
        set {
            pageSize = value;
        }
    }

    public Boolean getRenderResults() {
        return (getResultSize() > 0);
    }

    //** update methods
    public virtual PageReference save() {
        return controller.save();
    }

    public virtual PageReference cancel() {
        return controller.cancel();
    }

    //** pass reference to PaginationController component 
    public PaginationController getController () {
        return this;
    }
}