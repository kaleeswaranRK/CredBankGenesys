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
	appSession.put(GlobalConstant.MAX_RETRY_COUNT,3);
	appSession.put("overallCounter",0);
	try{
	debugLogger.debug(loggingCommonFormat + "**************mobileUpdate flow Config Entry ***********");
 	 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
 	debugLogger.debug("Customer Identified : " + appSession.getString(GlobalConstant.ISRMN));
	appSession.put("MENUTRAVERSE",appSession.getString("MENUTRAVERSE")+":"+"MOBILE_UPDATE");
	appSession.put("LASTMENU","MOBILE_UPDATE");
    	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
        result.put("appSession",appSession);
	}
	catch(Exception e){
	  	debugLogger.error("Exception "+e);
	}
	debugLogger.debug(loggingCommonFormat + "**************mobileUpdate flow Config Exit ***********");
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
        	<%@page import="com.scb.util.GlobalConstant"%>
        	
<%@include file="../include/backend.jspf" %>