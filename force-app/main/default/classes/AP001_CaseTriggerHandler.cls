public without sharing class AP001_CaseTriggerHandler {
    
    public AP001_CaseTriggerHandler() {}

    public void handlerBeforeInsert(List<Case> lstCasNew){
        this.fillField(lstCasNew);
    }

    public void handlerBeforeUpdate(List<Case> lstCasNew, List<Case> lstCasOld){
        this.fillField(lstCasNew);
        this.noUpdateAfterClosed(lstCasNew, lstCasOld);
    }

    public void handleAfterInsert(List<Case> lstCasNew){
        this.createInvoices(lstCasNew);
    }

    public void handleAfterUpdate(List<Case> lstCasNew){
        this.createInvoices(lstCasNew);
    }

    private void createInvoices(List<Case> lstCasNew){
        List<Id> lstIdCase = new List<Id>();
        for (Case cas : lstCasNew) {
            lstIdCase.add(cas.Id);
        }
        List<Invoices__c> lstIdInvIdCas = [SELECT Case__c FROM Invoices__c WHERE Case__c IN :lstIdCase];
        Set<Id> setIdInv = new Set<Id>();
        for (Invoices__c idInvIdCas : lstIdInvIdCas) {
            setIdInv.add(idInvIdCas.Case__c);
        }
        List<Invoices__c> lstInv = new List<Invoices__c>();
        for (Case cas : lstCasNew) {
            if(!setIdInv.contains(cas.Id) && cas.Status == 'payment'){
                lstInv.add(
                    new Invoices__c(
                        Account__c = cas.AccountId,
                        Contact__c = cas.ContactId,
                        Case__c = cas.Id
                    )
                );
            }
        }
        insert lstInv;
    }
    
    private void fillField(List<Case> lstCasNew){
        Set<Id> setIdCont = new Set<Id>();
        for (Case cas : lstCasNew) {
            setIdCont.add(cas.ContactId);
        }
        List<Contact> lstAcc = [SELECT AccountId FROM Contact WHERE Id IN :setIdCont];
        Map<Id, Contact> mapIdContToIdAcc= new Map<Id, Contact>(lstAcc);
        for (Case cas : lstCasNew) {
            if(mapIdContToIdAcc.get(cas.ContactId) != null) {
                cas.AccountId = mapIdContToIdAcc.get(cas.ContactId).AccountId;
                 // cas.OwnerId = mapIdContToIdAcc.get(cas.ContactId).AccountId;
            }
        }
    }

    @AuraEnabled
    public static List<Case>  getListClaim(String userID){ 
        User userConnected = [SELECT ContactId, Username, SenderEmail  FROM USER WHERE ID =: userID LIMIT 1]; 
        return [SELECT ID ,ContactId, DamageType__c, Description, DateTimeIncident__c, Account.Name, Status, CreatedDate, ClosedDate FROM Case WHERE ContactId =: userConnected.ContactId ];
        
    }
    
    @AuraEnabled
    public static void createClaimFromWeb(SObject caseWeb,SObject vehicWeb, String userId, String accId ){
        System.debug(accId);
        caseWeb.put('AccountId', accId);
            if(caseWeb!=null && vehicWeb!=null){
            insert caseWeb;
            insert vehicWeb;
        }
        //System.debug('###Test test test');
        
    }
    @AuraEnabled
    public  static String getAccId(){
        return [SELECT AccountId FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1].AccountId;
    }

    private void noUpdateAfterClosed(List<Case> lstCasNew, List<Case> lstCasOld){
        Map<Id, Map<String, Object>> mapMapNewCas = this.sObjectToMap(lstCasNew);
        Map<Id, Map<String, Object>> mapMapOldCas = this.sObjectToMap(lstCasOld);
        for (Case cas : lstCasNew) {
            if(mapMapOldCas.get(cas.Id).get('Status') == 'Closed'){
                mapMapOldCas.get(cas.Id).put('Status', mapMapNewCas.get(cas.Id).get('Status'));
                for (String key : mapMapOldCas.get(cas.Id).keySet()) {
                    if(String.valueOf(mapMapOldCas.get(cas.Id).get(key)) != String.valueOf(mapMapNewCas.get(cas.Id).get(key))){
                        cas.addError('Only "Status" field can be modified on Closed Claim! ['+key+']');
                    }
                }
            }
        }
    }

    private Map<Id, Map<String, Object>> sObjectToMap(List<Case> lstCas) {
        Map<Id, Map<String, Object>> mapMapCas = new Map<Id, Map<String, Object>>();
        for (Case cas : lstCas) {
            Map<String, Object> mapSObject = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(cas));
            mapMapCas.put(cas.Id, mapSObject);
        }
        return mapMapCas;
    }
}