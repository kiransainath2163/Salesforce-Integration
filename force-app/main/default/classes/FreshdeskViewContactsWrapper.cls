/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-18-2021
 * @last modified by  : kiransainath@apisero.com
 **/
public class FreshdeskViewContactsWrapper {
    public boolean active;
    public String address; //
    public String company_id; //
    public String description; //
    public String email; //rachel@freshdesk.com
    public String id; //2
    public String job_title; //
    public String language; //en
    public String mobile; //
    public String name; //Rachel
    public String phone; //
    public String time_zone; //Chennai
    public String twitter_id; //
    public String created_at; //2015-08-18T16:18:14Z
    public String updated_at; //2015-08-24T09:25:19Z
    public cls_custom_fields custom_fields;
    class cls_custom_fields {
        public String department; //Admin
        public String fb_profile; //
        public boolean permanent;
    }
    public static FreshdeskViewContactsWrapper parse(String json) {
        return (FreshdeskViewContactsWrapper) System.JSON.deserialize(
            json,
            FreshdeskViewContactsWrapper.class
        );
    }
}
