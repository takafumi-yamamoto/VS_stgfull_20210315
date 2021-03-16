public class AcrtDrResultHdlr {

    public interface IAcrtDrResultHdlr{
        void handleAcrtDrResult(AcrtDrResultQms.Data pData);
    }
    
    public class SampleHdlr implements IAcrtDrResultHdlr{
        public void handleAcrtDrResult(AcrtDrResultQms.Data pData){return;}
    }
}