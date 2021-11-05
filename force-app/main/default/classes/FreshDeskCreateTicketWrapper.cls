/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-19-2021
 * @last modified by  : kiransainath@apisero.com
 **/
public class FreshDeskCreateTicketWrapper {
    public List<String> reply_cc_emails;
    public Object email_config_id;
    public Object group_id;
    public Integer priority;
    public Long requester_id;
    public Object responder_id;
    public Integer source;
    public Integer status;
    public String subject;
    public Integer company_id;
    public Integer id;
    public String type;
    public Object to_emails;
    public Object product_id;
    public Boolean fr_escalated;
    public Boolean spam;
    public Boolean urgent;
    public Boolean is_escalated;
    public String created_at;
    public String updated_at;
    public String due_by;
    public String fr_due_by;
    public String description_text;
    public String description;

    public static FreshDeskCreateTicketWrapper parse(String json) {
        return (FreshDeskCreateTicketWrapper) System.JSON.deserialize(
            json,
            FreshDeskCreateTicketWrapper.class
        );
    }
}
