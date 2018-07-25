/*
* @Name: MPOT_ChangeRecReqController
* @Description: Controller Class for Changem           Record Request by NRO
* @Author:Deloitte Consulting
*/
public with sharing class MPOT_ChangeRecReqController{


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
public boolean bIsReadOnly{get;set;}
private static String mpotProjectRecTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('MPOT Project').getRecordTypeId();

public MPOT_ChangeRecReqController(ApexPages.StandardController controller){

bIsAdmin = false;
bIsNRO = false;
bIsOwner = false;
bIsReadOnly = false;
oProjectPlaceHolder = 'Select a value from the value list...';

/*
 * set<string> sAssignedPS = MPOT_Util.getPermissionSetNames(userInfo.getUserId());
if(sAssignedPS.contains('MPOT_Database_Administrator')){
bIsAdmin =  true;
}
if(sAssignedPS.contains('MPOT_NRO')){
bIsNRO =  true;
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
            /*
            if(sUserRole =='MPO Project Owner/Project Owner Plus'){
                bIsPO =  true;
            }
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
List<GLBL_Project__c> lPrjt = [select id, Name, RecordTypeId, MPOT_Project_Description__c, MPOT_Project_Driver__c,MPOT_Owner_Name__c,MPOT_Change_Regulatory_Impact_To__c,
                               MPOT_Project_Number__c, OwnerId, MPOT_Anchor__c, MPOT_Regulatory_Impact_Level__c, MPOT_Project_Scope__c,MPOT_Administrative_Comments__c,
                               MPOT_Stage__c,MPOT_Regulatory_Impact__c, MPOT_NRO_Comments__c,MPOT_Networks_Project_Impacts_Id__c,
                               MPOT_Project_Owner__c, Owner.Name, MPOT_Project_Sponsor__c, MPOT_Network_Project_Initiated_from__c,MPOT_Network_Project_Initiated_from_Id__c,
                               MPOT_Networks_Project_Impacts__c,MPOT_Platforms__c,MPOT_Molecule_Name__c,MPOT_Molecule_Id__c,
                               MPOT_Current_Status__c,MPOT_Current_Status_Color__c,MPOT_Sites__c, MPOT_Network_Record_Owner_Id__c , MPOT_Network_Record_Owner_Name__c, MPOT_Add_new_Sponsor__c , MPOT_Project_Sponsor_Id__c, MPOT_Project_Owner_Id__c, MPOT_Molecules__c,MPOT_Gating_Slide_Exception__c,MPOT_Platforms_Id__c,MPOT_Sites_Id__c,CreatedById,LastModifiedById,MPOT_Monthly_Update_Date__c,MPOT_Date_Moved_To_Inactive_Status__c,
                               MPOT_Changed_Project_Name__c,MPOT_Changed_Project_Description__c,MPOT_Changed_Project_Driver__c,MPOT_Changed_Project_Owner__c,MPOT_Changed_Project_Scope__c,
                               MPOT_Changed_Project_Sponsor__c,MPOT_Changed_Project_Sponsor_Id__c,MPOT_Changed_Project_Owner_Id__c,MPOT_Changed_Owner_Name__c,
                               MPOT_Changed_Networks_Project_Impacts_Id__c,MPOT_Changed_Networks_Project_Impacts__c,MPOT_Changed_Netwrk_Project_Initiated_Id__c,MPOT_Changed_Netwrk_Proj_Initiated_from__c,
                               MPOT_Changed_Molecule_Id__c,MPOT_Changed_Molecule_Name__c,MPOT_Changed_Molecule__c,
                               MPOT_Changed_Sites_Id__c,MPOT_Changed_Sites__c,MPOT_Changed_Platforms_Id__c,MPOT_Changed_Platforms__c,MPOT_Changed_Stage__c,MPOT_Changed_Anchor__c,  MPOT_Changed_Regulatory_Impact_Level__c, 
                               MPOT_NRO_Change_Record_Request_Indicator__c,MPOT_NRO_CR_Approved_Indicator__c,MPOT_NRO_CR_Created_Indicator__c,
                               MPOT_Changed_NRO_Comments__c,MPOT_Changed_Add_New_Sponsor__c
                               from GLBL_Project__c where Id=: sPrjtId AND RecordTypeId=:mpotProjectRecTypeId ];
oProject = lPrjt[0];
userName = oProject.Owner.name;
oldOwner = oProject.MPOT_Project_Owner_Id__c;

//populating the change request fields with the original values
    if(oProject.MPOT_NRO_CR_Created_Indicator__c != true ){
oProject.MPOT_Changed_Project_Name__c = oProject.Name;
oProject.MPOT_Changed_Project_Description__c = oProject.MPOT_Project_Description__c;
oProject.MPOT_Changed_Project_Driver__c = oProject.MPOT_Project_Driver__c;
oProject.MPOT_Changed_Project_Scope__c = oProject.MPOT_Project_Scope__c;

oProject.MPOT_Changed_Project_Sponsor__c = oProject.MPOT_Project_Sponsor__c ;
oProject.MPOT_Changed_Project_Sponsor_Id__c = oProject.MPOT_Project_Sponsor_Id__c ;  
oProject.MPOT_Changed_Project_Owner_Id__c = oProject.MPOT_Project_Owner_Id__c; 
oProject.MPOT_Changed_Owner_Name__c = oProject.MPOT_Project_Owner__c ;
 
oProject.MPOT_Changed_Networks_Project_Impacts_Id__c = oProject.MPOT_Networks_Project_Impacts_Id__c ;
oProject.MPOT_Changed_Networks_Project_Impacts__c = oProject.MPOT_Networks_Project_Impacts__c ;
oProject.MPOT_Changed_Netwrk_Project_Initiated_Id__c = oProject.MPOT_Network_Project_Initiated_from_Id__c ;
oProject.MPOT_Changed_Netwrk_Proj_Initiated_from__c = oProject.MPOT_Network_Project_Initiated_from__c ;

oProject.MPOT_Changed_Molecule_Id__c = oProject.MPOT_Molecule_Id__c ;
oProject.MPOT_Changed_Molecule_Name__c =oProject.MPOT_Molecule_Name__c ;
oProject.MPOT_Changed_Molecule__c = oProject.MPOT_Molecules__c ;
oProject.MPOT_Changed_Sites_Id__c = oProject.MPOT_Sites_Id__c ;
oProject.MPOT_Changed_Sites__c = oProject.MPOT_Sites__c ;
oProject.MPOT_Changed_Platforms_Id__c = oProject.MPOT_Platforms_Id__c ;
oProject.MPOT_Changed_Platforms__c = oProject.MPOT_Platforms__c ;
 
oProject.MPOT_Changed_Stage__c = oProject.MPOT_Stage__c ; 
oProject.MPOT_Changed_Anchor__c= oProject.MPOT_Anchor__c; 
oProject.MPOT_Changed_Regulatory_Impact_Level__c  = oProject.MPOT_Regulatory_Impact_Level__c;
   
oProject.MPOT_Change_Regulatory_Impact_To__c = oProject.MPOT_Regulatory_Impact__c;        
}
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
     * Method name : saveCR
     * Description :  Method to Save the Change Record Request
     * Param :  none
     * Returns :  PageReference 
    */   
public PageReference saveCR(){
try{
        if (oProject.MPOT_Changed_Add_New_Sponsor__c != null && oProject.MPOT_Changed_Add_New_Sponsor__c != '' && oProject.MPOT_Changed_Project_Sponsor__c != oProject.MPOT_Changed_Add_New_Sponsor__c ){
                oProject.MPOT_Changed_Project_Sponsor_Id__c = oProject.MPOT_Changed_Add_New_Sponsor__c;
                oProject.MPOT_Changed_Project_Sponsor__c = oProject.MPOT_Changed_Add_New_Sponsor__c;
                oProject.MPOT_Changed_Add_New_Sponsor__c ='';
        }
        
        if(oProject.MPOT_Changed_Project_Owner_Id__c != null && oProject.MPOT_Changed_Project_Owner_Id__c != ''){
            if(oProject.MPOT_Changed_Project_Owner_Id__c != oProject.MPOT_Changed_Project_Owner__c){
            oProject.MPOT_Changed_Project_Owner__c= oProject.MPOT_Changed_Project_Owner_Id__c ;
            }
        }
        else{
        oProject.MPOT_Changed_Project_Owner__c= oProject.MPOT_Changed_Project_Owner_Id__c ;
        }
        
        oProject.MPOT_NRO_CR_Created_Indicator__c = true;
        //checking for mandatory values being erased
        if((oProject.MPOT_Changed_Networks_Project_Impacts__c == null) || (oProject.MPOT_Changed_Project_Sponsor__c == null) || (oProject.MPOT_Changed_Sites__c == null))
        {
            //if project sponsor is being erased then populating an error msg
            if((oProject.MPOT_Changed_Project_Sponsor__c == null) || (oProject.MPOT_Changed_Project_Sponsor__c == ''))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Change Project Sponsor To cannot be null.'));
            }
            //if Networks Project Impacts is being erased then populating an error msg
            if((oProject.MPOT_Changed_Networks_Project_Impacts__c == null) || (oProject.MPOT_Changed_Networks_Project_Impacts__c == ''))
            {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Change Networks Impacted To cannot be null.'));
            }
            //if Sites is being erased then populating an error msg
            if((oProject.MPOT_Changed_Sites__c == null) || (oProject.MPOT_Changed_Sites__c == ''))
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Change Sites Impacted To cannot be null.'));
            }
        }
                //pageRef = apexpages.Currentpage();
                //apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Project Sponsor cannot be null');
                //apexpages.addmessage(msg);
        
        else
        {
            upsert oProject;
            pageRef =  new PageReference('/apex/MPOT_ViewCRPage?Id='+oProject.id);
            pageRef.setRedirect(true);    
        }
        
        return pageRef;
    }
catch(Exception ex)
    {
        ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
        ApexPages.addMessage(msg);
        return null;
    }

}

 /* 
     * Method name : getMolecules
     * Description : method to get the map values of Molcules id and name 
     * Param :  none
     * Returns : Map<id,string> 
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
    system.debug('***AllPO***'+mPOPlus);
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
     * Method name : getChangedSponsors
     * Description : method to get the map values of sponsor id and name 
     * Param :  none
     * Returns :  Map<id,string>
    */ 
@RemoteAction
public static Map<String,string> getChangedSponsors(){
    return  MPOT_Util.returnChangedPrjtSponsor();
}

  /* 
     * Method name : cancelCR
     * Description : method to cancel Change record request
     * Returns : PageReference 
    */ 
public PageReference cancelCR() {

        if(Apexpages.currentPage().getParameters().containsKey('Id'))
        {
            if(oProject.MPOT_NRO_CR_Created_Indicator__c != true){
                pageRef =  new PageReference('/apex/MPOT_ViewProjectPage?Id='+oProject.id);
            }
            else
            {
                pageRef =  new PageReference('/apex/MPOT_ViewCRPage?Id='+oProject.id);
            }
        }
        else
        {
        
            //pageRef =  new PageReference('/a3A/o');
            String keyPrefix = GLBL_Project__c.sObjectType.getDescribe().getKeyPrefix();
            pageRef =  new PageReference('/'+keyPrefix+'/o');
        }   
    pageRef.setRedirect(true);
    return pageRef;
    }
    
}