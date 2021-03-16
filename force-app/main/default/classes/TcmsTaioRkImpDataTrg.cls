public class TcmsTaioRkImpDataTrg {

    @TestVisible
    private static IHandler mHandler_instane = null;
    public static IHandler get_Handler_instane(Boolean pIsExecuting, Integer pSize){
        if(mHandler_instane == null){
            mHandler_instane = new Handler( TcmsTaioRkImpDataValids.get_ValidationOnBefore_instance() );
        }
        mHandler_instane.set_context(pIsExecuting, pSize);
        return mHandler_instane;
    }

    public interface IHandler {
        void set_context(Boolean pIsExecuting, Integer pSize);
        void onBeforeInsert(List<TcmsTaioRkImpData__c> pNewOnes);
        void onBeforeUpdate(List<TcmsTaioRkImpData__c> pNewOnes, Map<Id, TcmsTaioRkImpData__c> pOldOnes);
    }

    @TestVisible
    private class Handler implements IHandler{
        private TcmsTaioRkImpDataValids.IValidationOnBefore mValidator = null;
        private boolean mIsExecuting = false;
        private integer mBatchSize = 0;

        public Handler(TcmsTaioRkImpDataValids.IValidationOnBefore pValidator){
            this.mValidator = pValidator;
        }

        public void set_context(Boolean pIsExecuting, Integer pSize){
            this.mIsExecuting = pIsExecuting;
            this.mBatchSize = pSize;
        }

        public void onBeforeInsert(List<TcmsTaioRkImpData__c> pNewOnes){
            for(TcmsTaioRkImpData__c aNewOne : pNewOnes){
                mValidator.validate(aNewOne);
            }
        }

        public void onBeforeUpdate(List<TcmsTaioRkImpData__c> pNewOnes, Map<Id, TcmsTaioRkImpData__c> pOldOnes){
            for(TcmsTaioRkImpData__c aNewOne : pNewOnes){
                mValidator.validate(aNewOne);
            }
        }
    }

}