@isTest
private class SogiMitsumoriKeisanhyoHinmokuPriceT {
    
    @isTest static void testMethod_case1(){
        SogiMitsumoriKeisanhyoHinmokuPrice.IPrice_Calculator iPrice_Calculator_instance = SogiMitsumoriKeisanhyoHinmokuPrice.get_IPrice_Calculator_instance();
        iPrice_Calculator_instance.get_priceBookEntry_map();

        SogiMitsumoriKeisanhyoHinmokuPrice.OppData oppData = new SogiMitsumoriKeisanhyoHinmokuPrice.OppData();
        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.Plan;
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.KaiinWaribiki;
        oppData.kaiinKubun = 'よりそう会員';
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.KaiinWaribiki;
        oppData.kaiinKubun = '旧よりそう会員';
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.KaiinWaribiki;
        oppData.kaiinKubun = 'お葬式予約会員';
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.ButsuguNashiWaribiki;
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.JizenAnketoWaribiki;
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.ShikigoAnketoWaribiki;
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.SoryoTehai;
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.KaimyoHomyo;
        oppData.kaimyoHomyoKubun = '院居士';
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.SaidanUpGread;
        oppData.shohinCode = 'SBG-0005406';
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.YorisoOption;
        oppData.shohinCode = 'SBG-0005419';
        iPrice_Calculator_instance.get_hinmoku_price(oppData);

        oppData.hinmoku = SogiMitsumoriKeisanhyoHinmokuPrice.Hinmoku.AllianceWaribiki;
        oppData.shohinCode = 'SBG-0003620';
        iPrice_Calculator_instance.get_hinmoku_price(oppData);
    }
}