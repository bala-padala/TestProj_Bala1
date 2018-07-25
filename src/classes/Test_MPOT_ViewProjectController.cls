/******************************************************************************************************************************************
* Class Name  : Test_MPOT_ViewProjectController
* Description : Test class for MPOT_ViewProjectController

* Modification Log:  
----------------------------------------------------------------------------------------------------------------------------------------

* Developer                Date                 Modification ID        Description 

----------------------------------------------------------------------------------------------------------------------------------------

********************************************************************************************************************************************/
@isTest
public class Test_MPOT_ViewProjectController {
    public static testmethod void viewProject(){
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_NRO','runAsuser');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser');
        string sUserRole = MPOT_Util.fetchUserRole();
        sUserRole ='MPO NRO';
      
        system.runAs(runAsuser){
        GLBL_Project__c p = new GLBL_Project__c();
        List<GLBL_Project__c> lProjects = new List<GLBL_Project__c>();
        lProjects = Test_MPOT_DataFactory.returnProjects(1);
    
        insert lProjects;
        p = lProjects[0];
        List<MPOT_Setting__c>  lSetting = Test_MPOT_DataFactory.mSetting();
        insert lSetting;
        PageReference pref = Page.MPOT_ViewProjectPage;
        pref.getParameters().put('id', p.id);
        Test.setCurrentPage(pref);
        ApexPages.StandardController sc = new ApexPages.standardController(p);
        MPOT_ViewProjectController Controller =new  MPOT_ViewProjectController(sc);
        test.starttest();
                Controller.showPopUP();
                Controller.showPopUP1();
                controller.getStatusValues();
                controller.closePopup();
                controller.closePopup1();
                controller.approveProject();
                controller.editProject();
             
                controller.submitProject();
                System.assertEquals(lProjects.size(), 1);
                controller.newGatingSlide();
                controller.submitProject();
                controller.newMilestone();
                controller.newProjectConnection();
                controller.changeRecReq();
                controller.confirmMonthlyUpdate();
                controller.confirmRIVERsystem();
                Controller.viewCRReq();
                Controller.RedirectToGantt();
                Controller.sRadio = 'true';
                controller.sIssues = 'test';
                controller.confirmMonthlyUpdate(); 
                controller.cancelProject(); 
                Controller.sRadio = 'true';
                controller.sIssues = 'test';
                controller.confirmMonthlyUpdate();     
        test.stoptest();
        }
        
    }
    
    
    

}