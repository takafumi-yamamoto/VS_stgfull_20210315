/**
* 決済売上確定
*/
public class UriageKakuteiProcessor implements Queueable, Database.AllowsCallouts {
	private OkyakusamaSeikyuMeisai__c seikyuMeisai;

	public UriageKakuteiProcessor(OkyakusamaSeikyuMeisai__c seikyuMeisai){

		this.seikyuMeisai = [ SELECT Id, SeikyuBango__c,OpportunityRef__r.Utiagebi__c,
									( Select id, OpportunityRef__r.Utiagebi__c From SeikyuKos__r )
							  FROM OkyakusamaSeikyuMeisai__c
							  WHERE SeikyuStatus__c = '決済済'
							  AND SeikyuHouhou__c = 'gmo_credit'
							  AND SeikyuOya__c = null
							  AND IsDeleted = false
							  AND Id = :seikyuMeisai.Id
			];
	}

    public void execute(QueueableContext context) {
        try {
            if(canProcess(seikyuMeisai)) uriagekakutei(seikyuMeisai);
        }
        catch (Exception ex) {
            Loggings.Level level = Loggings.Level.Error;
            String title = '売上確定バッチ処理中にエラーException';
            Loggings.writeLog(
               Loggings.createLogEntry(level, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'CoreKessai.UriageKakuteiProcessor', title)
                   .putAttr('OkyakusamaSeikyuMeisai__c_id', seikyuMeisai.id)
                   .putAttr('SeikyuBango', seikyuMeisai.SeikyuBango__c)
                   .putAttr('Exception', ex.getMessage())
                   .putAttr('Description', 'UriageKakuteiProcessor execute')
           );
        }
    }

    /**
    * 売上日 <= 今日
    */
    private Boolean canProcess(OkyakusamaSeikyuMeisai__c seikyuMeisai){
        List<date> allDates = new List<date>();
        if(seikyuMeisai.OpportunityRef__r.Utiagebi__c!=null){
            allDates.add(seikyuMeisai.OpportunityRef__r.Utiagebi__c);
        }
        for(OkyakusamaSeikyuMeisai__c subSeikyuMeisai : seikyuMeisai.SeikyuKos__r){
            Date date1 = subSeikyuMeisai.OpportunityRef__r.Utiagebi__c;
            if(date1 != null){
                allDates.add(date1);
            }
        }
        if(allDates.size() > 0){
            allDates.sort();
            Date maxDate = allDates[Alldates.size()-1];
            Date baseDate = date.today();
            return maxDate <= baseDate;
        } else{
            return false;
        }
    }

    private void uriagekakutei(OkyakusamaSeikyuMeisai__c seikyuMeisai){

        String url = RsCoreApi_Configs.getConfig().Endpoint__c + '/payments/seikyuBango/' + seikyuMeisai.SeikyuBango__c + '/sales';
        String requestParams = getUriagekakuteiJsonStr(seikyuMeisai);
        RsCoreApi_PaymentClient client = new RsCoreApi_PaymentClient(url, requestParams);
        RsCoreApi_Util.doPost(client);

        if(client.getIsSuccess()){
            try {
                UriagekakuteiResult uriagekakuteiResult = (UriagekakuteiResult) JSON.deserialize(client.result, UriagekakuteiResult.class);
                updateOkyakusamaSeikyuMeisai(seikyuMeisai, uriagekakuteiResult);
            }
            catch (Exception ex) {
                Loggings.Level level = Loggings.Level.Error;
                String title = '売上確定バッチ処理中にエラーException';
                Loggings.writeLog(
                   Loggings.createLogEntry(level, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'CoreKessai.UriageKakuteiProcessor', title)
                       .putAttr('OkyakusamaSeikyuMeisai__c_id', seikyuMeisai.id)
                       .putAttr('SeikyuBango', seikyuMeisai.SeikyuBango__c)
                       .putAttr('Endpoint', url)
                       .putAttr('ResponseCode', client.code + '')
                       .putAttr('ResponseMsg', client.result)
                       .putAttr('Exception', ex.getMessage())
                   	   .putAttr('Description', '@updateOkyakusamaSeikyuMeisai')
               );

            }
        }

        Loggings.Level level = client.getIsSuccess() ? Loggings.Level.Info : Loggings.Level.Error;
        String title = client.getIsSuccess() ? '売上確定バッチ処理中成功' : '売上確定バッチ処理中にエラー';
        List<String> errorList = new List<String>();
        if(!client.getIsSuccess()){
        	errorList.add(client.getCoreErrorMsg());
        }

        Loggings.writeLog(
           Loggings.createLogEntry(level, Datetime.now().format('yyyyMMdd-HHmm-ss'), 'CoreKessai.UriageKakuteiProcessor', title)
               .putAttr('OkyakusamaSeikyuMeisai__c_id', seikyuMeisai.id)
               .putAttr('SeikyuBango', seikyuMeisai.SeikyuBango__c)
               .putAttr('Endpoint', url)
               .putAttr('ResponseCode', client.code + '')
               .putAttr('ResponseMsg', client.result)
               .putAttr('ErrorMsg', String.join(errorList, '\n'))
               .putAttr('Description', 'From Core Response')
       );

    }

    public class SalesResult {
        public String salesDate;
        public String serviceName;

        public Date getUriageKakuteiBi(){
            Date tmpDate;
            if(String.isNotBlank(salesDate)){
                String year = salesDate.substring(0, 4);
                String month = salesDate.substring(4, 6);
                String day = salesDate.substring(6, 8);
                tmpDate = Date.valueOf(year + '-' + month + '-' + day);
            }
            return tmpDate;
        }
    }


    public class UriagekakuteiResult {
        public List<SalesResult> salesResults;
    }

    private void updateOkyakusamaSeikyuMeisai(OkyakusamaSeikyuMeisai__c seikyuMeisai, UriagekakuteiResult uriagekakuteiResult){
        Date uriageKakuteiBi = uriagekakuteiResult.salesResults[0].getUriageKakuteiBi();

        List<OkyakusamaSeikyuMeisai__c> okyakusamaSeikyuMeisaiList = new List<OkyakusamaSeikyuMeisai__c>();
        okyakusamaSeikyuMeisaiList.add(new OkyakusamaSeikyuMeisai__c(Id=seikyuMeisai.Id, SeikyuStatus__c = '売上確定済', UriageKakuteiBi__c=uriageKakuteiBi,isSkipCrudPlicy__c = true));
        for(OkyakusamaSeikyuMeisai__c subSeikyuMeisai : seikyuMeisai.SeikyuKos__r){
            okyakusamaSeikyuMeisaiList.add(new OkyakusamaSeikyuMeisai__c(Id=subSeikyuMeisai.Id, SeikyuStatus__c = '売上確定済', UriageKakuteiBi__c=uriageKakuteiBi,isSkipCrudPlicy__c = true));
        }
        LocAfTesuryoSeikyuLineCalc.turnOffLockRule();
        KeirSimeLocks.turnOffLockRule();
        update okyakusamaSeikyuMeisaiList;
        KeirSimeLocks.turnOnLockRule();
        LocAfTesuryoSeikyuLineCalc.turnOnLockRule();
    }


    private String getUriagekakuteiJsonStr(OkyakusamaSeikyuMeisai__c seikyuMeisai){
        Map<string, string> info = new Map<string, string>();
        info.put('seikyuBango', seikyuMeisai.SeikyuBango__c);
        System.debug('seikyuMeisai.SeikyuBango__c >>>' + seikyuMeisai.SeikyuBango__c);
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeObject(info);
        System.debug('gen.getAsString() >>>' + gen.getAsString());
        return gen.getAsString();
    }


}