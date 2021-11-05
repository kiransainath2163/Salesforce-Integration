/* eslint-disable dot-notation */
import { LightningElement, wire, track } from "lwc";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import fetchAuthorizationParameters from "@salesforce/apex/QuickbooksUtil.fetchAuthorizationParameters";
import getRefreshAccessToken from "@salesforce/apex/QuickbooksUtil.getRefreshAccessToken";
import getAccessToken from "@salesforce/apex/QuickbooksUtil.getAccessToken";
import setAuthorizationParams from "@salesforce/apex/QuickbooksUtil.setAuthorizationParams";
export default class LwcTestComponent extends NavigationMixin(
    LightningElement
) {
    currentPageReference;
    urlStateParameters;
    showAuthorizationButton = false;
    @track isShow = {
        showAuthorizationButton: false,
        checkAuthorization: true,
        fetchAuthorization: false,
        authorizationSuccess: false,
        checkAccessToken: false,
        checkAccessTokenValidity: false,
        fetchAccessToken: false,
        fetchRefreshedAccessToken: false,
        accessTokenSuccess: false,
        refreshedAccessTokenSuccess: false,
        accessTokenUptoDate: false
    };
    showSuccess;
    showAccessToken;
    metadataValues = {};
    accessTokenCheck = true;
    showRecordForm;
    isUrlParametersLoaded = false;
    isMetadataLoaded = false;
    authorizationCode;
    realmId;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            console.log(this.urlStateParameters);
            this.setParametersBasedOnUrl();
        }
    }

    @wire(fetchAuthorizationParameters)
    getParameters({ data, error }) {
        if (data) {
            this.metadataValues = JSON.parse(data);
            this.isMetadataLoaded = true;
            if (this.metadataValues.AuthorizationCode__c) {
                this.authorizationCode =
                    this.metadataValues.AuthorizationCode__c;
                this.isShow.authorizationSuccess = true;
                this.isShow.showAuthorizationButton = false;
            } else {
                this.metadataValues["AuthorizationCode__c"] =
                    this.authorizationCode;
            }
            this.metadataValues["realmId__c"] = this.authorizationCode;
            if (this.isUrlParametersLoaded) {
                this.fetchAccessToken();
                this.setAuthorizationIntegrationParams();
            }
            console.log(this.metadataValues);
            if (this.metadataValues.AuthorizationCode__c === undefined) {
                this.isShow.checkAccessToken = true;
                this.isShow.showAuthorizationButton = true;
            } else if (this.metadataValues.access_token__c) {
                this.accessTokenCheck = false;
                this.isShow.authorizationSuccess = true;
                if (this.metadataValues.expires_in_time__c) {
                    this.isShow.checkAccessTokenValidity = true;
                    const date1 = new Date(
                        this.metadataValues.expires_in_time__c
                    );
                    const date2 = new Date();
                    const diffTime = date1 - date2;
                    if (diffTime > 0) {
                        this.showRecordForm = true;
                        this.isShow.accessTokenUptoDate = true;
                    } else {
                        this.fetchRefreshAccessToken();
                    }
                }
            }
        } else if (error) {
            console.log(error);
        }
    }

    setParametersBasedOnUrl() {
        if (this.urlStateParameters.code && this.urlStateParameters.realmId) {
            this.authorizationCode = this.urlStateParameters.code;
            this.realmId = this.urlStateParameters.realmId;
            this.metadataValues["AuthorizationCode__c"] =
                this.authorizationCode;
            this.isShow.authorizationSuccess = true;
            this.isShow.showAuthorizationButton = false;
            console.log("metadataValues: " + this.metadataValues);
            this.isUrlParametersLoaded = true;
            this.metadataValues["realmId__c"] = this.urlStateParameters.realmId;
            if (this.isMetadataLoaded) {
                this.fetchAccessToken();
            }
        }
    }

    handleAuthorization() {
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url:
                    this.metadataValues.auth_url__c +
                    "?client_id=" +
                    this.metadataValues.Client_Id__c +
                    "&scope=com.intuit.quickbooks.accounting&redirect_uri=" +
                    this.metadataValues.RedirectURI__c +
                    "&response_type=code&state=kiran"
            }
        });
    }

    fetchAccessToken() {
        this.isShow.fetchAccessToken = true;
        getAccessToken({ payLoadString: JSON.stringify(this.metadataValues) })
            .then((data) => {
                console.log(data);
                this.isShow.accessTokenSuccess = true;
            })
            .catch((error) => {
                console.log(error);
            });
    }

    setAuthorizationIntegrationParams() {
        setAuthorizationParams({
            payLoadString: JSON.stringify(this.metadataValues)
        })
            .then((data) => {
                console.log(data);
            })
            .catch((error) => {
                console.log(error);
            });
    }

    fetchRefreshAccessToken() {
        this.isShow.fetchRefreshedAccessToken = true;
        getRefreshAccessToken({
            payLoadString: JSON.stringify(this.metadataValues)
        })
            .then((data) => {
                console.log(data);
                this.isShow.refreshedAccessTokenSuccess = true;
            })
            .catch((error) => {
                console.log(error);
            });
    }
}
