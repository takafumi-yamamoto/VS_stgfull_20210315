/**
* クラス名           :   Trg_ShisetsuTest
* クラス概要       :   施設トリガーハンドラー.テストクラス
* @created  :   2018/01/05
* @modified :   
*/

@isTest
public class Trg_ShisetsuTest {
    
    @isTest(SeeAllData=true)
    public static void OnInsert(){
        Shikugun__c theShikugun = [
            SELECT id from Shikugun__c limit 1
        ].get(0);

        Insert new Shisetsu__c(
            ShisetsuShubetsu__c='斎場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            Shikugun__c =theShikugun.Id,
            KoeiMinei__c='自社'
        );
    }

    @isTest(SeeAllData=true)
    public static void OnUpdate(){
        Shikugun__c theShikugun = [
            SELECT id from Shikugun__c limit 1
        ].get(0);

        Shisetsu__c theShisetsu = new Shisetsu__c(
            ShisetsuShubetsu__c='斎場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            Shikugun__c =theShikugun.Id,
            KoeiMinei__c='自社'
        );
        Insert theShisetsu;

        Update new Shisetsu__c(
            Id = theShisetsu.Id,
            ShisetsuShubetsu__c = '火葬場'
        );
    }

    @isTest(SeeAllData=true)
    public static void OnDelete(){
        Shikugun__c theShikugun = [
            SELECT id from Shikugun__c limit 1
        ].get(0);

        Shisetsu__c theShisetsu = new Shisetsu__c(
            ShisetsuShubetsu__c='斎場',
            Name='テスト用００１',
            State__c='東京都',
            City__c='中央区',
            Street__c='2-2-2',
            PostalCode__c='335-0016',
            Shikugun__c =theShikugun.Id,
            KoeiMinei__c='自社'
        );
        Insert theShisetsu;

        Delete theShisetsu;
    }

    // private static Map<String,String> mapHeaderResponse;
    // static {
    // 	mapHeaderResponse = new Map<String,String>();
    // 	mapHeaderResponse.put('Content-Type', 'text/xml;charset=UTF-8');
    // }	
    // static void Test1() {
        
    //     //都道府県
    //     TodoufuKen__c TodoufuKen = new TodoufuKen__c();
    //     TodoufuKen.name='東京都';
    //     insert TodoufuKen;
    //     //市区郡
    //     Shikugun__c Shikugun=new Shikugun__c();
    //     Shikugun.Name='中央区';
    //     Shikugun.TodoufuKenRef__c=TodoufuKen.id;
    //     insert Shikugun;   
        
    //     TriggerIsActive__c TriggerIsActive = new TriggerIsActive__c();
    //     TriggerIsActive.name='default';
    //     TriggerIsActive.isActive__c=true;
    //     insert TriggerIsActive;     
                  
    //     Test.startTest(); 
    //     Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());   
    //     //施設
    //     Shisetsu__c Shisetsu1=new Shisetsu__c();
    //     Shisetsu1.ShisetsuShubetsu__c='斎場';        
    //     Shisetsu1.Name='テスト用００１';
    //     Shisetsu1.State__c='東京都';
    //     Shisetsu1.City__c='中央区';
    //     Shisetsu1.Street__c='2-2-2';
    //     Shisetsu1.PostalCode__c='335-0016';
    //     Shisetsu1.Shikugun__c=Shikugun.id;
    //     shisetsu1.KoeiMinei__c='自社';
    //     insert Shisetsu1;
        
    //     Shisetsu__c Shisetsu2=new Shisetsu__c();
    //     Shisetsu2.ShisetsuShubetsu__c='火葬場';        
    //     Shisetsu2.Name='テスト用００2';
    //     Shisetsu2.State__c='東京都';
    //     Shisetsu2.City__c='中央区';
    //     Shisetsu2.Street__c='2-2-2';
    //     Shisetsu2.PostalCode__c='335-0016';
    //     Shisetsu2.Shikugun__c=Shikugun.id;
    //     shisetsu2.KoeiMinei__c='民営';
    //     insert Shisetsu2;
        
    //     Shisetsu__c Shisetsu3=new Shisetsu__c();
    //     Shisetsu3.ShisetsuShubetsu__c='併設';        
    //     Shisetsu3.Name='テスト用００３';
    //     Shisetsu3.State__c='東京都';
    //     Shisetsu3.City__c='中央区';
    //     Shisetsu3.Street__c='2-2-2';
    //     Shisetsu3.PostalCode__c='335-0016';
    //     Shisetsu3.Shikugun__c=Shikugun.id;
    //     Shisetsu3.Chushadaisu__c=3;
    //     Shisetsu3.Anchika__c=true;
    //     shisetsu3.ShinzokuHikaeshitsuAri__c=true;
    //     shisetsu3.SimpleKeisai__c=true;
    //     shisetsu3.ZenShuhaTaioKa__c=true;
    //     shisetsu3.ShawaRoomAri__c=true;
    //     shisetsu3.ShukuhakuKa__c=true;
    //     shisetsu3.KoeiMinei__c='公営';
    //     shisetsu3.AnchiMenkaiKa__c=true;
    //     shisetsu3.TsukisoiAnchiKa__c=true;
    //     shisetsu3.KizzuRoomAri__c=true;
    //     shisetsu3.BebiRoomAri__c=true;
    //     shisetsu3.HoyoKa__c=true;
    //     shisetsu3.KasoshikiKa__c=true;
    //     shisetsu3.IchinichisoKa__c=true;
    //     shisetsu3.KazokusoKa__c=true;
    //     shisetsu3.IppansoKa__c=true;
    //     shisetsu3.SogiRebiKeisai__c=true;
    //     shisetsu3.Bariafuri__c=true;
    //     insert Shisetsu3;     
    //     //施設更新
    //     Shisetsu1.Fax__c='050-555-5555';
    //     update Shisetsu1;
    //     Shisetsu2.ShinzokuHikaeNonResidentPrice__c='100';
    //     //Shisetsu3.KoeiMinei__c='寺院';
    //     update Shisetsu2;
    //     Shisetsu3.ShinzokuHikaeNonResidentPrice__c='100';
    //     //Shisetsu3.KoeiMinei__c='民営';
    //     update Shisetsu3;

    //     delete Shisetsu3;
        
    //     Test.stopTest();
    // }
}