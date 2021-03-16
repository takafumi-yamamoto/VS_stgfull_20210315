public class Ctl_Pricebook {
   /**
	 * PriceBookIdを取得
	 * @param opportunity> opp　商談
	 * @return null
	 */    
    public String getPriceBookId() {
        system.debug('====================Ctl_Pricebook.getPriceBookId.begin===================');

        String pbId = '';
        if (Test.isRunningTest()) { 
            pbId = Test.getStandardPricebookId();
        }
        else{

            pbId = [select id,name from pricebook2 where IsStandard = true].Id;
        }

        system.debug('====================Ctl_Pricebook.getPriceBookId.end===================');
	    return pbId;
    }
}