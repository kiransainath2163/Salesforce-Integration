/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-14-2021
 * @last modified by  : kiransainath@apisero.com
 **/
@IsTest
public with sharing class ReverseGeoCodingTest {
    static testMethod void testParse() {
        String json =
            '{' +
            '  "results": [' +
            '    {' +
            '      "components": {' +
            '        "city": "Hyderabad",' +
            '        "continent": "Asia",' +
            '        "country": "India",' +
            '        "country_code": "in",' +
            '        "county": "Kukatpally mandal",' +
            '        "neighbourhood": "Vasanth Nagar",' +
            '        "postcode": "500085",' +
            '        "road": "unnamed road",' +
            '        "road_type": "residential",' +
            '        "state": "Telangana",' +
            '        "state_code": "TG",' +
            '        "state_district": "Medchal–Malkajgiri",' +
            '        "suburb": "Ward 114 KPHB Colony"' +
            '      },' +
            '      "confidence": 9,' +
            '      "formatted": "unnamed road, Ward 114 KPHB Colony, Hyderabad - 500085, Telangana, India",' +
            '      "geometry": {' +
            '        "lat": 17.49517,' +
            '        "lng": 78.3886437' +
            '      }' +
            '    }' +
            '  ],' +
            '  "status": {' +
            '    "code": 200,' +
            '    "message": "OK"' +
            '  }' +
            '}';
        ReverseGeoCoding obj = (ReverseGeoCoding) System.JSON.deserialize(
            json,
            ReverseGeoCoding.class
        );
        System.assert(obj != null);
    }
}
