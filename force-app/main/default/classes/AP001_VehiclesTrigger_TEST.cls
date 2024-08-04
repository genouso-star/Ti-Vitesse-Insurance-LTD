@isTest
private class AP001_VehiclesTrigger_TEST {
    @TestSetup
    static void makeData(){
        
    }

    @isTest
    static void insertUpdateVehicle(){
        Account acc = new Account(
            name='Acc',
            TotalLossVehiclesYearly__c=0
        );
        insert acc;
        Contact cont = new Contact(
            LastName='cont',
            AccountId=acc.Id
        );
        insert cont;
        Case cas = new Case(
            ContactId=cont.Id,
            AccountId=acc.Id,
            Status='New',
            Origin='Web',
            Subject='Claim'
        );
        insert cas;
        List<Vehicles__c> lstVeh = new List<Vehicles__c>(); 
        for (Integer i=0;i<10;i++) {
            lstVeh.add(
                new Vehicles__c(
                    Contact__c=cont.Id,
                    Case__c=cas.Id,
                    Make__c='Audi',
                    Model__c='Model',
                    Mileage__c=1000,
                    EngineCapacity__c=4,
                    RegistrationNumber__c='1234',
                    TotalLoss__c=true
                )
            );
        }
        Test.startTest();
        insert lstVeh;
        Account accUpdated = [SELECT TotalLossVehiclesYearly__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(10, accUpdated.TotalLossVehiclesYearly__c, 'Expected Account.TotalLossVehiclesYearly__c = 10');
        Vehicles__c vehToUpdate = lstVeh[0];
        vehToUpdate.TotalLoss__c = false;

        update vehToUpdate;
        Account accUpdated2 = [SELECT TotalLossVehiclesYearly__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(9, accUpdated2.TotalLossVehiclesYearly__c, 'Expected Account.TotalLossVehiclesYearly__c = 9');
        Test.stopTest();
    }
}
