/******************************************************************************************************************************************
  * Class Name  : Test_MPOT_ChangeRecReqController
  * Description : Test class for MPOT_ChangeRecReqController
  * Created By  : SABA FATIMA
  * Created Date :7/1/2016
  * Modification Log:  
  ----------------------------------------------------------------------------------------------------------------------------------------
  
  * Developer                Date                 Modification ID        Description 
                       
  ----------------------------------------------------------------------------------------------------------------------------------------

********************************************************************************************************************************************/
@isTest(SeeAllData=false)
public with sharing class Test_MPOT_ChangeRecReqController {
     /* 
     * @Method Name                    :  TestViewCR
     * @Description                    :  Method to Test ViewCRController class
     * @Return Type                    :  void
     * @Parameters                     :  None
     */
    static testMethod void TestViewCR() {
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_NRO','runAsuser');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser');
        string sUserRole = MPOT_Util.fetchUserRole();
        sUserRole ='MPO NRO';
      	Test.startTest();
		System.runAs(runAsUser) {
            
            List < GLBL_Project__c > lProjects = Test_MPOT_DataFactory.returnProjectCR(1);
            GLBL_Project__c oProject = new GLBL_Project__c();
            if(lProjects.size() > 0){
                 oProject = lProjects[0];
                 oProject.MPOT_Changed_Add_New_Sponsor__c = 'new Sponsor';
                 insert lProjects;
             }
             
             //Inserting Gating Slides
            List<MPOT_Project_Gating_Slide_File__c> lGS = Test_MPOT_DataFactory.returnGatingSlides(2, lProjects);
            insert lGS;
         
			PageReference pageRef = new PageReference('/apex/MPOT_ChangeRecReqPage?Id='); 
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().put('Id',lProjects[0].Id);
            ApexPages.StandardController controller = new ApexPages.StandardController(lProjects[0]);
            MPOT_ChangeRecReqController oController = New MPOT_ChangeRecReqController(controller);
            System.assertNotEquals(lProjects.size(), 0);
         
            oController.saveCR();
            oController.cancelCR();
            MPOT_ChangeRecReqController.getMolecules();
            MPOT_ChangeRecReqController.getSites();
            MPOT_ChangeRecReqController.getPlatforms();
            MPOT_ChangeRecReqController.getNetworks();
            MPOT_ChangeRecReqController.returnGroupUser();
            MPOT_ChangeRecReqController.returnNROUser();
            MPOT_ChangeRecReqController.getChangedSponsors();
        }
        
        System.runAs(assignUser) {
             
             //Inserting Project
            List < GLBL_Project__c > lProjects = Test_MPOT_DataFactory.returnProjectCR(1);
            GLBL_Project__c oProject = new GLBL_Project__c();
            if(lProjects.size() > 0){
                 oProject = lProjects[0];
                 oProject.MPOT_Changed_Add_New_Sponsor__c = 'new Sponsor';
                 oProject.Name = 'testingNull';
                 oProject.MPOT_NRO_CR_Created_Indicator__c = true ;
                 oProject.MPOT_Gating_Slide_Exception__c = true;
                 insert lProjects;
             }
            
            oProject = [SELECT Id from GLBL_Project__c where Name = 'testingNull'];
           
            oProject.MPOT_Changed_Project_Sponsor__c = '';
            oProject.MPOT_Changed_Networks_Project_Impacts__c = '';
            oProject.MPOT_Changed_Sites__c = '';
            PageReference pageRef = new PageReference('/apex/MPOT_ChangeRecReqPage?Id='); 
            Test.setCurrentPage(pageRef);
            
            ApexPages.currentPage().getParameters().put('Id',lProjects[0].Id);
            ApexPages.StandardController controller2 = new ApexPages.StandardController(lProjects[0]);
            MPOT_ChangeRecReqController oController2 = New MPOT_ChangeRecReqController(controller2);
            oController2.saveCR();
     		
           }
        Test.stopTest();
    }
             
}