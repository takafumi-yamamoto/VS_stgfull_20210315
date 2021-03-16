public class KrYsYosinTrg {

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
        void onBeforeInsert(List<KrYsYosin__c> pNewOnes);
        void onBeforeUpdate(List<KrYsYosin__c> pNewOnes, Map<Id, KrYsYosin__c> pOldOnes);
    }

    @TestVisible
    private class Handler implements IHandler{
        private boolean mIsExecuting = false;
        private integer mBatchSize = 0;

        public void set_context(Boolean pIsExecuting, Integer pSize){
            this.mIsExecuting = pIsExecuting;
            this.mBatchSize = pSize;
        }

        public void onBeforeInsert(List<KrYsYosin__c> pNewOnes){
            get_IYosinHantei_instance().on_KrysYosin_before_insert(pNewOnes);
        }
        public void onBeforeUpdate(List<KrYsYosin__c> pNewOnes, Map<Id, KrYsYosin__c> pOldOnes){
            get_IYosinHantei_instance().on_KrysYosin_before_update(pNewOnes, pOldOnes);
        }
    }

    @TestVisible
    private static KrYsYosinHantei.IYosinHantei IYosinHantei_instance;
    private static KrYsYosinHantei.IYosinHantei get_IYosinHantei_instance(){
        if( IYosinHantei_instance == null ){ IYosinHantei_instance = KrYsYosinHantei.get_IYosinHantei_instance(); }
        return IYosinHantei_instance;
    }
}