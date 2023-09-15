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
   String ucid=appSession.getString("ucid");
   UAASController controller = (UAASController) SpringApplicationContext.getBean("UAASController");
       String profileid=appSession.getString(GlobalConstant.RELID);
     String contact=appSession.getString(GlobalConstant.MOBILE);
     String menutravel = appSession.getString(GlobalConstant.MENUTRAVERSE);
   try{
	   debugLogger.debug(loggingCommonFormat + "***************OtpSend.jsp Block Started**************************");
	    debugLogger.debug(loggingCommonFormat + "UCID is :" +ucid);
	    debugLogger.debug(loggingCommonFormat + "AppSession Started in OtpSend.jsp Block with Datas :"+ appSession);
	    debugLogger.debug(loggingCommonFormat + "Send request to DB that the card is lost and to initiate a SMS to RMN using generateOTP method ");
	   
	      GenerateOTP_Req reqObj = new GenerateOTP_Req();
		  GenerateOTP_Res res = new GenerateOTP_Res();
		  reqObj.setMobileNumber(contact);
		  reqObj.setRelId(profileid);		
		  reqObj.setLanguage("english");
		  reqObj.setUcid(ucid);
		  reqObj.setHotline(appSession.getString("DNIS"));
		  reqObj.setSessionId(sessionID);

		  debugLogger.debug(loggingCommonFormat + " using  generateOTP method in UAASController with  request is :"+reqObj.toString());
		  res = controller.generateOTP(reqObj);
		  debugLogger.debug(loggingCommonFormat + " using  generateOTP method in UAASController with  response is :"+res.toString());
		  debugLogger.debug(loggingCommonFormat + "ErrorCode for  generateOTP method in UAASController "+ res.getErrorcode());
  		  debugLogger.debug(loggingCommonFormat + "ErrorMessage for  generateOTP method in UAASController"+   res.getErrormessage());
		  if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
			  appSession.put(GlobalConstant.SMSSENT,"SENDED");
			  debugLogger.debug(loggingCommonFormat + " Trigger the SMS to Respective RMN and NRMN customer and its Sended Successfully");
		  }else if(GlobalConstant.HOST_FAILURE_CODE.equalsIgnoreCase(res.getErrorcode())){
			  appSession.put(GlobalConstant.SMSSENT,"NOTSENDED");
			  debugLogger.debug(loggingCommonFormat + " Failure Exception or Validation Error Message/Unknown Error");
		  }else if("001024".equalsIgnoreCase(res.getErrorcode())){
			  appSession.put(GlobalConstant.SMSSENT,"NOTSENDED");
			  debugLogger.debug(loggingCommonFormat + " SMS Delivery failed incase of mobile number is wrong or other irrelevant data occurs");
		  }
		  else if("000152".equalsIgnoreCase(res.getErrorcode())){
			  appSession.put(GlobalConstant.SMSSENT,"NOTSENDED");
			  debugLogger.debug(loggingCommonFormat + " Invalid OTP message template for Triggersms method");
		  } else if("001368".equalsIgnoreCase(res.getErrorcode())){
			  appSession.put(GlobalConstant.SMSSENT,"NOTSENDED");
			  debugLogger.debug(loggingCommonFormat + "OTP Blocked for RMN and NRMN users");
		  }else{
			  appSession.put(GlobalConstant.SMSSENT,"NOTSENDED");
			  debugLogger.debug(loggingCommonFormat + "Internal Server Error or  Any Server Problem");  
		  }
		  appSession.put("OTP_DEST",contact);
		  result.put("appSession",appSession);
		  debugLogger.debug(loggingCommonFormat + "AppSession Ended in TiggerSms.jsp Block with Datas :"+ appSession);
		  debugLogger.debug(loggingCommonFormat + "***************TriggerSms.jsp Ended**************************");
	   return result;
   }catch(Exception e){
	   debugLogger.error(loggingCommonFormat + "Exception :" +e);
	   return result;  
   }
     
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
<%@page import="com.scb.util.*"%>
<%@page import="com.scb.ivr.model.uaas.GenerateOTP_Req"%>
<%@page import="com.scb.ivr.model.uaas.GenerateOTP_Res"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.controller.UAASController"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@include file="../include/backend.jspf" %>