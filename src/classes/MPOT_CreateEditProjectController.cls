/*
* @Name: MPOT_CreateEditProjectController
* @Description: Controller Class for new      Project creation by NRO 
* @Author:Deloitte Consulting
*/

public with sharing class MPOT_CreateEditProjectController{

//Commit 2
    public string sPrjtId {get;set;}
    public GLBL_Project__c oProject{get; set;}
    public String oProjectPlaceHolder{get; set;}
    public string userName{get;set;}
    public PageReference pageRef;
    public map<Id,String> SiteValues{get;set;}
    public boolean bIsAdmin{get;set;}
    public boolean bIsNRO{get;set;}
    public boolean bIsOwner{get;set;}
    public String newSponsor{get;set;}
    public Id oldOwner{get;set;}
    private static String mpotProjectRecTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('MPOT Project').getRecordTypeId();

    public MPOT_CreateEditProjectController(ApexPages.StandardController controller){

            bIsAdmin = false;
            bIsNRO = false;
            bIsOwner = false;
            oProjectPlaceHolder = 'Select a value from the value list...';
           
            sPrjtId = Apexpages.currentPage().getParameters().get('Id');
            if(Apexpages.currentPage().getParameters().containsKey('Id')){
                List<GLBL_Project__c> lPrjt = [select id, Name, RecordTypeId, MPOT_Project_Description__c, MPOT_Project_Driver__c,MPOT_Owner_Name__c,
                                              MPOT_Project_Number__c, OwnerId, MPOT_Anchor__c , MPOT_Regulatory_Impact_Level__c, MPOT_Project_Scope__c,MPOT_Administrative_Comments__c,
                                              MPOT_Stage__c,MPOT_Regulatory_Impact__c, MPOT_NRO_Comments__c,MPOT_Networks_Project_Impacts_Id__c,
                                              MPOT_Project_Owner__c, Owner.Name, MPOT_Project_Sponsor__c, MPOT_Network_Project_Initiated_from__c,MPOT_Network_Project_Initiated_from_Id__c,
                                              MPOT_Networks_Project_Impacts__c,MPOT_Platforms__c,MPOT_Molecule_Name__c,MPOT_Molecule_Id__c,
                                              MPOT_Current_Status__c,MPOT_Current_Status_Color__c,MPOT_Sites__c, MPOT_Network_Record_Owner_Id__c , MPOT_Network_Record_Owner_Name__c, MPOT_Add_new_Sponsor__c , MPOT_Project_Sponsor_Id__c, MPOT_Project_Owner_Id__c,MPOT_Gating_Slide_Exception__c,MPOT_Platforms_Id__c,MPOT_Sites_Id__c,CreatedById,LastModifiedById,MPOT_Monthly_Update_Date__c,MPOT_Date_Moved_To_Inactive_Status__c 
                                              from GLBL_Project__c where Id=: sPrjtId AND RecordTypeId=:mpotProjectRecTypeId ];
                oProject = lPrjt[0];
                userName = oProject.Owner.name;
                oldOwner = oProject.MPOT_Project_Owner_Id__c;
            }
            else{
                oProject = new GLBL_Project__c();
                oProject.OwnerId = userInfo.getUserId();
                oProject.RecordTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('MPOT Project').getRecordTypeId();
            }
            if(oProject.OwnerId == userInfo.getUserId()){
                bIsOwner = true;
            }
        }
    /* 
     * Method name : redirectOnComplete
     * Description :  Method to redirect after creation of record
     * Param :  none
     * Returns :  PageReference 
    */      
        public PageReference redirectOnComplete(){
            //try{
              
                string sUserRole = MPOT_Util.fetchUserRole();
                if(sUserRole != null && sUserRole != ''){
                    if(sUserRole == MPOT_Setting__c.getValues('DBARole').Message__c){
                        bIsAdmin =  true;
                    }
                    if(sUserRole == MPOT_Setting__c.getValues('NRORole').Message__c){
                        bIsNRO =  true;
                    }
                }
                if(!(bIsAdmin) && !(bIsNRO)){
                    pageRef =  new PageReference( MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
                else if(bIsNRO && !bIsOwner){
                    pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
                    pageRef.setRedirect(true);
                    return pageRef;
                }
                else if(bIsNRO && bIsOwner && Apexpages.currentPage().getParameters().containsKey('Id')){
                    List<GLBL_Project__c> lPrjt = [select id, Name,MPOT_New_Project_Request_Approved__c from GLBL_Project__c where Id=: Apexpages.currentPage().getParameters().get('Id') AND RecordTypeId=:mpotProjectRecTypeId];
                    if(lPrjt.size() > 0 && lPrjt[0].MPOT_New_Project_Request_Approved__c){
                        pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
                        pageRef.setRedirect(true);
                        return pageRef;
                    }
                }
                return null;
         /*   }
            catch(Exception ex){
                ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
                ApexPages.addMessage(msg);
            return null;
            }*/
        }
        
    /* 
     * Method name : saveProject
     * Description :  Method to  save project record
     * Param :  none
     * Returns :  PageReference 
    */  
        public PageReference saveProject(){
            try{
                    if(oProject.MPOT_Project_Owner_Id__c != null && oProject.MPOT_Project_Owner_Id__c != ''){
                    if(oProject.MPOT_Project_Owner_Id__c != oProject.MPOT_Project_Owner__c){
                        oProject.MPOT_Project_Owner__c = oProject.MPOT_Project_Owner_Id__c;
                    }
                }
                else{
                    oProject.MPOT_Project_Owner__c = oProject.MPOT_Project_Owner_Id__c;
                }

                if (oProject.MPOT_Add_new_Sponsor__c != null && oProject.MPOT_Add_new_Sponsor__c != '' && oProject.MPOT_Project_Sponsor__c != oProject.MPOT_Add_new_Sponsor__c ){
                    oProject.MPOT_Project_Sponsor_Id__c = oProject.MPOT_Add_new_Sponsor__c;
                    oProject.MPOT_Project_Sponsor__c = oProject.MPOT_Add_new_Sponsor__c;
                    oProject.MPOT_Add_new_Sponsor__c ='';
                }

                if(oProject.MPOT_Network_Record_Owner_Id__c != null && oProject.MPOT_Network_Record_Owner_Id__c != '' && oProject.MPOT_Network_Record_Owner_Id__c != oProject.OwnerId){
                    oProject.OwnerId = oProject.MPOT_Network_Record_Owner_Id__c ;
                }
                else{
                    oProject.MPOT_Network_Record_Owner_Id__c = oProject.OwnerId; 
                    
                }

                upsert oProject;
                pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
                pageRef.setRedirect(true);
                return pageRef;
            }
            catch(Exception ex){
                ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
                ApexPages.addMessage(msg);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Line ' + idx + ' - one of email or phone must be defined'));
                return null;
            }

        }
     /* 
     * Method name : getMolecules
     * Description :  Remote Action method to get the map values of Molcules id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */  
       
        @RemoteAction
        public static Map<id,string> getMolecules(){
            return MPOT_Util.returnGlblValues('Molecules');
        }
     /* 
     * Method name : getSites
     * Description :  Remote Action method to get the map values of Site id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */  
       
        @RemoteAction
        public static Map<id,string> getSites(){
            return  MPOT_Util.returnGlblValues('Sites');
        }
  /* 
     * Method name : getPlatforms
     * Description :  Remote Action  method to get the map values of Platform id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */  
      
        @RemoteAction
        public static Map<id,string> getPlatforms(){
            return MPOT_Util.returnGlblValues('Platforms');
        }
   /* 
     * Method name : getNetworks
     * Description : method to get the map values of netword id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */  
       
        @RemoteAction
        public static Map<id,string> getNetworks(){
            return  MPOT_Util.returnGlblValues('Networks');
        }

   /* 
     * Method name : returnGroupUser
     * Description : method to get the map values of group id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */  
        @RemoteAction
        public static Map<id,string> returnGroupUser(){
            Map<id,string> mPOwn = new Map<id,string>();
            mPOwn = MPOT_Util.returnGroupUser('MPO Project Owner');
            Map<id,string> mPOPlus = new Map<id,string>();
            mPOPlus = MPOT_Util.returnGroupUser('MPO Project Owner Plus');
            mPOPlus.putAll(mPOwn);
            return mPOPlus;
        }
   /* 
     * Method name : returnNROUser
     * Description : method to get the map values of NRO id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */  
        @RemoteAction
        public static Map<id,string> returnNROUser(){
            return  MPOT_Util.returnGroupUser('MPO NRO');
        }
     /* 
     * Method name : getSponsors
     * Description : method to get the map values of sponsor id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */ 
        @RemoteAction
        public static Map<String,string> getSponsors(){
            return  MPOT_Util.returnPrjtSponsor();
        }

    /* 
     * Method name : cancelEdit
     * Description : method to cancel project record
     * Returns : PageReference 
    */ 
        public PageReference cancelEdit() {
            if(Apexpages.currentPage().getParameters().containsKey('Id')){
                pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oProject.id);
            }
            else{
               
                String keyPrefix = GLBL_Project__c.sObjectType.getDescribe().getKeyPrefix();
                //pageRef =  new PageReference('/'+keyPrefix+'/o');
                pageRef =  new PageReference(MPOT_Setting__c.getValues('HomePage').Message__c);
            }

            pageRef.setRedirect(true);
            return pageRef;
        }
    }