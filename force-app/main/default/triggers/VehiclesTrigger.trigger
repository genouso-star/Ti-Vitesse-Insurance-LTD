/**
 * @File Name          : VehiclesTrigger.trigger
 * @Description        : Inserting and updating the Total loss Vehicles Yearly field.
 * @Author             : Elia David HANTANIRINA
 * @Last Modified By   : Elia David HANTANIRINA
 * @Last Modified On   : 21/02/2022
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      Modification
 *==============================================================================
 * 1.0    21/02/2022      Elia David HANTANIRINA    Initial Version
**/

trigger VehiclesTrigger on Vehicles__c (after insert, after update) {

    AP001_VehiclesTriggerHandler handler = new AP001_VehiclesTriggerHandler();

    if (Trigger.isAfter && Trigger.isInsert) {
        handler.handleAfterInsert(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        handler.handleAfterUpdate(Trigger.new);
    }

}