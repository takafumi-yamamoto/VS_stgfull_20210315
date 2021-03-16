public class SzsdPubCardCmdTrg {

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
        void on_before_insert(List<SzsdPubCardCmd__c> pNewOnes);
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

        public void on_before_insert(List<SzsdPubCardCmd__c> pNewOnes){
            for(SzsdPubCardCmd__c aNewOne : pNewOnes){
                if( !String.isBlank(aNewOne.ShodanBango__c) && aNewOne.ShodanBango__c.length() < 7 ){
                    aNewOne.ShodanBango__c = ('0000000' + aNewOne.ShodanBango__c).right(7);
                }
            }
        }
    }
}