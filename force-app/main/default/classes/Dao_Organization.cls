public class Dao_Organization {

  static public Organization getOrganization(){
    return [
        select
          Id,
          IsSandbox
        from
          Organization
        ];
  }
}