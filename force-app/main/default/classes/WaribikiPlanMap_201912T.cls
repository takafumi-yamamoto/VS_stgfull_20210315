@isTest
private class WaribikiPlanMap_201912T {

    /**
     * This is a test method for getPlanWaribikiShohinBango
     */
    static testMethod void test_getPlanWaribikiShohinBango() {

        Test.startTest();

		String memberKubun = 'FhiVGll';
		String planShohinBango = 'zVL1kjp';
		String jizenwariKeikaKikan = 'xFIwlHU';
		WaribikiPlanMap_201912 waribikiPlanMap_201912 = new WaribikiPlanMap_201912();
		String resultGetPlanWaribikiShohinBango = waribikiPlanMap_201912.getPlanWaribikiShohinBango(memberKubun,planShohinBango,jizenwariKeikaKikan);


        Test.stopTest();

    }


    /**
     * This is a test method for getJizenJunbiWaribikiShohinBango
     */
    static testMethod void test_getJizenJunbiWaribikiShohinBango() {

        Test.startTest();

		String planShohinBango = '4m8wmWi';
		WaribikiPlanMap_201912 waribikiPlanMap_201912 = new WaribikiPlanMap_201912();
		String resultGetJizenJunbiWaribikiShohinBango = waribikiPlanMap_201912.getJizenJunbiWaribikiShohinBango(planShohinBango);


        Test.stopTest();

    }


    /**
     * This is a test method for getAnkenWaribikiShohinBango
     */
    static testMethod void test_getAnkenWaribikiShohinBango() {


        Test.startTest();

		String planShohinBango = 'SUk1Dg2';
		WaribikiPlanMap_201912 waribikiPlanMap_201912 = new WaribikiPlanMap_201912();
		String resultGetAnkenWaribikiShohinBango = waribikiPlanMap_201912.getAnkenWaribikiShohinBango(planShohinBango);


        Test.stopTest();

    }


    /**
     * This is a test method for getKakakuComWaribikiShohinBango
     */
    static testMethod void test_getKakakuComWaribikiShohinBango() {

        Test.startTest();

		String planShohinBango = 'rE9Qh2k';
		WaribikiPlanMap_201912 waribikiPlanMap_201912 = new WaribikiPlanMap_201912();
		String resultGetKakakuComWaribikiShohinBango = waribikiPlanMap_201912.getKakakuComWaribikiShohinBango(planShohinBango);


        Test.stopTest();
    }


    /**
     * This is a test method for getAtobaraiShohinBango
     */
    static testMethod void test_getAtobaraiShohinBango() {

        Test.startTest();

		String planShohinBango = 'kqDzJuz';
		WaribikiPlanMap_201912 waribikiPlanMap_201912 = new WaribikiPlanMap_201912();
		String resultGetAtobaraiShohinBango = waribikiPlanMap_201912.getAtobaraiShohinBango(planShohinBango);


        Test.stopTest();

    }


}