public class ObIrHkShoryu {

    public Enum Kubuns{
        Normal,
        KyuTehaiDaiko,
        Terapass,
        SogiTenkan
    }
    public interface IProvider{
        ObIrHkShoryu.Kubuns getKubun(String pRyunyumotoService);
    }
    public class Provider implements IProvider{
        public ObIrHkShoryu.Kubuns getKubun(String pRyunyumotoService){

            if(
                new List<String>{
                    '僧侶手配代行','僧侶手配代行-リピート','僧侶手配代行-リピート(3回目)','僧侶手配代行-リピート(4回目)'
                }.contains(pRyunyumotoService)
            ){
                return ObIrHkShoryu.Kubuns.KyuTehaiDaiko;
            }

            if(
                new List<String>{
                    '定額僧侶手配代行'
                }.contains(pRyunyumotoService)
            ){
                return ObIrHkShoryu.Kubuns.Terapass;
            }

            if(
                new List<String>{ 'シンプルなお葬式','葬儀レビ' }.contains(pRyunyumotoService)
            ){
                return ObIrHkShoryu.Kubuns.SogiTenkan;
            }

            return ObIrHkShoryu.Kubuns.Normal;
        }
    }
}