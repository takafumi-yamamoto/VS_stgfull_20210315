public class SogiTokuyakutenTesuryoCalc {

    public static ITesuryoCalculator get_ITesuryoCalculator_incetance(){
        return new TesuryoCalculator();
    }

    public interface ITesuryoCalculator {
        Decimal get_tokuyakuten_tesuryo (String oppId);
    }

    public class TesuryoCalculator implements ITesuryoCalculator {
        public Decimal get_tokuyakuten_tesuryo (String oppId){
            Opportunity a_opp = [
                SELECT KakuteibiSyodan__c,SimpleYasugoRef__r.TokuyakutenKeiyakuRef__c,
                (
                    SELECT Id,Product2.k_ShohinCategory_Id_exp__c
                    FROM OpportunityLineItems 
                    WHERE Product2.k_ShohinSyubetsu_Id_exp__c = '1' 
                    AND Product2.k_Service_Id_exp__c in ('1','2')
                    LIMIT 1
                ) 
                FROM Opportunity 
                WHERE Id =:oppId 
                LIMIT 1
            ];
            if(a_opp.SimpleYasugoRef__r.TokuyakutenKeiyakuRef__c == null){
                return 0;
            }
            SogiShaTokuyakutenTesuryo__c a_SogiShaTokuyakutenTesuryo = (SogiShaTokuyakutenTesuryo__c)SobjectsExtension.firstOrNull([
                SELECT Ichinichiso__c,Ippanso__c,Kazokuso__c,Kasoshiki__c,Chokuso__c
                FROM SogiShaTokuyakutenTesuryo__c
                WHERE KeiyakuRef__c = :a_opp.SimpleYasugoRef__r.TokuyakutenKeiyakuRef__c
                AND Tekiyokaishi__c <= :a_opp.KakuteibiSyodan__c.date()
                ORDER BY Tekiyokaishi__c DESC
                ]);
            if(a_SogiShaTokuyakutenTesuryo == null){
                return 0;
            }
            Decimal tokuyakuten_tesuryo = 0;
            for(OpportunityLineItem oppLineItem : a_opp.OpportunityLineItems){
                if(oppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'chokusou'){
                    tokuyakuten_tesuryo = a_SogiShaTokuyakutenTesuryo.Chokuso__c;
                }
                if(oppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'kasou'){
                    tokuyakuten_tesuryo = a_SogiShaTokuyakutenTesuryo.Kasoshiki__c;
                }
                if(oppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'kazokusou'){
                    tokuyakuten_tesuryo = a_SogiShaTokuyakutenTesuryo.Kazokuso__c;
                }
                if(oppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yasugou-kazoku'){
                    tokuyakuten_tesuryo = a_SogiShaTokuyakutenTesuryo.Kazokuso__c;
                }
                if(oppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'ichinichi'){
                    tokuyakuten_tesuryo = a_SogiShaTokuyakutenTesuryo.Ichinichiso__c;
                }
                if(oppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'yasugou-ichinichi'){
                    tokuyakuten_tesuryo = a_SogiShaTokuyakutenTesuryo.Ichinichiso__c;
                }
                if(oppLineItem.Product2.k_ShohinCategory_Id_exp__c == 'ippansou'){
                    tokuyakuten_tesuryo = a_SogiShaTokuyakutenTesuryo.Ippanso__c;
                }
            }
            if(tokuyakuten_tesuryo == null){
                tokuyakuten_tesuryo = 0;
            }
            return tokuyakuten_tesuryo;
        }
    }
}