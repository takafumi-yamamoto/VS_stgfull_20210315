@isTest
public class NcpSzkSdnShkCardKeyT {
    @isTest public static void RecordKyeAssigner_assignIfNotAssigned(){
        Test.startTest();
        new NcpSzkSdnShkCardKey.RecordKyeAssigner().assignIfNotAssigned(
            new List<NcpSzkSdnShkCard__c>{
                new NcpSzkSdnShkCard__c()
            }
        );
        Test.stopTest();
    }
}