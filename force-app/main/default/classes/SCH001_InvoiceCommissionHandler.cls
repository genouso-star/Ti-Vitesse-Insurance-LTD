public with sharing class SCH001_InvoiceCommissionHandler {
    // define time schedulable
    public static String CRON_EXP ='0 45 23 L  ? ';
    
    public void updateCommissionAgent(){
    
    List<Id> lstIdCaseClosed = new List<Id>();
    List<Case> lstCaseClosed = [SELECT Id FROM Case WHERE ClosedDate  = THIS_MONTH AND ClosedDate = THIS_YEAR ];
    
    //Fetch all ID in case closed claims
    for(Case cas : lstCaseClosed){
        lstIdCaseClosed.add(cas.id);
    }
     
    //Get all related invoice related on claims closed
    List<AggregateResult> lstInvoiceGroupByAgent = [SELECT Account__c, sum(AmountWithVat__c) ,  max(Account__r.CommissionRate__c)  FROM Invoices__c WHERE Case__c IN :lstIdCaseClosed 
                                               		GROUP BY Account__c ];
    
    List<Account> lstAccounToUpdate = new List<Account>();
        for(AggregateResult inv : lstInvoiceGroupByAgent) {
             
            Double sommeAmount = 0;
            double percent = 1;
            
            if(Double.valueOf(inv.get('expr0')) > 0){
                sommeAmount = Double.valueOf(inv.get('expr0'));
            }
            
            if(Integer.valueOf(inv.get('expr1')) > 0){
                percent =  double.valueOf(inv.get('expr1'));
            }
            
            double result = sommeAmount *  (percent / 100);
            lstAccounToUpdate.add(new Account(id = String.valueOf(inv.get('Account__c')) , MonthlyCommission__c = result ));
            
        }                           
       update  lstAccounToUpdate;   
    }
}
