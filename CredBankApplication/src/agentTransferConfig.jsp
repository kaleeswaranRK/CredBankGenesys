<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
	 JSONObject result = new JSONObject();
		JSONObject appSession = state.getJSONObject("appSession");
	   	String loggerName = appSession.getString("loggerName");
		   Logger debugLogger = LogManager.getLogger(loggerName);
		   String sessionID = state.getString("GVPSessionID").split(";")[0];
	   	String callID = state.getString("CallUUID").trim();
	   	Date timeStamp = new Date();
		String className = new Object(){}.getClass().getEnclosingClass().getName();
		className = className.split("[.]")[4];
		String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
		debugLogger=Logging.LoggerConfiguration(sessionID);
	   	String ucid=appSession.getString("ucid");
	  	debugLogger.debug(loggingCommonFormat + "*************** agentTransfer subflow LoadProps Entry **************************");
		debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
		appSession.put(GlobalConstant.MAX_RETRY_COUNT,3);
		appSession.put("overallCounter",0);
		String isAgentAvailable="NO";
		appSession.put("Holiday","NA");
		appSession.put("ServiceHrs","NA");
		appSession.put("ServiceHrsAvailable","NA");
		appSession.put("VDNAvailable","NA");
	    appSession.put("startTime","NA");
	    appSession.put("endTime","NA");
		appSession.put("ERRORCOUNT",1);
	    try{
	    	DBController dbController = (DBController) SpringApplicationContext.getBean("DBController");
	    	BusinessHrsCheck_Req reqObj = new  BusinessHrsCheck_Req();
			reqObj.setSegment("PriorityBanking");
			reqObj.setLanguage("English");
			reqObj.setProduct("Staff");
			reqObj.setSessionId(sessionID);
			reqObj.setHotline(appSession.getString("DNIS"));
			reqObj.setUcid(appSession.getString("ucid"));
			 debugLogger.debug(loggingCommonFormat + " BusinessHrsCheck_Req rquest  :"+reqObj );
			BusinessHrsCheck_Res businessHrsCheck_Res = dbController.checkBusinessHours(reqObj);
			debugLogger.debug(loggingCommonFormat + " BusinessHrsCheck_Req response  :"+businessHrsCheck_Res );
			appSession.put("Holiday",businessHrsCheck_Res.isHoliday());
			appSession.put("ServiceHrs",businessHrsCheck_Res.isServiceHrs());
			appSession.put("ServiceHrsAvailable",businessHrsCheck_Res.isServiceHrsCheckAvailable());
			appSession.put("VDNAvailable",businessHrsCheck_Res.isVDNAvailable());
//		    appSession.put("startTime",businessHrsCheck_Res.getServiceHrsStartTime());
//		    appSession.put("endTime",businessHrsCheck_Res.getServiceHrsEndTime());
		    appSession.put("startTime","1200");
		    appSession.put("endTime","1400");
			 debugLogger.debug(loggingCommonFormat + "ErrorCode  :"+ businessHrsCheck_Res.getErrorcode());
			 debugLogger.debug(loggingCommonFormat + "ErrorMessage  :"+   businessHrsCheck_Res.getErrormessage());
			 debugLogger.debug(loggingCommonFormat + "Holiday  :"+ businessHrsCheck_Res.isHoliday());
			 debugLogger.debug(loggingCommonFormat + "ServiceHrs  :"+  businessHrsCheck_Res.isServiceHrs());
			 debugLogger.debug(loggingCommonFormat + "ServiceHrsAvailable  :"+ businessHrsCheck_Res.isServiceHrsCheckAvailable());
			 debugLogger.debug(loggingCommonFormat + "service Start time  : "+ businessHrsCheck_Res.getServiceHrsStartTime()+" service End Time : "+businessHrsCheck_Res.getServiceHrsEndTime() );
			 debugLogger.debug(loggingCommonFormat + "VDNAvailable  :"+   businessHrsCheck_Res.isVDNAvailable());
			if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(businessHrsCheck_Res.getErrorcode())){
				if(businessHrsCheck_Res.isServiceHrs()&&businessHrsCheck_Res.isServiceHrsCheckAvailable()&&!(businessHrsCheck_Res.isHoliday())){
					isAgentAvailable="YES";
				}
				else{
					isAgentAvailable="NO";
				}
			}
			else if(GlobalConstant.DB_FAILURE_CODE.equalsIgnoreCase(businessHrsCheck_Res.getErrorcode())){
				 isAgentAvailable="NO";
				 debugLogger.debug(loggingCommonFormat + " Failure Exception or Validation Error Message/Unknown Error/DB Server Problem ");
			}
			else if(GlobalConstant.DB_RECORD_NOT_FOUND.equalsIgnoreCase(businessHrsCheck_Res.getErrorcode())){
				 debugLogger.debug(loggingCommonFormat + "Invalid input from IVR");
				 isAgentAvailable="NO";
			}
			else{
				debugLogger.debug(loggingCommonFormat + "Record Not Found in DB");
				 isAgentAvailable="NO";
			}
	    }
	    catch(Exception e){
		    debugLogger.error(loggingCommonFormat + "Exception : "+e);
	    	System.out.println(e);
	    	isAgentAvailable="NO";
	    }
	    appSession.put("isAgentAvailable",isAgentAvailable);
	    debugLogger.debug(loggingCommonFormat + "Agent Available Status : "+ appSession.getString("isAgentAvailable"));
	    debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	  	debugLogger.debug(loggingCommonFormat + "*************** agentTransfer subflow LoadProps Exit **************************");
	    result.put("appSession",appSession);
 return result;
 
};
%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.db.entity.BusinessHrsCheck_Req"%>
<%@page import="com.scb.ivr.db.entity.BusinessHrsCheck_Res"%>
<%@page import="com.scb.ivr.controller.DBController"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@include file="../include/backend.jspf" %>