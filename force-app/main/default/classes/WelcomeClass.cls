/**
 * @description       :
 * @author            : kiransainath@apisero.com
 * @group             :
 * @last modified on  : 10-12-2021
 * @last modified by  : kiransainath@apisero.com
 **/
@RestResource(urlMapping='/v1/Welcome/*')
global with sharing class WelcomeClass {
    global final static String WELCOME_MESSAGE = 'Welcome to SFDC Integration tutorials';

    @HttpGet
    global static String welcomeClassMesssage() {
        return WELCOME_MESSAGE;
    }

    @HttpPost
    global static String postGreetingMessage() {
        return WELCOME_MESSAGE;
    }

    @HttpPatch
    global static String patchGreetingMessage() {
        return WELCOME_MESSAGE + 'update with Patch';
    }
}
