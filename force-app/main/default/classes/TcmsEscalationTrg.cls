public class TcmsEscalationTrg {

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
        void onAfterInsert(List<TcmsEscalation__c> pNewOnes);
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

        public void onAfterInsert(List<TcmsEscalation__c> pNewOnes){

            List<MailAlert__c> the_MailAlerts = new List<MailAlert__c>();
            TcmsNewEscalationMail theMailBuilder = new TcmsNewEscalationMail();
            for(TcmsEscalation__c aNewOne : pNewOnes){
                the_MailAlerts.add(
                    theMailBuilder.createMail(
                        new TcmsNewEscalationMail.Req().set_TcmsEscalationId(aNewOne.Id)
                    )
                );
            }
            INSERT the_MailAlerts;

        }
    }
}