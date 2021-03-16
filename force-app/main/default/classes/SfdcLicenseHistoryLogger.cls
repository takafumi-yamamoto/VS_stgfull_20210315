global class SfdcLicenseHistoryLogger implements Schedulable {

    // スケジューラー起動
    global void execute(SchedulableContext sc) {

        // 計測開始日時
        Datetime mTime = Datetime.now();

        // 必ず1レコードのみ取得される
        UserLicense ulObj = [
                                SELECT
                                  TotalLicenses
                                  , UsedLicenses
                                FROM
                                  UserLicense
                                WHERE
                                  LicenseDefinitionKey = 'SFDC'
                            ];

        insert new SfdcLicenseHistory__c(
            TotalLicenses__c = ulObj.TotalLicenses,
            UsedLicenses__c = ulObj.UsedLicenses,
            MeasuredDateTime__c = mTime
        );

    }
}