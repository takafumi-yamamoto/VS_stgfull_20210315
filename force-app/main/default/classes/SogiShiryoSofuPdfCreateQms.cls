public class SogiShiryoSofuPdfCreateQms implements IHdlQms{
    public static String msgType = 'SogiShiryoSofuPdfCreateQms';
    private static String rtSimpleYasugoShiryoSeikyuWebFormId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId();
    private static String rtSimpleYasugoEndingnoteWebForm = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoEndingnoteWebForm').getRecordTypeId();

	public class Data{
		public String sogiShiryoSofu_id;
    }

    public void handleQms(Qms__c pQms){
		try{
			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
			new Runner().run( theData.sogiShiryoSofu_id );
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '202010-1804', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
    }

    public class Runner{
        public Runner(){}
		public void run(String pSogiShiryoSofuId){ this.getInsert(pSogiShiryoSofuId); }

		public void getInsert(String pSogiShiryoSofuId){
			SogiShiryoSofu__c theSogiShiryoSofu = (SogiShiryoSofu__c)SobjectsExtension.firstOrNull(
				[
                    SELECT Id, 
                            Name, 
                            InsatsubutsuIchiran__c, 
                            SofuShubetsu__c, 
                            YusoShubetsu__c, 
                            PostalCode__c, 
                            State__c, 
                            City__c, 
                            Street__c, 
                            TaSofubutsu1__c, 
                            TaSofubutsu2__c, 
                            TaSofubutsu3__c, 
                            PamphletYohi__c, 
                            Atena__c, 
                            KasoshikiyoMongon__c, 
                            HosokuSetsumei__c, 
                            OpportunityRef__c, 
                            OpportunityRef__r.StageName, 
                            OpportunityRef__r.ShodanBangoF__c, 
                            OpportunityRef__r.Account.AcvmJizenWariMinDate__c, 
                            OpportunityRef__r.Account.JizenwariKekaKikan__c
					FROM SogiShiryoSofu__c 
                    WHERE Id = :pSogiShiryoSofuId 
				]
            );
            if(theSogiShiryoSofu == null) return;

            try{
                SougiShiryoSakusei.SougiShiryoSakuseiResult result = new SougiShiryoSakusei().postOproPdf(theSogiShiryoSofu);
                theSogiShiryoSofu.SofuShiryoURL__c = OpfcConfs.getConfig().base_url + result.path;
                theSogiShiryoSofu.PassWord__c = result.password;
                update theSogiShiryoSofu;
            }catch(Exception ex){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20201005-2107', 'Web資料請求PDF作成処理')
                        .setSubjectRecordId(theSogiShiryoSofu.Id)
                        .putAttr('Exception', ex.getMessage())
                        .putAttr('LineNumber', '' + ex.getLineNumber())
                        .putAttr('getStackTraceString', ex.getStackTraceString())
                );
            }
        }
    }

    public class QueuingOnShiryoSofuAfterUpdate{
		public void enqueSogiShiryoSofuLocationUpdates(SogiShiryoSofu__c pNewOne){
			INSERT this.getQueues(pNewOne);
		}

		public List<Qms__c> getQueues(SogiShiryoSofu__c pNewOne){

            SogiShiryoSofu__c shiryo = [select Id, 
                                                OpportunityRef__r.CaseRef__r.RecordTypeId, 
                                                OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c 
                                        from SogiShiryoSofu__c 
                                        where Id = :pNewOne.Id];

            List<Qms__c> theQmses = new List<Qms__c>();
            if((shiryo.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoShiryoSeikyuWebFormId && shiryo.OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c == '健在') || 
                shiryo.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoEndingnoteWebForm){
                
                Data theData = new Data();
                theData.sogiShiryoSofu_id = pNewOne.Id;
                theQmses.add(
                    QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build()
                );
            }

			return theQmses;
		}
	}
}