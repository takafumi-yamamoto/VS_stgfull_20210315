public class AcrtDrTackBatActivator implements Schedulable{
    @TestVisible
    private static Boolean to_raise_error_for_test_coverage = false;
    public void execute(SchedulableContext context) {
        try{
            //unschedule me.
            System.abortJob( context.getTriggerId() );
            AcrtDrTackBat.start();
            //reschedule new one.
            scheduleNew();
            if(to_raise_error_for_test_coverage) throw new Exceptions.AnException();
        }catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(
                    Loggings.Level.Error, '20200806-2109-01', 'AcrtDrTackBatActivator.execute','Cyclic-Scheduling has been killed. Resuchedule Needed!')
                    .putAttr('e.getMessage()',e.getMessage())
            );
        }
    }

    public static void scheduleNew(){
        Integer theInterval = 5;
        String theNextTimeCron = DateTime.now().addMinutes(theInterval).format('s m H d M ? y');
        System.schedule('AcrtDrTackBatActivator : accrete dlr 取得' + '(' + theNextTimeCron + ')', theNextTimeCron, new AcrtDrTackBatActivator() );
    }
}