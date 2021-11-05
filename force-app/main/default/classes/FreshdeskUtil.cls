/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 11-04-2021
 * @last modified by  : kiransainath@apisero.com
 **/
public with sharing class FreshdeskUtil {
    public static final String TICKET_ENDPOINT = '/api/v2/tickets';
    public static final String CONTACT_ENDPOINT = '/api/v2/contacts';

    public static void createContact(
        String name,
        String email,
        String phone,
        String mobile
    ) {
        String errorMessage;
        String endPoint = 'callout:Freshdesk';
        String contactEndpoint = endPoint + CONTACT_ENDPOINT;
        String cred = System.Label.Freshdesk_credentials;
        String requestBody =
            '{ "name":"' +
            name +
            '", "email":"' +
            email +
            '", "phone": "' +
            phone +
            '", "mobile" : "' +
            mobile +
            '"}';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(contactEndpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        request.setBody(requestBody);
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 201) {
                String responseBody = response.getBody();

                System.debug('Response from server' + responseBody);
            } else {
                System.debug(
                    'failed in creating a contact ' +
                    response.getStatus() +
                    ' Status ' +
                    response.getStatusCode()
                );
            }
        } catch (Exception ex) {
            System.debug(
                'Error while connecting to API Endpoint, Error Message:' +
                ex.getMessage()
            );
        }
    }

    public static void viewAllContacts() {
        String errorMessage;
        String endPoint = 'callout:Freshdesk';
        String contactEndpoint = endPoint + CONTACT_ENDPOINT;
        String cred = System.Label.Freshdesk_credentials;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        // request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        request.setEndpoint(contactEndpoint);
        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String body = response.getBody();
                List<FreshdeskViewContactsWrapper> contacts = (List<FreshdeskViewContactsWrapper>) JSON.deserialize(
                    body,
                    List<FreshdeskViewContactsWrapper>.class
                );
                System.debug('Contacts: ' + contacts);
                System.debug('Respon    se Body: ' + response.getBody());
            } else {
                System.debug(
                    'Error message with code: ' +
                    response.getStatusCode() +
                    ' and Status as: ' +
                    response.getStatus()
                );
            }
        } catch (Exception ex) {
            System.debug(
                'Error occured while connecting to Freshdesk API with error message:' +
                ex.getMessage()
            );
        }
    }

    @future(callout=true)
    public static void createTicket(
        String description,
        String subject,
        String email,
        Decimal priority,
        Decimal status,
        String recordId
    ) {
        String cred = System.Label.Freshdesk_credentials;
        String finalEndpoint = 'callout:Freshdesk' + TICKET_ENDPOINT;
        String body =
            '{ "description": "' +
            description +
            '", "subject": "' +
            subject +
            '", "email": "' +
            email +
            '", "priority": ' +
            Integer.valueOf(priority) +
            ', "status": ' +
            Integer.valueOf(status) +
            '}';
        System.debug('body' + body);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(finalEndpoint);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(cred)));
        request.setBody(body);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 201) {
            String responseBody = response.getBody();
            FreshDeskCreateTicketWrapper responseWrapper = (FreshDeskCreateTicketWrapper) JSON.deserialize(
                responseBody,
                FreshDeskCreateTicketWrapper.class
            );
            Contact con = [
                SELECT Id, fr_Id__c
                FROM Contact
                WHERE Id = :recordId
            ];
            if (con != null) {
                con.fr_Id__c = String.valueOf(responseWrapper.id);
                update con;
            }
        } else {
            throw new InvalidDataException(
                'Returned with Status Code' +
                response.getStatusCode() +
                ' and status as ' +
                response.getStatus()
            );
        }
    }

    @AuraEnabled
    public static String createFreshTicketLWC(Map<String, String> payLoadMap) {
        try {
            if (!payLoadMap.containsKey('recordId')) {
                throw new InvalidDataException('Contact record Id is missing!');
            }
            if (!payLoadMap.containsKey('ticket')) {
                throw new InvalidDataException('FreshDesk Wrapper is missing!');
            }
            FreshDeskTicketWrapperLWC ticketWrapper = (FreshDeskTicketWrapperLWC) JSON.deserialize(
                payLoadMap.get('ticket'),
                FreshDeskTicketWrapperLWC.class
            );
            fr_Ticket__c ticket = ticketWrapper.getObject();
            insert ticket;
            ticketWrapper.setId(ticket.Id);
            createTicket(
                ticket.description__c,
                ticket.Subject__c,
                ticket.email__c,
                ticket.Priority__c,
                ticket.Status__c,
                payLoadMap.get('recordId')
            );
            return JSON.serialize(ticketWrapper);
        } catch (Exception ex) {
            Map<String, String> mp = new Map<String, String>();
            mp.put('Error', ex.getMessage());
            return JSON.serialize(mp);
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getFreshDeskInitWrapper() {
        FreshDeskTicketWrapperLWC objList = new FreshDeskTicketWrapperLWC();
        return JSON.serialize(objList);
    }

    public class FreshDeskTicketWrapperLWC {
        @AuraEnabled
        public String Email { get; set; }
        @AuraEnabled
        public String Subject { get; set; }
        @AuraEnabled
        public Integer Priority { get; set; }
        @AuraEnabled
        public Integer Status { get; set; }
        @AuraEnabled
        public String Description { get; set; }
        @AuraEnabled
        public String Id { get; set; }

        public FreshDeskTicketWrapperLWC() {
        }

        public FreshDeskTicketWrapperLWC(
            String email,
            String subject,
            Integer priority,
            Integer status,
            String description
        ) {
            this.Email = email;
            this.Subject = subject;
            this.Priority = priority;
            this.Status = status;
            this.Description = description;
        }

        public fr_Ticket__c getObject() {
            fr_Ticket__c ticket = new fr_Ticket__c();
            ticket.email__c = this.Email;
            ticket.Subject__c = this.Subject;
            ticket.Priority__c = this.Priority;
            ticket.Status__c = this.Status;
            ticket.description__c = this.Description;
            return ticket;
        }

        public void setId(String ticketId) {
            this.Id = ticketId;
        }
    }

    public class InvalidDataException extends Exception {
    }
}
