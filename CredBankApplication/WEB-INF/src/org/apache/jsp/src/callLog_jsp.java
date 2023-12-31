/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: JspC/ApacheTomcat9
 * Generated at: 2023-09-08 10:02:26 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.src;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.scb.util.GlobalConstant;
import java.text.SimpleDateFormat;
import com.util.Logging;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;
import org.json.JSONException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.File;
import java.util.*;
import org.json.JSONArray;
import java.util.Map;
import com.scb.ivr.spring.appcontext.SpringApplicationContext;
import com.scb.ivr.db.entity.CallLog_Req;
import com.scb.ivr.db.res.CallLogUpdate_Res;
import com.scb.ivr.controller.DBController;
import java.util.Date;
import org.json.JSONObject;
import com.genesyslab.studio.backendlogic.GVPHttpRequestProcessor;
import java.util.Map;

public final class callLog_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {


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


/* public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams)
{
    return new JSONObject();
} */

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(1);
    _jspx_dependants.put("/src/../include/backend.jspf", Long.valueOf(1691499942000L));
  }

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("java.util");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = new java.util.HashSet<>();
    _jspx_imports_classes.add("com.scb.ivr.db.res.CallLogUpdate_Res");
    _jspx_imports_classes.add("java.nio.file.Files");
    _jspx_imports_classes.add("com.scb.ivr.spring.appcontext.SpringApplicationContext");
    _jspx_imports_classes.add("java.util.Date");
    _jspx_imports_classes.add("java.text.SimpleDateFormat");
    _jspx_imports_classes.add("com.util.Logging");
    _jspx_imports_classes.add("java.io.File");
    _jspx_imports_classes.add("com.scb.ivr.controller.DBController");
    _jspx_imports_classes.add("org.json.JSONException");
    _jspx_imports_classes.add("org.apache.logging.log4j.Logger");
    _jspx_imports_classes.add("org.json.JSONObject");
    _jspx_imports_classes.add("java.nio.file.Paths");
    _jspx_imports_classes.add("com.scb.util.GlobalConstant");
    _jspx_imports_classes.add("java.util.Map");
    _jspx_imports_classes.add("com.genesyslab.studio.backendlogic.GVPHttpRequestProcessor");
    _jspx_imports_classes.add("org.apache.logging.log4j.LogManager");
    _jspx_imports_classes.add("org.json.JSONArray");
    _jspx_imports_classes.add("com.scb.ivr.db.entity.CallLog_Req");
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    if (!javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      final java.lang.String _jspx_method = request.getMethod();
      if ("OPTIONS".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        return;
      }
      if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method)) {
        response.setHeader("Allow","GET, HEAD, POST, OPTIONS");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET, POST or HEAD. Jasper also permits OPTIONS");
        return;
      }
    }

    final javax.servlet.jsp.PageContext pageContext;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("application/json;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, false, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\r');
      out.write('\n');
      out.write('\r');
      out.write('\n');
      out.write("\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n");
      out.write("\r\n\r\n\r\n\r\n");
      out.write('\r');
      out.write('\n');
      out.write('\r');
      out.write('\n');
      out.write('\r');
      out.write('\n');

response.setHeader("Cache-Control", "no-cache");
/* response.addHeader("X-Frame-Options", "DENY"); */     // Setting the "DENY" Flag on response object to restrict browsers that support this header from allowing embedding web-pages in a frame

 /* Logger logger = BackendLogManager.getLogger("backEnd"); */
String output = null; 

try {
    // process the post data
    GVPHttpRequestProcessor processor = new GVPHttpRequestProcessor(request);
    processor.parseRequest();
    
    // "state" encapsulates the state variable submitted by the VXML page
    JSONObject state = processor.getState();
    
    // additional parameters that were passed in the namelist
    Map<String, String> additionalParams = processor.getAdditionalParams();
    
    // perform the logic
    JSONObject result = performLogic(state, additionalParams);
    
    output = result.toString();
    
    out.print(output);
    /* logger.info("Output: " + output); */
    
} catch (Exception e) {
    
    //Removed the call to 'e.printstacktrace()' as printing the stack trace of an exception is a bad practice.
    
    //String msg = e.getMessage();
    //if (null != msg){
    //    msg = msg.replace('"', '\'');
    //}
    
     e.printStackTrace();
        String msg = e.getMessage();
        if (null != msg){
            msg = msg.replace('"', '\'');
        }
    out.print("An error has occured in the custom backend JSP file");
    /* logger.error("An error has occured in the custom backend JSP file"); */
}

    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
