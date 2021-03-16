public class Ctl_WaribikiShouhin {

    public void addWaribikiShouhin(List<OpportunityLineItem> newList) {

        Set<String> theOppIds = new Set<String>(); for(OpportunityLineItem aLineItem : newList){ theOppIds.add( aLineItem.OpportunityId ); }
        Map<String, WrTkCtxs.ContextData> theOppIdToWaribikiContext = new WrTkCtxs().selectContextDataByOppIds(new List<String>(theOppIds) );

        List<OpportunityLineItem> theWaribkiLineItems = new List<OpportunityLineItem>();
        for( OpportunityLineItem aLineItem : newList ){
            if(!aLineItem.isAutoAddWaribkiItem__c) continue;
            WrTkCtxs.ContextData theWaribkiContext = theOppIdToWaribikiContext.get( aLineItem.OpportunityId );
            for( String aWaribikiShohinBango : new WrTks().getWaribikiShohinBangos(theWaribkiContext, aLineItem.ProductShohinBangoExp__c) ){
                PriceBookDao.PriceBookEnt thePriceBookEnt = PriceBookDao.instance().getEntry(theWaribkiContext.PricebookId, aWaribikiShohinBango);
                Decimal thePrice = thePriceBookEnt.UnitPrice;
                if(aWaribikiShohinBango == 'SBG-0000214') thePrice = -2200; // その他お客様向け割引（CS起因）葬儀用ブーケキャンペーン対応不可用
                theWaribkiLineItems.add(
                    new OpportunityLineItem( 
                        Product2Id = thePriceBookEnt.Product2Id,
                        OpportunityId = aLineItem.OpportunityId,
                        Quantity = 1,
                        UnitPrice = thePrice
                    )
                );
            }
        }
        if( theWaribkiLineItems.size() > 0 ) INSERT theWaribkiLineItems;
    }

}