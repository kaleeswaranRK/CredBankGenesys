<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    
	  
	 JSONObject result = new JSONObject();
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
	   debugLogger.debug("*********** Call log Entry **********");
//	   debugLogger.debug("Agent Transfer Data : "+state.getString("AgentTrans"));
	   debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);


  try{
	  
   	  Date startTimeDate = new Date(appSession.getLong("STARTTIME"));
   	  DBController dbController = (DBController) SpringApplicationContext.getBean("DBController");
	  CallLog_Req callLog_Req = new CallLog_Req();
	  callLog_Req.setCli(appSession.getString("ANI"));
      callLog_Req.setDnis(appSession.getString("DNIS"));
      callLog_Req.setStarttime(startTimeDate);
      callLog_Req.setEndtime(new Date());
      callLog_Req.setUcid(appSession.getString("ucid"));
      callLog_Req.setI_rmn(appSession.getString(GlobalConstant.MOBILE));
      callLog_Req.set_is_rmn(String.valueOf(appSession.getString(GlobalConstant.ISRMN).charAt(0)));
      callLog_Req.set_bank_card_loan(appSession.getString(GlobalConstant.BANK_CARD_LOAN));
      callLog_Req.setCustomer_segment(appSession.getString(GlobalConstant.SEGMENT));
      callLog_Req.setTransfer_or_disc(appSession.getString(GlobalConstant.TRANSFER_OR_DISCONNECT));
      callLog_Req.setSeg_code(appSession.getString(GlobalConstant.SEGMENTCODE));
      callLog_Req.setAcc_card_id(appSession.getString("ACC_CARD_ID"));
      callLog_Req.setRel_id(appSession.getString(GlobalConstant.RELID));
      callLog_Req.setBlock_code(appSession.getString(GlobalConstant.BLOCKCODE));
      callLog_Req.setLanguage(appSession.getString(GlobalConstant.LANGUAGE));
      callLog_Req.setContext_id(appSession.getString(GlobalConstant.CONTEXTID));
      callLog_Req.setLastmenu(appSession.getString("LASTMENU"));
      callLog_Req.setTransfer_attributes(appSession.getString(GlobalConstant.TRANSATTRIBUTE));
      callLog_Req.setConutry(appSession.getString(GlobalConstant.COUNTRY));
      callLog_Req.setOne_fa(appSession.getString(GlobalConstant.ONEFA));
      callLog_Req.setTwo_fa(appSession.getString(GlobalConstant.TWOFA));
      callLog_Req.setVerified_by(appSession.getString(GlobalConstant.VERIFIEDBY));
      callLog_Req.setIdentified_by(appSession.getString(GlobalConstant.IDENTIFIED_BY));
      callLog_Req.setMenu_traverse(appSession.getString(GlobalConstant.MENUTRAVERSE));
      callLog_Req.setChannel(appSession.getString(GlobalConstant.CHANNEL));
      callLog_Req.setInvoluntry_Reason(appSession.getString(GlobalConstant.INVOLUNTARYREASON));
      callLog_Req.setAgent_id(appSession.getString(GlobalConstant.AGENTID));
      callLog_Req.setSession_id(sessionID);
      callLog_Req.setOtp_dest(appSession.getString("OTP_DEST"));
      callLog_Req.setDisconnect_reason(appSession.getString(GlobalConstant.DISCONNECTREASON));

		debugLogger.debug(loggingCommonFormat + "callLog_Req request : "+ callLog_Req);

		CallLogUpdate_Res callLogUpdate_Res = dbController.insertCallLog(callLog_Req);		
		callLogUpdate_Res.getErrorcode();
		callLogUpdate_Res.getErrormessage();
		callLogUpdate_Res.getStatus();
		debugLogger.debug(loggingCommonFormat + "callLogUpdate_Res response : "+ callLogUpdate_Res);

		debugLogger.debug(loggingCommonFormat + "DB ErrorCode : "+ callLogUpdate_Res.getErrorcode());
		  debugLogger.debug(loggingCommonFormat + "DB ErrorMessage : "+   callLogUpdate_Res.getErrormessage());
		if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(callLogUpdate_Res.getErrorcode())){
			   debugLogger.debug("Call history inserted successfully");
		}
		else if(GlobalConstant.DB_RECORD_NOT_FOUND.equalsIgnoreCase(callLogUpdate_Res.getErrorcode())){
			   debugLogger.debug("Call history insertion failiure");
		}
		else{
			   debugLogger.debug("Invalid Input");
		}
  }
  catch(Exception e){
	  System.out.println(e);
  	debugLogger.error("Exception "+e);
  }
  appSession.put("preferLanguage",appSession.getString(GlobalConstant.LANGUAGE));
  appSession.put("ONEFA",appSession.getString(GlobalConstant.ONEFA));
  result.put("appSession",appSession);

  debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
  debugLogger.debug("*********** Call log Exit **********");


return result;

};
%>
<%-- GENERATED: DO NOT REMOVE --%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.Paths"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.db.entity.CallLog_Req"%>
<%@page import="com.scb.ivr.db.res.CallLogUpdate_Res"%>
<%@page import="com.scb.ivr.controller.DBController"%>
<%@page import="java.util.Date"%>
<%@include file="../include/backend.jspf"%>