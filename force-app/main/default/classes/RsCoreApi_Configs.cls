public class RsCoreApi_Configs {

	public static KaiinkibanSetting__c getConfig(){
		//if sandbox then dev config else //dev config
    	if(Environments.isSandbox()){
    		return KaiinkibanSetting__c.getInstance('dev');
    	} else {
    		return KaiinkibanSetting__c.getInstance('prod');
    	}
	}

}