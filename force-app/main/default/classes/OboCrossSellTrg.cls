public class OboCrossSellTrg {

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
        void onBeforeInsert(List<OboCrossSell__c> pNewOnes);
        void onBeforeUpdate(List<OboCrossSell__c> pNewOnes, Map<Id, OboCrossSell__c> pOldOnes);
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

        public void onBeforeInsert(List<OboCrossSell__c> pNewOnes){

            for(OboCrossSell__c aNewOne : pNewOnes){
                Boolean is_order_date_missing = aNewOne.CrossSellStatus__c == '受注' && aNewOne.OrderDate__c == null;
                if(is_order_date_missing) aNewOne.addError('受注日未注力;');
            }

        }
        public void onBeforeUpdate(List<OboCrossSell__c> pNewOnes, Map<Id, OboCrossSell__c> pOldOnes){

            for(OboCrossSell__c aNewOne : pNewOnes){
                OboCrossSell__c aOldOne = pOldOnes.get(aNewOne.Id);

                Boolean to_check_order_date = 
                    aNewOne.CrossSellStatus__c != aOldOne.CrossSellStatus__c
                    ||
                    aNewOne.OrderDate__c != aOldOne.OrderDate__c;
                if(to_check_order_date){
                    Boolean is_order_date_missing = aNewOne.CrossSellStatus__c == '受注' && aNewOne.OrderDate__c == null;
                    if(is_order_date_missing) aNewOne.addError('受注日未注力;');
                }
            }
        }
    }
}