public with sharing class ContactTriggerHandler {
      
    public static void beforeInsert(List<Contact> contacts) {
        for (Contact contact : contacts) {
           if (contact.DummyJSON_Id__c == null) {
                Integer randomNumber = (Integer) (Math.random() * 100).round();   
                contact.DummyJSON_Id__c = String.valueOf(randomNumber);
           }
        }

    }

    @future(callout=true)
    // Only run for inserted contacts where DummyJSON_Id__c <= 100
    public static void afterInsert(List<Id> contactIds) {
        List<Contact> contacts = [SELECT Id, DummyJSON_Id__c 
                                    FROM Contact 
                                   WHERE Id IN :contactIds];

        for (Contact contact : contacts) {
            Integer DummyJSONValue = Integer.valueOf(contact.DummyJSON_Id__c);

            if (DummyJSONValue <= 100) {
                DummyJSONCallout.getDummyJSONUserFromId(contact.DummyJSON_Id__c);
            }
  
        }

    }

    @future(callout=true)
    // Only run for updated contacts where DummyJSON_Id__c > 100
    public static void afterUpdate(List<Id> contactIds) {
        List<Contact> contacts = [SELECT Id, DummyJSON_Id__c, DummyJSON_Last_Updated__c 
                                    FROM Contact 
                                   WHERE Id IN :contactIds];

        for (Contact contact : contacts) {
            Integer DummyJSONValue = Integer.valueOf(contact.DummyJSON_Id__c);

            if (DummyJSONValue > 100) {
                DummyJSONCallout.postCreateDummyJSONUser(contact.Id); 
            }
  
        }

    }

}