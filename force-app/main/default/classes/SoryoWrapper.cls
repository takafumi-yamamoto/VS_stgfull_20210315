public class SoryoWrapper {
	
    public Keiyaku__c keiyaku {get; set;}
    public Decimal distance {get; set;}

    public SoryoWrapper(Keiyaku__c keiyaku, Decimal distance) {
        this.keiyaku = keiyaku;
        this.distance = distance;
    }
}