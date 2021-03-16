public class ShisetsuAutoNumberings {

    public void assingAutoNumberOnShisetsuBeforeInsert(List<Shisetsu__c> newOnes){

        List<ShisetsuSeq__c> theShisetsuSeqsToBeInserted = new List<ShisetsuSeq__c>();
        for(Shisetsu__c aShisetsu : newOnes){
            theShisetsuSeqsToBeInserted.add( new ShisetsuSeq__c() );
        }
        Insert theShisetsuSeqsToBeInserted;

        List<ShisetsuSeq__c> theShisetsuSeqs = new List<ShisetsuSeq__c>(
            [
                select 
                Id, Name
                from ShisetsuSeq__c
                where Id = :SobjectsExtension.collectIds(theShisetsuSeqsToBeInserted)
                order by Name
            ]
        );
        Integer theIndex = -1;
        for(Shisetsu__c aShisetsu : newOnes){
            theIndex ++;
            Long theSeqNo = Long.valueOf( theShisetsuSeqs.get(theIndex).Name );
            aShisetsu.SeqNo__c = theSeqNo;
            aShisetsu.KasobaKeisaiJohoId__c = String.valueOf(1000000000 + theSeqNo);
            aShisetsu.SaijoKeisaiJohoId__c = String.valueOf(2000000000 + theSeqNo);
        }
        Delete theShisetsuSeqs;
    }
}