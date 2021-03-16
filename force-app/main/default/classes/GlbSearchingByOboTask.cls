public class GlbSearchingByOboTask implements Queueable{

    private Id f_TaskId = null;
    public GlbSearchingByOboTask(Id pTaskId){ this.f_TaskId = pTaskId; }

    public void execute(QueueableContext context) {
        this.runTask( this.f_TaskId );
    }
    
    public void runTask(Id pTaskId){

        List<GlbSearchingByOboTask__c> theTasks = [
            SELECT 
            Id, ObosanbinRef__c
            FROM GlbSearchingByOboTask__c 
            WHERE Id = :pTaskId
            Limit 1
        ];

        if(theTasks.size() <= 0) return;
        GlbSearchingByOboTask__c theTask = theTasks.get(0);
        if(theTask.ObosanbinRef__c == null) return;

        List<Obosanbin__c> theObosanbins = [
            SELECT 
            Id, 
            Taishosha1Ref__c,
            Taishosha1Ref__r.LastName, Taishosha1Ref__r.FirstName,
            Taishosha1Ref__r.NameFurigana__c,
            Taishosha1Ref__r.Phone, Taishosha1Ref__r.MobilePhone__c,
            MoshuRef__c,
            MoshuRef__r.LastName, MoshuRef__r.FirstName,
            MoshuRef__r.NameFurigana__c,
            MoshuRef__r.Phone, MoshuRef__r.MobilePhone__c,
            SekoTantoSoryoSangoJiinMeiFurigana__c,
            SekoTantoSoryoSoryoRenrakusaki__c,
            ObosanbinKeiyakuMadoguchi__c, 
            ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.SeiKana__c, ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MeiKana__c,
            ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Phone, ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhone__c,
            ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,
            ObosanbinKeiyakuSekotanto__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.SeiKana__c, ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MeiKana__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Phone, ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MobilePhone__c,
            ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c,
            (
                SELECT Id,
                SekoTantoKanaSearch__c,
                TaisyousyaNameTxt__c, TaisyousyaFurigana__c, TaisyousyaPhone__c, TaisyousyaMobilePhone__c,
                MosyuNameTxt__c, MosyuFuriganaTxt__c, MosyuPhoneTxt__c, MosyuMobilePhoneTxt__c,
                KetteiSakiRef__c, KetteiSakiKanaSerch__c, 
                KetteiSakiDenwaBangoSearch__c, KetteiSakiKeitaiDenwaBangoSearch__c,
                KetteiSakiShozokuJiinKanaSearch__c,
                SekoTantoDenwaBangoSearch__c, SekoTantoKeitaiDenwaBangoSearch__c,
                SekoTantoSyozokuJiinKanaSearch__c
                FROM OpportunitiesObosanbin__r
            )
            FROM Obosanbin__c 
            WHERE Id = :theTask.ObosanbinRef__c
            LIMIT 1
        ];

        if(theObosanbins.size() <= 0) { theTask.ShoriStatus__c = 'Completed'; Update theTask; return; }
        Obosanbin__c theObosanbin = theObosanbins.get(0);
        if(theObosanbin.OpportunitiesObosanbin__r.size() <= 0) { theTask.ShoriStatus__c = 'Completed'; Update theTask; return; }
        Opportunity theOpp = theObosanbin.OpportunitiesObosanbin__r.get(0);

        Boolean theOppToBeUpdated = false;

        //対象者Begin
        String theTaisyousyaNameTxt = null;
        if(theObosanbin.Taishosha1Ref__c != null){
            theTaisyousyaNameTxt = 
                String.join(
                    new List<String>{ this.emptyIfNull(theObosanbin.Taishosha1Ref__r.LastName), this.emptyIfNull(theObosanbin.Taishosha1Ref__r.FirstName) },
                    ' '
                );
        }
        if(theOpp.TaisyousyaNameTxt__c != theTaisyousyaNameTxt){ theOpp.TaisyousyaNameTxt__c = theTaisyousyaNameTxt; theOppToBeUpdated = true; }

        String theTaisyousyaFurigana = theObosanbin.Taishosha1Ref__r.NameFurigana__c;
        if(theOpp.TaisyousyaFurigana__c != theTaisyousyaFurigana){ theOpp.TaisyousyaFurigana__c = theTaisyousyaFurigana; theOppToBeUpdated = true; }

        String theTaisyousyaPhone = theObosanbin.Taishosha1Ref__r.Phone;
        if(theOpp.TaisyousyaPhone__c != theTaisyousyaPhone){ theOpp.TaisyousyaPhone__c = theTaisyousyaPhone; theOppToBeUpdated = true; }

        String theTaisyousyaMobilePhone = theObosanbin.Taishosha1Ref__r.MobilePhone__c;
        if(theOpp.TaisyousyaMobilePhone__c != theTaisyousyaMobilePhone){ theOpp.TaisyousyaMobilePhone__c = theTaisyousyaMobilePhone; theOppToBeUpdated = true; }
        //対象者End

        //喪主Begin
        String theMosyuNameTxt = null;
        if(theObosanbin.MoshuRef__c != null){
            theMosyuNameTxt = 
                String.join(
                    new List<String>{ this.emptyIfNull(theObosanbin.MoshuRef__r.LastName), this.emptyIfNull(theObosanbin.MoshuRef__r.FirstName) },
                    ' '
                );
        }
        if(theOpp.MosyuNameTxt__c != theMosyuNameTxt){ theOpp.MosyuNameTxt__c = theMosyuNameTxt; theOppToBeUpdated = true; }

        String theMosyuFuriganaTxt = theObosanbin.MoshuRef__r.NameFurigana__c;
        if(theOpp.MosyuFuriganaTxt__c != theMosyuFuriganaTxt){ theOpp.MosyuFuriganaTxt__c = theMosyuFuriganaTxt; theOppToBeUpdated = true; }

        String theMosyuPhoneTxt = theObosanbin.MoshuRef__r.Phone;
        if(theOpp.MosyuPhoneTxt__c != theMosyuPhoneTxt){ theOpp.MosyuPhoneTxt__c = theMosyuPhoneTxt; theOppToBeUpdated = true; }

        String theMosyuMobilePhoneTxt = theObosanbin.MoshuRef__r.MobilePhone__c;
        if(theOpp.MosyuMobilePhoneTxt__c != theMosyuMobilePhoneTxt){ theOpp.MosyuMobilePhoneTxt__c = theMosyuMobilePhoneTxt; theOppToBeUpdated = true; }
        //喪主End

        //窓口僧侶 Begin
        Id theKetteiSakiRef = theObosanbin.ObosanbinKeiyakuMadoguchi__c;
        if(theOpp.KetteiSakiRef__c != theKetteiSakiRef){ theOpp.KetteiSakiRef__c = theKetteiSakiRef; theOppToBeUpdated = true; }

        String theKetteiSakiKanaSerch = null;
        if(theObosanbin.ObosanbinKeiyakuMadoguchi__c != null){
            theKetteiSakiKanaSerch = 
                String.join(
                    new List<String>{ 
                        this.emptyIfNull(theObosanbin.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.SeiKana__c),
                        this.emptyIfNull(theObosanbin.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MeiKana__c)
                        },
                    ' '
                );
        }
        if(theOpp.KetteiSakiKanaSerch__c != theKetteiSakiKanaSerch){ theOpp.KetteiSakiKanaSerch__c = theKetteiSakiKanaSerch; theOppToBeUpdated = true; }

        String theKetteiSakiDenwaBangoSearch = theObosanbin.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.Phone;
        if(theOpp.KetteiSakiDenwaBangoSearch__c != theKetteiSakiDenwaBangoSearch){ theOpp.KetteiSakiDenwaBangoSearch__c = theKetteiSakiDenwaBangoSearch; theOppToBeUpdated = true; }

        String theKetteiSakiKeitaiDenwaBangoSearch = theObosanbin.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.MobilePhone__c;
        if(theOpp.KetteiSakiKeitaiDenwaBangoSearch__c != theKetteiSakiKeitaiDenwaBangoSearch){ theOpp.KetteiSakiKeitaiDenwaBangoSearch__c = theKetteiSakiDenwaBangoSearch; theOppToBeUpdated = true; }

        String theKetteiSakiShozokuJiinKanaSearch = theObosanbin.ObosanbinKeiyakuMadoguchi__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c;
        if(theOpp.KetteiSakiShozokuJiinKanaSearch__c != theKetteiSakiShozokuJiinKanaSearch){ theOpp.KetteiSakiShozokuJiinKanaSearch__c = theKetteiSakiShozokuJiinKanaSearch; theOppToBeUpdated = true; }
         //窓口僧侶 End

        //施行僧侶 Begin
        String theSekoTantoKanaSearch = null;
        if(theObosanbin.ObosanbinKeiyakuSekotanto__c != null){
            theSekoTantoKanaSearch = 
                String.join(
                    new List<String>{ 
                        this.emptyIfNull(theObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.SeiKana__c),
                        this.emptyIfNull(theObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MeiKana__c)
                        },
                    ' '
                );
        }
        if(theOpp.SekoTantoKanaSearch__c != theSekoTantoKanaSearch){ theOpp.SekoTantoKanaSearch__c = theSekoTantoKanaSearch; theOppToBeUpdated = true; }

        String theSekoTantoDenwaBangoSearch = theObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.Phone;
        if(theOpp.SekoTantoDenwaBangoSearch__c != theSekoTantoDenwaBangoSearch){ theOpp.SekoTantoDenwaBangoSearch__c = theSekoTantoDenwaBangoSearch; theOppToBeUpdated = true; }

        String theSekoTantoKeitaiDenwaBangoSearch = 
            theObosanbin.ObosanbinKeiyakuSekotanto__c != null 
            ? theObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.MobilePhone__c
            : theObosanbin.SekoTantoSoryoSoryoRenrakusaki__c;
        if(theOpp.SekoTantoKeitaiDenwaBangoSearch__c != theSekoTantoKeitaiDenwaBangoSearch){ theOpp.SekoTantoKeitaiDenwaBangoSearch__c = theSekoTantoKeitaiDenwaBangoSearch; theOppToBeUpdated = true; }

        String theSekoTantoSyozokuJiinKanaSearch = 
                theObosanbin.ObosanbinKeiyakuSekotanto__c != null 
                ? theObosanbin.ObosanbinKeiyakuSekotanto__r.Teikeisaki__r.ShozokuSangouSangoJiin__r.SangoJiinMeiFurigana__c
                : theObosanbin.SekoTantoSoryoSangoJiinMeiFurigana__c;
        if(theOpp.SekoTantoSyozokuJiinKanaSearch__c != theSekoTantoSyozokuJiinKanaSearch){ theOpp.SekoTantoSyozokuJiinKanaSearch__c = theSekoTantoSyozokuJiinKanaSearch; theOppToBeUpdated = true; }
         //施行僧侶 End

         if(theOppToBeUpdated){
             Update theOpp;
         }
        theTask.ShoriStatus__c = 'Completed'; Update theTask; return;
    }

    private String emptyIfNull(String pValue){ return pValue == null ? '' : pValue; }
}