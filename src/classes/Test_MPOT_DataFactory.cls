/******************************************************************************************************************************************
  * Class Name  : Test_MPOT_DataFactory
  * Description : Test data class for MPOT
  * Created By  : SABA FATIMA
  * Created Date :6/17/2016
  * Modification Log:  
  ----------------------------------------------------------------------------------------------------------------------------------------
  
  * Developer                Date                 Modification ID        Description 
  Haritulasi               6/17/2016       
  ----------------------------------------------------------------------------------------------------------------------------------------

********************************************************************************************************************************************/
@isTest(SeeAllData=false)
public class Test_MPOT_DataFactory{
 
  
     
    //Creating User
    public static User createUser(String PermissionSetLabel,String Userlabel){

        Profile pfl = [select id from profile where name='GSO Basic User_Platform'];
        //Declaring the User
        User runAsUser = new User(alias = 'Admin', email='appAdmin@testorg.com',
                                  emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                                  localesidkey='en_US', profileid = pfl.Id,  country='United States', CommunityNickname = Userlabel,
                                  timezonesidkey='America/Los_Angeles', username= Userlabel+'@gso_org.com' , ACED_HUB__c='ACE HUB' , ACED_Affiliate__c = 'ACE');
        
        Insert runAsUser;     
        //Fetching the permission set based parameters recieved by createUser method    
        PermissionSet pSet = [SELECT ID,Label from PermissionSet WHERE Name=:PermissionSetLabel];
        PermissionSetAssignment Asign = New PermissionSetAssignment();
        Asign.AssigneeId=runAsUser.ID;
        Asign.PermissionSetId=pSet.ID;
        Insert Asign;     
        
        System.assertEquals(Asign.AssigneeId, runAsUser.ID);
        Return runAsUser;       
    
    }   
      /* 
     * @Method Name                    :  returnProjects
     * @Description                    :  returns a list of Projects
     * @Return Type                    :  List
     * @Parameters                     :  count
     */
    public static list < GLBL_Project__c > returnProjects(integer count) {
        list < GLBL_Project__c > lProject = new list < GLBL_Project__c > ();
        list<GLBL_Global_List_of_Values__c> lglv = new List<GLBL_Global_List_of_Values__c>();
        String mpotProjectRecTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('MPOT Project').getRecordTypeId();
        
        
        //Id recordTypeNetwork = Schema.SObjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByName().get('MPO_Networks').getRecordTypeId();
        //Id recordTypeNetwork = [select id,Name from RecordType where SobjectType='GLBL_Global_List_of_Values__c' and DeveloperName='MPO_Networks' Limit 1 ].Id;
        
        //GLBL_Global_List_of_Values__c glvObj = new GLBL_Global_List_of_Values__c(Name='TestGlobalNtwrk' , Active__c = true, recordTypeId=recordTypeNetwork);
        //lglv.add(glvObj);
        //insert lglv;
        
        //Id networkID = [Select Id from GLBL_Global_List_of_Values__c where RecordTypeId =: recordTypeNetwork LIMIT 1].Id;
        for (integer i = 0; i < count; i++) {
            GLBL_Project__c oProject = new GLBL_Project__c();
            oProject.Name = 'test Project' + i;
            oProject.MPOT_Stage__c = 'On Hold';
            //oProject.MPOT_Network_Project_Initiated_from_Id__c = networkID;
            oProject.MPOT_Network_Project_Initiated_from_Id__c = 'test network ID';
            oProject.MPOT_Network_Project_Initiated_from__c = 'TestGlobalNtwrk';
            oProject.MPOT_Project_Description__c = 'test description';
            oProject.MPOT_Project_Driver__c = 'Business Unit Request';
            oProject.MPOT_Networks_Project_Impacts__c = 'Dry Products ;';
            oProject.MPOT_Project_Scope__c = 'test Scope ';
            oProject.MPOT_Project_Sponsor__c = 'test Sponsor';
            oProject.MPOT_Regulatory_Impact__c = 'Yes';
            oProject.MPOT_Sites__c = 'test Site';
            oProject.MPOT_New_Project_Request_Approved__c = true;
            oProject.MPOT_Changes_Issues__c = 'tdst';
            oProject.MPOT_Project_Owner_Id__c ='005b0000004IOL8';
            oProject.MPOT_Project_Owner__c = '005b0000004IOL9';
            oProject.MPOT_Project_Sponsor__c = '005b0000004IOL8';
            oProject.MPOT_Add_new_Sponsor__c = '005b0000004IOL9';
            oProject.MPOT_Anchor__c = 'Yes';
            oProject.MPOT_Regulatory_Impact_Level__c = 'Minor';
          //  oProject.MPOT_Network_Record_Owner_Id__c = '005b0000004IOL8';
           // oProject.OwnerId = '005b0000004IOL8';
            //oProject.Country__c = 'test Country';
            oProject.RecordTypeId = mpotProjectRecTypeId;
            lProject.add(oProject);
        }
        System.assertNotEquals(lProject.size(),0);
        System.debug('@@@@@@@@@@@@@@@@@@@@@@@@lProject.size() in return projects mpot util' +lProject.size() );
        return lProject;
    }

          /* 
     * @Method Name                    :  returnProjectCR
     * @Description                    :  returns a list of Projects
     * @Return Type                    :  List
     * @Parameters                     :  count
     */
    public static list < GLBL_Project__c > returnProjectCR(integer count) {
        
        //Inserting Project
        List < GLBL_Project__c > lProjects = Test_MPOT_DataFactory.returnProjects(1);
        for(GLBL_Project__c proj : lProjects )
        {
        proj.MPOT_Changed_Project_Name__c = 'Test Changed Project Name';
        proj.MPOT_Changed_Project_Description__c = 'Test MPOT Changed Project Description';
        proj.MPOT_Changed_Project_Driver__c = 'Minimize Key Risks'; 
        proj.MPOT_Changed_Project_Scope__c ='Test MPOT Changed Project Scope';
        proj.MPOT_Changed_Project_Sponsor__c = 'Test MPOT Changed Project Sponsor';
        proj.MPOT_Changed_Stage__c = 'Feasibility/Design – Post Gate 2';
        proj.MPOT_Changed_Owner_Name__c = 'Test Changed Owner Name';
        proj.MPOT_Changed_Netwrk_Proj_Initiated_from__c = 'Test Changed Netwrk Proj Initiated from';
        proj.MPOT_Changed_Networks_Project_Impacts__c = 'Test Changed Networks Project Impacts';
        proj.MPOT_Changed_Platforms__c = 'Test Changed Platforms';
        proj.MPOT_Changed_Sites__c = 'Test Changed Sites';
        proj.MPOT_Changed_Molecule_Name__c = 'Test Changed Molecule Name';
        proj.MPOT_Changed_NRO_Comments__c ='Changed NRO Comments';
        proj.MPOT_Change_Regulatory_Impact_To__c = 'No';
        proj.MPOT_Change_Requested_By__c = 'Requested User - Change Requested By XYZ';
        proj.MPOT_Changed_Anchor__c = 'Yes';
        proj.MPOT_Anchor__c = 'Yes';
 
        }
         System.assertNotEquals(  lProjects.size() ,0);
        return lProjects;
        
    }

    
    /* 
     * @Method Name                    :  returnGatingSlides
     * @Description                    :  returns a list of Gating Slides
     * @Return Type                    :  List
     * @Parameters                     :  count,List of Gating Slides
     */
    public static list < MPOT_Project_Gating_Slide_File__c > returnGatingSlides(integer count, List < GLBL_Project__c > lProject) {
        list < MPOT_Project_Gating_Slide_File__c > lGatingSlides = new list < MPOT_Project_Gating_Slide_File__c > ();
        for (GLBL_Project__c oProject: lProject) {
            for (integer i = 0; i < count; i++) {
                MPOT_Project_Gating_Slide_File__c oGS = new MPOT_Project_Gating_Slide_File__c();
                //oPC.Name = 'test PC' + i;
                oGS.Project__c = oProject.id;
                //oPC.Connected_Project_Id__c = oProject.id;
                lGatingSlides.add(oGS);
            }
        }
        System.assertNotEquals( lGatingSlides.size() ,0);
        return lGatingSlides;
    }
    
       /* 
     * @Method Name                    :  returnProjectMilestones
     * @Description                    :  returns a list of Project Milestones
     * @Return Type                    :  List
     * @Parameters                     :  count,List of Project Milestones
     */
    public static list < MPOT_Project_Milestone__c> returnProjectMilestones(integer count,list <GLBL_Project__c> lProjt) {
        list <MPOT_Project_Milestone__c> lmilestones= new list <MPOT_Project_Milestone__c> ();
         MPOT_Project_Milestone__c oMilestone = new MPOT_Project_Milestone__c();
        for (GLBL_Project__c oProjt: lProjt) {
            for (integer i = 0; i < count; i++) {
              oMilestone.Milestone_name__c = 'Submission/Approval';
              oMilestone.Sub_Milestone_name__c = 'Canada';
              oMilestone.Start_date__c = system.Today();
              oMilestone.End_date__c = system.Today()+10;
              oMilestone.New_Start_date__c = system.Today()+15;
              oMilestone.New_End_date__c = system.Today()+20;
              oMilestone.Reason_For_Change__c ='Reason';
              oMilestone.Milestone_detail__c ='Detail';
              oMilestone.Project_Name__c = oProjt.Id; 
              lmilestones.add(oMilestone);
               System.assertEquals( lmilestones.size() ,1);
            }
        }
        return lmilestones;
    }
    
       /* 
     * @Method Name                    :  returnProjectConnections
     * @Description                    :  returns a list of Project Connections
     * @Return Type                    :  List
     * @Parameters                     :  count,List of Project Connections
     */
    public static list < MPOT_Project_Connections__c> returnProjectConnections(integer count,List<GLBL_Project__c> lPrjt) {
        list <MPOT_Project_Connections__c> lConnections= new list <MPOT_Project_Connections__c> ();
         //list <GLBL_Project__c> lProjt = returnProjects(count);
         MPOT_Project_Connections__c oConnections =new MPOT_Project_Connections__c ();
       for (GLBL_Project__c oProject: lPrjt) {
       
            for (integer i = 0; i < count; i++) {
              oConnections.Connected_Project_Name__c = oProject.Id; 
              oConnections.Connected_ProjectName__c = oProject.Id; 
              lConnections.add(oConnections);
            }
        }
         System.assertEquals( lConnections.size() ,1);
        return lConnections;
    }
    
        /* 
     * @Method Name                    :  returnGlobalListOfValues
     * @Description                    :  returns a list of Global List Of Values
     * @Return Type                    :  List
     * @Parameters                     :  count,List of Global List Of Values
     */
    public static list < GLBL_Global_List_of_Values__c> returnGlblList(integer count) {
        list <GLBL_Global_List_of_Values__c> lGlblList = new list <GLBL_Global_List_of_Values__c> ();
        String milestoneRecTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('Milestone').getRecordTypeId();
        for (GLBL_Global_List_of_Values__c oGlblList : lGlblList ) {
            for (integer i = 0; i < count; i++) {
              oGlblList.Name= 'MilestoneData';
              oGlblList.RecordTypeId = milestoneRecTypeId ;
              oGlblList.Active__c = true;
              lGlblList.add(oGlblList);
            }
        }
           System.assertEquals( lGlblList.size() ,1);
        return lGlblList ;
    }
    
    //Create public group
    public static Group returnPbGrp(string groupName) {
        Group oTestGrp = new Group();
        oTestGrp.Name = groupName;
        //oTestGrp.DeveloperName = groupName;
        insert oTestGrp;
        System.assertEquals( oTestGrp.Name , groupName);
        return oTestGrp;
   
    }
    
    //Create public group member
    public static void returnPbGrpMember(string pGroupId, string userId) {
        GroupMember oTestGrpMember = new GroupMember();
        oTestGrpMember.GroupId = pGroupId;
        oTestGrpMember.UserOrGroupId = userId;
        insert oTestGrpMember;
        System.assertEquals( oTestGrpMember.GroupId, pGroupId);
        //return oTestGrpMember ;
    }
    
    //Create glbl list of values
    public static List<GLBL_Global_List_of_Values__c> createGlblList(string val){
        List<GLBL_Global_List_of_Values__c> lGlbl =new List<GLBL_Global_List_of_Values__c>();
        GLBL_Global_List_of_Values__c gl = new GLBL_Global_List_of_Values__c();
        gl.Active__c = true;
        gl.Name = 'Test Value';
        gl.RecordTypeId = Schema.SobjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByname().get(val).getRecordTypeId();
        lGlbl.add(gl);
        System.assertEquals( gl.Name,  'Test Value');
        return lGlbl;
     
    }
    
    //Create User Setting
    public static void createUS(Id userId) {
        GLBL_User_Settings__c USet = new GLBL_User_Settings__c();
        USet.MPOT_User_Role__c = 'MPO Database Administrator';
        USet.GLBL_User__c = userId;
        USet.RecordTypeId = Schema.SobjectType.GLBL_User_Settings__c.getRecordTypeInfosByname().get('MPOT').getRecordTypeId();
        insert USet;
        System.assertEquals(  USet.GLBL_User__c , userId);
    }
    
    public static List<MPOT_Setting__c> mSetting(){
        List<MPOT_Setting__c>  lSetting = new List<MPOT_Setting__c>();
        MPOT_Setting__c mSetting = new MPOT_Setting__c();
        mSetting.Name = 'AdminActiveProjects';
        mSetting.Message__c = 'Active Projects';
        lSetting.add(mSetting);
        
        MPOT_Setting__c mSetting1 = new MPOT_Setting__c();
        mSetting1.Name = 'AdminChangeRecordRequests';
        mSetting1.Message__c = 'Admin – NRO Change Record Requests';
        lSetting.add(mSetting1);
        
        MPOT_Setting__c mSetting2 = new MPOT_Setting__c();
        mSetting2.Name = 'AdminInactiveProjects';
        mSetting2.Message__c = 'Inactive Projects';
        lSetting.add(mSetting2);
        
        MPOT_Setting__c mSetting3 = new MPOT_Setting__c();
        mSetting3.Name = 'AdminMilestoneChangeLogView';
        mSetting3.Message__c = 'Complete Milestone Change Log';
        lSetting.add(mSetting3);
        
        MPOT_Setting__c mSetting4 = new MPOT_Setting__c();
        mSetting4.Name = 'AdminNewRecordRequests';
        mSetting4.Message__c = 'Admin – NRO New Record Requests';
        lSetting.add(mSetting4);
        
        MPOT_Setting__c mSetting5 = new MPOT_Setting__c();
        mSetting5.Name = 'CreateEditPageWithId';
        mSetting5.Message__c = '/apex/MPOT_CreateEditProjectPage?Id=';
        lSetting.add(mSetting5);
        
        MPOT_Setting__c mSetting6 = new MPOT_Setting__c();
        mSetting6.Name = 'DBARole';
        mSetting6.Message__c = 'MPO Database Administrator';
        lSetting.add(mSetting6);
        
        
        MPOT_Setting__c mSetting7 = new MPOT_Setting__c();
        mSetting7.Name = 'NRORole';
        mSetting7.Message__c = 'MPO NRO';
        lSetting.add(mSetting7);
        
        MPOT_Setting__c mSetting8 = new MPOT_Setting__c();
        mSetting8.Name = 'ReadOnlyRole';
        mSetting8.Message__c = 'MPO Read-Only';
        lSetting.add(mSetting8);
        
        MPOT_Setting__c mSetting9 = new MPOT_Setting__c();
        mSetting9.Name = 'PORole';
        mSetting9.Message__c = 'MPO Project Owner/Project Owner Plus';
        lSetting.add(mSetting9);
        
        MPOT_Setting__c mSetting10 = new MPOT_Setting__c();
        mSetting10.Name = 'POPermissionSet';
        mSetting10.Message__c = 'MPOT_ProjectOwner';
        lSetting.add(mSetting10);
        
        MPOT_Setting__c mSetting11 = new MPOT_Setting__c();
        mSetting11.Name = 'POPPermissionset';
        mSetting11.Message__c = 'MPOT_ProjectOwner_Plus';
        lSetting.add(mSetting11);
        
         MPOT_Setting__c mSetting12 = new MPOT_Setting__c();
        mSetting12.Name = 'ViewPageWithId';
        mSetting12.Message__c = '/apex/MPOT_ViewProjectPage?Id=';
        lSetting.add(mSetting12);
        
          MPOT_Setting__c mSetting13 = new MPOT_Setting__c();
        mSetting13.Name = 'GatingSlideWithParentId';
        mSetting13.Message__c = '/apex/MPOT_GatingSlidePage?parentId=';
        lSetting.add(mSetting13);
        
        MPOT_Setting__c mSetting14 = new MPOT_Setting__c();
        mSetting14.Name = 'HomePage';
        mSetting14.Message__c = '/apex/MPOT_HomePage';
        lSetting.add(mSetting14);
        
         MPOT_Setting__c mSetting15 = new MPOT_Setting__c();
        mSetting15.Name = 'ProjectGanttPage';
        mSetting15.Message__c = '/apex/MPOT_ProjectGanttPage?Id=';
        lSetting.add(mSetting15);
        
         MPOT_Setting__c mSetting16 = new MPOT_Setting__c();
        mSetting16.Name = 'CRPageWithId';
        mSetting16.Message__c = '/apex/MPOT_ChangeRecReqPage?Id=';
        lSetting.add(mSetting16);
        
             MPOT_Setting__c mSetting17 = new MPOT_Setting__c();
        mSetting17.Name = 'NewMilestoneWithParentId';
        mSetting17.Message__c = '/apex/MPOT_milestone?parentId=';
        lSetting.add(mSetting17);
        
             MPOT_Setting__c mSetting18 = new MPOT_Setting__c();
        mSetting18.Name = 'NewProjectConnectionWithParentId';
        mSetting18.Message__c = '/apex/MPOT_ProjectConnectionsPage?parentId=';
        lSetting.add(mSetting18);
        
         MPOT_Setting__c mSetting19 = new MPOT_Setting__c();
        mSetting19.Name = 'ViewCRPageWithId';
        mSetting19.Message__c = '/apex/MPOT_ViewCRPage?Id=';
        lSetting.add(mSetting19);
        
        MPOT_Setting__c mSetting20 = new MPOT_Setting__c();
        mSetting20.Name = 'sAdminAP';
        mSetting20.Message__c = '/apex/MPOT_POListViewPage?userRole=Admin&viewName=AdminActiveProjects';
        lSetting.add(mSetting20);
        
         
        MPOT_Setting__c mSetting21 = new MPOT_Setting__c();
        mSetting21.Name = 'sAdminCRR';
        mSetting21.Message__c = '/apex/MPOT_POListViewPage?userRole=Admin&viewName=AdminChangeRecordRequests';
        lSetting.add(mSetting21);
        
        MPOT_Setting__c mSetting22 = new MPOT_Setting__c();
        mSetting22.Name = 'sAdminIP';
        mSetting22.Message__c = '/apex/MPOT_POListViewPage?userRole=Admin&viewName=AdminInactiveProjects';
        lSetting.add(mSetting22);
        
        
        MPOT_Setting__c mSetting23 = new MPOT_Setting__c();
        mSetting23.Name = 'sAdminNRR';
        mSetting23.Message__c = '/apex/MPOT_POListViewPage?userRole=Admin&viewName=AdminNewRecordRequests';
        lSetting.add(mSetting23);
        
        MPOT_Setting__c mSetting24 = new MPOT_Setting__c();
        mSetting24.Name = 'sNROAH';
        mSetting24.Message__c = '/apex/MPOT_POListViewPage?userRole=NRO&viewName=NROActiveOnHold';
        lSetting.add(mSetting24);
        
        MPOT_Setting__c mSetting25 = new MPOT_Setting__c();
        mSetting25.Name = 'sNROCRR';
        mSetting25.Message__c = '/apex/MPOT_POListViewPage?userRole=NRO&viewName=NROChangeRecordRequests';
        lSetting.add(mSetting25);
        
        MPOT_Setting__c mSetting26 = new MPOT_Setting__c();
        mSetting26.Name = 'sPOAP';
        mSetting26.Message__c = '/apex/MPOT_POListViewPage?userRole=PO_POP&viewName=POActiveProjects';
        lSetting.add(mSetting26);
        
        MPOT_Setting__c mSetting27 = new MPOT_Setting__c();
        mSetting27.Name = 'TrainingTemplateLink';
        mSetting27.Message__c = 'http://lillynetcollaboration.global.lilly.com/sites/MPO%20Migration%202016/SitePages/Home.aspx';
        lSetting.add(mSetting27);
        
         MPOT_Setting__c mSetting28 = new MPOT_Setting__c();
        mSetting28.Name = 'createPageLink';
        mSetting28.Message__c = '/apex/MPOT_CreateEditProjectPage';
        lSetting.add(mSetting28);
        
       System.assertNotEquals( lSetting.size() ,0 );
        return lsetting;
    }
    
    

}