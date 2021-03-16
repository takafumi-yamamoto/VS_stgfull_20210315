@isTest
public class ShisetsuImagesControllerTest {
    
    @isTest(SeeAllData=true)
    public static void saveImage_NewOne(){

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c( Name='1')
        };

        Insert theShisetsus.values();
        Shisetsu__c theShisetsu = [select id from Shisetsu__c where id = :theShisetsus.get('1').Id ].get(0);

        RsCoreApi_Images_Post.ResBody theRes = new RsCoreApi_Images_Post.ResBody();
        theRes.id = 900000001;
        theRes.url = '<image url>';
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(201).setBody( JSON.serialize( theRes ) ) );

        Test.startTest();
        ShisetsuImagesController.Result theResult = ShisetsuImagesController.saveImage(theShisetsu.Id, 'Kasoba', 'jpg', '<imgge data>' );
        Test.stopTest();
        
        //System.Debug(theResult);
        
        ShisetsuImg__c[] theShisetsuImgs = 
            [
                select Id, CoreImgId__c, ImageUrl__c, KasobaSaijo__c, Purpose__c,ShisetsuRef__c 
                from ShisetsuImg__c 
                where ShisetsuRef__c = :theShisetsu.Id
            ];

        //System.Debug(theShisetsuImgs.get(0));
        

        System.assertEquals(1, theShisetsuImgs.size(), 'theShisetsuImgs.size()');
        System.assertEquals('900000001', theShisetsuImgs.get(0).CoreImgId__c, 'CoreImgId__c');
        System.assertEquals('<image url>', theShisetsuImgs.get(0).ImageUrl__c, 'ImageUrl__c');
        System.assertEquals('Kasoba', theShisetsuImgs.get(0).KasobaSaijo__c, 'KasobaSaijo__c');
        System.assertEquals('top', theShisetsuImgs.get(0).Purpose__c, 'Purpose__c');
    }

    @isTest(SeeAllData=true)
    public static void saveImage_NewOne_BadResponse(){

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c( Name='1')
        };

        Insert theShisetsus.values();
        Shisetsu__c theShisetsu = [select id from Shisetsu__c where id = :theShisetsus.get('1').Id ].get(0);

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );

        Test.startTest();
        ShisetsuImagesController.Result theResult = ShisetsuImagesController.saveImage(theShisetsu.Id, 'Kasoba', 'jpg', '<imgge data>' );
        Test.stopTest();
        
        //System.Debug(theResult);
        
        ShisetsuImg__c[] theShisetsuImgs = 
            [
                select Id, CoreImgId__c, ImageUrl__c, KasobaSaijo__c, Purpose__c,ShisetsuRef__c 
                from ShisetsuImg__c 
                where ShisetsuRef__c = :theShisetsu.Id
            ];

        //System.Debug(theShisetsuImgs.get(0));
        
        System.assertEquals(true, theResult.isError, 'theResult.isError');
        System.assertEquals(0, theShisetsuImgs.size(), 'theShisetsuImgs.size()');
    }

    @isTest(SeeAllData=true)
    public static void saveImage_ExistingOne(){

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c( Name='1')
        };

        Insert theShisetsus.values();
        Shisetsu__c theShisetsu = [select id from Shisetsu__c where id = :theShisetsus.get('1').Id ].get(0);

        Map<String,ShisetsuImg__c> theShisetsuImgsOld = new Map<String,ShisetsuImg__c>{
            'Kasoba' => new ShisetsuImg__c(
                CoreImgId__c = '900000001', 
                ImageUrl__c ='<old-image-url>', 
                KasobaSaijo__c = 'Kasoba',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            ),
            'Saijo' => new ShisetsuImg__c(
                CoreImgId__c = '900000003', 
                ImageUrl__c ='<old-image-url>', 
                KasobaSaijo__c = 'Saijo',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        RsCoreApi_Images_Patch.ResBody theRes = new RsCoreApi_Images_Patch.ResBody();
        theRes.id = 900000002;
        theRes.url = '<new-image-url>';
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200).setBody( JSON.serialize( theRes ) ) );

        Test.startTest();
        ShisetsuImagesController.Result theResult = ShisetsuImagesController.saveImage(theShisetsu.Id, 'Kasoba', 'jpg', '<imgge data>' );
        Test.stopTest();
        
        //System.Debug(theResult);
        
        ShisetsuImg__c[] theShisetsuImgs = 
            [
                select Id, CoreImgId__c, ImageUrl__c, KasobaSaijo__c, Purpose__c,ShisetsuRef__c 
                from ShisetsuImg__c 
                where ShisetsuRef__c = :theShisetsu.Id
                order by CoreImgId__c
            ];

        //System.Debug(theShisetsuImgs.get(0));
        System.assertEquals(2, theShisetsuImgs.size(), 'theShisetsuImgs.size()');
        System.assertEquals('900000002', theShisetsuImgs.get(0).CoreImgId__c, 'CoreImgId__c');
        System.assertEquals('<new-image-url>', theShisetsuImgs.get(0).ImageUrl__c, 'ImageUrl__c');
        System.assertEquals('Kasoba', theShisetsuImgs.get(0).KasobaSaijo__c, 'KasobaSaijo__c');
        System.assertEquals('top', theShisetsuImgs.get(0).Purpose__c, 'Purpose__c');

        System.assertEquals('900000003', theShisetsuImgs.get(1).CoreImgId__c, 'CoreImgId__c');
        System.assertEquals('<old-image-url>', theShisetsuImgs.get(1).ImageUrl__c, 'ImageUrl__c');
    }

    @isTest(SeeAllData=true)
    public static void saveImage_ExistingOne_BadResponse(){

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c( Name='1')
        };

        Insert theShisetsus.values();
        Shisetsu__c theShisetsu = [select id from Shisetsu__c where id = :theShisetsus.get('1').Id ].get(0);

        Map<String,ShisetsuImg__c> theShisetsuImgsOld = new Map<String,ShisetsuImg__c>{
            'Kasoba' => new ShisetsuImg__c(
                CoreImgId__c = '900000001', 
                ImageUrl__c ='<old-image-url>', 
                KasobaSaijo__c = 'Kasoba',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            ),
            'Saijo' => new ShisetsuImg__c(
                CoreImgId__c = '900000003', 
                ImageUrl__c ='<old-image-url>', 
                KasobaSaijo__c = 'Saijo',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );

        Test.startTest();
        ShisetsuImagesController.Result theResult = ShisetsuImagesController.saveImage(theShisetsu.Id, 'Kasoba', 'jpg', '<imgge data>' );
        Test.stopTest();
        
        //System.Debug(theResult);
        
        ShisetsuImg__c[] theShisetsuImgs = 
            [
                select Id, CoreImgId__c, ImageUrl__c, KasobaSaijo__c, Purpose__c,ShisetsuRef__c 
                from ShisetsuImg__c 
                where ShisetsuRef__c = :theShisetsu.Id
                order by CoreImgId__c
            ];

        //System.Debug(theShisetsuImgs.get(0));
        System.assertEquals(true, theResult.isError, 'theResult.isError');
        System.assertEquals(2, theShisetsuImgs.size(), 'theShisetsuImgs.size()');
        System.assertEquals('900000001', theShisetsuImgs.get(0).CoreImgId__c, 'CoreImgId__c');
        System.assertEquals('<old-image-url>', theShisetsuImgs.get(0).ImageUrl__c, 'ImageUrl__c');
        System.assertEquals('Kasoba', theShisetsuImgs.get(0).KasobaSaijo__c, 'KasobaSaijo__c');
        System.assertEquals('top', theShisetsuImgs.get(0).Purpose__c, 'Purpose__c');

        System.assertEquals('900000003', theShisetsuImgs.get(1).CoreImgId__c, 'CoreImgId__c');
        System.assertEquals('<old-image-url>', theShisetsuImgs.get(1).ImageUrl__c, 'ImageUrl__c');
    }

    @isTest(SeeAllData=true)
    public static void saveImage_deleteImage(){

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c( Name='1')
        };

        Insert theShisetsus.values();
        Shisetsu__c theShisetsu = [select id from Shisetsu__c where id = :theShisetsus.get('1').Id ].get(0);

        Map<String,ShisetsuImg__c> theShisetsuImgsOld = new Map<String,ShisetsuImg__c>{
            'Kasoba' => new ShisetsuImg__c(
                CoreImgId__c = '900000001', 
                KasobaSaijo__c = 'Kasoba',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            ),
            'Saijo' => new ShisetsuImg__c(
                CoreImgId__c = '900000002', 
                KasobaSaijo__c = 'Saijo',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(204) );

        Test.startTest();
        ShisetsuImagesController.Result theResult = ShisetsuImagesController.deleteImage(theShisetsu.Id, 'Kasoba');
        Test.stopTest();
        
        //System.Debug(theResult);
        
        ShisetsuImg__c[] theShisetsuImgsNew = 
            [
                select Id, CoreImgId__c, ImageUrl__c, KasobaSaijo__c, Purpose__c,ShisetsuRef__c 
                from ShisetsuImg__c 
                where ShisetsuRef__c = :theShisetsu.Id
            ];

        System.assertEquals(1, theShisetsuImgsNew.size(), 'theShisetsuImgsNew.size()');
        System.assertEquals('Saijo', theShisetsuImgsNew.get(0).KasobaSaijo__c , 'theShisetsuImgsNew.get(0).KasobaSaijo__c');
    }

    @isTest(SeeAllData=true)
    public static void saveImage_deleteImage_BadResponse(){

        Map<String, Shisetsu__c> theShisetsus = new Map<String, Shisetsu__c>{
            '1' => new Shisetsu__c( Name='1')
        };

        Insert theShisetsus.values();
        Shisetsu__c theShisetsu = [select id from Shisetsu__c where id = :theShisetsus.get('1').Id ].get(0);

        Map<String,ShisetsuImg__c> theShisetsuImgsOld = new Map<String,ShisetsuImg__c>{
            'Kasoba' => new ShisetsuImg__c(
                CoreImgId__c = '900000001', 
                KasobaSaijo__c = 'Kasoba',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            ),
            'Saijo' => new ShisetsuImg__c(
                CoreImgId__c = '900000002', 
                KasobaSaijo__c = 'Saijo',
                Purpose__c = 'top',
                ShisetsuRef__c = theShisetsu.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );

        Test.startTest();
        ShisetsuImagesController.Result theResult = ShisetsuImagesController.deleteImage(theShisetsu.Id, 'Kasoba');
        Test.stopTest();
        
        //System.Debug(theResult);
        
        ShisetsuImg__c[] theShisetsuImgsNew = 
            [
                select Id, CoreImgId__c, ImageUrl__c, KasobaSaijo__c, Purpose__c,ShisetsuRef__c 
                from ShisetsuImg__c 
                where ShisetsuRef__c = :theShisetsu.Id
            ];

        System.assertEquals(true, theResult.isError, 'theResult.isError');
        System.assertEquals(2, theShisetsuImgsNew.size(), 'theShisetsuImgsNew.size()');
    }
}