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
	appSession.put("subFlowStatus","SUCCESS");
	debugLogger.debug(loggingCommonFormat + "**************pinVerification flow Config Entry ***********");
 	debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
	appSession.put("MENUTRAVERSE",appSession.getString("MENUTRAVERSE")+":"+"TPIN_Authentication");
	appSession.put("LASTMENU","TPIN_Authentication");
    debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
    debugLogger.debug(loggingCommonFormat + "**************pinVerification flow Config Exit ***********");
    result.put("appSession",appSession);
    return result;
        	};
        	%>
        	<%@page import="com.scb.util.GlobalConstant"%>
        	<%-- GENERATED: DO NOT REMOVE --%>
        	<%@page import="org.json.JSONObject"%>
        	<%@page import="org.json.JSONException"%>
        	<%@page import="java.util.Map"%>
        	<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
        	<%@page import="java.util.*"%>
<%@include file="../include/backend.jspf" %>