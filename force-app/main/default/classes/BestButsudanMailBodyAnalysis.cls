//メール本文分析クラス（ベスト仏壇）
public class BestButsudanMailBodyAnalysis {
	public string mailTitle { get; set; }
    public string mailBody { get; set; }
    
    //取引先名
    public string torihikisakiName { get; set; }
    public string torihikisakiFirstName { get; set; }
    public string torihikisakiLastName { get; set; }
    //取引先カタカナ
    public string torihikisakiKatakana { get; set; }
    public string torihikisakiFirstKatakana { get; set; }
    public string torihikisakiLastKatakana { get; set; }
    
    //------------注文情報------------
    //ご注文番号
    public string chumonNumber { get; set; }
    //ご注文ステータス 
    public string chumonStatus { get; set; }
    //ご注文日時
    public string chumonDatetime { get; set; }
    
    //----------お買い上げ商品----------
    //商品名
    public list<string> shohinmeiLst { get; set; }
    //商品型番
    public list<string> shohinKatabanLst { get; set; }
    //商品詳細
    public list<string> shohinShosaiLst { get; set; }
    //数量
    public list<integer> quantityLst { get; set; }
    //販売価格
    public list<integer> unitPriceLst { get; set; }
    //商品URL
    public list<string> shohinUrlLst { get; set; }    
    //小計
    public integer subtotal { get; set; }
    //総額
    public integer total { get; set; }
    
    //----------お届け先----------
    //お客様名
    public String todokesakiName { get; set; }
    //郵便番号
    public String todokesakiZipCode { get; set; }
    //住所 
    public String todokesakiAddress { get; set; }    
    //電話番号 
    public String todokesakiTelNo { get; set; }
      
    
    //----------支払方法・ご住所----------
    //支払方法
    public string shiharaihoho { get; set; }
    //お客様名 
    public string shiharaiCustomerName { get; set; }
    //郵便番号
    public string shiharaiZipCode { get; set; }
    //住所
    public string shiharaiAddress { get; set; }   
    //電話番号
    public string shiharaiTelNo { get; set; }
    
    //----------コメント----------
    //商談番号
    public string oppNumber; 
    
    public BestButsudanMailBodyAnalysis(case inCase) {  
    	shohinmeiLst=new list<string>();
    	shohinKatabanLst=new list<string>();
    	shohinShosaiLst=new list<string>();
    	quantityLst=new list<integer>();
    	unitPriceLst=new list<integer>();
    	shohinUrlLst=new list<string>();
    	
        MailTitle = inCase.Subject;
        MailBody = inCase.Description;
        
        convertRnToN();
        setStrOfNameKanji();
        setStrOfNameKana();
        setStrOfOrderInfo();
        setProductInfo();      
        setSendInfo();
        setShiharaiInfo();
        setCommentInfo();
    }
    public void convertRnToN(){
    	string temp=MailBody.replace('\r\n','\n');
    	MailBody = temp;
    }
    
    //ベスト仏壇の名（漢字）をメール本文から取得
    public void setStrOfNameKanji(){
    	integer startPostion=0;
    	integer endPostion=0;
    	string rtnStr='';
    	endPostion=MailBody.indexof('様');
    	torihikisakiName=MailBody.mid(startPostion,endPostion-startPostion).trim();
    	list<string> torihikisakiNameLst=torihikisakiName.split(' ');
    	if (torihikisakiNameLst.size()<2){
    		torihikisakiLastName=torihikisakiName.trim();
    	}
    	if (torihikisakiNameLst.size()==2){
    		torihikisakiLastName=torihikisakiNameLst[0].trim();
    		torihikisakiFirstName=torihikisakiNameLst[1].trim();
    	}
    	
    	
	}
	//ベスト仏壇の名(カナ)をメール本文から取得
    public void setStrOfNameKana(){
    	integer startPostion=0;
    	integer endPostion=0;
    	string rtnStr='';
    	startPostion=MailBody.indexof('様')+1;
    	endPostion=MailBody.indexof('様',startPostion);
    	torihikisakiKatakana=MailBody.mid(startPostion,endPostion-startPostion).trim();
    	list<string> torihikisakiKatakanaLst=torihikisakiKatakana.split(' ');
    	if (torihikisakiKatakanaLst.size()<2){
    		torihikisakiLastKatakana=torihikisakiKatakana.trim();
    	}
    	if (torihikisakiKatakanaLst.size()==2){
    		torihikisakiLastKatakana=torihikisakiKatakanaLst[0].trim();
    		torihikisakiFirstKatakana=torihikisakiKatakanaLst[1].trim();
    	}    	
	}
	public void setStrOfOrderInfo(){
		chumonNumber=getSubStringFromStartToEnd(MailBody,'ご注文番号 ： ','\n',1).trim();
		chumonStatus=getSubStringFromStartToEnd(MailBody,'ご注文ステータス ：','\n',1).trim();
		chumonDatetime=getSubStringFromStartToEnd(MailBody,'ご注文日時 ：','\n',1).trim();
	}
    private void setProductInfo(){
    	boolean singleProductFlag=false;
        string ProductInfoSection=getSubStringFromStartToEnd(MailBody,'お買い上げ商品\n----------------------------------------\n','----------------------------------------',1);     
        //system.debug('ProductInfoSection='+ProductInfoSection);   
        integer productBlockNumbers=getSubstrNumbers(ProductInfoSection,'http');
        if (productBlockNumbers<=1){
        	singleProductFlag=true;
        }
        //system.debug('singleProductFlag='+singleProductFlag);
        for (integer index=1;index<=productBlockNumbers;index++){
        	string productInfo=getProductBlock(ProductInfoSection,index);
        	//商品名
        	string shohinmei='';
        	//商品型番
        	string shohinKataban='';
        	//商品詳細
        	string shohinShosai='';
        	//数量
        	integer quantity;
        	//販売価格
        	integer unitPrice;
        	//商品URL
        	string shohinUrl='';        	
        	//商品の場合
    		//複数商品の場合
    		shohinmei=getStrOfShohinmei2(productInfo).trim();
    		shohinKataban=getStrOfShohinKataban2(productInfo).trim();
    		shohinShosai=getStrOfshohinShosai2(productInfo).trim();
    		quantity=getStrOfquantity2(productInfo);
    		unitPrice=getStrOfunitPrice2(productInfo);
    		shohinUrl=getStrOfshohinURL2(productInfo).trim(); 
    		
        	shohinmeiLst.add(shohinmei);
        	shohinKatabanLst.add(shohinKataban);
        	shohinShosaiLst.add(shohinShosai);
        	quantityLst.add(quantity);
        	unitPriceLst.add(unitPrice);
        	shohinUrlLst.add(shohinUrl);
        }
        string StrSubtotal=getSubStringFromStartToEnd(MailBody,'小計 :','円',1).trim();
        Subtotal=convertStrToInt(StrSubtotal);
        string Strtotal=getSubStringFromStartToEnd(MailBody,'総額 : ','円',1).trim();
        total=convertStrToInt(Strtotal);
    }
	public void setSendInfo(){
		todokesakiName=getSubStringFromStartToEnd(MailBody,'お客様名 : ','\n',1).trim();
		todokesakiZipCode=getSubStringFromStartToEnd(MailBody,'郵便番号 :','\n',1).trim();
		todokesakiAddress=getSubStringFromStartToEnd(MailBody,'住所 :','\n',1).trim();
		todokesakiTelNo=getSubStringFromStartToEnd(MailBody,'電話番号 :','\n',1).trim();
	}    
	public void setShiharaiInfo(){
		shiharaihoho=getSubStringFromStartToEnd(MailBody,'支払方法 :','\n',1).trim();
		shiharaiCustomerName=getSubStringFromStartToEnd(MailBody,'お客様名 :','\n',2).trim();
		shiharaiZipCode=getSubStringFromStartToEnd(MailBody,'郵便番号 :','\n',2).trim();
		shiharaiAddress=getSubStringFromStartToEnd(MailBody,'住所 :','\n',2).trim();
		shiharaiTelNo=getSubStringFromStartToEnd(MailBody,'電話番号 :','\n',2).trim();
	}
	public void setCommentInfo(){
		oppNumber=getSubStringFromStartToEnd(MailBody,'コメント\n----------------------------------------\n','\n',1).trim();
	} 	      
	/**
	 * 指定の文字列から子文字列を取得
	 * @param Str　指定の文字列
	 * @param StartStr　開始の文字列、この文字列以後から終了文字列前までのは取得対象になります。
	 * @param EndStr　　　終了の文字列、開始の文字列以後から終了文字列前までのは取得対象になります。
	 * @param times　　　回数
	 * @return 取得した文字列
	 */	        
	public string getSubStringFromStartToEnd(String Str,String StartStr,String EndStr,integer times){
		integer startPostion=0;
		integer endPostion=0;			
		integer Position=0;
		string rtnStr='';
		for (integer i=0;i<times;i++){
			Position=str.indexof(StartStr,Position);
			//system.debug('str='+str);
			//system.debug('StartStr='+StartStr);
			//system.debug('position='+Position);
			Position=Position+StartStr.length();				
		}
		startPostion=Position;
		endPostion=Str.indexof(EndStr,startPostion);
		//system.debug('startPostion='+startPostion);
		//system.debug('endPostion='+endPostion);
		rtnStr=Str.mid(startPostion,endPostion-startPostion);
		return rtnStr;
	} 
	public integer getSubstrNumbers(String Str,string subStr){
		integer times=0;
		integer position=0;
		while (position >=0){
			position=Str.indexof(subStr,position+subStr.length());
			
			times++;
		}
		return times-1;
	}   
	public string getSubstrByRowNumber(string str,integer RowNum){
		string rtnStr;
		List<String> rowstrs = str.split('\n');
		rtnStr= rowstrs[RowNum-1];
		return rtnStr;
	}
	public integer getRowNumbers(string str){
		integer rownumber=0;
		rownumber=str.split('\n').size();
		return rownumber;
	}
	public string getProductBlock(string AllproductInfo,integer index){		
		integer startPosition=0;
		integer endPosition=AllproductInfo.length();
		integer rows=0;
		rows=getRowNumbers(AllproductInfo);
		//system.debug('rows=' + rows);
		string str='';
		
		for (integer i=1;i<=rows;i++){
			
			string rowtext=getSubstrByRowNumber(AllproductInfo,i);
			if (String.isBlank(rowtext)){
				rowtext='#######';
			}else{
				rowtext=rowtext+'\n';
			}			
			str=str+rowtext;		
		}
		//system.debug('str='+str);
		list<string> productInfoLst= str.split('#######');
		//system.debug('productInfoLst='+productInfoLst);
		return productInfoLst[index-1];
	}
	public string getStrOfShohinKataban2(string str){
		string firstLineText=getSubstrByRowNumber(str,1);
		//system.debug('firstLineText'+firstLineText);
		integer startPosition=firstLineText.lastIndexOf('(');
		integer endPosition=firstLineText.lastIndexOf(')');
		return firstLineText.mid(startPosition+1,endPosition-startPosition-1);
		
	}	
	public string getStrOfShohinmei2(string str){
		string firstLineText=getSubstrByRowNumber(str,1);
		integer productNameLenth=firstLineText.length()-getStrOfShohinKataban2(str).length()-5;
		string productName=str.mid(3,productNameLenth);
		return productName;
	}
	public string getStrOfShohinShosai2(string str){
		integer rownumbers=0;
		string rowStr='';
		rowNumbers=getRowNumbers(str);
		//system.debug('rowNumbers='+rowNumbers);
		for (integer index=2;index<=rowNumbers-2;index++){
			
			rowStr=rowStr+getSubstrByRowNumber(str,index);
			//system.debug('rowStr1='+rowStr);
		}
		return rowStr;		
	} 
	public string getStrOfshohinURL2(string str){		
		integer rowNumbers=getRowNumbers(str);
		integer lastRowNumber=rowNumbers;
		return getSubstrByRowNumber(str,lastRowNumber);		
	}
    public integer getStrOfQuantity2(string str){		
		integer rowNumbers=getRowNumbers(str);
		integer quantityLineNumber=rowNumbers-1;
		string  quantityAndPriceText=getSubstrByRowNumber(str,quantityLineNumber);	
		integer endPosition=quantityAndPriceText.indexof('×');
		string quantityStr=quantityAndPriceText.mid(0,endPosition);
		return convertStrToInt(quantityStr);
	}
    public integer getStrOfUnitPrice2(string str){		
		integer rowNumbers=getRowNumbers(str);
		integer quantityLineNumber=rowNumbers-1;
		string  quantityAndPriceText=getSubstrByRowNumber(str,quantityLineNumber);	
		string priceStr= getSubStringFromStartToEnd(quantityAndPriceText,'×','円',1);
		priceStr=priceStr.replace(',','');
		return convertStrToInt(priceStr);
	}
	
/*	public string getStrOfShohinKataban1(string str){
		string firstLineText=getSubstrByRowNumber(str,1)+'\n';
		//system.debug('firstLineText=' + firstLineText);
		string shohinKataban=getSubStringFromStartToEnd(firstLineText,'商品型番: ','\n',1);
		return shohinKataban;		
	}
	public string getStrOfShohinmei1(string str){
		string secondLineText=getSubstrByRowNumber(str,2)+'\n';
		//system.debug('secondLineText=' + secondLineText);
		string shohinmei=getSubStringFromStartToEnd(secondLineText,'商品名: ','\n',1);
		return shohinmei;	
	}	
	public string getStrOfShohinShosai1(string str){
		integer rownumbers=0;
		string rowStr='';
		rowNumbers=getRowNumbers(str);
		//system.debug('rowNumbers='+rowNumbers);
		for (integer index=3;index<=rowNumbers-2;index++){
			
			rowStr=rowStr+getSubstrByRowNumber(str,index);
			//system.debug('rowStr1='+rowStr);
		}
		return rowStr;		
	} 
	public string getStrOfshohinURL1(string str){		
		integer rowNumbers=getRowNumbers(str);
		integer lastRowNumber=rowNumbers;
		return getSubstrByRowNumber(str,lastRowNumber);		
	}
    public integer getStrOfQuantity1(string str){		
		integer rowNumbers=getRowNumbers(str);
		integer quantityLineNumber=rowNumbers-1;
		string  quantityAndPriceText=getSubstrByRowNumber(str,quantityLineNumber);	
		system.debug('***quantityAndPriceText='+quantityAndPriceText);

		string quantityStr=getSubStringFromStartToEnd(quantityAndPriceText,'× ','=',1);
		system.debug('***quantityStr='+quantityStr);
		return convertStrToInt(quantityStr);
	}
    public integer getStrOfUnitPrice1(string str){		
		integer rowNumbers=getRowNumbers(str);
		integer quantityLineNumber=rowNumbers-1;
		string  quantityAndPriceText=getSubstrByRowNumber(str,quantityLineNumber);	

		string priceStr=getSubStringFromStartToEnd(quantityAndPriceText,'商品価格: ','円',1);
        priceStr=priceStr.replace(',','');
		if (string.isblank(priceStr)){
			return 0;
		}else{
			return integer.valueof(priceStr.trim());
		}		
	}*/
	public integer convertStrToInt(string str){		
		string tempStr=str.replace(',','').deleteWhitespace();
		if (string.isblank(tempStr)){
			return 0;
		}else{
			return integer.valueof(tempStr.trim());
		}		
	}
}