/**
 * @author            : Loutfi ALILUCH
 * @last modified on  : 04/02/2022
 * @last modified by  : Loutfi ALILUCH
**/
public with sharing class CustomLookupController {
    @AuraEnabled
    public static List<sObject> searchRecords(String objectApiName, List<String> searchFields, String searchKey, List<String> fieldsToQuery, String filter){
        String query = 'SELECT ' + String.join(fieldsToQuery, ',');
        query += ' FROM ' + objectApiName;

        if(searchKey != null && searchKey != ''){
            String searchKeyword = '%' + searchKey + '%';
            query += getWhereClause(searchFields, searchKeyword);
        }
        if(filter != null && filter != ''){
            query += ' AND ' + filter;
        }
        query += ' LIMIT 20';
        return Database.query(query);
    }


    private static String getWhereClause(List<String> searchFields, String searchKeyword){
        List<String> whereClauseItems = new List<String>();
        for(String searchField : searchFields){
            whereClauseItems.add(searchField + ' LIKE :searchKeyword');
        }
        return ' WHERE (' + String.join(whereClauseItems, ' OR ') + ')';
    }
}