({
    getLstInvoices: function(component, id_user) {
         
        console.log('contactID '+id_user);
        
         var action = component.get('c.getLstInvoice'); 
         
        	action.setParams({
                "userID" : id_user, 
        	});
            // action.setCallback(this,function(response){ 
            // console.log('123 -> '+response.getReturnValue());
 		    //  component.set('v.lstInvoice', response.getReturnValue());
            // },'SUCCESS'); 
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === 'SUCCESS'){
 		            component.set('v.lstInvoice', response.getReturnValue());
                }
                else{
                    alert('error');
                }
            });
			  
           $A.enqueueAction(action);
        }
})
