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
   System.out.println("first");
   String ucid=appSession.getString("ucid");
   System.out.println("ucid "+ucid);
  String credit=state.getString("CreditNum");
  
  String reportInput=state.getString("reportInput");
 String Relid= appSession.getString(GlobalConstant.RELID);
    try{
	   if("1".equalsIgnoreCase(reportInput)){
		  
		   debugLogger.debug(loggingCommonFormat + "***************CreditCard Lost Report Service Started**************************");
		   RKALEESController controller = (RKALEESController) SpringApplicationContext.getBean("RKALEESController");
		    debugLogger.debug(loggingCommonFormat + "UCID is :" +ucid);
		    debugLogger.debug(loggingCommonFormat + "AppSession Started in CreditCard Lost Report Service with Datas :"+ appSession);
		    debugLogger.debug(loggingCommonFormat + "Report the Credit Card is Lost service using getCustomerIdentificationCardNum method");
		    cardLost_Req reqObj = new cardLost_Req();
		    cardLost_Res res = new cardLost_Res();
			  reqObj.setCardNo(credit);
			  reqObj.setSessionId(sessionID);
			  reqObj.setUcid(ucid);
			  reqObj.setUserId(appSession.getString("relID"));
			  reqObj.setHotline(appSession.getString("DNIS"));

			  debugLogger.debug(loggingCommonFormat + " using  getCustomerIdentificationCardNum method in C400Controller with  request is :"+reqObj);
			  res = controller.setCardLost(reqObj);
			  debugLogger.debug(loggingCommonFormat + " using  getCustomerIdentificationCardNum method in C400Controller with  request is :"+res.toString());
	  		debugLogger.debug(loggingCommonFormat + "ErrorCode for getCustomerIdentificationCardNum method in C400Controller :"+ res.getErrorcode());

			  debugLogger.debug(loggingCommonFormat + "ErrorMessage for getCustomerIdentificationCardNum method in C400Controller :"+   res.getErrormessage());
			  if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
				  if(credit.equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardNum())){
					  if(Relid.equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCustomerId())){
						  result.put("cardnum",res.getResponse().getData().get(0).getAttributes().getCardNum().substring(12, 16));
				    	  debugLogger.debug(loggingCommonFormat + "result"+result.getString("cardnum"));
				  if("ACTIVE".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
					appSession.put("cardstatus","ACTIVE");
					appSession.put("cardnum","CCSUCCESS");
					debugLogger.debug(loggingCommonFormat + "CreditCardNumber is in Active Status");
				  }
				  else if("INACTIVE".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","INACTIVE"); 
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "CreditCardNumber is in InActive Status");
					  }
				  else if("BLOCKED".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","BLOCKED");
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "CreditCardNumber is in Blocked Status");
					  }
				  else if("EXPIRED".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","EXPIRED"); 
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "CreditCardNumber is in Expired Status");
					  }
				  else if("CLOSED".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","CLOSED");
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "CreditCardNumber is in Closed Status");
					  }
				  
				  }else{
					  appSession.put("cardnum","RELIDNOTMATCH");
					  debugLogger.debug(loggingCommonFormat + "Customer RELID is not Matched with getCustomerIdentificationCardNum method Response RELID ");
					  debugLogger.debug(loggingCommonFormat + "Customer RELID is :" +Relid);
					  debugLogger.debug(loggingCommonFormat + "Host Response  RELID is :" +res.getResponse().getData().get(0).getAttributes().getCustomerId());
				  }
					  
				  }else{
					  appSession.put("cardnum","NOTMATCH");
					  debugLogger.debug(loggingCommonFormat + "Customer CreditCardNumber is not Matched with getCustomerIdentificationCardNum method Response CreditCardNumber ");
					  debugLogger.debug(loggingCommonFormat + "Customer entered CreditCardNumber is :" +credit);
					  debugLogger.debug(loggingCommonFormat + "Host Response  RELID is :" +res.getResponse().getData().get(0).getAttributes().getCardNum());
				  }
			  }else if("111111".equalsIgnoreCase(res.getErrorcode())){
				  appSession.put("cardnum","Error");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "Failure Exception or Validation Error Message/Unknown Error");
			  }else if("099990".equalsIgnoreCase(res.getErrorcode())){
				  appSession.put("cardnum","Error");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "CreditCard Number is Not Found");
			  }else if("700013".equalsIgnoreCase(res.getErrorcode())){
				  appSession.put("cardnum","NOTMATCH");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "Customer CreditCardNumber is not Matched with getCustomerIdentificationCardNum method Response CreditCardNumber");
			  } else{
				  appSession.put("cardnum","Error");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "A remote host refused an attempted connect operation. (Connection refused)");
			  }
			  result.put("appSession",appSession);
			  debugLogger.debug(loggingCommonFormat + "AppSession Ended in CreditCard Lost Report Service with Datas :"+ appSession);
			  
	    	  debugLogger.debug(loggingCommonFormat + "***************CreditCard Lost Report Service Ended**************************");
				   
	   }else if("2".equalsIgnoreCase(reportInput)){
		   debugLogger.debug(loggingCommonFormat + "***************DebitCard Lost Report Service**************************");
		    debugLogger.debug(loggingCommonFormat + "UCID is :" +ucid);
		    debugLogger.debug(loggingCommonFormat + "AppSession Started in DebitCard Lost Report with Datas :"+ appSession);
		    debugLogger.debug(loggingCommonFormat + "Report the DebitCard Lost Report service using getCustomerIdentificationDebtCardNum method");
			RKALEESController controller = (RKALEESController) SpringApplicationContext.getBean("RKALEESController");
			cardLost_Req reqObj = new cardLost_Req();
		    cardLost_Res res = new cardLost_Res();
		    reqObj.setCardNo(credit);
			  reqObj.setSessionId(sessionID);
			  reqObj.setUcid(ucid);
			  reqObj.setUserId(appSession.getString("relID"));
			  reqObj.setHotline(appSession.getString("DNIS"));
			  res = controller.setCardLost(reqObj);
			  debugLogger.debug(loggingCommonFormat + " using  getCustomerIdentificationDebtCardNum method in EuronetController with  request is :"+reqObj);
			  debugLogger.debug(loggingCommonFormat + " using  getCustomerIdentificationDebtCardNum method in EuronetController with  request is :"+res.toString());
	  		  debugLogger.debug(loggingCommonFormat + "ErrorCode for  getCustomerIdentificationDebtCardNum method in EuronetController :"+ res.getErrorcode());

			  debugLogger.debug(loggingCommonFormat + "ErrorMessage for  getCustomerIdentificationDebtCardNum method in EuronetController :"+   res.getErrormessage());
			  if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
				  debugLogger.debug(loggingCommonFormat + "DebitCardNumber from response is :" +res.getResponse().getData().get(0).getAttributes().getCardNum());
				  debugLogger.debug(loggingCommonFormat + "DebitCardNumber  Active or Not Status from response is :" +res.getResponse().getData().get(0).getAttributes().getCardStatus());
				  if(credit.equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardNum())){
					  if(Relid.equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCustomerId())){
						  result.put("cardnum",res.getResponse().getData().get(0).getAttributes().getCardNum().substring(12, 16));
				    	  debugLogger.debug(loggingCommonFormat + "result"+result.getString("cardnum"));
				  if("ACTIVE".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
					appSession.put("cardstatus","ACTIVE");
					appSession.put("cardnum","CCSUCCESS");
					debugLogger.debug(loggingCommonFormat + "DebitCardNumber is in Active Status");
				  }
				  else if("INACTIVE".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","INACTIVE"); 
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "DebitCardNumber is in InActive Status");
					  }
				  else if("BLOCKED".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","BLOCKED");
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "DebitCardNumber is in Blocked Status");
					  }
				  else if("EXPIRED".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","EXPIRED"); 
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "DebitCardNumber is in Expired Status");
					  }
				  else if("CLOSED".equalsIgnoreCase(res.getResponse().getData().get(0).getAttributes().getCardStatus())){
						appSession.put("cardstatus","CLOSED");
						 appSession.put("cardnum","CCSUCCESS");
						debugLogger.debug(loggingCommonFormat + "DebitCardNumber is in Closed Status");
					  }
				  
				  }else{
					  appSession.put("cardnum","RELIDNOTMATCH");
					  debugLogger.debug(loggingCommonFormat + "Customer RELID is not Matched with getCustomerIdentificationCardNum method Response RELID ");
					  debugLogger.debug(loggingCommonFormat + "Customer RELID is :" +Relid);
					  debugLogger.debug(loggingCommonFormat + "Host Response  RELID is :" +res.getResponse().getData().get(0).getAttributes().getCustomerId());
				  }
					  
				  }else{
					  appSession.put("cardnum","NOTMATCH");
					  debugLogger.debug(loggingCommonFormat + "Customer DebitCardNumber is not Matched with getCustomerIdentificationCardNum method Response CreditCardNumber ");
					  debugLogger.debug(loggingCommonFormat + "Customer entered CreditCardNumber is :" +credit);
					  debugLogger.debug(loggingCommonFormat + "Host Response  RELID is :" +res.getResponse().getData().get(0).getAttributes().getCustomerId());
				  }
			  }else if(GlobalConstant.HOST_FAILURE_CODE.equalsIgnoreCase(res.getErrorcode())){
				  appSession.put("cardnum","Error");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "Failure Exception or Validation Error Message/Unknown Error");
			  }else if("700074".equalsIgnoreCase(res.getErrorcode())){
				  appSession.put("cardnum","Error");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "Invalid DebitCard");
			  }else if("700013".equalsIgnoreCase(res.getErrorcode())){
				  appSession.put("cardnum","NOTMATCH");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "Customer DebitCardNumber is not Matched with getCustomerIdentificationCardNum method Response CreditCardNumber");
			  }else{
				  appSession.put("cardnum","Error");
				  appSession.put("cardstatus","Error");
				  debugLogger.debug(loggingCommonFormat + "A remote host refused an attempted connect operation. (Connection refused)");
			  }
			 
			  debugLogger.debug(loggingCommonFormat + "AppSession Endeed in DebitCard Lost Report Service with Datas :"+ appSession);
			  
	    	  debugLogger.debug(loggingCommonFormat + "***************DebitCard Lost Report Service Ended**************************");
		 
	   }
    	 
    	
    }catch(Exception e){
    	  debugLogger.error(loggingCommonFormat + "Exception :" +e);
    	 return result;
    }
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
<%@page import="com.scb.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.model.rkalees.cardLost_Req"%>
<%@page import="com.scb.ivr.model.rkalees.cardLost_Res"%>
<%@page import="com.scb.ivr.controller.RKALEESController"%>
<%@page import="com.scb.ivr.controller.C400Controller"%>
<%@page import="com.scb.ivr.controller.EuronetController"%>
<%@page import="com.scb.ivr.model.euronet.CustomerIdentificationDebtCardNum_Req"%>
<%@page import="com.scb.ivr.model.euronet.CustomerIdentificationDebtCardNum_Res"%>
<%@page import="com.scb.ivr.model.c400.CustomerIdentificationCardNum_Req"%>
<%@page import="com.scb.ivr.model.c400.CustomerIdentificationCardNum_Res"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@include file="../include/backend.jspf" %>