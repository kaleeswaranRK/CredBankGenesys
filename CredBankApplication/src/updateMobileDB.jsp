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
	debugLogger.debug(loggingCommonFormat + "***********updateMobileDB Block Entry***********");
  	 debugLogger.debug(loggingCommonFormat + "AppSession Starting Value : "+ appSession);
    try{
    	CASASController casasController = (CASASController) SpringApplicationContext.getBean("CASASController");
    	ValidateTPIN_Req requestDetails = new ValidateTPIN_Req();
    	requestDetails.setUserid(appSession.getString("relID"));

    	requestDetails.setPassword("1234");
    	requestDetails.setSessionId(sessionID);
    	requestDetails.setUcid(appSession.getString("ucid"));
    	requestDetails.setHotline(appSession.getString("DNIS"));
    	debugLogger.debug(loggingCommonFormat + "ValidateTPIN_Req request: "+requestDetails);
    	ValidateTPIN_Res res = casasController.validateTPIN(requestDetails);
    	debugLogger.debug(loggingCommonFormat + "ValidateTPIN_Req response: "+res);
    	res.getErrorcode();
    	res.getErrormessage();
    	debugLogger.debug(loggingCommonFormat + "Error code : "+res.getErrorcode());
		debugLogger.debug(loggingCommonFormat + "ErrorMessage : "+res.getErrormessage());
    	if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
				appSession.put("mobileUpdateStatus","Yes");
			}
    	else if("700004".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("mobileUpdateStatus","Blocked");
		}
    	else if("000118".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("mobileUpdateStatus","Invalid");
		}
			else{
				appSession.put("mobileUpdateStatus","Error");
			}
    }catch(Exception e){
    	appSession.put("mobileUpdateStatus","Error");
        debugLogger.debug(loggingCommonFormat + "Exception : "+e);   

    	}
	debugLogger.debug(loggingCommonFormat + "mobileUpdateStatus : "+appSession.getString("mobileUpdateStatus"));
    result.put("appSession",appSession);
 	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
 	debugLogger.debug(loggingCommonFormat + "***********updateMobileDB Block Exit***********");
	return result;

    	};
    	%>
    	<%-- GENERATED: DO NOT REMOVE --%>
    	<%@page import="org.json.JSONObject"%>
    	<%@page import="com.scb.util.GlobalConstant"%>
    	<%@page import="org.json.JSONException"%>
    	<%@page import="java.util.Map"%>
    	<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
    	<%@page import="java.util.*"%>
    	<%@page import="com.scb.ivr.controller.CASASController"%>
    	<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
    	<%@page import="com.scb.ivr.model.casas.ValidateTPIN_Req"%>
    	<%@page import="org.apache.commons.codec.digest.DigestUtils"%>
    	<%@page import="com.scb.ivr.model.casas.ValidateTPIN_Res"%>
<%@include file="../include/backend.jspf" %>