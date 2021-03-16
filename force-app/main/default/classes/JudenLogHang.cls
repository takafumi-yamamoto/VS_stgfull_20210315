public class JudenLogHang {
  /**
   * 取引先紐づけ処理
   * 発信電話番号と一致する取引先にToDOを紐づける
   *
   * @Auther yamamoto
   * @param List<Task> ToDoリスト
   */
   /**
  public void phoneNumerBinding(List<Task> newTaskList){
    
    List<String> phoneNumerNoHyphenList = new List<String>();
    List<Task> targetTaskList = new List<Task>();
    for(Task newTask : newTaskList){
      if(newTask.WhoId == Label.SysBiztelLeadData){
        phoneNumerNoHyphenList.add(newTask.B_PhoneFrom__c.replace('-',''));
        targetTaskList.add(newTask);
      }
    }

    // 電話番号マップ(キー：電話番号、値：取引先リスト(重複を考慮してリスト型))
    Map<String, List<ID>> accountPhoneMap = new Map<String, List<ID>>();
    // 携帯電話番号マップ(キー：携帯電話番号、値：取引先リスト(重複を考慮してリスト型))
    Map<String, List<ID>> accountMobilePhoneMap = new Map<String, List<ID>>();

    String accountWhere = ' where PhoneFormula__c = :phoneNumerNoHyphenList or MobilePhoneFormula__c = :phoneNumerNoHyphenList ';
    String accountOrderBy = ' order by MobilePhoneFormula__c';
    for(Account accountPhoneNumer : Dao_Account.getAccountListByPhoneNumber(accountWhere, phoneNumerNoHyphenList, accountOrderBy)){

      // 電話番号に一致する取引先を格納する
      List<ID> accountPhoneDuplicateIdList = new List<ID>();
      if(accountPhoneMap.containsKey(accountPhoneNumer.PhoneFormula__c)){
        accountPhoneDuplicateIdList = accountPhoneMap.get(accountPhoneNumer.PhoneFormula__c);
      }
      accountPhoneDuplicateIdList.add(accountPhoneNumer.PersonContactId);
      accountPhoneMap.put(accountPhoneNumer.PhoneFormula__c, accountPhoneDuplicateIdList);
      
      // 携帯電話番号に一致する取引先を格納する
      List<ID> accountMobilePhoneDuplicateIdList = new List<ID>();
      if(accountMobilePhoneMap.containsKey(accountPhoneNumer.MobilePhoneFormula__c)){
        accountMobilePhoneDuplicateIdList = accountMobilePhoneMap.get(accountPhoneNumer.MobilePhoneFormula__c);
      }
      accountMobilePhoneDuplicateIdList.add(accountPhoneNumer.PersonContactId);
      accountMobilePhoneMap.put(accountPhoneNumer.MobilePhoneFormula__c, accountMobilePhoneDuplicateIdList);
    }

    for(Task targetTask : targetTaskList){
      String phoneNumerNoHyphenTemp = targetTask.B_PhoneFrom__c.replace('-','');
      List<ID> accountIdListTemp = new List<ID>();
      if(accountPhoneMap.containsKey(phoneNumerNoHyphenTemp)){
        accountIdListTemp = accountPhoneMap.get(phoneNumerNoHyphenTemp);
      }
      else if(accountMobilePhoneMap.containsKey(phoneNumerNoHyphenTemp)){
        accountIdListTemp = accountMobilePhoneMap.get(phoneNumerNoHyphenTemp);
      }

      // 一致する取引先がない場合はスキップ
      if(accountIdListTemp.size() == 0){
        continue;
      }
      // 取引先が1件の場合は紐づける
      else if(accountIdListTemp.size() == 1){
        targetTask.WhoId = accountIdListTemp.get(0);
      }
      // 上記以外はメールで詳細を通知する
      else{
        String strToAddres = Label.DuplicationAccount_Contact_Address;
        String strSubject = '【BIZTEL関連システムアラートメール】通話録音データの自動紐付け処理にて要確認事項が発生';

        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String strText = '下記の通話録音データに関して、複数のお客様情報に同一の電話番号が登録されているため、自動紐付け処理ができません。\r\n' + 
                  'データを確認し、手動での紐付け作業を実施してください。\r\n' + 
                  '\r\n' + 
                  '■通話録音データ\r\n' + 
                  '発信電話番号:' + targetTask.B_PhoneFrom__c + '\r\n' + 
                  '\r\n' + 
                  '■お客様データ\r\n';

        for(ID accountIdList : accountIdListTemp){
          strText += baseUrl + '/' + accountIdList + '\r\n';
        }

        if(!Dao_Organization.getOrganization().IsSandbox) Utility_Common.sendEmail(strToAddres, strSubject, strText);
      }
    }
  }


  public void todoHang(List<Account> newAccountList, Map<ID, Account> oldAccountMap){

    List<String> phoneNumberList = new List<String>();
    Map<String, ID> phoneNumberAccountIdMap = new Map<String, ID>();
    for(Account newAccount : newAccountList){
      Account oldAccountTemp;

      // 新規作成の場合
      if(oldAccountMap == null){
        oldAccountTemp = null;
      }
      // 更新の場合
      else{
        oldAccountTemp = oldAccountMap.get(newAccount.Id);
      }
      
      if(oldAccountTemp == null || (newAccount.PhoneFormula__c != oldAccountTemp.PhoneFormula__c || newAccount.MobilePhoneFormula__c != oldAccountTemp.MobilePhoneFormula__c)){
        if(newAccount.PhoneFormula__c != null){
          phoneNumberAccountIdMap.put(newAccount.PhoneFormula__c, newAccount.PersonContactId);
        }

        if(newAccount.MobilePhoneFormula__c != null){
          phoneNumberAccountIdMap.put(newAccount.MobilePhoneFormula__c, newAccount.PersonContactId);
        }
      }
    }

    String taskWhere = ' where WhoId = :LabelSysBiztelLeadData and B_PhoneFromFormula__c = :phoneNumberSet ';
    List<Task> taskUpList = new List<Task>();
    for(Task taskPhoneNumber : Dao_Task.getTaskListByPhoneNumber(taskWhere, Label.SysBiztelLeadData, phoneNumberAccountIdMap.keySet())){
      if(phoneNumberAccountIdMap.containsKey(taskPhoneNumber.B_PhoneFromFormula__c)){
        taskPhoneNumber.WhoId = phoneNumberAccountIdMap.get(taskPhoneNumber.B_PhoneFromFormula__c);
        taskUpList.add(taskPhoneNumber);
      }
    }

    update taskUpList;
  }
*/
}