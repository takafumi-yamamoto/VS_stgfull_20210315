@isTest
private class JustTest {
    static testMethod void testMethod1() {
		List<RecordType> recordTypes = [SELECT 
    Id,
    Name,
    DeveloperName,
    NamespacePrefix,
    Description,
    BusinessProcessId,
    SobjectType,
    IsActive,
    IsPersonType,
    CreatedById,
    CreatedDate,
    LastModifiedById,
    LastModifiedDate,
    SystemModstamp
 FROM RecordType];
        System.debug(recordTypes);

        RecordTypeCachedDaos.RecordTypeCachedDao dao = (RecordTypeCachedDaos.RecordTypeCachedDao)RecordTypeCachedDaos.getInstance();
        System.debug('>>>dao');

        String accountDefaultRecordType = dao.SelectIdByObjectTypeNameAndDevName('Account','null');
        System.debug('---accountDefaultRecordType---' + accountDefaultRecordType);
    }
}