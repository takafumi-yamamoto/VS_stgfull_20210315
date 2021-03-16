public class ShinkiToiawaseSogiyoRyokinhyoShikiData {

	public Boolean sltFlg = true;
	public String optName = '';
	public String standardSlt;
	public String freeWord;
	public String kingaku = '';
    public Decimal kingakuZeikomi;
	public Decimal suryo = 0;
    public Decimal kaso = 0;
    public Decimal ichinichi = 0;
    public Decimal kazoku = 0;
    public Decimal ippan = 0;
    public Decimal ichinichiJutoMae = 0;
    public Decimal kazokuJutoMae = 0;
    public Decimal ippanJutoMae = 0;
    public String kaimyoHomyoSlt;
    public Boolean planJuto = true;
    public String kasobaName;
    public String saijoName;
    public Boolean shutoken = false;
    public String biko;
    
    public void setSltFlg(Boolean sltFlg){
    	this.sltFlg = sltFlg;
    }

    public Boolean getSltFlg(){
    	return this.sltFlg;
    }

    public void setOptName(String optName){
    	this.optName = optName;
    }

    public String getOptName(){
    	return this.optName;
    }

    public void setStandardSlt(String standardSlt){
    	this.standardSlt = standardSlt;
    }

    public String getStandardSlt(){
    	return this.standardSlt;
    }

    public void setFreeWord(String freeWord){
    	this.freeWord = freeWord;
    }

    public String getFreeWord(){
    	return this.freeWord;
    }

    public void setKingaku(String kingaku){
    	this.kingaku = kingaku;
    }

    public String getKingaku(){
    	return this.kingaku;
    }

    public void setKingakuZeikomi(Decimal kingakuZeikomi){
        this.kingakuZeikomi = kingakuZeikomi;
    }

    public Decimal getKingakuZeikomi(){
        return this.kingakuZeikomi;
    }

    public void setSuryo(Decimal suryo){
    	this.suryo = suryo;
    }

    public Decimal getSuryo(){
    	return this.suryo;
    }

    public void setKaso(Decimal kaso){
    	this.kaso = kaso;
    }

    public Decimal getKaso(){
    	return this.kaso;
    }

    public void setIchinichi(Decimal ichinichi){
    	this.ichinichi = ichinichi;
    }

    public Decimal getIchinichi(){
    	return this.ichinichi;
    }

    public void setKazoku(Decimal kazoku){
    	this.kazoku = kazoku;
    }

    public Decimal getKazoku(){
    	return this.kazoku;
    }

    public void setIppan(Decimal ippan){
    	this.ippan = ippan;
    }

    public Decimal getIppan(){
    	return this.ippan;
    }

    public void setIchinichiJutoMae(Decimal ichinichiJutoMae){
        this.ichinichiJutoMae = ichinichiJutoMae;
    }

    public Decimal getIchinichiJutoMae(){
        return this.ichinichiJutoMae;
    }

    public void setKazokuJutoMae(Decimal kazokuJutoMae){
        this.kazokuJutoMae = kazokuJutoMae;
    }

    public Decimal getKazokuJutoMae(){
        return this.kazokuJutoMae;
    }

    public void setIppanJutoMae(Decimal ippanJutoMae){
        this.ippanJutoMae = ippanJutoMae;
    }

    public Decimal getIppanJutoMae(){
        return this.ippanJutoMae;
    }

    public void setKaimyoHomyoSlt(String kaimyoHomyoSlt){
    	this.kaimyoHomyoSlt = kaimyoHomyoSlt;
    }

    public String getKaimyoHomyoSlt(){
    	return this.kaimyoHomyoSlt;
    }

    public void setPlanJuto(Boolean planJuto){
    	this.planJuto = planJuto;
    }

    public Boolean getPlanJuto(){
    	return this.planJuto;
    }

    public void setKasobaName(String kasobaName){
    	this.kasobaName = kasobaName;
    }

    public String getKasobaName(){
    	return this.kasobaName;
    }

    public void setSaijoName(String saijoName){
    	this.saijoName = saijoName;
    }

    public String getSaijoName(){
    	return this.saijoName;
    }

    public void setShutoken(Boolean shutoken){
        this.shutoken = shutoken;
    }

    public Boolean getShutoken(){
        return this.shutoken;
    }

    public void setBiko(String biko){
        this.biko = biko;
    }

    public String getBiko(){
        return this.biko;
    }
}