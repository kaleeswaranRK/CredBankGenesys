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
	debugLogger.debug(loggingCommonFormat + "***********tpinvalue Check Block Entry***********");
  	 debugLogger.debug(loggingCommonFormat + "AppSession Starting Value : "+ appSession);
	debugLogger.debug(loggingCommonFormat + "pinvalue : "+CvvOrPinMasker.maskPIN(state.getString("tPinValue"))+" ");
    try{
    	CASASController casasController = (CASASController) SpringApplicationContext.getBean("CASASController");
    	ValidateTPIN_Req requestDetails = new ValidateTPIN_Req();
    	requestDetails.setUserid(appSession.getString("relID"));
    	String pass = DigestUtils.sha256Hex(state.getString("tPinValue"));
    	debugLogger.debug(loggingCommonFormat + "pinvalue Hash value : "+pass);
    	requestDetails.setPassword(pass);
    	requestDetails.setSessionId(sessionID);
    	requestDetails.setUcid(appSession.getString("ucid"));
    	requestDetails.setHotline(appSession.getString("DNIS"));
    	debugLogger.debug(loggingCommonFormat + "ValidateTPIN_Req request : "+requestDetails);
    	ValidateTPIN_Res res = casasController.validateTPIN(requestDetails);
    	res.getErrorcode();
    	res.getErrormessage();
    	debugLogger.debug(loggingCommonFormat + "Error code : "+res.getErrorcode());
		debugLogger.debug(loggingCommonFormat + "ErrorMessage : "+res.getErrormessage());
    	debugLogger.debug(loggingCommonFormat + "ValidateTPIN_Req request : "+res);
    	if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
    		debugLogger.debug(loggingCommonFormat + "TPIN HAS BEEN SUCCESSFULLY FETCHED");
				appSession.put("tpinStatus","Yes");
				appSession.put("TPINAUTH","S");
			   	appSession.put("VERIFIEDBY","TPIN");
		}
    	else if("700041".equalsIgnoreCase(res.getErrorcode())||"700004".equalsIgnoreCase(res.getErrorcode())){
    		debugLogger.debug(loggingCommonFormat + "TPIN HAS BEEN BLOCKED");
			appSession.put("tpinStatus","Blocked");
			appSession.put("TPINAUTH","F");
		}
    	else if("700013".equalsIgnoreCase(res.getErrorcode())||"000118".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("tpinStatus","Invalid");
    		debugLogger.debug(loggingCommonFormat + "TPIN IS INVALID");
		}
			else{
	    		debugLogger.debug(loggingCommonFormat + "ERROR WHILE FETCH TPIN VALUE");
				appSession.put("tpinStatus","Error");
			}
    }catch(Exception e){
    	appSession.put("tpinStatus","Error");
        debugLogger.debug(loggingCommonFormat + "Exception : "+e);   

    	}
    String ONEFA=appSession.getString(GlobalConstant.ONEFA);
    String[] split = ONEFA.split(",");
	String oneFAChange="";
	for (String value : split) {
		String[] split2 = value.split("[|]");
		if(split2[0].equalsIgnoreCase("TPIN")) {
			oneFAChange=oneFAChange+"TPIN"+"|"+appSession.getString("TPINAUTH")+",";
		}
		else{
			oneFAChange=oneFAChange.concat(value);
		}
	}
	appSession.put(GlobalConstant.ONEFA,oneFAChange);
	debugLogger.debug("oneFA value : " + appSession.getString(GlobalConstant.ONEFA));
	debugLogger.debug(loggingCommonFormat + "tpin Status : "+appSession.getString("tpinStatus"));
    result.put("appSession",appSession);
 	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	debugLogger.debug(loggingCommonFormat + "************tpinvalue Check Block Exit***********");
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
    	<%@page import="com.scb.log4jmask.CvvOrPinMasker"%>
    	
<%@include file="../include/backend.jspf" %>