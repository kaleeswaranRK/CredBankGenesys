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
	String ucid = 	appSession.getString("ucid");

    try{
		  debugLogger.debug(loggingCommonFormat + "***************Otp Validation Block Entry**************************");
		  	 debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);

		  	 UAASController controller = (UAASController) SpringApplicationContext.getBean("UAASController");
    	 String profileid= appSession.getString("relID");
    	 String otpinput= state.getString("otpNum");
    	 String modulus="b6b44e815345da9297e595cc88bd6ba7ac5fe4d08bb7aa795951b71b093ad0e0bde4b638570ca038ba0d73222c62286c6a926793f88ae411280c3b92ac5c79d2c142d4a600a376420e101a31936697c2adb56ee0e96be21320eacfefe7f97fd5ad0e59bbf1ff75efa2ae50b6fdb3acd46e89fd993efe4fbf775a071c19d9d694c6f97a47fdd64df0b87338aa839db9b4d5cc907de7c409c5fd7db5921123081b766f795afcb70a7fce5b953a9c4b557b5cebed277cec522fe752c09706d571ebb6620ebdece8c6cd66fc146f562dc5b674cba1361afc6bbe2f050558071b691a0e67e6e57bc9abb8ee64971c23ef14302ab27643fcfad50e123af630c9bc77d9";
    	 String encryptblock="MTY2MTM0OTI5MTgyMl8tX1ZOVl8tX0hLXy1fMzYwMzMyODQyXy1fcGI0ZWliWG5fLV9uZkt4amZ3MENtSWZaemxzeDdvV2JwbEV1OG9VVU15b2hjdkJQZys5aGxZPQ==";
    	 ValidateOTP_Req reqObj = new ValidateOTP_Req();
    	 reqObj.setRelID(profileid);
    	 reqObj.setUcid(ucid);
    	 reqObj.setHotline(appSession.getString("DNIS"));
    	 reqObj.setModulus(modulus);
    	 reqObj.setEncryptedBlock(encryptblock);	
    	 reqObj.setExponent("10001");
    	 reqObj.setKeyIndex("3");
    	 reqObj.setOtp(otpinput);
    	 reqObj.setOtpSn("311731");
    	 reqObj.setSessionId(sessionID);
    	 debugLogger.debug(loggingCommonFormat + "This All request to validateOTP method requests  : "+ reqObj);
    	 debugLogger.debug(loggingCommonFormat + "OTP Input from Customer is  : "+ otpinput);
    	 ValidateOTP_Res res = controller.validateOTP(reqObj);
    	 debugLogger.debug(loggingCommonFormat + "USER ENTERED OTP INPUT is VALID  AND THE STATUSCODE IS:" +res.getResponse().getStatusCode());
		  debugLogger.debug(loggingCommonFormat + "ErrorCode :"+  res.getErrorcode());
		  debugLogger.debug(loggingCommonFormat + "ErrorMessage :"+   res.getErrormessage());
		  debugLogger.debug(loggingCommonFormat + "StartTime :"+     res.getStartTime());
		  debugLogger.debug(loggingCommonFormat + "EndTime :"+       res.getEndTime());
		  debugLogger.debug(loggingCommonFormat + "OTP VALID response  "+  res.getResponse());
    	 if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
    		 if("100".equalsIgnoreCase(res.getResponse().getStatusCode())){
    	    		debugLogger.debug(loggingCommonFormat + "OTP VALIDATION SUCCESSFULL");
			  appSession.put("validotp","Valid");
			  appSession.put("OTPAUTH","S");
			  appSession.put("VERIFIEDBY","OTP");
			  appSession.put("OTP_DEST",appSession.getString("MOBILE"));
    		 }
		else if("308".equalsIgnoreCase(res.getResponse().getStatusCode())){
    		debugLogger.debug(loggingCommonFormat + "INVALID OTP VALIDATION");
			  appSession.put("validotp","Invalid");
			  appSession.put("OTPAUTH","F");
			  
		  }else if("368".equalsIgnoreCase(res.getResponse().getStatusCode())){
	    		debugLogger.debug(loggingCommonFormat + "OTP HAS BEEN BLOCKED");
			  appSession.put("validotp","Blocked");
				appSession.put("OTPAUTH","F");
			 
		  }else if("307".equalsIgnoreCase(res.getResponse().getStatusCode())){
	    		debugLogger.debug(loggingCommonFormat + "OTP HAS BEEN EXPIRED");
			  appSession.put("validotp","Expired");
				appSession.put("OTPAUTH","F");
			 
		  }else if("330".equalsIgnoreCase(res.getResponse().getStatusCode())){
	    		debugLogger.debug(loggingCommonFormat + "INVALID OTP TOKEN");
			  appSession.put("validotp","invalidOtpToken");
				appSession.put("OTPAUTH","F");

		  }
		  else{
	    		debugLogger.debug(loggingCommonFormat + "ERROR WHILE VALIDATE OTP");
			  appSession.put("validotp","Error");
				appSession.put("OTPAUTH","F");
		  }
    	 }
    	 else if("111111".equalsIgnoreCase(res.getResponse().getStatusCode())){
      		debugLogger.debug(loggingCommonFormat + "Failure Exception or Validation Error Message/Unknown Error");
  			  appSession.put("validotp","error");
  				appSession.put("OTPAUTH","F");
  			  
  		  }
    	 else if("001308".equalsIgnoreCase(res.getResponse().getStatusCode())){
     		debugLogger.debug(loggingCommonFormat + "INVALID OTP VALIDATION");
 			  appSession.put("validotp","Invalid");
 				appSession.put("OTPAUTH","F");
 			  
 		  }else if("001368".equalsIgnoreCase(res.getResponse().getStatusCode())){
 	    		debugLogger.debug(loggingCommonFormat + "OTP HAS BEEN BLOCKED");
 			  appSession.put("validotp","Blocked");
 				appSession.put("OTPAUTH","F");
 			 
 		  }else if("001307".equalsIgnoreCase(res.getResponse().getStatusCode())){
 	    		debugLogger.debug(loggingCommonFormat + "OTP HAS BEEN EXPIRED");
 			  appSession.put("validotp","Expired");
 				appSession.put("OTPAUTH","F");
 			 
 		  }else if("001330".equalsIgnoreCase(res.getResponse().getStatusCode())){
 	    		debugLogger.debug(loggingCommonFormat + "INVALID OTP TOKEN");
 			  appSession.put("validotp","invalidOtpToken");
 				appSession.put("OTPAUTH","F");

 		  }
		  else{
	    		debugLogger.debug(loggingCommonFormat + "ERROR WHILE VALIDATE OTP");
			  appSession.put("validotp","Error");
				appSession.put("OTPAUTH","F");

		  }
		  debugLogger.debug(loggingCommonFormat + "validotp  status : "+  appSession.getString("validotp"));
		  	 debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
		  debugLogger.debug(loggingCommonFormat + "***************Otp Validation Block Exit**************************");
    }catch(Exception e){
    	 debugLogger.error(loggingCommonFormat + "Exception :" +e);
		  appSession.put("validotp","Error");
			appSession.put("OTPAUTH","F");
    }
    String ONEFA=appSession.getString(GlobalConstant.ONEFA);
    String[] split = ONEFA.split(",");
	String oneFAChange="";
	for (String value : split) {
		String[] split2 = value.split("[|]");
		if(split2[0].equalsIgnoreCase("OTP")) {
			oneFAChange=oneFAChange+"OTP"+"|"+appSession.getString("OTPAUTH");
		}
		else{
			oneFAChange=oneFAChange.concat(value)+",";
		}
	}
	appSession.put(GlobalConstant.ONEFA,oneFAChange);
	debugLogger.debug("oneFA value : " + appSession.getString(GlobalConstant.ONEFA));
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
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.model.uaas.ValidateOTP_Req"%>
<%@page import="com.scb.ivr.model.uaas.ValidateOTP_Res"%>
<%@page import="com.scb.ivr.controller.UAASController"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@include file="../include/backend.jspf" %>