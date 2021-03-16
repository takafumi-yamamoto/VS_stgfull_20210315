public class SogishaWrapper {

	public String keiyakuId {get;set;}
	public String accountName {get;set;}
	public Decimal tokuyakutenTsuryo {get;set;}
	public Decimal kametenTesuryoYusenJuni {get;set;}
	public Decimal sokyakuTasseiritsu {get;set;}
	public Decimal tokuyakutenToraiaruChu {get;set;}
	public Decimal naibuSokyakuMokuhyosu {get;set;}
	public Decimal tokuyakutenKeiyakuAri {get;set;}
	public Decimal saijoAri {get;set;}
	public Decimal yuryoShozaiAri {get;set;}
	public Decimal ptWebKa {get;set;}
	
	public SogishaWrapper(String keiyakuId,
							String accountName,
							Decimal tokuyakutenTsuryo,
							Decimal kametenTesuryoYusenJuni,
							Decimal sokyakuTasseiritsu,
					    	Decimal tokuyakutenToraiaruChu,
					    	Decimal naibuSokyakuMokuhyosu,
					    	Decimal tokuyakutenKeiyakuAri,
					    	Decimal saijoAri,
					    	Decimal yuryoShozaiAri,
					    	Decimal ptWebKa){
		this.keiyakuId = keiyakuId;
		this.accountName = accountName;
		this.tokuyakutenTsuryo = tokuyakutenTsuryo;
		this.kametenTesuryoYusenJuni = kametenTesuryoYusenJuni;
		this.sokyakuTasseiritsu = sokyakuTasseiritsu;
    	this.tokuyakutenToraiaruChu = tokuyakutenToraiaruChu;
    	this.naibuSokyakuMokuhyosu = naibuSokyakuMokuhyosu;
    	this.tokuyakutenKeiyakuAri = tokuyakutenKeiyakuAri;
    	this.saijoAri = saijoAri;
    	this.yuryoShozaiAri = yuryoShozaiAri;
    	this.ptWebKa = ptWebKa;
	}
}