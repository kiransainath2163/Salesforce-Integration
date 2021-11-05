/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-13-2021
 * @last modified by  : kiransainath@apisero.com
 **/
@RestResource(urlMapping='/v1/Account/*')
global with sharing class AccountManager {
    @HttpGET
    global static AccountWrapper accountInformation() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substringAfterLast('/');
        Account acc = [
            SELECT
                Name,
                Industry,
                Rating,
                Phone,
                Fax,
                Description,
                (SELECT Id, FirstName, LastName, Email, Phone FROM Contacts),
                (SELECT Id, CaseNumber, Subject, Description, Status FROM Cases)
            FROM Account
            WHERE Id = :accountId
        ];
        return new AccountWrapper(acc, acc.Contacts, acc.Cases);
    }

    @HttpPOST
    global static AccountWrapper1 postAccount(AccountWrapper1 accWrapper) {
        /*Account acc = new Account(
            Name=accName, 
            AccountNumber=accNumber, 
            Description=description, 
            Industry=industry);
        insert acc;
        return acc;*/

        try {
            Account acc = accWrapper.accountRecord;
            insert acc;
            Contact con = accWrapper.contactRecord;
            con.AccountId = acc.Id;
            insert con;
            return accWrapper;
        } catch (Exception ex) {
            AccountWrapper1 accWrapperObj = new AccountWrapper1();
            accWrapperObj.exceptionMessage = ex.getMessage();
            return accWrapperObj;
        }
    }

    global class AccountWrapper1 {
        Account accountRecord;
        Contact contactRecord;
        String exceptionMessage;
    }

    @HttpDELETE
    global static String deleteAcount() {
        try {
            RestRequest request = RestContext.request;
            String accId = request.requestURI.substringAfterLast('/');
            if (accId != null) {
                List<Account> acc = [SELECT Id FROM Account WHERE Id = :accId];
                if (acc != null && acc.size() > 0) {
                    delete acc;
                    return '{ "Message" : "Account record deleted successfully!" }';
                } else {
                    return '{ "Message" : "Could not find the record in Salesforce Org!" }';
                }
            } else {
                return '{ "Message" : "Could not extract Id from URL!" }';
            }
        } catch (Exception ex) {
            return '{ Message : ' + ex.getMessage() + '}';
        }
    }

    global class AccountWrapper {
        public Account accountList;
        public List<Contact> contactList;
        public List<Case> caseList;
        public AccountWrapper(
            Account acc,
            List<Contact> contacts,
            List<Case> cases
        ) {
            this.accountList = acc;
            this.contactList = contacts;
            this.caseList = cases;
        }
    }
}
