public class SogiShiryoSakuseiKekkaTsuchi {
    
    private static String rtSimpleYasugoShiryoSeikyuWebFormId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId();
    private static String rtSimpleYasugoEndingnoteWebForm = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoEndingnoteWebForm').getRecordTypeId();

    public static void OnAfterUpdate(List<SogiShiryoSakuseiKekka__c> newList, Map<Id, SogiShiryoSakuseiKekka__c> oldMap){
        for(SogiShiryoSakuseiKekka__c kekka : [select Id, 
                                                        StatusCode__c, 
                                                        (select Id, 
                                                                AutoShiryoSofuMailSend__c, 
                                                                SofuJokyo__c, 
                                                                SofuNichiji__c, 
                                                                Atena__c, 
                                                                Mail__c, 
                                                                PassWord__c, 
                                                                SofuShiryoURL__c, 
                                                                PdfAutoCreateErrMsg__c, 
                                                                InsatsubutsuIchiran__c, 
                                                                OpportunityRef__c, 
                                                                OpportunityRef__r.RecordType.DeveloperName, 
                                                                OpportunityRef__r.StageName, 
                                                                OpportunityRef__r.AccountId, 
                                                                OpportunityRef__r.Account.PersonContactId, 
                                                                OpportunityRef__r.CaseRef__r.RecordType.DeveloperName, 
                                                                OpportunityRef__r.CaseRef__r.Lastname__c, 
                                                                OpportunityRef__r.CaseRef__r.Firstname__c, 
                                                                OpportunityRef__r.CaseRef__r.LastNameKana__c, 
                                                                OpportunityRef__r.CaseRef__r.FirstNameKana__c, 
                                                                OpportunityRef__r.CaseRef__r.KeitaiDenwa__c, 
                                                                OpportunityRef__r.CaseRef__r.TelNo__c, 
                                                                OpportunityRef__r.CaseRef__r.Jusho__c, 
                                                                OpportunityRef__r.CaseRef__r.ShiryoSoufuHoho__c, 
                                                                OpportunityRef__r.CaseRef__r.MailAddress__c, 
                                                                OpportunityRef__r.CaseRef__r.SalesforceOrgURL__c, 
                                                                OpportunityRef__r.CaseRef__r.DuplicationCheckAccountUrl__c, 
                                                                OpportunityRef__r.CaseRef__r.AddressConfirmInfo__c, 
                                                                OpportunityRef__r.CaseRef__r.uniq_id__c, 
                                                                OpportunityRef__r.CaseRef__r.KiboAreaState__c, 
                                                                OpportunityRef__r.CaseRef__r.KiboAreaCity__c, 
                                                                OpportunityRef__r.CaseRef__r.TaishoshaKyojuKeitai__c, 
                                                                OpportunityRef__r.CaseRef__r.WebShiryoSeikyuTaishoushaJokyo__c, 
                                                                OpportunityRef__r.CaseRef__r.TaishoshaYomeiKikan__c, 
                                                                OpportunityRef__r.CaseRef__r.ToiawaseKiinsha__c, 
                                                                OpportunityRef__r.CaseRef__r.EndingNoteFlg__c, 
                                                                OpportunityRef__r.CaseRef__r.ToiawaseDate__c, 
                                                                OpportunityRef__r.CaseRef__r.MailArrivalTime__c, 
                                                                OpportunityRef__r.CaseRef__r.PostalCode__c, 
                                                                OpportunityRef__r.CaseRef__r.State__c, 
                                                                OpportunityRef__r.CaseRef__r.City__c, 
                                                                OpportunityRef__r.CaseRef__r.Street__c, 
                                                                OpportunityRef__r.CaseRef__r.RecordTypeId, 
                                                                OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c, 
                                                                LastModifiedById, 
                                                                LastModifiedBy.LastName 
                                                            from SogiShiryoSofus__r) 
                                                from SogiShiryoSakuseiKekka__c 
                                                where Id = :newList]){
            if(kekka.StatusCode__c == null || kekka.StatusCode__c == '') continue;
            
            SogiShiryoSofu__c shiryoSofu = kekka.SogiShiryoSofus__r.get(0);
            if(!shiryoSofu.AutoShiryoSofuMailSend__c) postFeedItem(kekka);
            if(shiryoSofu.LastModifiedBy.LastName == 'Process') sendMailShiryoSofuAdmin(shiryoSofu);
            if((kekka.StatusCode__c == '200' || kekka.StatusCode__c == '402') && shiryoSofu.AutoShiryoSofuMailSend__c) sendMailSogiShiryoSofu(shiryoSofu);
        }
    }

    private static void sendMailSogiShiryoSofu(SogiShiryoSofu__c pShiryoSofu){

        YorisoNoOsoshikiShiryoSofuUrlMail.CreateMailArg theArgUrl = new YorisoNoOsoshikiShiryoSofuUrlMail.CreateMailArg();
        theArgUrl.atena = pShiryoSofu.Atena__c;
        theArgUrl.mailaddress = pShiryoSofu.Mail__c;
        theArgUrl.pdfUrl = pShiryoSofu.SofuShiryoURL__c;
        theArgUrl.passWord = pShiryoSofu.PassWord__c;
        INSERT new YorisoNoOsoshikiShiryoSofuUrlMail().createMail(theArgUrl);

        update new Account(Id = pShiryoSofu.OpportunityRef__r.AccountId, JizenwariShoshoHassoDate__c = date.today());

        pShiryoSofu.SofuJokyo__c = '送付済';
        pShiryoSofu.SofuNichiji__c = datetime.now();
        upsert pShiryoSofu;
    }

    private static void postFeedItem(SogiShiryoSakuseiKekka__c kekka){
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        
        if(kekka.SogiShiryoSofus__r.size() > 0){
            try{
                SogiShiryoSofu__c sofu = kekka.SogiShiryoSofus__r.get(0);
                //メンション先
                mentionSegmentInput.id = sofu.LastModifiedById;
                messageBodyInput.messageSegments.add(mentionSegmentInput);
                
                //本文
                String textBody = '\r\n';
                if(kekka.StatusCode__c == '200' || kekka.StatusCode__c == '402') { textBody += '資料の作成が完了しました。'; }
                else { textBody += '資料の作成に失敗しました。'; }
                textBody += '\r\n';
                textBody += URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/SogiShiryoSofu__c/' + sofu.Id + '/view?0.source=alohaHeader';

                textSegmentInput.text = textBody;
                messageBodyInput.messageSegments.add(textSegmentInput);
                feedItemInput.body = messageBodyInput;
                //投稿先
                feedItemInput.subjectId = sofu.LastModifiedById;
                ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);
            }
            catch(Exception e){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error, '20200807-1120-01', '葬儀資料作成結果通知')
                    .putAttr('theResult.descr', e.getMessage())
                );
            }
        }
    }

    public static void sendMailShiryoSofuAdmin(SogiShiryoSofu__c pShiryoSofu){
        String tempTitle = '';
        String tempChuiMsg = '';
        String tempJidoShiryoSofuKekka = '送信されました。';
        if(pShiryoSofu.PdfAutoCreateErrMsg__c != null){
            tempTitle = '【要確認】';
            tempJidoShiryoSofuKekka = '以下の理由により送信されませんでした。' + '\n';
            tempJidoShiryoSofuKekka += pShiryoSofu.PdfAutoCreateErrMsg__c;
        }

        if(pShiryoSofu.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoShiryoSeikyuWebFormId){
            YorisoNoOsoshikiShiryoSeikyuAdminMail.CreateMailArg theMail = new YorisoNoOsoshikiShiryoSeikyuAdminMail.CreateMailArg();
            tempTitle += '【よりそうのお葬式】資料請求の申し込み：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.uniq_id__c;
            if(pShiryoSofu.OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c == '健在'){
                if(pShiryoSofu.OpportunityRef__r.CaseRef__r.ShiryoSoufuHoho__c.startsWith('メール')){
                    tempChuiMsg = '※3分コール、到着確認℡はしないでください。' + '\n' + 
                                    '※資料はメールで自動送信されています。' + '\n' + 
                                    '※資料送付が「メール希望（自動）」、対象者の状態が「健在」になっていることを確認してください。' + '\n';
                }
                if(pShiryoSofu.OpportunityRef__r.CaseRef__r.ShiryoSoufuHoho__c == '郵送希望'){
                    tempChuiMsg = '※郵送希望、状態が健在のお客様です。' + '\n' + 
                                    '※3分コールをせず、資料作成をしてください。' + '\n';
                }
            }
            theMail.title = tempTitle;
            theMail.salesforceOrgURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Opportunity/' + pShiryoSofu.OpportunityRef__c + '/view';
            theMail.jidoShiryoSofuKekka = tempJidoShiryoSofuKekka;
            theMail.duplicationCheckAccountUrl = pShiryoSofu.OpportunityRef__r.CaseRef__r.DuplicationCheckAccountUrl__c;
            theMail.addressConfirmInfo = pShiryoSofu.OpportunityRef__r.CaseRef__r.AddressConfirmInfo__c;
            theMail.chuiMsg = tempChuiMsg;
            theMail.uniq_id = pShiryoSofu.OpportunityRef__r.CaseRef__r.uniq_id__c;
            theMail.kiboAreaState = pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaState__c;
            theMail.kiboAreaCity = pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaCity__c;
            theMail.taishoshaKyojuKeitai = pShiryoSofu.OpportunityRef__r.CaseRef__r.TaishoshaKyojuKeitai__c;
            theMail.taishoushaJokyo = pShiryoSofu.OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c;
            theMail.webShiryoSeikyuTaishoushaJokyo = pShiryoSofu.OpportunityRef__r.CaseRef__r.WebShiryoSeikyuTaishoushaJokyo__c;
            theMail.taishoshaYomeiKikan = pShiryoSofu.OpportunityRef__r.CaseRef__r.TaishoshaYomeiKikan__c;
            theMail.toiawaseKiinsha = pShiryoSofu.OpportunityRef__r.CaseRef__r.ToiawaseKiinsha__c;
            theMail.endingNoteFlg = pShiryoSofu.OpportunityRef__r.CaseRef__r.EndingNoteFlg__c;
            theMail.toiawaseDate = String.valueOf(pShiryoSofu.OpportunityRef__r.CaseRef__r.ToiawaseDate__c);
            INSERT new YorisoNoOsoshikiShiryoSeikyuAdminMail().createMail(theMail);

            insert new Task(
                RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId(), 
                WhoId = pShiryoSofu.OpportunityRef__r.Account.PersonContactId, 
                WhatId = pShiryoSofu.OpportunityRef__c, 
                Status = '完了', 
                Subject = '', 
                TaskSubtype = 'Call', 
                ServiceType__c = pShiryoSofu.OpportunityRef__r.RecordType.DeveloperName, 
                ShiborikomiJoken__c = '問合せ受付：お客様情報一時聴取/入力中', 
                YokenSyubetsu__c = '事務作業', 
                Description = tempTitle + '\n' + 
                                '\n' + 
                                'よりそうのお葬式の資料請求フォームから' + '\n' + 
                                'お申し込みがありました。' + '\n' + 
                                '\n' + 
                                '以下のURLから対応を開始してください。' + '\n' + 
                                URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Opportunity/' + pShiryoSofu.OpportunityRef__c + '/view' + '\n' + 
                                '\n' + 
                                '▼自動資料送付結果' + '\n' + 
                                tempJidoShiryoSofuKekka + '\n' + 
                                '\n' + 
                                '▼重複の可能性のある取引先' + '\n' + 
                                conversionNullNashi(pShiryoSofu.OpportunityRef__r.CaseRef__r.DuplicationCheckAccountUrl__c) + '\n' + 
                                '\n' + 
                                '▼住所注意事項' + '\n' + 
                                conversionNullNashi(pShiryoSofu.OpportunityRef__r.CaseRef__r.AddressConfirmInfo__c) + '\n' + 
                                '\n' + 
                                '以下、お申し込み内容' + '\n' + 
                                '------------------------------------------------' + '\n' + 
                                '受付番号：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.uniq_id__c + '\n' + 
                                '\n' + 
                                'お名前：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.Lastname__c + ' ' + pShiryoSofu.OpportunityRef__r.CaseRef__r.Firstname__c + '(' + pShiryoSofu.OpportunityRef__r.CaseRef__r.LastNameKana__c + ' ' + pShiryoSofu.OpportunityRef__r.CaseRef__r.FirstNameKana__c + ')' + '\n' +
                                '\n' + 
                                '連絡先電話番号：' + conversionNullKuran(pShiryoSofu.OpportunityRef__r.CaseRef__r.KeitaiDenwa__c) + conversionNullKuran(pShiryoSofu.OpportunityRef__r.CaseRef__r.TelNo__c) + '\n' + 
                                '\n' + 
                                'メールアドレス：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.MailAddress__c + '\n' + 
                                '\n' + 
                                'お葬式をお考えの地域：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaState__c + pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaCity__c + '\n' + 
                                '\n' + 
                                '対象者様居住状態（初回）：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.TaishoshaKyojuKeitai__c + '\n' + 
                                '\n' + 
                                '対象者様のご状態（初回）：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.TaishoushaJokyo__c + '\n' + 
                                '\n' + 
                                '対象者様のご状況：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.WebShiryoSeikyuTaishoushaJokyo__c + '\n' + 
                                '\n' + 
                                '余命期間（初回）：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.TaishoshaYomeiKikan__c + '\n' + 
                                '\n' + 
                                '問い合わせ起因者（初回）：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.ToiawaseKiinsha__c + '\n' + 
                                '\n' + 
                                'エンディングノート：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.EndingNoteFlg__c + '\n' + 
                                '------------------------------------------------' + '\n'
                                ,
                OwnerId = DefaultOwner.getOwnerId()
            );
        }
        if(pShiryoSofu.OpportunityRef__r.CaseRef__r.RecordTypeId == rtSimpleYasugoEndingnoteWebForm){
            YorisoNoOsoshikiEndingNoteAdminMail.CreateMailArg theMail = new YorisoNoOsoshikiEndingNoteAdminMail.CreateMailArg();
            tempTitle += '【よりそうのお葬式】エンディングノートの申し込み：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.uniq_id__c;
            theMail.title = tempTitle;
            theMail.mailArrivalTime = pShiryoSofu.OpportunityRef__r.CaseRef__r.MailArrivalTime__c;
            theMail.salesforceOrgURL = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Opportunity/' + pShiryoSofu.OpportunityRef__c + '/view';
            theMail.jidoShiryoSofuKekka = tempJidoShiryoSofuKekka;
            theMail.duplicationCheckAccountUrl = pShiryoSofu.OpportunityRef__r.CaseRef__r.DuplicationCheckAccountUrl__c;
            theMail.addressConfirmInfo = pShiryoSofu.OpportunityRef__r.CaseRef__r.AddressConfirmInfo__c;
            theMail.uniq_id = pShiryoSofu.OpportunityRef__r.CaseRef__r.uniq_id__c;
            theMail.kiboAreaState = pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaState__c;
            theMail.kiboAreaCity = pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaCity__c;
            theMail.toiawaseDate = String.valueOf(pShiryoSofu.OpportunityRef__r.CaseRef__r.ToiawaseDate__c);
            INSERT new YorisoNoOsoshikiEndingNoteAdminMail().createMail(theMail);

            insert new Task(
                RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Tsujo').getRecordTypeId(), 
                WhoId = pShiryoSofu.OpportunityRef__r.Account.PersonContactId, 
                WhatId = pShiryoSofu.OpportunityRef__r.Id, 
                Status = '完了', 
                Subject = '', 
                TaskSubtype = 'Call', 
                ServiceType__c = pShiryoSofu.OpportunityRef__r.RecordType.DeveloperName, 
                ShiborikomiJoken__c = '問合せ受付：お客様情報一時聴取/入力中', 
                YokenSyubetsu__c = '事務作業', 
                Description = tempTitle + '\n' + 
                                '\n' + 
                                'よりそうのお葬式のエンディングノート申込みフォームから' + '\n' + 
                                'お申し込みがありました。' + '\n' + 
                                '\n' + 
                                'メールの到着時間帯：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.MailArrivalTime__c + '\n' + 
                                '\n' + 
                                '＝■＝■＝■＝■＝■＝■＝【 エンディングノート＋資料請求 のみ 】＝■＝■＝■＝■＝■＝■＝' + '\n' + 
                                '\n' + 
                                '\n' + 
                                '！！　晴天様　の　対応は不要　！！' + '\n' + 
                                '\n' + 
                                '\n' + 
                                '作業手順：Salesforceを確認→ シンプル資料＋エンディングノート発送' + '\n' + 
                                '※絶対に　電話はしない　こと！' + '\n' + 
                                '\n' + 
                                '以下のURLから対応を開始してください。' + '\n' + 
                                URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/r/Opportunity/' + pShiryoSofu.OpportunityRef__c + '/view' + '\n' + 
                                '\n' + 
                                '▼自動資料送付結果' + '\n' + 
                                tempJidoShiryoSofuKekka + '\n' + 
                                '\n' + 
                                '▼重複の可能性のある取引先' + '\n' + 
                                conversionNullNashi(pShiryoSofu.OpportunityRef__r.CaseRef__r.DuplicationCheckAccountUrl__c) + '\n' + 
                                '\n' + 
                                '▼住所注意事項' + '\n' + 
                                conversionNullNashi(pShiryoSofu.OpportunityRef__r.CaseRef__r.AddressConfirmInfo__c) + '\n' + 
                                '\n' + 
                                '以下、お申し込み内容' + '\n' + 
                                '------------------------------------------------' + '\n' + 
                                '受付番号：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.uniq_id__c + '\n' + 
                                '\n' + 
                                'お名前：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.Lastname__c + ' ' + pShiryoSofu.OpportunityRef__r.CaseRef__r.Firstname__c + '(' + pShiryoSofu.OpportunityRef__r.CaseRef__r.LastNameKana__c + ' ' + pShiryoSofu.OpportunityRef__r.CaseRef__r.FirstNameKana__c + ')' + '\n' +
                                '\n' + 
                                '連絡先電話番号：' + conversionNullKuran(pShiryoSofu.OpportunityRef__r.CaseRef__r.KeitaiDenwa__c) + conversionNullKuran(pShiryoSofu.OpportunityRef__r.CaseRef__r.TelNo__c) + '\n' + 
                                '\n' + 
                                'メールアドレス：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.MailAddress__c + '\n' + 
                                '\n' + 
                                '送付先住所：〒' + pShiryoSofu.OpportunityRef__r.CaseRef__r.PostalCode__c + ' ' + pShiryoSofu.OpportunityRef__r.CaseRef__r.State__c + pShiryoSofu.OpportunityRef__r.CaseRef__r.City__c + pShiryoSofu.OpportunityRef__r.CaseRef__r.Street__c + '\n' + 
                                '\n' + 
                                'お葬式をお考えの地域：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaState__c + pShiryoSofu.OpportunityRef__r.CaseRef__r.KiboAreaCity__c + '\n' + 
                                '------------------------------------------------' + '\n' + 
                                '＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝■＝' + '\n' + 
                                '\n' + 
                                '送信時間：' + pShiryoSofu.OpportunityRef__r.CaseRef__r.ToiawaseDate__c
                                ,
                OwnerId = DefaultOwner.getOwnerId()
            );
        }
    }

    private static String conversionNullKuran(String val){ return val == null ? '' : val; }
    private static String conversionNullNashi(String val){ return val == null ? 'なし' : val; }
}