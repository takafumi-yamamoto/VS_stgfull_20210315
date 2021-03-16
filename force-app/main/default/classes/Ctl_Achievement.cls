public class Ctl_Achievement{
    // 種別 , Syubetsu__c , picklist
    public static final String CONST_SYUBETSU_JIZENWARI = '事前割申込完了';
    public static final String CONST_SYUBETSU_SEIZEN = 'お葬式予約申込完了';
    public static final String CONST_SYUBETSU_OBOUSAN = '僧侶手配利用';
    //public static final String CONST_SYUBETSU_1 = 'シンプル安豪資料請求';
    //public static final String CONST_SYUBETSU_4 = '事前準備登録';

    public static final String CONST_KEIYAKUSTATUS_KEIYAKUTYUU = '契約中';

    /**
    * 事前割関するアチーブメントの新規・更新
    */
    public void upsertJizenwariAchievement(List<Jizenwari__c> newJizenwariList, Map<ID, Jizenwari__c> oldJizenwariMap){
		//List<Achievement__c> acheivementForUpdateList = new List<Achievement__c>();
        
  //      Map<Id,Jizenwari__c> jizenwariMap = new Map<Id,Jizenwari__c>();

  //      for(Jizenwari__c jizenwari : newJizenwariList){
  //          if(String.isBlank(jizenwari.OpportunityRef__c)) continue;
  //          if(oldJizenwariMap == null){
  //              if(jizenwari.Yuko_kigenStart__c != null)
  //                  jizenwariMap.put(jizenwari.OpportunityRef__c, jizenwari);
  //          }else{
  //          	Jizenwari__c jizenwariOld = oldJizenwariMap.get(jizenwari.id);
  //          	if(jizenwari.Yuko_kigenStart__c != jizenwariOld.Yuko_kigenStart__c) {
  //          		jizenwariMap.put(jizenwari.OpportunityRef__c, jizenwari);
  //          	}
  //          }
  //      }

  //      if(jizenwariMap.size() == 0) return;

  //      Map<Id, Achievement__c> acheivementMap = getAcheivementMap(jizenwariMap.keySet(), CONST_SYUBETSU_JIZENWARI);

		//for(Jizenwari__c jizenwari : jizenwariMap.values()){
		//	Achievement__c achievement = acheivementMap.containsKey(jizenwari.OpportunityRef__c) ? 
		//								acheivementMap.get(jizenwari.OpportunityRef__c) : 
		//								new Achievement__c(Syubetsu__c = CONST_SYUBETSU_JIZENWARI, 
		//												   TorihikiSakiRef__c = jizenwari.KeiyakuSha__c,
		//												   SourceShodanRef__c = jizenwari.OpportunityRef__c
		//												   );
		//	achievement.YukoFlag__c = jizenwari.Yuko_kigenStart__c != null;
		//	achievement.YukoKaishiBi__c = jizenwari.Yuko_kigenStart__c;
		//	acheivementForUpdateList.add(achievement);
		//	System.debug(achievement);
		//	System.debug(jizenwari);
		//}
		//upsert acheivementForUpdateList;
    }

    /**
    * 生前契約関するアチーブメントの新規・更新
    */
    public void upsertSeizenKeiyakuAchievement(List<SeizenKeiyaku__c> newSeizenKeiyakuList, Map<ID, SeizenKeiyaku__c> oldSeizenKeiyakuMap){

        //List<Achievement__c> acheivementForUpdateList = new List<Achievement__c>();
        
        //Map<Id,SeizenKeiyaku__c> seizenKeiyakuMap = new Map<Id,SeizenKeiyaku__c>();

        //for(SeizenKeiyaku__c seizenKeiyaku : newSeizenKeiyakuList){
        //    System.debug('>>>>seizenKeiyaku');
        //    System.debug(seizenKeiyaku);

        //    if(String.isBlank(seizenKeiyaku.OpportunityRef__c)) continue; 
        //    if(oldSeizenKeiyakuMap == null){
        //        if(seizenKeiyaku.KeiyakuTeiketuStartDate__c != null)
        //            seizenKeiyakuMap.put(seizenKeiyaku.OpportunityRef__c, seizenKeiyaku);
        //    }else{
        //        SeizenKeiyaku__c seizenKeiyakuOld = oldSeizenKeiyakuMap.get(seizenKeiyaku.id);
        //        if(seizenKeiyaku.KeiyakuTeiketuStartDate__c != seizenKeiyakuOld.KeiyakuTeiketuStartDate__c
        //            && seizenKeiyaku.KeiyakuStatus__c == CONST_KEIYAKUSTATUS_KEIYAKUTYUU
        //            ) {
        //            seizenKeiyakuMap.put(seizenKeiyaku.OpportunityRef__c, seizenKeiyaku);
        //        }
        //    }
        //}

        //if(seizenKeiyakuMap.size() == 0) return;

        //Map<Id, Achievement__c> acheivementMap = getAcheivementMap(seizenKeiyakuMap.keySet(), CONST_SYUBETSU_SEIZEN);

        //for(SeizenKeiyaku__c seizenKeiyaku : seizenKeiyakuMap.values()){
        //    Achievement__c achievement = acheivementMap.containsKey(seizenKeiyaku.OpportunityRef__c) ? 
        //                                acheivementMap.get(seizenKeiyaku.OpportunityRef__c) : 
        //                                new Achievement__c(Syubetsu__c = CONST_SYUBETSU_SEIZEN, 
        //                                                   TorihikiSakiRef__c = seizenKeiyaku.KeiyakuSya__c,
        //                                                   SourceShodanRef__c = seizenKeiyaku.OpportunityRef__c
        //                                                   );

        //    achievement.YukoFlag__c = seizenKeiyaku.KeiyakuTeiketuStartDate__c != null;
        //    achievement.YukoKaishiBi__c = seizenKeiyaku.KeiyakuTeiketuStartDate__c;
        //    acheivementForUpdateList.add(achievement);
        //    System.debug(achievement);
        //    System.debug(seizenKeiyaku);
        //}
        //upsert acheivementForUpdateList;
    }


    /**
    * お坊さん便関するアチーブメントの新規・更新
    */
    public void upsertObousanbinAchievement(List<SeizenKeiyaku__c> newSeizenKeiyakuList, Map<ID, SeizenKeiyaku__c> oldSeizenKeiyakuMap){

    }

    private Map<Id, Achievement__c> getAcheivementMap(Set<Id> oppIds, String syubetsu){
        List<Achievement__c> achievements = Dao_Achievement.GetInstance().SelectByOppIdsAndSyubetsu(oppIds, syubetsu);
        
        Map<Id, Achievement__c> acheivementMap = new Map<Id, Achievement__c>();
        for(Achievement__c achievement : achievements){
            acheivementMap.put(achievement.SourceShodanRef__c, achievement);
        }

        return acheivementMap;
    }

}