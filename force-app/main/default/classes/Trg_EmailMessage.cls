/**
 * メール・メッセージトリガーハンドラー
 * ・メール-to-ケースで受けたメールの内容により、ケースの項目を更新する
 * ・メール-to-ケースで送信するときに不達フラグをはずす
 */
public class Trg_EmailMessage {

    public void OnAfterInsert(List<EmailMessage> newList){
        new MailToCaseHandler().caseUpdate(newList);

	}

    public void OnAfterUpdate(List<EmailMessage> newList, Map<Id, EmailMessage> oldMap){
        new MailToCaseHandler().copySendMail(newList,oldMap);
    }
}