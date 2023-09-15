<%@page language="java" contentType="application/json;charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	String ucid = 	appSession.getString("ucid");
	 debugLogger.debug(loggingCommonFormat + "******************prefered Language Entry******************");
    try{
    	 debugLogger.debug(loggingCommonFormat + "AppSession Starting Value : "+ appSession);
    	 
	    DBController dbController = (DBController) SpringApplicationContext.getBean("DBController");
	    Map<String, Object> inParams = new HashMap<String, Object>();
	    String ANI=state.getString("ANI");
	    inParams.put("cli", ANI);
	    inParams.put("sessionId", sessionID);
	    PrefereredLangCode_Res prefereredLangCode_Res = dbController.getPreferredLanguageBasedOnCLI(inParams);
		 debugLogger.debug(loggingCommonFormat + "ErrorCode"+ prefereredLangCode_Res.getErrorcode());
		  debugLogger.debug(loggingCommonFormat + "ErrorMessage"+   prefereredLangCode_Res.getErrormessage());
		  debugLogger.debug(loggingCommonFormat + "LanguageCode  "+  prefereredLangCode_Res.getLangCode());
	    	 if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(prefereredLangCode_Res.getErrorcode())){
		  appSession.put("LANGUAGECODE",prefereredLangCode_Res.getLangCode());
	    	 }

    }catch(Exception e){
	    debugLogger.error(loggingCommonFormat + "Exception : "+e);
    	System.out.println(e);
    }
 	 result.put("appSession",appSession);
 	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	 debugLogger.debug(loggingCommonFormat + "******************prefered Language Exit******************");
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
<%@page import="com.scb.ivr.db.res.PrefereredLangCode_Res"%>
<%@page import="com.scb.ivr.controller.DBController"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@include file="../include/backend.jspf"%>