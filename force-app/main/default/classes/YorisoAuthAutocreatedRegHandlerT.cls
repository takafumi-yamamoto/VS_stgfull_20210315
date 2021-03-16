@isTest
public class YorisoAuthAutocreatedRegHandlerT {

    @isTest
    public static void canCreateUser(){
        System.assertEquals(false, new YorisoAuthAutocreatedRegHandler().canCreateUser(null));
        return;
    }

    @isTest
    public static void createUser(){
        User user = [SELECT Email FROM User].get(0);
        Auth.UserData userData;
        
        userData = new Auth.UserData(null, 'test', 'test', 'test', user.Email, null, 'test', 'test', 'testProvider', null, new Map<String,String>() );
        System.assertEquals(user.Id, new YorisoAuthAutocreatedRegHandler().createUser(null, userData).Id);
        
        userData = new Auth.UserData(null, 'test', 'test', 'test', 'xxxx@xx.xx', null, 'test', 'test', 'testProvider', null, new Map<String,String>() );       
        System.assertEquals(null, new YorisoAuthAutocreatedRegHandler().createUser(null, userData));
        
        return;
    }
    
    @isTest
    public static void updateUser(){
        User user = [SELECT Id FROM User].get(0);
        new YorisoAuthAutocreatedRegHandler().updateUser(user.Id, '000000000000000000', null);
        return;
    } 
}