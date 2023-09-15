<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
	 String sessionID = state.getString("GVPSessionID").split(";")[0];
     String callID = state.getString("CallUUID").trim();
    JSONObject appSession = state.getJSONObject("appSession");    
	JSONObject result = new JSONObject();
    String loggerName = appSession.getString("loggerName");
    Date timeStamp = new Date();
    Logger debugLogger = null;
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
	String ucid = 	appSession.getString("ucid");
    appSession.put("menuName","menuVXML");
	appSession.put("ErrorCode","");
	try{
	   

	    debugLogger.debug(loggingCommonFormat + "***************preferLangSet Block Entry **************************");
   	 debugLogger.debug(loggingCommonFormat + "AppSession Starting Value : "+ appSession);

	    DBController dbController = (DBController) SpringApplicationContext.getBean("DBController");
	    String reliId= appSession.getString("relID");
	    debugLogger.debug(loggingCommonFormat + "LANGUAGECODE  "+appSession.getString("LANGUAGECODE"));

	   String lang= appSession.getString("LANGUAGECODE");
	    String ANI=appSession.getString("ANI");
	    Map<String, Object> inParams = new HashMap<String, Object>();
	    inParams.put("cli", ANI);
	    inParams.put("relId", reliId);
	    inParams.put("langCode", lang);
	    inParams.put("sessionId", sessionID);
	    debugLogger.debug(loggingCommonFormat + "In param  "+inParams);
	    PrefereredLangUpdate_Res prefereredLangUpdate_Res = dbController.setPreferredLanguage(inParams);
	    prefereredLangUpdate_Res.getErrorcode();
	    prefereredLangUpdate_Res.getErrormessage();
	    prefereredLangUpdate_Res.getStatus();
	    debugLogger.debug(loggingCommonFormat + "After prefereredLangUpdate_Res  "+prefereredLangUpdate_Res);
	     debugLogger.debug(loggingCommonFormat + "ErrorCode  "+ prefereredLangUpdate_Res.getErrorcode());
	      debugLogger.debug(loggingCommonFormat + "ErrorMessage  "+   prefereredLangUpdate_Res.getErrormessage());
	      debugLogger.debug(loggingCommonFormat + "Insert Status  "+  prefereredLangUpdate_Res.getStatus());
	      appSession.put("ErrorCode",prefereredLangUpdate_Res.getErrorcode());
   
	}catch(Exception e){
		 debugLogger.debug(loggingCommonFormat + "Exception  "+ e);
	} 
	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
     debugLogger.debug(loggingCommonFormat + "***************preferLangSet Block Ended**************************");
     result.put("menuName","menuVXML");
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
<%@page import="com.scb.ivr.db.res.PrefereredLangUpdate_Res"%>
<%@page import="com.scb.ivr.controller.DBController"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@include file="../include/backend.jspf" %>