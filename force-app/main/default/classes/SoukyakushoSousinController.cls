public class SoukyakushoSousinController {
    @AuraEnabled
    public static DataContext createSoukyakusho(String recordId) {
        System.debug('recordId : ' + recordId);

        DataContext dc = new DataContext();
        SokyakuSyori sokakusyori = new SokyakuSyori();
        SogSok_Sokyaku__c sogSok_Sokyaku = sokakusyori.get_SogSok_Sokyaku(recordId);

        if(sogSok_Sokyaku == null || String.isBlank(sogSok_Sokyaku.SokyakuShoRef__c)){
            dc.isSuccess = false;
            dc.validMessages = new List<String>{ '送客書が見つかりません！' };
        } else if(String.isBlank(sogSok_Sokyaku.SoukyakuSakiKeiyakuRef__c)){
            dc.isSuccess = false;
            dc.validMessages = new List<String>{ '送客先契約は見つかりません！' };
        } else if(!sogSok_Sokyaku.SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.CanPtWebSokyakuExp__c){
            dc.isSuccess = false;
            dc.validMessages = new List<String>{ 'パートナーWeb送客できません!' };
        } else if(sogSok_Sokyaku.OpportunityRef__r.KakuteibiSyodan__c == null){
            dc.isSuccess = false;
            dc.validMessages = new List<String>{ '確定日が入力されていません!' };
        } else {
            PtWebApi_Soukyakusho_Post client = new PtWebApi_Soukyakusho_Post();
            PtWebApi_Soukyakusho_Post.ReqBody reqBody = client.createReqBody(sogSok_Sokyaku.SokyakuShoRef__c);
            
            dc.validMessages = client.getValidMessages(reqBody.soukyakusho);

            if(dc.validMessages.size() > 0){
                dc.isSuccess = false;
            } else {
                PtWebApi_Soukyakusho_Post.Result postResult = PtWebApi_Soukyakusho_Post.sendRequest(reqBody);
                dc.isSuccess = postResult.isSuccess;
                dc.responseResult = postResult.resBodyRaw;
                dc.statusCode = postResult.statusCode;
                dc.descr = postResult.descr;
                if(dc.isSuccess){
                    sokakusyori.updateSoukyakuZyoho(sogSok_Sokyaku);
                }
            } 
        }

        return dc;
    }


    public class SokyakuSyori {
        public SogSok_Sokyaku__c get_SogSok_Sokyaku(String recordId){
            List<SogSok_Sokyaku__c> theSogSokSokyakus = [select Id, SokyakuShoRef__c, SoukyakuSakiKeiyakuRef__c, SoukyakuSakiKeiyakuRef__r.Teikeisaki__r.CanPtWebSokyakuExp__c, OpportunityRef__c, OpportunityRef__r.KakuteibiSyodan__c From SogSok_Sokyaku__c Where Id = :recordId];
            return theSogSokSokyakus.size() <= 0 ? null : theSogSokSokyakus.get(0);
        }

        public void updateSoukyakuZyoho(SogSok_Sokyaku__c sogSok_Sokyaku){
            List<Sobject> sobjList = new List<Sobject>();
            sogSok_Sokyaku.DocStatus__c = 'Activated';
            sogSok_Sokyaku.SoukyakuStatus__c = 'wait_for_mitsumorisho';
            sogSok_Sokyaku.SoukyakuDateTime__c = Datetime.now();
            sobjList.add(sogSok_Sokyaku);
            sobjList.add(new SogSok_SokyakuSho__c(Id=sogSok_Sokyaku.SokyakuShoRef__c, SoukyakuDate__c=Date.today()));
            update sobjList;
        }
        
    }

    public class DataContext{

        @AuraEnabled public Integer statusCode {
            get { 
                return this.statusCode; 
            }
            set { statusCode = value; }
        }

        @AuraEnabled public String descr {
            get { 
                return this.descr; 
            }
            set { descr = value; }
        }

        @AuraEnabled public String responseResult {
            get { 
                return this.responseResult; 
            }
            set { responseResult = value; }
        }

        @AuraEnabled public List<String> validMessages {
            get { 
                return this.validMessages; 
            }
            set { validMessages = value; }
        }

        @AuraEnabled public Boolean isSuccess {
            get { 
                return this.isSuccess; 
            }
            set { isSuccess = value; }
        }
    }
}