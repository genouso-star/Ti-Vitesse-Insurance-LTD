trigger VehiclesTrigger on Vehicles__c (after insert, after update) {

    AP001_VehiclesTriggerHandler handler = new AP001_VehiclesTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert) {
        handler.handleAfterInsert(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        handler.handleAfterUpdate(Trigger.new);
    }

}
