trigger AccountChangeTaskProcessReqTrigger on AccountChangeTaskProcessReq__e (after insert) {
	AccountChangedTaskProcessor process = new AccountChangedTaskProcessor(Trigger.New);
	process.run();
}