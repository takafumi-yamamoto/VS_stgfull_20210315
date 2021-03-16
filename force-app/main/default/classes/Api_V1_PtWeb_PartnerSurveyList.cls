@RestResource(urlMapping='/api/v1/partnersurvey/list/*')
global class Api_V1_PtWeb_PartnerSurveyList {

    private static final List<String> PW_SURVEY_QUESTION_RESPONSE = new List<String>{
        'SG001', 'SG002', 'SG005', 'SG007', 'SG004'
        ,'SJ001', 'SJ003', 'SJ005', 'SJ007'
    };

	public class ReqBody{
        public String torihikisaki_bango = '';
        public String strLimit = '';
        public String strOffset = '';
        public Integer intLimit = 20;
        public Integer intOffset = 0;

        public ReqBody readRequest(RestRequest pRestRequest){
            System.debug('pRestRequest:' + pRestRequest);
            this.torihikisaki_bango = pRestRequest.params.get('torihikisaki_bango');
            this.strLimit  = pRestRequest.params.get('limit');
            this.strOffset = pRestRequest.params.get('offset');
            return this;
        }
    }

    public class ResBody{
        public Integer total_count = 0;
        public Decimal summary_sogisha_total      = 0;
        public Decimal summary_sogisha_correspond = 0;
        public Decimal summary_sogisha_grooming   = 0;
        public Decimal summary_sogisha_cooking    = 0;
        public Decimal summary_saijo_access     = 0;
        public Decimal summary_saijo_atmosphere = 0;
        public Decimal summary_saijo_decoration = 0;
        public List<Answer> answers = new List<Answer>();
    }

    public class Answer{
        public String shodan_bango  = '';
        public String survey_id     = '';
        public Date   seko_date     = null;
        public String plan_name     = '';
        public String saijo_name    = '';
        public String taishosha_name = '';
        public Integer sogisha_total       = 0;
        public Integer sogisha_correspond  = 0;
        public Integer sogisha_grooming    = 0;
        public Integer sogisha_cooking     = 0;
        public String  sogisha_free = '';
        public Integer saijo_access     = 0;
        public Integer saijo_atmosphere = 0;
        public Integer saijo_decoration = 0;
        public String  saijo_free = '';
    }

    @HttpGet
    global static void doGet(){

        RestRequest theReq = RestContext.request;
        RestResponse theRes = RestContext.response;
        theRes.addHeader('Content-Type', 'application/json');
        ReqBody theReqBody = new ReqBody().readRequest(theReq);

        if (String.isBlank(theReqBody.torihikisaki_bango)) {
            theRes.statusCode = 400;
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Info, '20200731-1200-01', 'Api_V1_PtWeb_PartnerSurveyList')
                    .putAttr('theResult.statusCode', String.valueOf(theRes.statusCode) )
                    .putAttr('theResult.param_torihikisaki_bango', theReqBody.torihikisaki_bango)
            );
            return;
        }

        try {
            theReqBody.intLimit = Integer.valueOf(theReqBody.strLimit);
            theReqBody.intOffset = Integer.valueOf(theReqBody.strOffset);
        } catch (Exception e) {
            theRes.statusCode = 400;
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Info, '20200731-1200-01', 'Api_V1_PtWeb_PartnerSurveyList')
                    .putAttr('theResult.statusCode', String.valueOf(theRes.statusCode) )
                    .putAttr('theResult.param_limit', theReqBody.strLimit)
                    .putAttr('theResult.param_offset', theReqBody.strOffset)
            );
            return;
        }

        try {
            Processor proc = new Processor();
            ResBody theResBody = proc.run(theReqBody);
            theRes.statusCode = 200;
            theRes.responseBody = Blob.valueOf( JSON.serialize( theResBody ) );
            return;
        } catch (Exception e){
            theRes.statusCode = 500;
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20200731-1200-02', 'Api_V1_PtWeb_PartnerSurveyList')
                    .putAttr('theResult.statusCode', String.valueOf(theRes.statusCode) )
                    .putAttr('theResult.param_torihikisaki_bango', theReqBody.torihikisaki_bango)
                    .putAttr('theResult.descr', e.getStackTraceString())
            );
            return;
        }
    }

    private class Processor {
        public void Processor() {}

        public ResBody run(ReqBody pReqBody) {
            ResBody theResBody = new ResBody();

            this.setSummaryFromReport(pReqBody.torihikisaki_bango, theResBody);

            List<SurveyTaker__c> surveyTakerList = getTakerListByTorihikisakiBango(
                pReqBody.torihikisaki_bango
                ,pReqBody.intLimit
                ,pReqBody.intOffset
            );

            for (SurveyTaker__c taker : surveyTakerList) {
                Answer theAnswer = new Answer();
                OpportunityLineItem plan = getPlanByOppId(taker.CaseSurveyViscaRef__r.OppRef__r.Id);
                Boolean validSaijoFlg = isValidSaijo(
                    taker.CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.SaijoRef__r.ShisetsuKubun__c
                    ,plan.Product2.k_ShohinCategory_Name_exp__c
                );
                theAnswer.survey_id      = taker.Id;
                theAnswer.shodan_bango   = taker.CaseSurveyViscaRef__r.OppRef__r.ShodanBango__c;
                theAnswer.seko_date      = taker.CaseSurveyViscaRef__r.OppRef__r.Utiagebi__c;
                theAnswer.taishosha_name = taker.CaseSurveyViscaRef__r.OppRef__r.TaishosyaRef__r.Name;
                theAnswer.plan_name      = plan.Product2.NameForCustomer__c;
                if (validSaijoFlg) {
                    theAnswer.saijo_name = taker.CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.SaijoRef__r.Name;
                }
                for (SurveyQuestionResponse__c res : taker.SurveyQuestionAnswers__r) {
                    if (!validSaijoFlg && res.SurveyQuestion__r.Name.contains('SJ')) {
                        continue;
                    }

                    String qName = res.SurveyQuestion__r.Name;
                    String ans = res.Response__c;
                    if (String.isNotEmpty(ans)) {
                        if (Cnst.SURVEY_WEB_POSTING_CONVERT_PICKUPSTAR_TO_NUMBER_LIST.containsKey(ans)) {
                            ans = Cnst.SURVEY_WEB_POSTING_CONVERT_PICKUPSTAR_TO_NUMBER_LIST.get(ans);
                            if (qName == 'SG001') {
                                theAnswer.sogisha_total = integer.valueof(ans);
                            } else if (qName == 'SG002') {
                                theAnswer.sogisha_correspond = integer.valueof(ans);
                            } else if (qName == 'SG005') {
                                theAnswer.sogisha_grooming = integer.valueof(ans);
                            } else if (qName == 'SG007') {
                                theAnswer.sogisha_cooking = integer.valueof(ans);
                            } else if (qName == 'SJ001') {
                                theAnswer.saijo_access = integer.valueof(ans);
                            } else if (qName == 'SJ003') {
                                theAnswer.saijo_atmosphere = integer.valueof(ans);
                            } else if (qName == 'SJ005') {
                                theAnswer.saijo_decoration = integer.valueof(ans);
                            }
                        } else {
                            if (qName == 'SG004') {
                                theAnswer.sogisha_free = ans;
                            } else if (qName == 'SJ007') {
                                theAnswer.saijo_free = ans;
                            }
                        }
                    }
                }
                theResBody.answers.add(theAnswer);
            }

            return theResBody;
        }

        private List<SurveyTaker__c> getTakerListByTorihikisakiBango (
            String torihikisakiBango
            ,Integer intLimit
            ,Integer intOffset
        ) {
            return [
                SELECT
                  Id
                  ,CaseSurveyViscaRef__r.OppRef__r.Id
                  ,CaseSurveyViscaRef__r.OppRef__r.ShodanBango__c
                  ,CaseSurveyViscaRef__r.OppRef__r.Utiagebi__c
                  ,CaseSurveyViscaRef__r.OppRef__r.TaishosyaRef__r.Name
                  ,CaseSurveyViscaRef__r.OppRef__r.TaishosyaRef__r.JuminhyouFormula__c
                  ,CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.SaijoRef__r.Name
                  ,CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.SaijoRef__r.ShisetsuKubun__c
                  ,WebPostingStatus__c
                  ,SaijoComment__c
                  ,surveyAreaCode__c
                  ,(
                    SELECT
                      SurveyQuestion__r.Name
                      ,Response__c
                    FROM
                      SurveyQuestionAnswers__r
                    WHERE
                      SurveyQuestion__r.Name IN :PW_SURVEY_QUESTION_RESPONSE
                    ORDER BY
                      No__c
                  )
                FROM
                  SurveyTaker__c
                WHERE
                  CaseSurveyViscaRef__r.OppRef__r.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__r.TeikesakiTorihikisakiBango__c = :torihikisakiBango
                ORDER BY
                  CaseSurveyViscaRef__r.OppRef__r.Utiagebi__c DESC
                LIMIT
                  :intLimit
                offset
                  :intOffset
            ];
        }

        private OpportunityLineItem getPlanByOppId (String oppId) {
            return [
                SELECT
                  Product2.NameForCustomer__c
                  ,Product2.k_ShohinCategory_Name_exp__c
                FROM
                  OpportunityLineItem
                WHERE
                  OpportunityId = :oppId
                AND
                  Product2.HinmokuBunrui__c = :Cnst.PRODUCT2_BUNRUI_HONTAI
                LIMIT 1
            ];
        }

        private Boolean isValidSaijo (String kubun, String planTypeName) {
            Boolean rslt = false;
            if (kubun == '自社'
                    && (planTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_ICHINICHI
                        || planTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_KAZOKU
                        || planTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_IPPAN
                        || planTypeName == cnst.PRODUCT2_SOGI_CATEGORY_NAME_YASUGO)
            ) {
                rslt = true;
            }

            return rslt;
        }

        private void setSummaryFromReport(String torihikisakiBango, ResBody theResBody) {
            List<Report> reportList = [
                select Id, DeveloperName
                from Report
                where DeveloperName = 'rp20210222190000'
            ];
            String reportId = (String)reportList.get(0).get('Id');

            // Get the report metadata
            Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
            Reports.ReportMetadata md = describe.getReportMetadata();

            // Set filter
            Reports.ReportFilter[] filterList = md.getReportFilters();
            Reports.ReportFilter appendFilter = new Reports.ReportFilter(
                'SurveyTaker__c.CaseSurveyViscaRef__c.OppRef__c.SimpleYasugoRef__c.SimpleYasugoKeiyakuRef__c.TeikesakiTorihikisakiBango__c'
                ,'equals'
                ,torihikisakiBango
                ,Reports.ReportFilterType.fieldValue
            );
            filterList.add(appendFilter);
            md.setReportFilters(filterList);

            String filterLogic = md.getReportBooleanFilter();
            filterLogic += ' AND 5';
            md.setReportBooleanFilter(filterLogic);

            Reports.ReportResults results = Reports.ReportManager.runReport(reportId, md, false);
            List<Reports.GroupingValue> rowGroupings = results.getGroupingsDown().getGroupings();
            if (rowGroupings.size() < 1) {
                return;
            }

            for(Reports.GroupingValue qnameGr : rowGroupings[0].getGroupings()) {
                Decimal ansSum = 0;
                Decimal ansCnt = 0;
                for(Reports.GroupingValue ansGr : qnameGr.getGroupings()) {
                    String factKey = ansGr.getKey() + '!T';
                    String ans = (String) ansGr.getValue();
                    Integer cnt = Integer.valueOf(results.getFactMap().get(factKey).getAggregates()[0].getValue());
                    ansCnt += cnt;
                    if (Cnst.SURVEY_WEB_POSTING_CONVERT_PICKUPSTAR_TO_NUMBER_LIST.containsKey(ans)) {
                        Integer point = Integer.valueOf(Cnst.SURVEY_WEB_POSTING_CONVERT_PICKUPSTAR_TO_NUMBER_LIST.get(ans));
                        ansSum += point * cnt;
                    }
                }
                // 小数点 第2位を四捨五入
                Decimal ansAvg = (ansSum / ansCnt) * 10;
                ansAvg = (Decimal) ansAvg.round(System.RoundingMode.HALF_UP) / 10;
                if (qnameGr.getLabel() == 'SG001') {
                    theResBody.total_count = (Integer) ansCnt;
                    theResBody.summary_sogisha_total = ansAvg;
                } else if (qnameGr.getLabel() == 'SG002') {
                    theResBody.summary_sogisha_correspond = ansAvg;
                } else if (qnameGr.getLabel() == 'SG005') {
                    theResBody.summary_sogisha_grooming = ansAvg;
                } else if (qnameGr.getLabel() == 'SG007') {
                    theResBody.summary_sogisha_cooking = ansAvg;
                } else if (qnameGr.getLabel() == 'SJ001') {
                    theResBody.summary_saijo_access = ansAvg;
                } else if (qnameGr.getLabel() == 'SJ003') {
                    theResBody.summary_saijo_atmosphere = ansAvg;
                } else if (qnameGr.getLabel() == 'SJ005') {
                    theResBody.summary_saijo_decoration = ansAvg;
                }
            }
        }
    }
}