public class EitaiKuyoTaioAreas {

    public static ITaioKanoAreaHantei get_ITaioKanoAreaHantei_instance(){
        return new TaioKanoAreaHantei();
    }

    public interface ITaioKanoAreaHantei {
        Boolean is_available_state(String p_state);
    }

    public class TaioKanoAreaHantei implements ITaioKanoAreaHantei{
        public Boolean is_available_state(String p_state){
            return this.taio_kano_states.contains(p_state);
        }

        private Set<String> taio_kano_states = new Set<String>{
            '東京都', '栃木県', '埼玉県', '千葉県',
            '新潟県', '山梨県',
            '愛知県', '岐阜県',
            '三重県', '奈良県', '大阪府', '京都府', '兵庫県',
            '岩手県', '北海道', '広島県', '福岡県'
        };
    }
}