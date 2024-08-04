global with sharing class SCH001_ResetAccTotalLossVehYearly implements Schedulable{
    global void execute(SchedulableContext schedulContext) {
        Database.executeBatch(new BAT001_ResetAccTotalLossVehYearly());
    }
}
//System.schedule('SCH001_ResetAccTotalLossVehYearly', '0 0 0 1 JAN ? *', new SCH001_ResetAccTotalLossVehYearly());
