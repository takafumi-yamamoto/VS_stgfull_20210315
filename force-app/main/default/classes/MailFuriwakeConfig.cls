public class MailFuriwakeConfig {
    
    public static List<MailFutatsuDef__mdt> f_CachedFutatsuAddressList = null;
    public static List<MailFuriwakeDef__mdt> f_CachedMailFuriwakeList = null;
    public static List<MailLabelFuriwakeDef__mdt> f_CachedMailLabelFuriwakeList = null;
    public static List<MailKinkyuLevelFuriwakeDef__mdt> f_CachedMailKinkyuLevelFuriwakeList = null;

    public static final String FURIWAKE_METADATA_FUTATSU ='FUTATSU';
    public static final String FURIWAKE_METADATA_SERVICE ='SERVICE';
    public static final String FURIWAKE_METADATA_LABEL ='LABEL';
    public static final String FURIWAKE_METADATA_KINKYU ='KINKYU';

    private static final Map<String,String> METADATANAME_MAP = new Map<String,String>{FURIWAKE_METADATA_FUTATSU => 'MailFutatsuDef__mdt'
                                                                            ,FURIWAKE_METADATA_SERVICE => 'MailFuriwakeDef__mdt'
                                                                            ,FURIWAKE_METADATA_LABEL => 'MailLabelFuriwakeDef__mdt'
                                                                            ,FURIWAKE_METADATA_KINKYU => 'MailKinkyuLevelFuriwakeDef__mdt'
                                                                            };

    static{
        getMailFutatsuMailAddress();
        getMailFuriwakeList();
        getMailLabelFuriwakeList();
        getMailLevelFuriwakeList();
    }

    private static Map<String,List<sObject>> metadata_list_map = new Map<String,List<sObject>>{
        FURIWAKE_METADATA_FUTATSU => f_CachedFutatsuAddressList
        ,FURIWAKE_METADATA_SERVICE => f_CachedMailFuriwakeList
        ,FURIWAKE_METADATA_LABEL => f_CachedMailLabelFuriwakeList
        ,FURIWAKE_METADATA_KINKYU => f_CachedMailKinkyuLevelFuriwakeList
    };

    //不達メールアドレスと検知するためのメールアドレスリストを取得
    public static List<MailFutatsuDef__mdt> getMailFutatsuMailAddress(){
        if(f_CachedFutatsuAddressList == null){

            f_CachedFutatsuAddressList =
                [
                    select 
                        id
                        ,MasterLabel
                        ,FromMailAddress__c
                        ,TargetSubject__c
                        ,TargetContents__c
                    from MailFutatsuDef__mdt
                ];
        }
        return f_CachedFutatsuAddressList;
	}

    //メール振分用定義
    public static List<MailFuriwakeDef__mdt> getMailFuriwakeList(){
        if(f_CachedMailFuriwakeList == null){

            f_CachedMailFuriwakeList =
                [
                    select 
                        id
                        ,MasterLabel
                        ,ToMailAddress__c
                        ,TargetSubject__c
                        ,TargetContents__c
                        ,PriorityOrder__c
                    from MailFuriwakeDef__mdt
                    Order by PriorityOrder__c,ToMailAddress__c
                ];
        }

        return f_CachedMailFuriwakeList;
	}

    //メールラベル振分用定義
    public static List<MailLabelFuriwakeDef__mdt> getMailLabelFuriwakeList(){
        if(f_CachedMailLabelFuriwakeList == null){

            f_CachedMailLabelFuriwakeList =
                [
                    select 
                        id
                        ,MasterLabel
                        ,ToMailAddress__c
                        ,FromMailAddress__c
                        ,TargetSubject__c
                        ,TargetContents__c
                        ,PriorityOrder__c
                    from MailLabelFuriwakeDef__mdt
                    Order by PriorityOrder__c
                ];
        }
        return f_CachedMailLabelFuriwakeList;
	}

    //メール緊急レベル振分用定義
    public static List<MailKinkyuLevelFuriwakeDef__mdt> getMailLevelFuriwakeList(){
        if(f_CachedMailKinkyuLevelFuriwakeList == null){

            f_CachedMailKinkyuLevelFuriwakeList =
                [
                    select 
                        id
                        ,MasterLabel
                        ,ToMailAddress__c
                        ,TargetSubject__c
                        ,TargetContents__c
                        ,PriorityOrder__c
                    from MailKinkyuLevelFuriwakeDef__mdt
                    Order By PriorityOrder__c
                ];
        }
        return f_CachedMailKinkyuLevelFuriwakeList;
	}

    public static String chkMailConditon(EmailMessage emmsg,String targetMetaData){

        String chkresult = '';
        String metadataName = METADATANAME_MAP.get(targetMetaData);
        List<sObject> metalist = metadata_list_map.get(targetMetaData);

        if(metalist==null){
            return chkresult;
        }
                
        Map<String, Schema.SObjectField> fieldMap = getsObjectFieldmap(metadataName);

        //受信先メールアドレス項目・送信先メールアドレス項目があるかの判定に使う
        Schema.SObjectField toMailAddrField = fieldMap.get('ToMailAddress__c');
        Schema.SObjectField fromMailAddrField = fieldMap.get('FromMailAddress__c');

        for(Sobject targetData:metalist){
            FuriwakeCondition fcondition = new FuriwakeCondition();
            //受信先メールアドレス
            if(toMailAddrField!=null)fcondition.toMailAddr = (String)targetData.get('ToMailAddress__c');
            else fcondition.toMailAddr = null;
            //送信先メールアドレス
            if(fromMailAddrField!=null)fcondition.fromMailAddr = (String)targetData.get('FromMailAddress__c');
            else fcondition.fromMailAddr = null;
            //件名
            fcondition.subject = (String)targetData.get('TargetSubject__c');
            //本文
            fcondition.bodytext = (String)targetData.get('TargetContents__c');
            
            boolean conditionResult = chkConditions(emmsg,fcondition);
            if(conditionResult){
                if(FURIWAKE_METADATA_FUTATSU.equals(targetMetaData)) return 'true';
                return chkresult = (String)targetData.get('MasterLabel');
            }
        }
        return chkresult;
    }

    private static Boolean chkConditions(EmailMessage emmsg,FuriwakeCondition fcondion){
    
        Boolean chkresult = false;

        Boolean chkToAddr = false;
        Boolean chkFromAddr = false;
        Boolean chkSubject = false;
        Boolean chkBody = false;
        
        //受信先メールアドレスが合致しているかのチェック
        chkToAddr = chk(fcondion.toMailAddr,emmsg.ToAddress);
        //送信元メールアドレスが合致しているかのチェック
        chkFromAddr = chk(fcondion.fromMailAddr,emmsg.FromAddress);
        //件名が合致しているかのチェック
        chkSubject = chk(fcondion.subject,emmsg.Subject);
        //本文が合致しているかのチェック
        chkBody = chk(fcondion.bodytext,emmsg.TextBody);

        if(chkToAddr && chkFromAddr && chkSubject && chkBody) return true;

        return chkresult;
    }

    private static boolean chk(String cond,String message){

        if(String.isBlank(cond)){
            return true;
        }else{
            if(String.isNotBlank(message) && message.contains(cond)) return true;
        }
        return false;
    }

    private static Map<String, Schema.SObjectField> getsObjectFieldmap(String metadataName){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Schema.SObjectType sobjtype = gd.get(metadataName);
        Schema.DescribeSObjectResult sobjtypeResult = sobjtype.getDescribe();
        return sobjtypeResult.fields.getMap();
    }

    public class FuriwakeCondition{
        String toMailAddr{get;set;}
        String fromMailAddr{get;set;}
        String subject{get;set;}
        String bodytext{get;set;}
    }

}