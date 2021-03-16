public class UmeDevPageCtl {
    public UmeDevPageCtl() {
        my_msg = 'hello';
    }

    public String my_msg { get; set; }

    public PageReference action01(){
        my_msg = 'hello action01';
        return null;
    } 
}