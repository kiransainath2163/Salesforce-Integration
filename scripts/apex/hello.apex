// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

OpenCageGeoCoderUtil.forwardGeoCoding('0015j000007YATvAAO');
OpenCageGeoCoderUtil.reverseGeoCoding(17.495156, 78.388713);

FreshdeskUtil.createContact('Kiran Sainath Bandarlanka', 'bandarlanka_sainath@temp1.com', '7032256755', '7989147059');
FreshdeskUtil.viewAllContacts();
FreshdeskUtil.getFreshDeskInitWrapper();
System.debug(System.Label.Freshdesk_Endpoint);
System.debug(FreshdeskUtil.getFreshDeskInitWrapper());


Map<String, String> mp = new Map<String, String>();
mp.put('token_url__c', 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer');
mp.put('Client_Id__c', 'AB2klERLZni14hUOEIGxoqhp6NmFovMtuSESy5y5gKu3Kjd5v4');
mp.put('Client_Secret__c', 'U6FMyXhyem5xRGA3NPgj7PpBzfxgocBWKlwyt2iC');
mp.put('AuthorizationCode__c', 'AB11635266011ocsnB6K6whCNxECskosgG1cWuWNxYQxwzAKDZ');
mp.put('RedirectURI__c', 'https://udemyintegration-developer-edition.ap27.force.com/s');
String js = JSON.serialize(mp);
QuickbooksUtil.getAccessToken(js);

Map<String, String> mp = new Map<String, String>();
mp.put('token_url__c', 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer');
mp.put('Client_Id__c', 'AB2klERLZni14hUOEIGxoqhp6NmFovMtuSESy5y5gKu3Kjd5v4');
mp.put('Client_Secret__c', 'U6FMyXhyem5xRGA3NPgj7PpBzfxgocBWKlwyt2iC');
mp.put('refresh_token__c', 'AB11643993538dAb5KIPOKT0xlCwXLFQuZozVToOc3lKMRG1oS');
mp.put('RedirectURI__c', 'https://udemyintegration-developer-edition.ap27.force.com/s');
String js = JSON.serialize(mp);
QuickbooksUtil.getRefreshAccessToken(js);
 where Name='SAmple'

Account acc = [select Id, name from Account where Name='Sample' limit 1].get(0);
Account acc = [select Id, name from Account where Name='Sample' limit 1];
System.debug('Acc: '+acc);
if(acc != null ){
    System.debug('Not Null'+acc);
}else{
    System.debug('Null'+acc);
}

Account ac = new Account();
if(ac != null ){
    System.debug('Not Null'+ac); 
}else{
    System.debug('Null'+ac);
}

Account, contact, lead, case

// Account acc = null;
Account acc = new Account();
acc.Phone = '9898989';
insert acc;

List<Contact>
String str = 'str'

List<Account> ac1 = [select Name from Account where Name='Sample'];
if(ac1 != null && ac1.size()>0){
    System.debug(ac1[0].Name);
}
System.debug([select Name from Account where Name='Sample']?.Name);

Account[] ac1 = [select Name from Account];

String[] str = new List<String>();
str.add('😊');
str.add('😍');
str.add('🙌');
System.debug(str);


List<String> str = new List<String>();
str.add('One');
str.add('Two');
str.add('three');
System.debug(str);

x?.y






Account ac1 = [null];

List<sObject>
List<Account> accList = [select Name from Account limit 5];
System.debug(accList[0]);
Account acc = List<>[0]
System.debug(acc.Name)


System.debug(ac1);
ac1.Phone='9898989';
update ac1;
System.debug(ac1);




let a = {}
a.temp = 'New'
console.log(a)
// , Fields(ALL)
List<Account> ac1 = [select Name from Account where name='Kishore'];
if(ac1 != null && ac1.size() > 0){
    System.debug('Not null: '+ac1);
}else{
    System.debug('Null: '+ac1);
}

List<Account> ac1 = [select Name from Account limit 2];

Final sObject s1;
s1 = new Account();
s1 = new Contact();
System.debug(s1);

Final String s1;
s1='one';
s1 = 'twowq';
System.debug(s1);

Integer int1 = Dec.valueOf('123');
System.debug(int1);


FreshdeskUtil.viewAllContacts();