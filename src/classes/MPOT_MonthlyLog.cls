/*
* @Name: MPOT_MonthlyLog
* @Description: Controller Class for Complete MPOT_MonthlyLog enhanced list view
* @Author:Deloitte Consulting
*/
public with sharing class MPOT_MonthlyLog{
public String ListViewName{get;set;}
public String listId {get;set;}
//private static String mpotProjectRecTypeId = Schema.SobjectType.MPOT_Change_Log__c.getRecordTypeInfosByname().get('MPOT Milestone Log').getRecordTypeId();
 
 public MPOT_MonthlyLog(){
 ListViewName = 'Complete Monthly Update Change Log';
 //sRoleParam = '';
 }
  public String listName {
    get;
    set {
        listName = value;
        String qryString = 'SELECT Name FROM MPOT_Monthly_Update_Change_Log__c LIMIT 1';
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(Database.getQueryLocator(qryString ));
        List<SelectOption> allViews = ssc.getListViewOptions();
        for (SelectOption so : allViews) {
          if (so.getLabel() == listName) {
              listId = so.getValue().substring(0,15);
              break;
          }
        }             
    }      
  }
 
 

}