@isTest
public with sharing class AP001_VehicleManager_TEST {
    /*@isTest
    static void testGetVehicleOnloanAvalaible() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://resilient-impala-5b740t-dev-ed.my.salesforce.com/services/apexrest/Vehicles/'
            + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Vehicles__c thisVehicles__c = VehicleManager.testGetVehicleOnloanAvalaible();
        // Verify results
        System.assert(thisVehicles__c != null);
        System.assertEquals('Test record', thisVehicles__c.RecordType);
    }
    @isTest
    static void testCreateVehicleOnloanAvalaible() {
        // Call the method to test
        ID thisVehicles__cId = VehicleManager.createVehicleOnloanAvalaible(
            '001234', 'Chevrolet', 'Test', '2012');
        // Verify results
        System.assert(thisVehicles__cId != null);
        Vehicles__c thisVehicles__c = [SELECT RegistrationNumber__c, Make__c, Model__c, YearVehicle__c
                            FROM Vehicles__c
                            WHERE RecordType.Name = 'On loan Vehicle'];
        System.assert(thisVehicles__c != null);
        System.assertEquals(thisVehicles__c.RecordType, 'On loan Vehicle');
    }*/
}

