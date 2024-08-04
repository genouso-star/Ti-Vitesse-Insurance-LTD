public class BAT001_ResetAccTotalLossVehYearly implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        return Database.getQueryLocator('SELECT TotalLossVehiclesYearly__c FROM Account');
    }

    public void execute(Database.BatchableContext batchContext, List<Account> LstAcc){
        for (Account acc : LstAcc) {
            acc.TotalLossVehiclesYearly__c = 0;
        }
        update LstAcc;
    }

    public void finish(Database.BatchableContext batchContext){}

}
