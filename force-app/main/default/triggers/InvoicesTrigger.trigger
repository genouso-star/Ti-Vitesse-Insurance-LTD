trigger InvoicesTrigger on Invoices__c (before insert, before update) {

    List<Invoices__c> lstInv = new List<Invoices__c>();
         for(Invoices__c inv: Trigger.new){
             
             if(Trigger.isInsert){
                 
                 if(inv.Name == null){    
                 	inv.LastPaymentDate__c = System.now().addMonths(3);
                    //inv.LastPaymentDate__c = inv.InvoiceDate__c.addMonths(3);
                    lstInv.add(inv);
                 }
             }
             
             if(trigger.isUpdate){
                 if(inv.Name == null && inv.Name != Trigger.oldMap.get(inv.Id).Name) {
                    inv.LastPaymentDate__c = System.now().addMonths(3);
                    //inv.LastPaymentDate__c = inv.InvoiceDate__c.addMonths(3);
                     lstInv.add(inv);
                 } 
             }
         }
    /*
    if(lstInv.size()>0) {
        upsert lstInv;
    }*/
}