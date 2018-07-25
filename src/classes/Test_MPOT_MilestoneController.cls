@isTest
public class Test_MPOT_MilestoneController {
     public static testmethod void viewProject_PositiveScenario1(){        
        List<GLBL_Global_List_of_Values__c>  lglblvaluesMileStones = new List<GLBL_Global_List_of_Values__c>(); 
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_NRO','runAsuser');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser');
        string sUserRole = MPOT_Util.fetchUserRole();
        sUserRole ='MPO NRO';
        Profile pfl = [select id from profile where name='System Administrator'];
       
        User user = new User(alias = 'Admin', email='appAdmin@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'Userlabel',
                                  timezonesidkey='America/Los_Angeles', username= 'test@gso_org.com' , ACED_HUB__c='ACE HUB' , ACED_Affiliate__c = 'ACE');
         
         
       
         System.runAs(user){
        	lglblvaluesMileStones =  Test_MPOT_DataFactory.createGlblList('Milestone');
        	insert lglblvaluesMileStones;              
         }
         
        system.runAs(assignUser){
        GLBL_Project__c p = new GLBL_Project__c();
        List<GLBL_Project__c> lProjects = new List<GLBL_Project__c>();
        lProjects = Test_MPOT_DataFactory.returnProjects(1);
    	insert lProjects;
        List<MPOT_Project_Milestone__c> lprjMilestone = new List<MPOT_Project_Milestone__c>();
        lprjMilestone = Test_MPOT_DataFactory.returnProjectMilestones(1,lProjects);
        insert lprjMilestone;
        p = lProjects[0];
            
        List<GLBL_Global_List_of_Values__c>  lglblvalues = new List<GLBL_Global_List_of_Values__c>(); 
        lglblvalues =  Test_MPOT_DataFactory.createGlblList('Sub-Milestone');
            for(GLBL_Global_List_of_Values__c g : lglblvalues){
                g.MPOT_Milestone__c = lglblvaluesMileStones[0].Id;
            }
        insert lglblvalues;
            
        
        MPOT_Project_Milestone__c pm = new MPOT_Project_Milestone__c();
        pm = lprjMilestone[0];
        system.debug('******project milestones *****'+lprjMilestone.size());    
            
        List<MPOT_Setting__c>  lSetting = Test_MPOT_DataFactory.mSetting();
        insert lSetting;
        PageReference pref = Page.MPOT_Milestone;
    	pref.getParameters().put('id', pm.id);
    	Test.setCurrentPage(pref);
        ApexPages.StandardController sc = new ApexPages.standardController(pm);
        MPOT_MilestoneController Controller =new  MPOT_MilestoneController(sc);
           
        test.starttest();
        controller.objMilestone = null;
        controller.MileStone = '';
	    Controller.SubMile();
        Controller.Confirm();
        Controller.cancel_milestoneupdate();
        system.assertEquals( controller.objMilestone ,null);
        Controller.modify();
        Controller.createChangeLog('Modify');
        Controller.confirm_milestoneupdate();
        Controller.goBack();
        Controller.cancel();
        Controller.cancelEdit();
        Controller.del();
        test.stoptest();
        }        
    }
    public static testmethod void viewProject_PositiveScenario2(){        
        List<GLBL_Global_List_of_Values__c>  lglblvaluesMileStones = new List<GLBL_Global_List_of_Values__c>(); 
        User runAsUser = Test_MPOT_DataFactory.createUser('MPOT_NRO','runAsuser');
        User assignUser = Test_MPOT_DataFactory.createUser('MPOT_Database_Administrator','assignUser');
        string sUserRole = MPOT_Util.fetchUserRole();
        sUserRole ='MPO NRO';
        Profile pfl = [select id from profile where name='System Administrator'];
       
        User user = new User(alias = 'Admin', email='appAdmin@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = 'Userlabel',
                                  timezonesidkey='America/Los_Angeles', username= 'test@gso_org.com' , ACED_HUB__c='ACE HUB' , ACED_Affiliate__c = 'ACE');
         
         
       
         System.runAs(user){
        	lglblvaluesMileStones =  Test_MPOT_DataFactory.createGlblList('Milestone');
        	insert lglblvaluesMileStones;              
         }
         
        system.runAs(assignUser){
        GLBL_Project__c p = new GLBL_Project__c();
        List<GLBL_Project__c> lProjects = new List<GLBL_Project__c>();
        lProjects = Test_MPOT_DataFactory.returnProjects(1);
    	insert lProjects;
        List<MPOT_Project_Milestone__c> lprjMilestone = new List<MPOT_Project_Milestone__c>();
        lprjMilestone = Test_MPOT_DataFactory.returnProjectMilestones(1,lProjects);
        insert lprjMilestone;
        p = lProjects[0];
            
        List<GLBL_Global_List_of_Values__c>  lglblvalues = new List<GLBL_Global_List_of_Values__c>(); 
        lglblvalues =  Test_MPOT_DataFactory.createGlblList('Sub-Milestone');
            for(GLBL_Global_List_of_Values__c g : lglblvalues){
                g.MPOT_Milestone__c = lglblvaluesMileStones[0].Id;
            }
        insert lglblvalues;
            
        
        MPOT_Project_Milestone__c pm = new MPOT_Project_Milestone__c();
        pm = lprjMilestone[0];
        List<MPOT_Setting__c>  lSetting = Test_MPOT_DataFactory.mSetting();
        insert lSetting;
        PageReference pref = Page.MPOT_Milestone;
    	Test.setCurrentPage(pref);
        ApexPages.StandardController sc = new ApexPages.standardController(pm);
        MPOT_MilestoneController Controller =new  MPOT_MilestoneController(sc);
        test.starttest();
	    Controller.SubMile();
        Controller.Confirm(); 
        Controller.cancel_milestoneupdate();
        Controller.modify();
        Controller.createChangeLog('Modify');
        system.assertEquals('/apex/MPOT_CreateEditProjectPage', MPOT_Setting__c.getValues('createPageLink').Message__c);
        Controller.confirm_milestoneupdate();
        Controller.goBack();
        Controller.cancel();
        Controller.cancelEdit();
        Controller.del();
        test.stoptest();
        }        
    }
    
}