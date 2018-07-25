/*
* @Name: MPOT_ViewProjectController
* @Description: Project View Layout of MPOT Project for DBA ,NRO ,PO/PO+
* @Author:Deloitte Consulting
*/
public with sharing class MPOT_ViewProjectController{

    public string sPrjtId {get;set;}
    public GLBL_Project__c oProject{get; set;}
    public MPOT_Project_Milestone__c oPMilestone{get; set;}
    public string userName{get;set;}
    public PageReference pageRef;
    public boolean bIsAdmin{get;set;}
    public boolean bIsNRO{get;set;}
    public boolean bIsPO{get;set;}
    public boolean bIsOwner{get;set;}
    public boolean hasAttachment{get;set;}
    public boolean popUp{get;set;}
    public boolean bApproved{get;set;}
    public String sIssues{get;set;}
    public String sRadio {get;set;}
    public user currentuser{get;set;}
    public boolean bIsOnlyPO{get;set;}
    public boolean popUp1{get;set;}
    public boolean bIsRltdPrjtOwner{get;set;}
    public boolean bIsReadOnly{get;set;}
    private static String mpotProjectRecTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('MPOT Project').getRecordTypeId();
    public Map<String,MPOT_Custom_Field_IDs__c> mCustomFieldId {set;get;}
  
    public MPOT_ViewProjectController(ApexPages.StandardController controller){
        
        currentuser=new User();
        currentuser=[Select Id,Name,Email from User where Id=:userinfo.getuserId()];
        sIssues ='';
        sRadio = '';
        hasAttachment = false;
        bIsAdmin = false;
        bIsPO =false;
        bIsOnlyPO = false;
        bIsReadOnly = false;
        bIsRltdPrjtOwner = false;
        mCustomFieldID = MPOT_Custom_Field_IDs__c.getAll();
        bIsNRO = false;
        bApproved = false;
        //Logic to check the logged in user's role
        string sUserRole = MPOT_Util.fetchUserRole();
        if(sUserRole != null && sUserRole != ''){
            if(sUserRole == MPOT_Setting__c.getValues('DBARole').Message__c){
                bIsAdmin =  true;
            }
            if(sUserRole == MPOT_Setting__c.getValues('NRORole').Message__c){
                bIsNRO =  true;
            }
            if(sUserRole == MPOT_Setting__c.getValues('PORole').Message__c){
                bIsPO =  true;
            }
            if(sUserRole == MPOT_Setting__c.getValues('ReadOnlyRole').Message__c){
                bIsReadOnly =  true;
            }   
        }
        set<string> sAssignedPS = MPOT_Util.getPermissionSetNames(userInfo.getUserId());
        if(sAssignedPS.contains(MPOT_Setting__c.getValues('POPermissionSet').Message__c) && !sAssignedPS.contains(MPOT_Setting__c.getValues('POPPermissionset').Message__c) && bIsPO == true){
            bIsOnlyPO =  true;
        }
      
       
       // sPrjtId = Apexpages.currentPage().getParameters().get('Id');
        if(Apexpages.currentPage().getParameters().containsKey('Id')){
            List<GLBL_Project__c> lPrjt = [select id, Name,RecordTypeId , MPOT_Project_Description__c, MPOT_Project_Driver__c, MPOT_Project_Number__c, OwnerId, MPOT_Project_Scope__c, MPOT_Stage__c,MPOT_Administrative_Comments__c,
                                           MPOT_Changes_Issues__c,MPOT_Regulatory_Impact__c, MPOT_Anchor__c , MPOT_Regulatory_Impact_Level__c, MPOT_Project_Owner__c, MPOT_Project_Sponsor__c, MPOT_Network_Project_Initiated_from__c,MPOT_Networks_Project_Impacts__c,MPOT_New_Project_Request_Approved__c,
                                           MPOT_Current_Status__c,MPOT_Current_Status_Color__c,MPOT_Platforms__c, MPOT_Sites__c, MPOT_Owner_Name__c, MPOT_Project_Owner_Id__c, MPOT_NRO_Comments__c, MPOT_NRO_New_Record_Request_Indicator__c, MPOT_Gating_Slide_Exception__c ,LastModifiedById,CreatedById,LastModifiedDate,CreatedDate
                                           ,MPOT_Regulatory_Umbrella_Project_Name__c,MPOT_Link_to_Regulatory_RIVER_System_LT__c,MPOT_Molecule_Name__c,MPOT_Monthly_Update_Date__c,MPOT_Overdue__c,MPOT_Date_Moved_To_Inactive_Status__c,
                                           MPOT_Don_t_Send_Mail__c, MPOT_NRO_Change_Record_Request_Indicator__c,MPOT_NRO_CR_Approved_Indicator__c,MPOT_NRO_CR_Created_Indicator__c
                                           from GLBL_Project__c where Id=:Apexpages.currentPage().getParameters().get('Id')  AND RecordTypeId =:mpotProjectRecTypeId ];
            if(lPrjt.size() >0){
            sPrjtId = lPrjt[0].Id;
            oProject = lPrjt[0];
            }
            if(oProject.OwnerId == userInfo.getUserId()){
                bIsOwner = true;
            }
            if(oProject.MPOT_Project_Owner__c == userInfo.getUserId()){
                bIsRltdPrjtOwner = true;            
            }
              if (oProject.MPOT_New_Project_Request_Approved__c == true){
            bApproved = true ;
            }
            
        }
      
        
    }
     /* 
     * Method name : submitProject
     * Description :  method to Submit Project to the DBA 
     * Param :  none
     * Returns :  PageReference 
    */
   public PageReference submitProject(){
        
        List<MPOT_Project_Gating_Slide_File__c> lGatingSlide = [select Id,(Select id from Attachments) from MPOT_Project_Gating_Slide_File__c where Project__c =: oProject.Id ];
        for(MPOT_Project_Gating_Slide_File__c  GatingSlideObj : lGatingSlide)
        {
            for(Attachment attObj : GatingSlideObj.Attachments)
            {
                hasAttachment = true;
                break;
            }
        }
        
        //If a project gating slide record exists and attachment exists on the gating slide 
        if(hasAttachment == true ){
            oProject.MPOT_NRO_New_Record_Request_Indicator__c = true;
            update oProject;
            pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
            pageRef.setRedirect(true);
            return pageRef;
        }
        //if no record for gating slide and attacchment exists then check if it is an exception
        else 
        {
            //Checking if it is an exception
            if (oProject.MPOT_Gating_Slide_Exception__c == true )
            {
                oProject.MPOT_NRO_New_Record_Request_Indicator__c = true;
                update oProject;
                pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else{
                pagereference p = apexpages.Currentpage();
                apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Gating slides need to be attached prior to submitting the New Record Request');
                apexpages.addmessage(msg);
                //p.setRedirect(true);
                //return p;
            }
        }
        return null;
    }
    
     /* 
     * Method name : approveProject
     * Description :  method to Approve Project by DBA 
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference approveProject(){
        oProject.MPOT_New_Project_Request_Approved__c= true;
        
        if(oProject.MPOT_Monthly_Update_Date__c ==null){
        oProject.MPOT_Monthly_Update_Date__c = System.today();
        }
        
        update oProject;
        // pageRef =  new PageReference('/a3A?fcf='+System.Label.MPOT_List_view_url);
        pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
     /* 
     * Method name : newGatingSlide
     * Description :  method to redirect to new Gating Slide
     * Param :  none
     * Returns :  PageReference 
    */ 
    
    public PageReference newGatingSlide(){
        //PageReference pRedirectObjectPageReference = new PageReference('/' + MPOT_Project_Gating_Slide_File__c.sObjectType.getDescribe().getKeyPrefix()+ '/e');
        //pRedirectObjectPageReference.getParameters().put('nooverride', '1'); 
        //pRedirectObjectPageReference.getParameters().put('CF'+mCustomFieldID.get('Project__c').Field_id__c, oProject.name);//field id  
        //pRedirectObjectPageReference.getParameters().put('CF'+mCustomFieldID.get('Project__c').Field_id__c+'_lkid',oProject.id); 
        pageRef  = new PageReference(MPOT_Setting__c.getValues('GatingSlideWithParentId').Message__c+oProject.id);
        //pRedirectObjectPageReference.getParameters().put('retURL','/'+ oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
      /* 
     * Method name : newMilestone
     * Description :  method to redirect to new milestone
     * Param :  none
     * Returns :  PageReference 
    */ 
     public PageReference newMilestone(){
        pageRef  = new PageReference(MPOT_Setting__c.getValues('NewMilestoneWithParentId').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     /* 
     * Method name : newProjectConnection
     * Description :  method to redirect to new Project Connection
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference newProjectConnection(){
        //PageReference pRedirectObjectPageReference = new PageReference('/' + MPOT_Project_Gating_Slide_File__c.sObjectType.getDescribe().getKeyPrefix()+ '/e');
        //pRedirectObjectPageReference.getParameters().put('nooverride', '1'); 
        //pRedirectObjectPageReference.getParameters().put('CF'+mCustomFieldID.get('Project__c').Field_id__c, oProject.name);//field id  
        //pRedirectObjectPageReference.getParameters().put('CF'+mCustomFieldID.get('Project__c').Field_id__c+'_lkid',oProject.id); 
        pageRef  = new PageReference(MPOT_Setting__c.getValues('NewProjectConnectionWithParentId').Message__c+oProject.id);
        //pRedirectObjectPageReference.getParameters().put('retURL','/'+ oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
      /* 
     * Method name : cancelProject
     * Description :  method to delete Project Gating Slide
     * Param :  none
     * Returns :  PageReference 
    */ 

    public PageReference cancelProject() {
        List<MPOT_Project_Gating_Slide_File__c> lGating = [select Id from MPOT_Project_Gating_Slide_File__c where Project__c =: oProject.Id];
        if(lGating.size() > 0){
            Database.Delete(lGating, false);
        }
        Database.Delete(oProject.Id , false);
        //String keyPrefix = GLBL_Project__c.sObjectType.getDescribe().getKeyPrefix();
        //pageRef =  new PageReference('/'+keyPrefix+'/o');
        pageRef =  new PageReference(MPOT_Setting__c.getValues('HomePage').Message__c);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
      /* 
     * Method name : editProject
     * Description :  method to Edit Project Record
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference editProject() {
        pageRef =  new PageReference(MPOT_Setting__c.getValues('CreateEditPageWithId').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
      /* 
     * Method name : changeRecReq
     * Description :  method to redirect to Change Request Record
     * Param :  none
     * Returns :  PageReference 
    */ 
    
    public PageReference changeRecReq() {
        //resetting the submit and approve indicator before creating a new req 
        oProject.MPOT_Change_Requested_By__c = currentuser.Name;
        
        oProject.MPOT_NRO_CR_Approved_Indicator__c = false;   
        oProject.MPOT_NRO_Change_Record_Request_Indicator__c = false;
        oProject.MPOT_NRO_CR_Approved_Indicator__c = false;
        update oProject;
        pageRef =  new PageReference(MPOT_Setting__c.getValues('CRPageWithId').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
      /* 
     * Method name : RedirectToGantt
     * Description :  method to redirect to Gantt Chart
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference RedirectToGantt(){
        pageRef =  new PageReference(MPOT_Setting__c.getValues('ProjectGanttPage').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    
      /* 
     * Method name : confirmMonthlyUpdate
     * Description :  method for Monthly update Confirmation
     * Param :  none
     * Returns :  PageReference 
    */ 
 
    public pageReference confirmMonthlyUpdate(){
    try{
         if(sRadio != '' && sRadio != null && !String.isBlank(sIssues)){
             if(oProject.MPOT_Don_t_Send_Mail__c != false){
                 oProject.MPOT_Don_t_Send_Mail__c = false;
             }
             
             oProject.MPOT_Current_Status__c = sRadio ;
             oProject.MPOT_Changes_Issues__c = sIssues;
             oProject.MPOT_Monthly_Update_Date__c = System.Today();
             update oProject;
             popUp=false;
             
             //Inserting Monthly Logs
             MPOT_Monthly_Update_Change_Log__c monthlyLog = new MPOT_Monthly_Update_Change_Log__c();
             monthlyLog.Date__c = System.now();
             monthlyLog.Issues_Changes__c = oProject.MPOT_Changes_Issues__c;
             monthlyLog.Project__c = oProject.id;
             monthlyLog.Status__c = sRadio;
             monthlyLog.User__c = UserInfo.getUserId();
             System.debug('Before updating Monthly log::::Bala::'+sRadio);
             System.debug('Bala:: Monthly log:: issues:::'+oProject.MPOT_Changes_Issues__c);
             insert monthlyLog;
             
             System.debug('after inserting Bala::::');
             
             
             
             
             pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
             pageRef.setRedirect(true);
             return pageRef;
           }else{
             pagereference p = apexpages.Currentpage();
             if(String.isBlank(sRadio)){
             apexpages.Message msg1 = new Apexpages.Message(ApexPages.Severity.ERROR,'You need to enter values in order to confirm the monthly update');
             apexpages.addmessage(msg1);
             }else if(String.isBlank(sIssues)){
             
              apexpages.Message msg1 = new Apexpages.Message(ApexPages.Severity.ERROR,'A status of red or yellow required that an updated explanation be provided in “Issues/Changes” explaining why the current timeline is at risk (yellow) or cannot be met (red).');
             apexpages.addmessage(msg1);
             
             }
             return p;
           }
      }catch(exception ex){
            Pagereference p = apexpages.Currentpage();
            ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
            ApexPages.addMessage(msg);
            return p;
      }
        
    }
    
     /* 
     * Method name : showPopUP
     * Description :  method to Show Pop up Box for monthly update
     * Param :  none
     * Returns :  void 
    */ 
    public void showPopUP(){
        popUp =true;
    }
    
      /* 
     * Method name : closePopup
     * Description :  method to Close Pop up Box
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference closePopup(){
        popUp=false;
        pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     /* 
     * Method name : showPopUP
     * Description :  method to Show Pop up Box for river system
     * Param :  none
     * Returns :  void 
    */ 
      public void showPopUP1(){
        popUp1 =true;
    }
    
    /* 
     * Method name : closePopup
     * Description :  method to Close Pop up Box for River System
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference closePopup1(){
        popUp1 =false;
        pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /* 
     * Method name : getStatusValues
     * Description :  method to get MPOT_Current_Status__c picklist values
     * Param :  none
     * Returns :  list<SelectOption>
    */ 
    public list<SelectOption> getStatusValues(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = GLBL_Project__c.MPOT_Current_Status__c.getDescribe();
        List<Schema.PicklistEntry> statusValues = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : statusValues )
           {
              options.add(new SelectOption(f.getLabel(), f.getValue()));
           }     
           
         return options;

    }
   /* 
     * Method name : confirmRIVERsystem
     * Description :  method to confirm RIVER system
     * Param :  none
     * Returns : pageReference 
    */ 
     public pageReference confirmRIVERsystem(){
  
            update oProject;
            popUp1=false;
            pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
            pageRef.setRedirect(true);
            return pageRef;
       
    }
     /* 
     * Method name : viewCRReq
     * Description :  method to redirect to CR request
     * Param :  none
     * Returns : pageReference 
    */ 
    public PageReference viewCRReq(){
        pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewCRPageWithId').Message__c+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }

}