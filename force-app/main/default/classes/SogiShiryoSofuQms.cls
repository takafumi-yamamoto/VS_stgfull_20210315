public class SogiShiryoSofuQms implements IHdlQms{
    public static String msgType = 'SogiShiryoSofuQms';
    private static String rtSimpleYasugoShiryoSeikyuWebFormId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoShiryoSeikyuWebForm').getRecordTypeId();
    private static String rtSimpleYasugoEndingnoteWebForm = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SimpleYasugoEndingnoteWebForm').getRecordTypeId();
    private static String rtSimpleYasugoId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('SimpleYasugo').getRecordTypeId();
    private static String rtOpportunityTorihikiShodan = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('TorihikiShodan').getRecordTypeId();
    private static String rtAccountCustomer = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();

	public class Data{
		public String opportunity_id;
    }

    public void handleQms(Qms__c pQms){
		try{
			Data theData = (Data)JSON.deserialize(pQms.Data__c, Data.class);
			new Runner().run( theData.opportunity_id );
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Completed);
		}catch(Exception ex){
			UPDATE New Qms__c(Id = pQms.Id, ShoriStatus__c = QmsShoriStatus.Failed);
			Loggings.writeLog(
				Loggings.createLogEntry(Loggings.Level.Error, '20201012-1805', msgType)
					.setSubjectRecordId(pQms.Id)
					.putAttr('Exception', ex.getMessage())
					.putAttr('LineNumber', '' + ex.getLineNumber())
					.putAttr('getStackTraceString', ex.getStackTraceString())
			);
		}
    }

    public class Runner{

        public Opportunity theOpportunity;
        public List<String> errMsgList = new List<String>();

        public Runner(){}

        public void run(String pOpportunityId){
            this.getOpprotunity(pOpportunityId);
            if(!isTargetCase()) return;

            this.pdfCreateJudgment();
            this.insertSogiShiryoSofu();
        }
        
        public void getOpprotunity(String pOpportunityId){
            theOpportunity = (Opportunity)SobjectsExtension.firstOrNull(
				[
                    SELECT Id,
                    Account.PersonContactId, 
                    RecordType.DeveloperName, 
                    SimpleYasugoRef__r.KiboAreaRef__c, 
                    CaseRef__r.Lastname__c, 
                    CaseRef__r.Firstname__c, 
                    CaseRef__r.LastNameKana__c, 
                    CaseRef__r.FirstNameKana__c, 
                    CaseRef__r.KeitaiDenwa__c, 
                    CaseRef__r.TelNo__c, 
                    CaseRef__r.Jusho__c, 
                    CaseRef__r.ShiryoSoufuHoho__c, 
                    CaseRef__r.MailAddress__c, 
                    CaseRef__r.SalesforceOrgURL__c, 
                    CaseRef__r.DuplicationCheckAccountUrl__c, 
                    CaseRef__r.AddressConfirmInfo__c, 
                    CaseRef__r.uniq_id__c, 
                    CaseRef__r.KiboAreaState__c, 
                    CaseRef__r.KiboAreaCity__c, 
                    CaseRef__r.TaishoshaKyojuKeitai__c, 
                    CaseRef__r.WebShiryoSeikyuTaishoushaJokyo__c, 
                    CaseRef__r.TaishoshaYomeiKikan__c, 
                    CaseRef__r.ToiawaseKiinsha__c, 
                    CaseRef__r.EndingNoteFlg__c, 
                    CaseRef__r.ToiawaseDate__c, 
                    CaseRef__r.MailArrivalTime__c, 
                    CaseRef__r.PostalCode__c, 
                    CaseRef__r.State__c, 
                    CaseRef__r.City__c, 
                    CaseRef__r.Street__c, 
                    CaseRef__r.RecordTypeId, 
                    CaseRef__r.TaishoushaJokyo__c 
					FROM Opportunity 
                    WHERE Id = :pOpportunityId 
				]
            );
        }

        private Boolean isTargetCase(){
            if(theOpportunity.CaseRef__r.RecordTypeId == rtSimpleYasugoShiryoSeikyuWebFormId) return true;
            if(theOpportunity.CaseRef__r.RecordTypeId == rtSimpleYasugoEndingnoteWebForm) return true;
            return false;
        }

        public void pdfCreateJudgment(){
            checkTargetOpportunity();
            checkJogaiJoken();
            checkHiraganaKatakanaNomi();
            checkTodayDuplicate();
            checkSekoKanoSogisha();
            checkOtherOpportunity();
        }

        private void checkTargetOpportunity(){
            if(theOpportunity.CaseRef__r.RecordTypeId == rtSimpleYasugoShiryoSeikyuWebFormId && theOpportunity.CaseRef__r.TaishoushaJokyo__c != '健在'){
                this.errMsgList.add('・対象者様の状態が健在以外です。');
            }
        }
    
        private void checkJogaiJoken(){
            for(SogiShiryoSofuPdfSakuseiJogaiJoken__mdt jogaiJoken : [select TargetItemApiName__c, 
                                                                            CheckValue__c, 
                                                                            ErrMsg__c 
                                                                        from SogiShiryoSofuPdfSakuseiJogaiJoken__mdt 
                                                                        where isActive__c = true]){
                Object ojbItem = theOpportunity.CaseRef__r.get(jogaiJoken.TargetItemApiName__c);
                if(ojbItem == null) continue;
                Pattern p = Pattern.compile(jogaiJoken.CheckValue__c);
                Matcher m = p.matcher((String)ojbItem);
                if(m.find()) this.errMsgList.add(jogaiJoken.ErrMsg__c);
            }
        }
    
        private void checkHiraganaKatakanaNomi(){
            if(Pattern.matches('^[ぁ-んァ-ン]+$', theOpportunity.CaseRef__r.Lastname__c + theOpportunity.CaseRef__r.Firstname__c)) this.errMsgList.add('・姓名がひらがなまたはカタカナのみです。');
        }
    
        private void checkTodayDuplicate(){
            for(Case todayCase : [select Id, 
                                    KeitaiDenwa__c, 
                                    TelNo__c, 
                                    MailAddress__c, 
                                    Jusho__c 
                                from Case 
                                where CreatedDate = TODAY]){
                if(isDuplicate(todayCase)){
                    this.errMsgList.add('・本日、同様の問合せが作成された可能性があります。');
                    break;
                }
            }
        }

        private void checkSekoKanoSogisha(){
            if(theOpportunity.SimpleYasugoRef__r.KiboAreaRef__c == null){
                this.errMsgList.add('・希望エリアが設定されていません。');
            }
            else{
                List<SekouKanouArea__c> sekoKanoAreaList = [select Id 
                                                            from SekouKanouArea__c 
                                                            where SimpleYasugoKeiyakuRef__c != null 
                                                            and ShikugunRef__c = :theOpportunity.SimpleYasugoRef__r.KiboAreaRef__c
                                                            and SokyakuTeishi__c = false 
                                                            and SimpleYasugoKeiyakuRef__r.KeiyakuJokyo__c = '契約中'];
                if(sekoKanoAreaList.size() == 0) this.errMsgList.add('・施行可能な葬儀社がありません。');
            }
        }

        private void checkOtherOpportunity(){
            List<String> tempOngoingShodanBangoList = new List<String>();
            for(Opportunity opp : [select 
                                        Id, 
                                        ShodanBango__c 
                                    from Opportunity 
                                    where AccountId = :theOpportunity.AccountId 
                                    and Account.RecordTypeId = :rtAccountCustomer
                                    and Id != :theOpportunity.Id
                                    and RecordTypeId != :rtOpportunityTorihikiShodan
                                    and StageName not in ('決定','施行待ち','施行完了','商談クローズ','除外')]){
                tempOngoingShodanBangoList.add(opp.ShodanBango__c);
            }
            if(tempOngoingShodanBangoList.size() > 0){
                String tempOngoingShodanBangoMsg = String.join(tempOngoingShodanBangoList, ',');
                this.errMsgList.add('・進行中の商談があります。' + '(' + tempOngoingShodanBangoMsg + ')');
            }
        }
    
        private Boolean isDuplicate(Case todayCase){
            if(theOpportunity.CaseRef__r.Id == todayCase.Id) return false;
            if(String.isNotBlank(theOpportunity.CaseRef__r.KeitaiDenwa__c) && theOpportunity.CaseRef__r.KeitaiDenwa__c == todayCase.KeitaiDenwa__c) return true;
            if(String.isNotBlank(theOpportunity.CaseRef__r.TelNo__c) && theOpportunity.CaseRef__r.TelNo__c == todayCase.TelNo__c) return true;
            if(String.isNotBlank(theOpportunity.CaseRef__r.MailAddress__c) && theOpportunity.CaseRef__r.MailAddress__c == todayCase.MailAddress__c) return true;
            if(String.isNotBlank(theOpportunity.CaseRef__r.Jusho__c) && theOpportunity.CaseRef__r.Jusho__c == todayCase.Jusho__c) return true;
            return false;
        }

		public void insertSogiShiryoSofu(){
            SogiShiryoSofu__c theSogiShiryoSofu = new SogiShiryoSofu__c();
            theSogiShiryoSofu.OpportunityRef__c = theOpportunity.Id; 
            theSogiShiryoSofu.PamphletYohi__c = '要';
            theSogiShiryoSofu.SofuJokyo__c = '資料作成中';
            theSogiShiryoSofu.InsatsubutsuIchiran__c = '送付状;斎場資料;会員案内;';
            theSogiShiryoSofu.Template__c = '標準';
            theSogiShiryoSofu.Atena__c = theOpportunity.CaseRef__r.Lastname__c + ' ' + theOpportunity.CaseRef__r.Firstname__c;

            if(String.isNotBlank(theOpportunity.CaseRef__r.ShiryoSoufuHoho__c) && theOpportunity.CaseRef__r.ShiryoSoufuHoho__c.startsWith('メール')){
                theSogiShiryoSofu.SofuShubetsu__c = 'メール';
                theSogiShiryoSofu.Mail__c = theOpportunity.CaseRef__r.MailAddress__c;

                if(theOpportunity.CaseRef__r.RecordTypeId == rtSimpleYasugoShiryoSeikyuWebFormId && theOpportunity.CaseRef__r.TaishoushaJokyo__c == '健在' && errMsgList.size() == 0){
                    theSogiShiryoSofu.AutoShiryoSofuMailSend__c = true;
                }
            }
            if(theOpportunity.CaseRef__r.ShiryoSoufuHoho__c == '郵送希望' || theOpportunity.CaseRef__r.RecordTypeId == rtSimpleYasugoEndingnoteWebForm){
                theSogiShiryoSofu.YusoShubetsu__c = '通常';
                theSogiShiryoSofu.SofuShubetsu__c = '郵便';
                theSogiShiryoSofu.PostalCode__c = theOpportunity.CaseRef__r.PostalCode__c;
                theSogiShiryoSofu.State__c = theOpportunity.CaseRef__r.State__c;
                theSogiShiryoSofu.City__c = theOpportunity.CaseRef__r.City__c;
                theSogiShiryoSofu.Street__c = theOpportunity.CaseRef__r.Street__c;
            }

            if(errMsgList.size() > 0){
                String errMsg = '';
                for(String aMsg : errMsgList){ errMsg += aMsg + '\n'; }
                theSogiShiryoSofu.PdfAutoCreateErrMsg__c = errMsg;
            }
            else{
                theSogiShiryoSofu.PdfAutoCreate__c = true;
            }

            insert theSogiShiryoSofu;

            Boolean shutokenFlg = false;
            if(theOpportunity.SimpleYasugoRef__r.KiboAreaRef__c != null){
                ShiryoSofuTeianShisetsuTrial.TeianShisetsuListWrap standardTeianListWrap = new ShiryoSofuTeianShisetsuTrial().getShiryoSofuTeianShisetsu(theOpportunity.SimpleYasugoRef__r.KiboAreaRef__c);

                List<SogiShiryoSofuMeisai__c> insSogiShiryoSofuMeisaiList = new List<SogiShiryoSofuMeisai__c>();
                Integer indexKasobaTeian = 0;
                for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap standardKasoba : standardTeianListWrap.standardKasobaList){
                    insSogiShiryoSofuMeisaiList.add(
                        new SogiShiryoSofuMeisai__c(
                                SogiShiryoSofuRef__c = theSogiShiryoSofu.Id,
                                ShisetsuRef__c = standardKasoba.shisetsuId,
                                Hyojijun__c = indexKasobaTeian++,
                                ShisetsuKubun__c = '火葬場',
                                Name = theSogiShiryoSofu.Id + '_' + '火葬場' + '_' + standardKasoba.shisetsuName 
                        )
                    );

                    if(standardKasoba.shutokenIchibuChiki) shutokenFlg = true;
                }

                Integer indexSaijoTeian = 0;
                for(ShiryoSofuTeianShisetsuTrial.TeianShisetsuWrap standardSaijo : standardTeianListWrap.standardSaijoList){
                    insSogiShiryoSofuMeisaiList.add(
                        new SogiShiryoSofuMeisai__c(
                            SogiShiryoSofuRef__c = theSogiShiryoSofu.Id,
                            SaijoRef__c = standardSaijo.shisetsuId,
                            Hyojijun__c = indexSaijoTeian++,
                            ShisetsuKubun__c = '斎場',
                            Name = theSogiShiryoSofu.Id + '_' + '斎場' + '_' + standardSaijo.shisetsuName
                        )
                    );
                }
                insert insSogiShiryoSofuMeisaiList;
            }
            
            if(theSogiShiryoSofu.PdfAutoCreate__c){
                try{
                    if(shutokenFlg) theSogiShiryoSofu.InsatsubutsuIchiran__c = '送付状;首都圏案内文;斎場資料;会員案内;';
                    theSogiShiryoSofu.SofuJokyo__c = '印刷待ち';
                    update theSogiShiryoSofu;
                }catch(Exception ex){
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error, '20201005-2107', 'Web資料請求PDF作成処理')
                            .putAttr('Exception', ex.getMessage())
                            .putAttr('LineNumber', '' + ex.getLineNumber())
                            .putAttr('getStackTraceString', ex.getStackTraceString())
                    );
                }
                
                new SogiShiryoSofuPdfCreateQms.QueuingOnShiryoSofuAfterUpdate().enqueSogiShiryoSofuLocationUpdates(theSogiShiryoSofu);
            }
            else{
                SogiShiryoSakuseiKekkaTsuchi.sendMailShiryoSofuAdmin([select Id, 
                                                                            AutoShiryoSofuMailSend__c, 
                                                                            SofuJokyo__c, 
                                                                            SofuNichiji__c, 
                                                                            Atena__c, 
                                                                            Mail__c, 
                                                                            PassWord__c, 
                                                                            SofuShiryoURL__c, 
                                                                            PdfAutoCreateErrMsg__c, 
                                                                            InsatsubutsuIchiran__c, 
                                                                            OpportunityRef__r.RecordType.DeveloperName, 
                                                                            OpportunityRef__c, 
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
                                                                            LastModifiedById 
                                                                        from SogiShiryoSofu__c
                                                                        where Id = :theSogiShiryoSofu.Id]);
            }
        }
    }

    public class QueuingOnOpportunityAfterInsert{
		public void enqueOpportunityLocationUpdates(List<Opportunity> pNewOnes){
			INSERT this.getQueues(pNewOnes);
		}

		public List<Qms__c> getQueues(List<Opportunity> pNewOnes){

			Set<String> theOpportunityIds_toBeProcessed = new Set<String>();
			for(Opportunity aNewOne : pNewOnes){
				if( aNewOne.RecordTypeId == rtSimpleYasugoId && aNewOne.Origin__c == 'Web') theOpportunityIds_toBeProcessed.add(aNewOne.Id);
			}

			List<Qms__c> theQmses = new List<Qms__c>();
			for(String aOpportunityId : theOpportunityIds_toBeProcessed){
				Data theData = new Data();
				theData.opportunity_id = aOpportunityId;
				theQmses.add(
					QmsBld.newRoot().setMsgType( msgType ).setData( JSON.serialize( theData ) ).build()
				);
			}

			return theQmses;
		}
	}
}