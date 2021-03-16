public class Ctl_ShisetsuCoreTransferJob{}

// public class Ctl_ShisetsuCoreTransferJob implements Queueable,Database.AllowsCallouts{
    
//     	List<Shisetsu__c> ShisetsuTransferList;
//     	String InsertOrUpdateFlag;
    	
//     	public Ctl_ShisetsuCoreTransferJob(List<Shisetsu__c> syoriList,String InsertUpdateFlag){
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