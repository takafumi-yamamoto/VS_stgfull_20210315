/**
 * Apexコールアウトにて、テストモードの使用
 * @Auther Mizuno
 *
 * TODO テストモード実装に関して問題ないか確認
 */
public class Com_CalloutWrapper {
	/*

    // テストモード動作の際のモックインスタンスを指定
    public HttpCalloutMock mockImpl;
    // テストモード設定
    public Boolean isTestMode;

    // モック実装
    public Com_CalloutWrapper (HttpCalloutMock mockImpl, Boolean isTestMode) {
        this.mockImpl = mockImpl;
        this.isTestMode = isTestMode;
    }


    /**
     * Apexコールアウト処理のラッパークラス。
     * カスタム設定のテストモード設定に応じて、コールアウト/モックの動作を切り替えて実行する。
     *
     * @Auther Mizuno
     * @param  req Httpリクエスト
     * @return     Httpレスポンス（テストモードの場合はモック結果）
     */ 
   /* public HttpResponse callout(HttpRequest req) {
        HttpResponse res;
        if(isTestMode) {
            // テスト動作モード
            return mockImpl.respond(req);
        } else {
            // 通常動作モード
            Http http = new Http();
            return http.send(req);
        }
    }*/
}