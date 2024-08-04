public with sharing class AP001_SendEmail {

    @InvocableMethod
    public static void SendEmail(List<String> idInvoice){
        
        String sMessage='M';
        String ids=idInvoice.get(0);
        Invoices__c inv = [SELECT Contact__c , Contact__r.Email__c , InvoiceDate__c FROM Invoices__c WHERE ID =:ids  LIMIT 1];
            
		String mail = inv.Contact__r.Email__c;
          
         PageReference invoicePDF = new PageReference('/apex/InvoicePDFPage?id='+ids);
        
        try{ 
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();  
            attach.setContentType('application/pdf');
            attach.setFileName('Invoice PDF');
            attach.body = invoicePDF.getContent();
             
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
			semail.setSubject('Invoice');
            semail.setToAddresses(new String[]{mail});
            semail.setPlainTextBody('Please find the attached Invoice details');
            semail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{semail});            
			sMessage='SUCCESS';
            
        }catch(Exception ex){
            sMessage=ex.getMessage()+'\n'+ex.getLineNumber()+'\n'+ex.getCause();
        } 
        
        //return sMessage;
       System.debug(sMessage);
    }
}
