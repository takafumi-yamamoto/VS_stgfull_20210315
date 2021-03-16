public with sharing class Ctl_AccountDeleteHistory {
  /**
   * 取引先削除履歴作成処理
   * @param List<Account> accDelList 取引先リスト
   */
  public void createDeleteHistory(List<Account> accDelList) {
    
    List<AccountDeleteHistory__c> accDelHisList = new List<AccountDeleteHistory__c>();

    // 取引先削除履歴を作成
    for(Account accDel : accDelList){
      AccountDeleteHistory__c accDelHisTemp = new AccountDeleteHistory__c();
      accDelHisTemp.AccountID__c = accDel.Id;

      String nameTemp;
      // 個人取引先の場合
      if(accDel.IsPersonAccount){
        nameTemp = accDel.LastName + ' ' + accDel.FirstName;
      }
      // 個人取引先以外の場合
      else{
        nameTemp = accDel.Name;
      }

      accDelHisTemp.AccountName__c = nameTemp;
/*
      accDelHisTemp.NewID__c = accDel.NewID__c;
      accDelHisTemp.MobilePhone__c = accDel.MobilePhone__c;
      accDelHisTemp.TicketNumber__c = accDel.TicketNumber__c;
      accDelHisTemp.SMSHistoryType__c = accDel.SMSHistoryType__c;
      accDelHisTemp.QuoObou__c = accDel.QuoObou__c;
      accDelHisTemp.Phonetic__c = accDel.Phonetic__c;
      accDelHisTemp.Seibetsu__c = accDel.Seibetsu__c;
      accDelHisTemp.OneDADMTransmissionFlg__c = accDel.OneDADMTransmissionFlg__c;
      accDelHisTemp.TestFlg__c = accDel.TestFlg__c;
      accDelHisTemp.NewsletterDelflg__c = accDel.NewsletterDelflg__c;
      accDelHisTemp.BirthDay__c = accDel.BirthDay__c;
      accDelHisTemp.BonDMTransmissionFlg__c = accDel.BonDMTransmissionFlg__c;
      accDelHisTemp.SecondDADMTransmissionFlg__c = accDel.SecondDADMTransmissionFlg__c;
      accDelHisTemp.BillingCountry__c = accDel.BillingCountry;
      accDelHisTemp.BillingPostalCode__c = accDel.BillingPostalCode;
      accDelHisTemp.BillingState__c = accDel.BillingState;
      accDelHisTemp.BillingCity__c = accDel.BillingCity;
      accDelHisTemp.BillingStreet__c = accDel.BillingStreet;
      accDelHisTemp.ZipCodeInadequacy__c = accDel.ZipCodeInadequacy__c;
      accDelHisTemp.Phone__c = accDel.Phone;
      accDelHisTemp.Fax__c = accDel.Fax;
      accDelHisTemp.MailAddress__c = accDel.MailAddress__c;
      accDelHisTemp.MailAddress2__c = accDel.MailAddress2__c;
      accDelHisTemp.Remarks__c = accDel.Remarks__c;
      accDelHisTemp.A_DMfutou_c__c = accDel.A_DMfutou_c__c;
      accDelHisTemp.BankName__c = accDel.BankName__c;
      accDelHisTemp.BankOffice__c = accDel.BankOffice__c;
      accDelHisTemp.BankKamoku__c = accDel.BankKamoku__c;
      accDelHisTemp.BankMeigi__c = accDel.BankMeigi__c;
      accDelHisTemp.BankNumber__c = accDel.BankNumber__c;
*/
      accDelHisList.add(accDelHisTemp);
    }
    
    List<Database.Saveresult> results = Database.insert(accDelHisList, false);

    Integer i = 0;
       for(Database.Saveresult res : results) {
      if (!res.isSuccess()) {
        for(Database.Error err : res.getErrors()) {
          accDelList[i].addError('取引先削除履歴データ作成時にエラーが発生しました。' + err.getMessage());
        }
      }

      i++;
    }
  }

}