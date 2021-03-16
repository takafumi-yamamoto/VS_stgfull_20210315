public class OpFcReq {

    public class Req{
        private String mCID = '';
        public String CID { get{ return this.mCID; } }
        public Req setCid(String pValue){ this.mCID = pValue; return this; }

        private String mUPW = '';
        public String UPW { get{ return this.mUPW; } }
        public Req setUpw(String pValue){ this.mUPW = pValue; return this; }

        private String mUID = '';
        public String UID { get{ return this.mUID; } }
        public Req setUID(String pValue){ this.mUID = pValue; return this; }

        private Boolean mFontEmb = false;
        public Boolean FontEmb { get{ return this.mFontEmb; } }
        public Req setFontEmb(Boolean pValue){ this.mFontEmb = pValue; return this; }

        private String mOproPdfPassword = '';
        public String OproPdfPassword { get{ return this.mOproPdfPassword; } }
        public Req setOproPdfPassword(String pValue){ this.mOproPdfPassword = pValue; return this; }

        private Boolean mAddTimeStamp = true;
        public Boolean AddTimeStamp { get{ return this.mAddTimeStamp; } }
        public Req setAddTimeStamp(Boolean pValue){ this.mAddTimeStamp = pValue; return this; }

        private List<TemplateData> mTemplateDatas = new List<TemplateData>();
        public List<TemplateData> TemplateDatas { get{ return this.TemplateDatas; } }
        public Req addTemplateDatas( List<TemplateData> pTemplateDatas ){
            this.mTemplateDatas.addAll(pTemplateDatas);
            return this;
        }

        public String getParamString(){
            String theParamString = 'OP=dlp';
            theParamString += '&CID=' + this.mCID;
            theParamString += '&UPW=' + this.mUPW;
            theParamString += '&UID=' + this.mUID;
            theParamString += '&FE=' + (this.mFontEmb ? 'true' : 'false');

            Integer theTemplateDataCount = 0;
            for(TemplateData aTemplateData : this.mTemplateDatas){
                theTemplateDataCount++;
                String theTemplateDataKey = 'TP' + String.valueOf(theTemplateDataCount);
                theParamString += '&' + theTemplateDataKey + '=' + aTemplateData.getTemplateName_encoded();

                Integer theDatasetCount = 0;
                for(DataSet aDataset : aTemplateData.datasets){
                    theDatasetCount++;
                    String theDatasetKey = 'TD' + String.valueOf(theTemplateDataCount) + '_' + String.valueOf(theDatasetCount);
                    theParamString += '&' + theDatasetKey + '=' + aDataset.getEncoded( this.OproPdfPassword );
                }
            }
            if(this.mAddTimeStamp) theParamString = theParamString + '&time=' + Datetime.now().format('yyyyMMddHHmmssSSS');
            return theParamString;
        }
    }

    public class TemplateData {
        private String mTemplateName;
        public String TemplateName { get{ return this.mTemplateName; } }
        public TemplateData setTemplateName(String pValue){ this.mTemplateName = pValue; return this; }
        public String getTemplateName_encoded(){
            return EncodingUtil.urlEncode(this.mTemplateName, 'UTF-8');
        }

        private List<DataSet> mDataSet = new List<DataSet>();
        public List<DataSet> datasets { get{ return this.mDataSet; } }
        public TemplateData addDatasets(List<DataSet> pDataSets){
            this.mDataSet.addAll(pDataSets);
            return this;
        }
    }

    public class DataSet{
        private List<CsvRow> mCsvRows = new List<CsvRow>();

        private Boolean mFirstRowIsHeader = true;
        public Boolean FirstRowIsHeader = true;
        public DataSet setFirstRowIsHeader(Boolean pValue){ this.FirstRowIsHeader = pValue; return this; }

        public DataSet addRows( List<CsvRow> pRows){
            this.mCsvRows.addAll(pRows);
            return this;
        }
        public String getEncoded( String pOproPdfPassword ){
            List<String> theRows_encoded = new List<String>();
            Integer theRowCount = 0;
            for(CsvRow aRow : this.mCsvRows){
                theRowCount++;
                Boolean isHeaderRow = this.FirstRowIsHeader && theRowCount == 1;
                theRows_encoded.add( aRow.getEncoded(isHeaderRow, pOproPdfPassword) );
            }
            String theCrLf_encoded = '%0D%0A';
    
            String aDatasetValue_encoded = String.join(theRows_encoded, theCrLf_encoded);
            return aDatasetValue_encoded;
        }
    }

    public class CsvRow{
        private List<String> theColumnValues = new List<String>();
        public CsvRow setColumnValues( List<String> pColumnValues ){
            this.theColumnValues = pColumnValues;
            return this;
        }

        public String getEncoded(Boolean pIsHeaerRow, String pOproPdfPassword){
            List<String> theValues_encoded = new List<String>();
            for(String aValue : this.theColumnValues){

                String aValue_encoded = String.isBlank(aValue) ? '' : aValue;
                aValue_encoded = aValue_encoded.replace('"', '""');
                aValue_encoded = '"' + aValue_encoded + '"';
                aValue_encoded = EncodingUtil.urlEncode(aValue_encoded, 'UTF-8');
                theValues_encoded.add( aValue_encoded );
            }

            if( !String.isBlank(pOproPdfPassword) ){
                if( pIsHeaerRow ){
                    theValues_encoded.add( 'opro_pdf_password' );
                }else{
                    theValues_encoded.add( EncodingUtil.urlEncode(pOproPdfPassword, 'UTF-8') );
                }
                
            }
            String theCommma_encoded = '%2C';
    
            String aRowValue_encoded = String.join(theValues_encoded, theCommma_encoded);
            return aRowValue_encoded;
        }
    }
}