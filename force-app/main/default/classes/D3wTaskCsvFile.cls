public class D3wTaskCsvFile {

    public static IFiler get_IFiler_instance(){
        return new Filer();
    }

    private static String m_d3worker_csv_file_title = 'd3w_work_data';

    public interface IFiler {
        void set_csv_data(String p_task_id, String p_csv_data);
        String get_csv_data(String p_task_id);
    }
    public class Filer implements IFiler{
        public void set_csv_data(String p_task_id, String p_csv_data){

            ContentVersion a_ContentVersion = new ContentVersion(
                ContentLocation = 'S',
                Title = m_d3worker_csv_file_title,
                PathOnClient = 'd3w_work_data.csv',
                VersionData = Blob.valueOf(p_csv_data)
            );
            INSERT a_ContentVersion;

            String a_ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE id = :a_ContentVersion.Id].get(0).ContentDocumentId;

            INSERT new ContentDocumentLink(
                ContentDocumentId = a_ContentDocumentId,
                ShareType = 'I',
                Visibility = 'AllUsers',
                LinkedEntityId = p_task_id
            );
        }
        public String get_csv_data(String p_task_id){

            Set<String> the_document_ids = new Set<String>();
            for(ContentDocumentLink a_ContentDocumentLink : [
                SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :p_task_id
            ])
            {
                the_document_ids.add(a_ContentDocumentLink.ContentDocumentId);
            }

            ContentVersion a_ContentVersion = (ContentVersion)SobjectsExtension.firstOrNull(
                [
                    SELECT Id, VersionData FROM ContentVersion 
                    WHERE ContentDocumentId IN :the_document_ids
                    AND Title = :m_d3worker_csv_file_title
                    AND IsLatest=True
                    ORDER BY CreatedDate DESC
                    LIMIT 1
                ]
            );

            if(a_ContentVersion == null){ return null; }
            String a_data = a_ContentVersion.VersionData.toString();
            
            String BOM = '\uFEFF';
            if( a_data.startsWith(BOM) ){ a_data = a_data.substring(1);}

            return a_data;
        }
    }
}