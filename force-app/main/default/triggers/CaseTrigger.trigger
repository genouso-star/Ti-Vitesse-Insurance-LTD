trigger CaseTrigger on Case (before insert, before update, after insert, after update) {

    AP001_CaseTriggerHandler handler = new AP001_CaseTriggerHandler();

    if (Trigger.isBefore && Trigger.isInsert) {
        handler.handlerBeforeInsert(Trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        handler.handlerBeforeUpdate(Trigger.new, Trigger.old);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        handler.handleAfterInsert(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        handler.handleAfterUpdate(Trigger.new);
    }

}