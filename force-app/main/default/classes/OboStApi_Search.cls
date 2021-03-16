public class OboStApi_Search {
    public class OboStApiSearchException extends Exception {}

    public class ReqBody {
        public Integer offset;
        public Integer limit_size;
        public String exclude_negotiation_id = '';
        public String contract_id = '';
        public String shushi = '';
        public String kibo_shuha = '';
        public List<String> rank_ordering = new List<String>();
        public List<String> exclude_contract_ids = new List<String>();
        public List<String> exclude_unavailable_services = new List<String>();
        public Place place;
        public List<CandidatePeriod> candidate_periods = new List<CandidatePeriod>();
        public List<FuzzyCandidateDate> fuzzy_candidate_dates = new List<FuzzyCandidateDate>();

        public String getUrlParam(){
            List<String> params = new List<String>();
            if(offset != null) params.add('offset=' + offset);
            if(limit_size != null) params.add('limit=' + limit_size);
            if(String.isNotBlank(exclude_negotiation_id)) params.add('exclude_negotiation_id=' + EncodingUtil.urlEncode(exclude_negotiation_id,'UTF-8'));
            if(String.isNotBlank(contract_id)) params.add('contract_id=' + EncodingUtil.urlEncode(contract_id,'UTF-8'));
            if(String.isNotBlank(shushi)) params.add('shushi=' + EncodingUtil.urlEncode(shushi,'UTF-8'));
            if(String.isNotBlank(kibo_shuha)) params.add('kibo_shuha=' + EncodingUtil.urlEncode(kibo_shuha,'UTF-8'));
            if(rank_ordering != null && rank_ordering.size() > 0)
                params.add('rank_ordering=' +  + join(rank_ordering, ','));
            if(exclude_contract_ids != null && exclude_contract_ids.size() > 0)
                params.add('exclude_contract_ids='  + join(exclude_contract_ids, ','));
            if(exclude_unavailable_services != null && exclude_unavailable_services.size() > 0)
                params.add('exclude_unavailable_services=' + join(exclude_unavailable_services, ','));
            if(candidate_periods != null && candidate_periods.size() > 0)
                params.add('candidate_periods='  + join(candidate_periods, ','));
            if(fuzzy_candidate_dates != null && fuzzy_candidate_dates.size() > 0)
                params.add('fuzzy_candidate_dates=' + join(fuzzy_candidate_dates, ','));
            if(place != null)
                params.add('place=' + place);
            return String.join(params, '&');
        }

        private String join(List<Object> iterableObj, String separator){
            List<String> stringList = new List<String>();
            for(Object obj: iterableObj) {
                stringList.add(obj.toString());
            }
            return EncodingUtil.urlEncode(String.join(stringList, separator), 'UTF-8');
        }

    }

    public class Duration{
        public Datetime from_datetime;
        public Datetime to_datetime;
        public Duration(Datetime from_datetime, Datetime to_datetime){
            this.from_datetime = from_datetime;
            this.to_datetime = to_datetime;
        }
        public override String toString(){
            if(from_datetime == null || to_datetime == null)
                return '';
            return from_datetime.format('YYYY-MM-dd HH:mm') + '_' + to_datetime.format('YYYY-MM-dd HH:mm');
        }
    }

    public class CandidatePeriod{
        public List<Duration> duraitios = new List<Duration>();
        public CandidatePeriod addDuration(Duration duraitio){
            if(duraitio != null) this.duraitios.add(duraitio);
            return this;
        }
        public CandidatePeriod addDurations(List<Duration> duraitios){
            if(duraitios != null) this.duraitios.addAll(duraitios);
            return this;
        }
        public override String toString(){
            if(duraitios != null && duraitios.size() > 0){
                return join(duraitios, '&');
            }
            return '';
        }
        private String join(List<Object> iterableObj, String separator){
            List<String> stringList = new List<String>();
            for(Object obj: iterableObj) {
                stringList.add(obj.toString());
            }
            return String.join(stringList, separator);
        }
    }

    public class FuzzyCandidateDate {
        public String eigyoHHMMFrom;
        public String eigyoHHMMTo;
        public Integer siteiAkiJikan;
        public Date candidate_date;
        public FuzzyCandidateDate(String eigyoHHMMFrom, String eigyoHHMMTo, Integer siteiAkiJikan, Date candidate_date){
            this.eigyoHHMMFrom = eigyoHHMMFrom;
            this.eigyoHHMMTo = eigyoHHMMTo;
            this.siteiAkiJikan = siteiAkiJikan;
            this.candidate_date = candidate_date;
        }
        public override String toString(){
            return  eigyoHHMMFrom + '_' + eigyoHHMMTo  + '&'
                    + siteiAkiJikan + '&'
                    + Datetime.newInstance(candidate_date.year(), candidate_date.month(), candidate_date.day()).format('YYYY-MM-dd');
        }
    }
    public class Place {
        public Decimal latitude;
        public Decimal longitude;
        public Integer max_distance;
        public Place(Decimal latitude, Decimal longitude, Integer max_distance) {
            this.latitude = latitude;
            this.longitude = longitude;
            this.max_distance = max_distance;
        }
        public override String toString(){
            if(latitude == null || longitude == null || max_distance == null)
                return '';
            return EncodingUtil.urlEncode(String.join(new List<String>{ String.valueOf(latitude), String.valueOf(longitude), String.valueOf(max_distance) }, ','), 'UTF-8');
        }
    }

    public class Senteisaki{
        public String id; // 契約番号
        public String partner_id;
        public String partner_name;
        public String temple;
        public String rank;
        public Decimal distance;
    }

    public class Result {
        public Boolean isSuccess = false;
        public String endPoint = '';
        public Integer statusCode = 0;
        public String descr = '';
        public String reqBodyRaw = '';
        public String resBodyRaw = '';
    }

    public List<Senteisaki> doSearch(ReqBody pReqBody) {
        OboStConfig theConfig = new OboStConfig();

        Result theResult = new Result();
        List<Senteisaki> senteisakis = new List<Senteisaki>();
        try {
            theResult.endPoint = theConfig.getBaseEndPoint() + '/api/search/contracts?' + pReqBody.getUrlParam();
            theResult.reqBodyRaw = pReqBody.getUrlParam();

            HttpRequest request = new HttpRequest();
            request.setEndpoint(theResult.endPoint);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setTimeout(60000);
            new OboStApi_Auth().setAuthHeader(request);

            HttpResponse response = new http().send(request);

            theResult.statusCode = response.getStatusCode();
            theResult.resBodyRaw = response.getBody();
            theResult.isSuccess = theResult.statusCode == 200;

            senteisakis = (List<Senteisaki>)JSON.deserialize(theResult.resBodyRaw, List<Senteisaki>.class);

        } catch(Exception e){
            theResult.isSuccess = false;
            theResult.descr = e.getMessage();
            System.debug(theResult.descr);
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20190421-1400-02', 'OboStApi_Search.doSearch')
                    .putAttr('theResult.endPoint', theResult.endPoint)
                    .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                    .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                    .putAttr('theResult.getUrlParam', EncodingUtil.urlDecode(theResult.reqBodyRaw, 'UTF-8'))
                    .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                    .putAttr('theResult.descr',theResult.descr)
            );
            throw new OboStApiSearchException(theResult.descr);
        }

        Loggings.writeLog(
            Loggings.createLogEntry(
                theResult.isSuccess ? Loggings.Level.Info : Loggings.Level.Error, '20190421-1400-01', 'OboStApi_Search.doSearch')
                .putAttr('theResult.endPoint', theResult.endPoint)
                .putAttr('theResult.statusCode', String.valueOf(theResult.statusCode))
                .putAttr('theResult.reqBodyRaw',theResult.reqBodyRaw)
                .putAttr('theResult.getUrlParam', EncodingUtil.urlDecode(theResult.reqBodyRaw, 'UTF-8'))
                .putAttr('theResult.resBodyRaw',theResult.resBodyRaw)
                .putAttr('theResult.descr',theResult.descr)
        );
        return senteisakis;
    }

}