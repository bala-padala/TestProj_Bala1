/*
* @Name: MPOT_SearchController
* @Description: Controller Class for Search Functionality,reports, export ,strategic map view
* @Author:Deloitte Consulting
*/


public with sharing class MPOT_SearchController{
public string header{get;set;}
public List<wrapper> lstwrapper {get; set;}
public string Filetype{get;set;}
public boolean isExcel {get;set;}
public boolean isCsv {get;set;}  
public boolean showMsg {get;set;}  
public PageReference pageRef;
 public boolean popUp{get;set;}
public String mpotMilestoneRecTypeId;
public string networkName{get;set;}
public string networkId{get;set;}
public string networkImpactedName{get;set;}
public string networkImpactedId{get;set;}
public string siteName{get;set;}
public string siteId{get;set;}
public string moleculeName{get;set;}
public string moleculeId{get;set;}
public string regulatoryImp{get;set;}
public string platformName{get;set;}
public string platformId{get;set;}
public boolean displayRedYellow{get;set;}
public boolean displayInactive{get;set;}
public boolean displayButtons{get;set;}
public boolean displayResult{get;set;}
public boolean displayReport{get;set;}
public boolean displayStrategicMV{get;set;}
public String oProjectPlaceHolder{get; set;}
public boolean displayAdvSearch{get;set;}
public boolean displayCriteria{get;set;}
public boolean displayDate{get;set;}
public boolean displayDate1{get;set;}
public boolean displayThirty{get;set;}
public boolean bExport{get;set;}
public Map<string,List<GLBL_Project__c>> mStagePrjt{get;set;}
public List<GLBL_Project__c> lPrjtSR {get;set;}
public List<GLBL_Project__c> lPrjtISR {get;set;}
public List<string> lStageName {get;set;}
public PageReference  getRedRecords{get;set;}
public List<MPOT_Change_Log__c> lmilestoneChangeNew{get;set;}
public List<permissionSetAssignment> permissionSetAssignments;
public Set<String> permissionSets;
public string startDate{get;set;}
public string endDate{get;set;}
public string fromDate{get;set;}
public string toDate{get;set;}
public date lmDate{get;set;}
public Boolean canExport{get;set;}
//public static List<GLBL_Project__c> lPrjtSRClone{get;set;}
public string searchCriteria{get;set;}
public List<string> lPrjtDriver {get;set;}
public Map<string,List<GLBL_Project__c>> mDriverPrjt{get;set;}
public boolean bIsShow{get;set;}
public boolean bIsShowG{get;set;}
public boolean bIsShowExport{get;set;}
public  List<GLBL_Project__c> lRedYellow{get;set;}
public  List<GLBL_Project__c> lInactive{get;set;}
private static String mpotProjectRecTypeId = Schema.SobjectType.GLBL_Project__c.getRecordTypeInfosByname().get('MPOT Project').getRecordTypeId();

public MPOT_SearchController(){
canExport = false;
 permissionSetAssignments = new List<permissionSetAssignment>();
 permissionSets = new Set<String>();
permissionSetAssignments = [SELECT Id, Assignee.Name,PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId()];
System.debug('****'+permissionSetAssignments);
if(permissionSetAssignments.size() > 0)
{for(PermissionSetAssignment assignment:permissionSetAssignments)
{

permissionSets.add(assignment.PermissionSet.Label);
}
}

if(permissionSets.contains('MPO Full Active') ||permissionSets.contains('MPO NRO') || permissionSets.contains('MPO Database Administrator'))
canExport = true;

Filetype = '';
lstwrapper = new List<wrapper>();
//header = 'Project Name,Project Stage';
header = 'Project Number,Project Name,Stage,Project Description,Project Scope,Project Owner,Project Sponsor,Network Record Owner,Networks Project Initiated From,Networks Project Impacts,Site,Platforms,Molecules,Regulatory Impact,Project Driver,Current Status (Monthly Update),Changes Issues (Monthly Update),Monthly Update Date';
bExport =false;
displayRedYellow = false;
displayInactive = false;
displayDate  = false;
displayDate1  = false;
displayThirty = false;
mStagePrjt = new Map<string,List<GLBL_Project__c>>();
mDriverPrjt = new Map<string,List<GLBL_Project__c>>();
lPrjtSR = new List<GLBL_Project__c>();
lPrjtISR =  new List<GLBL_Project__c>();
bIsShow =  true;
bIsShowG = false;
showMsg = false;
bIsShowExport = true;
//lPrjtSRClone = new List<GLBL_Project__c>();
lStageName = new List<string>{MPOT_Setting__c.getValues('SearchResultStage1').Message__c,MPOT_Setting__c.getValues('SearchResultStage2').Message__c,MPOT_Setting__c.getValues('SearchResultStage3').Message__c,MPOT_Setting__c.getValues('SearchResultStage4').Message__c};
//lPrjtDriver = new List<string>{'Business Unit Request','Compliance, Control, Capability, Validation','Productivity/Cycle Time','Minimize Key Risks','Desired Future State'};
lPrjtDriver = new List<string>();
Schema.DescribeFieldResult fieldResult = GLBL_Project__c.MPOT_Project_Driver__c.getDescribe();
List<Schema.PicklistEntry> statusValues = fieldResult.getPicklistValues();
for( Schema.PicklistEntry f : statusValues )
{
system.debug('*****label'+f.getLabel());
//system.debug('*****value'+f.getValue());
lPrjtDriver.add(f.getLabel());
/*if(f.getLabel() != null && f.getLabel().equals('Compliance, Control, Capability, Validation')){
    lPrjtDriver.add('Compliance');
}
else if(f.getLabel() != null && f.getLabel().equals('Minimize Key Risks')){
    lPrjtDriver.add('Minimize Key Risks Control Capability Validation');
}
else{
    lPrjtDriver.add(f.getLabel());
}*/
}


set<string> sAssignedPS = MPOT_Util.getPermissionSetNames(userInfo.getUserId());
if(sAssignedPS.contains('MPOT_General') && !(sAssignedPS.contains('MPOT_Database_Administrator')  || sAssignedPS.contains('MPOT_NRO')|| sAssignedPS.contains('MPOT_General_Plus')  || sAssignedPS.contains('MPOT_ProjectOwner_Plus') || sAssignedPS.contains('MPOT_Full_Active'))){
bIsShow =  false;
}
if( (sAssignedPS.contains('MPOT_Database_Administrator') || sAssignedPS.contains('MPOT_NRO') || sAssignedPS.contains('MPOT_General_Plus') || sAssignedPS.contains('MPOT_ProjectOwner_Plus') || sAssignedPS.contains('MPOT_Full_Active'))){
bIsShowG =  true;
}
if(!(sAssignedPS.contains('MPOT_Database_Administrator') || sAssignedPS.contains('MPOT_NRO') || sAssignedPS.contains('MPOT_Full_Active'))){
bIsShowExport =  false;
}
displayButtons = false;
displayResult = false;
displayReport = false;
displayStrategicMV = false;
displayCriteria = false;
displayAdvSearch = true;
oProjectPlaceHolder = 'Select a value from the value list...';
}

   /* 
     * Method name : viewAsReadOnly
     * Description :  Method to assign read only role to the user
     * Param :  none
     * Returns :  void 
    */ 
public void viewAsReadOnly() {
Id valueRecTypeId =Schema.SobjectType.GLBL_User_Settings__c.getRecordTypeInfosByname().get('MPOT').getRecordTypeId();
List<GLBL_User_Settings__c> lUSRecord = [select id, MPOT_User_Role__c, GLBL_User__c from GLBL_User_Settings__c where RecordTypeId =: valueRecTypeId AND GLBL_User__c =: userInfo.getUserId()];
if(lUSRecord.size() > 0){
    if(lUSRecord[0].MPOT_User_Role__c != 'MPO Read-Only'){
        lUSRecord[0].MPOT_User_Role__c = 'MPO Read-Only';
        update lUSRecord[0];
    }
}

}
  /* 
     * Method name : getItems
     * Description :  Method to get regulatory impact values
     * Param :  none
     * Returns :  List<SelectOption>
    */ 
public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes','Yes'));
        options.add(new SelectOption('No','No'));
        return options;
    }

 /* 
     * Method name : performSearch
     * Description :  Method to get All the projects Satisfying the search Criteria . The Projects must have either the selected networks impacted, networks initiating
                     Platform, molecules , sites or the regulatory impact .
     * Param :  none
     * Returns :  PageReference 
    */

public PageReference performSearch() {
    List<GLBL_Project__c> lNewRes;
    mStagePrjt.clear();
    //List<GLBL_Project__c> lSearchResults = searchRecords();
    //if((networkImpactedName != null && networkImpactedName != '') || (networkName != null && networkName != '') || (siteName != null && siteName != '') || (moleculeName != null && moleculeName != '') || (platformName != null && platformName != '') || regulatoryImp != 'None'){
        List<GLBL_Project__c> lSearchResults = new List<GLBL_Project__c>();
         List<GLBL_Project__c> lInactiveSearchResults = new List<GLBL_Project__c>();
        lSearchResults = searchRecords();
        lInactiveSearchResults = searchRecordsInactive();
        system.debug('**Inside** search'+lSearchResults);
        // system.debug('**Inside** search'+lInactiveSearchResults );
        if(lSearchResults.size() > 0){
            for(GLBL_Project__c lRes : lSearchResults){
            if(!mStagePrjt.containsKey(lRes.MPOT_Stage__c)){
            lNewRes = new List<GLBL_Project__c>();
            lNewRes.add(lRes);
            mStagePrjt.put(lRes.MPOT_Stage__c, lNewRes);    
            }
            else{
            lNewRes = mStagePrjt.get(lRes.MPOT_Stage__c);
            lNewRes.add(lRes);
            mStagePrjt.put(lRes.MPOT_Stage__c, lNewRes);
            }
            }
            for(string stg: lStageName){
            system.debug('******map'+mStagePrjt.get(stg));
            if(!mStagePrjt.containsKey(stg)){
                lNewRes = new List<GLBL_Project__c>();
                mStagePrjt.put(stg, lNewRes);
            }
            }
            displayAdvSearch = false;
            displayButtons = true;
            displayResult = true;
            displayReport = false;
            displayStrategicMV = false;
            displayCriteria = true;
            displayDate =false;
            displayDate1 = false;
            displayThirty =false;
            displayRedYellow = false;
            displayInactive =false;
        }
        else{
            system.debug('**Inside no result**');
            ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.Info, 'No Projects found as per the entered Criteria.');
            ApexPages.addMessage(msg);
        }
        
    /*}
    else{
        system.debug('**Inside no select**');
        ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.Info, 'Please select Criteria to perform search.');
        ApexPages.addMessage(msg);
    }*/
   return null;
   
}
 /* 
     * Method name : displaySearch
     * Description :  Method to display search button and results
     * Param :  none
     * Returns :  PageReference 
    */
public PageReference displaySearch() {
    displayButtons = true;
    displayResult = true;
    displayReport = false;
    displayStrategicMV = false;
    displayDate =false;
    displayDate1 = false;
    displayThirty =false;
    displayRedYellow = false;
    displayInactive =false;
    return null;
}
 /* 
     * Method name : displayReport
     * Description :  Method to display report button and results
     * Param :  none
     * Returns :  PageReference 
    */
public PageReference displayReport() {
    displayButtons = true;
    displayResult = false;
    displayReport = true;
    displayStrategicMV = false;
    displayDate =false;
    displayDate1 = false;
    displayThirty =false;
    displayRedYellow = false;
    displayInactive =false;
    return null;
}
/* 
     * Method name : displaySearchDate
     * Description :  Method to display Start and end dates
     * Param :  none
     * Returns :  PageReference 
    */
public PageReference displaySearchDate() {
    displayDate =true;
    displayDate1 = false;
    displayThirty =false;
    displayRedYellow = false;
    return null;
}
/* 
     * Method name : displaythirtyDay
     * Description :  Method to display 30 day report
     * Param :  none
     * Returns :  PageReference 
    */
public PageReference displaythirtyDay() {
    displayDate1 = true;
    displayDate =false;
    displayRedYellow = false;
    displayInactive =false;
    return null;
}

/* 
     * Method name : setDate
     * Description :  Method for date conversion
     * Param : string myDate
     * Returns :  date 
    */
public date setDate(string myDate){


String[] strDate =myDate.split('/');
Integer myIntDate = integer.valueOf(strDate[1]);
Integer myIntMonth = integer.valueOf(strDate[0]);
Integer myIntYear =integer.valueof(strDate[2]);
Date dt = Date.newInstance( myIntYear, myIntMonth, myIntDate);

return dt;

}

/* 
     * Method name : getRedRecords
     * Description :  Method to get Red/Yellow report results
     * Param : none
     * Returns :  PageReference 
    */
public PageReference getRedRecords(){
     displayRedYellow = true ;
     displayDate = false;
     displayThirty =false;
     displayDate1 =false ;
     lRedYellow = new List<GLBL_Project__c>();
     for(GLBL_Project__c lred : lPrjtSR){
         if(lred.MPOT_Current_Status__c ==  'Current Timeline Cannot be Met' || lred.MPOT_Current_Status__c == 'Current Timeline at Risk'){
             lRedYellow.add(lred);
         }
     }
     return null;
}



/* 
     * Method name : getInactiveRecords
     * Description :  Method to get Inactive search results
     * Param : none
     * Returns :  PageReference 
    */
public PageReference getInactiveRecords(){

    displayDate1 =false;
    displayInactive = true;
    displayRedYellow =false;
    displayThirty =false;
    lInactive = new List<GLBL_Project__c>();
    system.debug('***********inactive Projects ******* '+ lPrjtISR.size() );
    system.debug('***********Start Date ******* '+ startDate  );
    system.debug('***********End Date ******* '+ endDate  );
   
    if(startDate != null 
       && endDate != null 
       && startDate != '' 
       && endDate !='' ){
    
            Date fromDate  = setDate(startDate);
            Date toDate  = setDate(endDate);
            
            if(lPrjtISR.size() != 0 ){
                for(GLBL_Project__c Inactive :lPrjtISR){
             //   system.debug('line378***********fromDate = ******* '+ fromDate + 'Inactive.MPOT_Last_Modified_Date__c '+ Inactive.MPOT_Last_Modified_Date__c+ 'toDate'+ toDate+''+Inactive.MPOT_Stage__c +Inactive.MPOT_Stage__c+Inactive.MPOT_Stage__c);
    system.debug('***********End Date ******* '+ endDate  );
                    if(fromDate <= Inactive.MPOT_Last_Modified_Date__c                        
                       && Inactive.MPOT_Last_Modified_Date__c  <= toDate    
                       && (Inactive.MPOT_Stage__c == 'Cancelled' || Inactive.MPOT_Stage__c == 'On Hold' || Inactive.MPOT_Stage__c == 'Completed')){
                        lInactive.add(Inactive);
                        system.debug('***********myDate  ******* '+ lmDate  );
                    }
                }
        
            }
          
           
    
       
    }
    else{
            ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR,'Please enter valid date range.');
           ApexPages.addMessage(msg);
      }

   return null;
}

/* 
     * Method name : getThirtyDayRecords
     * Description :  Method to get project records for 30 day report
     * Param : none
     * Returns :  PageReference 
    */
public PageReference getThirtyDayRecords(){
  
    displayThirty = true;
    displayDate = false;
    displayInactive = false;
    displayRedYellow =false;
    mpotMilestoneRecTypeId = Schema.SobjectType.MPOT_Change_Log__c.getRecordTypeInfosByname().get('MPOT Milestone Log').getRecordTypeId();
    lmilestoneChangeNew = new List<MPOT_Change_Log__c>();
    List<MPOT_Change_Log__c> lMilestoneChangeLog = [SELECT Name, Project__r.Name ,Project__r.Id,Activity__c,Date__c,Action_Taken_By__c,Project_for_Milestone_Change_Log__r.name,
                                                    Milestone__c,New_End_Date__c,New_Start_Date__c,Previous_End_Date__c,Baseline_End__c,Baseline_Start__c,Comments__c,
                                                    Number_of_Day_Btw_NewEnd_and_PrevEnd__c,Number_of_Day_Btw_NewStart_and_PrevStart__c,
                                                    Previous_Start_Date__c,Project_Milestone__c,Reason_for_Change__c,Sub_Milestone__c
                                                    FROM MPOT_Change_Log__c WHERE RecordTypeId =: mpotMilestoneRecTypeId AND Project_for_Milestone_Change_Log__r.Id IN: lPrjtSR order By Project_for_Milestone_Change_Log__r.Name LIMIT 50000];
  
   
    if(fromDate != null 
       && toDate != null 
       && fromDate !='' 
       && toDate !=''){
   
        Date fdate = setDate(fromDate);
        Date tdate= setDate(toDate);
        if(lMilestoneChangeLog.size() <> 0){
            for(MPOT_Change_Log__c mil :lMilestoneChangeLog){
            
                if((mil.Number_of_Day_Btw_NewEnd_and_PrevEnd__c >30 || mil.Number_of_Day_Btw_NewStart_and_PrevStart__c  >30) && (fdate <= mil.Date__c && mil.Date__c <= tdate +1)  && mil.Activity__c == 'Modify' ){
                    lmilestoneChangeNew.add(mil);
                }else if((mil.Number_of_Day_Btw_NewEnd_and_PrevEnd__c >30 || mil.Number_of_Day_Btw_NewStart_and_PrevStart__c  >30) && (fdate == tdate && mil.Date__c == fdate)  && mil.Activity__c == 'Modify' ){
                    lmilestoneChangeNew.add(mil);
                
                }
            }
        }
    
     
    }else{
      ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR,'Please enter valid date range.');
      ApexPages.addMessage(msg);
    
    }
        
   return null;
   
 
 

}

/* 
     * Method name : displaySMV
     * Description :  Method to display the Strategic Map View
     * Param : none
     * Returns :  PageReference 
    */
public PageReference displaySMV() {
    mDriverPrjt.clear();
    List<GLBL_Project__c> lNewRes;
    for(GLBL_Project__c lRes : lPrjtSR){
        if(!mDriverPrjt.containsKey(lRes.MPOT_Project_Driver__c)){
        lNewRes = new List<GLBL_Project__c>();
        lNewRes.add(lRes);
        mDriverPrjt.put(lRes.MPOT_Project_Driver__c, lNewRes);    
        }
        else{
        lNewRes = mDriverPrjt.get(lRes.MPOT_Project_Driver__c);
        lNewRes.add(lRes);
        mDriverPrjt.put(lRes.MPOT_Project_Driver__c, lNewRes);
        }
    }
        for(string dvr: lPrjtDriver){
        system.debug('******map'+mDriverPrjt.get(dvr));
        if(!mDriverPrjt.containsKey(dvr)){
            lNewRes = new List<GLBL_Project__c>();
            mDriverPrjt.put(dvr, lNewRes);
        }
        }
    
    displayButtons = true;
    displayResult = false;
    displayReport = false;
    displayStrategicMV = true;
    displayDate =false;
    displayDate1 = false;
    displayThirty =false;
    displayRedYellow = false;
    displayInactive =false;
    return null;
}

/* 
     * Method name : exportRecords
     * Description :  Method to redirect to export Excel page which downloads the excel
     * Param : none
     * Returns :  PageReference 
    */
public PageReference exportRecords() {
     
     PageReference newocp = new PageReference('/apex/MPOT_exportExcel');
     newocp.setRedirect(false);
   
     showMsg = true;
     return newocp;
}

    /* 
     * Method name : export
     * Description :  Method to get all the project record details for export
     * Param : none
     * Returns :  PageReference 
    */
public void export(){
List<GLBL_Project__c> a = searchRecords();
    if(a.size()>0){
        for(GLBL_Project__c csd :a){
                wrapper w = new wrapper();
                w.pNumber = csd.MPOT_Project_Number__c;
                w.pName = csd.Name;
                w.pStage = csd.MPOT_Stage__c;
                w.pAnchor = csd.MPOT_Anchor__c;
                w.pDescription = csd.MPOT_Project_Description__c;
                w.pScope = csd.MPOT_Project_Scope__c;
              //  w.pOwner = csd.Owner.FirstName+' '+csd.Owner.LastName;
                w.pOwner = csd.MPOT_Project_Owner__r.Name;
                w.pSponsor = csd.MPOT_Project_Sponsor__c;
                w.pRecordOwner = csd.Owner.Name;
                w.pNetworksProjectInitiatedFrom = csd.MPOT_Network_Project_Initiated_from__c;
                w.pNetworksProjectImpacts = csd.MPOT_Networks_Project_Impacts__c;
                w.pSite = csd.MPOT_Sites__c;
                w.pPlatforms = csd.MPOT_Platforms__c;
                w.pMolecules = csd.MPOT_Molecule_Name__c;
                w.pRegulatoryImpact = csd.MPOT_Regulatory_Impact__c;
                w.pRegulatoryImpactLevel = csd.MPOT_Regulatory_Impact_Level__c;
                w.pProjectDriver = csd.MPOT_Project_Driver__c;
                w.pCurrentStatus = csd.MPOT_Current_Status__c;
                w.pChangesIssues = csd.MPOT_Changes_Issues__c;
                w.MonthlyUpdateDate = csd.MPOT_Monthly_Update_Date__c;
                lstwrapper.add(w);               
        }             
    }
}

  /* 
     * Method name : searchRecordsInactive
     * Description : Code to  Get records satifying the search criteria and are inactive 
     * Param : none
     * Returns :  List<GLBL_Project__c>
    */


public List<GLBL_Project__c> searchRecordsInactive() {
    lPrjtISR.clear();
    searchCriteria = 'Search Parameters:';
    set<GLBL_Project__c> lPrjtSRAllinactive =  new set<GLBL_Project__c>();
    if((networkImpactedName != null 
        && networkImpactedName != '') 
       || (networkName != null && networkName != '') 
       || (siteName != null && siteName != '') 
       || (moleculeName != null && moleculeName != '') 
       || (platformName != null && platformName != '') 
       || regulatoryImp != 'None'){
        List<GLBL_Project__c> lPrjtAllinactive = [select Id, Name,RecordTypeId ,LastModifiedDate,MPOT_Current_Status__c,MPOT_Project_Description__c,MPOT_Last_Modified_Date__c,MPOT_Current_Status_Color__c,MPOT_Changes_Issues__c, MPOT_Overdue__c, MPOT_Anchor_Image__c, MPOT_Stage__c,MPOT_Sites__c,MPOT_Platforms__c,MPOT_Regulatory_Impact__c,MPOT_Molecule_Name__c,MPOT_Networks_Project_Impacts__c,MPOT_Network_Project_Initiated_from__c, MPOT_Project_Driver__c from GLBL_Project__c where  MPOT_New_Project_Request_Approved__c = true AND RecordTypeId =:mpotProjectRecTypeId AND(MPOT_Stage__c = 'Completed' OR  MPOT_Stage__c ='On Hold' OR MPOT_Stage__c ='Cancelled')  order By Name Limit 50000];
       // system.debug('**lPrjtSRAll1 ***'+ lPrjtAll.size());
        boolean bAddedSet = false;
        searchCriteria = searchCriteria+'<html>';
       // system.debug('**networkImpactedName***'+ networkImpactedName);    
        if(networkImpactedName != null 
           && networkImpactedName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Network Impacted:</b>'+ networkImpactedName+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR1: lPrjtSRAllinactive ){
                    boolean bHaveParam = false;
                    if(PSR1.MPOT_Networks_Project_Impacts__c != null && PSR1.MPOT_Networks_Project_Impacts__c != ''){
                        List<string> lImpactedNw1 = PSR1.MPOT_Networks_Project_Impacts__c.split(';');
                        for(string val : lImpactedNw1){
                            if(val !=' ' && networkImpactedName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkImpactedName2***'+ networkImpactedName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAllinactive.remove(PSR1);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR1: lPrjtAllinactive ){
                    //system.debug('**PSRMane***'+ PSR.Name);
                    //system.debug('**PSR.MPOT_Networks_Project_Impacts__c***'+ PSR.MPOT_Networks_Project_Impacts__c);
                    //system.debug('**networkImpactedName***'+ networkImpactedName);
                    bAddedSet = true;
                    if(PSR1.MPOT_Networks_Project_Impacts__c != null 
                       && PSR1.MPOT_Networks_Project_Impacts__c != ''){
                        List<string> lImpactedNw1 = PSR1.MPOT_Networks_Project_Impacts__c.split(';');
                        for(string val : lImpactedNw1){
                            system.debug('**valbefore***'+ val);
                            if(val !=' ' 
                               && networkImpactedName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkImpactedName***'+ networkImpactedName);
                                lPrjtSRAllinactive.add(PSR1);                            
                            }                   
                        }                       
                    }               
                }               
            }
        }    
      //  system.debug('**lPrjtSRAll***'+ lPrjtSRAll);
        if(networkName != null && networkName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Network Initiating:</b>'+ networkName+'<b>|</b>';         
            if(bAddedSet){
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    boolean bHaveParam = false;
                    if(PSR1.MPOT_Network_Project_Initiated_from__c != null 
                       && PSR1.MPOT_Network_Project_Initiated_from__c != ''){
                        List<string> lNw1 = PSR1.MPOT_Network_Project_Initiated_from__c.split(';');
                        for(string val : lNw1){
                            if(val !=' '
                               && networkName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkName2***'+ networkName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAllinactive.remove(PSR1);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR1: lPrjtAllinactive ){
                    bAddedSet = true;
                    if(PSR1.MPOT_Network_Project_Initiated_from__c != null && PSR1.MPOT_Network_Project_Initiated_from__c != ''){
                        List<string> lNw1 = PSR1.MPOT_Network_Project_Initiated_from__c.split(';');
                        for(string val : lNw1){
                            if(val !=' ' && networkName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkName***'+ networkName);
                                lPrjtSRAllinactive.add(PSR1);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        if(siteName != null && siteName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Sites Impacted:</b>'+ siteName+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    boolean bHaveParam = false;
                    if(PSR1.MPOT_Sites__c != null 
                       && PSR1.MPOT_Sites__c != ''){
                        List<string> lSite1 = PSR1.MPOT_Sites__c.split(';');
                        for(string val : lSite1){
                            if(val !=' ' 
                               && siteName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**siteName2***'+ siteName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAllinactive.remove(PSR1);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    bAddedSet = true;
                    if(PSR1.MPOT_Sites__c != null && PSR1.MPOT_Sites__c != ''){
                        List<string> lSite1 = PSR1.MPOT_Sites__c.split(';');
                        for(string val : lSite1){
                            if(val !=' ' && siteName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**siteName***'+ siteName);
                                lPrjtSRAllinactive.add(PSR1);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        
        if(moleculeName != null && moleculeName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Molecules Impacted:</b>'+ moleculeName+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    boolean bHaveParam = false;
                    if(PSR1.MPOT_Molecule_Name__c != null 
                       && PSR1.MPOT_Molecule_Name__c != ''){
                        List<string> lMolecule1 = PSR1.MPOT_Molecule_Name__c.split(';');
                        for(string val : lMolecule1){
                            if(val !=' ' 
                               && moleculeName.contains(val)){
                              //  system.debug('**val***'+ val);
                                //system.debug('**moleculeName2***'+ moleculeName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAllinactive.remove(PSR1);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    bAddedSet = true;
                    if(PSR1.MPOT_Molecule_Name__c != null && PSR1.MPOT_Molecule_Name__c != ''){
                        List<string> lMolecule1 = PSR1.MPOT_Molecule_Name__c.split(';');
                        for(string val : lMolecule1){
                            if(val !=' ' && moleculeName.contains(val)){
                             //   system.debug('**val***'+ val);
                              //  system.debug('**moleculeName***'+ moleculeName);
                                lPrjtSRAllinactive.add(PSR1);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        if(platformName != null && platformName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Drug Product/Platform Impacted:</b>'+ platformName+'<b>|</b>';                        
            if(bAddedSet){
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    boolean bHaveParam = false;
                    if(PSR1.MPOT_Platforms__c != null 
                       && PSR1.MPOT_Platforms__c != ''){
                        List<string> lPlatform1 = PSR1.MPOT_Platforms__c.split(';');
                        for(string val : lPlatform1){
                            if(val !=' ' 
                               && platformName.contains(val)){
                              //  system.debug('**val***'+ val);
                                //system.debug('**platformName2***'+ platformName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAllinactive.remove(PSR1);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    bAddedSet = true;
                    if(PSR1.MPOT_Platforms__c != null && PSR1.MPOT_Platforms__c != ''){
                        List<string> lPlatform1 = PSR1.MPOT_Platforms__c.split(';');
                        for(string val : lPlatform1){
                            if(val !=' ' && platformName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**platformName***'+ platformName);
                                lPrjtSRAllinactive.add(PSR1);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        
        if(regulatoryImp != 'All'){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Regulatory Impact:</b>'+ regulatoryImp+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    if(PSR1.MPOT_Regulatory_Impact__c != null 
                       && PSR1.MPOT_Regulatory_Impact__c != '' 
                       && PSR1.MPOT_Regulatory_Impact__c != regulatoryImp){
                        system.debug('**PSR1.MPOT_Regulatory_Impact__c***'+ PSR1.MPOT_Regulatory_Impact__c);
                        lPrjtSRAllinactive.remove(PSR1);                     
                    }                   
                }               
            }
            else{
                for(GLBL_Project__c PSR1: lPrjtAllinactive){
                    bAddedSet = true;
                    if(PSR1.MPOT_Regulatory_Impact__c != null 
                       && PSR1.MPOT_Regulatory_Impact__c != '' 
                       && PSR1.MPOT_Regulatory_Impact__c == regulatoryImp){
                        system.debug('**PSR1.MPOT_Regulatory_Impact__c***'+ PSR1.MPOT_Regulatory_Impact__c);
                        lPrjtSRAllinactive.add(PSR1);
                        //bAddedSet = true;                     
                    }                   
                }
            }
        }
        else{
            searchCriteria = searchCriteria+'<b style= "color:Green;">Regulatory Impact:</b>'+ regulatoryImp+'<b>|</b>';
            if(!bAddedSet){
                lPrjtSRAllinactive.addAll(lPrjtAllinactive);
            }
        }
    }
    searchCriteria = searchCriteria+'</html>';  
    //lPrjtSRClone = lPrjtSR.clone();
   // system.debug('**lPrjtSRAll**'+ lPrjtSRAll);
    lPrjtISR.addAll(lPrjtSRAllinactive);
   // system.debug('**lPrjtSR***'+ lPrjtSR);
    return lPrjtISR;
}

/*Code to  Get records satifying the search criteria and are inactive Ends ****/

 /* 
     * Method name : searchRecords
     * Description : Code to  Get records satifying the search criteria and are active 
     * Param : none
     * Returns :  List<GLBL_Project__c>
    */
public List<GLBL_Project__c> searchRecords() {
    lPrjtSR.clear();
    searchCriteria = 'Search Parameters:';
    set<GLBL_Project__c> lPrjtSRAll =  new set<GLBL_Project__c>();
    if((networkImpactedName != null && networkImpactedName != '') || (networkName != null && networkName != '') || (siteName != null && siteName != '') || (moleculeName != null && moleculeName != '')|| (platformName != null && platformName != '') || regulatoryImp != 'None'){
        List<GLBL_Project__c> lPrjtAll = [select Id,Owner.Name,Owner.FirstName,Owner.LastName,MPOT_Project_Number__c,MPOT_Molecules__c,MPOT_Project_Owner__c,MPOT_Project_Owner__r.Name,MPOT_Network_Record_Owner_Name__c,Name,RecordTypeId ,MPOT_Regulatory_Impact__c,MPOT_Current_Status_Color__c, MPOT_Overdue__c, MPOT_Anchor_Image__c, MPOT_Stage__c,MPOT_Networks_Project_Impacts__c,MPOT_Network_Project_Initiated_from__c, MPOT_Project_Driver__c,MPOT_Project_Description__c,MPOT_Project_Scope__c,MPOT_Owner_Name__c,MPOT_Project_Sponsor__c,MPOT_Network_Record_Owner__c,MPOT_Sites__c,MPOT_Platforms__c,MPOT_Molecule_Name__c,MPOT_Current_Status__c,MPOT_Changes_Issues__c,MPOT_Monthly_Update_Date__c, MPOT_Anchor__c, MPOT_Regulatory_Impact_Level__c from GLBL_Project__c where MPOT_Record_Status__c = 'Active' AND MPOT_New_Project_Request_Approved__c = true AND RecordTypeId =:mpotProjectRecTypeId  order By Name Limit 50000];
        system.debug('**lPrjtSRAll1 ***'+ lPrjtAll.size());
        boolean bAddedSet = false;
        searchCriteria = searchCriteria+'<html>';
        system.debug('**networkImpactedName***'+ networkImpactedName);    
        if(networkImpactedName != null 
           && networkImpactedName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Network Impacted:</b>'+ networkImpactedName+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR: lPrjtSRAll){
                    boolean bHaveParam = false;
                    if(PSR.MPOT_Networks_Project_Impacts__c != null && PSR.MPOT_Networks_Project_Impacts__c != ''){
                        List<string> lImpactedNw = PSR.MPOT_Networks_Project_Impacts__c.split(';');
                        for(string val : lImpactedNw){
                            if(val !=' ' && networkImpactedName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkImpactedName2***'+ networkImpactedName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAll.remove(PSR);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR: lPrjtAll){
                    system.debug('**PSRMane***'+ PSR.Name);
                    system.debug('**PSR.MPOT_Networks_Project_Impacts__c***'+ PSR.MPOT_Networks_Project_Impacts__c);
                    system.debug('**networkImpactedName***'+ networkImpactedName);
                    bAddedSet = true;
                    if(PSR.MPOT_Networks_Project_Impacts__c != null 
                       && PSR.MPOT_Networks_Project_Impacts__c != ''){
                        List<string> lImpactedNw = PSR.MPOT_Networks_Project_Impacts__c.split(';');
                        for(string val : lImpactedNw){
                            system.debug('**valbefore***'+ val);
                            if(val !=' ' 
                               && networkImpactedName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkImpactedName***'+ networkImpactedName);
                                lPrjtSRAll.add(PSR);                            
                            }                   
                        }                       
                    }               
                }               
            }
        }    
        system.debug('**lPrjtSRAll***'+ lPrjtSRAll);
        if(networkName != null 
           && networkName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Network Initiating:</b>'+ networkName+'<b>|</b>';         
            if(bAddedSet){
                for(GLBL_Project__c PSR: lPrjtSRAll){
                    boolean bHaveParam = false;
                    if(PSR.MPOT_Network_Project_Initiated_from__c != null 
                       && PSR.MPOT_Network_Project_Initiated_from__c != ''){
                        List<string> lNw = PSR.MPOT_Network_Project_Initiated_from__c.split(';');
                        for(string val : lNw){
                            if(val !=' ' 
                               && networkName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkName2***'+ networkName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAll.remove(PSR);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR: lPrjtAll){
                    bAddedSet = true;
                    if(PSR.MPOT_Network_Project_Initiated_from__c != null && PSR.MPOT_Network_Project_Initiated_from__c != ''){
                        List<string> lNw = PSR.MPOT_Network_Project_Initiated_from__c.split(';');
                        for(string val : lNw){
                            if(val !=' ' && networkName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**networkName***'+ networkName);
                                lPrjtSRAll.add(PSR);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        if(siteName != null 
           && siteName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Sites Impacted:</b>'+ siteName+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR: lPrjtSRAll){
                    boolean bHaveParam = false;
                    if(PSR.MPOT_Sites__c != null 
                       && PSR.MPOT_Sites__c != ''){
                        List<string> lSite = PSR.MPOT_Sites__c.split(';');
                        for(string val : lSite){
                            if(val !=' ' 
                               && siteName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**siteName2***'+ siteName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAll.remove(PSR);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR: lPrjtAll){
                    bAddedSet = true;
                    if(PSR.MPOT_Sites__c != null && PSR.MPOT_Sites__c != ''){
                        List<string> lSite = PSR.MPOT_Sites__c.split(';');
                        for(string val : lSite){
                            if(val !=' ' && siteName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**siteName***'+ siteName);
                                lPrjtSRAll.add(PSR);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        
        if(moleculeName != null 
           && moleculeName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Molecules Impacted:</b>'+ moleculeName+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR: lPrjtSRAll){
                    boolean bHaveParam = false;
                    if(PSR.MPOT_Molecule_Name__c != null 
                       && PSR.MPOT_Molecule_Name__c != ''){
                        List<string> lMolecule = PSR.MPOT_Molecule_Name__c.split(';');
                        for(string val : lMolecule){
                            if(val !=' ' 
                               && moleculeName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**moleculeName2***'+ moleculeName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAll.remove(PSR);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR: lPrjtAll){
                    bAddedSet = true;
                    if(PSR.MPOT_Molecule_Name__c != null && PSR.MPOT_Molecule_Name__c != ''){
                        List<string> lMolecule = PSR.MPOT_Molecule_Name__c.split(';');
                        for(string val : lMolecule){
                            if(val !=' ' && moleculeName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**moleculeName***'+ moleculeName);
                                lPrjtSRAll.add(PSR);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        if(platformName != null 
           && platformName != ''){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Drug Product/Platform Impacted:</b>'+ platformName+'<b>|</b>';                        
            if(bAddedSet){
                for(GLBL_Project__c PSR: lPrjtSRAll){
                    boolean bHaveParam = false;
                    if(PSR.MPOT_Platforms__c != null 
                       && PSR.MPOT_Platforms__c != ''){
                        List<string> lPlatform = PSR.MPOT_Platforms__c.split(';');
                        for(string val : lPlatform){
                            if(val !=' ' 
                               && platformName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**platformName2***'+ platformName);
                                //lPrjtSRAll.remove(PSR);
                                bHaveParam = true;
                            }                   
                        }                       
                    }
                    if(bHaveParam == false){
                        lPrjtSRAll.remove(PSR);
                    }
                }
            }
            else{
                for(GLBL_Project__c PSR: lPrjtAll){
                    bAddedSet = true;
                    if(PSR.MPOT_Platforms__c != null && PSR.MPOT_Platforms__c != ''){
                        List<string> lPlatform = PSR.MPOT_Platforms__c.split(';');
                        for(string val : lPlatform){
                            if(val !=' ' && platformName.contains(val)){
                                system.debug('**val***'+ val);
                                system.debug('**platformName***'+ platformName);
                                lPrjtSRAll.add(PSR);                            
                            }                   
                        }                       
                    }               
                }               
            }           
        }
        
        if(regulatoryImp != 'All'){
            searchCriteria = searchCriteria+'<b style= "color:Green;">Regulatory Impact:</b>'+ regulatoryImp+'<b>|</b>';
            if(bAddedSet){
                for(GLBL_Project__c PSR: lPrjtSRAll){
                    if(PSR.MPOT_Regulatory_Impact__c != null 
                       && PSR.MPOT_Regulatory_Impact__c != '' 
                       && PSR.MPOT_Regulatory_Impact__c != regulatoryImp){
                        system.debug('**PSR.MPOT_Regulatory_Impact__c***'+ PSR.MPOT_Regulatory_Impact__c);
                        lPrjtSRAll.remove(PSR);                     
                    }                   
                }               
            }
            else{
                for(GLBL_Project__c PSR: lPrjtAll){
                    bAddedSet = true;
                    if(PSR.MPOT_Regulatory_Impact__c != null && PSR.MPOT_Regulatory_Impact__c != '' && PSR.MPOT_Regulatory_Impact__c == regulatoryImp){
                        system.debug('**PSR.MPOT_Regulatory_Impact__c***'+ PSR.MPOT_Regulatory_Impact__c);
                        lPrjtSRAll.add(PSR);
                        //bAddedSet = true;                     
                    }                   
                }
            }
        }
        else{
            searchCriteria = searchCriteria+'<b style= "color:Green;">Regulatory Impact:</b>'+ regulatoryImp+'<b>|</b>';
            if(!bAddedSet){
                lPrjtSRAll.addAll(lPrjtAll);
            }
        }
    }
    searchCriteria = searchCriteria+'</html>';  
    //lPrjtSRClone = lPrjtSR.clone();
    system.debug('**lPrjtSRAll**'+ lPrjtSRAll);
    lPrjtSR.addAll(lPrjtSRAll);
    system.debug('**lPrjtSR***'+ lPrjtSR);
    return lPrjtSR;
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
     * Method name : prepareGanttData
     * Description :  Remote action method to get milestone details for the gantt chart
     * Param : id 
     * Returns :  string 
  */
@RemoteAction
public static string prepareGanttData(List<string> lPrjtRes){
system.debug('**Inside Gantt lPrjtRes**'+ lPrjtRes);
List<GLBL_Project__c> lPrjtMS = [select Id, Name,RecordTypeId , (select Id, Name, Start_date__c, End_date__c, Sub_Milestone_name__c, Milestone_name__c, Milestone_detail__c from Project_Milestones__r where End_date__c >= TODAY order By Sub_Milestone_name__c) from GLBL_Project__c where Id =: lPrjtRes AND RecordTypeId =:mpotProjectRecTypeId  order By Name];
//List<GLBL_Project__c> lPrjtMS = new List<GLBL_Project__c>();
List<MilestoneDetails> lMilestoneDet = new List<MilestoneDetails>();
system.debug('**Inside Gantt lPrjtMS**'+ lPrjtMS);
//lPrjtMS.addAll(lPrjtSR);
for(GLBL_Project__c oPrjt : lPrjtMS){
integer iDetCount = 1;
for(MPOT_Project_Milestone__c oPM : oPrjt.Project_Milestones__r){
if(MPOT_Gantt_Data_Mapping__c.getValues(oPM.Milestone_name__c) != null){
List<MilestoneAttributesDetails> lMAttDetails = new List<MilestoneAttributesDetails>();
MilestoneAttributesDetails MAttDet = new MilestoneAttributesDetails();
//Remove default date from code
//Datetime dtFrmDate = new Datetime();
//Datetime dtToDate = new Datetime();
if(oPM.End_date__c != Null){
Date toDate = oPM.End_date__c;
Datetime dtToDate = datetime.newInstance(toDate.year(), toDate.month(),toDate.day());
MAttDet.setToDate(String.valueOf(dtToDate.getTime()));
}

if(oPM.Start_date__c!= Null){
Date frmDate = oPM.Start_date__c;
Datetime dtFrmDate = datetime.newInstance(frmDate.year(), frmDate.month(),frmDate.day());
MAttDet.setFromDate(String.valueOf(dtFrmDate.getTime()));
}


if(oPM.Milestone_name__c == 'Submission/Approval'){
MAttDet.label = '<span class=\'blue-star\'></span><span class=\'red-star\'></span>';
}
else{
MAttDet.label = '';
}
if(MPOT_Gantt_Data_Mapping__c.getValues(oPM.Milestone_name__c) != null){
MAttDet.customClass = MPOT_Gantt_Data_Mapping__c.getValues(oPM.Milestone_name__c).ColourClass__c;
}
/*else{
MAttDet.customClass = MPOT_Gantt_Data_Mapping__c.getValues('genericMilestone').ColourClass__c;
}*/
if(oPM.Milestone_detail__c != null){
MAttDet.desc_PH = oPM.Milestone_detail__c;
}
else{
MAttDet.desc_PH = '';   
}
lMAttDetails.add(MAttDet);
MilestoneDetails MDet = new MilestoneDetails();
if(iDetCount == 1){
MDet.name = oPrjt.Name;
}
else{
MDet.name = '';
}
if(oPM.Sub_Milestone_name__c != null){
MDet.desc_PH = oPM.Sub_Milestone_name__c;
}
else{
MDet.desc_PH = '';  
}
MDet.values = lMAttDetails; 
lMilestoneDet.add(MDet);
iDetCount = iDetCount + 1;
}
}
}
string jsonString1 = JSON.serialize(lMilestoneDet);
system.debug('***jsonString Before***'+ jsonString1 );

jsonString1 = jsonString1 .replace('frm_PH', 'from');
jsonString1  = jsonString1 .replace('desc_PH', 'desc');
system.debug('***jsonString After***'+ jsonString1 );
return jsonString1;
}



  /* 
     * Name : MilestoneDetails
     * Description :  Wrapper Class for milestone details
  */
public class MilestoneDetails
    {
        public String name{get;set;}
        //Below var name - desc
        public String desc_PH{get;set;}
        public List<MilestoneAttributesDetails> values{get;set;}
    }


 /* 
     * Name : MilestoneAttributesDetails
     * Description :  Wrapper Class for milestone date details
  */
public class MilestoneAttributesDetails
    {
        //actual variable name needed was "from", but it is keyword so we cant use that
        public String frm_PH{get;set;}
        public String to{get;set;}
        public String label{get;set;}
        public String customClass{get;set;}
        public String desc_PH{get;set;}
        
        public void setToDate(String val)
        {
            to = setDate(val);
            System.assert(true);
        }
        public void setFromDate(String val)
        {
            frm_PH = setDate(val);
            System.assert(true);
        }
        //Date should be in special format as it is used in regular expression
        private String setDate(String val)
        {
            return '/Date('+val+')/';
        }
    }

public class wrapper{
        public string pName {get; set;}
        public string pStage{get; set;}
        public string pAnchor{get; set;}
        public string pNumber{get; set;}
        public string pDescription{get; set;}
        public string pScope{get; set;}
        public string pOwner{get;set;}
        public string pSponsor{get;set;}
        public string pRecordOwner{get;set;}
        public string pNetworksProjectInitiatedFrom{get;set;}
        public string pNetworksProjectImpacts{get;set;}
        public string pSite{get;set;}
        public string pPlatforms{get;set;}
        public string pMolecules{get;set;}
        public string pRegulatoryImpact{get;set;}
        public string pRegulatoryImpactLevel{get;set;}
        public string pProjectDriver{get;set;}
        public string pCurrentStatus{get;set;}
        public string pChangesIssues{get;set;}
        public Date MonthlyUpdateDate{get;set;}
         }
         
         
     public void showPopUP(){
        popUp =true;
    }

}