public class Dao_Account {

    static final String strSelectFrom  = ' SELECT '
                                    + ' Id, TorihikisakiBangoF__c, '
                                    + ' Name, LastName, FirstName,'
                                    + ' NameFurigana__c, LastNameFurigana__pc, FirstNameFurigana__pc,'
                                    + ' PersonBirthdate, PhoneFormula__c, MobilePhoneFormula__c,'
                                    + ' Phone, MobilePhone__c, MailAddress__c, MailAddress2__c, '
                                    + ' BillingPostalCode, BillingState, BillingCity, BillingStreet,JizenwariMemberKa__c,'
                                    + ' MemberKubunCode__c, MemberTokutenKubunCode__c, MemberKubun__c,MemberTokutenKubun__c, JizenJizenSheetTeishutsuzumi__c, JizenwariKekaKikan__c, '
                                    + ' AcvmJizenWariMinDate__c, AcvmJizenJunbiMinDate__c, AcvmOsoushikiYoyakuMinDate__c, '
                                    + ' RecordType.DeveloperName, '
                                    + ' (SELECT Id, '
                                    + '  JizenwariMemberKisanbi__c '
                                    + '  FROM TorihikiSakiAchivements__r '
                                    + '  WHERE Syubetsu__c = \'YorisoJizenWari\' '
                                    + '  ORDER BY YukoKaishiBi__c )'
                                    + ' FROM Account ';

    static public List<Account> getAccountListByPhoneNumber(String strWhereParam, List<String> phoneNumerNoHyphenList, String strOrderByParam){

        return Database.query(strSelectFrom + strWhereParam + strOrderByParam);
    }



    static public List<Account> SearchAccount(String strWhereParam, Set<Id> whereParams, String strOrderByParam){

        return Database.query(strSelectFrom + strWhereParam + strOrderByParam);
    }

    /**
    * Null Accountを取得する
    */
    //static public Map<Id, Account> getNullAccoutMap(List<String> ids){
    //    Map<Id, Account> accountMap = new Map<Id, Account>([SELECT id, RecordType.Name From Account WHERE RecordType.Name = 'NULL' and id in :ids]);
    //    return accountMap;
    //}

    private static Dao_Account f_Instance;
    public static Dao_Account getInstance(){
    if(f_Instance == null) {
        f_Instance = new Dao_Account(RecordTypeCachedDaos.getInstance());
    }
        return f_Instance;
    }

    private RecordTypeCachedDaos.IRecordTypeCachedDao f_IRecordTypeCachedDao;
    public Dao_Account(RecordTypeCachedDaos.IRecordTypeCachedDao pIRecordTypeCachedDao){
        this.f_IRecordTypeCachedDao = pIRecordTypeCachedDao;
    }

    public List<Account> SelectByRecordTypeDevName(string pRecordTypeDevName){
        String theRecordTypeId = this.f_IRecordTypeCachedDao.SelectIdByObjectTypeNameAndDevName('Account',pRecordTypeDevName);
        return Database.query(Dao_Account.strSelectFrom + ' where RecordTypeId = :theRecordTypeId');
    }

    public Account selectByTorihikisakiBango(String pTorihikisakiBango){
        List<Account> theEntities = Database.query(Dao_Account.strSelectFrom + ' where TorihikisakiBangoF__c = :pTorihikisakiBango');
        if(theEntities.size() <= 0) return null;
        return theEntities.get(0);
    }

    public Account selectById(Id id){
        List<Account> theEntities = Database.query(Dao_Account.strSelectFrom + 'where Id = :id');
        return theEntities.size() > 0 ? theEntities.get(0) : null;
    }
    public List<Account> selectByIds(List<Id> pIds){
        return Database.query(Dao_Account.strSelectFrom + 'where Id in :pIds');
    }

    static final String strAccountSelect = 'SELECT ' + 
                                        'Id ' + 
                                        ',IsDeleted ' + 
                                        ',MasterRecordId ' + 
                                        ',Name ' + 
                                        ',LastName ' + 
                                        ',FirstName ' + 
                                        ',Salutation ' + 
                                        ',Type ' + 
                                        ',RecordTypeId ' + 
                                        ',ParentId ' + 
                                        ',BillingStreet ' + 
                                        ',BillingCity ' + 
                                        ',BillingState ' + 
                                        ',BillingPostalCode ' + 
                                        ',BillingCountry ' + 
                                        ',BillingLatitude ' + 
                                        ',BillingLongitude ' + 
                                        ',BillingGeocodeAccuracy ' + 
                                        ',BillingAddress ' + 
                                        ',ShippingStreet ' + 
                                        ',ShippingCity ' + 
                                        ',ShippingState ' + 
                                        ',ShippingPostalCode ' + 
                                        ',ShippingCountry ' + 
                                        ',ShippingLatitude ' + 
                                        ',ShippingLongitude ' + 
                                        ',ShippingGeocodeAccuracy ' + 
                                        ',ShippingAddress ' + 
                                        ',Phone ' + 
                                        ',Fax ' + 
                                        ',AccountNumber ' + 
                                        ',Website ' + 
                                        ',PhotoUrl ' + 
                                        ',Sic ' + 
                                        ',Industry ' + 
                                        ',AnnualRevenue ' + 
                                        ',NumberOfEmployees ' + 
                                        ',Ownership ' + 
                                        ',TickerSymbol ' + 
                                        ',Description ' + 
                                        ',Rating ' + 
                                        ',Site ' + 
                                        ',OwnerId ' + 
                                        /*',CreatedDate ' + 
                                        ',CreatedById ' + 
                                        ',LastModifiedDate ' + 
                                        ',LastModifiedById ' + 
                                        ',SystemModstamp ' + 
                                        ',LastActivityDate ' + 
                                        ',LastViewedDate ' + 
                                        ',LastReferencedDate ' + */
                                        ',PersonContactId ' + 
                                        ',IsPersonAccount ' + 
                                        ',PersonMailingStreet ' + 
                                        ',PersonMailingCity ' + 
                                        ',PersonMailingState ' + 
                                        ',PersonMailingPostalCode ' + 
                                        ',PersonMailingCountry ' + 
                                        ',PersonMailingLatitude ' + 
                                        ',PersonMailingLongitude ' + 
                                        ',PersonMailingGeocodeAccuracy ' + 
                                        ',PersonMailingAddress ' + 
                                        ',PersonOtherStreet ' + 
                                        ',PersonOtherCity ' + 
                                        ',PersonOtherState ' + 
                                        ',PersonOtherPostalCode ' + 
                                        ',PersonOtherCountry ' + 
                                        ',PersonOtherLatitude ' + 
                                        ',PersonOtherLongitude ' + 
                                        ',PersonOtherGeocodeAccuracy ' + 
                                        ',PersonOtherAddress ' + 
                                        ',PersonMobilePhone ' + 
                                        ',PersonHomePhone ' + 
                                        ',PersonOtherPhone ' + 
                                        ',PersonAssistantPhone ' + 
                                        ',PersonEmail ' + 
                                        ',PersonTitle ' + 
                                        ',PersonDepartment ' + 
                                        ',PersonAssistantName ' + 
                                        ',PersonLeadSource ' + 
                                        ',PersonBirthdate ' + 
                                        ',PersonHasOptedOutOfEmail ' + 
                                        ',PersonHasOptedOutOfFax ' + 
                                        ',PersonDoNotCall ' + 
                                        ',PersonLastCURequestDate ' + 
                                        ',PersonLastCUUpdateDate ' + 
                                        ',PersonEmailBouncedReason ' + 
                                        ',PersonEmailBouncedDate ' + 
                                        ',Jigsaw ' + 
                                        ',JigsawCompanyId ' + 
                                        ',AccountSource ' + 
                                        ',SicDesc ' + 
                                        ',BankBranchName__c ' + 
                                        ',BankName__c ' + 
                                        ',KeisaiMeiSogiRebiYo__c ' + 
                                        ',BankAccountType__c ' + 
                                        ',BankAccountNo__c ' + 
                                        ',BankAccountMeigi__c ' + 
                                        ',HyokaSogiRebiNaibuYo__c ' + 
                                        ',AccountTypeForCore__c ' + 
                                        ',AfterSalesTaisyoFlag__c ' + 
                                        ',BillingAddressFormula__c ' + 
                                        ',Remarks__c ' + 
                                        ',BodaijinoUmu__c ' + 
                                        ',BotsunengappiChofukuCheckyo__c ' + 
                                        ',BotsunengappiWareki__c ' + 
                                        ',JisyaSaijoSyoyuJokyo__c ' + 
                                        ',CostomFirstNameKanji__c ' + 
                                        ',CostomLastNameKanji__c ' + 
                                        ',CreateSourceSimpleYasugo__c ' + 
                                        ',DaihyoDenwaBango__c ' + 
                                        ',HakaUmuKubun__c ' + 
                                        ',HomutaiokanoArea__c ' + 
                                        ',JiinSyuha__c ' + 
                                        ',JiinSyusi__c ' + 
                                        ',MailAddress2__c ' + 
                                        ',Phone2__c ' + 
                                        ',JuminhyouCity__c ' + 
                                        ',JuminhyouFormula__c ' + 
                                        ',JuminhyouState__c ' + 
                                        ',Kaimyojuyonomiirai__c ' + 
                                        ',MailAddress__c ' + 
                                        ',MadoguchiSoryoKyojuchi__c ' + 
                                        ',TeikeiZumiServices__c ' + 
                                        ',AllianceType__c ' + 
                                        ',MemberKubunCode__c ' + 
                                        ',MemberKubun__c ' + 
                                        ',MemberTokutenKubunCode__c ' + 
                                        ',MemberTokutenKubun__c ' + 
                                        ',MemberTourokuZumi__c ' + 
                                        ',MobilePhoneFormula__c ' + 
                                        ',NameFurigana__c ' + 
                                        ',NayoseTaisyoGaiKubun__c ' + 
                                        ',NewsLetterHaishinFlag__c ' + 
                                        ',ObonDmSoushinFlag__c ' + 
                                        ',OhakaAri__c ' + 
                                        ',PhoneFormula__c ' + 
                                        ',SeinengappiChofukuCheckyo__c ' + 
                                        ',SeinengappiWareki__c ' + 
                                        ',ShikugunRef__c ' + 
                                        ',SiryoSeikyuKubun__c ' + 
                                        ',SonotanoSyukyoSyuha__c ' + 
                                        ',SyozokuGyosyaMei__c ' + 
                                        ',RirekisyoKakuninJokyo__c ' + 
                                        ',Syuha__c ' + 
                                        ',Syushi__c ' + 
                                        ',TokkiJiko__c ' + 
                                        ',TorihikisakiBangoF__c ' + 
                                        ',TorihikisakiBango__c ' + 
                                        ',WebAccountKeitaiDenwaBango__c ' + 
                                        ',WebAccountMailAddress__c ' + 
                                        ',YusenFaxFormula__c ' + 
                                        ',YusenFaxKubun__c ' + 
                                        ',KoukokuDmNg__c ' + 
                                        ',YusenMailAddressFormula__c ' + 
                                        ',KoukokuFaxNg__c ' + 
                                        ',YusenMailAddressKubun__c ' + 
                                        ',YusenTelNoFormula__c ' + 
                                        ',YusenTelNoKubun__c ' + 
                                        ',YutaikenSyutokuMaisu__c ' + 
                                        ',sp__c ' + 
                                        ',AcvmJizenJunbiMinDate__c ' + 
                                        ',AcvmJizenWariMinDate__c ' + 
                                        ',AcvmOsoushikiYoyakuMinDate__c ' + 
                                        //',AcvmSimYasSiryoMinDate__c ' + 
                                        ',AcvmSoryoTehaiMinDate__c ' + 
                                        ',SyusiSyuhaExp__c ' + 
                                        ',SougisyaNo__c ' + 
                                        ',SimpleYasugoKeiyakuKensu__c ' + 
                                        ',ManNenrei__c ' + 
                                        ',ManNenreiExp__c ' + 
                                        ',TokuyakutenKeiyakusu__c ' + 
                                        ',SekoHoshoKeiyakukensu__c ' + 
                                        ',SekoHoshoTicketKeiyaku__c ' + 
                                        ',JisyaSaijoSyoyuSu__c ' + 
                                        ',EigyomukeSogishaKanriId__c ' + 
                                        ',Soumei__c ' + 
                                        ',TokuyakutenFlg__c ' + 
                                        ',SekoHoshoTicketFlg__c ' + 
                                        ',TokuyakutenSekoHoshoSekoHoshoTicketFlg__c ' + 
                                        ',TehaibiKensakuyo__c ' + 
                                        ',ShuhaKensakuYo__c ' + 
                                        ',ZaisekiSaki__c ' + 
                                        ',JizenwariMemberKa__c ' + 
                                        ',UneiKeitai__c ' + 
                                        ',UneiKeitaiSonota__c ' + 
//                                        ',DaihyomeiKana__c ' + 
                                        ',KeiriTantoshaTel__c ' + 
                                        ',ShuyoRenrakusaki__c ' + 
                                        ',ShindaishaShoyusu__c ' + 
                                        ',SeikyusakiShogoKana__c ' + 
                                        ',SeikyusakiShogo__c ' + 
                                        ',SeikyusakiYagokana__c ' + 
                                        ',SeikyusakiYago__c ' + 
                                        ',IsDeleted__c ' + 
                                        ',IsPersonAccount__c ' + 
                                        ',SeikyusakiTel__c ' + 
                                        ',SeikyusakiFax__c ' + 
//                                        ',SeikyusakiTantoshaKana__c ' + 
//                                        ',SeikyusakiTantosha__c ' + 
                                        ',HekinSekoKensuNen__c ' + 
                                        ',SekoStaffNinzu__c ' + 
                                        ',YusenTelNo__c ' + 
                                        ',SekoKanoKensuTsuki__c ' + 
                                        ',SosaiPlannerNinzu__c ' + 
                                        ',SosaiDirectorNinzu__c ' + 
                                        ',JiinShushaSonota__c ' + 
                                        ',JiinShuhaSonotaKana__c ' + 
                                        ',BetsuinKatsudoKibo__c ' + 
                                        ',Somei__c ' + 
                                        ',SomeiTorokuKibo__c ' + 
                                        ',TashaServiceToroku__c ' + 
                                        ',TashaServiceTorokumei__c ' + 
                                        ',YakushokuKubun__c ' + 
                                        ',MyFuneralStatus__c ' + 
                                        ',HonninKakuninSyoruiSyubetsu__c ' + 
                                        ',SousekiJuryoJoKyo__c ' + 
                                        ',SousekiKakuninKekka__c ' + 
                                        ',ShozokuSangouSangoJiin__c ' + 
                                        ',Syusi__c ' + 
                                        ',HoujinTanniKubun__c ' + 
                                        ',HoujinKakuAri__c ' + 
                                        ',KyogoServices__c ' + 
                                        ',SystemModstamp__c ' + 
                                        ',Fax2__c ' + 
                                        ',SangoJiinMeiFurigana__c ' + 
                                        ',TelNoPrimaryKubun__c ' + 
                                        ',SyuzaiTaiouKahiKubun__c ' + 
                                        ',CustomCreatedById__c ' + 
                                        ',CustomCreatedDate__c ' + 
                                        ',SouiSoukaiHoukai__c ' + 
                                        ',CustomLastActivityDate__c ' + 
                                        ',CustomLastModifiedById__c ' + 
                                        ',CustomLastModifiedDate__c ' + 
//                                        ',SeikyuSakiTantoNameFurigana__c ' + 
//                                        ',SeikyuSakiTantoName__c ' + 
                                        ',SeikyuSakiPhone2__c ' + 
                                        ',SeikyuSakiPhone1__c ' + 
                                        ',SeikyuSakiMobile2__c ' + 
                                        ',SeikyuSakiMobile1__c ' + 
                                        ',SeikyuSakiFax2__c ' + 
                                        ',SeikyuSakiFax1__c ' + 
                                        ',FirstTeikeiToiawaseBi__c ' + 
                                        ',SeikyuSakiDescription__c ' + 
                                        ',SeikyuSakiAddrStreet__c ' + 
                                        ',SeikyuSakiAddrState__c ' + 
                                        ',SeikyuSakiAddrPostalCode__c ' + 
                                        ',KoukokuMailNg__c ' + 
                                        ',SeikyuSakiAddrCity__c ' + 
                                        ',KoukokuSmsNg__c ' + 
                                        ',SangoJiinName__c ' + 
                                        ',KyotenKubun__c ' + 
                                        ',RenrakusakiBiko__c ' + 
                                        //',Pkey__c ' + 
                                        ',OldTorihikisakiId__c ' + 
                                        ',NameYagouFurigana__c ' + 
                                        ',NameYago__c ' + 
                                        ',MobilePhone__c ' + 
                                        ',NameShogoFurigana__c ' + 
                                        ',MobilePhone2__c ' + 
                                        ',NameShogo__c ' + 
                                        ',KaisyaHoujinBango__c ' + 
//                                        ',DaihyoName__c ' + 
                                        ',MendanTaiouSya__c ' + 
                                        ',MendanBi__c ' + 
                                        ',PersonDeathDate__pc ' + 
                                        ',FirstNameFurigana__pc ' + 
                                        ',Botsunengappi__pc ' + 
                                        ',LastNameFurigana__pc ' + 
                                        ',Age__pc ';

    static final String strAccountFrom = ' FROM Account ';

    static final String strKeiyakuSelectFrom = 'SELECT ' + 
                                        'Id ' +
                                        ',IsDeleted ' +
                                        ',Name ' +
                                        ',RecordTypeId ' +
                                        ',CreatedDate ' +
                                        ',CreatedById ' +
                                        ',LastModifiedDate ' +
                                        ',LastModifiedById ' +
                                        ',SystemModstamp ' +
                                        ',LastActivityDate ' +
                                        ',LastViewedDate ' +
                                        ',LastReferencedDate ' +
                                        ',Teikeisaki__c ' +
                                        ',AmazonTaioka__c ' +
                                        ',AreaTokureiAri__c ' +
                                        ',AreaTokureiTaisyoArea__c ' +
                                        ',CyokuSoTaiouKa__c ' +
                                        ',CyusyaJoUmu__c ' +
                                        ',CyusyaKanouDaisu__c ' +
                                        ',HansyaSyoruiJuryoJokyo__c ' +
                                        ',HomutaiokanoArea__c ' +
                                        ',HoninKakuninSyoruiSyubetsu__c ' +
                                        ',IdoSyudan__c ' +
                                        ',IkoujiCreatedById__c ' +
                                        ',IkoujiCreatedDate__c ' +
                                        ',IkoujiLastActivityDate__c ' +
                                        ',IkoujiLastModifiedById__c ' +
                                        ',IkoujiLastModifiedDate__c ' +
                                        ',TokuyakutenKensu__c ' +
                                        ',JiinDenoHoyoKa__c ' +
                                        ',JishasaijoAri__c ' +
                                        ',JisyaSaijoSyoyuJokyo__c ' +
                                        ',JuyoJikoCheckListJuryoJokyo__c ' +
                                        ',Kaimyojuyonomiirai__c ' +
                                        ',KaiteKiyakuTekiyoZumi__c ' +
                                        ',Syozokusangojiinme__c ' +
                                        ',KakoTyoKinyuTaiouKahiKubun__c ' +
                                        ',KeisaiMei__c ' +
                                        ',KeiyakuBango__c ' +
                                        ',KeiyakuChuFlg__c ' +
                                        ',KeiyakuJokyo__c ' +
                                        ',KeiyakuMousikomiBi__c ' +
                                        ',KeiyakuSikkoRiyu__c ' +
                                        ',KeiyakuSikkouKaijoBi__c ' +
                                        ',KeiyakuSikkouKaijoRiyu__c ' +
                                        ',KeiyakuSikkouKasibi__c ' +
                                        ',KeiyakuSyoBango__c ' +
                                        ',KeiyakuSyoSyosiki__c ' +
                                        ',KeiyakuSyubetsu__c ' +
                                        ',KeiyakuSyuryoBi__c ' +
                                        ',KeiyakuSyuryoRiyu__c ' +
                                        ',KeiyakuTantoCity__c ' +
                                        ',KeiyakuTantoFaxNo__c ' +
//                                        ',KeiyakuTantoNameFurigana__c ' +
//                                        ',KeiyakuTantoName__c ' +
                                        ',KeiyakuTantoPostalCode__c ' +
                                        ',KeiyakuTantoState__c ' +
                                        ',KeiyakuTantoStreet__c ' +
                                        ',KeiyakuTantoTelNo__c ' +
                                        ',KeiyakuTantoYakuShoku__c ' +
                                        ',Keiyakukaishibi__c ' +
                                        ',Keiyakuyuko__c ' +
                                        ',KyuTesuryoTaioFlag__c ' +
                                        ',MadoguchiSomeiFurigana__c ' +
                                        ',MadoguchiSoryoBillingState__c ' +
                                        ',MadoguchiSouryoRenrakuSaki__c ' +
                                        ',MadoguchisoryoIdo__c ' +
                                        ',MadoguchisoryoKeido__c ' +
                                        ',Madoguchisoryo__c ' +
                                        ',Meisyo__c ' +
                                        ',NaibuSokyakuMokuhyosu__c ' +
                                        ',NyukinSimekiriJouken__c ' +
                                        ',ObousanBinTehaiKubun__c ' +
                                        ',OmukaeFreeBiko__c ' +
                                        ',OmukaeFreeTaiouKa__c ' +
                                        //',PKey__c ' +
                                        ',RidatsuRiyu__c ' +
                                        ',RiyoKanoOptionTaisyo__c ' +
                                        ',SekoHosyoKeiyakuSu__c ' +
                                        ',SekoHosyoYukoKeiyakuSu__c ' +
                                        ',ServiceId__c ' +
                                        ',ShikiariNeageKosyoStatus__c ' +
                                        ',ShoriStatusBiko__c ' +
                                        ',ShoriStatus__c ' +
                                        ',ShozokuSangouSangoJiinName__c ' +
                                        ',SimpleKeiyakuSu__c ' +
                                        ',SimpleYukoKeiyakuSu__c ' +
                                        ',SogisyaTokkijikoAri__c ' +
                                        ',SokyakuTasseiritsu__c ' +
                                        ',SokyakujiCyuitenAri__c ' +
                                        ',Sokyakujicyuiten__c ' +
                                        ',Soryokyojuchi__c ' +
                                        ',SoudanKanouArea__c ' +
                                        ',SougisyaDenwaBango1__c ' +
                                        ',SougisyaFax__c ' +
                                        ',SougisyaSoukyakuRank__c ' +
                                        ',SoukyakuHyouka__c ' +
                                        ',SousekiJuryoJokyo__c ' +
                                        ',SousekiKakuninKekka__c ' +
                                        ',SyozokusangojiinmeFurigana__c ' +
                                        ',SyuKeiyakuRef__c ' +
                                        ',Syuha__c ' +
                                        ',Syushi__c ' +
                                        ',SyuyoNinzu__c ' +
                                        ',TaimenSoudanTaiouKa__c ' +
                                        ',TaiouKanouArea__c ' +
                                        ',TaiouKanouPlan__c ' +
                                        ',TeikeiKyohiBi__c ' +
                                        ',TeikeiKyohiRiyu__c ' +
                                        ',TeikeisakiJusyoIdo__c ' +
                                        ',TeikeisakiJusyoKeido__c ' +
                                        ',TeikeisakiMonkName__c ' +
                                        ',TeikeisakiName__c ' +
                                        ',TeikeisakiTodofukenshikugunName__c ' +
                                        ',TeikesakiTorihikisakiBango__c ' +
                                        ',TesuryoAtobaraiAri__c ' +
                                        ',TesuryoCardLoanAri__c ' +
                                        ',TesuryoHenreiHinAri__c ' +
                                        ',TesuryoOptionAri__c ' +
                                        ',TesuryoRyoriAri__c ' +
                                        ',TogetsuSokyakusu__c ' +
                                        ',TokkiJiko__c ' +
                                        ',TokuyakutenKeiyakuSu__c ' +
                                        ',TokuyakutenToraiaruChuFlg__c ' +
                                        ',TokuyakutenToraiaruKaishibi__c ' +
                                        ',TokuyakutenToraiaruShuryobi__c ' +
                                        ',TokuyakutenYukoKeiyakuSu__c ' +
                                        ',ToubaTaioKahiKubun__c ' +
                                        ',TryCount__c ' +
                                        ',TryLimit__c ' +
                                        ',TsukisoiAnchiBiko__c ' +
                                        ',TsukisoiAnchiKa__c ' +
                                        ',UnsoKyokasyoHikaeAri__c ' +
                                        ',UnsoKyokasyoKubun__c ' +
                                        ',Website__c ' +
                                        ',YasugoKeiyakuSu__c ' +
                                        ',YasugoYukoKeiyakuSu__c ' +
                                        ',paymentCycle__c ' +
                                        ',sp__c ' +
                                        ',SalesforceOrgURL__c ' +
                                        ',Iraisyosofuhouhou__c ' +
                                        ',EigyomukeSogishaKanriId__c ' +
                                        ',TokkijikoPartnerKinyu__c ' +
                                        ',ShiharaiHohoSonota__c ' +
                                        ',SekoRyunyuHiritsuJishaShukaku__c ' +
                                        ',SekorRyunyuHiritsuByoinKesatsuKaigo__c ' +
                                        ',SekoRyunyuHiritsuInternet__c ' +
                                        ',SekoRyunyuHiritsuSonota__c ' +
                                        ',SekoHiritsuChokuso__c ' +
                                        ',SekoHiritsuIchinichiso__c ' +
                                        ',SekoHiritsuKazokuso__c ' +
                                        ',SekoHiritsuIppanso__c ' +
                                        ',SekoHiritsuHansoAnken__c ' +
                                        ',SekoHiritsuSonota__c ' +
                                        ',SekoHekinTanka__c ' +
                                        ',SogiBrandTaioKanoNaiyo__c ' +
                                        ',ShiharaiHoho__c ' +
                                        ',JishaSyukyakujiTaiokanoNaiyo__c ' +
                                        ',SaidaiEnkiNissuKasoshiki__c ' +
                                        ',SaidaiEnkiNissuShikiari__c ' +
                                        ',SaidaiBunkatuKaisuKasoshiki__c ' +
                                        ',SaidaiBunkatsuKaisuShikiari__c ' +
                                        ',KaimyojuyoIraiYosodan__c ' +
                                        ',TobaTaioYosodan__c ' +
                                        ',TobaTaioKingaku__c ' +
                                        ',KakochoKinyuYosodan__c ' +
                                        ',KakochoKinyuKingaku__c ' +
                                        ',JiinDenoHoyoYosodan__c ' +
                                        ',CoreRenkeiSchemeExp__c' + 
                                        ' From KeiyakusTeikeisaki__r ';

    static public Account getAccountKeiyakuByAccountId(String strAccountWhereParam, String strAccountOrderByParam, String strKeiyakuWhereParam, String strKeiyakuOrderyByParam){
        System.debug('query:' + strAccountSelect + ',(' + strKeiyakuSelectFrom + strKeiyakuWhereParam + strKeiyakuOrderyByParam + ')' + strAccountFrom + strAccountWhereParam + strAccountOrderByParam);
        return Database.query(strAccountSelect + ',(' + strKeiyakuSelectFrom + strKeiyakuWhereParam + strKeiyakuOrderyByParam + ')' + strAccountFrom + strAccountWhereParam + strAccountOrderByParam);
    }

    static public List<Account> getAccountContactListByAccountId(List<ID> accountIdList){
        return [SELECT Id, (SELECT Id FROM CONTACTS) FROM Account WHERE Id =: accountIdList];
    }

    static public Map<ID, Account> getAccountContactKeiyakuMapByAccountSet(Set<ID> accountIdSet){
        return new Map<ID, Account>([select Id, (select Id from Contacts), (select Id, SyuKeiyakuRef__r.Teikeisaki__c from KeiyakusTeikeisaki__r where RecordType.DeveloperName = 'ObousanBinJohouSya') from Account where Id = :accountIdSet]);
    }

    static public Map<ID, Account> getAccountContactMapByAccountSet(Set<ID> accountIdSet){
        return new Map<ID, Account>([select Id, (select Id from Contacts) from Account where Id = :accountIdSet]);
    }

    static public List<Account> getAccountKeiyakuListByAccountId(Set<ID> accountIdSet){
        return [select Id, Name, (select Id, Name, RecordType.Name from KeiyakusTeikeisaki__r) from Account where Id = :accountIdSet];
    }
}