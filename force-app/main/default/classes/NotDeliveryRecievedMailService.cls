/**
 * 不達メールを受信時にエラーハンドリングするためのクラス
 * 　受信したメールの内容からケースとの紐づけ、添付ファイルの挿入を行う。
 */
global class NotDeliveryRecievedMailService implements Messaging.InboundEmailHandler{
  
  global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

    //メールの添付ファイルからケースIDを取得してもとのケースに紐付ける
    // メール本文を格納する文字列変数
    String theBody;

    // メールの添付ファイル格納用
    List<Attachment> atts = new List<Attachment>();
    List<Messaging.Inboundemail.Binaryattachment> batts = email.binaryAttachments;
    List<Messaging.Inboundemail.TextAttachment> tatts = email.textAttachments;

    //紐づき元のケースID
    Id targetCaseId;

    try{
      //バイナリの添付ファイルの処理
      if (batts != null && batts.size() > 0){
        for (Messaging.Inboundemail.Binaryattachment batt: batts){
          Attachment att = new Attachment();
          // ファイル名を設定
          att.name = batt.fileName;
          // ファイルの内容を設定
          att.Body = batt.body;

          atts.add(att);
        }
      }
      //テキストの添付ファイルの処理
      if (tatts != null && tatts.size() > 0){
        for (Messaging.Inboundemail.TextAttachment tatt: tatts){
          //元のメール本文が書かれている添付ファイルの場合
          if('ForwardedAttachment_1.txt'.equals(tatt.fileName)){
            //ケースのスレッドIDを抽出し、紐づき先のケースのIDを取得する
            String refAfterStr = tatt.body.substringAfterLast('ref:');
            if(!String.isBlank(refAfterStr)){
              String caseThredId = refAfterStr.replace(':ref', '');
              targetCaseId = Cases.getCaseIdFromEmailThreadId(caseThredId);
            }
          }
          Attachment att = new Attachment();
          // ファイル名を設定
          att.name = tatt.fileName;
          // ファイルの内容を設定
          att.Body = blob.valueOf(tatt.body);

          att.ContentType = 'text/plain; charset= UTF-8'; 

          atts.add(att);
        }
      }
      //CaseIDが取得できなかった場合、新規にケースを作成する
      if(targetCaseId == null){
        Case targetCase = new Case();
        targetCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Mail').getRecordTypeId();
        targetCase.Subject = email.Subject;
        insert targetCase;
        targetCaseId = targetCase.Id;
      }
      //Task作成
      Task emailTask = new Task();
      emailTask.ActivityDate = System.today();
      //受信メールがテキスト形式の場合
      if (email.plainTextBody != null){
        theBody = email.plainTextBody;
      //受信メールがテキスト形式ではない(HTML形式)
      } else {
        theBody = email.htmlBody;
      }
      emailTask.Description = theBody;
      emailTask.Status = '完了';
      emailTask.Subject = email.subject;
      emailTask.TaskSubtype = 'Email';
      emailTask.WhatId = targetCaseId;
      insert emailTask;

      //EmailMessage作成
      EmailMessage emsg = new EmailMessage();
      emsg.Incoming = true;
      emsg.Subject = email.subject;
      emsg.MessageDate  = System.now();
      emsg.FromAddress = email.fromAddress;
      emsg.ToAddress = String.join(email.toAddresses, ',');
      emsg.HtmlBody = email.htmlBody;
      emsg.TextBody = theBody;
      emsg.ParentId = targetCaseId;
      insert emsg;
      
      //Attachment(添付ファイルオブジェクト)にParentIDを設定
      for(Attachment att:atts){
        att.ParentId = emsg.Id;
      }
      insert atts;
      result.success = true;

    }catch(Exception e){
      System.Debug(e.getMessage());
      result.success = false;
      
    }

    return result;
  }
  
}