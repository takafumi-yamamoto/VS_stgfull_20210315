/**
* クラス名           :   Com_LatitudeAndLongitude
* クラス概要       :   緯度経度設定の共通クラス
* @created  :   2018/01/05
* @modified :   
*/
public class Com_LatitudeAndLongitude {
    
   /**
    * setLatitudeAndLongitude
    * 位置の情報により、経度、緯度をセット
    * @param 取引先リスト
    * @return なし
    * @created: 2018/01/04 Wang
    * @modified: 
    */   
    public static void setLatitudeAndLongitudeMain(String sobjectType,List<sobject> newList,Map<Id, sobject> oldMap){
        
            list<sobject> locationChangedList=new list<sobject>();
            for (sobject obj:newList){              
                if (oldMap==null){
                    locationChangedList.add(obj);
                }else{
                    //市区郡の場合        
                    if (sobjectType==Shikugun__c.getSObjectType().getDescribe().getName()){
                        Shikugun__c newShikugun = (Shikugun__c)obj;
                        Shikugun__c oldShikugun = (Shikugun__c)oldMap.get(newShikugun.id);
                        if (newShikugun.TodoufuKenRef__r.name!=oldShikugun.TodoufuKenRef__r.name){
                            locationChangedList.add(obj);
                        }
                    } 
                    //取引先の場合
                    if (sobjectType==Account.getSObjectType().getDescribe().getName()){
                        Account newAccount = (Account)obj;
                        Account oldAccount = (Account)oldMap.get(newAccount.id);
                        if (newAccount.BillingPostalCode!=oldAccount.BillingPostalCode||
                            newAccount.BillingCountry!=oldAccount.BillingCountry||
                            newAccount.BillingState!=oldAccount.BillingState||
                            newAccount.BillingCity!=oldAccount.BillingCity||
                            newAccount.BillingStreet!=oldAccount.BillingStreet){
                                locationChangedList.add(obj);
                        }
                    }
                    //施設の場合
                    if (sobjectType==Shisetsu__c.getSObjectType().getDescribe().getName()){
                        Shisetsu__c newShisetsu = (Shisetsu__c)obj;
                        Shisetsu__c oldShisetsu = (Shisetsu__c)oldMap.get(newShisetsu.id);
                        if (newShisetsu.PostalCode__c!=oldShisetsu.PostalCode__c||
                            newShisetsu.State__c!=oldShisetsu.State__c||
                            newShisetsu.City__c!=oldShisetsu.City__c||
                            newShisetsu.Street__c!=oldShisetsu.Street__c){
                                locationChangedList.add(obj);
                        }
                    }
                    //斎場の場合
                    if (sobjectType==Saijo__c.getSObjectType().getDescribe().getName()){
                        Saijo__c newShisetsu = (Saijo__c)obj;
                        Saijo__c oldShisetsu = (Saijo__c)oldMap.get(newShisetsu.id);
                        if (newShisetsu.PostalCode__c!=oldShisetsu.PostalCode__c||
                            newShisetsu.ShikugunRef__c!=oldShisetsu.ShikugunRef__c||
                            newShisetsu.Street__c!=oldShisetsu.Street__c){
                                locationChangedList.add(obj);
                        }
                    }
                }
            }

            if(locationChangedList.size() > 0){
                setLatitudeAndLongitude(sobjectType,locationChangedList);
            }
    }
    
   /**
    * setLatitudeAndLongitude
    * 位置の情報により、経度、緯度をセット
    * @param 取引先リスト
    * @return なし
    * @created: 2018/01/04 Wang
    * @modified: 
    */   
    public static void setLatitudeAndLongitude(String sobjectType,List<sobject> SobjectList){
        if (system.isFuture()){
            return;
        }
        list <id> idlst=new list <id>();
        for (sobject obj:SobjectList){
            idlst.add(obj.id);
        }

        try{
            CovertLocationToLatitudeAndLongitude1(sobjectType,string.join(idlst,';'));
        }
        catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20200525-1513-01', 'Com_LatitudeAndLongitude.setLatitudeAndLongitude')
                    .putAttr('sobjectType', sobjectType)
                    .putAttr('idlst', string.join(idlst,';'))
                    .putAttr('UserInfo.getUserId()', UserInfo.getUserId())
                    .putAttr('e.getMessage()',e.getMessage())
                    .putAttr('e.getStackTraceString()',e.getStackTraceString())
            );
        }
    }
   /**
    * CovertLocationToLatitudeAndLongitude
    * Google Apiを呼び出して、経度、緯度を算出
    * @param 市区郡ID
    * @return なし
    */    
    @Future(callout=true)
    public static void CovertLocationToLatitudeAndLongitude1(String sobjectType,string ids){
        system.debug('=================setLatitudeAndLongitude begin==========================');
        system.debug('***ids=' + ids);
        list<sobject> updSobjectLst = new list<sobject>();
        list<id> SobjectIds=ids.split(';');        
        list<sobject> objs = getObjs(sobjectType,ids);
        for (sobject obj:objs){       
            string address=getAddress(obj);
            system.debug('***address=' + address);
            if(address !=''){
                HttpRequest req = new HttpRequest();
                address = EncodingUtil.urlEncode(address,'UTF-8');
                req.setEndPoint('https://maps.googleapis.com/maps/api/geocode/xml?key=AIzaSyCxIYCRdQaHersS3Ew0Qp3TwcHmn6C8yP0&address='+address+'&sensor=true');
                req.setMethod('GET');
                Http http = new Http();
                HttpResponse res;
                if(!Test.isRunningTest()){
                    res = http.send(req);
                }else{
                    String resString = '<GeocodeResponse><status>OK</status><result><geometry><location><lat>37.4217550</lat> <lng>-122.0846330</lng></location>';
                    resString +='</geometry> </result> </GeocodeResponse>';
                    res = new HttpResponse();
                    res.setBody(resString);
                    res.setStatusCode(200);
                }
                Dom.Document doc = res.getBodyDocument();
                Dom.XMLNode geocodeResponse = doc.getRootElement();
                system.debug('***geocodeResponse=' + geocodeResponse);
                if(geocodeResponse!=null){
                    Dom.XMLNode result = geocodeResponse.getChildElement('result',null);
                    system.debug('***result=' + result);
                    if(result!=null){
                        Dom.XMLNode geometry = result.getChildElement('geometry',null);
                        system.debug('***geometry=' + geometry);
                        if(geometry!=null){
                            Dom.XMLNode location = geometry.getChildElement('location',null);                            
                            system.debug('***location=' + location);
                            if(location!=null){
                                String lat = location.getChildElement('lat', null).getText();
                                String lng = location.getChildElement('lng', null).getText();
                                system.debug('***lat=' + lat);
                                system.debug('***lng=' + lng);
                                try{
                                    updSobjectLst.add(setLatitudeAndLongitudeToObject(obj,lat,lng));
                                }catch(Exception ex){
                                    system.debug('Exception '+ex.getMessage());
                                }
                            }
                        }
                    }
                }
                
            }
            system.debug('=================setLatitudeAndLongitude end==========================');
            update updSobjectLst;
        }
    }
   /**
    * getObjs
    * 処理対象となるレコードを取得
    * @param sobjectType　オブジェクトタイプ
    * @param ids  IDの文字列  
    * @return 対象レコード
    */      
    public static list<sObject> getObjs(String sobjectType,string ids){ 
        list<id> SobjectIds=ids.split(';');
        list<sobject> sObjLst = new list<sobject>();
        //市区郡の場合
        if (sobjectType==Shikugun__c.getSObjectType().getDescribe().getName()){
            for (Shikugun__c Shikugun:[select id,
                                              name,
                                              TodoufuKenRef__r.name,
                                              Chiriichijouhou__c 
                                         from Shikugun__c 
                                        where id in :SobjectIds]){
                sObjLst.add(Shikugun);
            }
        }
        //施設の場合
        if (sobjectType==Shisetsu__c.getSObjectType().getDescribe().getName()){
            for (Shisetsu__c Shisetsu:[select id,
                                            Jusho__c,
                                            PostalCode__c
                                       from Shisetsu__c 
                                      where id in :SobjectIds]){
                sObjLst.add(Shisetsu);
            }
        }
        //斎場の場合
        if (sobjectType==Saijo__c.getSObjectType().getDescribe().getName()){
            for (Saijo__c saijo:[select id,
                                            Jusho__c,
                                            PostalCode__c
                                       from Saijo__c 
                                      where id in :SobjectIds]){
                sObjLst.add(saijo);
            }
        }
        //取引先の場合
        if (sobjectType==Account.getSObjectType().getDescribe().getName()){
            for (Account acc:[select id,
                                   BillingStreet,
                                   BillingCity,
                                   BillingState,
                                   BillingCountry,
                                   BillingPostalCode,
                                   BillingLatitude,
                                   BillingLongitude 
                              from account 
                             where id in :SobjectIds]){
                sObjLst.add(acc);
            }
        }           
        return sObjLst;     
    }
   /**
    * getAddress
    * 各対象に格納されてる住所の文字列を取得
    * @param obj　オブジェクト
    * @return 住所
    */     
    public static string getAddress(sobject obj){  
        String address='';
        String sobjectType = obj.getSObjectType().getDescribe().getName();
        //市区郡の場合        
        if (sobjectType==Shikugun__c.getSObjectType().getDescribe().getName()){         
            Shikugun__c Shikugun = (Shikugun__c)obj;  
            address='';
            if(Shikugun.TodoufuKenRef__c!=null){
                address=Shikugun.TodoufuKenRef__r.name+',';
            }
            if(Shikugun.name!=null){
                address += Shikugun.name;
            }           
        }
        //施設の場合
        if (sobjectType==Shisetsu__c.getSObjectType().getDescribe().getName()){     
            Shisetsu__c Shisetsu = (Shisetsu__c)obj;
            address='';             
            if(Shisetsu.Jusho__c!=null){
                address = Shisetsu.Jusho__c+',';
            }
            if(Shisetsu.PostalCode__c!=null){
                address += Shisetsu.PostalCode__c;
            }            
        }  
        //斎場の場合
        if (sobjectType==Saijo__c.getSObjectType().getDescribe().getName()){     
            Saijo__c saijo = (Saijo__c)obj;
            address='';             
            if(saijo.Jusho__c!=null){
                address = saijo.Jusho__c+',';
            }
            if(saijo.PostalCode__c!=null){
                address += saijo.PostalCode__c;
            }            
        }
        //取引先の場合
        if (sobjectType==Account.getSObjectType().getDescribe().getName()){     
            Account acc = (Account)obj;
            address='';
            if(acc.BillingStreet!=null){
                address += acc.BillingStreet+',';
            }
            if(acc.BillingCity !=null){
                address += acc.BillingCity+',';
            }
            if(acc.BillingState!=null){
                address +=acc.BillingState+',';
            }
            if(acc.BillingCountry!=null){
                address += acc.BillingCountry+',';
            }
            if(acc.BillingPostalCode!=null){
                address += acc.BillingPostalCode;
            }
        }           
        return address;     
    } 
   /**
    * setLatitudeAndLongitudeToObject
    * 緯度、経度をオブジェクトに設定    
    * @param obj　オブジェクト
    * @param lat　緯度
    * @param lng　経度            
    * @return 緯度経度設定後のオブジェクト
    */       
    public static sobject setLatitudeAndLongitudeToObject(sobject obj,string lat,string lng){       
        String sobjectType = obj.getSObjectType().getDescribe().getName(); 
        //市区郡の場合
        if (sobjectType==Shikugun__c.getSObjectType().getDescribe().getName()){
            Shikugun__c rtnObj = new Shikugun__c();
            rtnObj.id=obj.id;
            rtnObj.Chiriichijouhou__latitude__s =Decimal.valueof(lat);
            rtnObj.Chiriichijouhou__longitude__s =Decimal.valueof(lng);  
            return rtnObj;          
        }
        //施設の場合
        if (sobjectType==Shisetsu__c.getSObjectType().getDescribe().getName()){
            Shisetsu__c rtnObj = new Shisetsu__c();
            rtnObj.id=obj.id;
            rtnObj.IdoKedo__latitude__s =Decimal.valueof(lat);
            rtnObj.IdoKedo__longitude__s =Decimal.valueof(lng);  
            return rtnObj;          
        }  
        //斎場の場合
        if (sobjectType==Saijo__c.getSObjectType().getDescribe().getName()){
            Saijo__c rtnObj = new Saijo__c();
            rtnObj.id=obj.id;
            rtnObj.IdoKedo__latitude__s =Decimal.valueof(lat);
            rtnObj.IdoKedo__longitude__s =Decimal.valueof(lng);  
            return rtnObj;          
        }
        //取引先の場合
        if (sobjectType==Account.getSObjectType().getDescribe().getName()){
            Account rtnObj = new Account();
            rtnObj.id=obj.id;
            rtnObj.BillingLatitude =Decimal.valueof(lat);
            rtnObj.BillingLongitude =Decimal.valueof(lng);  
            return rtnObj;          
        }       
        return null;
    }
    
    
   /**
    * CovertLocationToLatitudeAndLongitude2
    * Google Apiを呼び出して、経度、緯度を算出
    * @param 市区郡ID
    * @return なし
    */    
    public static void CovertLocationToLatitudeAndLongitude2(String sobjectType,list<sobject> objs){
        system.debug('=================setLatitudeAndLongitude begin==========================');
        for (sobject obj:objs){       
            string address=getAddress(obj);
            system.debug('***address=' + address);
            if(address !=''){
                HttpRequest req = new HttpRequest();
                address = EncodingUtil.urlEncode(address,'UTF-8');
                req.setEndPoint('https://maps.googleapis.com/maps/api/geocode/xml?key=AIzaSyCxIYCRdQaHersS3Ew0Qp3TwcHmn6C8yP0&address='+address+'&sensor=true');
                req.setMethod('GET');
                Http http = new Http();
                HttpResponse res;
                if(!Test.isRunningTest()){
                    res = http.send(req);
                }else{
                    String resString = '<GeocodeResponse><status>OK</status><result><geometry><location><lat>37.4217550</lat> <lng>-122.0846330</lng></location>';
                    resString +='</geometry> </result> </GeocodeResponse>';
                    res = new HttpResponse();
                    res.setBody(resString);
                    res.setStatusCode(200);
                }
                Dom.Document doc = res.getBodyDocument();
                Dom.XMLNode geocodeResponse = doc.getRootElement();
                system.debug('***geocodeResponse=' + geocodeResponse);
                if(geocodeResponse!=null){
                    Dom.XMLNode result = geocodeResponse.getChildElement('result',null);
                    system.debug('***result=' + result);
                    if(result!=null){
                        Dom.XMLNode geometry = result.getChildElement('geometry',null);
                        system.debug('***geometry=' + geometry);
                        if(geometry!=null){
                            Dom.XMLNode location = geometry.getChildElement('location',null);                            
                            system.debug('***location=' + location);
                            if(location!=null){
                                String lat = location.getChildElement('lat', null).getText();
                                String lng = location.getChildElement('lng', null).getText();
                                system.debug('***lat=' + lat);
                                system.debug('***lng=' + lng);
                                try{
                                    setLatitudeAndLongitudeToObject2(obj,lat,lng);
                                }catch(Exception ex){
                                    system.debug('Exception '+ex.getMessage());
                                }
                            }
                        }
                    }
                }
                
            }
            system.debug('=================setLatitudeAndLongitude end==========================');
        }
    }   
   /**
    * setLatitudeAndLongitudeToObject
    * 緯度、経度をオブジェクトに設定    
    * @param obj　オブジェクト
    * @param lat　緯度
    * @param lng　経度            
    * @return 緯度経度設定後のオブジェクト
    */       
    public static void setLatitudeAndLongitudeToObject2(sobject obj,string lat,string lng){     
        String sobjectType = obj.getSObjectType().getDescribe().getName(); 
        //市区郡の場合
        if (sobjectType==Shikugun__c.getSObjectType().getDescribe().getName()){
             obj.put('Chiriichijouhou__latitude__s', Decimal.valueof(lat));
             obj.put('Chiriichijouhou__longitude__s', Decimal.valueof(lng));
        }
        //施設の場合
        if (sobjectType==Shisetsu__c.getSObjectType().getDescribe().getName()){
             obj.put('IdoKedo__latitude__s', Decimal.valueof(lat));
             obj.put('IdoKedo__longitude__s', Decimal.valueof(lng));
        }  
        //斎場の場合
        if (sobjectType==Saijo__c.getSObjectType().getDescribe().getName()){
             obj.put('IdoKedo__latitude__s', Decimal.valueof(lat));
             obj.put('IdoKedo__longitude__s', Decimal.valueof(lng));
        }  
        //取引先の場合
        if (sobjectType==Account.getSObjectType().getDescribe().getName()){
            obj.put('BillingLatitude', Decimal.valueof(lat));
            obj.put('BillingLongitude', Decimal.valueof(lng));
        } 
    }     
}