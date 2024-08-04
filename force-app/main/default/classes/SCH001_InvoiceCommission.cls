global with sharing class SCH001_InvoiceCommission implements Schedulable{
    global void execute(SchedulableContext schedulContext) {
        // awesome code here
        
        //String sch = '0 55 23 L  ? ';
        
       // String jobID = System.schedule('Remind Opp Owners', sch, reminder);
       SCH001_InvoiceCommissionHandler updateAgent = new SCH001_InvoiceCommissionHandler();
       
       updateAgent.updateCommissionAgent();
        
    }
}
