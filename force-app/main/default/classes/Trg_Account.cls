public class Trg_Account{

	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	public Trg_Account(boolean isExecuting, integer size){
	    m_isExecuting = isExecuting;
	    BatchSize = size;
	}

	public void OnBeforeDelete(List<Account> oldAccountList){
		new Ctl_Account().checkDuplicateAccountMerge(oldAccountList);
		new Ctl_AccountDeleteHistory().createDeleteHistory(oldAccountList);
		new OboStSynVer().OnAccountBeforeDelete(oldAccountList);
	}

    public void OnBeforeInsert(List<Account> newAccountList){

		Ctl_Account.subscriveAccountBeforeInsert(newAccountList);
		new Nayose().nayoseSogisha(newAccountList, null);
		new Nayose().nayoseCustomer(newAccountList, null);
		new Ctl_Account().initialProcessing(newAccountList, null);
		new Utility_Account().StandardMobileToCustomMobile(newAccountList);
		Ctl_Account.formatBillingPostalCode(newAccountList,null);            
		// 個人取引先（AccountからContactへのコピー処理)
		new CopyIndividualAccounts().OnBeforeInsert(newAccountList);
		
    }

    public void OnBeforeUpdate(List<Account> newAccountList, Map<ID, Account> oldAccountMap){

		Ctl_Account.subscriveAccountBeforeUpdate(newAccountList,oldAccountMap);
		new Nayose().nayoseSogisha(newAccountList, oldAccountMap);
		new Nayose().nayoseCustomer(newAccountList, oldAccountMap);
		new Ctl_Account().initialProcessing(newAccountList, oldAccountMap);
		Ctl_Account.formatBillingPostalCode(newAccountList,oldAccountMap);
		// 経理の送客停止処理
		new KeiriSokyakuTeishi().OnBeforeUpdate(newAccountList,oldAccountMap);
        // 個人取引先（AccountからContactへのコピー処理)
        new CopyIndividualAccounts().OnBeforeUpdate(newAccountList,oldAccountMap);

    }

	public void OnAfterInsert(List<Account> newAccountList){
		new Ctl_JudenLogHang().todoHang(newAccountList, null);
		// issues4156 --Start--
        //よりそう会員化済の設定処理として利用する
        new JizenwariMemberToroku().checkJizenwariMemberTorokuInsert(newAccountList);
		// issues4156 --end--
        new JizenJunbiSheetToroku().checkJizenJunbiSheetTorokuInsert(newAccountList);
        new Ctl_Account().copyContact(newAccountList, null);
		//緯度経度を設定 
		new AcntGeoLocQms.QueuingOnAccountAfterInsert().enqueAccountLocationUpdates(newAccountList);
		// キャンペーンのアチーブメント追加処理
		new Ctl_Achievement_CampaignSougiBouquet().OnAfterInsert(newAccountList);
	}

	public void OnAfterUpdate(List<Account> newAccountList, Map<ID, Account> oldAccountMap){
		new Ctl_JudenLogHang().todoHang(newAccountList, oldAccountMap);
		// issues4156 --Start--
        //よりそう会員化済の設定処理として利用する
        new JizenwariMemberToroku().checkJizenwariMemberTorokuUpdate(newAccountList, oldAccountMap);
		// issues4156 --end--
        new JizenJunbiSheetToroku().checkJizenJunbiSheetTorokuUpdate(newAccountList, oldAccountMap);
        new Ctl_Account().copyContact(newAccountList, oldAccountMap);
		//緯度経度を設定
		new AcntGeoLocQms.QueuingOnAccountAfterUpdate().enqueAccountLocationUpdates(newAccountList, oldAccountMap);
		new GlbSearchingByAccount().subscriveOnAccountAfterUpdated(newAccountList, oldAccountMap);
		new Ctl_Account().changeKeiyakuName(newAccountList, oldAccountMap);
        new OboStSynVer().OnAccountAfterUpdate(newAccountList, oldAccountMap);
		// 経理の送客停止処理
		new KeiriSokyakuTeishi().OnAfterUpdate(newAccountList,oldAccountMap);
		// 電話流入SMS配信
		new SogiSmsFollowEffectMeasurement().OnAccountAfterUpdate(newAccountList,oldAccountMap);
		// キャンペーンのアチーブメント追加処理
		new Ctl_Achievement_CampaignSougiBouquet().OnAfterUpdate(newAccountList,oldAccountMap);
    }

	public void OnAfterDelete(List<Account> oldAccountList, Map<ID, Account> oldAccountMap){}

}