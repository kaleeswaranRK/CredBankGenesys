/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: JspC/ApacheTomcat9
 * Generated at: 2023-09-06 17:14:45 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp.src;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import org.json.JSONObject;
import org.json.JSONException;
import java.util.Map;
import com.util.Logging;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.util.*;
import com.scb.util.*;
import com.scb.ivr.model.uaas.GenerateOTP_Req;
import com.scb.ivr.model.uaas.GenerateOTP_Res;
import java.text.SimpleDateFormat;
import com.scb.ivr.controller.UAASController;
import com.scb.ivr.spring.appcontext.SpringApplicationContext;
import org.json.JSONObject;
import com.genesyslab.studio.backendlogic.GVPHttpRequestProcessor;
import java.util.Map;

public final class OtpSend_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {


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


/* public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams)
{
    return new JSONObject();
} */

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(1);
    _jspx_dependants.put("/src/../include/backend.jspf", Long.valueOf(1691499940833L));
  }

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("java.util");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("com.scb.util");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = new java.util.HashSet<>();
    _jspx_imports_classes.add("org.json.JSONException");
    _jspx_imports_classes.add("org.json.JSONObject");
    _jspx_imports_classes.add("org.apache.logging.log4j.Logger");
    _jspx_imports_classes.add("com.scb.ivr.model.uaas.GenerateOTP_Req");
    _jspx_imports_classes.add("com.scb.ivr.spring.appcontext.SpringApplicationContext");
    _jspx_imports_classes.add("com.scb.ivr.model.uaas.GenerateOTP_Res");
    _jspx_imports_classes.add("java.util.Map");
    _jspx_imports_classes.add("com.scb.ivr.controller.UAASController");
    _jspx_imports_classes.add("java.text.SimpleDateFormat");
    _jspx_imports_classes.add("com.util.Logging");
    _jspx_imports_classes.add("com.genesyslab.studio.backendlogic.GVPHttpRequestProcessor");
    _jspx_imports_classes.add("org.apache.logging.log4j.LogManager");
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
      out.write(" \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n");
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
