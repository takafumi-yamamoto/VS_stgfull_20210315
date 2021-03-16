trigger MitsumoriTeiansyoCmdTrigger on MitsumoriTeiansyoCmd__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if(Utility_Common.isDataIkouProfile()){return;}
    if(!TriggerIsActive__c.getOrgDefaults().isActive__c){return;}

    if(Trigger.isAfter && Trigger.isUpdate){
        
        List<MitsumoriTeiansyo__c> theMitsumoriTeiansyos = new List<MitsumoriTeiansyo__c>(
            [
                select Id, MitsumoriTeiansyoCmdRef__c, Service__c, TekiyoWaribiki__c
                from MitsumoriTeiansyo__c 
                where MitsumoriTeiansyoCmdRef__c = :SobjectsExtension.collectIds(Trigger.New)
            ]
        );

        Map<Id, MitsumoriTeiansyo__c> theMapOfMitsumoriTeiansyosByCmdRef = new Map<Id, MitsumoriTeiansyo__c>();
        for(MitsumoriTeiansyo__c aMitsumoriTeiansyo : theMitsumoriTeiansyos){
            if(aMitsumoriTeiansyo.MitsumoriTeiansyoCmdRef__c == null) continue;
            theMapOfMitsumoriTeiansyosByCmdRef.put( aMitsumoriTeiansyo.MitsumoriTeiansyoCmdRef__c, aMitsumoriTeiansyo );
        }
        
        for(MitsumoriTeiansyo__c aMT : theMitsumoriTeiansyos){
            for(MitsumoriTeiansyoCmd__c aMTC :Trigger.New){
                if(aMT.MitsumoriTeiansyoCmdRef__c == aMTC.Id){
                    aMT.Service__c = aMTC.Service__c;
                    aMT.TekiyoWaribiki__c = aMTC.TekiyoWaribiki__c;
                }
            }
        }
        
        update theMitsumoriTeiansyos;
        
        List<TeianSho__c> theTeianshosToBeInserted = new List<TeianSho__c>();
        for(MitsumoriTeiansyoCmd__c aCmd : Trigger.New){
            MitsumoriTeiansyo__c theMitsumoriTeiansyo = theMapOfMitsumoriTeiansyosByCmdRef.get(aCmd.Id);
            if( theMitsumoriTeiansyo == null ) continue;
            for(String aPlan : aCmd.Plans__c.split(';')){
                TeianSho__c theTeianSho = new TeianSho__c
                    (
                    MitsumoriTeianshoRef__c = theMitsumoriTeiansyo.Id,
                    SubTitle__c = aCmd.SubTitle__c,
                    TsuikaRyokin1_Hinmei__c = aCmd.TsuikaRyokin1_Hinmei__c,
                    TsuikaRyokin1_Kingaku__c = aCmd.TsuikaRyokin1_Kingaku__c,
                    TsuikaRyokin2_Hinmei__c = aCmd.TsuikaRyokin2_Hinmei__c,
                    TsuikaRyokin2_Kingaku__c = aCmd.TsuikaRyokin2_Kingaku__c,
                    TsuikaRyokin3_Hinmei__c = aCmd.TsuikaRyokin3_Hinmei__c,
                    TsuikaRyokin3_Kingaku__c = aCmd.TsuikaRyokin3_Kingaku__c,
                    TsuikaRyokin4_Hinmei__c = aCmd.TsuikaRyokin4_Hinmei__c,
                    TsuikaRyokin4_Kingaku__c = aCmd.TsuikaRyokin4_Kingaku__c,
                    TsuikaRyokin5_Hinmei__c = aCmd.TsuikaRyokin5_Hinmei__c,
                    TsuikaRyokin5_Kingaku__c = aCmd.TsuikaRyokin5_Kingaku__c,
                    TsuikaRyokin6_Hinmei__c = aCmd.TsuikaRyokin6_Hinmei__c,
                    TsuikaRyokin6_Kingaku__c = aCmd.TsuikaRyokin6_Kingaku__c,
                    Plan__c = aPlan,
                    TokkiJiko__c = aCmd.TokkiJiko__c
                    );
                theTeianshosToBeInserted.add(theTeianSho);
            }
        }

        insert theTeianshosToBeInserted;
    }
}