global class YorisoAuthAutocreatedRegHandler implements Auth.RegistrationHandler{
    global boolean canCreateUser(Auth.UserData data) {
        return false;
    }

    global User createUser(Id portalId, Auth.UserData data){             
        try{
            deActivates();
        
            //アカウント有効化　ThirdPartyAccountLinkは自動で作成
            List<User> users = [select Id, isActive from User where Email = :data.email];
            if(users.size() > 0){
                User user = users.get(0);
                user.isActive = true;
                update user;            
                return user;
            }
        }
        catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181128-1742-01', 'licenseManagement')
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
        }
        return null;
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){               
        try{
            deActivates();
        
            //アカウント有効化
            List<User> users = [select Id, isActive from User where Id = :userId];
            if(users.size() > 0){
                User user = users.get(0);
                user.isActive = true;
                update user;
            }
        }
        catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181128-1742-02', 'licenseManagement')
                    .putAttr( 'e.getMessage()', e.getMessage() )
            );
        }
        return;
    }

    //  アカウント無効化
    //  CS一般の画面ログインが期限切れになったユーザーを非有効にします
    private void deActivates() {
        List<User> deActiveUsers = [
            SELECT Id, Name, IsActive, Email
            FROM User
                WHERE IsActive = true 
                AND JidoMukokaSuru__c = true 
                AND Id NOT IN (
                    SELECT UsersId
                    FROM AuthSession 
                    WHERE SessionType IN ('UI')
                )
        ];
            
        for (User deActiveUser : deActiveUsers) {
            deActiveUser.isActive = false;
        }
        
        //update deActiveUsers;
        List<Database.SaveResult> res_lists = Database.update(deActiveUsers, false);
        Integer i = 0;
        for (Database.SaveResult res : res_lists) {
          if(!res.isSuccess()){
            for(Database.Error e : res.getErrors()) {
                Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error, '20181221-1652-03', 'licenseManagement')
                    .putAttr( 'e.getMessage()', 'レコードID:' + deActiveUsers.get(i).Id + ' エラーメッセージ:' + e.getMessage() )
                );
            }
          }
          i++;
        }
    }
}