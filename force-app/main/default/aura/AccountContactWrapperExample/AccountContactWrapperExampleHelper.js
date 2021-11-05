({
    getAccountContactWrapperhelper: function (component, event, helper) {
        console.log("***In helper");
        var a = component.get("v.recordId");
        console.log("***In helper" + a);
        //call apex class method
        var action = component.get("c.getAccountWithContacts");
        action.setParams({
            accountId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in wrapperList attribute on component.
                component.set(
                    "v.accountContactWrapper",
                    JSON.parse(response.getReturnValue())
                );
            }
        });
        $A.enqueueAction(action);
    }
});
