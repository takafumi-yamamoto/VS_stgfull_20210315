public class OboAddrCopy {

	public void onObosanbinBeforeInsert(List<Obosanbin__c> pNewOnes){

		System.Debug('OboAddrCopy invoked');
		for(Obosanbin__c aNewOne : pNewOnes){

			if( this.hoyoStructAddrHasValue(aNewOne) ){
				aNewOne.HoyoBashoAddress__c = this.getHoyoStrAddrByStructAddr(aNewOne);
			}else if ( !String.isBlank(aNewOne.HoyoBashoAddress__c) ){
				aNewOne.hoyo_banchi__c = aNewOne.HoyoBashoAddress__c;
			}

			if( this.tsuikaHoyoStructAddrHasValue(aNewOne) ){
				aNewOne.TsuikahoyobashoAddress__c = this.getTsuikaHoyoStrAddrByStructAddr(aNewOne);
			}else if( !String.isBlank(aNewOne.TsuikahoyobashoAddress__c) ){
				aNewOne.tuika_banchi__c = aNewOne.TsuikahoyobashoAddress__c;
			}

			if( this.sogiStructAddrHasValue(aNewOne) ){
				aNewOne.SaijoAddress__c = this.getSogiStrAddrByStructAddr(aNewOne);
			}else if(!String.isBlank(aNewOne.SaijoAddress__c) ){
				aNewOne.sogi_banchi__c = aNewOne.SaijoAddress__c;
			}
		}
	}

	public void onObosanbinBeforeUpdate(List<Obosanbin__c> pNewOnes, Map<Id, Obosanbin__c> pOldOnes){

		for(Obosanbin__c aNewOne : pNewOnes){
			Obosanbin__c aOldOne = pOldOnes.get(aNewOne.Id);

			Boolean theIsHoyoStructAddrChange = this.isHoyoStructAddrChange(aNewOne, aOldOne);
			if( theIsHoyoStructAddrChange ){
				aNewOne.HoyoBashoAddress__c = getHoyoStrAddrByStructAddr(aNewOne);
			}else if(aNewOne.HoyoBashoAddress__c != aOldOne.HoyoBashoAddress__c ){
				aNewOne.hoyo_postcode__c = '';
				aNewOne.hoyo_todofuken__c = '';
				aNewOne.hoyo_shikugun__c = '';
				aNewOne.hoyo_tyoumei__c = '';
				aNewOne.hoyo_banchi__c = aNewOne.HoyoBashoAddress__c;
			}

			Boolean theIsTsuikaHoyoStructAddrChange = this.isTsuikaHoyoStructAddrChange(aNewOne, aOldOne);
			if( theIsTsuikaHoyoStructAddrChange ){
				aNewOne.TsuikahoyobashoAddress__c = getTsuikaHoyoStrAddrByStructAddr(aNewOne);
			}else if(aNewOne.TsuikahoyobashoAddress__c != aOldOne.TsuikahoyobashoAddress__c ){
				aNewOne.tuika_postcode__c = '';
				aNewOne.tuika_todofuken__c = '';
				aNewOne.tuika_shikugun__c = '';
				aNewOne.tuika_tyoumei__c = '';
				aNewOne.tuika_banchi__c = aNewOne.TsuikahoyobashoAddress__c;
			}

			Boolean theIsSogiStructAddrChange = this.isSogiStructAddrChange(aNewOne, aOldOne);
			if( theIsSogiStructAddrChange ){
				aNewOne.SaijoAddress__c = getSogiStrAddrByStructAddr(aNewOne);
			}else if(aNewOne.SaijoAddress__c != aOldOne.SaijoAddress__c){
				aNewOne.sogi_postcode__c = '';
				aNewOne.sogi_todofuken__c = '';
				aNewOne.sogi_shikugun__c = '';
				aNewOne.sogi_tyoumei__c = '';
				aNewOne.sogi_banchi__c = aNewOne.SaijoAddress__c;
			}		
		}
	}

	private Boolean hoyoStructAddrHasValue(Obosanbin__c pObosanbin){
		if( !String.isBlank(pObosanbin.hoyo_postcode__c) ) return true;
		if( !String.isBlank(pObosanbin.hoyo_todofuken__c) ) return true;
		if( !String.isBlank(pObosanbin.hoyo_shikugun__c) ) return true;
		if( !String.isBlank(pObosanbin.hoyo_tyoumei__c) ) return true;
		if( !String.isBlank(pObosanbin.hoyo_banchi__c) ) return true;
		return false;
	}

	private String getHoyoStrAddrByStructAddr(Obosanbin__c pObosanbin){
        String theValue = String.Format('{0} {1}{2}{3}{4}', 
			new String[]{
                String.isBlank(pObosanbin.hoyo_postcode__c) ? '' : pObosanbin.hoyo_postcode__c,
                String.isBlank(pObosanbin.hoyo_todofuken__c) ? '' : pObosanbin.hoyo_todofuken__c,
                String.isBlank(pObosanbin.hoyo_shikugun__c) ? '' : pObosanbin.hoyo_shikugun__c,
                String.isBlank(pObosanbin.hoyo_tyoumei__c) ? '' : pObosanbin.hoyo_tyoumei__c,
				String.isBlank(pObosanbin.hoyo_banchi__c) ? '' : pObosanbin.hoyo_banchi__c
      		}
        );
        return theValue;
	}

	private Boolean isHoyoStructAddrChange(Obosanbin__c pNewOne, Obosanbin__c pOldOld){
		if(pNewOne.hoyo_postcode__c != pOldOld.hoyo_postcode__c) return true;
		if(pNewOne.hoyo_todofuken__c != pOldOld.hoyo_todofuken__c)  return true;
		if(pNewOne.hoyo_shikugun__c != pOldOld.hoyo_shikugun__c)  return true;
		if(pNewOne.hoyo_tyoumei__c != pOldOld.hoyo_tyoumei__c)  return true;
		if(pNewOne.hoyo_banchi__c != pOldOld.hoyo_banchi__c)  return true;
		return false;
	}

	// 追加法要場所
	private Boolean tsuikaHoyoStructAddrHasValue(Obosanbin__c pObosanbin){
		if( !String.isBlank(pObosanbin.tuika_postcode__c) ) return true;
		if( !String.isBlank(pObosanbin.tuika_todofuken__c) ) return true;
		if( !String.isBlank(pObosanbin.tuika_shikugun__c) ) return true;
		if( !String.isBlank(pObosanbin.tuika_tyoumei__c) ) return true;
		if( !String.isBlank(pObosanbin.tuika_banchi__c) ) return true;
		return false;
	}

	private String getTsuikaHoyoStrAddrByStructAddr(Obosanbin__c pObosanbin){
        String theValue = String.Format('{0} {1}{2}{3}{4}', 
			new String[]{
                String.isBlank(pObosanbin.tuika_postcode__c) ? '' : pObosanbin.tuika_postcode__c,
                String.isBlank(pObosanbin.tuika_todofuken__c) ? '' : pObosanbin.tuika_todofuken__c,
                String.isBlank(pObosanbin.tuika_shikugun__c) ? '' : pObosanbin.tuika_shikugun__c,
                String.isBlank(pObosanbin.tuika_tyoumei__c) ? '' : pObosanbin.tuika_tyoumei__c,
				String.isBlank(pObosanbin.tuika_banchi__c) ? '' : pObosanbin.tuika_banchi__c
      		}
        );
        return theValue;
	}

	private Boolean isTsuikaHoyoStructAddrChange(Obosanbin__c pNewOne, Obosanbin__c pOldOld){
		if(pNewOne.tuika_postcode__c != pOldOld.tuika_postcode__c) return true;
		if(pNewOne.tuika_todofuken__c != pOldOld.tuika_todofuken__c)  return true;
		if(pNewOne.tuika_shikugun__c != pOldOld.tuika_shikugun__c)  return true;
		if(pNewOne.tuika_tyoumei__c != pOldOld.tuika_tyoumei__c)  return true;
		if(pNewOne.tuika_banchi__c != pOldOld.tuika_banchi__c)  return true;
		return false;
	}

	// 斎場住所
	private Boolean sogiStructAddrHasValue(Obosanbin__c pObosanbin){
		if( !String.isBlank(pObosanbin.sogi_postcode__c) ) return true;
		if( !String.isBlank(pObosanbin.sogi_todofuken__c) ) return true;
		if( !String.isBlank(pObosanbin.sogi_shikugun__c) ) return true;
		if( !String.isBlank(pObosanbin.sogi_tyoumei__c) ) return true;
		if( !String.isBlank(pObosanbin.sogi_banchi__c) ) return true;
		return false;
	}

	private String getSogiStrAddrByStructAddr(Obosanbin__c pObosanbin){
        String theValue = String.Format('{0} {1}{2}{3}{4}', 
			new String[]{
                String.isBlank(pObosanbin.sogi_postcode__c) ? '' : pObosanbin.sogi_postcode__c,
                String.isBlank(pObosanbin.sogi_todofuken__c) ? '' : pObosanbin.sogi_todofuken__c,
                String.isBlank(pObosanbin.sogi_shikugun__c) ? '' : pObosanbin.sogi_shikugun__c,
                String.isBlank(pObosanbin.sogi_tyoumei__c) ? '' : pObosanbin.sogi_tyoumei__c,
				String.isBlank(pObosanbin.sogi_banchi__c) ? '' : pObosanbin.sogi_banchi__c
      		}
        );
        return theValue;
	}
	
	private Boolean isSogiStructAddrChange(Obosanbin__c pNewOne, Obosanbin__c pOldOld){
		if(pNewOne.sogi_postcode__c != pOldOld.sogi_postcode__c) return true;
		if(pNewOne.sogi_todofuken__c != pOldOld.sogi_todofuken__c)  return true;
		if(pNewOne.sogi_shikugun__c != pOldOld.sogi_shikugun__c)  return true;
		if(pNewOne.sogi_tyoumei__c != pOldOld.sogi_tyoumei__c)  return true;
		if(pNewOne.sogi_banchi__c != pOldOld.sogi_banchi__c)  return true;
		return false;
	}
}