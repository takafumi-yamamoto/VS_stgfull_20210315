public class MteianJizenBackImgs {
    private static MteianJizenBackImgs__mdt f_cachedData = null;
    
    private static MteianJizenBackImgs__mdt loadConfig(){
        if(f_cachedData != null) return f_cachedData;
        
        String developerlName = Environments.isSandbox() ? 'dev' : 'prod';
        
        f_cachedData = 
            [
                select id,
                JizenImg0d__c,JizenImg1y__c,
                JizenImg2y__c,JizenImg30d__c
                from MteianJizenBackImgs__mdt
                where DeveloperName = :developerlName
                Limit 1
            ]
            .get(0);
        return f_cachedData;
    }
    
    public static MteianJizenBackImgs__mdt getConfig(){
        loadConfig();
        return f_cachedData;
    }

}