public class Trg_PtWebAccountIrai {

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_PtWebAccountIrai(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}    

    public void OnBeforeInsert(List<PtWebAccountIrai__c> pNewOnes){
        Map<Id, Account> theMapOfAccountIdToAccount = this.selectAccounts(pNewOnes, null);
        for(PtWebAccountIrai__c aNewOne : pNewOnes){
            if( !String.isBlank(aNewOne.MailAddress__c) ) continue;
            if( aNewOne.IraiKubun__c != '新規' ) continue;
            if( !theMapOfAccountIdToAccount.containsKey ( aNewOne.AccountRef__c ) ) continue;
            aNewOne.MailAddress__c = theMapOfAccountIdToAccount.get(aNewOne.AccountRef__c).MailAddress__c;
        }
    }

    public void OnBeforeUpdate(List<PtWebAccountIrai__c> pNewOnes) {
        for (PtWebAccountIrai__c pNewOne : pNewOnes) {
            validate(pNewOne);
        }
    }

	public void OnAfterUpdate(List<PtWebAccountIrai__c> pNewOnes, Map<ID, PtWebAccountIrai__c> pOldOnes){
        new PtWebAccounts_IssuingNewAccount().subscrivePtWebAccountIraiOnAfterUpdated(pNewOnes, pOldOnes, this.selectAccounts(pNewOnes, null));
        new PtWebAccounts_InvalidatingWebAccount().subscrivePtWebAccountIraiOnAfterUpdated(pNewOnes, pOldOnes);
	}  

    private Map<Id,Account> selectAccounts(List<PtWebAccountIrai__c> pNewOnes, Map<ID, PtWebAccountIrai__c> pOldOnes){
        Set<Id> theAccountIds = new Set<Id>();
        for(PtWebAccountIrai__c aNewOne : pNewOnes){ theAccountIds.add(aNewOne.AccountRef__c); }
        Map<Id,Account> theAccounts = new Map<Id,Account>(
            [
                select Id, MailAddress__c, PtWebAccountRef__c
                from Account
                where Id = :theAccountIds
            ]
        );
        return theAccounts;
    }

    private static boolean isValidDeletingMailAddress(string ptAccId, string mailAddress) {
        Integer validCnt = [
            SELECT
                COUNT()
            FROM
                PtWebAccount__c
            WHERE
                MailAddress__c = :mailAddress
            AND
                AccountRef__c = :ptAccId
        ];
        return (validCnt == 1) ? true : false;
    }

    private static void validate(PtWebAccountIrai__c ptWebAccIrai) {
        if (ptWebAccIrai.IraiKubun__c == '削除') {
            if (!isValidDeletingMailAddress(ptWebAccIrai.AccountRef__c, ptWebAccIrai.mailAddress__c)) {
                ptWebAccIrai.addError('このパートナーに属していないメールアドレスのため、削除できません。\n');
                return;
            }
        }
    }
}