public class SogiShiryoSofuSofuzumiProcessing {
    private static String rtSimpleYasugoOtoiawaseId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoOtoiawase').getRecordTypeId();
    private static String rtSimpleYasugoShiryoSeikyuWebFormId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId();
    private static String rtSimpleYasugoEndingnoteWebForm = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoEndingnoteWebForm').getRecordTypeId();

    public static void OnAfterUpdate(List<SogiShiryoSofu__c> newList, Map<Id, SogiShiryoSofu__c> oldMap){
        
        Set<Id> sogiShiryoSofuIds = new Set<Id>();
        for(SogiShiryoSofu__c aSogiShiryoSofu : newList){
            if(aSogiShiryoSofu.SofuJokyo__c == '送付済' && oldMap.get(aSogiShiryoSofu.Id).SofuJokyo__c != '送付済') sogiShiryoSofuIds.add(aSogiShiryoSofu.Id);
        }

        List<Task> insTaskList = new List<Task>();
        List<Opportunity> upOpportunityList = new List<Opportunity>();
        for(SogiShiryoSofu__c shiryoSofu : [select Id, 
                                                    InsatsubutsuIchiran__c,
                                                    SofuNichiji__c, 
                                                    OpportunityRef__c, 
                                                    OpportunityRef__r.RecordType.DeveloperName, 
                                                    OpportunityRef__r.StageName,  
                                                    OpportunityRef__r.CaseRef__r.RecordTypeId, 
                                                    OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c, 
                                                    OpportunityRef__r.Account.PersonContactId 
                                            from SogiShiryoSofu__c 
                                            where Id = :sogiShiryoSofuIds]){
            String dsp = '';
            if(shiryoSofu.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoShiryoSeikyuWebFormId || 
            shiryoSofu.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoOtoiawaseId){
                dsp = shiryoSofu.InsatsubutsuIchiran__c + '発送' + '\n' + 
                        '\n' + 
                        '【資料発送日】'+'\n' + shiryoSofu.SofuNichiji__c.format('yyyy/MM/dd')+'\n' + 
                        '【次回の対応】' + '\n' + 
                        'フォローTEL';
            }
            if(shiryoSofu.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoEndingnoteWebForm){
                dsp = shiryoSofu.InsatsubutsuIchiran__c + '発送' + '\n' + 
                        '\n' + 
                        '【次回の対応】' + '\n' + 
                        '入電待ち';
            }

            String subPhase = '';
            if(shiryoSofu.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoShiryoSeikyuWebFormId){
                if(shiryoSofu.OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c == '健在') subPhase = '資料到着確認待ち（健在/余命宣告［不急］）';
                if(shiryoSofu.OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c != '健在') subPhase = '資料到着確認待ち（危篤/余命宣告［急］）';
            }
            if(shiryoSofu.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoEndingnoteWebForm){
                subPhase = 'フォロー（健在/余命宣告［不急］）';
            }
    
            insTaskList.add(
                new Task(
                    RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId(), 
                    WhoId = shiryoSofu.OpportunityRef__r.Account.PersonContactId, 
                    WhatId = shiryoSofu.OpportunityRef__c, 
                    Status = '完了', 
                    Subject = '', 
                    TaskSubtype = 'Call', 
                    ServiceType__c = shiryoSofu.OpportunityRef__r.RecordType.DeveloperName, 
                    ShiborikomiJoken__c = 'フォロー：' + subPhase, 
                    YokenSyubetsu__c = '事務作業', 
                    Description = dsp,
                    OwnerId = UserInfo.getUserId()
                )
            );

            if(shiryoSofu.OpportunityRef__r.StageName == '問合せ受付'){
                
                upOpportunityList.add(
                    new Opportunity(
                        Id = shiryoSofu.OpportunityRef__c,
                        StageName = 'フォロー',
                        SubPhase__c = subPhase
                    )
                );
            }
        }

        insert insTaskList;
        update upOpportunityList;
    }
}