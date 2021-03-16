public class KrYsFreUnSetlDlImpJobTrg {

    @TestVisible
    private static IHandler mHandler_instane = null;
    public static IHandler get_Handler_instane(Boolean pIsExecuting, Integer pSize){
        if(mHandler_instane == null){
            mHandler_instane = new Handler(
                KrYsFreUnSetlDlImp.get_IImportJob_instance()
            );
        }
        mHandler_instane.set_context(pIsExecuting, pSize);
        return mHandler_instane;
    }

    public interface IHandler {
        void set_context(Boolean pIsExecuting, Integer pSize);
        void onAfterInsert(List<KrYsFreUnSetlDlImpJob__c> pNewOnes);
    }

    @TestVisible
    private class Handler implements IHandler{
        private boolean mIsExecuting = false;
        private integer mBatchSize = 0;
        private KrYsFreUnSetlDlImp.IImportJob m_IImportJob;

        public Handler(KrYsFreUnSetlDlImp.IImportJob p_IImportJob){
            this.m_IImportJob = p_IImportJob;
        }
        public void set_context(Boolean pIsExecuting, Integer pSize){
            this.mIsExecuting = pIsExecuting;
            this.mBatchSize = pSize;
        }

        public void onAfterInsert(List<KrYsFreUnSetlDlImpJob__c> pNewOnes){
            this.m_IImportJob.set_KrYsFreUnsetlDlId(pNewOnes.get(0).Id).startAsync();
        }
    }
}