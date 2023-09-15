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

	  	 debugLogger.debug(loggingCommonFormat + "*************** OtpValidation subflow LoadProps Entry **************************");
	  	 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
	  	appSession.put("otpAvailable","");
		String ucid = 	appSession.getString("ucid");
		appSession.put(GlobalConstant.MAX_RETRY_COUNT,3);
		appSession.put("overallCounter",0);
		appSession.put("MENUTRAVERSE",appSession.getString("MENUTRAVERSE")+":"+"OTP_Authentication");
		appSession.put("LASTMENU","OTP_Authentication");
	  	try{

				if("NA".equalsIgnoreCase(appSession.getString("MOBILE"))){
					appSession.put("otpAvailable","No");
				}
				else{
					appSession.put("otpAvailable","yes");
				}
	  			debugLogger.debug(loggingCommonFormat + " MOBILE : "+appSession.getString("MOBILE"));
	  	if("Yes".equalsIgnoreCase(appSession.getString("otpAvailable"))&&!appSession.getString("MOBILE").isEmpty()){
	  	UAASController controller = (UAASController) SpringApplicationContext.getBean("UAASController");
		GenerateOTP_Req reqObj = new GenerateOTP_Req();
		GenerateOTP_Res res = new GenerateOTP_Res();
		reqObj.setMobileNumber(appSession.getString("MOBILE"));
		reqObj.setRelId(appSession.getString("relID"));		
		reqObj.setLanguage("english");
		reqObj.setUcid(ucid);
		reqObj.setHotline(appSession.getString("DNIS"));
		reqObj.setSessionId(sessionID);
		debugLogger.debug(loggingCommonFormat + "GenerateOTP_Req request : "+ reqObj);
		res = controller.generateOTP(reqObj);
		debugLogger.debug(loggingCommonFormat + "GenerateOTP_Req response : "+ res);
		debugLogger.debug(loggingCommonFormat + "ErrorCode : "+ res.getErrorcode());
		debugLogger.debug(loggingCommonFormat + "ErrorMessage : "+res.getErrormessage());
		if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
				appSession.put("otpAvailable","Yes");
				appSession.put("otp",res.getOtpResponse().getOtpSn());
	  			String mobFour = appSession.getString("MOBILE").substring(appSession.getString("MOBILE").length()-4, appSession.getString("MOBILE").length());
	  			appSession.put("mobfour",Integer.parseInt(mobFour));
	  			debugLogger.debug(loggingCommonFormat + "otp generated successfully");
	  			debugLogger.debug(loggingCommonFormat + "otp value : "+res.getOtpResponse().getOtpSn());
			}
		else if("111111".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("otpAvailable","No");
			debugLogger.debug(loggingCommonFormat + "Failure Exception or Validation Error Message/Unknown Error");
		}
		else if("001024".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("otpAvailable","No");
			debugLogger.debug(loggingCommonFormat + "SMS Delivery failed");
		}
		else if("000152".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("otpAvailable","No");
			debugLogger.debug(loggingCommonFormat + "Invalid OTP message template");
		}
		else if("001368".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("otpAvailable","No");
			debugLogger.debug(loggingCommonFormat + "OTP Blocked");
		}
			else{
				debugLogger.debug(loggingCommonFormat + "Internal Server Error");
				appSession.put("otpAvailable","No");
			}
	  	}
	  	}
	    catch(Exception e){
		    debugLogger.error(loggingCommonFormat + "Exception : "+e);
		    appSession.put("otpAvailable","Error");
	    }
	  	  debugLogger.debug(loggingCommonFormat +" Otp Available : "+appSession.getString("otpAvailable"));
		  	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	  	  debugLogger.debug(loggingCommonFormat + "*************** OtpValidation subflow LoadProps Exit **************************");
	    result.put("appSession",appSession);
    return result;
    
};
%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerContactDetails_Req"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerContactDetails_Res"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.controller.EBBSController"%>
<%@page import="com.scb.ivr.model.uaas.GenerateOTP_Res"%>
<%@page import="com.scb.ivr.model.uaas.GenerateOTP_Req"%>
<%@page import="com.scb.ivr.controller.UAASController"%>
<%@page import="com.scb.ivr.model.ebbs.res.custcontact.CustomerContactDetail_Data"%>
<%@include file="../include/backend.jspf" %>