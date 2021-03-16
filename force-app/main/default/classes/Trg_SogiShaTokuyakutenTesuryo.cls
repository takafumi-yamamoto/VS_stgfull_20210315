public class Trg_SogiShaTokuyakutenTesuryo {

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
        void on_after_insert(List<SogiShaTokuyakutenTesuryo__c> p_new_ones);
        void on_after_update(List<SogiShaTokuyakutenTesuryo__c> p_new_ones, Map<Id,SogiShaTokuyakutenTesuryo__c> p_old_ones);
        void on_after_delete(Map<Id,SogiShaTokuyakutenTesuryo__c> p_old_ones);
    }

    private class Handler implements IHandler{
        private boolean mIsExecuting = false;
        private integer mBatchSize = 0;

        public void set_context(Boolean pIsExecuting, Integer pSize){
            this.mIsExecuting = pIsExecuting;
            this.mBatchSize = pSize;
        }

        public void on_after_insert(List<SogiShaTokuyakutenTesuryo__c> p_new_ones){
            get_ILatestUpdater_instance().on_SogiShaTokuyakutenTesuryo_after_Insert(p_new_ones);
        }
        public void on_after_update(List<SogiShaTokuyakutenTesuryo__c> p_new_ones, Map<Id,SogiShaTokuyakutenTesuryo__c> p_old_ones){
            get_ILatestUpdater_instance().on_SogiShaTokuyakutenTesuryo_after_update(p_new_ones, p_old_ones);
        }
        public void on_after_delete(Map<Id,SogiShaTokuyakutenTesuryo__c> p_old_ones){
            get_ILatestUpdater_instance().on_SogiShaTokuyakutenTesuryo_after_delete(p_old_ones);
        }
    }

    @TestVisible
    private static SogiTokuyakutenTesuryoLatest.ILatestUpdater m_ILatestUpdater;
    private static SogiTokuyakutenTesuryoLatest.ILatestUpdater get_ILatestUpdater_instance(){
        if(m_ILatestUpdater == null){ m_ILatestUpdater = SogiTokuyakutenTesuryoLatest.get_ILatestUpdater_instance(); }
        return m_ILatestUpdater;
    }
}