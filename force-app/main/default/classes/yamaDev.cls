public class yamaDev {

    public void testYama(){
        
        Map<String, WrTkCtxs.ContextData> test = new WrTkCtxs().selectContextDataByOppIds(new List<String>{'0061s000004goeXAAQ'});
        System.debug('test:' + test);

        Map<String, WrTkCtxs.ContextData> theOppIdToWaribikiContext = new WrTkCtxs().selectContextDataByOppIds(new List<String>{'0061s000004goeXAAQ'});

        WrTkCtxs.ContextData theWaribkiContext = theOppIdToWaribikiContext.get( '0061s000004goeXAAQ' );
        Set<String> theWaribikiShohinBangos = new WrTks().getWaribikiShohinBangos(theWaribkiContext, 'SBG-0005011');

        System.debug('theWaribikiShohinBangos:' + theWaribikiShohinBangos);
        
    }
}