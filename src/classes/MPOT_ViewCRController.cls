/*
* @Name: MPOT_ViewCRController
* @Description: Project Change Request Layout of MPOT Project for DBA ,NRO .
* @Author:Deloitte Consulting
*/
public with sharing class MPOT_ViewCRController{
    
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
    public String sIssues{get;set;}
    public String sRadio {get;set;}
    public user currentuser{get;set;}
    private static String mpotProjectRecTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('MPOT Project').getRecordTypeId();
    public Map<String,MPOT_Custom_Field_IDs__c> mCustomFieldId {set;get;}
  
    public MPOT_ViewCRController(ApexPages.StandardController controller){
        
        currentuser=new User();
        currentuser=[Select Id,Name,Email from User where Id=:userinfo.getuserId()];
        sIssues ='';
        sRadio = '';
        hasAttachment = false;
        bIsAdmin = false;
        bIsPO =false;
        mCustomFieldID = MPOT_Custom_Field_IDs__c.getAll();
        bIsNRO = false;
        /*
        set<string> sAssignedPS = MPOT_Util.getPermissionSetNames(userInfo.getUserId());
        if(sAssignedPS.contains('MPOT_Database_Administrator')){
            bIsAdmin =  true;
        }
        if(sAssignedPS.contains('MPOT_NRO')){
            bIsNRO =  true;
        }
          if(sAssignedPS.contains('MPOT_ProjectOwner')||sAssignedPS.contains('MPOT_ProjectOwner_Plus')){
            bIsPO=  true;
        }
        */
        
//Logic to check the logged in user's role
        string sUserRole = MPOT_Util.fetchUserRole();
        if(sUserRole != null && sUserRole != ''){
            if(sUserRole =='MPO Database Administrator'){
                bIsAdmin =  true;
            }
            if(sUserRole =='MPO NRO'){
                bIsNRO =  true;
            }
            
            if(sUserRole =='MPO Project Owner/Project Owner Plus'){
                bIsPO =  true;
            }
            /*
            if(sUserRole =='MPO Read-Only'){
                bIsReadOnly =  true;
            }  */ 
        }
   /*
    *      set<string> sAssignedPS = MPOT_Util.getPermissionSetNames(userInfo.getUserId());
        if(sAssignedPS.contains('MPOT_ProjectOwner') && !sAssignedPS.contains('MPOT_ProjectOwner_Plus') && bIsPO == true){
            bIsOnlyPO =  true;
        }    
    */
        
        
        
        
        sPrjtId = Apexpages.currentPage().getParameters().get('Id');
        if(Apexpages.currentPage().getParameters().containsKey('Id')){
            List<GLBL_Project__c> lPrjt = [select id,RecordTypeId , Name, MPOT_Project_Description__c, MPOT_Project_Driver__c, MPOT_Project_Number__c, OwnerId, MPOT_Project_Scope__c, MPOT_Stage__c,MPOT_Administrative_Comments__c,MPOT_Change_Regulatory_Impact_To__c,   MPOT_Project_Sponsor_Id__c,
                                           MPOT_Changes_Issues__c,MPOT_Regulatory_Impact__c,  MPOT_Project_Owner__c, MPOT_Project_Sponsor__c, MPOT_Network_Project_Initiated_from__c,MPOT_Networks_Project_Impacts__c,MPOT_New_Project_Request_Approved__c,
                                           MPOT_Current_Status__c,MPOT_Current_Status_Color__c,MPOT_Platforms__c, MPOT_Sites__c, MPOT_Owner_Name__c, MPOT_Project_Owner_Id__c, MPOT_Molecules__c, MPOT_NRO_Comments__c, MPOT_NRO_New_Record_Request_Indicator__c, MPOT_Gating_Slide_Exception__c ,LastModifiedById,CreatedById,LastModifiedDate,CreatedDate
                                           ,MPOT_Monthly_Update_Date__c,MPOT_Overdue__c, MPOT_Anchor__c, MPOT_Regulatory_Impact_Level__c, MPOT_Date_Moved_To_Inactive_Status__c,MPOT_Molecule_Name__c,
                                           MPOT_Changed_Project_Name__c,MPOT_Changed_Project_Description__c,MPOT_Changed_Project_Driver__c,MPOT_Changed_Project_Owner__c,MPOT_Changed_Project_Scope__c,
                                            MPOT_Changed_Project_Sponsor__c,MPOT_Changed_Project_Sponsor_Id__c,MPOT_Changed_Project_Owner_Id__c,MPOT_Changed_Owner_Name__c,
                                            MPOT_Changed_Networks_Project_Impacts_Id__c,MPOT_Changed_Networks_Project_Impacts__c,MPOT_Changed_Netwrk_Project_Initiated_Id__c,MPOT_Changed_Netwrk_Proj_Initiated_from__c,
                                            MPOT_Changed_Molecule_Id__c,MPOT_Changed_Molecule_Name__c,MPOT_Changed_Molecule__c,
                                            MPOT_Changed_Sites_Id__c,MPOT_Changed_Sites__c,MPOT_Changed_Platforms_Id__c,MPOT_Changed_Platforms__c,MPOT_Changed_Stage__c,MPOT_Changed_Anchor__c, MPOT_CHanged_Regulatory_Impact_Level__c,
                                           MPOT_NRO_Change_Record_Request_Indicator__c,MPOT_NRO_CR_Approved_Indicator__c,MPOT_NRO_CR_Created_Indicator__c,MPOT_Changed_NRO_Comments__c,MPOT_Change_Requested_By__c,
                                           MPOT_Network_Project_Initiated_from_Id__c,MPOT_Networks_Project_Impacts_Id__c,MPOT_Platforms_Id__c,MPOT_Sites_Id__c, MPOT_Submission_Date__c,
                                           MPOT_Molecule_Id__c
                                           from GLBL_Project__c where Id=: sPrjtId AND RecordTypeId =:mpotProjectRecTypeId ];
            oProject = lPrjt[0];
            if(oProject.OwnerId == userInfo.getUserId()){
                bIsOwner = true;
            }
           
          
        }
        
        
    }
    
   /* 
     * Method name : submitCR
     * Description :  method to Submit Change request to the DBA 
     * Param :  none
     * Returns :  PageReference 
    */   
     
    public PageReference submitCR(){  
        oProject.MPOT_NRO_Change_Record_Request_Indicator__c = true;
         if (Schema.sObjectType.GLBL_Project__c.isUpdateable()){
          oProject.MPOT_Submission_Date__c = System.today();
         update oProject;
         }

      
        pageRef =  new PageReference('/apex/MPOT_ViewCRPage?Id='+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
     /* 
     * Method name : approveCR
     * Description :  method to Approve Change request by the DBA , and adding the changed values to the Project record
     * Param :  none
     * Returns :  PageReference 
    */ 
    
      public PageReference approveCR(){
         
         List<MPOT_Change_Log__c> lLogs = new List<MPOT_Change_Log__c>();
          MPOT_Change_Log__c projLog = new MPOT_Change_Log__c(); 
          projLog.RecordTypeId = [Select Id,SobjectType,Name From RecordType WHERE DeveloperName ='MPOT_Project' and SobjectType ='MPOT_Change_Log__c' limit 1].Id;
          if(oProject.Name != oProject.MPOT_Changed_Project_Name__c)
          {
            projLog.Project_Name__c = oProject.Name;
          }
          
          if(oProject.MPOT_Project_Description__c != oProject.MPOT_Changed_Project_Description__c )
          {
            projLog.Project_Description__c = oProject.MPOT_Project_Description__c;
          }
          
          if(oProject.MPOT_Project_Driver__c != oProject.MPOT_Changed_Project_Driver__c )
          {
            projLog.Project_Driver__c = oProject.MPOT_Project_Driver__c;
          }
          
          if(oProject.MPOT_Project_Scope__c != oProject.MPOT_Changed_Project_Scope__c )
          {
            projLog.Project_Scope__c = oProject.MPOT_Project_Scope__c;
          }        
          
          if((oProject.MPOT_Project_Sponsor__c != oProject.MPOT_Changed_Project_Sponsor__c) )
          {
            projLog.Project_Sponsor__c = oProject.MPOT_Project_Sponsor__c;
          }
          
          if(oProject.MPOT_Stage__c != oProject.MPOT_Changed_Stage__c  )
          {
            projLog.Project_Stage__c = oProject.MPOT_Stage__c;
          }
         
         if(oProject.MPOT_Anchor__c!= oProject.MPOT_Changed_Anchor__c)
          {
            projLog.Previous_Anchor__c= oProject.MPOT_Anchor__c;
          }
          
           if(oProject.MPOT_Regulatory_Impact_Level__c!= oProject.MPOT_Changed_Regulatory_Impact_Level__c)
          {
            projLog.Previous_Regulatory_Impact_Level__c= oProject.MPOT_Regulatory_Impact_Level__c;
          }
          
        
          if((oProject.MPOT_Project_Owner_Id__c != oProject.MPOT_Changed_Project_Owner_Id__c) || 
            (oProject.MPOT_Owner_Name__c != oProject.MPOT_Changed_Owner_Name__c) ||
            (oProject.MPOT_Project_Owner__c != oProject.MPOT_Changed_Project_Owner_Id__c))
          {
              projLog.Project_Owner__c = oProject.MPOT_Owner_Name__c;
              
          }
              
          if((oProject.MPOT_Network_Project_Initiated_from_Id__c != oProject.MPOT_Changed_Netwrk_Project_Initiated_Id__c) ||
            (oProject.MPOT_Network_Project_Initiated_from__c != oProject.MPOT_Changed_Netwrk_Proj_Initiated_from__c))
          {
              projLog.Network_Project_Initiated_from__c = oProject.MPOT_Network_Project_Initiated_from__c;   
          }
          
          if((oProject.MPOT_Networks_Project_Impacts_Id__c != oProject.MPOT_Changed_Networks_Project_Impacts_Id__c) ||
            (oProject.MPOT_Networks_Project_Impacts__c != oProject.MPOT_Changed_Networks_Project_Impacts__c))
          {
              projLog.Networks_Project_Impacts__c = oProject.MPOT_Networks_Project_Impacts__c;   
          }
          
          if((oProject.MPOT_Platforms_Id__c != oProject.MPOT_Changed_Platforms_Id__c) ||
            (oProject.MPOT_Platforms__c != oProject.MPOT_Changed_Platforms__c))
          {
              projLog.Platforms_Impacted__c =oProject.MPOT_Platforms__c;   
          }
          
          if((oProject.MPOT_Sites_Id__c != oProject.MPOT_Changed_Sites_Id__c) ||
            (oProject.MPOT_Sites__c != oProject.MPOT_Changed_Sites__c))
          {
              projLog.Sites_Impacted__c  =oProject.MPOT_Sites__c;  
          }
          
          if((oProject.MPOT_Molecule_Id__c != oProject.MPOT_Changed_Molecule_Id__c ) ||
            (oProject.MPOT_Molecule_Name__c != oProject.MPOT_Changed_Molecule_Name__c) ||
            (oProject.MPOT_Molecules__c != oProject.MPOT_Changed_Molecule__c ))
          {
              projLog.Molecules_Impacted__c = oProject.MPOT_Molecule_Name__c;  
          }
          
          if(oProject.MPOT_Regulatory_Impact__c != oProject.MPOT_Change_Regulatory_Impact_To__c)
          {
            projLog.Regulatory_Impact__c = oProject.MPOT_Regulatory_Impact__c;
          }
          
          projLog.Project_NRO_Comments__c = oProject.MPOT_Changed_NRO_Comments__c;
          projLog.Change_Requested_by__c = oProject.MPOT_Change_Requested_By__c;
         // projLog.Regulatory_Impact__c= oProject.MPOT_Change_Regulatory_Impact_To__c;
          projLog.Project__c = oProject.Id;    
          projLog.MPOT_Submission_Date__c = oProject.MPOT_Submission_Date__c;   
           
          projLog.Date_Change_Approved__c = System.today(); 
          lLogs.add(projLog);
          insert lLogs;

          oProject.MPOT_NRO_CR_Approved_Indicator__c = true;
          oProject.MPOT_NRO_CR_Created_Indicator__c = false;

        //populating the Original fields with the change request fields and making the change request fields blank
        if(oProject.MPOT_NRO_Change_Record_Request_Indicator__c == true ){
            oProject.Name = oProject.MPOT_Changed_Project_Name__c ;
            oProject.MPOT_Project_Description__c = oProject.MPOT_Changed_Project_Description__c ;
            oProject.MPOT_Project_Driver__c = oProject.MPOT_Changed_Project_Driver__c ;
            oProject.MPOT_Project_Scope__c = oProject.MPOT_Changed_Project_Scope__c ;
            
            oProject.MPOT_Project_Sponsor__c = oProject.MPOT_Changed_Project_Sponsor__c ;
            oProject.MPOT_Project_Sponsor_Id__c = oProject.MPOT_Changed_Project_Sponsor_Id__c ;  
       
            oProject.MPOT_Networks_Project_Impacts_Id__c= oProject.MPOT_Changed_Networks_Project_Impacts_Id__c ;
            oProject.MPOT_Networks_Project_Impacts__c = oProject.MPOT_Changed_Networks_Project_Impacts__c ;
            oProject.MPOT_Network_Project_Initiated_from_Id__c = oProject.MPOT_Changed_Netwrk_Project_Initiated_Id__c ;
            oProject.MPOT_Network_Project_Initiated_from__c = oProject.MPOT_Changed_Netwrk_Proj_Initiated_from__c ;
            oProject.MPOT_Regulatory_Impact__c = oProject.MPOT_Change_Regulatory_Impact_To__c;
            oProject.MPOT_Molecule_Id__c = oProject.MPOT_Changed_Molecule_Id__c ;
            oProject.MPOT_Molecule_Name__c = oProject.MPOT_Changed_Molecule_Name__c ;
            oProject.MPOT_Molecules__c = oProject.MPOT_Changed_Molecule__c ;
            oProject.MPOT_Sites_Id__c= oProject.MPOT_Changed_Sites_Id__c  ;
            oProject.MPOT_Sites__c = oProject.MPOT_Changed_Sites__c ;
            oProject.MPOT_Platforms_Id__c = oProject.MPOT_Changed_Platforms_Id__c  ;
            oProject.MPOT_Platforms__c = oProject.MPOT_Changed_Platforms__c ;
            
            oProject.MPOT_Project_Owner_Id__c = oProject.MPOT_Changed_Project_Owner_Id__c ; 
            oProject.MPOT_Owner_Name__c = oProject.MPOT_Changed_Owner_Name__c ;
            oProject.MPOT_Project_Owner__c = oProject.MPOT_Changed_Project_Owner_Id__c;
            //oProject.MPOT_NRO_Comments__c = oProject.MPOT_Changed_NRO_Comments__c;
        
            oProject.MPOT_Stage__c = oProject.MPOT_Changed_Stage__c ;
            oProject.MPOT_Anchor__c= oProject.MPOT_Changed_Anchor__c;
            oProject.MPOT_Regulatory_Impact_Level__c =  oProject.MPOT_Changed_Regulatory_Impact_Level__c;
            
            
            clearCRValues();
        
            }  
            
            

           if (Schema.sObjectType.GLBL_Project__c.isUpdateable()){
             update oProject;
           }
          
        //moving the gating slides from project CR lookup to projecCR and clearing out the project CR lookup
        List<MPOT_Project_Gating_Slide_File__c> lGatingSlide = [select Id,ProjectCR__c,Project__c from MPOT_Project_Gating_Slide_File__c where ProjectCR__c =: oProject.Id ];
        for(MPOT_Project_Gating_Slide_File__c  GatingSlideObj : lGatingSlide)
        {
            GatingSlideObj.Project__c = GatingSlideObj.ProjectCR__c;
            GatingSlideObj.ProjectCR__c = null;
        }
         if (Schema.sObjectType.MPOT_Project_Gating_Slide_File__c.isUpdateable()){
         update lGatingSlide;
         }  
     
        pageRef =  new PageReference('/apex/MPOT_ViewProjectPage?Id='+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /* 
     * Method name : deleteCR
     * Description :  method for deleting CR
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference deleteCR()
    {
        //clearing the CR values 
        clearCRValues();
        //oProject.MPOT_NRO_CR_Approved_Indicator__c = true;
        oProject.MPOT_NRO_CR_Created_Indicator__c = false;
        oProject.MPOT_NRO_Change_Record_Request_Indicator__c = false;
        if (Schema.sObjectType.GLBL_Project__c.isUpdateable()){
             update oProject;
           }
        
        //delete the gating slides associated with the CR
        List<MPOT_Project_Gating_Slide_File__c> lGatingSlide = [select Id,ProjectCR__c,Project__c from MPOT_Project_Gating_Slide_File__c where ProjectCR__c =: oProject.Id ];
        try{
            delete lGatingSlide;  
        }
         catch (DmlException e) {
            ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(0));
            ApexPages.addMessage(msg);
            return null;
         }
        pageRef =  new PageReference('/apex/MPOT_ViewProjectPage?Id='+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /* 
     * Method name : clearCRValues
     * Description :  method for clearing CR values after they are added to the Project record
     * Param :  none
     * Returns :  PageReference 
    */ 
    public void clearCRValues()
    {
       //Changed Request fields to blank -clearing off the values
            oProject.MPOT_Changed_Project_Name__c = '';
            oProject.MPOT_Changed_Project_Description__c = '';
            oProject.MPOT_Changed_Project_Driver__c = '';
            oProject.MPOT_Changed_Project_Scope__c = '';
            
            oProject.MPOT_Changed_Project_Sponsor__c = '' ;
            oProject.MPOT_Changed_Project_Sponsor_Id__c = '' ;  
            oProject.MPOT_Changed_Project_Owner_Id__c = '' ; 
            oProject.MPOT_Changed_Owner_Name__c = '' ;
            
            oProject.MPOT_Changed_Project_Owner_Id__c =''; 
            oProject.MPOT_Changed_Owner_Name__c='' ;
            oProject.MPOT_Changed_Project_Owner__c = null;
            
            oProject.MPOT_Changed_Networks_Project_Impacts_Id__c = '' ;
            oProject.MPOT_Changed_Networks_Project_Impacts__c = '' ;
            oProject.MPOT_Changed_Netwrk_Project_Initiated_Id__c = '' ;
            oProject.MPOT_Changed_Netwrk_Proj_Initiated_from__c = '' ;
            
            oProject.MPOT_Changed_Molecule_Id__c = '' ;
            oProject.MPOT_Changed_Molecule_Name__c = '' ;
            oProject.MPOT_Changed_Molecule__c = '' ;
            oProject.MPOT_Changed_Sites_Id__c = '' ;
            oProject.MPOT_Changed_Sites__c = '' ;
            oProject.MPOT_Changed_Platforms_Id__c = '' ;
            oProject.MPOT_Changed_Platforms__c = '' ;
            oProject.MPOT_Changed_Stage__c = '';
            oProject.MPOT_Change_Regulatory_Impact_To__c= '';
            oProject.MPOT_Changed_NRO_Comments__c = ''; 
            
                oProject.MPOT_Changed_Anchor__c= '';
                 oProject.MPOT_Changed_Regulatory_Impact_Level__c = '';
                 oProject.MPOT_Submission_Date__c = null;
    }
     /* 
     * Method name : editCR
     * Description :  method for Editing CR values 
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference editCR(){
       pageRef =  new PageReference('/apex/MPOT_ChangeRecReqPage?Id='+oProject.id);
        pageRef.setRedirect(true);
        return pageRef;  
         
     }
    
     /* 
     * Method name : newGatingSlide
     * Description :  method for redirecting to Gating Slide
     * Param :  none
     * Returns :  PageReference 
    */ 
    public PageReference newGatingSlide(){
      pageRef  = new PageReference('/apex/MPOT_GatingSlidePage?parentCRId='+oProject.id);
        //pRedirectObjectPageReference.getParameters().put('retURL','/'+ oProject.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /* 
     * Method name : showPopUP
     * Description :  method to show Pop up
     * Param :  none
     * Returns :  void 
    */ 
    public void showPopUP(){
        popUp =true;
    }
    
    /* 
     * Method name : closePopup
     * Description :  method to Close pop up
     * Param :  none
     * Returns :  void 
    */ 
    public void closePopup(){
        popUp=false;
    }
       
}