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
	try{
	debugLogger.debug(loggingCommonFormat + "**************mobileUpdate flow Config Entry ***********");
 	 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
 	debugLogger.debug("SMS Triggered for both RMN : " +appSession.getString("MOBILE") +" The new number : "+state.getString("mobNum1"));
    	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
    	debugLogger.debug(loggingCommonFormat + "**************mobileUpdate flow Config Exit ***********");
    	appSession.put(GlobalConstant.DISCONNECTREASON,"SUCCESS");
	}
	catch(Exception e){
    	appSession.put(GlobalConstant.DISCONNECTREASON,"FAILIURE");
	    debugLogger.error(loggingCommonFormat + "Exception : "+e);
	}
        result.put("appSession",appSession);
    	return result;
        	};
        	%>
        	<%-- GENERATED: DO NOT REMOVE --%>
        	<%@page import="com.scb.util.GlobalConstant"%>
        	<%@page import="org.json.JSONObject"%>
        	<%@page import="org.json.JSONException"%>
        	<%@page import="java.util.Map"%>
        	<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
        	<%@page import="java.util.*"%>
<%@include file="../include/backend.jspf" %>