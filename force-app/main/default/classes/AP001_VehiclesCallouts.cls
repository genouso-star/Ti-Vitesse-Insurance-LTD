public class AP001_VehiclesCallouts {

    @AuraEnabled
    public static Object getVehicles() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        Map<String,Object> genTok = AP001_AccessToken.getaccesstoken();
        request.setHeader('Authorization', 'Bearer ' + genTok.get('accesstoken'));
        request.setEndpoint(genTok.get('instanceURL') +'/services/apexrest/v1.0/getVehicles/');

        HttpResponse response = http.send(request);

        Object obj;
        // If the request is successful, parse the JSON response.
        if(response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            obj = JSON.deserializeUntyped(response.getBody());   
        }
        System.debug(obj);
        return obj;
    }

    @AuraEnabled
    public static object UpdateVehicles(map<string,object> obj, string idRecordCase) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        map<string,Object> genTok = AP001_AccessToken.getaccesstoken();
        request.setEndpoint(genTok.get('instanceURL') + '/services/apexrest/v1.0/updateVehicle/'+obj.get('RegistrationNumber'));
        request.setMethod('POST');   
		request.setHeader('Authorization', 'Bearer ' + genTok.get('accesstoken'));
        request.setHeader('Content-Type', 'application/json');
        string Body= '{'+
                '"Make":"'+obj.get('Make')+'",'+
                '"Model":"'+obj.get('Model')+'",'+
                '"Year of Vehicle":"'+obj.get('Year of Vehicle')+'"'+
            '}';
        request.setBody(body);
        HttpResponse response = http.send(request);
        Object results;
        system.debug(response.getStatusCode());
        system.debug(response.getBody());
        if(response.getStatusCode() == 200) {
            results = response.getBody();
            Vehicles__c Veh_WS = new Vehicles__c(RegistrationNumber__c=String.valueOf(obj.get('RegistrationNumber')),Make__c=String.valueOf(obj.get('Make')),Model__c=String.valueOf(obj.get('Model')),YearVehicle__c=decimal.valueOf((String)obj.get('Year of Vehicle')));
            system.debug('veh :::'+ Veh_WS);
            assignVehicle(Veh_WS,idRecordCase);
            system.debug('getbody update :::'+ response.getBody());
        } else return null;
        return results;
    }
    
    private static Object assignVehicle(Vehicles__c v,String idRecordCase) {
        List<Vehicles__c> vehUpd = new List<Vehicles__c>();
        Id idCon = [SELECT ContactId FROM Case WHERE Id= :idRecordCase].ContactId;
        List<Vehicles__c> lstRemVeh = [SELECT Id, Contact__c FROM Vehicles__c  WHERE Contact__c = :idCon];
        if(lstRemVeh.size() != 0){
        	lstRemVeh[0].Contact__c = null;
            vehUpd.add(lstRemVeh[0]);
        }
        
        v.Contact__c = idCon;
        v.RecordTypeId = Schema.SObjectType.Vehicles__c.getRecordTypeInfosByName().get('Vehicle on loan').getRecordTypeId();
        vehUpd.add(v);
        try {
        	upsert vehUpd;
            return v;
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
        return vehUpd;
    }
}