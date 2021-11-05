/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-18-2021
 * @last modified by  : kiransainath@apisero.com
 **/
@IsTest
public with sharing class FreshdeskViewContactsWrapperTest {
    static testMethod void testParse() {
        String json =
            '{' +
            '    "active":false,' +
            '    "address":"",' +
            '    "company_id":"",' +
            '    "description":"",' +
            '    "email":"rachel@freshdesk.com",' +
            '    "id":2,' +
            '    "job_title":"",' +
            '    "language":"en",' +
            '    "mobile":"",' +
            '    "name":"Rachel",' +
            '    "phone":"",' +
            '    "time_zone":"Chennai",' +
            '    "twitter_id":"",' +
            '    "created_at":"2015-08-18T16:18:14Z",' +
            '    "updated_at":"2015-08-24T09:25:19Z",' +
            '    "other_companies": [' +
            '        4,' +
            '        9,' +
            '        10' +
            '    ],' +
            '    "custom_fields":{' +
            '      "department": "Admin",' +
            '      "fb_profile": "",' +
            '      "permanent": true' +
            '    }' +
            '}';
        FreshdeskViewContactsWrapper obj = (FreshdeskViewContactsWrapper) System.JSON.deserialize(
            json,
            FreshdeskViewContactsWrapper.class
        );
        System.assert(obj != null);
    }
}
