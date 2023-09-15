<%@page language="java" contentType="application/json;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
	 JSONObject result = new JSONObject();

	  
    try{
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
  	   debugLogger.debug("*********** Json parse Entry **********");
  	    debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
//	JSONObject obj = new JSONObject(new String(Files.readAllBytes(Paths.get("D:/Subbu/config/menu.json"))));
//	debugLogger.debug("Menu json value : "+obj.getJSONObject("DynamicMenu"));
//  ConfigController configcontroller = (ConfigController) SpringApplicationContext.getBean("configController");
//	debugLogger.debug(loggingCommonFormat + "MENU JSON FROM CONFIG : "+configcontroller.getConfigFileValues("menu.json"));
//	JSONObject obj = new JSONObject(configcontroller.getConfigFileValues("menu.json").toString());
//	result.put("flowDetails",obj.getJSONObject("DynamicMenu").getJSONObject("country").getJSONArray("entry"));
    debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	debugLogger.debug("*********** Json parse Exit **********");
    }
    catch(Exception e){
    	System.out.println("Json parse Exception"+e);
    }

 return result;
 
};
%>
<%-- GENERATED: DO NOT REMOVE --%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
    	<%@page import="com.scb.ivr.controller.ConfigController"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>

<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@include file="../include/backend.jspf"%>