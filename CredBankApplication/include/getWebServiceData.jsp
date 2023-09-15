<%@page language="java"%>
<%@page contentType="application/json;charset=UTF-8"%>
<%@page
	import="javax.naming.InitialContext,java.net.*,java.io.BufferedInputStream,java.io.*,java.util.*"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="org.json.JSONObject"%>
<%@page	import="com.genesyslab.studio.backendlogic.WebServiceBackendProcessor"%>
<%@page import="com.genesyslab.studio.backendlogic.BackendLogManager"%>
<%@page import="javax.net.ssl.SSLContext"%>
<%@page import="javax.net.ssl.TrustManager"%>
<%@page import="javax.net.ssl.X509TrustManager"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="javax.net.ssl.HostnameVerifier"%>
<%@page import="javax.net.ssl.SSLSession"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.util.concurrent.Callable"%> 
<%@page import="java.util.concurrent.ExecutorService"%>
<%@page import="java.util.concurrent.Executors"%>
<%@page import="java.util.concurrent.Future"%>

<%!
Logger logger = BackendLogManager.getLogger("getWebService");
boolean throwServerException = false;  // Flag to display Error Messages
private String buildErrorResponse(String message) {
	

	logger.info("buildErrorResponse() in");
    StringBuffer sb = new StringBuffer();
    sb.append("'errorMsg'");
    sb.append(":");
    sb.append("'").append(message).append("',");
    sb.append("'throwServerException'");
    sb.append(":");
    sb.append(throwServerException);

	logger.error("buildErrorResponse:" + "{" + sb.toString() + "}");
	logger.info("buildErrorResponse() out");
    return "{" + sb.toString() + "}";

};
%>
<%
    // This backend logic will process WebServices requests and responses for URS
    logger.info("getWebServiceData:Start");
    HttpURLConnection con = null;
    String readTimeout = "20000"; // timeout in milliseconds
    String conTimeout = "20000"; // timeout in milliseconds
    Boolean legacyFlow = false;
    boolean webHttpsProductionMode = false;
    
    final WebServiceBackendProcessor processor = new WebServiceBackendProcessor(
            request);
    processor.parseRequest();
    FileInputStream ipStr = null;
    FileOutputStream opStr = null;
    try {
        Properties properties = new Properties();
        ipStr = new FileInputStream(request
                .getRealPath("/WEB-INF/composer.properties"));
        properties.load(ipStr);
        if (properties.getProperty("web.connectionTimeout") != null) {
            conTimeout = properties
                    .getProperty("web.connectionTimeout");
        }
        if (properties.getProperty("web.readTimeout") != null) {
            readTimeout = properties.getProperty("web.readTimeout");
        }
	
	if (properties.getProperty("web.throwServerException") != null) {
		throwServerException = Boolean.parseBoolean(properties.getProperty("web.throwServerException"));
        }
	
     	// During project upgrade remove the property 'web.legacyCertificateCode' if this key is present.
     	if (properties.getProperty("web.legacyCertificateCode") != null) {

     		properties.remove("web.legacyCertificateCode");
     		opStr = new FileOutputStream(request.getRealPath("/WEB-INF/composer.properties"));
     		properties.store(opStr, "Removed the flag 'web.legacyCertificateCode'");
     	}
     	
     	if (properties.getProperty("web.legacyFlow") != null) {
				legacyFlow = Boolean.parseBoolean(properties.getProperty("web.legacyFlow"));
		}
		
		if (properties.getProperty("web.https.productionMode") != null) {
				webHttpsProductionMode = Boolean.parseBoolean(properties.getProperty("web.https.productionMode"));
		}
				
        logger.debug("conTimeout: " + conTimeout + ", readTimeout: " + readTimeout + ", throwServerException: " + throwServerException + ", legacyFlow: " + legacyFlow + ", webHttpsProductionMode: " + webHttpsProductionMode);
    } catch (Exception e) {
    	 logger.error("Could not find properties file. Hence using default connectionTimeout and readTimeout values");
    } finally {
			if (ipStr != null) {
				try {
					ipStr.close();
				} catch (IOException e) {
					logger.error("Error in closing properties input file stream");
				}
			} if(opStr != null) {
				try {
					opStr.close();
				} catch (IOException e) {
					logger.error("Error in closing properties output file stream",e);
				}
			}
		}

    String value = null;

    URL url = processor.formURI();
       
    
    if (url != null) {
        try {
           final String connectTimeout = conTimeout;
           final String connectReadTimeout = readTimeout;
           final boolean webHttpsProdMode = webHttpsProductionMode;
        	if(legacyFlow) {
				// Fallback mechanism to invoke the service in the older fashion.
				logger.info("Legacy Flow - 'web.LegacyFlow' has been enabled");
				processor.formHTTPMessage(connectTimeout, connectReadTimeout, webHttpsProdMode);
           		processor.connectToURL();
            	value = processor.readWebServiceresponse();
				logger.info("Legacy Flow - Exit!!");
				
				
			} else {			  
				/**
				 * Raise the request/response in a separate thread.
				 */
				logger.info("Async Flow Execution!");
				ExecutorService executorService = Executors.newFixedThreadPool(3);

				Future<Object> future = executorService.submit(new Callable<Object>() {
				    public Object call() throws Exception {
				    	logger.info("Async Flow Start!");
				    	processor.formHTTPMessage(connectTimeout, connectReadTimeout, webHttpsProdMode);
           				processor.connectToURL();
            			String retValue = processor.readWebServiceresponse();
            			logger.info("Async Flow End - "+retValue);
            			return retValue;
				    }
				});
				logger.info("Main thread!");		
				value = (String) future.get();
				logger.info("Value - "+ value);
				executorService.shutdown();
					
			}
           
            if (value == null) {
                // URS will generate error.session.fetch when receiving response of 500
                out.print(buildErrorResponse("error.com.genesyslab.composer.webservice.badFetch - Input Stream cannot be read"));
              // Removed the logger over here as it is already been taken care in method 'buildErrorResponse(..)' above
                return;
            } else {
                value = processor.processSOAPMessage(value);
                String postData = value;
                JSONObject result = org.json.XML.toJSONObject(postData);
                value = result.toString();
                logger.debug("result:" + result.toString());
                logger.debug("value:" + value.toString());
                if (processor.isSOAPFault()) {
                    out.print(buildErrorResponse(value));
                    return;
                }
            }
        } catch (Exception e) {
            // Removed the logger over here as it is already been taken care in method 'buildErrorResponse(..)' below
            out.print(buildErrorResponse("An error has occured - "+e.getMessage()));

            return;
        }

    } else {
        out.print(buildErrorResponse("error.com.genesyslab.composer.webservice.badFetch - Requested URL cannot be fetched"));
        // Removed the logger over here as it is already been taken care in method 'buildErrorResponse(..)' above
        return;

    }

    processor.disconnectConnection();
    if (null != value) {
        // value should not be null here 
        out.print(value);
        logger.debug("value:" + value.toString());
    }
    logger.info("getWebServiceData:End");
%>