public class PtWebAccounts_ActivatingWebAccount {

    private static String f_startRequestName = PtWebAccounts_ActivatingWebAccountTask.Class.toString();

    public class PtWebAccounts_ActivatingWebAccountTask implements Queueable{

        private Id f_TaskId = null;

        public PtWebAccounts_ActivatingWebAccountTask(Id pTaskId){ this.f_TaskId = pTaskId; }

        public void run(){

            List<PtWebAccountStatusChanged__c> theTasks = new List<PtWebAccountStatusChanged__c>(
                [
                    select 
                    Id, ExternalId__c, torihikisaki_bango__c, mailaddress__c, status__c
                    from PtWebAccountStatusChanged__c 
                    where Id = :this.f_TaskId and status__c = 'Activated'
                ]
            );
            if( theTasks.size() <= 0 ) return;
            PtWebAccountStatusChanged__c theTask = theTasks.get(0);

            List<Account> theAccounts = [ select Id, PtWebAccountRef__c from Account where TorihikisakiBango__c = :theTask.torihikisaki_bango__c ];
            if( theAccounts.size() <= 0 ) {
                theTask.ShoriStatus__c = 'Faulted'; 
                Update theTask;
                return;
            }
            Account theAccount = theAccounts.get(0);

            //Delete [select Id from PtWebAccount__c where Id = :theAccount.PtWebAccountRef__c ];
            PtWebAccount__c[] existPtWebAccs = [
                SELECT
                    Id
                    ,mailAddress__c
                FROM
                    PtWebAccount__c
                WHERE
                    ExternalId__c = :theTask.ExternalId__c
                AND
                    AccountRef__c = :theAccount.Id
                LIMIT 1
            ];

            // 更新
            if (existPtWebAccs.size() == 1) {
                PtWebAccount__c ptWebAcc = existPtWebAccs.get(0);
                ptWebAcc.mailAddress__c  = theTask.mailaddress__c;
                update ptWebAcc;
            // 新規
            } else {
                PtWebAccount__c ptWebAcc = new PtWebAccount__c(
                    mailAddress__c = theTask.mailaddress__c
                    ,ExternalId__c = theTask.ExternalId__c
                    ,AccountRef__c = theAccount.Id
                );
                insert ptWebAcc;

                PtWebAccountIrai__c[] existPtWebAccIrais = [
                    SELECT
                        Id
                    FROM
                        PtWebAccountIrai__c
                    WHERE
                        MailAddress__c = :theTask.mailAddress__c
                    LIMIT 1
                ];

                if (existPtWebAccIrais.size() == 1) {
                    PtWebAccountIrai__c ptWebAccIrai = existPtWebAccIrais.get(0);
                    ptWebAccIrai.PtWebAccountRef__c = ptWebAcc.Id;
                    update ptWebAccIrai;
                }

                theAccount.UsePtWebFlg__c = true;
                update theAccount;
            }
            //theAccount.PtWebAccountRef__c = thePtWebAccount.Id;
            //Update theAccount;

            theTask.ShoriStatus__c = 'Completed'; 
            Update theTask;
        }

        //implements Queueable Begin
        public void execute(QueueableContext context) { this.run(); }
        //implements Queueable End
    }

    private static void sendStartRequest(){
        Asyncs_Broker.requestStart( f_startRequestName );
    }

    private void start(){
        List<PtWebAccountStatusChanged__c> theTasks = new List<PtWebAccountStatusChanged__c>(
            [
                select Id
                from PtWebAccountStatusChanged__c 
                where ShoriStatus__c = 'Created' and Status__c = 'Activated'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 20
                for update
            ]
        );
        for(PtWebAccountStatusChanged__c aTask : theTasks){ aTask.ShoriStatus__c = 'Running'; }
        Update theTasks;

        for(PtWebAccountStatusChanged__c aTask : theTasks){ System.enqueueJob( new PtWebAccounts_ActivatingWebAccountTask(aTask.Id) ); }

        List<PtWebAccountStatusChanged__c> theTaskLeft = new List<PtWebAccountStatusChanged__c>(
            [
                select Id
                from PtWebAccountStatusChanged__c 
                where ShoriStatus__c = 'Created' and Status__c = 'Activated'
                and LastModifiedDate >= :DateTime.now().addDays(-30)
                limit 1
            ]
        );
        if( theTaskLeft.size() >= 1 ) sendStartRequest();
    }

    public static void subscriveOnAyncBrokerOnRunRequested(string pRequestName){
        if(pRequestName == f_startRequestName ){ 
            new PtWebAccounts_ActivatingWebAccount().start();
        }
    }

    public void subscriveOnPtWebAccountStatusChangedAfterInserted(List<PtWebAccountStatusChanged__c> pNewOnes){
        sendStartRequest();
    }
}