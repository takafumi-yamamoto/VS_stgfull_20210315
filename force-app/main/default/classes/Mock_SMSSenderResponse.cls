/**
 * メッセージ送信処理の疑似レスポンスを定義する。
 *
 * 一般的にApexテストクラスで使用されるHttpCalloutMockインターフェースを使用しているが、
 * カスタムのテストモード指定時に動作させることを目的とするため、
 * isTestアノテーションの付与は行わない。
 *
 * TODO 命名規則から外れているため、確認
 *
 * @Auther Mizuno
 */
global class Mock_SMSSenderResponse implements HttpCalloutMock {

    /**
     * コンストラクタ
     * @Auther Mizuno
     */
    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();

        res.setBody('{"result":"Successful"}');

        res.setStatusCode(200);

        return res;

    }
}