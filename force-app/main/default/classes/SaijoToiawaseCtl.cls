public class SaijoToiawaseCtl {
    
    @future 
    public static void futureSaijoJogai(String oppId, 
                                            String simpleYasugoId, 
                                            String toiawasenaiyo, 
                                            String konnyusaki, 
                                            String konnyusakiSogishaTeikeiId, 
                                            String konnyusakiSogishaTeikeiName, 
                                            String konnyusakiSogishaTeikeiJokyo, 
                                            String konnyusakiKasobaTeikeiId, 
                                            String konnyusakiKasobaTeikeiName, 
                                            String konnyusakiSaijoTeikeiId, 
                                            String konnyusakiSaijoTeikeiName, 
                                            String konnyusakiSaijoTeikeiJokyo, 
                                            String konnyusakiKyogoTasha,
                                            String teikeigaiSogishaShisetsumei, 
                                            String tashaSodanJokyo, 
                                            String ankenShubetsu, 
                                            String toiawaseJogaiKubun) {
        
        try{
            String chakushinDenwaBango = '';
            String hasshinDenwaBango = '';
            User u = [select Id, BizTelAgentId__c from User where Id = :UserInfo.getUserId()];
            
            if(String.isNotBlank(u.BizTelAgentId__c)){
                List<Task> tList = [select Id, B_PhoneFromFormula__c, B_PhoneTo__c 
                                    from Task 
                                    where RecordTypeId = :Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('BizTel').getRecordTypeId()
                                    and B_AgentIdTo__c = :u.BizTelAgentId__c 
                                    and B_PhoneFrom__c != 'anonymous' 
                                    and CreatedDate >= :datetime.now().addhours(-1) order by CreatedDate desc limit 1];
                
                if(tList.size() == 1){
                    Task t = tList.get(0);
                    chakushinDenwaBango = t.B_PhoneTo__c;
                    hasshinDenwaBango = t.B_PhoneFromFormula__c;
                }
            }
        
            Opportunity opp = OpportunityDao.sltById(oppId);
            if(chakushinDenwaBango != ''){
                opp.ChakushinDenwaBango__c = chakushinDenwaBango;
            }
            if(hasshinDenwaBango != ''){
                opp.HasshinDenwaBango__c = hasshinDenwaBango;
            }
            opp.StageName = '除外';
            opp.SubPhase__c = '';
            opp.JogaiKubun__c = toiawaseJogaiKubun;
            opp.AnkenShubetsu__c = ankenShubetsu;
            update opp;

            SimpleYasugo__c simple = new SimpleYasugo__c(
                Id = simpleYasugoId, 
                ToiawaseNaiyo__c = toiawasenaiyo, 
                Konnyusaki__c = konnyusaki, 
                TashaSodanJokyo__c = tashaSodanJokyo);

            simple.KonnyusakiSogishaRef__c = null;
            simple.KonnyusakiSogishaText__c = '';
            simple.KonnyusakiKasobaRef__c = null;
            simple.KonnyusakiKasobaText__c = '';
            simple.KonnyusakiSaijoRef__c = null;
            simple.KonnyusakiSaijoText__c = '';
            simple.KonnyusakiKyogoTasha__c = '';
            simple.KonnyusakiKyogoTashaText__c = '';

            if(konnyusaki == '葬儀社'){
                if(konnyusakiSogishaTeikeiId != null && konnyusakiSogishaTeikeiId != ''){
                    simple.KonnyusakiSogishaRef__c = konnyusakiSogishaTeikeiId;
                } 
                simple.KonnyusakiSogishaText__c = konnyusakiSogishaTeikeiName;
                simple.TeikeiJokyo__c = konnyusakiSogishaTeikeiJokyo;
            }
            else if(konnyusaki == '火葬場'){
                if(konnyusakiKasobaTeikeiId != null && konnyusakiKasobaTeikeiId != ''){
                    simple.KonnyusakiKasobaRef__c = konnyusakiKasobaTeikeiId;
                }
                simple.KonnyusakiKasobaText__c = konnyusakiKasobaTeikeiName;
                simple.TeikeiJokyo__c = '';
            }
            else if(konnyusaki == '斎場'){
                if(konnyusakiSogishaTeikeiId != null && konnyusakiSogishaTeikeiId != ''){
                    simple.KonnyusakiSogishaRef__c = konnyusakiSogishaTeikeiId;
                } 
                if(konnyusakiSaijoTeikeiId != null && konnyusakiSaijoTeikeiId != ''){
                    simple.KonnyusakiSaijoRef__c = konnyusakiSaijoTeikeiId;
                }
                simple.KonnyusakiSaijoText__c = konnyusakiSaijoTeikeiName;
                simple.TeikeiJokyo__c = konnyusakiSaijoTeikeiJokyo;
            }
            else if(konnyusaki == '競合他社'){
                simple.KonnyusakiKyogoTasha__c = konnyusakiKyogoTasha;
                simple.KonnyusakiKyogoTashaText__c = teikeigaiSogishaShisetsumei;
            }
            update simple;
            
            insert new Task(
                            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId(),
                            WhatId = opp.Id,
                            Subject = '受電（お客様）',
                            ActivityDate = date.today(),
                            Status = '完了',
                            Priority = '標準',
                            Description = '斎場問合わせ',
                            TaskSubtype = 'Call',
                            RequestTeam__c = 'シンプル安豪',
                            Kijitsu__c = datetime.now(),
                            ServiceType__c = 'シンプル安豪',
                            ShiborikomiJoken__c = '除外',
                            YokenSyubetsu__c = '受電（お客様）'
                        );
        }
        catch(Exception e){
            System.debug('e.getMessage():' + e.getMessage());
            System.debug('e.getStackTraceString():' + e.getStackTraceString());

            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20190711-1827-01', 'SaijoToiawaseCtl')
                    .putAttr('theResult.message', e.getMessage())
            );
        }
    }
}