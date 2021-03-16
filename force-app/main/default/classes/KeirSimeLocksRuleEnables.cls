public class KeirSimeLocksRuleEnables {
	private static Boolean mIsEnabled = true;
	public static void turnOnLockRule(){mIsEnabled = true; }
	public static void turnOffLockRule(){mIsEnabled = false; }
	public static Boolean isEnabled() { return mIsEnabled; }
}