<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    
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
 JSONObject result = new JSONObject();
 try{
 debugLogger.debug(loggingCommonFormat + "****************Menu Assign Entry**************");

 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);

	String menuName=state.getString("menuName");
	debugLogger.debug(loggingCommonFormat + "menu name : "+ menuName);
	String DtmfGrammar = "Dtmf.grxml";
	ConfigController controller = (ConfigController) SpringApplicationContext.getBean("configController");
	debugLogger.debug(loggingCommonFormat + "MENU JSON FROM CONFIG : "+controller.getConfigFileValues("menu.json"));
	Map<String, Map<String, String>> mapvalue=(Map<String, Map<String, String>>) controller.getConfigFileValues("menu.json");
			Map<String, String> menuDetails=mapvalue.get(menuName);
			debugLogger.debug(loggingCommonFormat + "MENU JSON FROM map : "+menuDetails);
			debugLogger.debug(loggingCommonFormat +"prompts : "+menuDetails.get("PROMPTS"));
			debugLogger.debug(loggingCommonFormat +"BARGEIN : "+ menuDetails.get("BARGEIN"));
			debugLogger.debug(loggingCommonFormat + "GRAMMARS : "+menuDetails.get("GRAMMARS"));
			debugLogger.debug(loggingCommonFormat + "MENU_DESC : "+menuDetails.get("MENU_DESC"));
			debugLogger.debug(loggingCommonFormat + "MENU_DESC : "+menuDetails.get("NEXT_NODE"));
			debugLogger.debug(loggingCommonFormat + "NI_PROMPT : "+menuDetails.get("NI_PROMPT"));
			debugLogger.debug(loggingCommonFormat + "NM_PROMPT "+menuDetails.get("NM_PROMPT"));
			debugLogger.debug(loggingCommonFormat + "RETRY : "+menuDetails.get("RETRY"));
			debugLogger.debug(loggingCommonFormat + "STATE_ID : "+menuDetails.get("STATE_ID"));
			debugLogger.debug(loggingCommonFormat + "MENU_TIMEOUT : "+menuDetails.get("MENU_TIMEOUT"));
			debugLogger.debug(loggingCommonFormat + "MAXTRIES : "+menuDetails.get("MAXTRIES"));
			debugLogger.debug(loggingCommonFormat + "MAXTRIES_NEXTNODE : "+menuDetails.get("MAXTRIES_NEXTNODE"));
			debugLogger.debug(loggingCommonFormat + "INTENT : "+menuDetails.get("INTENT"));
			result.put("menuObject",menuDetails);
			result.put("bargein",menuDetails.get("BARGEIN"));
			result.put("initialPromptListprompts",menuDetails.get("PROMPTS"));
			result.put("acceptedDTMFList",menuDetails.get("GRAMMARS"));
			result.put("nextNode",menuDetails.get("NEXT_NODE"));
			result.put("maxTriesNextNode",menuDetails.get("MAXTRIES_NEXTNODE"));
			result.put("retryPromptList", menuDetails.get("NM_PROMPT"));
			result.put("retry2PromptList", menuDetails.get("NM_PROMPT"));
			result.put("maxRetryPromptList",menuDetails.get("MAXTRIES"));
			result.put("timeoutPromptList", menuDetails.get("NI_PROMPT"));
			result.put("timeout2PromptList", menuDetails.get("NI_PROMPT"));
			result.put("maxRetries",menuDetails.get("RETRY"));
			result.put("maxTimeouts",menuDetails.get("RETRY"));
			result.put("propTimeout",menuDetails.get("MENU_TIMEOUT"));
			result.put("DtmfGrammar",DtmfGrammar);
			result.put("minInputLength", "1");
			result.put("maxInputLength", "1");
			result.put("interTimeout", "2s");
			result.put("termChar", "#");
			result.put("inputType", "dtmf");
			result.put("interdigitTimeout","7s");
			result.put("invalidCounter", 0);
			result.put("overallCounter", 0);
			result.put("timeoutCounter",0);

	debugLogger.debug("Result value : "+result);
	debugLogger.debug("DTMF value : "+result.getString("DtmfGrammar"));
	debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	debugLogger.debug(loggingCommonFormat + "****************Menu Assign Exit**************");
 }
 catch(Exception e){
		debugLogger.error(loggingCommonFormat + "Exception while menu assign : "+e);
 }
 return result;
 
};
%>
<%-- GENERATED: DO NOT REMOVE --%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.scb.ivr.controller.ConfigController"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="java.util.Map"%>
<%@include file="../include/backend.jspf"%>