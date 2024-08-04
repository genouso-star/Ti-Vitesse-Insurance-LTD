({
    doInit : function(component, event, helper) {
		 
        var id_user =  $A.get("$SObjectType.CurrentUser.Id");
        helper.getListClaims(component, id_user);
        helper.getAccIds(component, id_user); 
	},
	saveClaims : function(component, event, helper) {
		//helper.saveClaimsHelper(component);
	 	var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
             inputCmp.showHelpMessageIfInvalid();
             return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        // If we pass error checking, do some real work
        if(validExpense){
            helper.saveClaimsHelper(component);
       }
    
	}
})