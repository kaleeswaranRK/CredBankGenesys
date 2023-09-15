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
 JSONObject menuDetails = new JSONObject();
 debugLogger.debug(loggingCommonFormat + "****************Menu Assign Entry**************");

 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
 
	JSONArray flowDetails=state.getJSONArray("flowDetails");
	String menuName=state.getString("menuName");
	debugLogger.debug(loggingCommonFormat + "menu name : "+ menuName);
	String DtmfGrammar = "Dtmf.grxml";
	for(int menuInput=0;menuInput<flowDetails.length();menuInput++){
		if(menuName.equalsIgnoreCase(flowDetails.getJSONObject(menuInput).getString("key"))){
			menuDetails=flowDetails.getJSONObject(menuInput).getJSONObject("value");
			System.out.println("menu name : "+menuDetails);
			result.put("menuObject",menuDetails);
			result.put("bargein",menuDetails.getString("bargein"));
			result.put("initialPromptListprompts",menuDetails.getString("prompts"));
			result.put("acceptedDTMFList",menuDetails.getString("grammars"));
			result.put("nextNode",menuDetails.getString("nextNode"));
//			result.put("noInput",menuDetails.getString("noInput"));
//			result.put("noMatch",menuDetails.getString("noMatch"));
//			result.put("maxtries",menuDetails.getString("maxtries"));
//			result.put("maxTriesNextNode",menuDetails.getString("maxTriesNextNode"));
			result.put("retryPromptList", menuDetails.getString("noMatch"));
			result.put("retry2PromptList", menuDetails.getString("noMatch"));
			result.put("maxRetryPromptList", menuDetails.getString("maxtries"));
			result.put("timeoutPromptList", menuDetails.getString("noInput"));
			result.put("timeout2PromptList", menuDetails.getString("noInput"));
			result.put("maxRetries",menuDetails.getString("retry"));
			result.put("maxTimeouts",menuDetails.getString("retry"));
			result.put("propTimeout",menuDetails.getString("timeOut"));
			result.put("DtmfGrammar",DtmfGrammar);
			result.put("minInputLength", "1");
			result.put("maxInputLength", "1");
//			result.put("propTimeout", "7s");
			result.put("interTimeout", "2s");
			result.put("termChar", "#");
			result.put("inputType", "dtmf");
			result.put("interdigitTimeout","2s");
			result.put("invalidCounter", 0);
			result.put("overallCounter", 0);
			result.put("timeoutCounter",0);
		}
	}
	debugLogger.debug("Result value : "+result);
	debugLogger.debug("DTMF value : "+result.getString("DtmfGrammar"));
	debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	debugLogger.debug(loggingCommonFormat + "****************Menu Assign Exit**************");


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
<%@page import="java.util.Map"%>
<%@include file="../include/backend.jspf"%>