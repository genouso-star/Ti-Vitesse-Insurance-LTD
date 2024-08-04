public with sharing class AP001_VehiclesTriggerHandler {
    public AP001_VehiclesTriggerHandler() {}
    /**
         * @description Method to increment Total Loss Vehicles Yearly field in the Agent object.
         * @author EHA | 21/02/2022
         * @return int Incrementing the Total Loss Vehicles Yearly.
         **/
    public void handleAfterInsert(List<Vehicles__c> lstVehNew){
        this.updateAccounts(lstVehNew);
    }

    public void handleAfterUpdate(List<Vehicles__c> lstVehNew){
        this.updateAccounts(lstVehNew);
    }

    private void updateAccounts(List<Vehicles__c> lstVehNew){
        Set<Id> setIdAcc = this.getIdsAccFromLstVehicle(lstVehNew);
        List<AggregateResult> lstIdAccCountVehLoss = [
            SELECT  
            Contact__r.AccountID, 
            COUNT(Id)

            FROM Vehicles__c 
            WHERE Contact__r.AccountID IN :setIdAcc 
            AND TotalLoss__c = true
            AND CreatedDate = THIS_YEAR
            GROUP BY Contact__r.AccountID];
        Map<Id, Double> mapIdAccToTotalLossVeh = new Map<Id, Double>();
        for (AggregateResult IdAccCountVehLoss : lstIdAccCountVehLoss) {
            mapIdAccToTotalLossVeh.put(
                String.valueOf(IdAccCountVehLoss.get('AccountID')),
                Double.valueOf(IdAccCountVehLoss.get('expr0'))
            );
        }
        List<Account> lstAccToUpdate = new List<Account>();
        for (Id idAcc : setIdAcc) {
            Double intTotalLossVehiclesYearly = mapIdAccToTotalLossVeh.get(idAcc) == null ? 0 : mapIdAccToTotalLossVeh.get(idAcc);
            lstAccToUpdate.add(
                new Account(
                    Id = idAcc,
                    TotalLossVehiclesYearly__c = intTotalLossVehiclesYearly
                )
            );
        }
        update lstAccToUpdate;
    }

    private Set<Id> getIdsAccFromLstVehicle(List<Vehicles__c> lstVehNew){
        List<Id> lstIdCont = new List<Id>();
        for (Vehicles__c veh : lstVehNew) {
            lstIdCont.add(veh.Contact__c);
        }
        List<Contact> lstCont = [SELECT AccountId FROM Contact WHERE Id IN :lstIdCont];
        Set<Id> setIdAcc = new Set<Id>();
        for (Contact cont : lstCont) {
            setIdAcc.add(cont.AccountId);
        }
        return setIdAcc;
    }
}
