<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    
	 JSONObject result = new JSONObject();
		JSONObject appSession = state.getJSONObject("appSession");
	   	String loggerName = appSession.getString("loggerName");
		   Logger debugLogger = null;
		   String sessionID = state.getString("GVPSessionID").split(";")[0];
	   	String callID = state.getString("CallUUID").trim();
	   	Date timeStamp = new Date();
		String className = new Object(){}.getClass().getEnclosingClass().getName();
		className = className.split("[.]")[4];
		String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
		debugLogger=Logging.LoggerConfiguration(sessionID);
	  	  debugLogger.debug(loggingCommonFormat + "*************** UserAuthentication LoadProps Entry **************************");
	  	 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
	 	appSession.put(GlobalConstant.MAX_RETRY_COUNT,3);
		appSession.put("overallCounter",0);
		appSession.put("isCutstIden","NO");
		appSession.put("MENUTRAVERSE",appSession.getString("MENUTRAVERSE")+":"+"USER_Authentication");
		appSession.put("LASTMENU","USER_Authentication");
	    try{
		  	debugLogger.debug("Customer Identified : " + appSession.getString(GlobalConstant.ISRMN));
			String oneFA=appSession.getString(GlobalConstant.ONEFA);
			String[] split = oneFA.split(",");
			for (String value : split) {
				String[] split2 = value.split("[|]");
				if(split2[0].equalsIgnoreCase("TPIN")&&split2[1].equalsIgnoreCase("F")) {
					appSession.put("TPINAUTH","F");
				}
				else if (split2[0].equalsIgnoreCase("TPIN")&&split2[1].equalsIgnoreCase("S")) {
					appSession.put("TPINAUTH","S");
				}
				else if (split2[0].equalsIgnoreCase("TPIN")&&split2[1].equalsIgnoreCase("NA")) {
					appSession.put("TPINAUTH","NA");
				}
				else if (split2[0].equalsIgnoreCase("OTP")&&split2[1].equalsIgnoreCase("F")) {
					appSession.put("OTPAUTH","F");
				}
				else if (split2[0].equalsIgnoreCase("OTP")&&split2[1].equalsIgnoreCase("NA")) {
					appSession.put("OTPAUTH","NA");
				}
				else {
					appSession.put("OTPAUTH","S");
				}
			}
			debugLogger.debug("oneFA value : " + oneFA);
	    }
	    catch(Exception e){
		    debugLogger.error(loggingCommonFormat + "Exception : "+e);
	    	System.out.println(e);
	    }
	  	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	  	  debugLogger.debug(loggingCommonFormat + "*************** UserAuthentication LoadProps Exit **************************");
	    result.put("appSession",appSession);
    return result;
    
};
%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerContactDetails_Req"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerContactDetails_Res"%>
<%@include file="../include/backend.jspf" %>