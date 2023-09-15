<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    

    JSONObject result = new JSONObject();
    JSONObject appSession = state.getJSONObject("appSession");    
    String sessionID = state.getString("GVPSessionID").split(";")[0];
    String callID = state.getString("CallUUID").trim();

   String loggerName = appSession.getString("loggerName");
   Date timeStamp = new Date();
   Logger debugLogger = null;
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
   debugLogger.debug(loggingCommonFormat + "****************MainFlow Return**************************");
   String ini=state.getString("initialPromptList");
   debugLogger.debug(loggingCommonFormat + "initialPromptList : "+ini);
   debugLogger.debug(loggingCommonFormat + "Flow End");
    return result;
    
};
%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@include file="../include/backend.jspf" %>