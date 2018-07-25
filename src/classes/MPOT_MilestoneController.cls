/*
* @Name: MPOT_MilestoneController
* @Description: Controller Clas  s for Milestone creation
* @Author:Deloitte Consulting
*/
public with sharing class MPOT_MilestoneController{
 
    public boolean modify{get;set;}
    public string sMSId  {get;set;}
    public string sPjectId {get;set;}
    public List<SelectOption> milestoneList {get;set;}
    public List<SelectOption> SubmilestoneList {get;set;}
    public string Milestone {get;set;}
    public string MilestoneStatus {get;set;}
    public string Submilestone {get;set;}
    public GLBL_Global_List_of_Values__c  objMilestone {get;set;}
    public MPOT_Project_Milestone__c oMilestone {get;set;}
    public Map<String,List<string >> MapSubmlstn{get;set;}
    public boolean bIsOwner{get;set;}
    public boolean bIsPO{get;set;}
    
    
    public MPOT_MilestoneController(ApexPages.StandardController controller){
    modify = false;
    bIsOwner = false;
    bIsPO = false;
        //Logic to check the logged in user's role
        string sUserRole = MPOT_Util.fetchUserRole();
        if(sUserRole != null && sUserRole != '' && sUserRole =='MPO Project Owner/Project Owner Plus'){
             bIsPO =  true;
        }
       
    
        MapSubmlstn = new Map<String,List<string >>();
        milestoneList = new  List<SelectOption>();
        //Milestone = '--none--';
        SubmilestoneList = new List<SelectOption>();
        milestoneList.add(new SelectOption('', ''));
        SubmilestoneList.add(new SelectOption('', ''));
        //Submilestone = '--none--';
                
        Id valueRecTypeId1 =Schema.SobjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByname().get('Milestone').getRecordTypeId();
        List<GLBL_Global_List_of_Values__c> lmilestone = [SELECT id,Name  
                                                 FROM GLBL_Global_List_of_Values__c WHERE 
                                                 Active__c= true and RecordTypeId =: valueRecTypeId1 ];
        
            for(GLBL_Global_List_of_Values__c  glb:lmilestone){
                milestoneList.add(new SelectOption(glb.name, glb.name));
            }
        MapSubmlstn= returnMilSubMilestone(lmilestone);


        sPjectId = Apexpages.currentPage().getParameters().get('parentId');
        sMSId = Apexpages.currentPage().getParameters().get('Id');
       
        if(Apexpages.currentPage().getParameters().containsKey('Id')){
            List<MPOT_Project_Milestone__c> lPrjtMilestone =[SELECT id , Name, Milestone_name__c,Milestone_detail__c,Project_Name__c,OwnerId,
                                            Project_Name__r.Id,Milestone_Note__c,Baseline_End_Date__c,Baseline_Start_Date__c,
                                                        End_date__c,New_End_Date__c,New_Start_Date__c,Start_date__c,
                                                        Sub_Milestone_name__c,Reason_For_Change__c,Milestone_Status__c 
                                                        FROM MPOT_Project_Milestone__c WHERE Id =:sMSId ];
                                                        
           
            if (lPrjtMilestone.size()>0){
                oMilestone = lPrjtMilestone [0];
                Milestone = oMilestone.Milestone_name__c;
                Submilestone = oMilestone.Sub_Milestone_name__c;
                  if(Submilestone <> '' && Milestone <> null){
                     SubMile();
                  }
                }
        }else{
        oMilestone = new MPOT_Project_Milestone__c();
        oMilestone.Project_Name__c = sPjectId;
        
        }
        if(oMilestone.OwnerId == userInfo.getUserId()){
            bIsOwner =  true;
        }

    }
   /* 
     * Method name : SubMile
     * Description :  This method gets the Submilestone List
     * Param : none  
     * Returns :  pageReference 
    */
    public pageReference SubMile(){
         SubmilestoneList = new List<SelectOption>();
         if(MapSubmlstn.containsKey(milestone)){
             for(string s : MapSubmlstn.get(milestone)){
                 SubmilestoneList.add(new SelectOption(s, s));
             } 
         }
         return null;   
    }
       /* 
     * Method name : returnMilSubMilestone
     * Description :  This method get the milestone and Submilestone values
     * Param : list<GLBL_Global_List_of_Values__c>  
     * Returns :  Map<String,List<String>>
    */
    public static Map<String,List<String>> returnMilSubMilestone(list<GLBL_Global_List_of_Values__c> lmilestone){
        
        Map<String,List<String>> MapSubmlstn = new Map<String,List<String>>();
        MapSubmlstn.put('',new List<String>{''});
                                                       
        GLBL_Global_List_of_Values__c  objMilestone = lmilestone[0];
        Id valueRecTypeId =Schema.SobjectType.GLBL_Global_List_of_Values__c.getRecordTypeInfosByname().get('Sub-Milestone').getRecordTypeId();
        set<Id> milestone = (new Map<Id,GLBL_Global_List_of_Values__c>(lmilestone )).keySet();
        
        List<GLBL_Global_List_of_Values__c>  subMilestoneList =    [SELECT id,Name ,MPOT_Milestone__r.Name,MPOT_Milestone__c
                                                 FROM GLBL_Global_List_of_Values__c WHERE Active__c= true and
                                                RecordTypeId =: valueRecTypeId and MPOT_Milestone__r.Id IN : milestone];        
                                           
                                                 
        
       for(GLBL_Global_List_of_Values__c sm: subMilestoneList ){
            List<String> tmpList = new List<String>();
              
             
           if(MapSubmlstn.containsKey(sm.MPOT_Milestone__r.Name)){
                tmpList = MapSubmlstn.get(sm.MPOT_Milestone__r.Name);
                tmpList.add(sm.Name);
                MapSubmlstn.put(sm.MPOT_Milestone__r.Name,tmpList);              
            }else{
                tmpList.add(sm.Name);
                MapSubmlstn.put(sm.MPOT_Milestone__r.Name,tmpList);
            }
        }
        return MapSubmlstn;    
    }
       /* 
     * Method name : Confirm
     * Description : This method Confirms/Saves the new milestone
     * Param : none  
     * Returns :  pageReference 
    */
    public pageReference Confirm(){
     try{
        
        if(!Apexpages.currentPage().getParameters().containsKey('Id') &&( oMilestone.Start_date__c != null && oMilestone.End_date__c != null) &&( Milestone != null )){
            oMilestone.Milestone_name__c = Milestone;
            oMilestone.Sub_Milestone_name__c = Submilestone;
            insert oMilestone;
            createChangeLog('Add');
            PageReference pageRef =  new PageReference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oMilestone.Project_Name__c+'#Milestone');
            pageRef.setRedirect(true);
            return pageRef;
        }else{
                pagereference p = apexpages.Currentpage();
                ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR,'Please make sure Milestone, Start and End dates are filled!');
                ApexPages.addMessage(msg);
                return p;
            }
            
     }catch(Exception ex){
            ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, 'Please make sure Milestone, Start and End dates are filled!');
            ApexPages.addMessage(msg);
            return null;
            }
   }
      /* 
     * Method name : cancel
     * Description : This method Cancels the milestone
     * Param : none  
     * Returns :  pageReference 
    */
     public pageReference cancel(){
         return new pagereference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+ sPjectId+'#Milestone' );
    }
      /* 
     * Method name : del
     * Description : This method deletes the milestone
     * Param : none  
     * Returns :  pageReference 
    */
    public pageReference del()
    {
       try
        {
            Id iPrjtId = oMilestone.Project_Name__r.Id;
            createChangeLog('Delete');
            
            Database.Delete(oMilestone.Id , false);
            return new pagereference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+iPrjtId);
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            return null;
        }
    }
   /* 
     * Method name : goBack
     * Description : This method redirects to Project detail page
     * Param : none  
     * Returns :  pageReference 
    */
    public pageReference goBack(){
         return new pagereference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oMilestone.Project_Name__r.Id+'#Milestone' );
    }
     /* 
     * Method name : modify
     * Description : This method modify the milestone 
     * Param : none  
     * Returns :  pageReference 
     * Comments :modified by Lakshmi to save milestone details
    */
    
     public pageReference modify(){
         
        // view= true;
         modify = true;
        return null;
        
    }
    
      /* 
     * Method name : confirm_milestoneupdate
     * Description : This method Confirms the milestone update 
     * Param : none  
     * Returns :  pageReference 
     */
    public pageReference confirm_milestoneupdate(){
        try{
         if( modify == false){
              update oMilestone;
              return new pagereference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oMilestone.Project_Name__r.Id+'#Milestone' );
         }
        else if( oMilestone.New_Start_Date__c == null || oMilestone.New_End_Date__c == null || oMilestone.Reason_For_Change__c == null){
            {
                pagereference p = apexpages.Currentpage();
                ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR,'Please make sure New Start and End dates and Reason for Change is filled!');  
                ApexPages.addMessage(msg);
                return p;
            }
            
          
        }else{
            createChangeLog('Modify');
            oMilestone.Start_date__c = oMilestone.New_Start_Date__c;
            oMilestone.End_date__c = oMilestone.New_End_Date__c;
            oMilestone.New_Start_Date__c = null;
            oMilestone.New_End_Date__c = null;
            oMilestone.Reason_For_Change__c = null;
            update oMilestone;
            return new pagereference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oMilestone.Project_Name__r.Id+'#Milestone' );
        }
       
     }catch(Exception ex){
            ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, ex.getdmlMessage(0));
            ApexPages.addMessage(msg);
            return null;
            }
       
       
    }
       /* 
     * Method name : cancelEdit
     * Description : This method cancels the milestone edit
     * Param : none  
     * Returns :  pageReference 
     */
    public pageReference cancelEdit(){
         return new pagereference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oMilestone.Id+'#Milestone');
    }
       /* 
     * Method name : cancel_milestoneupdate
     * Description : This method cancels the milestone update 
     * Param : none  
     * Returns :  pageReference 
     */
    public pageReference cancel_milestoneupdate(){
        return new pagereference(MPOT_Setting__c.getValues('ViewPageWithId').Message__c+oMilestone.Project_Name__r.Id+'#Milestone' );
    } 
       /* 
     * Method name : createChangeLog
     * Description : This method creates change log
     * Param : String activity 
     * Returns :  void
     */
    public void createChangeLog(String activity){
            Id valueRecTypeId1 =Schema.SobjectType.MPOT_Change_Log__c.getRecordTypeInfosByname().get('MPOT Milestone Log').getRecordTypeId();
                
        
            MPOT_Change_Log__c newRecord = new MPOT_Change_Log__c();
            //newRecord.Project__c = oMilestone.Project_Name__c;
           // newRecord.Project_Name__c = oMilestone.Project_Name__c;
            newRecord.Project_for_Milestone_Change_Log__c = oMilestone.Project_Name__c;
            newRecord.Milestone_Name__c = oMilestone.Milestone_name__c ;
            newRecord.Milestone_Status__c = oMilestone.Milestone_Status__c;
            newRecord.Sub_Milestone_Name__c = oMilestone.Sub_Milestone_name__c;
            newRecord.Project_Milestone__c = oMilestone.Project_Name__c;
            
            if(oMilestone.Start_date__c != oMilestone.New_Start_Date__c ){
                newRecord.New_Start_Date__c = oMilestone.New_Start_Date__c;
            }else{
                newRecord.New_Start_Date__c = null;
            }
            if(oMilestone.End_date__c != oMilestone.New_End_Date__c){
                
                newRecord.New_End_Date__c = oMilestone.New_End_Date__c;
            }else{
                 newRecord.New_End_Date__c = null;
            }
            
            newRecord.Previous_Start_Date__c = oMilestone.Start_date__c;
            newRecord.Previous_End_Date__c = oMilestone.End_date__c;
            newRecord.Reason_for_Change__c = oMilestone.Reason_For_Change__c;
            newRecord.Modified_By__c = UserInfo.getUserID();
            newRecord.Modified_On__c = System.now();
            //newRecord.Project__c = oMilestone.Project_Name__r.Id;
            newRecord.Project_Milestone__c = oMilestone.Id;
            newRecord.Activity__c = activity;
            newRecord.RecordTypeId = valueRecTypeId1;
            insert newRecord;
        
    }
    
}
