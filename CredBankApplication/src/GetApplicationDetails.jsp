<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    
    JSONObject result = new JSONObject();
    
    String sessionID = state.getString("GVPSessionID").split(";")[0];
	String callID = state.getString("CallUUID").trim();
	Date timeStamp = new Date();
		
    Logger debugLogger = null; 
    JSONObject appSession = new JSONObject();
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
    result.put("ApplicationStatus","UNKNOWN");
  
    try{
		 
		appSession = state.getJSONObject("appSession");
		
		String loggerName = appSession.getString("loggerName");
	    debugLogger = LogManager.getLogger(loggerName);
	    	       	    
	    debugLogger.debug(loggingCommonFormat + "****************In SelfService CallFlow - GetApplicationDetails**************************"+"AppSession: " + appSession);
	    
	    String applicationNumber = state.getString("ApplicationInput");
	    
	    debugLogger.debug(loggingCommonFormat + "Application Number input entered by customer: " + applicationNumber);
	    
	    String ucid = appSession.getString("ucid");
		
		CASASController casasController = (CASASController) SpringApplicationContext.getBean("CASASController");
		
		ValidateTPIN_Req requestDetails = new ValidateTPIN_Req();
		
		requestDetails.setUserid(appSession.getString(GlobalConstant.RELID));
		String pass = DigestUtils.shaHex(applicationNumber);
		requestDetails.setPassword(pass);
		requestDetails.setSessionId(sessionID);
		requestDetails.setUcid(ucid);
		requestDetails.setHotline(appSession.getString("DNIS"));
		debugLogger.debug(loggingCommonFormat + "GetApplication request Details: " + requestDetails);

		ValidateTPIN_Res res = casasController.validateTPIN(requestDetails);
		debugLogger.debug(loggingCommonFormat + "GetApplication Response Details: " + res);
		
		if(res!=null) {
			
			if(res.getErrorcode().equals("000000")) {
				debugLogger.debug(loggingCommonFormat + "GetApplication: " + res.getErrormessage());
				result.put("ApplicationStatus","APPROVED");
			    
			}
			else if(res.getErrorcode().equalsIgnoreCase("000118") || res.getErrorcode().equalsIgnoreCase("000102")) {
				debugLogger.debug(loggingCommonFormat + "GetApplication - Failure: " + res.getErrormessage());
				result.put("ApplicationStatus","PENDING");
			}
			else if(res.getErrorcode().equalsIgnoreCase("700041") || res.getErrorcode().equalsIgnoreCase("700004")) {
				debugLogger.debug(loggingCommonFormat + "GetApplication - Failure: " + res.getErrormessage());
				result.put("ApplicationStatus","DECLINED");
			}
			else {
				debugLogger.debug(loggingCommonFormat + "GetApplication - Failure: " + res.getErrormessage());
			}
		} 
		else {
			debugLogger.debug(loggingCommonFormat + "GetApplication - Failure: Data not found");
		}
	    
    } catch(Exception e) {
		debugLogger.error(loggingCommonFormat + "Encountered exception in SelfService CallFlow - GetApplicationDetails: " + e);
	}
    
    appSession.put("overallCounter",0);    
    result.put("appSession", appSession);
      
    return result;
    
};
%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="com.util.Logging"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.List"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.controller.CASASController"%>
<%@page import="com.scb.ivr.model.casas.ValidateTPIN_Req"%>
<%@page import="com.scb.ivr.model.casas.ValidateTPIN_Res"%>
<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
<%@include file="../include/backend.jspf" %>