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
    
 	Logger debugLogger = null;
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
    
 	String AccNum="";
 	String last_Digit="";
	try{
		debugLogger.debug(loggingCommonFormat + "--START GET ACCOUNT NUMBER VALIDATION BLOCK--");
		AccNum=appSession.getString(GlobalConstant.ACCNUM);
		debugLogger.debug(loggingCommonFormat + "YOUR ACCOUNT NUMBER IS GetAccNumber BLOCK:"+AccNum);
		last_Digit=AccNum.substring(7,11);
		System.out.println("Account Number ending with last four digit is"+last_Digit);
		System.out.println("Account Number ending with last four digit is:"+last_Digit);
		appSession.put("ACCNUMVOICE",last_Digit);
		System.out.println("Account Number ending with last four digit in voice:"+appSession.getString("ACCNUMVOICE"));
		
	}
	catch(Exception e){
		System.out.println("Exception caught in GetAccNumber Backend Block:"+e.getMessage());
		return result;
	}
	result.put("appSession",appSession);
	debugLogger.debug(loggingCommonFormat + "END GET ACCOUNT NUMBER VALIDATION BLOCK appSession values are:"+appSession);
	debugLogger.debug(loggingCommonFormat + "---END GET ACCOUNT NUMBER VALIDATION BLOCK--");
    return result;
    
};
%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@include file="../include/backend.jspf" %>