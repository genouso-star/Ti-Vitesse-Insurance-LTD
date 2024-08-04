@isTest
public with sharing class BAT001_ResetAccTotalLossVehYearly_TEST {

    @TestSetup
    static void makeData(){
        List<Account> accounts = new List<Account>();
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(
                name = 'Account '+i, 
                TotalLossVehiclesYearly__c = i));
        }
        insert accounts;
    }

    @isTest static void reinitAccTotalLossVehYearly(){
        Test.startTest();
        Database.executeBatch(new BAT001_ResetAccTotalLossVehYearly());
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(
            0, 
            [SELECT count() FROM Account WHERE TotalLossVehiclesYearly__c > 0], 
            'Expected 0 Account with TotalLossVehiclesYearly');
    }
}
