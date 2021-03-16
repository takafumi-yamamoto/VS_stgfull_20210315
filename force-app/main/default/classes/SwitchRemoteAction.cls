public class SwitchRemoteAction {

    public static String keiyakuSimpleRecordTypeId = Schema.SObjectType.Keiyaku__c.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();

    public SwitchRemoteAction(ApexPages.StandardController controller){}

    @RemoteAction
    public static PostalCodeSearchCtl.Result getJSONByPostCD(String postalCode){
        PostalCodeSearchCtl.Result resultAddress = new PostalCodeSearchCtl().getJSONByPostCD(postalCode);
        return resultAddress;
    }

    @RemoteAction
    public static list<Shisetsu__c> rmtActGetShisetsu(String pParam, String shisetsuKubun) {
        list<Shisetsu__c> shisetsuList = new list<Shisetsu__c>();
        if(pParam != '') {
            String soql = 'SELECT Id,Name,ShisetsumeiFurigana__c FROM Shisetsu__c ';
            soql += '            WHERE (Name Like \'%' + pParam + '%\'';
            soql += '            OR ShisetsumeiFurigana__c Like \'%' + pParam + '%\')';
            if(shisetsuKubun == 'kaso'){
                soql += '            AND ShisetsuShubetsu__c IN (\'火葬場\',\'併設\')';
            }
            else{
                soql += '            AND ShisetsuShubetsu__c IN (\'斎場\',\'併設\')';
            }
            soql += '            ORDER BY Name';
            soql += '            LIMIT 10';
            shisetsuList = database.query(soql);
        }
        return shisetsuList;
    }

    @RemoteAction
    public static list<Saijo__c> rmtActGetSaijo(String pParam) {
        list<Saijo__c> saijoList = new list<Saijo__c>();
        if(pParam != '') {
            String soql = 'SELECT Id,Name,KeisaiSaijoMeiKana__c FROM Saijo__c ';
            soql += '            WHERE (Name Like \'%' + pParam + '%\'';
            soql += '            OR KeisaiSaijoMeiKana__c Like \'%' + pParam + '%\'';
            soql += '            OR SeishikiSaijoMei__c Like \'%' + pParam + '%\'';
            soql += '            OR SeishikiSaijoMeiKana__c Like \'%' + pParam + '%\')';
            soql += '            ORDER BY Name';
            soql += '            LIMIT 10';
            saijoList = database.query(soql);
        }
        return saijoList;
    }

    @RemoteAction
    public static list<Keiyaku__c> rmtActGetKonnyusakiSogisha(String pParam) {
        list<Keiyaku__c> keiyakuList = new list<Keiyaku__c>();
        if(pParam != '') {
            String soql = 'SELECT Id, Teikeisaki__c, Teikeisaki__r.Name, Teikeisaki__r.NameYagouFurigana__c, Teikeisaki__r.NameShogo__c, Teikeisaki__r.NameShogoFurigana__c, Teikeisaki__r.BillingState, KeiyakuJokyo__c FROM Keiyaku__c ';
            soql += ' WHERE RecordTypeId = \'' + keiyakuSimpleRecordTypeId + '\'';
            soql += ' AND (Teikeisaki__r.Name Like \'%' + pParam + '%\'';
            soql += ' OR Teikeisaki__r.NameYagouFurigana__c Like \'%' + pParam + '%\'';
            soql += ' OR Teikeisaki__r.NameShogo__c Like \'%' + pParam + '%\'';
            soql += ' OR Teikeisaki__r.NameShogoFurigana__c Like \'%' + pParam + '%\')';
            soql += ' ORDER BY Teikeisaki__r.Name';
            soql += ' LIMIT 10';
            keiyakuList = database.query(soql);
        }
        return keiyakuList;
    }

    @RemoteAction
    public static list<Shisetsu__c> rmtActGetKonnyusakiKasoba(String pParam) {
        list<Shisetsu__c> shisetsuList = new list<Shisetsu__c>();
        if(pParam != '') {
            String soql = 'SELECT Id, Name, State__c FROM Shisetsu__c ';
            soql += ' WHERE ShisetsuShubetsu__c = \'火葬場\'';
            soql += ' AND (Name Like \'%' + pParam + '%\'';
            soql += ' OR ShisetsumeiFurigana__c Like \'%' + pParam + '%\')';
            soql += ' ORDER BY Name';
            soql += ' LIMIT 10';
            shisetsuList = database.query(soql);
        }
        return shisetsuList;
    }

    @RemoteAction
    public static list<Saijo__c> rmtActGetKonnyusakiSaijo(String pParam) {
        list<Saijo__c> saijoList = new list<Saijo__c>();
        if(pParam != '') {
            String soql = 'SELECT Id, Name, ShikugunRef__r.TodoufukenNameExp__c, SeishikiSaijoMei__c FROM Saijo__c ';
            soql += ' WHERE (Name Like \'%' + pParam + '%\'';
            soql += ' OR KeisaiSaijoMeiKana__c Like \'%' + pParam + '%\'';
            soql += ' OR SeishikiSaijoMei__c Like \'%' + pParam + '%\'';
            soql += ' OR SeishikiSaijoMeiKana__c Like \'%' + pParam + '%\')';
            soql += ' ORDER BY Name';
            soql += ' LIMIT 10';
            saijoList = database.query(soql);
        }
        return saijoList;
    }
}