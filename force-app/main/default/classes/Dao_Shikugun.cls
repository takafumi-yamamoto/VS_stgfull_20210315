public class Dao_Shikugun {
	private static Dao_Shikugun instance;
	public static Dao_Shikugun getInstance(){
		if(instance == null){ instance = new Dao_Shikugun(); }
		return instance;
	}
	private Dao_Shikugun(){}

	public List<Shikugun__c> getAvaliableShikugunList(){
		return Database.query('SELECT Id, Name, AreaCode__c, ShikugunMeiFurigana__c, ShikugunMei__c, TodoufuKenRef__r.Name, Muko__c FROM Shikugun__c WHERE Muko__c = false');
	}



	static final String SELECT_FROM  = ' SELECT '
                                    + ' Id, '
									+ ' Name '
                                    // + ' TodoufuKenRef__c, '
                                    // + ' TodoufuKenRef__r. '

                                    + ' FROM Shikugun__c ';

	static public List<Shikugun__c> getShikugunList(String strWhereParam, String strOrderByParam){
		return Database.query(SELECT_FROM + strWhereParam + strOrderByParam);
	}

	/**
	 * 指定都道府県レコード取得
	 * 20171205 必要そうだが、使用場面がないため、コメントアウト
	 * @Auther Mizuno
	 * @param  state 都道府県名
	 */
	// static public List<Shikugun__c> SearchShikugunByStateName(String state){
	// 	String strWhereParam = 'WHERE TodoufuKenRef__r.Name=:state';
	// 	String strOrderByParam = '';
	// 	return getShikugunList(strWhereParam, strOrderByParam);
	// }

	/**
	 * 都道府県名+市区群 (市区群マスタName項目)でレコード取得
	 */
	static public List<Shikugun__c> SearchShikugunByFullName(String stateCity){
		// TODO Memo mizuno 
		// インジェクション防止の観点では、パラメータをListで渡し、バインド変数を使用する形が望ましい。
		// ※Database.Queryを実行するステートメント(⇒getShikugunList内)で、バインド変数と同名の変数を定義する必要がある。	
		String strWhereParam = 'WHERE Name=\''+stateCity+'\''; 

		String strOrderByParam = 'ORDER BY Id ASC';
		return getShikugunList(strWhereParam, strOrderByParam);
	}

	// 
	// 20171206 反復呼び出しを行うパターンが少ないため、コメントアウト
	// 
	// /**
	//  * SOQLクエリ発行数低減のため、メモリ上にデータをロードして各種検索を行う。
	//  * インデックスは効かないため、レコード数とクエリ数の制限状況により推奨は異なる。
	//  * 
	//  * 
	//  * @Auther Mizuno
	//  */ 
	// public class OnMemoryDB {
	// 	private List<Shikugun__c> shikigunList;
	// 	/**
	// 	 * レコードをメモリ上にロード
	// 	 * コストがかかる処理のため、あえてコンストラクタで実行しない。
	// 	 */
	// 	public void load() {
	// 		shikigunList = getShikugunList('','');
	// 	}

	// 	/**
	// 	 * レコードをメモリ上にロード(都道府県指定)
	// 	 * @Auther Mizuno
	// 	 */ 
	// 	public void load(String state) {
	// 		shikigunList = SearchShikugunByStateName(state);
	// 	}

	// 	/**
	// 	 * IDによる市区群検索
	// 	 * @Auther Mizuno
	// 	 * @param  recordId 市区群レコードID
	// 	 * @return          市区群オブジェクト
	// 	 */ 
	// 	public Shikugun__c getById(String recordId) {
	// 		Map<Id,Shikugun__c> shikigunMap = new Map<Id,Shikugun__c>(shikigunList); 
	// 		return (shikigunMap.containsKey(recordId)) ? shikigunMap.get(recordId) : null;
	// 	}

	// 	/**
	// 	 * 都道府県名+市区群による市区群検索
	// 	 * @param  stateCity 都道府県+市区郡(例：東京都新宿区高田馬場)
	// 	 * @return           市区群オブジェクト
	// 	 */
	// 	public Shikugun__c getByFullName(String stateCity) {
	// 		if(String.isBlank(stateCity)) return null;

	// 		for(Shikugun__c shikugun : shikigunList) {
	// 			if(stateCity.equals(shikugun.Name)) return shikugun;
	// 		}
	// 		return null;
	// 	}

	// }
}