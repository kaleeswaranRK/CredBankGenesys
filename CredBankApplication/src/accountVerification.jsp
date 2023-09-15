<%@page language="java" contentType="application/json;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {

	 JSONObject result = new JSONObject();
		JSONObject appSession = state.getJSONObject("appSession");
	   	String loggerName = appSession.getString("loggerName");
		   Logger debugLogger = LogManager.getLogger(loggerName);
		   String sessionID = state.getString("GVPSessionID").split(";")[0];
	   	String callID = state.getString("CallUUID").trim();
	   	Date timeStamp = new Date();
		String className = new Object(){}.getClass().getEnclosingClass().getName();
		className = className.split("[.]")[4];
		String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
		debugLogger=Logging.LoggerConfiguration(sessionID);
	   
		String ucid = 	appSession.getString("ucid");
		String cusIden="NO";
	    try{
	    	 debugLogger.debug(loggingCommonFormat + "***************accountVerification Block ENTRY**************************");
	 		debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
	    	String accNum=state.getString("accNum");
	    	if(accNum.length()==11){
	    	    debugLogger.debug(loggingCommonFormat + "***************Account Number Verification**************************");
		    	debugLogger.debug(loggingCommonFormat + "Account number "+ CreditcardMasker.maskCreditCard(accNum)+" ");
	    		EBBSController controller = (EBBSController) SpringApplicationContext.getBean("EBBSController");
	    		CustomerIdentificationAcctNum_Req reqObj = new CustomerIdentificationAcctNum_Req();
	    		CustomerIdentificationAcctNum_Res res = new CustomerIdentificationAcctNum_Res();
	    		reqObj.setAcctNum(accNum);
	    		reqObj.setCurrency_code("BHD");
	    		reqObj.setSessionId(sessionID);
	    		reqObj.setUcid(appSession.getString("ucid"));
	    		reqObj.setHotline(appSession.getString("DNIS"));
		    	debugLogger.debug(loggingCommonFormat + " getCustomerIdentificationAcctNum req : "+ reqObj);
	    		res = controller.getCustomerIdentificationAcctNum(reqObj);
	    		res.getErrorcode();
	    		res.getErrormessage();
	    	debugLogger.debug(loggingCommonFormat + "DB ErrorCode : "+ res.getErrorcode());
  			debugLogger.debug(loggingCommonFormat + "DB ErrorMessage : "+   res.getErrormessage());
	    	debugLogger.debug(loggingCommonFormat + " getCustomerIdentificationAcctNum req : "+ res);

  			if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
  				cusIden="YES";
  			   	appSession.put(GlobalConstant.ACCNUM,accNum);
  			   	appSession.put("IDENTIFIED_BY","ACC");
  			    appSession.put("relID",	res.getResponse().getData().get(0).getAttributes().getCasaCustomers().get(0).getProfileId());
	  			debugLogger.debug(loggingCommonFormat + "relID : "+	res.getResponse().getData().get(0).getAttributes().getCasaCustomers().get(0).getProfileId());
  			}
  			else if("700011".equalsIgnoreCase(res.getErrorcode())||"700013".equalsIgnoreCase(res.getErrorcode())){
  				cusIden="NO";
  			}
  			else{
  			   	appSession.put(GlobalConstant.INVOLUNTARYREASON,"EXCEPTION");
  				cusIden="ERROR";
  			}
	    	}
	    	else if(accNum.length()==16){
	    	    debugLogger.debug(loggingCommonFormat + "***************Debit or Credit Number Verification**************************");
		    	debugLogger.debug(loggingCommonFormat + "CARD number "+ CreditcardMasker.maskCreditCard(accNum)+" ");
	    		DBController dbController = (DBController) SpringApplicationContext.getBean("DBController");
				Map<String, Object> inParams = new HashMap<String, Object>();
				inParams.put("binNumber", accNum.substring(0,6));
				inParams.put("sessionId", sessionID);
		    	debugLogger.debug(loggingCommonFormat + " getCustomerIdentificationAcctNum request : "+ inParams);
				BinMaster_Res binMaster = dbController.getCardDetailsBasedOnBin(inParams);
		    	debugLogger.debug(loggingCommonFormat + " getCustomerIdentificationAcctNum response : "+ binMaster);
				binMaster.getErrorcode();
				binMaster.getErrormessage();
		    	debugLogger.debug(loggingCommonFormat + "DB ErrorCoden : "+ binMaster.getErrorcode());
	  			debugLogger.debug(loggingCommonFormat + "DB ErrorMessage : "+   binMaster.getErrormessage());
	  			if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(binMaster.getErrorcode())){
	  				cusIden="YES";
	  				appSession.put("cardHost",binMaster.getHost());
	  				if("CREDIT".equalsIgnoreCase(binMaster.getCardType())){
		  				appSession.put("IDENTIFIED_BY","CC");
	  				}
	  				else{
		  				appSession.put("IDENTIFIED_BY","DC");
	  				}
	  			}
	  			else if("700011".equalsIgnoreCase(binMaster.getErrorcode())||GlobalConstant.DB_RECORD_NOT_FOUND.equalsIgnoreCase(binMaster.getErrorcode())){
	  				cusIden="NO";
	  			}
	  			else{
	  				cusIden="ERROR";
	  			}
	    	    debugLogger.debug(loggingCommonFormat + "card Type : "+binMaster.getCardName());
	    	    debugLogger.debug(loggingCommonFormat + "card Host : "+binMaster.getHost());
	    	    
	    	}
	    	else{
  				cusIden="NO";
	    	}
	    	
	    }
	    catch(Exception e){
	    	debugLogger.debug(loggingCommonFormat + "Exception : "+e);
	  		cusIden="ERROR";
	    }
	    appSession.put("isCustIden",cusIden);
	    debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	    debugLogger.debug(loggingCommonFormat + "isCustIden : "+appSession.getString("isCustIden"));
	    	    debugLogger.debug(loggingCommonFormat + "***************accountVerification Block END**************************");
	    	    result.put("appSession",appSession);
	 return result;
	};
%>
<%-- GENERATED: DO NOT REMOVE --%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.controller.EBBSController"%>
<%@page
	import="com.scb.ivr.model.ebbs.CustomerIdentificationAcctNum_Req"%>
<%@page
	import="com.scb.ivr.model.ebbs.CustomerIdentificationAcctNum_Res"%>
<%@page import="com.scb.ivr.db.entity.BinMaster_Res"%>
<%@page import="com.scb.ivr.controller.DBController"%>
<%@page import="com.scb.log4jmask.CreditcardMasker"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@include file="../include/backend.jspf"%>