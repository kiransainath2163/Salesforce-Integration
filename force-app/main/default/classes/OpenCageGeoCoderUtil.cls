/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-14-2021
 * @last modified by  : kiransainath@apisero.com
 **/
global with sharing class OpenCageGeoCoderUtil {
    public static void forwardGeoCoding(Id recordId) {
        String endPoint = System.Label.OpenCageEndpoint;
        String apiKey = System.label.OpenCageKey;
        String errorMessage;
        String finalEndpoint =
            endPoint +
            '?key=' +
            apiKey +
            '&q=kukatpally&pretty=1';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //https://api.opencagedata.com/geocode/v1/json?key=e29574b63d92458a9ec25975a2021011&q=51.952659%2C+7.632473&pretty=1&no_annotations=1
        try {
            Account acc = [
                SELECT
                    Id,
                    Location__latitude__s,
                    Location__longitude__s,
                    ShippingStreet,
                    ShippingState,
                    ShippingPostalCode,
                    ShippingCity,
                    ShippingCountry
                FROM Account
                WHERE Id = :recordId
            ];
            if (acc != null) {
                String Address =
                    acc.ShippingStreet +
                    ',' +
                    acc.ShippingCity +
                    ',' +
                    acc.ShippingState +
                    ',' +
                    acc.ShippingPostalCode +
                    ',' +
                    acc.ShippingCountry;
                String encodedAddress = EncodingUtil.urlEncode(
                    Address,
                    'UTF-8'
                );
                finalEndpoint =
                    endPoint +
                    '?key=' +
                    apiKey +
                    '&q=' +
                    encodedAddress +
                    '&pretty=1&limit=1';
            }
            request.setMethod('GET');
            request.setEndpoint(finalEndpoint);
            //request.setHeader('Content-Type', 'application/json');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String body = response.getBody();
                System.debug('Body = ' + body);
                OpenCageWrapper wrapper = (OpenCageWrapper) JSON.deserialize(
                    body,
                    OpenCageWrapper.class
                );
                List<OpenCageWrapper.cls_results> results = wrapper.results;
                System.debug('Body Class =' + results);
                if (results != null && results.size() > 0 && acc != null) {
                    acc.Location__Latitude__s = results[0].geometry.lat;
                    acc.Location__Longitude__s = results[0].geometry.lng;
                    update acc;
                }
            } else {
                errorMessage =
                    'Unexpected error occured while connecting to OpenCage Data API with status as ' +
                    response.getStatus() +
                    ' and status code as ' +
                    response.getStatusCode();
                System.debug(errorMessage);
            }
        } catch (Exception ex) {
            errorMessage =
                'Unexpected error occured while connecting to OpenCage Data API with status as ' +
                ex.getMessage();
            System.debug(errorMessage);
        }
    }

    @future(callout=true)
    public static void reverseGeoCoding(Decimal Latitude, Decimal Longitude) {
        String errorMessage;
        try {
            String apiEndpoint = System.Label.OpenCageEndpoint;
            String apiKey = System.Label.OpenCageKey;
            String finalEndpoint;

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            Account acc = [
                SELECT
                    Id,
                    Address__c,
                    ShippingStreet,
                    ShippingState,
                    ShippingCity,
                    ShippingPostalCode,
                    ShippingCountry
                FROM Account
                WHERE Id = '0015j000007YATvAAO'
            ];
            request.setMethod('GET');
            finalEndpoint =
                apiEndpoint +
                '?key=' +
                apiKey +
                '&q=' +
                Latitude +
                ',' +
                Longitude +
                '+&pretty=1';
            request.setEndpoint(finalEndpoint);
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                String body = response.getBody();
                ReverseGeoCoding reverseGeoCoding = (ReverseGeoCoding) JSON.deserialize(
                    body,
                    ReverseGeoCoding.class
                );
                List<ReverseGeoCoding.cls_results> results = reverseGeoCoding.results;
                if (results != null && results.size() > 0 && acc != null) {
                    acc.ShippingStreet = results[0].components.road;
                    acc.ShippingState = results[0].components.state;
                    acc.ShippingCity = results[0].components.city;
                    acc.ShippingPostalCode = results[0].components.postcode;
                    acc.ShippingState = results[0].components.state;
                    acc.Address__c = results[0].formatted;
                    update acc;
                }
            }
        } catch (Exception ex) {
            errorMessage =
                'Unexpected error occured while connecting to OpenCage Data API with status as ' +
                ex.getMessage();
            System.debug(errorMessage);
        }
    }
}
