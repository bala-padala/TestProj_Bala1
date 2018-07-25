/******************************************************************************************************************************************
* Class Name  : Test_MPOT_ViewCRController
* Description : Test class for MPOT_ViewCRController
* Created By  : SABA FATIMA
* Created Date :7/1/2016
* Modification Log:  
----------------------------------------------------------------------------------------------------------------------------------------

* Developer                Date                 Modification ID        Description 

----------------------------------------------------------------------------------------------------------------------------------------

********************************************************************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class Test_MPOT_ViewCRController {
    /* 
* @Method Name                    :  TestViewCR
* @Description                    :  Method to Test ViewCRController class
* @Return Type                    :  void
* @Parameters                     :  None
*/
    static testMethod void TestViewCR() {
        User u = Test_MPOT_DataFactory.createUser('MPOT_NRO','usr');
        System.runAs(u) {
            
            //Inserting Project
            List < GLBL_Project__c > lProjects = Test_MPOT_DataFactory.returnProjectCR(1);
            if(lProjects.size() > 0){
                insert lProjects;
            }
            
            //Inserting Gating Slides
            List<MPOT_Project_Gating_Slide_File__c> lGS = Test_MPOT_DataFactory.returnGatingSlides(2, lProjects);
            insert lGS;
          
            
            Test.startTest();
            
            PageReference pageRef = new PageReference('/apex/MPOT_ViewCRPage?Id='); 
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id',lProjects[0].Id);
            ApexPages.StandardController controller = new ApexPages.StandardController(lProjects[0]);
            
            MPOT_ViewCRController oController = New MPOT_ViewCRController(controller);
           System.assertNotEquals(lProjects.size(), 0);
          
            oController.submitCR();
            oController.approveCR();
            oController.deleteCR();
            oController.editCR();
            oController.newGatingSlide();
            oController.showPopUP();
            oController.closePopup();
            
            Test.stopTest();
        }
        
    }
    
}