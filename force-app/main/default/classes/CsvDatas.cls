public class CsvDatas {

    public class DataSet{
        private List<Row> m_rows = new List<Row>();

        public DataSet(){}
        public DataSet(List<Row> p_rows){
            this.add_rows(p_rows);
        }
        public DataSet add_rows( List<Row> p_rows){
            this.m_rows.addAll(p_rows);
            return this;
        }
        public String get_csv_encoded(){
            List<String> the_row_encoded = new List<String>();
            for(Row a_row : this.m_rows){
                the_row_encoded.add( a_row.get_csv_encoded() );
            }
            return String.join(the_row_encoded, '\n');
        }
    }
    public class Row{
        public Row(){}
        public Row(List<String> p_values){
            this.set_values(p_values);
        }
        private List<String> m_values = new List<String>();
        public Row set_values(List<String> p_values){
            this.m_values = p_values;
            return this;
        }
        public String get_csv_encoded(){
            List<String> the_values_encoded = new List<String>();
            for(String a_value : this.m_values){
                String a_value_encoded = String.isBlank(a_value) ? '' : a_value;
                a_value_encoded = a_value_encoded.replace('"', '""');
                a_value_encoded = '"' + a_value_encoded + '"';
                the_values_encoded.add(a_value_encoded);
            }
            return String.join(the_values_encoded, ',');
        }
    }
}