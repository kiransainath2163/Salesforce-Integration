/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-14-2021
 * @last modified by  : kiransainath@apisero.com
 **/
@IsTest
public with sharing class OPenCageWrapperTest {
    static testMethod void testParse() {
        String jsonString =
            '{' +
            '   "results" : [' +
            '      {' +
            '         "components" : {' +
            '            "continent" : "North America",' +
            '            "country" : "United States of America",' +
            '            "country_code" : "us",' +
            '            "road" : "Hatch St",' +
            '            "state" : "Kansas",' +
            '            "state_code" : "KS",' +
            '            "town" : "Fort Leavenworth"' +
            '         },' +
            '         "confidence" : 4,' +
            '         "formatted" : "Hatch St, Fort Leavenworth, KS, United States of America",' +
            '         "geometry" : {' +
            '            "lat" : 39.341104,' +
            '            "lng" : -94.942517' +
            '         }' +
            '      },' +
            '      {' +
            '         "components" : {' +
            '            "continent" : "North America",' +
            '            "country" : "United States of America",' +
            '            "country_code" : "us",' +
            '            "county" : "Douglas County",' +
            '            "postcode" : "66045",' +
            '            "state" : "Kansas",' +
            '            "state_code" : "KS"' +
            '         },' +
            '         "confidence" : 8,' +
            '         "formatted" : "Douglas County, KS 66045, United States of America",' +
            '         "geometry" : {' +
            '            "lat" : 38.959,' +
            '            "lng" : -95.2499' +
            '         }' +
            '      }' +
            '   ],' +
            '   "status" : {' +
            '      "code" : 200,' +
            '      "message" : "OK"' +
            '   }' +
            '}';
        OpenCageWrapper obj = (OpenCageWrapper) JSON.deserialize(
            jsonString,
            OpenCageWrapper.class
        );
        System.assert(obj != null);
    }
}
