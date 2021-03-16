public class oboStSelProfSvcRankOrdUpd implements Schedulable{

	public void execute(SchedulableContext SC) {
		try{
			this.run();
		}catch(Exception e){
	        Loggings.writeLog(
	            Loggings.createLogEntry(Loggings.Level.Error, '20190418-1618', 'oboStSelProfSvcRankOrdUpd.execute')
	                .putAttr('e.getMessage()',e.getMessage())
	        );
		}
		
	}
	public void run() {

        Datetime theNow = Datetime.now();
        //theNow = Datetime.newInstance(2018,7,15,23,59,59);
        
        OboStSelProf__c[] theOboStSelProfs = [
        	SELECT Id, TargetAvgTesuryo__c
        	FROM oboStSelProf__c
        	LIMIT 1
        ];
        OboStSelProf__c theOboStSelProf = theOboStSelProfs.size() > 0 ? theOboStSelProfs.get(0) : new OboStSelProf__c();
        Decimal theTargetAvgTesuryo = theOboStSelProf.TargetAvgTesuryo__c == null ? 0 : theOboStSelProf.TargetAvgTesuryo__c;

        Datetime theStartDate = theNow.addDays(-3);
        Datetime theEndDate = theNow.addDays(-1);
        Datetime theStartDateTime 
            = Datetime.newInstance(theStartDate.year(),theStartDate.month(),theStartDate.day(),0,0,0);
        Datetime theEndDateTime 
            = Datetime.newInstance(theEndDate.year(),theEndDate.month(),theEndDate.day(),23,59,59);

        AggregateResult[] theAggregateResults = 
        [
            SELECT AVG(UriageGakuPartnerExp__c),Count(Id)
            FROM Opportunity
            WHERE KakuteibiSyodan__c >= :theStartDateTime 
            AND KakuteibiSyodan__c <= :theEndDateTime
            AND RecordType.DeveloperName = 'Obosanbin'
            AND UriageGakuPartnerExp__c != 0
            AND StageName NOT IN ('失注','キャンセル','除外')
        ];
        AggregateResult theAggregateResult = theAggregateResults.get(0);

        Decimal theAvgTesuryo = theAggregateResult.get('expr0') == null ? 0.0 : Math.Round( (Decimal)theAggregateResult.get('expr0') );
        Decimal theCount = (Decimal)theAggregateResult.get('expr1');

        Decimal theAvgTesuryoGap = 0.0;
        Decimal theAvgTesruryoGapRate = 0.0;
        if(theCount > 0){
	        theAvgTesuryoGap = theAvgTesuryo - theTargetAvgTesuryo;
	        theAvgTesruryoGapRate = theTargetAvgTesuryo == 0.0 ? 0.0 : Math.Round(theAvgTesuryoGap / theTargetAvgTesuryo * 100.0) /100.0;        	
        }

        String theSvcRankOrder = 'D-C-E-B-A';
        if(theAvgTesruryoGapRate >= 0.05) theSvcRankOrder = 'A-B-C-D-E';
        if(theAvgTesruryoGapRate > 0 && theAvgTesruryoGapRate < 0.05) theSvcRankOrder = 'B-A-C-D-E';
        if(theAvgTesruryoGapRate < 0 && theAvgTesruryoGapRate > -0.05) theSvcRankOrder = 'D-C-E-B-A';
        if(theAvgTesruryoGapRate <= -0.05) theSvcRankOrder = 'D-E-C-B-A';

        theOboStSelProf.MeasureExecDatetime__c = Datetime.now();
        theOboStSelProf.MeasureDateTimeFrom__c = theStartDateTime;
        theOboStSelProf.MeasureDateTimeTo__c = theEndDateTime;
        theOboStSelProf.MeasuredCount__c = theCount;
        theOboStSelProf.MeasuredAvgTesuryo__c = theAvgTesuryo;
        theOboStSelProf.MeasuredAvgTesuryoGapRate__c = theAvgTesruryoGapRate;
        theOboStSelProf.SvcRankOrder__c = theSvcRankOrder;

        UPSERT theOboStSelProf;
	}
}