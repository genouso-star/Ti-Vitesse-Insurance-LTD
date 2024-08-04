({
	doInit : function(component, event, helper) {
		var id_user =  $A.get("$SObjectType.CurrentUser.Id");
        helper.getLstInvoices(component, id_user); 
	}
})