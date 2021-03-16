public class AcrtDrResultQms implements IHdlQms{
    @TestVisible
    private static Boolean raise_err_for_test_coverage = false;

    @TestVisible
    private static AcrtSmsSendErrHistLogr.IErrHistoryLogr mIErrHistoryLogr = AcrtSmsSendErrHistLogr.get_IErrHistoryLogr_instance();

    public static String msgType = 'AcrtDrResultQms';

	public class Data{
        public String AcrtDrTack_Id;
        public String AcrtDrTack_MsgType;
        public String Result_Code;
        public Boolean isExpired;
        public Boolean isDeliveryFailed(){
            return
            this.isExpired || 
            this.Result_Code == AcrtApiSmsDr.result_code_undelivered ||
            this.Result_Code == AcrtApiSmsDr.result_code_unknown_subscriber;
        }
    }

    private static AcrtDrResultHdlrPvdr.IAcrtDrResultHdlrPvdr mHdlrProvider = new AcrtDrResultHdlrPvdr.Provider();

    public void handleQms(Qms__c pQms){
		try{
			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
    
            if(theData.isDeliveryFailed()){
                mIErrHistoryLogr.updateLogSmsHistory(theData.AcrtDrTack_Id);
            }

            this.dispatchTohandler(theData, pQms.Id);
            
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20200630-1554', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
    }

    private void dispatchTohandler(Data pData, String pQmsId){
        Data thedata = pData;

        AcrtDrResultHdlrPvdr.ResolveHandlerResult thePvdrRes = mHdlrProvider.resolveHandler(theData.AcrtDrTack_MsgType);
        if(thePvdrRes.handler != null){
            try{
                thePvdrRes.handler.handleAcrtDrResult(theData);
                if(raise_err_for_test_coverage) throw new Exceptions.AnException();
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200806-1303', msgType, theData.AcrtDrTack_MsgType)
                        .setSubjectRecordId(pQmsId)
                        .putAttr('Exception', ex.getMessage())
                        .putAttr('LineNumber', '' + ex.getLineNumber())
                        .putAttr('getStackTraceString', ex.getStackTraceString())
                        .putAttr('theData.AcrtDrTack_Id', theData.AcrtDrTack_Id )
                        .putAttr('theData.AcrtDrTack_MsgType', theData.AcrtDrTack_MsgType )
                );
                throw ex;
            }
        }
    }

    public static Qms__c createQms(String pAcrtDrTack_Id, String pAcrtDrTack_MsgType, String pAcrtApiSmsDr_Result_Code, Boolean pIsExpired){
        Data theData = new Data();
        theData.AcrtDrTack_Id = pAcrtDrTack_Id;
        theData.AcrtDrTack_MsgType = pAcrtDrTack_MsgType;
        theData.Result_Code = pAcrtApiSmsDr_Result_Code;
        theData.isExpired = pIsExpired;
        return QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build();
    }
}