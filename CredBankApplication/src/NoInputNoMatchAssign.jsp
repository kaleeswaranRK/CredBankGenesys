<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    
	JSONObject result = new JSONObject();
    String sessionID = state.getString("GVPSessionID").split(";")[0];
    String callID = state.getString("CallUUID").trim();
   JSONObject appSession = state.getJSONObject("appSession");    
   String loggerName = appSession.getString("loggerName");
   Date timeStamp = new Date();
   Logger debugLogger = null;
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
	String otpNum=state.getString("otpNum");
    try{
		  debugLogger.debug(loggingCommonFormat + "***************No input No match Assign Block Entry**************************");
		  appSession.getString("NoInputCount");
		  appSession.getString("NoMatchCount");
		  appSession.getString("MaxCount");

    }catch(Exception e){
    	 debugLogger.error(loggingCommonFormat + "Exception :" +e);
    }
	  debugLogger.debug(loggingCommonFormat + "***************No input No match Assign Conversion Block Exit**************************");
	  result.put("appSession",appSession);
    return result;
    
};
%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Map"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.util.*"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.model.uaas.ValidateOTP_Req"%>
<%@page import="com.scb.ivr.model.uaas.ValidateOTP_Res"%>
<%@page import="com.scb.ivr.controller.UAASController"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@include file="../include/backend.jspf" %>