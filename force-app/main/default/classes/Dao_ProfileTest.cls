@isTest
public class Dao_ProfileTest {
    @isTest
    public static void doTest(){
        Dao_Profile theTarget = Dao_Profile.getInstance();
        List<Profile> theActual = theTarget.selectAll();
        System.Debug(theActual);
    }
}