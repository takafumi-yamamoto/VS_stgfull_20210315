@isTest
public class ObStSynBatActivatorT {
	@isTest static void doTest_scheduleNew(){
		new ObStSynBatActivator().scheduleNew();
	}
	@isTest static void doTest_run(){
		new ObStSynBatActivator().run();
	}
}