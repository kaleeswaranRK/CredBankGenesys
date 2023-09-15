<%@page language="java" contentType="application/json;charset=UTF-8"
	pageEncoding="UTF-8"%>
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
	debugLogger=Logging.LoggerConfiguration(sessionID);   	String MobNum="NA";
	String rmn="N";
    try{
  	  debugLogger.debug(loggingCommonFormat + "*************** NRMNorRMN Check Entry **************************");

	    debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
 	   System.out.println("Host hit Entry");
 	  EBBSController controller = (EBBSController) SpringApplicationContext.getBean("EBBSController");
  	   System.out.println("controller : "+controller);
    	CustomerIdentificationRMN_Req reqObj = new CustomerIdentificationRMN_Req();
    	CustomerIdentificationRMN_Res res = new CustomerIdentificationRMN_Res();
    	String ANI=appSession.getString("ANI");
    	reqObj.setMobile(ANI);
    	reqObj.setSessionId(sessionID);
    	reqObj.setUcid(appSession.getString("ucid"));
		reqObj.setHotline(appSession.getString("DNIS"));

  	  debugLogger.debug(loggingCommonFormat + " request : "+ reqObj);
    	  res = controller.getCustomerIdentificationRMN(reqObj);
    	  debugLogger.debug(loggingCommonFormat + "ErrorCode : "+  res.getErrorcode());
    	  debugLogger.debug(loggingCommonFormat + "ErrorMessage : "+   res.getErrormessage());
    	  debugLogger.debug(loggingCommonFormat + "StartTime : "+     res.getStartTime());
    	  debugLogger.debug(loggingCommonFormat + "EndTime : "+       res.getEndTime());
    	  debugLogger.debug(loggingCommonFormat + "response : "+  res.getResponse());
    	  debugLogger.debug(loggingCommonFormat + "responseList : "+   res.getResponse().getData());
    	  if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(res.getErrorcode())){
    		  List<CustIdentificationRMNProfile> profile =res.getResponse().getData().getAttributes().getResponse().getProfile();
    		  debugLogger.debug("size of profile : "+profile.size());
    		  if(profile.size()==1){
    			  rmn="Y";
	  			appSession.put("IDENTIFIED_BY","RMN");
        	  debugLogger.debug(loggingCommonFormat + "profile : "+   profile);
        	  List<CustIdentificationRMNContact> contacts = profile.get(0).getContacts();
        		for (CustIdentificationRMNContact custIdentificationRMNContact : contacts) {
        			if("MOB".equalsIgnoreCase(custIdentificationRMNContact.getContactTypeCode())){
        			MobNum=custIdentificationRMNContact.getContact();
        			}
        		}
          	  debugLogger.debug(loggingCommonFormat + " mobileNumber : "+   MobNum);
    		  DBController dbController = (DBController) SpringApplicationContext.getBean("DBController");
    		  String relID= profile.get(0).getProfileId();
    		  appSession.put("relID",relID);
    		  Map<String, Object> inParams = new HashMap<String, Object>();
    		    inParams.put("cli", ANI);
    		    inParams.put("sessionId", appSession.getString("ucid"));
    		    PrefereredLangCode_Res prefereredLangCode_Res = dbController.getPreferredLanguageBasedOnCLI(inParams);
    		    debugLogger.debug(loggingCommonFormat + "DB ErrorCode : "+ prefereredLangCode_Res.getErrorcode());
    			  debugLogger.debug(loggingCommonFormat + "DB ErrorMessage : "+   prefereredLangCode_Res.getErrormessage());
    			  debugLogger.debug(loggingCommonFormat + "DB LanguageCode : "+  prefereredLangCode_Res.getLangCode());
    	    	  if(GlobalConstant.HOST_SUCCESS_CODE.equalsIgnoreCase(prefereredLangCode_Res.getErrorcode())){
    				  appSession.put("LANGUAGECODE",prefereredLangCode_Res.getLangCode());
    			  }
    			  else{
    				  appSession.put("LANGUAGECODE","NA");
    				  debugLogger.debug(loggingCommonFormat + "prefer language not found");
    			  }
            	  debugLogger.debug(loggingCommonFormat + "LANGUAGECODE : "+  appSession.getString("LANGUAGECODE"));
            	  debugLogger.debug(loggingCommonFormat + "relID : "+  appSession.getString("relID"));
    		  }

    	  }
    	  else{
    		  rmn="N";    	  }

    }
    catch(Exception e){
    	rmn="N"; 
    	debugLogger.error(loggingCommonFormat + "Exception : "+e);
    	System.out.println(e);
    }
 	 appSession.put(GlobalConstant.ISRMN,rmn);
 	 appSession.put("MOBILE",MobNum);
	  debugLogger.debug(loggingCommonFormat +"RMN Status : "+ appSession.getString(GlobalConstant.ISRMN));
	  debugLogger.debug(loggingCommonFormat + "AppSession End Value : "+ appSession);
	  debugLogger.debug(loggingCommonFormat + "*************** NRMNorRMN Check Exit **************************");
    result.put("appSession",appSession);
    return result;
    };
    %>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.ivr.controller.EBBSController"%>
<%@page import="com.scb.ivr.SpringBootMain"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerIdentificationRMN_Res"%>
<%@page import="com.scb.ivr.model.ebbs.CustomerIdentificationRMN_Req"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>
<%@page import="com.scb.ivr.model.ebbs.res.custidentifyrmn.CustIdentificationRMNContact"%>
<%@page import="com.scb.ivr.model.ebbs.res.custidentifyrmn.CustIdentificationRMNProfile"%>
<%@page import="com.scb.ivr.controller.DBController"%>
<%@page import="com.scb.ivr.db.res.PrefereredLangCode_Res"%>
<%@page import="java.util.List"%>
    	<%@page import="com.scb.ivr.controller.ConfigController"%>

<%@include file="../include/backend.jspf"%>