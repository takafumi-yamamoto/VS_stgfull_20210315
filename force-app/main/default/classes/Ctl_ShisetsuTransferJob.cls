public class Ctl_ShisetsuTransferJob{}
// public class Ctl_ShisetsuTransferJob implements Queueable,Database.AllowsCallouts{
    
//     	List<Shisetsu__c> ShisetsuTransferList;
//     	String InsertOrUpdateFlag;
    	
//     	public Ctl_ShisetsuTransferJob(List<Shisetsu__c> syoriList,String InsertUpdateFlag){
//     		this.ShisetsuTransferList = syoriList;
//     		this.InsertOrUpdateFlag=InsertUpdateFlag;
//     	}

// 	    public void execute(QueueableContext context) {
// 	    	system.debug('***Ctl_ShisetsuTransferJob.execute.begin***');	    	
//           	System.debug('callout');
//           	System.debug(ShisetsuTransferList);
//             if(ShisetsuTransferList != null && ShisetsuTransferList.size() > 0){
//             	Ctl_ShisetsuTransferService service = new Ctl_ShisetsuTransferService();            	
//             	service.InsertOrUpdateFlag=InsertOrUpdateFlag;
//             	service.requestTransfer(ShisetsuTransferList);        
            	
//             }
//             system.debug('***Ctl_ShisetsuTransferJob.execute.end***');   
// 	    }

// }
/*public class Ctl_ShisetsuTransferJob implements Queueable,Database.AllowsCallouts{
    
    	List<Shisetsu__c> ShisetsuTransferList;
    	String InsertOrUpdateFlag;
    	
    	public Ctl_ShisetsuTransferJob(List<Shisetsu__c> syoriList,String InsertUpdateFlag){
    		this.ShisetsuTransferList = syoriList;
    		this.InsertOrUpdateFlag=InsertUpdateFlag;
    	}

	    public void execute(QueueableContext context) {
	    	/*system.debug('***Ctl_ShisetsuTransferJob.execute.begin***');	    	
          	System.debug('callout');
          	System.debug(ShisetsuTransferList);
            if(ShisetsuTransferList != null && ShisetsuTransferList.size() > 0){
            	Ctl_ShisetsuTransferService service = new Ctl_ShisetsuTransferService();            	
            	service.InsertOrUpdateFlag=InsertOrUpdateFlag;
            	service.requestTransfer(ShisetsuTransferList);        
            	
            }
            system.debug('***Ctl_ShisetsuTransferJob.execute.end***');*/
/*            system.debug('***Ctl_ShisetsuTransferJob.execute.begin***');
            Com_LatitudeAndLongitude.setLatitudeAndLongitude(Shisetsu__c.getSObjectType().getDescribe().getName(),ShisetsuTransferList);
            system.debug('***ShisetsuTransferList='+ShisetsuTransferList);
            system.debug('***Ctl_ShisetsuTransferJob.execute.end***');
            
            
	    }

}*/