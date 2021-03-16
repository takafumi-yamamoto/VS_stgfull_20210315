public class OpFcPwd {

    public String genPassword() {
        Integer yoriso_security_policy_password_lenght = 12;
        return this.getRandomString(yoriso_security_policy_password_lenght);
    }

    private string getRandomString(Integer LengthRequired){
        String CharList = 'abcdefghkmnpqrstuvwxyzABCDEFGHJKLMNPRSTUVWXYZ';
        String numList = '12345678';
        String kigouList = '!#$%*/<=>?@_';
        String Res = '';
        integer position;
        integer positionkigou;
        integer positionNum;
        List<integer> randomList = this.getuniquerandomNumber(2,LengthRequired);
        Integer addkigouIndexkigou = randomList.get(0);
        Integer addkigouIndexNum = randomList.get(1);
        for(Integer i = 0; i < LengthRequired; i++) {
            position = Integer.valueof(String.valueof(Math.roundToLong(CharList.length()*Math.random()))) -1;
            positionkigou = Integer.valueof(String.valueof(Math.roundToLong(kigouList.length()*Math.random()))) -1;
            positionNum = Integer.valueof(String.valueof(Math.roundToLong(numList.length()*Math.random()))) -1;
            if(position < 0){
                position = 0;
            }
            if(positionkigou < 0){
                positionkigou = 0;
            }
            if(positionNum < 0){
                positionNum = 0;
            }
            if(i == addkigouIndexkigou){
                Res = Res + kigouList.substring(positionkigou,positionkigou+1);
            }else if(i == addkigouIndexNum){
                Res = Res + numList.substring(positionNum,positionNum+1);
            }else{
                Res = Res + CharList.substring(position,position+1);
            }
        }
        return Res;
    }

    private List<integer> getuniquerandomNumber (integer listsize,integer upperLimit ) {
        List<integer> intlist = new List<integer>();

        Map<integer, integer> randMap = new Map<integer, integer>();
        integer count = 0;
        while (true) {
            Integer randNum = Math.round(Math.random()*1000);
            Integer romdomNum = Math.mod(randNum, upperLimit-1);
            randMap.put(romdomNum,romdomNum);
            if(randMap.size() == listsize){
                break;
            }
            if(count == 100){
                break;
            }
            count++;
        }
        for(integer randkey : randMap.keySet()){
            intlist.add(randkey);
        }
        return intlist;
    }
}