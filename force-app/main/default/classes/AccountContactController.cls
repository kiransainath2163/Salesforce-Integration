/**
 * @description       : 
 * @author            : kiransainath@apisero.com
 * @group             : 
 * @last modified on  : 11-09-2021
 * @last modified by  : kiransainath@apisero.com
**/
public class AccountContactController{
      
    @AuraEnabled(cacheable=true)
    public static List<AccountContactListWrapper> getAllAccountWithContacts(){
        List<AccountContactListWrapper> accWrapperList = new List<AccountContactListWrapper>();
        List<Account> accList = [SELECT Id, Name, BillingState, Website, Phone,
                                    (SELECT Id, FirstName, LastName, Name, Email From Contacts)
                                    FROM Account LIMIT 5];
        if(!accList.isEmpty()){
            for(Account acc : accList){
                AccountContactListWrapper accWrapper = new AccountContactListWrapper();
                accWrapper.accRecord = acc;
                accWrapper.contactList = acc.Contacts;
                accWrapper.contactCount = acc.Contacts.size();
                accWrapperList.add(accWrapper);
            }
        }
        return accWrapperList;
    }

    @AuraEnabled
    public static String getAccountWithContacts(String accountId){
        AccountContactListWrapper accWrapper = new AccountContactListWrapper();
        List<Account> accList = [SELECT Id, Name, BillingState, Website, Phone,
                                    (SELECT Id, FirstName, LastName, Email From Contacts)
                                    FROM Account WHERE Id =: accountId];
        // if(!accList.isEmpty()){
        //     accWrapper.accRecord = accList[0];
        //     accWrapper.contactList = accList[0].Contacts;
        //     accWrapper.contactCount = accList[0].Contacts.size();
        // }
        return JSON.serialize(accWrapper);
        
    }
      
    // wrapper class with @AuraEnabled and {get;set;} properties 
    public class AccountContactListWrapper{
        @AuraEnabled
        public Account accRecord{get;set;}
        @AuraEnabled
        public List<Contact> contactList{get;set;}
        @AuraEnabled
        public Integer contactCount{get;set;}
    }
}