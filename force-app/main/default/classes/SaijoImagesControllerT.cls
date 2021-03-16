@isTest
public class SaijoImagesControllerT {
    
    @isTest(SeeAllData=true)
    public static void saveImage_NewOne(){

        Map<String, Saijo__c> theSaijos = new Map<String, Saijo__c>{
            '1' => new Saijo__c( Name='1')
        };

        Insert theSaijos.values();
        Saijo__c theShisetsu = [select id from Saijo__c where id = :theSaijos.get('1').Id ].get(0);

        RsCoreApi_Images_Post.ResBody theRes = new RsCoreApi_Images_Post.ResBody();
        theRes.id = 900000001;
        theRes.url = '<image url>';
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(201).setBody( JSON.serialize( theRes ) ) );

        Test.startTest();
        SaijoImagesController.Result theResult = SaijoImagesController.saveImage(theShisetsu.Id, 'gaikan', 'jpg', '<imgge data>' );
        Test.stopTest();
        
    }

    @isTest(SeeAllData=true)
    public static void saveImage_NewOne_BadResponse(){

        Map<String, Saijo__c> theSaijos = new Map<String, Saijo__c>{
            '1' => new Saijo__c( Name='1')
        };

        Insert theSaijos.values();
        Saijo__c theSaijo = [select id from Saijo__c where id = :theSaijos.get('1').Id ].get(0);

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );

        Test.startTest();
        SaijoImagesController.Result theResult = SaijoImagesController.saveImage(theSaijo.Id, 'gaikan', 'jpg', '<imgge data>' );
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void saveImage_ExistingOne(){

        Map<String, Saijo__c> theSaijos = new Map<String, Saijo__c>{
            '1' => new Saijo__c( Name='1')
        };

        Insert theSaijos.values();
        Saijo__c theSaijo = [select id from Saijo__c where id = :theSaijos.get('1').Id ].get(0);

        Map<String,SaijoImg__c> theShisetsuImgsOld = new Map<String,SaijoImg__c>{
            'Saijo' => new SaijoImg__c(
                CoreImgId__c = '900000003', 
                ImageUrl__c ='<old-image-url>', 
                Purpose__c = 'gaikan',
                SaijoRef__c = theSaijo.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        RsCoreApi_Images_Patch.ResBody theRes = new RsCoreApi_Images_Patch.ResBody();
        theRes.id = 900000002;
        theRes.url = '<new-image-url>';
        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(200).setBody( JSON.serialize( theRes ) ) );

        Test.startTest();
        SaijoImagesController.Result theResult = SaijoImagesController.saveImage(theSaijo.Id, 'gaikan', 'jpg', '<imgge data>' );
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void saveImage_ExistingOne_BadResponse(){

        Map<String, Saijo__c> theSaijos = new Map<String, Saijo__c>{
            '1' => new Saijo__c( Name='1')
        };

        Insert theSaijos.values();
        Saijo__c theSaijo = [select id from Saijo__c where id = :theSaijos.get('1').Id ].get(0);

        Map<String,SaijoImg__c> theShisetsuImgsOld = new Map<String,SaijoImg__c>{
            'Saijo' => new SaijoImg__c(
                CoreImgId__c = '900000003', 
                ImageUrl__c ='<old-image-url>', 
                Purpose__c = 'gaikan',
                SaijoRef__c = theSaijo.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );

        Test.startTest();
        SaijoImagesController.Result theResult = SaijoImagesController.saveImage(theSaijo.Id, 'gaikan', 'jpg', '<imgge data>');
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void saveImage_deleteImage(){

        Map<String, Saijo__c> theSaijos = new Map<String, Saijo__c>{
            '1' => new Saijo__c( Name='1')
        };

        Insert theSaijos.values();
        Saijo__c theShisetsu = [select id from Saijo__c where id = :theSaijos.get('1').Id ].get(0);

        Map<String,SaijoImg__c> theShisetsuImgsOld = new Map<String,SaijoImg__c>{
            'Saijo' => new SaijoImg__c(
                CoreImgId__c = '900000002', 
                Purpose__c = 'gaikan',
                SaijoRef__c = theShisetsu.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(204) );

        Test.startTest();
        SaijoImagesController.Result theResult = SaijoImagesController.deleteImage(theShisetsu.Id, 'gaikan');
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void saveImage_deleteImage_BadResponse(){

        Map<String, Saijo__c> theSaijos = new Map<String, Saijo__c>{
            '1' => new Saijo__c( Name='1')
        };

        Insert theSaijos.values();
        Saijo__c theShisetsu = [select id from Saijo__c where id = :theSaijos.get('1').Id ].get(0);

        Map<String,SaijoImg__c> theShisetsuImgsOld = new Map<String,SaijoImg__c>{
            'Saijo' => new SaijoImg__c(
                CoreImgId__c = '900000002', 
                Purpose__c = 'gaikan',
                SaijoRef__c = theShisetsu.Id           
            )
        };
        Insert theShisetsuImgsOld.values();

        Test.setMock( HttpCalloutMock.class, new Testing_HttpResponseMock().setStatusCode(500) );

        Test.startTest();
        SaijoImagesController.Result theResult = SaijoImagesController.deleteImage(theShisetsu.Id, 'gaikan');
        Test.stopTest();
    }
}