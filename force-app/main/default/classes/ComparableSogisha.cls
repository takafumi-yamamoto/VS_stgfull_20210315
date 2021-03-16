public class ComparableSogisha implements Comparable {
    
    public SogishaWrapper sogishaWrapper;
    
	// ソートする項目名
	public String sortField;
	// ソートする項目名
	public Boolean isAsc;

	// コンストラクタ
	public ComparableSogisha(SogishaWrapper sogishaWrapper){
		this.sogishaWrapper = sogishaWrapper;
	}

	// コンストラクタ
	public ComparableSogisha(SogishaWrapper sogishaWrapper,String sortField,Boolean isAsc){
		this.sogishaWrapper = sogishaWrapper;
		this.sortField = sortField;
		this.isAsc = isAsc;
	}

	// ソート処理(list.sort()実行時に呼ばれる)
	public Integer compareTo(Object compareTo){
		// list.sort()時に参照される値
		Integer resCode = -1;
		// 比較用
		ComparableSogisha compareToAc = (ComparableSogisha)compareTo;

		// 請求先名でソート
		if(sortField == 'tokuyakutenTsuryo'){
			if(sogishaWrapper.tokuyakutenTsuryo == compareToAc.sogishaWrapper.tokuyakutenTsuryo) resCode = 0;
			else if(sogishaWrapper.tokuyakutenTsuryo > compareToAc.sogishaWrapper.tokuyakutenTsuryo || compareToAc.sogishaWrapper.tokuyakutenTsuryo ==null) resCode = 1;
		}
		else if(sortField == 'sokyakuTasseiritsu'){
			if(sogishaWrapper.sokyakuTasseiritsu == compareToAc.sogishaWrapper.sokyakuTasseiritsu) resCode = 0;
			else if(sogishaWrapper.sokyakuTasseiritsu > compareToAc.sogishaWrapper.sokyakuTasseiritsu || compareToAc.sogishaWrapper.sokyakuTasseiritsu ==null) resCode = 1;
		}
		else if(sortField == 'tokuyakutenToraiaruChu'){
			if(sogishaWrapper.tokuyakutenToraiaruChu == compareToAc.sogishaWrapper.tokuyakutenToraiaruChu) resCode = 0;
			else if(sogishaWrapper.tokuyakutenToraiaruChu > compareToAc.sogishaWrapper.tokuyakutenToraiaruChu || compareToAc.sogishaWrapper.tokuyakutenToraiaruChu ==null) resCode = 1;
		}
		else if(sortField == 'naibuSokyakuMokuhyosu'){

			if(sogishaWrapper.naibuSokyakuMokuhyosu == compareToAc.sogishaWrapper.naibuSokyakuMokuhyosu) resCode = 0;
			else if(sogishaWrapper.naibuSokyakuMokuhyosu > compareToAc.sogishaWrapper.naibuSokyakuMokuhyosu || compareToAc.sogishaWrapper.naibuSokyakuMokuhyosu ==null) resCode = 1;
		}
		else if(sortField == 'tokuyakutenKeiyakuAri'){
			if(sogishaWrapper.tokuyakutenKeiyakuAri == compareToAc.sogishaWrapper.tokuyakutenKeiyakuAri) resCode = 0;
			else if(sogishaWrapper.tokuyakutenKeiyakuAri > compareToAc.sogishaWrapper.tokuyakutenKeiyakuAri || compareToAc.sogishaWrapper.tokuyakutenKeiyakuAri ==null) resCode = 1;
		}
		else if(sortField == 'saijoAri'){
			if(sogishaWrapper.saijoAri == compareToAc.sogishaWrapper.saijoAri) resCode = 0;
			else if(sogishaWrapper.saijoAri > compareToAc.sogishaWrapper.saijoAri || compareToAc.sogishaWrapper.saijoAri ==null) resCode = 1;
		}
		else if(sortField == 'yuryoShozaiAri'){
			if(sogishaWrapper.yuryoShozaiAri == compareToAc.sogishaWrapper.yuryoShozaiAri) resCode = 0;
			else if(sogishaWrapper.yuryoShozaiAri > compareToAc.sogishaWrapper.yuryoShozaiAri || compareToAc.sogishaWrapper.yuryoShozaiAri ==null) resCode = 1;
		}
		else if(sortField == 'ptWebKa'){
			if(sogishaWrapper.ptWebKa == compareToAc.sogishaWrapper.ptWebKa) resCode = 0;
			else if(sogishaWrapper.ptWebKa > compareToAc.sogishaWrapper.ptWebKa || compareToAc.sogishaWrapper.ptWebKa ==null) resCode = 1;
		}
		else if(sortField == 'kametenTesuryoYusenJuni'){
			if(sogishaWrapper.kametenTesuryoYusenJuni == compareToAc.sogishaWrapper.kametenTesuryoYusenJuni) resCode = 0;
			else if(sogishaWrapper.kametenTesuryoYusenJuni < compareToAc.sogishaWrapper.kametenTesuryoYusenJuni || compareToAc.sogishaWrapper.kametenTesuryoYusenJuni ==null) resCode = 1;
			System.debug('resCode:' + resCode);
		}
		// 他にソートが必要な項目の条件を追加します
		
		// 降順の場合値を反転させる
		if(!isAsc){
			resCode = -1 * resCode; 
		}

		return resCode;
	}
}