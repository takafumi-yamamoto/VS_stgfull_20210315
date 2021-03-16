public class ChargeCalculator {
    private List<String> errMsgs= new List<String>();
    public class CalcChargeException extends Exception {
        public List<String> errMsgs {get; private set;}
        public CalcChargeException(List<String> errMsgs) {
            this.errMsgs = errMsgs;
        }
    }

    public Integer planChargePrice          {get; private set;}
    public Integer sogishaOptionChargePrice {get; private set;}
    public Integer yorisoOptionChargePrice  {get; private set;}
    public Integer paymentChargePrice       {get; private set;}

    private String oppId;
    private TesuryoTekiyo__c tesuryoTekiyo;

    private String  planProduct2Id;
    private Integer planUnitPrice = 0;
    private Integer planTotalDiscountPrice = 0;

    private class ChargeItem {
        String  id        {get; private set;}
        Boolean isCalc    {get; private set;}
        String  name      {get; private set;}
        Integer unitPrice {get; private set;}
        Integer quantity  {get; private set;}

        public ChargeItem(string id, boolean isCalc, string name, Integer unitPrice, Integer quantity) {
            this.id        = id;
            this.isCalc    = isCalc;
            this.name      = name;
            this.unitPrice = unitPrice;
            this.quantity  = quantity;
        }
    }
    private List<ChargeItem> sogishaOptionItems = new List<ChargeItem>();
    private List<ChargeItem> yorisoOptionItems  = new List<ChargeItem>();
    private List<ChargeItem> paymentItems       = new List<ChargeItem>();

    private static final List<ChargeMasterTest__c> chargeMasters = [
        SELECT
            Id
            ,TesuryoPlanRef__c
            ,Product2Ref__c
            ,Type__c
            ,FeeRate__c
            ,FixedFeePrice__c
            ,OwnCoverPrice__c
        FROM
            ChargeMasterTest__c
    ];

    private static final List<ChargePaymentMasterTest__c> chargePaymentMasters = [
        SELECT
            Id
            ,TesuryoPlanRef__c
            ,PaymentCode__c
            ,Type__c
            ,FeeRate__c
            ,FixedFeePrice__c
        FROM
            ChargePaymentMasterTest__c
    ];

    private Opportunity getOppWithItemsWithPaymentsById(String oppId) {
        return [
            SELECT
                Id
                ,SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c
                ,KakuteibiSyodan__c
                ,(
                    SELECT
                        Product2Id
                        ,UnitPrice
                        ,Quantity
                        ,Product2.Name
                        ,Product2.HinmokuBunrui__c
                        ,Product2.DataKubun__c
                        ,Product2.k_ShohinCategory_Id_exp__c
                    FROM
                        OpportunityLineItems
                )
                ,(
                    SELECT
                        Id
                        ,Name
                        ,SeikyuKingaku__c
                        ,SeikyuHohoCode__c
                        ,SeikyuHouhou__c
                    FROM
                        KaisyuYoteisOpportunity__r
                )
            FROM
                Opportunity
            WHERE
                Id = :oppId
            LIMIT 1
        ];
    }

    private void setTesuryoTekiyo(String keiyakuId, date fixedDate) {
        this.tesuryoTekiyo = [
            SELECT
                Id
                ,TesuryoPlanRef__c
                ,TesuryoPlanRef__r.Name
                ,RyoriTesuryoAri__c
                ,HenreihinTesuryoAri__c
                ,UrnOptionTesuryoFlg__c
                ,YorisoOptionFlowersTesuryoFlg__c
                ,OptionTesuryoAri__c
                ,AtobaraiTesuryoAri__c
                ,CardLoanTesuryoAri__c
            FROM 
                TesuryoTekiyo__c
            WHERE
                KeiyakuRef__c = :keiyakuId
            AND ShoninStatus__c = '承認済'
            AND TekiyoKaishiBi__c <= :fixedDate
            AND TekiyoSyuryoBi__c >= :fixedDate
            LIMIT 1
        ];
    }

    public ChargeCalculator(String oppId) {
        this.oppId = oppId;
        this.planChargePrice          = 0;
        this.sogishaOptionChargePrice = 0;
        this.yorisoOptionChargePrice  = 0;
        this.paymentChargePrice       = 0;

        Opportunity opp = getOppWithItemsWithPaymentsById(this.oppId);
        if (opp == null) {
            this.errMsgs.add('存在しない商談です。');
        }

        setTesuryoTekiyo(opp.SimpleYasugoRef__r.SimpleYasugoKeiyakuRef__c, opp.KakuteibiSyodan__c.date());
        if (this.tesuryoTekiyo == null) {
            this.errMsgs.add('有効な手数料適用が存在しません。');
        }

        setPlanWithDiscountWithOptionsByItems(opp.OpportunityLineItems);
        if (!isExistChargeMaster(tesuryoTekiyo.TesuryoPlanRef__c, this.planProduct2Id)) {
            this.errMsgs.add('プランに対する手数料設定が存在しません。');
        }
        for (ChargeItem item : this.sogishaOptionItems) {
            if (!isExistChargeMaster(tesuryoTekiyo.TesuryoPlanRef__c, item.id)) {
                this.errMsgs.add('葬儀社オプションに対する有効な手数料設定がありません。'
                    + tesuryoTekiyo.TesuryoPlanRef__r.Name
                    + '：'
                    + item.name
                );
            }
        }
        for (ChargeItem item : this.yorisoOptionItems) {
            if (!isExistChargeMaster(tesuryoTekiyo.TesuryoPlanRef__c, item.id)) {
                this.errMsgs.add('よりそうオプションに対する有効な手数料設定がありません。'
                    + tesuryoTekiyo.TesuryoPlanRef__r.Name
                    + '：'
                    + item.name
                );
            }
        }

        setPaymentItems(opp.KaisyuYoteisOpportunity__r);

        if (this.errMsgs.size() > 0) {
            throw new CalcChargeException(this.errMsgs);
        }
    }

    private void setPlanWithDiscountWithOptionsByItems(List<OpportunityLineItem> items) {
        for (OpportunityLineItem item : items) {
            String category   = item.Product2.k_ShohinCategory_Id_exp__c;
            String kbn        = item.Product2.Datakubun__c;
            switch on category {
                when 'chokusou', 'kasou', 'ichinichi', 'kazokusou', 'ippan' {
                    this.planProduct2Id = item.Product2Id;
                    this.planUnitPrice  = item.UnitPrice.intValue();
                }
                when 'sougiOption' {
                    this.sogishaOptionItems.add(
                        new ChargeItem(
                            item.Product2Id
                            ,isCalcChargeOptionItem(item.Product2.HinmokuBunrui__c, category)
                            ,item.Product2.Name
                            ,item.UnitPrice.intValue()
                            ,item.Quantity.intValue()
                        )
                    );
                }
                when 'yoriso-option', 'yoriso-option-campaign' {
                    this.yorisoOptionItems.add(
                        new ChargeItem(
                            item.Product2Id
                            ,isCalcChargeOptionItem(item.Product2.HinmokuBunrui__c, category)
                            ,item.Product2.Name
                            ,item.UnitPrice.intValue()
                            ,item.Quantity.intValue()
                        )
                    );
                }
                when 'waribiki' {
                    if (kbn == '2:割引プラン') {
                        this.planTotalDiscountPrice += item.UnitPrice.intValue();
                    }
                }
            }
        }
    }

    private void setPaymentItems(List<OkyakusamaSeikyuMeisai__c> meisais) {
        for (OkyakusamaSeikyuMeisai__c meisai : meisais) {
            if (meisai.SeikyuKingaku__c == null) {
                this.errMsgs.add('お客様請求明細(' + meisai.Name + ')の請求金額が未登録です。');
                continue;
            }
            this.paymentItems.add(
                new ChargeItem(
                    meisai.SeikyuHohoCode__c
                    ,isExistChargePaymentMaster(this.tesuryoTekiyo.TesuryoPlanRef__c, meisai.SeikyuHohoCode__c)
                    ,meisai.SeikyuHouhou__c
                    ,meisai.SeikyuKingaku__c.intValue()
                    ,1
                )
            );
        }
    }

    public void calc() {
        try {
            // プラン
            this.planChargePrice = calcCharge(this.planProduct2Id, this.planUnitPrice, 1, this.planTotalDiscountPrice);
            // 葬儀社オプション
            for (ChargeItem item : this.sogishaOptionItems) {
                if (!item.isCalc) continue;
                this.sogishaOptionChargePrice += calcCharge(item.id, item.unitPrice, item.quantity, 0);
            }
            // よりそうオプション
            for (ChargeItem item : this.yorisoOptionItems) {
                if (!item.isCalc) continue;
                this.yorisoOptionChargePrice += calcCharge(item.id, item.unitPrice, item.quantity, 0);
            }
            // 事務手数料
            for (ChargeItem item : this.paymentItems) {
                if (!item.isCalc) continue;
                this.paymentChargePrice += calcPaymentCharge(item.id, item.unitPrice);
            }
        } catch (Exception e) {
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20210115-1122-33', 'CargeCalculator')
                    .putAttr('oppId', this.oppId)
                    .putAttr('Exception', e.getMessage())
                    .putAttr('LineNumber', '' + e.getLineNumber())
                    .putAttr('getStackTraceString', e.getStackTraceString()
                )
            );
        }
    }

    private ChargeMasterTest__c getChargeMaster(String tesuryoPlanId, String product2Id) {
        for (ChargeMasterTest__c row : chargeMasters) {
            if (row.TesuryoPlanRef__c == tesuryoPlanId && row.Product2Ref__c == product2Id) {
                return row;
            }
        }

        return null;
    }

    private boolean isExistChargeMaster(String tesuryoPlanId, String product2Id) {
        ChargeMasterTest__c chargeMaster = getChargeMaster(tesuryoPlanId, product2Id);
        return (chargeMaster != null)? true : false;
    }

    private ChargePaymentMasterTest__c getChargePaymentMaster(String tesuryoPlanId, String paymentCode) {
        for (ChargePaymentMasterTest__c row : chargePaymentMasters) {
            if (row.TesuryoPlanRef__c == tesuryoPlanId && row.PaymentCode__c == paymentCode) {
                return row;
            }
        }

        return null;
    }

    private Boolean isExistChargePaymentMaster(String tesuryoPlanId, String paymentCode) {
        ChargePaymentMasterTest__c chargePaymentMaster = getChargePaymentMaster(tesuryoPlanId, paymentCode);
        return (chargePaymentMaster != null)? true : false;
    }

    private Boolean isCalcChargeOptionItem(String category, String hinmokuBunrui) {
        switch on category {
            when 'sougiOption', 'yasugou-option' {
                switch on hinmokuBunrui {
                    when '返礼品' {
                        if (this.tesuryoTekiyo.HenreihinTesuryoAri__c) {
                            return true;
                        }
                    }
                    when '料理' {
                        if (this.tesuryoTekiyo.RyoriTesuryoAri__c) {
                            return true;
                        }
                    }
                    when '骨壷ランクアップ' {
                        if (this.tesuryoTekiyo.UrnOptionTesuryoFlg__c) {
                            return true;
                        }
                    }
                    when else {
                        if (this.tesuryoTekiyo.OptionTesuryoAri__c) {
                            return true;
                        }
                    }
                }
            }
            when 'yoriso-option' {
                switch on hinmokuBunrui {
                    when 'お別れ花', '祭壇', '棺上花束', '枕花' {
                        if (this.tesuryoTekiyo.YorisoOptionFlowersTesuryoFlg__c) {
                            return true;
                        }
                    }
                    when else {
                        if (this.tesuryoTekiyo.OptionTesuryoAri__c) {
                            return true;
                        }
                    }
                }
            }
            when else {
                return true;
            }
        }

        return false;
    }

    private integer calcCharge(
        String  id
        ,Integer unitPrice
        ,Integer quantity
        ,Integer discountPrice
    ) {
        Integer chargePrice = 0;

        ChargeMasterTest__c chargeMaster = getChargeMaster(
            this.tesuryoTekiyo.TesuryoPlanRef__c
            ,id
        );

        if (chargeMaster.Type__c == '1') {
            chargePrice = calcChargeForFix(chargeMaster.FixedFeePrice__c.intValue(), quantity);
        } else if (chargeMaster.Type__c == '2') {
            chargePrice = calcChargeForRate(unitPrice, quantity, discountPrice, chargeMaster.FeeRate__c, chargeMaster.OwnCoverPrice__c.intValue());
        }

        return chargePrice;
    }

    private integer calcPaymentCharge(
        String  id
        ,Integer unitPrice
    ) {
        Integer chargePaymentPrice = 0;

        ChargePaymentMasterTest__c chargePaymentMaster = getChargePaymentMaster(
            this.tesuryoTekiyo.TesuryoPlanRef__c
            ,id
        );

        if (chargePaymentMaster.Type__c == '1') {
            chargePaymentPrice = calcChargeForFix(chargePaymentMaster.FixedFeePrice__c.intValue(), 1);
        } else if (chargePaymentMaster.Type__c == '2') {
            chargePaymentPrice = calcChargeForRate(unitPrice, 1, 0, chargePaymentMaster.FeeRate__c, 0);
        }

        return chargePaymentPrice;
    }

    private Integer calcChargeForRate(
        Integer unitPrice
        ,Integer quantity
        ,Integer discountPrice
        ,Decimal rate
        ,Integer ownCoverPrice
    ) {
        Integer chargePrice = 0;

        if (unitPrice > 0 && quantity > 0 && rate > 0) {
            Decimal tmpChargePrice = (unitPrice + discountPrice + ownCoverPrice) * rate - ownCoverPrice;
            if (tmpChargePrice >= 0) {
                tmpChargePrice = tmpChargePrice * quantity;
                chargePrice = tmpChargePrice.round(System.RoundingMode.DOWN).intValue();
            }
        }

        return chargePrice;
    }

    private Integer calcChargeForFix(Integer unitChargePrice, Integer quantity) {
        Integer chargePrice = 0;

        if (quantity > 0) {
            chargePrice = unitChargePrice * quantity;
        }

        return chargePrice;
    }
}