public with sharing class AP001_AccessToken {
    public static map<String,Object> getaccesstoken() {
        map<String,Object> result = new map<String,Object>();
        Webservice_Setting__mdt stglogin = [SELECT MasterLabel,Consumer_Key__c ,Consumer_Secret__c,Password__c,Username__c,Security_token__c 
                                    FROM Webservice_Setting__mdt WHERE MasterLabel = 'Login'limit 1];

        //get the access token
        Http httpCls = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/oauth2/token');
        request.setMethod('POST');
        request.setTimeout(2 * 60 * 1000);

        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setBody('grant_type=password' +
        '&client_id=' + stglogin.Consumer_Key__c +
        '&client_secret=' + stglogin.Consumer_Secret__c +
        '&username=' + stglogin.Username__c +
        '&password=' + stglogin.Password__c+stglogin.Security_token__c);

        httpResponse response = httpCls.send(request);
        
        if(response.getStatusCode() == 200){
            map<string,Object> resultMap = (map<string,Object>)JSON.deserializeUntyped(response.getBody());
            result.put('accesstoken',resultMap.get('access_token'));
            result.put('instanceURL',resultMap.get('instance_url'));
            result.put('error',false);
            result.put('message','Connection made successfully!');
        }
        else{
            result.put('error',true);
            result.put('message','Could not retrieve the access token for the following reason :' + response.getBody());
        }
        return result;

    }
}
