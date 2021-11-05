/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 11-04-2021
 * @last modified by  : kiransainath@apisero.com
 **/
public with sharing class QuickbooksUtil {
    @AuraEnabled(cacheable=true)
    public static String fetchAuthorizationParameters() {
        try {
            String quickBookRecordName = System.Label.QuickBookRecordLabel;
            qb_Metadata__mdt quickBookMetadata = [
                SELECT
                    access_token__c,
                    auth_url__c,
                    Client_Id__c,
                    Client_Secret__c,
                    Company_Info__c,
                    Create_Bill__c,
                    Create_Customer__c,
                    Create_Estimate__c,
                    Create_Invoice__c,
                    Create_Payment__c,
                    Create_Vendor__c,
                    Customer_Url__c,
                    Environment__c,
                    expires_in__c,
                    expires_in_time__c,
                    minorversion__c,
                    PageName__c,
                    Prod_Base_URL__c,
                    realmId__c,
                    refresh_token__c,
                    Sanbdox_Base_URL__c,
                    token_type__c,
                    token_url__c,
                    AuthorizationCode__c,
                    RedirectURI__c
                FROM qb_Metadata__mdt
                WHERE MasterLabel = :quickBookRecordName
            ];
            System.debug(quickBookMetadata);
            return JSON.serialize(quickBookMetadata);
        } catch (Exception ex) {
            Map<String, String> str = new Map<String, String>();
            str.put('Error', ex.getMessage());
            return JSON.serialize(str);
        }
    }

    @AuraEnabled(cacheable=true)
    public static String getAccessToken(String payLoadString) {
        try {
            Map<String, Object> payLoad = (Map<String, Object>) JSON.deserializeUntyped(
                payLoadString
            );
            String urlEndpoint = String.valueOf(payLoad.get('token_url__c'));
            String clientId = String.valueOf(payLoad.get('Client_Id__c'));
            String clientSecretId = String.valueOf(
                payLoad.get('Client_Secret__c')
            );
            String base64Format = EncodingUtil.base64Encode(
                Blob.valueOf(clientId + ':' + clientSecretId)
            );
            String body =
                'grant_type=authorization_code&code=' +
                payLoad.get('AuthorizationCode__c') +
                '&redirect_uri=' +
                payLoad.get('RedirectURI__c');
            System.debug(
                'AuthorizationCode :' + payLoad.get('AuthorizationCode__c')
            );
            System.debug('RedirectURI__c :' + payLoad.get('RedirectURI__c'));
            System.debug('urlEndpoint: ' + urlEndpoint);
            System.debug('clientId: ' + clientId);
            System.debug('clientSecretId: ' + clientSecretId);
            System.debug('base64Format: ' + base64Format);
            System.debug('body: ' + body);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setEndpoint(urlEndpoint);
            request.setHeader('Accept', 'application/json');
            request.setHeader('Authorization', 'Basic ' + base64Format);
            request.setHeader(
                'Content-Type',
                'application/x-www-form-urlencoded'
            );
            request.setBody(body);
            HttpResponse response = http.send(request);
            if (
                response.getStatusCode() == 201 ||
                response.getStatusCode() == 200
            ) {
                System.debug(response.getBody());
                createUpdateIntegrationMetadata(response.getBody());
                return response.getBody();
            } else {
                System.debug('Error: ' + response.getStatus());
                return 'Error: ' + response.getStatus();
            }
        } catch (Exception ex) {
            return '{ "Error":"' + ex + '"}';
        }
    }

    public static void createUpdateIntegrationMetadata(String body) {
        TokenParameters tokenParameters = (TokenParameters) System.JSON.deserialize(
            body,
            TokenParameters.class
        );
        Map<String, Object> tokenMap = new Map<String, Object>();
        System.debug('Success');
        System.debug('response: ' + body);
        tokenMap.put('access_token__c', tokenParameters.access_token);
        tokenMap.put('refresh_token__c', tokenParameters.refresh_token);
        tokenMap.put('token_type__c', tokenParameters.token_type);
        tokenMap.put('expires_in__c', (Object) tokenParameters.expires_in);
        tokenMap.put(
            'expires_in_time__c',
            System.now().addSeconds(tokenParameters.expires_in)
        );
        CreateUpdateMetadataUtils.createUpdateMetadata(
            'qb_Metadata.QuickBooks',
            'QuickBooks',
            tokenMap
        );
    }

    @AuraEnabled
    public static String getRefreshAccessToken(String payLoadString) {
        Map<String, Object> payLoad = (Map<String, Object>) JSON.deserializeUntyped(
            payLoadString
        );
        String urlEndpoint = String.valueOf(payLoad.get('token_url__c'));
        System.debug('urlEndpoint: ' + urlEndpoint);
        String clientId = String.valueOf(payLoad.get('Client_Id__c'));
        System.debug('clientId :' + clientId);
        String clientSecretId = String.valueOf(payLoad.get('Client_Secret__c'));
        System.debug('clientSecretId :' + clientSecretId);
        String base64Format = EncodingUtil.base64Encode(
            Blob.valueOf(clientId + ':' + clientSecretId)
        );
        System.debug('base64Format :' + base64Format);
        String body =
            'grant_type=refresh_token&refresh_token=' +
            payLoad.get('refresh_token__c');
        System.debug('body :' + body);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint(urlEndpoint);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', 'Basic ' + base64Format);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(body);
        HttpResponse response = http.send(request);
        if (
            response.getStatusCode() == 201 ||
            response.getStatusCode() == 200
        ) {
            System.debug('response: ' + response.getBody());
            createUpdateIntegrationMetadata(response.getBody());
        } else {
            System.debug('Error ' + response.getStatus());
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static void setAuthorizationParams(String payLoadString) {
        Map<String, Object> payLoad = (Map<String, Object>) JSON.deserializeUntyped(
            payLoadString
        );
        Map<String, Object> tokenMap = new Map<String, Object>();
        tokenMap.put('realmId__c', payLoad.get('realmId__c'));
        tokenMap.put(
            'AuthorizationCode__c',
            payLoad.get('AuthorizationCode__c')
        );
        CreateUpdateMetadataUtils.createUpdateMetadata(
            'qb_Metadata.QuickBooks',
            'QuickBooks',
            tokenMap
        );
    }

    public class IntegrationParameters {
        @AuraEnabled
        public String authorizationCode;
        @AuraEnabled
        public String accessToken;
        @AuraEnabled
        public String authorizationURL;
        @AuraEnabled
        public String tokenURL;
        @AuraEnabled
        public String clientId;
        @AuraEnabled
        public String clientSecretId;
        @AuraEnabled
        public String environment;
        @AuraEnabled
        public String productionURL;
        @AuraEnabled
        public String sandboxURL;
    }

    public class AuthorizationParameters {
        @AuraEnabled
        public String code;
        @AuraEnabled
        public String state;
        @AuraEnabled
        public String realmId;
    }

    public class TokenParameters {
        public String access_token; //eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiZGlyIn0..1Id7U6d34zh7lWksBx-z_Q.TpQq76Zey0NT5H3OO2o-C5rW4SNf7BjSk3tUIqSVOzQwvyTMUFtaxUHtxIa8ruhCXhyr08ARWWcNeup8qQDMBZZUEbGG0_pdr8EKCmCwfvpCdK6h2Xh4gOSrz351o8qafnEBrDcz2_GGYWTUWdWtp3slkNXSh7FMd02epkpi7jFcaHzbOK8evPZFZAxQJy22JjwvkpIX4YHTCVL6Ze849j3fyrMo7XEGxBWk67Uc_ThEJK9Ni8OjKMrrT-vgGQ2vck9OcBiDPoTM2Bi2rnpcS94IhNcFgBVfKOX8-rPshcM8Xj7T_oGj-6vVflMSpuf6ex_4D0An2zWDUWsK5V46nn64gTX8BlwjHlLfNk1x84iArtJ3srn17RQ1-nEB6apzqGQQVBlBPSVLHBBiHDhXPQu-rRpC66m_Snusxt7dRzQmDtScQ3l9M7TiDEcyXNWsttEbOoG1_3zbEYiuYakooo4eZTAVxCniHJCBUJg0WuW9X3s0MJPJFcF_qEPisFWKvgPolU3zNQomYQ4bJAu1GoZax7kjtFMM2aewzs_E3uH9ma_L281OAM9vx8MMt4QJmoy-5o-9wDZP7tJCtnKXcUGjc6mpQckmSN5GsKmpXX7iMBvoxaWnZaPVPWAzBcmJU5iFMuXC9C0IqJge4B6wQUIWFBZ_4kVr14mkdD2Z1is_FWDugwjh_JH9FmGLKgn4sI1xbWQhdB_JknIwthzddIEvlNrxcrAol37D6pTInBl0nZEeqdFa_wWwkJN59aFG.Xb-XIMy1gc8SU9fai_w2tg
        public String refresh_token; //AB116440740005fistnjSFA7OTAKWrtgSqxRr0Kx0MJK9Afz39
        public Integer x_refresh_token_expires_in; //8726400
        public String token_type; //bearer
        public Integer expires_in; //3600
    }
}
