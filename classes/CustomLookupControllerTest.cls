/**
 * @author            : Loutfi ALILUCH
 * @last modified on  : 13/10/2022
 * @last modified by  : Loutfi ALILUCH
**/
@isTest
public with sharing class CustomLookupControllerTest {
    @TestSetup
    static void setup(){
        Account acc1 = new Account(Name = 'Test account 1', AccountNumber = 'CDK1234567891', Type = 'Prospect');
        Account acc2 = new Account(Name = 'Test account 2', AccountNumber = 'PLU1234567892', Type = 'Customer - Direct');
        Account acc3 = new Account(Name = 'Test account 3', AccountNumber = 'MPK1234567893', Type = 'Prospect');
        Account acc4 = new Account(Name = 'Test account 4', AccountNumber = 'CDK1234567894', Type = 'Channel Partner / Reseller');
        Account acc5 = new Account(Name = 'Test account 5', AccountNumber = 'CDK1234567895', Type = 'Installation Partner');
        Account acc6 = new Account(Name = 'Test account 6', AccountNumber = 'PKU1234567896', Type = 'Technology Partner');
        insert new List<Account>{acc1, acc2, acc3, acc4, acc5, acc6};
    }

    @isTest static void searchAccountsByName(){
        String objectApiName = 'Account';
        List<String> searchFields = new List<String>{'Name', 'AccountNumber'};
        String searchKey = 'Test';
        List<String> fieldsToQuery = new List<String>{'Name', 'AccountNumber', 'Type'};
        Test.startTest();
        List<Account> returnedAccounts = CustomLookupController.searchRecords(objectApiName, searchFields, searchKey, fieldsToQuery, null);
        Test.stopTest();
        System.assertEquals(6, returnedAccounts.size(), 'The returned records are wrong');
        System.assert(returnedAccounts[0].Type != null && !String.isEmpty(returnedAccounts[0].Type), 'Some field from fieldsToQuery list is missing');
    }

    @isTest static void searchAccountsByAccountNumber(){
        String objectApiName = 'Account';
        List<String> searchFields = new List<String>{'Name', 'AccountNumber'};
        String searchKey = 'CDK';
        List<String> fieldsToQuery = new List<String>{'Name', 'AccountNumber', 'Type'};
        Test.startTest();
        List<Account> returnedAccounts = CustomLookupController.searchRecords(objectApiName, searchFields, searchKey, fieldsToQuery, null);
        Test.stopTest();
        System.assertEquals(3, returnedAccounts.size(), 'The returned records are wrong');
        System.assert(returnedAccounts[0].Type != null && !String.isEmpty(returnedAccounts[0].Type), 'Some field from fieldsToQuery list is missing');
    }

    @isTest static void searchAccountsByEmptyKeyword(){
        String objectApiName = 'Account';
        List<String> searchFields = new List<String>{'Name', 'AccountNumber'};
        String searchKey = '';
        List<String> fieldsToQuery = new List<String>{'Name', 'AccountNumber', 'Type'};
        Test.startTest();
        List<Account> returnedAccounts = CustomLookupController.searchRecords(objectApiName, searchFields, searchKey, fieldsToQuery, null);
        Test.stopTest();
        System.assertEquals(6, returnedAccounts.size(), 'The returned records are wrong');
    }

    @isTest static void searchAccountsByNameAndFilter(){
        String objectApiName = 'Account';
        List<String> searchFields = new List<String>{'Name', 'AccountNumber'};
        String searchKey = 'Test';
        List<String> fieldsToQuery = new List<String>{'Name', 'AccountNumber', 'Type'};
        String filter = 'Type = \'Prospect\'';
        Test.startTest();
        List<Account> returnedAccounts = CustomLookupController.searchRecords(objectApiName, searchFields, searchKey, fieldsToQuery, filter);
        Test.stopTest();
        System.assertEquals(2, returnedAccounts.size(), 'The returned records are wrong');
        System.assert(returnedAccounts[0].Type != null && !String.isEmpty(returnedAccounts[0].Type), 'Some field from fieldsToQuery list is missing');
    }
}