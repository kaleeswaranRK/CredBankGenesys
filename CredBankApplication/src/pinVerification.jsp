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
    try{
    	debugLogger.debug(loggingCommonFormat + "**************pin Active Verification Entry***********");
	  	 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
    	DBController dbController = (DBController) SpringApplicationContext.getBean("DBController");
    	String profileid= appSession.getString("relID");
    	debugLogger.debug(loggingCommonFormat + "relID : " + profileid);
    	AMIvrIntraction amIvrIntraction = new AMIvrIntraction();
    	amIvrIntraction.setRelID(profileid);
		debugLogger.debug(loggingCommonFormat + "Card DB request : "+amIvrIntraction);
    	AMIvrIntraction amIvrIntraction_Res = dbController.getAMIvrHost(amIvrIntraction);
		debugLogger.debug(loggingCommonFormat + "Card DB response : "+amIvrIntraction_Res);
        if(!amIvrIntraction_Res.getRelID().isEmpty()&&("ACTIVE").equalsIgnoreCase(amIvrIntraction_Res.getStatus())){
             appSession.put("tpinCheck","Active");
        }else if("BLOCKED".equalsIgnoreCase(amIvrIntraction_Res.getStatus())){
            appSession.put("tpinCheck","Blocked");
        }
        else{
            appSession.put("tpinCheck","Inactive");
       }
    }catch(Exception e){
    	appSession.put("tpinCheck","Error");
        debugLogger.debug(loggingCommonFormat + "Exception : "+e);   
    	}
    debugLogger.debug(loggingCommonFormat + "TPIN STATUS  : " +appSession.getString("tpinCheck"));
 	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);

	debugLogger.debug(loggingCommonFormat + "**************pin Active Verification Exit***********");
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
    	<%@page import="com.scb.ivr.controller.DBController"%>
    	<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
    	<%@page import="com.scb.ivr.db.entity.AMIvrIntraction"%>
    	<%@include file="../include/backend.jspf" %>
