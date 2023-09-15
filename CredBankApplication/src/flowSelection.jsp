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
debugLogger.debug(loggingCommonFormat + "****************flow Selection Entry *********************");
debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
try{
JSONObject menuObject = state.getJSONObject("menuObject");
String retValue = state.getString("dtmfInput");
String retResult = state.getString("returnResult");
String[] node = menuObject.getString("NEXT_NODE").split(",");
String[] dtmf = menuObject.getString("GRAMMARS").split(",");
HashMap<String, String> nextNodeMapping = new HashMap<>();
for(int promptCount=0;promptCount<node.length;promptCount++) {
	nextNodeMapping.put(dtmf[promptCount],node[promptCount]);
}
debugLogger.debug("map value : "+nextNodeMapping);
String nextNode = nextNodeMapping.get(retValue);
if(nextNode.split("~")[0].equalsIgnoreCase("SF")){
	appSession.put("nextForm", "../src-gen/"+nextNode.split("~")[1]+".vxml");
	appSession.put("nextNode", "SF");
}else if(nextNode.split("~")[0].equalsIgnoreCase("NM")){
	appSession.put("nextForm", "#menuProperty");
	appSession.put("menuName",nextNode.split("~")[1]);
	appSession.put("nextNode", "NM");
	debugLogger.debug(loggingCommonFormat + "Next Menu Name : "+ appSession.getString("menuName"));
}else {
	appSession.put("nextForm", "#"+nextNode);
	appSession.put("nextNode", "others");
}
}
catch(Exception e){
	debugLogger.error(loggingCommonFormat + "Exception : "+e);
	System.out.println(e);
}
debugLogger.debug(loggingCommonFormat + "Next Flow value : "+ appSession.getString("nextForm"));
debugLogger.debug(loggingCommonFormat + "Next Node value : "+ appSession.getString("nextNode"));
debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
debugLogger.debug(loggingCommonFormat + "****************flow Selection Exit *********************");
result.put("appSession",appSession);
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