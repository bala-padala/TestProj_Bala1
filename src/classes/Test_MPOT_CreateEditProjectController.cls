@IsTest
public with sharing class Test_MPOT_CreateEditProjectController{
   
    public static testMethod void createAsNRO() {
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_NRO','runAsuser');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser');
        
      
        system.runAs(runAsuser){
        GLBL_Project__c p = new GLBL_Project__c();
        List<GLBL_Project__c> lProjects = new List<GLBL_Project__c>();
        lProjects = Test_MPOT_DataFactory.returnProjects(1);
    
        insert lProjects;
        p = lProjects[0];
        List<MPOT_Setting__c>  lSetting = Test_MPOT_DataFactory.mSetting();
        insert lSetting;
        PageReference pref = Page.MPOT_HomePage;
        Test.setCurrentPage(pref);
        Test.Starttest();
        ApexPages.StandardController sc = new ApexPages.standardController(p);
        MPOT_CreateEditProjectController Controller =new  MPOT_CreateEditProjectController(sc);

        Controller.saveProject();
        Controller.redirectOnComplete();
       
        System.assertEquals(lProjects.size(), 1);
        MPOT_CreateEditProjectController.getMolecules();
        MPOT_CreateEditProjectController.getSites();
        MPOT_CreateEditProjectController.getPlatforms();
        MPOT_CreateEditProjectController.getNetworks();
        MPOT_CreateEditProjectController.returnGroupUser();
        MPOT_CreateEditProjectController.returnNROUser();
        MPOT_CreateEditProjectController.getSponsors();
        Controller.cancelEdit();
        Test.StopTest();
        }
        
    }
    
     public static testMethod void createAsNROPo() {
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_ProjectOwner','runAsuser');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser');
   
      
        system.runAs(runAsuser){
        GLBL_Project__c p = new GLBL_Project__c();
        List<GLBL_Project__c> lProjects = new List<GLBL_Project__c>();
        lProjects = Test_MPOT_DataFactory.returnProjects(1);
    
        insert lProjects;
        p = lProjects[0];
        List<MPOT_Setting__c>  lSetting = Test_MPOT_DataFactory.mSetting();
        insert lSetting;
        PageReference pref = Page.MPOT_CreateEditProjectPage;
        pref.getParameters().put('id', p.id);
        Test.setCurrentPage(pref);
        test.Starttest();
        ApexPages.StandardController sc = new ApexPages.standardController(p);
        MPOT_CreateEditProjectController Controller =new  MPOT_CreateEditProjectController(sc);
        
        Controller.saveProject();
        Controller.redirectOnComplete();
       
        System.assertEquals(lProjects.size(), 1);
        MPOT_CreateEditProjectController.getMolecules();
        MPOT_CreateEditProjectController.getSites();
        MPOT_CreateEditProjectController.getPlatforms();
        MPOT_CreateEditProjectController.getNetworks();
        MPOT_CreateEditProjectController.returnGroupUser();
        MPOT_CreateEditProjectController.returnNROUser();
        MPOT_CreateEditProjectController.getSponsors();
        Controller.cancelEdit();
        test.StopTest();
        }
        
    }
    
     public static testMethod void createAsComboUser() {
        Profile pfl = [select id from profile where name='System Administrator'];
       
        User user = new User(alias = 'Admin', email='appAdmin@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'Userlabel',
                                  timezonesidkey='America/Los_Angeles', username= 'test@gso_org.com' , ACED_HUB__c='ACE HUB' , ACED_Affiliate__c = 'ACE');
         
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_NRO','u');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser'); 
       
        System.runAs(user){
      
        GLBL_User_Settings__c oUserSetting= new GLBL_User_Settings__c();
        oUserSetting.MPOT_User_Role__c = 'MPO NRO';
        oUserSetting.GLBL_User__c = runAsUser.Id;
        insert oUserSetting;
        }
         
        system.runAs(runAsUser){
        string sUserRole = MPOT_Util.fetchUserRole();
        
        GLBL_Project__c p = new GLBL_Project__c();
        List<GLBL_Project__c> lProjects = new List<GLBL_Project__c>();
        lProjects = Test_MPOT_DataFactory.returnProjects(1);
    
        insert lProjects;
        p = lProjects[0];
        List<MPOT_Setting__c>  lSetting = Test_MPOT_DataFactory.mSetting();
        insert lSetting;
        PageReference pref = Page.MPOT_CreateEditProjectPage;
        pref.getParameters().put('id', p.id);
        Test.setCurrentPage(pref);
        Test.Starttest();
        ApexPages.StandardController sc = new ApexPages.standardController(p);
        MPOT_CreateEditProjectController Controller =new  MPOT_CreateEditProjectController(sc);

        Controller.saveProject();
        Controller.redirectOnComplete();
        System.assertEquals(lProjects.size(), 1);
        MPOT_CreateEditProjectController.getMolecules();
        MPOT_CreateEditProjectController.getSites();
        MPOT_CreateEditProjectController.getPlatforms();
        MPOT_CreateEditProjectController.getNetworks();
        MPOT_CreateEditProjectController.returnGroupUser();
        MPOT_CreateEditProjectController.returnNROUser();
        MPOT_CreateEditProjectController.getSponsors();
        Controller.cancelEdit();
        test.StopTest();
        
        } 
    }
}