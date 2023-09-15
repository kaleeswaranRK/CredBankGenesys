<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
	 JSONObject result = new JSONObject();
		JSONObject appSession = state.getJSONObject("appSession");
	   	String loggerName = appSession.getString("loggerName");
		   Logger debugLogger = null;
		   String sessionID = state.getString("GVPSessionID").split(";")[0];
	   	String callID = state.getString("CallUUID").trim();
	   	Date timeStamp = new Date();
		String className = new Object(){}.getClass().getEnclosingClass().getName();
		className = className.split("[.]")[4];
		String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
		debugLogger=Logging.LoggerConfiguration(sessionID);		String ucid = 	appSession.getString("ucid");
	    debugLogger.debug(loggingCommonFormat + "***************getReference Id Block ENTRY**************************");
	    debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
	    try{
	    	
	    	String accNum=state.getString("accNum");
	    	if(accNum.length()==11){
	    	    debugLogger.debug(loggingCommonFormat + "***************getReference Id by accout number **************************");
	  			debugLogger.debug(loggingCommonFormat + "relID : "+	appSession.getString("relID"));
	  			}
	    	else if(accNum.length()==16){
	    		String cardHost=appSession.getString("cardHost");
	    	    debugLogger.debug(loggingCommonFormat + "***************getReference Id by cardHost : "+cardHost+"**************************");
	    	if("C400".equalsIgnoreCase(cardHost)){
					C400Controller controller = (C400Controller) SpringApplicationContext.getBean("c400Controller");
					CustomerIdentificationCardNum_Req reqObj = new CustomerIdentificationCardNum_Req();
					reqObj.setCardNumber(accNum);
					reqObj.setSessionId(sessionID);
					reqObj.setUcid(ucid);
					reqObj.setHotline(appSession.getString("DNIS"));

					debugLogger.debug(loggingCommonFormat + "CustomerIdentificationCardNum_Req request : "+ reqObj);
					CustomerIdentificationCardNum_Res res = controller.getCustomerIdentificationCardNum(reqObj);
					debugLogger.debug(loggingCommonFormat + "CustomerIdentificationCardNum_Req response : "+ res);
					debugLogger.debug(loggingCommonFormat + "DB ErrorCoden : "+ res.getErrorcode());
		  			debugLogger.debug(loggingCommonFormat + "DB ErrorMessage : "+res.getErrormessage());
		  			if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
		  			debugLogger.debug(loggingCommonFormat + "relID : "+res.getResponse().getData().get(0).getAttributes().getCustomerId());
		  			appSession.put("relID",res.getResponse().getData().get(0).getAttributes().getCustomerId());
		  			}
		  			else if("700011".equalsIgnoreCase(res.getErrorcode())||"700013".equalsIgnoreCase(res.getErrorcode())){
			  			appSession.put("relID","NA");
		  			}
		  			else{
			  			appSession.put("relID","ERROR");
		  			}
				}
				else{
					EuronetController controller = (EuronetController) SpringApplicationContext.getBean("euronetController");
					CustomerIdentificationDebtCardNum_Req reqObj = new CustomerIdentificationDebtCardNum_Req();
					reqObj.setCardNumber(accNum);
					reqObj.setSessionId(sessionID);
					reqObj.setUcid(ucid);
					reqObj.setHotline(appSession.getString("DNIS"));

					CustomerIdentificationDebtCardNum_Res res = controller.getCustomerIdentificationDebtCardNum(reqObj);					
					debugLogger.debug(loggingCommonFormat + "DB ErrorCoden : "+ res.getErrorcode());
		  			debugLogger.debug(loggingCommonFormat + "DB ErrorMessage : "+res.getErrormessage());
		  			if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
			  		debugLogger.debug(loggingCommonFormat + "relID : "+res.getResponse().getRelationshipId());
		  			appSession.put("relID",res.getResponse().getRelationshipId());
		  			}
		  			else if("700011".equalsIgnoreCase(res.getErrorcode())||"700013".equalsIgnoreCase(res.getErrorcode())){
			  			appSession.put("relID","NA");
		  			}
		  			else{
			  			appSession.put("relID","ERROR");
		  			}
		  			
				}
	    	}
	    	if(!appSession.getString("relID").equalsIgnoreCase("NA")){
	    		EBBSController controller = (EBBSController) SpringApplicationContext.getBean("EBBSController");
				CustomerContactDetails_Req reqObj = new CustomerContactDetails_Req();
				CustomerContactDetails_Res res = new CustomerContactDetails_Res();
				reqObj.setProfileId(appSession.getString("relID"));
				reqObj.setSessionId(sessionID);
				reqObj.setUcid(ucid);
				reqObj.setHotline(appSession.getString("DNIS"));

				res = controller.getCustomerContactDetails(reqObj);
				debugLogger.debug(loggingCommonFormat + "ErrorCode : "+ res.getErrorcode());
	  			debugLogger.debug(loggingCommonFormat + "ErrorMessage : "+res.getErrormessage());
	  			if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
	  				CustomerContactDetail_Data[] data= res.getResponse().getData();
					 for(int i=0;i<data.length;i++) { 
					  CustomerContactDetail_Data datum = data[i];
					    if(datum.getAttributes().getContacttypecode().equalsIgnoreCase("MOB") && datum.getAttributes().getPrimarycontact().equalsIgnoreCase("Y")) {
						 String contact = datum.getAttributes().getContact(); 
						 debugLogger.debug(loggingCommonFormat+" contact number:"+contact); 
						 debugLogger.debug(loggingCommonFormat+" Primary contact type:"+datum.getAttributes().getContacttypecode());
						 debugLogger.debug(loggingCommonFormat+" Primary contact status:"+datum.getAttributes().getPrimarycontact());
						 appSession.put(GlobalConstant.MOBILE,contact);
						 } 
					 }	  				
	  			}
	  			else{
		  			debugLogger.debug(loggingCommonFormat + " MOBILE NUMBER IS NOT AVAILABLE");
	  			}
	    	}
	    }
   	 catch(Exception e){
   		    debugLogger.error(loggingCommonFormat + "Exception : "+e);
   	    }
	    debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
   	    debugLogger.debug(loggingCommonFormat + "***************getReference Id Block EXIT**************************");
   	    result.put("appSession",appSession);
		
   	    return result;
   	    };

%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.controller.C400Controller"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.model.c400.CustomerIdentificationCardNum_Req"%>
<%@page import="com.scb.ivr.model.c400.CustomerIdentificationCardNum_Res"%>
<%@page import="com.scb.ivr.controller.EuronetController"%>
<%@page import="com.scb.ivr.model.euronet.CustomerIdentificationDebtCardNum_Req"%>
<%@page import="com.scb.ivr.model.euronet.CustomerIdentificationDebtCardNum_Res"%>
<%@page import="com.scb.ivr.controller.EBBSController"%>
<%@page import="com.scb.ivr.controller.EBBSController"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerIdentificationAcctNum_Req"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerIdentificationAcctNum_Res"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerContactDetails_Req"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerContactDetails_Res"%>
<%@page import="com.scb.ivr.model.ebbs.res.custcontact.CustomerContactDetail_Data"%>
<%@include file="../include/backend.jspf" %>