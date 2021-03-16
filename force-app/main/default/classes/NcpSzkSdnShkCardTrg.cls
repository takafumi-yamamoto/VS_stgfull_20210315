public class NcpSzkSdnShkCardTrg {

    @TestVisible
    private static IHandler mHandler_instane = null;
    public static IHandler get_Handler_instane(Boolean pIsExecuting, Integer pSize){
        if(mHandler_instane == null){
            mHandler_instane = new Handler();
        }
        mHandler_instane.set_context(pIsExecuting, pSize);
        return mHandler_instane;
    }

    public interface IHandler {
        void set_context(Boolean pIsExecuting, Integer pSize);
        void on_before_insert(List<NcpSzkSdnShkCard__c> pNewOnes);
    }

    @TestVisible
    private class Handler implements IHandler{
        private boolean mIsExecuting = false;
        private integer mBatchSize = 0;

        public Handler(){}

        public void set_context(Boolean pIsExecuting, Integer pSize){
            this.mIsExecuting = pIsExecuting;
            this.mBatchSize = pSize;
        }

        public void on_before_insert(List<NcpSzkSdnShkCard__c> pNewOnes){
            get_IRecordKyeAssigner_instance().assignIfNotAssigned(pNewOnes);
        }
    }

    @TestVisible
    private static NcpSzkSdnShkCardKey.IRecordKyeAssigner m_IRecordKyeAssigner;
    private static NcpSzkSdnShkCardKey.IRecordKyeAssigner get_IRecordKyeAssigner_instance(){
        if( m_IRecordKyeAssigner == null ){ m_IRecordKyeAssigner = NcpSzkSdnShkCardKey.get_IRecordKyeAssigner_instance(); }
        return m_IRecordKyeAssigner;
    }
}