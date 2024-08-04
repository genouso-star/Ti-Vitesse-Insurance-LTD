public without sharing class AP001_InvoicePDFController {

    @AuraEnabled
    public List<Invoices__c> lstAcc {get;set;}
    public String SelectAccId{get;set;}
    
    public AP001_InvoicePDFController(){
        DisplayAccount();
    }
    
    public void DisplayAccount(){
        
        //Get invoice id
        String idInvoice = ApexPages.CurrentPage().getparameters().get('id');
        
        lstAcc  = new List<Invoices__c>();
        lstAcc  = [SELECT Account__r.Name, Contact__r.Name, AmountWithVat__c, AmountWithoutVat__c, Case__r.CaseNumber, Contact__c, InvoiceDate__c , Name, Vat__c FROM Invoices__c where Id = :idInvoice ];
    
	}

    @AuraEnabled
    public static List<Invoices__c>  getLstInvoice(String userID){ 
        System.debug('User'+userID );
        User userConnected = [SELECT ContactId, Username FROM USER WHERE ID =: userID LIMIT 1]; 
        List<Invoices__c> lstInvoice = [SELECT ID , Name, Account__c,  Account__r.Name, Contact__r.Name, AmountWithVat__c,
        AmountWithoutVat__c, Case__r.CaseNumber, Contact__c, InvoiceDate__c , Vat__c FROM Invoices__c WHERE Contact__c = :userConnected.ContactId];
        System.debug('### liste invoice => ' + lstInvoice);
        return lstInvoice;   
    }

}
