public without sharing class ShisetsuImagesController {

    public class Result{
        @AuraEnabled public Boolean isError = false;
    }
    public class Processor{
        public ShisetsuImagesController.Result saveImage(String pRecordId, String pKasobaSaijo, String pExtension, String pImgData ){
            ShisetsuImagesController.Result theProcResult = new ShisetsuImagesController.Result();

            Shisetsu__c theShisetsu = getShisetsu(pRecordId);
            Long theFacilityId = Long.valueOf(pKasobaSaijo == 'Kasoba' ? theShisetsu.KasobaKeisaiJohoId__c : theShisetsu.SaijoKeisaiJohoId__c);
            ShisetsuImg__c theExistingOne = this.findExistingShisetsuImg(theShisetsu, pKasobaSaijo, 'top');

            if(theExistingOne == null){
                RsCoreApi_Images_Post.ReqArgs theReqArgs = new RsCoreApi_Images_Post.ReqArgs();
                theReqArgs.base64Data = pImgData;
                theReqArgs.extension = pExtension;
                theReqArgs.type = 'facility';
                theReqArgs.typeAssociateId = theFacilityId;
                theReqArgs.purpose = 'top';
                theReqArgs.published = true;
                RsCoreApi_Images_Post.Result theResult = new RsCoreApi_Images_Post.Agent().sendRequest(theReqArgs);

                if( !theResult.isError ){
                    ShisetsuImg__c theShisetsuImg = new ShisetsuImg__c(
                        CoreImgId__c = theResult.id,
                        ImageUrl__c = theResult.url,
                        KasobaSaijo__c = pKasobaSaijo,
                        Purpose__c = 'top',
                        ShisetsuRef__c = theShisetsu.Id
                    );
                    Insert theShisetsuImg;
                }

                if( !theResult.isError ){
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Info,'20180531-1533-01', 'Shisetsu.CoreSync.Image.Post','Success')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
                            .putAttr('pKasobaSaijo', pKasobaSaijo)
                            .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                            .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                    );
                }
                if(theResult.isError){
                    theProcResult.isError = true;
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error,'20180531-1533-02', 'Shisetsu.CoreSync.Image.Post','施設像の登録に失敗')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
                            .putAttr('pKasobaSaijo', pKasobaSaijo)
                            .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                            .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                    );
                }

            }


            if(theExistingOne != null){
                RsCoreApi_Images_Patch.ReqArgs theReqArgs = new RsCoreApi_Images_Patch.ReqArgs();
                theReqArgs.imageId = theExistingOne.CoreImgId__c;
                theReqArgs.base64Data = pImgData;
                theReqArgs.extension = pExtension;
                theReqArgs.published = true;
                RsCoreApi_Images_Patch.Result theResult = new RsCoreApi_Images_Patch.Agent().sendRequest(theReqArgs);

                if( !theResult.isError ){
                    theExistingOne.CoreImgId__c = String.valueOf(theResult.id);
                    theExistingOne.ImageUrl__c = theResult.url;
                    Update theExistingOne;
                }

                if( !theResult.isError ){
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Info,'20180531-1533-03', 'Shisetsu.CoreSync.Image.Patch','Success')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
                            .putAttr('pKasobaSaijo', pKasobaSaijo)
                            .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                            .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                    );
                }
                if(theResult.isError){
                    theProcResult.isError = true;
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error,'20180531-1533-04', 'Shisetsu.CoreSync.Image.Patch','施設像の登録に失敗')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
                            .putAttr('pKasobaSaijo', pKasobaSaijo)
                            .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                            .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                    );
                }
            }

            return theProcResult;
        }

        public ShisetsuImagesController.Result deleteImage( String pRecordId, String pKasobaSaijo ) {
            ShisetsuImagesController.Result theProcResult = new ShisetsuImagesController.Result();

            Shisetsu__c theShisetsu = getShisetsu(pRecordId);
            ShisetsuImg__c theExistingOne = this.findExistingShisetsuImg(theShisetsu, pKasobaSaijo, 'top');
            if(theExistingOne==null) return theProcResult;

            RsCoreApi_Images_Delete.ReqArgs theArgs = new RsCoreApi_Images_Delete.ReqArgs();
            theArgs.imageId = Long.valueOf(theExistingOne.CoreImgId__c);
            RsCoreApi_Images_Delete.Result theResult = new RsCoreApi_Images_Delete.Agent().sendRequest(theArgs);

            if( !theResult.isError ) Delete theExistingOne;

            if( !theResult.isError ){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Info,'20180531-1535-01', 'Shisetsu.CoreSync.Image.Delete','Success')
                        .setSubjectRecordId(theShisetsu.Id)
                        .putAttr('endPoint',theResult.endPoint)
                        .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                        .putAttr('descr',theResult.descr)
                        .putAttr('pKasobaSaijo', pKasobaSaijo)
                        .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                        .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                );
            }
            if(theResult.isError){
                theProcResult.isError = true;
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error,'20180531-1535-02', 'Shisetsu.CoreSync.Image.Delete','施設像の登録に失敗')
                        .setSubjectRecordId(theShisetsu.Id)
                        .putAttr('endPoint',theResult.endPoint)
                        .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                        .putAttr('descr',theResult.descr)
                        .putAttr('pKasobaSaijo', pKasobaSaijo)
                        .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                        .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                );
            }
            return theProcResult;
        } 

        private Shisetsu__c getShisetsu(String pRecordId){
            List<Shisetsu__c> theShisetsus = new List<Shisetsu__c>(
                [
                    select 
                    Id, KasobaKeisaiJohoId__c, SaijoKeisaiJohoId__c,
                    (
                        select id, CoreImgId__c, KasobaSaijo__c, Purpose__c from ShisetsuImgs__r
                    )
                    from Shisetsu__c where Id = :pRecordId
                ]
            );
            if(theShisetsus.size() > 0) return theShisetsus.get(0);
            return null;
        }

        private ShisetsuImg__c findExistingShisetsuImg(Shisetsu__c pShisetsu, String pKasobaSaijo, String pPurpose){
            ShisetsuImg__c theExistingOne = null;
            for(ShisetsuImg__c aShisetsuImg : pShisetsu.ShisetsuImgs__r){
                if(aShisetsuImg.KasobaSaijo__c == pKasobaSaijo && aShisetsuImg.Purpose__c == pPurpose) {
                    theExistingOne = aShisetsuImg;
                    break;
                }
            }
            return theExistingOne;
        }
    }

    @AuraEnabled
    public static ShisetsuImagesController.Result saveImage(String pRecordId, String pKasobaSaijo, String pExtension, String pImgData ) {
        try{
            return new Processor().saveImage(pRecordId, pKasobaSaijo, pExtension, pImgData );
        }
        catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error,'20180531-2220-01', 'Shisetsu.CoreSync.Image.saveImage','施設画像の連携中にエラー')
                    .setSubjectRecordId(pRecordId)
                    .putAttr('pKasobaSaijo', pKasobaSaijo)
                    .putAttr('exception.getMessage()', e.getMessage() )
            );
            return new ShisetsuImagesController.Result();
        }
    }

    @AuraEnabled
    public static ShisetsuImagesController.Result deleteImage( String pRecordId, String pKasobaSaijo ) {
        try{
            return new Processor().deleteImage(pRecordId, pKasobaSaijo);
        }catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error,'20180531-2220-02', 'Shisetsu.CoreSync.Image.deleteImage','施設画像の連携中にエラー')
                    .setSubjectRecordId(pRecordId)
                    .putAttr('pKasobaSaijo', pKasobaSaijo)
                    .putAttr('exception.getMessage()', e.getMessage() )
            );
            return new ShisetsuImagesController.Result();
        }
    }
}