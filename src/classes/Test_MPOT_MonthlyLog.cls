@isTest(SeeAllData=false)
public with sharing class Test_MPOT_MonthlyLog {
    
    static testMethod void Test_MPOT_MonthlyLog() {
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_NRO','runAsuser');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser');
        string sUserRole = MPOT_Util.fetchUserRole();
        sUserRole ='MPO NRO';
        System.runAs(assignUser) {
            
            //Inserting Project
            List < GLBL_Project__c > lProjects = Test_MPOT_DataFactory.returnProjects(1);
        if(lProjects.size() > 0){
                insert lProjects;
            }
     
            Test_MPOT_DataFactory.createGlblList('Molecules');
            Test_MPOT_DataFactory.createUS(assignUser.Id);
            System.assertNotEquals(lProjects.size(), 0);
         
            Test.startTest();
            MPOT_MonthlyLog controller = new MPOT_MonthlyLog();
            controller.listName = 'value' ;
            controller.listId = '3456789';
            controller.ListViewName ='Complete Monthly Update Change Log';
           system.assertEquals( controller.ListViewName, 'Complete Monthly Update Change Log');
            Test.stopTest();
        }
        
    }
    
    
}