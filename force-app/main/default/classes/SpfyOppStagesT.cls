@isTest
public class SpfyOppStagesT {
    @isTest public static void StageRsolver_getStageNext_Jucyu() {

        Test.startTest();
        SpfyOppStages.Res theRes = new SpfyOppStages.StageRsolver(
            new SpfyPreKessaiPolicy.PreKessaiPolicy()
        ).getStageNext(
            new SpfyOppStages.Req()
                .set_prevStageName('')
        );
        Test.stopTest();
    }

    @isTest public static void StageRsolver_getStageNext_Hattcyusho() {

        Test.startTest();
        SpfyOppStages.Res theRes = new SpfyOppStages.StageRsolver(
            new SpfyPreKessaiPolicy.PreKessaiPolicy()
        ).getStageNext(
            new SpfyOppStages.Req()
                .set_prevStageName('発注準備')
                .set_prevSubPhase('入金待ち-best')
                .set_financial_status('paid')
        );
        Test.stopTest();
    }

    @isTest public static void StageRsolver_getStageNext_Shipping() {

        Test.startTest();
        SpfyOppStages.Res theRes = new SpfyOppStages.StageRsolver(
            new SpfyPreKessaiPolicy.PreKessaiPolicy()
        ).getStageNext(
            new SpfyOppStages.Req()
                .set_fulfillment_status('partial')
        );
        Test.stopTest();
    }

    @isTest public static void StageRsolver_getStageNext_Shipped() {

        Test.startTest();
        SpfyOppStages.Res theRes = new SpfyOppStages.StageRsolver(
            new SpfyPreKessaiPolicy.PreKessaiPolicy()
        ).getStageNext(
            new SpfyOppStages.Req()
                .set_fulfillment_status('fulfilled')
        );
        Test.stopTest();
    }

    @isTest public static void StageRsolver_getStageNext_Closed() {

        Test.startTest();
        SpfyOppStages.Res theRes = new SpfyOppStages.StageRsolver(
            new SpfyPreKessaiPolicy.PreKessaiPolicy()
        ).getStageNext(
            new SpfyOppStages.Req()
                .set_fulfillment_status('fulfilled')
                .set_financial_status('paid')
                .set_shipDate( Date.newInstance(2020, 7, 13) )
        );
        Test.stopTest();
    }
}