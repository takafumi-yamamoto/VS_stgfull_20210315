global class MultiLoginHistoryLoggerBatch implements Database.Batchable<sObject>, Schedulable {

    // 検知対象から除外する管理者
    private Static String whiteListUsers = ''
                                           + '\'system-admin@minrevi.jp\' '
                                           + ', \'jun-ishii@yoriso.com\' '
                                           + ', \'takeharu-umezaki@yoriso.com\' '
                                           + ', \'takafumi-yamamoto@yoriso.com\' '
                                           + ', \'satoki-sano@yoriso.com\' '
                                           + ', \'huang-exia@yoriso.com\' '
                                           + ', \'hikaru-ebina@yoriso.com\' '
                                           + ', \'ayami-hayata@yoriso.com\' '
                                           + ', \'takaya-hiyama@yoriso.com\' '
                                           + ', \'tasuku-suzuki@yoriso.com\' '
                                           + ', \'teppei-seki@yoriso.com\' ';

    // スケジューラー起動
    global void execute(SchedulableContext sc) {
        Integer theBatchSize = 100;
        Database.executeBatch(new MultiLoginHistoryLoggerBatch(), theBatchSize);
    }

    // バッチ実行前処理
    global List<sObject> start(Database.BatchableContext BC) {

        String query = 'SELECT '
                       + '  COUNT(Id) cnt '
                       + '  ,u.Username '
                       + 'FROM '
                       + '  AuthSession a '
                       + '  ,AuthSession.Users u '
                       + 'WHERE '
                       + '  a.SessionType = \'UI\' '
                       + '  AND u.Username NOT IN ( '
                       + whiteListUsers
                       + '  ) '
                       + 'GROUP BY '
                       + '  a.UsersId '
                       + '  ,u.Username '
                       + 'HAVING COUNT(Id) >= 2 '
                       + 'ORDER BY COUNT(Id) DESC';

        System.Debug('SOQL＞＞' + query);

        return Database.query(query);

    }

    // バッチメイン処理
    global void execute(Database.BatchableContext BC, List<AggregateResult> groupedResults) {
        Datetime mTime = Datetime.now();
        List<MultiLoginHistory__c> regObjList = new List<MultiLoginHistory__c>();

        for (AggregateResult ar : groupedResults) {
            regObjList.add(
                new MultiLoginHistory__c(
                    Username__c = (String)ar.get('Username')
                    , LoginSessionCount__c = (Integer)ar.get('cnt')
                    , MeasuredDateTime__c = mTime
                )
            );
        }

        insert regObjList;
    }

    // バッチ終了前処理
    global void finish(Database.BatchableContext BC) {
    }

}