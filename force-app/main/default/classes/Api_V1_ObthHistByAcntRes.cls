public class Api_V1_ObthHistByAcntRes {
	
	public class Res{
		public Meta meta;
		public Response response;
	}
	public class Meta{
		public String response_status;
		public Error error;
	}
	public class Error{
		public String code;
		public String message;
	}
	public class Response{
		public Torihikisaki torihikisaki;
		public List<OboTehai> obotehais = new List<OboTehai>();
	}
	public class Torihikisaki{
		public String torihikisaki_bango;
		public String last_name;
		public String first_name;
		public String last_name_kana;
		public String first_name_kana;
		public String mobile_phone;
		public String email;
	}
	public class OboTehai{
		public String shodan_bango;
		public String oboplan_keitai;
		public OboPlanEvent oboplan_event;
		public KiboShuha kibo_shuha;
		public String service_date;
		public Taishosha taishosha;
		public Tehaisaki tehaisaki;
	}
	public class OboPlanEvent{ public String code; public String name; }
	public class KiboShuha{ public String code; public String name; }
	public class Taishosha{
		public String torihikisaki_bango;
		public String last_name;
		public String first_name;
		public String last_name_kana;
		public String first_name_kana;
		public String birth_date ;
		public String death_date;
		public String zokugara_by_sodansha;
	}
	public class Tehaisaki{
		public String tehaisaki_keiyaku_bango;
		public String sekosha_keiyaku_bango;
		public Boolean is_tasha_tehai;
		public Boolean is_active;
		public Sekosha sekosha;
		public Jiin jiin;
	}
	public class Sekosha{
		public String name;
	}
	public class Jiin{
		public String name;
		public String shushi;
		public String shuha;
	}

	public interface IOboTehaiValidator{
		Boolean isValid(OboTehai pOboTehai);
	}
	public class OboTehaiValidator implements IOboTehaiValidator{
		public Boolean isValid(OboTehai pOboTehai){
			if( String.isBlank(pOboTehai.shodan_bango) ) return false;
			if( String.isBlank(pOboTehai.oboplan_keitai) ) return false;
			if( pOboTehai.oboplan_event == null ) return false;
			if( pOboTehai.kibo_shuha == null ) return false;
			if( pOboTehai.service_date == null ) return false;
			if( pOboTehai.taishosha == null ) return false;
			if( pOboTehai.tehaisaki == null ) return false;
			if( pOboTehai.tehaisaki.sekosha == null ) return false;
			if( String.isBlank( pOboTehai.tehaisaki.sekosha.name ) ) return false;
			if( pOboTehai.tehaisaki.jiin == null ) return false;
			if( String.isBlank( pOboTehai.tehaisaki.jiin.name ) ) return false;
			if( String.isBlank( pOboTehai.tehaisaki.jiin.shushi ) ) return false;
			return true;
		}
	}

	public Enum ErrorCodes{
		invalid_request,
		account_not_found,
		unhandled_exception
	}
	public Enum ResponseStatuses{
		success,
		error
	}
}