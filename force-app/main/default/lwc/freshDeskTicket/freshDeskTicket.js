import { LightningElement, wire, api } from "lwc";
import getFreshDeskInitWrapper from "@salesforce/apex/FreshdeskUtil.getFreshDeskInitWrapper";
import createFreshTicketLWC from "@salesforce/apex/FreshdeskUtil.createFreshTicketLWC";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class FreshDeskTicket extends LightningElement {
    @api recordId;
    freshDeskWrapper;
    @wire(getFreshDeskInitWrapper)
    initWrapper({ error, data }) {
        if (data) {
            this.freshDeskWrapper = JSON.parse(data);
        } else if (error) {
            console.log(error);
        }
    }

    createTicket() {
        console.log("Data" + this.freshDeskWrapper);
        if (this.isInputValid()) {
            const kvData = {};
            kvData.recordId = "" + this.recordId;
            kvData.ticket = JSON.stringify(this.freshDeskWrapper);
            createFreshTicketLWC({ payLoadMap: kvData })
                .then((data) => {
                    let returnValue = JSON.parse(data);
                    if (returnValue.Error !== undefined) {
                        this.showNotification(
                            "Error!",
                            returnValue.Error,
                            "error"
                        );
                    } else {
                        this.showNotification(
                            "Success!",
                            "Ticket created successfully!",
                            "success"
                        );
                    }
                })
                .catch((error) => {
                    console.log(error);
                });
        }
    }

    handleChange(event) {
        console.log(event.target.name);
        if (event.target.name === "Email") {
            this.freshDeskWrapper.Email = event.target.value;
        } else if (event.target.name === "Subject") {
            this.freshDeskWrapper.Subject = event.target.value;
        } else if (event.target.name === "Priority") {
            this.freshDeskWrapper.Priority = parseInt(event.target.value, 10);
        } else if (event.target.name === "Status") {
            this.freshDeskWrapper.Status = parseInt(event.target.value, 10);
        } else if (event.target.name === "Description") {
            this.freshDeskWrapper.Description = event.target.value;
        }
        console.log(this.freshDeskWrapper);
    }

    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll(".validate");
        console.log(inputFields);
        inputFields.forEach((inputField) => {
            if (!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
            //this.contact[inputField.name] = inputField.value;
        });
        return isValid;
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(evt);
    }
}
