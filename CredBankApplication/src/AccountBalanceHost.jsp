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
    
 	Logger debugLogger = LogManager.getLogger(loggerName);	
 	String ucid="";
 	String profileId="";
    String accnum="";
    String currentDate="";
    String accountbalance="";
    String casaCurrencyCode="";
    String last_Digit="";
	String className = new Object(){}.getClass().getEnclosingClass().getName();
	className = className.split("[.]")[4];
	String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
	debugLogger=Logging.LoggerConfiguration(sessionID);
	try{
		debugLogger.debug(loggingCommonFormat + "--START ACCOUNT BALANCE HOST HIT BLOCK--");
		EBBSController controller = (EBBSController) SpringApplicationContext.getBean("EBBSController");
		profileId=appSession.getString(GlobalConstant.RELID);
		accnum=appSession.getString(GlobalConstant.ACCNUM);
		last_Digit=accnum.substring(7,11);
		appSession.put("LASTNUM",last_Digit);
		debugLogger.debug(loggingCommonFormat + "ACCOUNT BALANCE HIT ACCENUM:"+accnum);
		AccountBalanceCASA_Req reqObj = new AccountBalanceCASA_Req();
		AccountBalanceCASA_Res res = new AccountBalanceCASA_Res();
		reqObj.setProfileId(profileId);
		reqObj.setSessionId(sessionID);
		reqObj.setHotline(appSession.getString("DNIS"));
		reqObj.setUcid(appSession.getString("ucid"));

		res = controller.getAccountBalanceCASA(reqObj);
		debugLogger.debug(loggingCommonFormat + "Account Balance Host Hit request: "+reqObj);
		
		//
		debugLogger.debug(loggingCommonFormat + "ERRORCODE : "+res.getErrorcode());
		debugLogger.debug(loggingCommonFormat + "ERRORMessage : "+res.getErrormessage());


		debugLogger.debug(loggingCommonFormat + "Account Balance Host Hit response: "+res);
		if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
			 List<AccountBalanceCASADatum> data = res.getResponse().getData();
			 System.out.println("size of data list:"+data.size());
			 debugLogger.debug(loggingCommonFormat + "size of data list:"+data.size());
		 		 AccountBalanceCASADatum resultData=data.get(0);
		 		 List<AccountBalanceCASAdetail> casadetails = resultData.getAttributes().getResponse().getCustomerdetails().getCasadetails();
		 		 for(int j=0;j<casadetails.size();j++) {
		 			 AccountBalanceCASAdetail accountBalanceCASAdetail = casadetails.get(j);
		 			 if(accnum.equalsIgnoreCase(accountBalanceCASAdetail.getCasaNumber()) && "O".equalsIgnoreCase(accountBalanceCASAdetail.getAccountCurrentStatus())) {
		 				accountbalance =accountBalanceCASAdetail.getAvailablebalanceWithlimit();
		 				casaCurrencyCode= accountBalanceCASAdetail.getCasaCurrencyCode(); 
		 				 System.out.println("Account balance is:"+accountbalance);
		 				System.out.println("Currency code is:"+casaCurrencyCode);
		 				 appSession.put("BALANCEAPI","OK");
		 				 currentDate=new SimpleDateFormat("yyyyMMdd").format(new Date());
		 				 appSession.put("DATE",currentDate);
		 				appSession.put("BALANCE",accountbalance);
		 				 appSession.put("CURCODE",casaCurrencyCode);
		 				debugLogger.debug(loggingCommonFormat + "Account Balance API HIT SUCCESSFULL");
		 				debugLogger.debug(loggingCommonFormat + "Account Balance is:"+appSession.getString("BALANCE"));
		 				debugLogger.debug(loggingCommonFormat + "CURRENT DATE IS:"+appSession.getString("DATE"));
		 				debugLogger.debug(loggingCommonFormat + "CURRENCY CODE IS:"+appSession.getString("CURCODE"));
		 				
		 			 }
		 		
		 		 }
			
		}
		else if(GlobalConstant.HOST_FAILURE_CODE.equalsIgnoreCase(res.getErrorcode())){
				 appSession.put("BALANCEAPI","ERROR");
				debugLogger.debug(loggingCommonFormat + "Account Balance API HIT UNSUCCESSFULL DUT TO FAILURE EXCEPTION");
		}
		else if("CUS0001".equalsIgnoreCase(res.getErrorcode())){
			 	appSession.put("BALANCEAPI","RETRY");
				debugLogger.debug(loggingCommonFormat + "Account Balance API HIT SUCCESSFULL BUT CUSTOMER PROFILE NOT FOUND");
		}
		else{
			appSession.put("BALANCEAPI","ERROR");
			debugLogger.debug(loggingCommonFormat + "Account Balance API HIT FAILED DUE TO UNKNOWN EXCEPTION");
		}
	
	 		

		

	}
	catch(Exception e){
		System.out.println("Exception caught in Account BalanceHost Block:"+e.getMessage());
		debugLogger.debug(loggingCommonFormat + "Exception caught in Account BalanceHost Block:"+e.getMessage());
		return result;
	}
    
	result.put("appSession",appSession);
	debugLogger.debug(loggingCommonFormat + "--END ACCOUNT BALANCE HIT BLOCK APPSESSION VALUES:"+appSession);
	debugLogger.debug(loggingCommonFormat + "--END ACCOUNT BALANCE HOST HIT BLOCK--");
    return result;
    
};
%>
<%-- GENERATED: DO NOT REMOVE --%> 
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import ="com.scb.ivr.controller.EBBSController"%>
<%@page import ="com.scb.ivr.model.ebbs.AccountBalanceCASA_Req"%>
<%@page import ="com.scb.ivr.model.ebbs.AccountBalanceCASA_Res"%>
<%@page import="com.scb.ivr.model.ebbs.res.acctbalcasa.AccountBalanceCASADatum"%>
<%@page import="com.scb.ivr.model.ebbs.res.acctbalcasa.AccountBalanceCASAdetail"%>
<%@page import ="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@include file="../include/backend.jspf" %>