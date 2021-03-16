public class SpfyOppNew {

    public interface IOppCreator {
        void createNew(Decimal pOrderId);
    }
    public class OppCreator implements IOppCreator{
        private SpfyOrdersGet.IClient mSpfyOrdersGetClinet;
        private SpfyOppShohinBango.ShohinBangoForOppLineItems mShohinBangoForOppLineItems;
        private SpfyOppNewAcntRslv.IAccountResolver mAccountResolver;
        private SpfyNoteShipDates.SpfyNoteShipDate mSpfyNoteShipDate;
        private SpfyOppStages.StageRsolver mStageRsolver;
        private SpfyCyumonJohoTxt.ICyumonJohoTexter mCyumonJohoTexter;


        public OppCreator(
            SpfyOrdersGet.IClient pSpfyOrdersGetClient, 
            SpfyOppShohinBango.ShohinBangoForOppLineItems pShohinBangoForOppLineItems,
            SpfyOppNewAcntRslv.IAccountResolver pAccountResolver,
            SpfyNoteShipDates.SpfyNoteShipDate pSpfyNoteShipDate,
            SpfyOppStages.StageRsolver pStageRsolver,
            SpfyCyumonJohoTxt.ICyumonJohoTexter pCyumonJohoTexter
        ){
            this.mSpfyOrdersGetClinet = pSpfyOrdersGetClient;
            this.mShohinBangoForOppLineItems = pShohinBangoForOppLineItems;
            this.mAccountResolver = pAccountResolver;
            this.mSpfyNoteShipDate = pSpfyNoteShipDate;
            this.mStageRsolver = pStageRsolver;
            this.mCyumonJohoTexter = pCyumonJohoTexter;
        }

        public void createNew(Decimal pOrderId){
            this.createNew(
                this.mSpfyOrdersGetClinet.getOrder(pOrderId)
            );
        }

        public void createNew(SpfyApi_OrdersGetEx.Order pOrder){

            String theAccountId =
                this.mAccountResolver.resolveAccount(
                    new SpfyOppNewAcntRslv.Req()
                        .set_customer_id(pOrder.customer.id)
                        .set_first_name(pOrder.customer.first_name)
                        .set_last_name(pOrder.customer.last_name)
                        .set_phone(pOrder.customer.phone == null ? pOrder.billing_address.phone : pOrder.customer.phone)
                        .set_email(pOrder.customer.email)
                        .set_address_zip(pOrder.customer.zip)
                        .set_address_province(pOrder.customer.province)
                        .set_address_city(pOrder.customer.city)
                        .set_address_address1(pOrder.customer.address1)
                        .set_address_address2(pOrder.customer.address2)
                )
                .AccountId;

            BestButsudan__c theBest = new BestButsudan__c(
                ChumonId__c = pOrder.name,
                ShohinTodokesaki__c = '	別の住所に送る',
                TodokesakiName__c = 
                    String.join( new List<String>{ pOrder.shipping_address.last_name, pOrder.shipping_address.first_name }, ' '),
                TodokesakiZipCode__c = pOrder.shipping_address.zip,
                TodokesakiState__c = pOrder.shipping_address.province,
                TodokesakiCity__c = pOrder.shipping_address.city,
                TodokesakiStreet__c = 
                    String.format('{0}{1}', new List<String>{
                        String.isBlank(pOrder.shipping_address.address1) ? '' :  pOrder.shipping_address.address1,
                        String.isBlank(pOrder.shipping_address.address2) ? '' :  pOrder.shipping_address.address2
                    }),
                TodokesakiTelNo__c = pOrder.shipping_address.phone,
                ChumonJoho__c = this.mCyumonJohoTexter.getText(pOrder)
            );
            INSERT theBest;

            SpfyOrder__c theSpfyOrder = new SpfyOrder__c(
                idfr__c = GuidUtil.NewGuid(),
                spfyOrder_Id__c = pOrder.id,
                OrderNumber__c = pOrder.order_number,
                OrderName__c = pOrder.name,
                created_at__c = pOrder.created_at,
                financial_status__c = pOrder.financial_status,
                gateway__c = pOrder.gateway,
                checkout_id__c = pOrder.checkout_id,
                fulfillment_status__c = pOrder.fulfillment_status == null ? 'unshipped' : pOrder.fulfillment_status,
                order_status_url__c = pOrder.order_status_url,
                cancelled_at__c = pOrder.cancelled_at,
                note__c = pOrder.note,
                total_line_items_price__c = pOrder.total_line_items_price,
                total_discounts__c = pOrder.total_discounts*-1,
                total_shipping_lines_price__c = pOrder.total_shipping_lines_price,
                total_tax__c = pOrder.total_tax,
                total_price__c = pOrder.total_price,

                bill_addr_first_name__c = pOrder.billing_address.first_name,
                bill_addr_last_name__c = pOrder.billing_address.last_name,
                bill_addr_phone__c = pOrder.billing_address.phone,
                bill_addr_zip__c = pOrder.billing_address.zip,
                bill_addr_province__c = pOrder.billing_address.province,
                bill_addr_city__c = pOrder.billing_address.city,
                bill_addr_address1__c = pOrder.billing_address.address1,
                bill_addr_address2__c = pOrder.billing_address.address2,

                ship_addr_first_name__c = pOrder.shipping_address.first_name,
                ship_addr_last_name__c = pOrder.shipping_address.last_name,
                ship_addr_phone__c = pOrder.shipping_address.phone,
                ship_addr_zip__c = pOrder.shipping_address.zip,
                ship_addr_province__c = pOrder.shipping_address.province,
                ship_addr_city__c = pOrder.shipping_address.city,
                ship_addr_address1__c = pOrder.shipping_address.address1,
                ship_addr_address2__c = pOrder.shipping_address.address2
            );
            INSERT theSpfyOrder;

            RefHub4Opp__c theRefHub4Opp = new RefHub4Opp__c(
                idfr__c = GuidUtil.NewGuid(),
                SpfyOrderRef__r = new SpfyOrder__c( idfr__c = theSpfyOrder.idfr__c )
            );
            INSERT theRefHub4Opp;

            Date theShipDate = this.mSpfyNoteShipDate.getShipDate(pOrder.note);
            SpfyOppStages.Res theSpfyOppStagesRes = 
                this.mStageRsolver.getStageNext(
                    new SpfyOppStages.Req()
                        .set_prevStageName(null)
                        .set_prevSubPhase(null)
                        .set_cancelled_at(pOrder.cancelled_at)
                        .set_financial_status(pOrder.financial_status)
                        .set_gateway(pOrder.gateway)
                        .set_fulfillment_status(pOrder.fulfillment_status)
                        .set_shipDate(theShipDate)
                );

            Opportunity theOpp = new Opportunity(
                RecordTypeId = RecordTypeCachedDaos.getInstance().SelectIdByObjectTypeNameAndDevName('Opportunity','KakuyasuButsudan'),
                Name = 
                String.join(
                    new List<String>{ pOrder.billing_address.last_name + ' ' + pOrder.billing_address.first_name + '_ベスト仏壇', pOrder.name },
                    ' '
                ),
                StageName = theSpfyOppStagesRes.nextStageName,
                SubPhase__c = theSpfyOppStagesRes.nextSubPhase,
                Req_Day__c = pOrder.created_at,
                KakuteibiSyodan__c = pOrder.created_at,
                CloseDate = Date.newInstance(pOrder.created_at.year(), pOrder.created_at.month(), pOrder.created_at.day()),
                Utiagebi__c = theShipDate,
                //KiboShiharaiHouhou__c = pOrder.gateway,
                AccountId = theAccountId,
                BestButsudanRef__c = theBest.Id,
                RefHub4OppRef__r = new RefHub4Opp__c(idfr__c = theRefHub4Opp.idfr__c),
                SpfyOrderName__c = pOrder.name
            );
            INSERT theOpp;

            List<SpfyLineItem__c> theSpfyLineItems = new List<SpfyLineItem__c>();
            for(SpfyApi_OrdersGetEx.LineItem aLineItem : pOrder.line_items){
                theSpfyLineItems.add(
                    new SpfyLineItem__c(
                        idfr__c = GuidUtil.NewGuid(),
                        lineItemId__c = aLineItem.id,
                        name__c = aLineItem.name,
                        OppRef__c = theOpp.Id,
                        price__c = aLineItem.price,
                        quantity__c = aLineItem.quantity,
                        sku__c = aLineItem.sku,
                        SpfyOrderRef__r = new SpfyOrder__c( idfr__c = theSpfyOrder.idfr__c ),
                        title__c = aLineItem.title,
                        variant_title__c = aLineItem.variant_title,
                        properties__c = aLineItem.getPropsText()
                    )
                );
            }
            INSERT theSpfyLineItems;

            INSERT new OpportunityLineItem(
                OpportunityId = theOpp.Id,
                Product2 = new Product2( ShohinBango__c = this.mShohinBangoForOppLineItems.getShohinBango() ),
                UnitPrice = pOrder.total_price,
                Quantity = 1
            );

            if(pOrder.financial_status == 'paid'){
                INSERT new OkyakusamaSeikyuMeisai__c(
                    OpportunityRef__c = theOpp.Id,
                    RecordTypeId = Schema.SObjectType.OkyakusamaSeikyuMeisai__c.getRecordTypeInfosByDeveloperName().get('KobetsuSeikyu').getRecordTypeId(),
                    ServiceSyubetsu__c = 'ベスト仏壇',
                    SeikyuHouhou__c = 'shopify-paid',
                    SeikyuKingaku__c = pOrder.total_price,
                    Kessaibi__c = Date.newInstance(pOrder.created_at.year(), pOrder.created_at.month(), pOrder.created_at.day())
                );
            }

        }
    }

}