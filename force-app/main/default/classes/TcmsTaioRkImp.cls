public class TcmsTaioRkImp {

    public static ITaioRerekiImporter get_ITaioRerekiImporter_instance(){
        return new TaioRerekiImporter(
            TcmsTaioRkImpOpp.get_IOppCreator_instance(),
            TcmsTaioRkImpSogiShiryo.get_ISogiShiryoSofuCreator_instance(),
            new TcmsTaioRkImpDataSelector()
        );
    }

    public interface ITaioRerekiImporter {
        void run_import(String pTcmsTaioRkImpDataId);
    }
    public class TaioRerekiImporter implements ITaioRerekiImporter{

        private TcmsTaioRkImpOpp.IOppCreator m_IOppCreator;
        private TcmsTaioRkImpSogiShiryo.ISogiShiryoSofuCreator m_ISogiShiryoSofuCreator;
        private TcmsTaioRkImpDataSelector m_TcmsTaioRkImpDataSelector;
        public TaioRerekiImporter(
            TcmsTaioRkImpOpp.IOppCreator pIOppCreator,
            TcmsTaioRkImpSogiShiryo.ISogiShiryoSofuCreator pISogiShiryoSofuCreator,
            TcmsTaioRkImpDataSelector pTcmsTaioRkImpDataSelector
        ){
            this.m_IOppCreator = pIOppCreator;
            this.m_ISogiShiryoSofuCreator = pISogiShiryoSofuCreator;
            this.m_TcmsTaioRkImpDataSelector = pTcmsTaioRkImpDataSelector;
        }

        public void run_import(String pTcmsTaioRkImpDataId){
            try{
                String theOppId = this.import(pTcmsTaioRkImpDataId);
                UPDATE new TcmsTaioRkImpData__c( Id = pTcmsTaioRkImpDataId, Shori_Status__c = 'Completed', OppRef__c = theOppId );
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200929-1914', 'TcmsTaioRkImp.TaioRerekiImporter.run_import')
                    .setSubjectRecordId(pTcmsTaioRkImpDataId)
                    .putAttr('ex.getTypeName()', ex.getTypeName() )
                    .putAttr('ex.getMessage()', ex.getMessage())
                    .putAttr('ex.getLineNumber()', '' + ex.getLineNumber())
                    .putAttr('ex.getStackTraceString()', ex.getStackTraceString())
                );
                UPDATE new TcmsTaioRkImpData__c( Id = pTcmsTaioRkImpDataId, Shori_Status__c = 'Failed' );
            }
        }

        public String import(String pTcmsTaioRkImpDataId){
            TcmsTaioRkImpData__c theTcmsTaioRkImpData = this.m_TcmsTaioRkImpDataSelector.selectTcmsTaioRkImpData(pTcmsTaioRkImpDataId);
            if(theTcmsTaioRkImpData == null) return null;
            String the_opp_id = this.m_IOppCreator.createOpp(theTcmsTaioRkImpData);
            if( !String.isBlank(the_opp_id) ){
                this.m_ISogiShiryoSofuCreator.createSogiShiryoSofu(the_opp_id, theTcmsTaioRkImpData);
            }
            return the_opp_id;
        }
    }

    public class TcmsTaioRkImpDataSelector{
        public TcmsTaioRkImpData__c selectTcmsTaioRkImpData(String pTcmsTaioRkImpDataId){
            return (TcmsTaioRkImpData__c)SobjectsExtension.firstOrNull(
                [
                    SELECT Id, TcmsSeqNo__c, ToiawaseDt__c, Kanryo_Shubetsu__c, SiryoKibo__c, SmsPermission__c,

                    Sodansha_Sei__c, Sodansha_Mei__c,
                    Sodansha_Sei_Kana__c, Sodansha_Mei_Kana__c,
                    Sodansha_Phone__c, Sodansha_Mobile__c,

                    Sodansha_Addr_ZipCode__c, Sodansha_Addr_State__c, Sodansha_Addr_City__c, Sodansha_Addr_Street__c, Sodansha_Addr_Room__c,
                    
                    Sofusaki_Atena__c, 
                    Sofusaki_ZipCode__c, Sofusaki_State__c, Sofusaki_City__c, Sofusaki_Street__c, Sofusaki_Room__c,

                    TaishoshaUmu__c, Taishosha_Zokugara_From_Sodansha__c,
                    Taishosha_Joutai__c, Taishosha_KyojuKeitai__c, Taishosha_Yomei__c,
                    Taishosha_Jumin_State__c, Taishosha_Jumin_City__c, 

                    SogiKiboAreaCode__c,
                    SogiType1__c, SogiType2__c, 
                    AnchiSaki__c,
                    SoryoTehaiUmu__c, BodaijiUmu__c, 

                    Comment__c, HikitsugiJiko__c
                    
                    FROM TcmsTaioRkImpData__c
                    WHERE Id = :pTcmsTaioRkImpDataId
                    LIMIT 1
                ]
                );
        }
    }
}