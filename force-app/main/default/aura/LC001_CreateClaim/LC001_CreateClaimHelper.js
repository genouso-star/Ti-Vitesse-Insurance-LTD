({
    
        
    showMessage  : function(type, message){
        
         var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
                        "title": type+"!",
                        "type":""+type,
                        "message": ""+message
        });
        
        toastEvent.fire();
        
    }, saveClaimsHelper : function(component, helper) {
		 
            // Create the new expense
            var newClaims = component.get("v.newClaims");
            var newVehicleDammage = component.get("v.newVehicDammage");
            var accId = component.get('v.accId');
            var action = component.get('c.createClaimFromWeb'); 
             
            console.log("Create newClaims: " + JSON.stringify(newClaims));
            console.log("Create newVehicleDammage: " + JSON.stringify(newVehicleDammage));
            var id_user =  $A.get("$SObjectType.CurrentUser.Id");
            action.setParams({
                "caseWeb" : newClaims,
                "vehicWeb" : newVehicleDammage,
                "userId" :id_user,
                "accId" : accId
        	});
            
            action.setCallback(this,function(response){
                var state = response.getState();
                var responseValue = response.getReturnValue(); 
              
                //if(parseInt(responseValue)  == 1){
                if(state === 'SUCCESS'){
                    
                    console.log('Finish > '+responseValue);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"Success",
                        "message": "The claim has been created successfully."
                    });
                    toastEvent.fire();
                    
                    window.location.href = "https://resilient-impala-5b740-developer-edition.um8.force.com/customersupport/s";
                    
                }else if (state === "INCOMPLETE") {
                    alert("Incomplete");
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    }
                } else {
                    console.log("Unknown error");
                }
                 
            }); 
			 
            //helper.createExpense(component, newExpense);
          
          $A.enqueueAction(action); 
        
    }, 
    getListClaims: function(component, id_user) {
         
        console.log('contactID '+id_user);
        
         var action = component.get('c.getListClaim'); 
         
        	action.setParams({
                "userID" : id_user, 
        	});
            action.setCallback(this,function(response){ 
             //console.log('123 -> '+response.getReturnValue());
 		     component.set('v.lstClaims', response.getReturnValue());
            },'SUCCESS'); 
			  
           $A.enqueueAction(action,false); 
         
    },
    getAccIds: function(component, id_user) {
         
        console.log('contactID '+id_user);
        var action = component.get('c.getAccId'); 
         
            action.setCallback(this,function(response){ 
                console.log(response.getReturnValue());
 		    component.set('v.accId', response.getReturnValue());
            },'SUCCESS'); 
			  
           $A.enqueueAction(action,false); 
         
    }
})