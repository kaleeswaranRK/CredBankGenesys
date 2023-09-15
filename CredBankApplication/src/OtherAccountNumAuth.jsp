<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    

    
    JSONObject result = new JSONObject();
    
    JSONObject appSession = state.getJSONObject("appSession");
    String sessionID = state.getString("GVPSessionID").split(";")[0];
    String callID =state.getString("CallUUID").trim();
    
    String loggerName=sessionID;
     
    Date timeStamp = new Date();        
 	Logger debugLogger = null;
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
 	String ucid="";
 	String ACCNUM="";
    
	try{
		
		debugLogger.debug(loggingCommonFormat + "--START OTHER ACCOUNT NUMBER Validation Block :"+ACCNUM);
		
		ACCNUM=state.getString("ACCINPUTOUT");
		System.out.println("Other Account Number:"+ACCNUM);
		debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER IS :"+ACCNUM);
		
		
		
		
		EBBSController controller = (EBBSController) SpringApplicationContext.getBean("EBBSController");

		CustomerIdentificationAcctNum_Req reqObj = new CustomerIdentificationAcctNum_Req();
		CustomerIdentificationAcctNum_Res res = new CustomerIdentificationAcctNum_Res();
		reqObj.setAcctNum(ACCNUM);
		reqObj.setCurrency_code("BHD");
		reqObj.setSessionId(sessionID);
		reqObj.setUcid(appSession.getString("ucid"));
		reqObj.setHotline(appSession.getString("DNIS"));

		debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER REQUEST IS :"+reqObj);
		res = controller.getCustomerIdentificationAcctNum(reqObj);
		System.out.println("ERROR CODR FOR OTHER ACCOUNT NUMBER:"+res.getErrorcode());
		System.out.println("ERROR CODR FOR OTHER ACCOUNT NUMBER:"+res.getErrorcode());
		if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
			String profileId = res.getResponse().getData().get(0).getAttributes().getCasaCustomers().get(0).getProfileId();
			//result.put("profileId",profileId);
			appSession.put("STATUS","OK");
			appSession.put(GlobalConstant.ACCNUM,ACCNUM);
			debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER PUTTING INTO THE SESSION VARIABLE :"+appSession.getString(GlobalConstant.ACCNUM));
			debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER VALID RESPONSE ");
		}
		else if("700013".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("STATUS","RETRY");
			debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER NOT FOUND RESPONSE ");
		}
		else if("CUS0001".equalsIgnoreCase(res.getErrorcode())){
			appSession.put("STATUS","RETRY");
			debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER NOT FOUND RESPONSE ");
		}
		else if(GlobalConstant.HOST_FAILURE_CODE.equalsIgnoreCase(res.getErrorcode())){
			appSession.put("STATUS","NO");
			debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER FAILURE/EXCEPTION RESPONSE ");
		}
		else {
			appSession.put("STATUS","NO");
			debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER UNKNOWN ERROR RESPONSE ");
		}
		
		
	}
	catch(Exception e){
		System.out.println("Exceptio caught in Other Account Number authentication block:"+e.getMessage());
		return result;
	}
	
	result.put("appSession",appSession);
	debugLogger.debug(loggingCommonFormat + "OTHER ACCOUNT NUMBER BLOCK APP SESSION VARIABLE :"+appSession);
	debugLogger.debug(loggingCommonFormat + "--OTHER ACCOUNT NUMBER BLOCK IS ENDED");
    return result;
    
};
%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="com.util.Logging"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="com.scb.ivr.controller.EBBSController"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerIdentificationAcctNum_Req"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerIdentificationAcctNum_Res"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@include file="../include/backend.jspf" %>