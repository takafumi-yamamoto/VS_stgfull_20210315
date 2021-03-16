public class SaijoImagesController {

    public class Result{
        @AuraEnabled public Boolean isError = false;
    }
    public class Processor{
        public SaijoImagesController.Result saveImage(String pRecordId, String pPuropose, String pExtension, String pImgData ){
            SaijoImagesController.Result theProcResult = new SaijoImagesController.Result();

            Saijo__c theShisetsu = getShisetsu(pRecordId);
            Long theFacilityId = Long.valueOf(theShisetsu.SaijoKeisaiJohoId__c);
            SaijoImg__c theExistingOne = this.findExistingShisetsuImg(theShisetsu, pPuropose);

            if(theExistingOne == null){
                RsCoreApi_Images_Post.ReqArgs theReqArgs = new RsCoreApi_Images_Post.ReqArgs();
                theReqArgs.base64Data = pImgData;
                theReqArgs.extension = pExtension;
                theReqArgs.type = 'facility';
                theReqArgs.typeAssociateId = theFacilityId;
                theReqArgs.purpose = pPuropose;
                theReqArgs.published = true;
                RsCoreApi_Images_Post.Result theResult = new RsCoreApi_Images_Post.Agent().sendRequest(theReqArgs);

                if( !theResult.isError ){
                    SaijoImg__c theShisetsuImg = new SaijoImg__c(
                        CoreImgId__c = theResult.id,
                        ImageUrl__c = theResult.url,
                        Purpose__c = pPuropose,
                        SaijoRef__c = theShisetsu.Id
                    );
                    Insert theShisetsuImg;
                }

                if( !theResult.isError ){
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Info,'20190903-1314-01', 'SaijoImagesController.CoreSync.Image.Post','Success')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
                            .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                            .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                    );
                }
                if(theResult.isError){
                    theProcResult.isError = true;
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error,'20190903-1314-02', 'SaijoImagesController.CoreSync.Image.Post','斎場画像の登録に失敗')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
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
                        Loggings.createLogEntry(Loggings.Level.Info,'20190903-1314-03', 'SaijoImagesController.CoreSync.Image.Patch','Success')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
                            .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                            .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                    );
                }
                if(theResult.isError){
                    theProcResult.isError = true;
                    Loggings.writeLog(
                        Loggings.createLogEntry(Loggings.Level.Error,'20190903-1314-04', 'SaijoImagesController.CoreSync.Image.Patch','斎場画像の更新に失敗')
                            .setSubjectRecordId(theShisetsu.Id)
                            .putAttr('endPoint',theResult.endPoint)
                            .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                            .putAttr('descr',theResult.descr)
                            .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                            .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                    );
                }
            }

            return theProcResult;
        }

        public SaijoImagesController.Result deleteImage( String pRecordId, String pPuropose) {
            SaijoImagesController.Result theProcResult = new SaijoImagesController.Result();

            Saijo__c theShisetsu = getShisetsu(pRecordId);
            SaijoImg__c theExistingOne = this.findExistingShisetsuImg(theShisetsu, pPuropose);
            if(theExistingOne==null) return theProcResult;

            RsCoreApi_Images_Delete.ReqArgs theArgs = new RsCoreApi_Images_Delete.ReqArgs();
            theArgs.imageId = Long.valueOf(theExistingOne.CoreImgId__c);
            RsCoreApi_Images_Delete.Result theResult = new RsCoreApi_Images_Delete.Agent().sendRequest(theArgs);

            if( !theResult.isError ) Delete theExistingOne;

            if( !theResult.isError ){
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Info,'20190903-1314-05', 'SaijoImagesController.CoreSync.Image.Delete','Success')
                        .setSubjectRecordId(theShisetsu.Id)
                        .putAttr('endPoint',theResult.endPoint)
                        .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                        .putAttr('descr',theResult.descr)
                        .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                        .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                );
            }
            if(theResult.isError){
                theProcResult.isError = true;
                Loggings.writeLog(
                    Loggings.createLogEntry(Loggings.Level.Error,'20190903-1314-06', 'SaijoImagesController.CoreSync.Image.Delete','斎場画像の登録に失敗')
                        .setSubjectRecordId(theShisetsu.Id)
                        .putAttr('endPoint',theResult.endPoint)
                        .putAttr('statusCode',String.valueOf(theResult.statusCode) )
                        .putAttr('descr',theResult.descr)
                        .putAttr('reqBodyRaw',theResult.reqBodyRaw == null ? '' : theResult.reqBodyRaw.left(500) )
                        .putAttr('resBodyRaw',theResult.resBodyRaw == null ? '' : theResult.resBodyRaw.left(500) )
                );
            }
            return theProcResult;
        } 

        private Saijo__c getShisetsu(String pRecordId){
            List<Saijo__c> theShisetsus = new List<Saijo__c>(
                [
                    select 
                    Id, SaijoKeisaiJohoId__c,
                    (
                        select id, CoreImgId__c, Purpose__c from SaijoSaijoImgs__r
                    )
                    from Saijo__c where Id = :pRecordId
                ]
            );
            if(theShisetsus.size() > 0) return theShisetsus.get(0);
            return null;
        }

        private SaijoImg__c findExistingShisetsuImg(Saijo__c pShisetsu, String pPurpose){
            SaijoImg__c theExistingOne = null;
            for(SaijoImg__c aShisetsuImg : pShisetsu.SaijoSaijoImgs__r){
                if(aShisetsuImg.Purpose__c == pPurpose) {
                    theExistingOne = aShisetsuImg;
                    break;
                }
            }
            return theExistingOne;
        }
    }

    @AuraEnabled
    public static SaijoImagesController.Result saveImage(String pRecordId, String pPuropose, String pExtension, String pImgData ) {
        try{
            return new Processor().saveImage(pRecordId, pPuropose, pExtension, pImgData );
        }
        catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error,'20190903-1314-07', 'SaijoImagesController.CoreSync.Image.saveImage','斎場画像の連携中にエラー')
                    .setSubjectRecordId(pRecordId)
                    .putAttr('exception.getMessage()', e.getMessage() )
            );
            return new SaijoImagesController.Result();
        }
    }

    @AuraEnabled
    public static SaijoImagesController.Result deleteImage( String pRecordId, String pPuropose) {
        try{
            return new Processor().deleteImage(pRecordId, pPuropose);
        }catch(Exception e){
            Loggings.writeLog(
                Loggings.createLogEntry(Loggings.Level.Error,'20190903-1314-08', 'SaijoImagesController.CoreSync.Image.deleteImage','斎場画像の連携中にエラー')
                    .setSubjectRecordId(pRecordId)
                    .putAttr('exception.getMessage()', e.getMessage() )
            );
            return new SaijoImagesController.Result();
        }
    }
}