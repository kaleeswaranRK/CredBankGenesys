<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    

    
    JSONObject result = new JSONObject();
    
    JSONObject appSession = state.getJSONObject("appSession");
    String sessionID = state.getString("GVPSessionID").split(";")[0];
    String callID =state.getString("CallUUID").trim();
    
    String loggerName=sessionID;
     
    Date timeStamp = new Date();    
    
 	Logger debugLogger = LogManager.getLogger(loggerName);	
 //	String host="";
 	//String ucid ="";
 	String AccNumStatus="";
    String profileId="";
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
	try{
		
		debugLogger.debug(loggingCommonFormat + "--START ACCOUNT NUMBER VALIDATION BLOCK--");
		AccNumStatus=appSession.getString(GlobalConstant.ACCNUM);
		profileId=appSession.getString(GlobalConstant.RELID);
		System.out.println("Existing profileid is:"+profileId);
		debugLogger.debug(loggingCommonFormat + "Existing profileid is:"+profileId);
		debugLogger.debug(loggingCommonFormat + "Account number is:"+AccNumStatus);
		if(!"NA".equalsIgnoreCase(AccNumStatus)){
			System.out.println("ACCOUNT NUMBER IS AVAILABLE");
			debugLogger.debug(loggingCommonFormat + "Account number is:"+AccNumStatus);
			appSession.put("GOTO","MENU");
			debugLogger.debug(loggingCommonFormat + "Account number is available so go to :"+appSession.getString("GOTO"));
			
		}
		else {
			System.out.println("ACCOUNT NUMBER IS UNAVAILABLE");
			debugLogger.debug(loggingCommonFormat + "Account number is:"+AccNumStatus);
			appSession.put("GOTO","INPUT");
			debugLogger.debug(loggingCommonFormat + "Account number is not available so go to :"+appSession.getString("GOTO"));
		}
		
	    String TRAVERSE=appSession.getString(GlobalConstant.MENUTRAVERSE)+":";
		appSession.put(GlobalConstant.MENUTRAVERSE,TRAVERSE+"ACC_INFO");
		appSession.put(GlobalConstant.LASTMENU,"ACC_INFO");
		
	}
	catch(Exception e){
		System.out.println("Exception caught in AccNumberValidation Block:"+e.getMessage());
		return result;
	}
    
	result.put("appSession",appSession);
	debugLogger.debug(loggingCommonFormat + "AppSession Variables:"+appSession);
	debugLogger.debug(loggingCommonFormat + "---ACCNUMBER VALIDATION BLOCK END");
    return result;
    
};
%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@include file="../include/backend.jspf" %>