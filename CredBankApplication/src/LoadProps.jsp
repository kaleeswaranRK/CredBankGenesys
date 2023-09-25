<%@page language="java" contentType="application/json;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%!// Implement this method to execute some server-side logic.
	public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {

		JSONObject result = new JSONObject();

		String sessionID = state.getString("GVPSessionID").split(";")[0];
		String callID = state.getString("CallUUID").trim();

		Date timeStamp = new Date();
		String className = new Object() {
		}.getClass().getEnclosingClass().getName();
		className = className.split("[.]")[4];
		String loggingCommonFormat = "{" + sessionID + "}," + callID + "," + className + ",";

		//Get ANI & DNIS
		String DNIS = state.getString("DNIS").trim();
		String ANI = state.getString("ANI").trim();
		Logger debugLogger = null;
		String LOG_DIRECTORY = null;
		String filepath = null;
		JSONObject appSession = new JSONObject();
		InputStream appInfoPropFile = null;
		Properties appInfoProps = new Properties();
		try {

			String envType = "DEV";
			System.setProperty("ENVTYPE", envType);

			String logLevel = null;
			String loggerName = sessionID;
			String PropFilePath = "D:/Subbu/config/IvrAppInfo.properties";
			String ucid = "0000" + new SimpleDateFormat("ddMMyyyyhhmmssss").format(new Date());
			String logPattern = null;
			String logFileBackupIndexString = null;
			try {
				//		if(envType!= null){
				//			appInfoPropFile =new FileInputStream(PropFilePath);
				//		} else {			
				//    		appInfoPropFile = new FileInputStream(PropFilePath);
				//    	}


				ConfigController controller = (ConfigController) SpringApplicationContext.getBean("configController");
				appInfoProps = (Properties) controller.getConfigFileValues("GCCP_BH_IVR_Config.properties");
				//   	appInfoProps.load(appInfoPropFile);
			System.setProperty("log4jpath", appInfoProps.getProperty("LOG4J_PATH").trim());
			System.setProperty("logxmlPath", appInfoProps.getProperty("LOGXML_PATH").trim());
				String logFileSizeString = appInfoProps.getProperty("LOG_FILE_SIZE").trim();
				int logFileSize = Integer.parseInt(logFileSizeString.trim());
				logFileBackupIndexString = appInfoProps.getProperty("LOG_FILE_BACKUPINDEX").trim();
				int logFileBackupIndex = Integer.parseInt(logFileBackupIndexString.trim());
				logPattern = appInfoProps.getProperty("LOG_PATTERN").trim();

				if (logLevel == null) {
					logLevel = appInfoProps.getProperty("LOG_LEVEL").trim();
				}

				LOG_DIRECTORY = appInfoProps.getProperty("DEV.LOG_DIRECTORY").trim();

				if (LOG_DIRECTORY.endsWith("/")) {
					filepath = LOG_DIRECTORY + loggerName + ".log";
				} else {
					filepath = LOG_DIRECTORY + "/" + loggerName + ".log";
				}
			} catch (Exception e) {
				System.out.println(e);
				int logFileSize = 20;
				int logFileBackupIndex = 50;
				LOG_DIRECTORY = "D:/Genesys/ElibraryLogs";
				logPattern = "%m%n";
				if (LOG_DIRECTORY.endsWith("/")) {
					filepath = LOG_DIRECTORY + loggerName + ".log";
				} else {
					filepath = LOG_DIRECTORY + "/" + loggerName + ".log";
				}
				logFileBackupIndexString = "50";
				logLevel = "debug";
			}


			debugLogger = Logging.LoggerConfiguration(sessionID);
			debugLogger.debug(loggingCommonFormat + "IVR CONFIG : " + appInfoProps);
			//System.out.println("Split "+new Object(){}.getClass().getEnclosingClass().getName().split("[.]")[4].toString());

			//		System.out.println("Currently running Java file: " + className);
			//	    debugLogger.debug(loggingCommonFormat + "cred card "+" 4123412341234123 ");
			//	    debugLogger.debug(loggingCommonFormat + "pin "+" 4123 ");

			//debugLogger = LogManager.getLogger(loggerName);	
			//		ConfigController controller = (ConfigController) SpringApplicationContext.getBean("configController");
			//		debugLogger.debug(loggingCommonFormat + "MENU JSON FROM CONFIG : "+controller.getConfigFileValues("menu.json"));
			//		Map<String, Map<String, String>> mapvalue=(Map<String, Map<String, String>>) controller.getConfigFileValues("menu.json");
			//		Map<String, String> map = (Map<String, String>)mapvalue.get("langMenu");
			//		debugLogger.debug(loggingCommonFormat + "MENU JSON FROM map : "+map);
			//		debugLogger.debug(loggingCommonFormat + map.get("PROMPTS"));
			//		debugLogger.debug(loggingCommonFormat + map.get("BARGEIN"));
			//		debugLogger.debug(loggingCommonFormat + map.get("GRAMMARS"));
			//		debugLogger.debug(loggingCommonFormat + map.get("MENU_DESC"));
			//		debugLogger.debug(loggingCommonFormat + map.get("NEXT_NODE"));
			//		debugLogger.debug(loggingCommonFormat + map.get("NI_PROMPT"));
			//		debugLogger.debug(loggingCommonFormat + map.get("NM_PROMPT"));
			//		debugLogger.debug(loggingCommonFormat + map.get("RETRY"));
			//		debugLogger.debug(loggingCommonFormat + map.get("STATE_ID"));
			//  	debugLogger.debug(loggingCommonFormat + map.get("MENU_TIMEOUT"));
			//		debugLogger.debug(loggingCommonFormat + map.get("MAXTRIES"));
			//		debugLogger.debug(loggingCommonFormat + map.get("MAXTRIES_NEXTNODE"));
			//		debugLogger.debug(loggingCommonFormat + map.get("INTENT"));
			//	    debugLogger.debug(loggingCommonFormat + "AppSession Starting value : "+ appSession);
			//		debugLogger.debug(loggingCommonFormat + "****************Init Properties Entry **************************");
			//		debugLogger.debug(loggingCommonFormat + "ANI: " + state.getString("ANI").trim());
			//	   	debugLogger.debug(loggingCommonFormat + "DNIS: " + state.getString("DNIS").trim());
			//	   	debugLogger.debug(loggingCommonFormat + "In Master CallFlow - InitProperties");
			//	   	debugLogger.debug(loggingCommonFormat + "envType from Websphere ENV : " + System.getProperty("ENVTYPE"));
			appSession.put("filepath", filepath);

			//Initialize appSession values
			appSession.put("TechnicalDifficulties", "");
			appSession.put("ANI", appInfoProps.getProperty("ANI"));
			appSession.put(GlobalConstant.MAX_RETRY_COUNT, 3);
			appSession.put("overallCounter", 0);
			appSession.put("eventName", "");
			appSession.put("loggerName", loggerName);
			appSession.put("logPattern", logPattern);
			appSession.put("logFileBackupIndexString", logFileBackupIndexString);
			appSession.put(GlobalConstant.MAX_RETRY_COUNT, 3);
			appSession.put("overallCounter", 0);
			appSession.put("ucid", ucid);
			appSession.put("isCustIden", "NO");
			appSession.put("subFlowStatus", "NA");
			appSession.put("otpAvailable", "NA");
			appSession.put("validotp", "NA");
			appSession.put("OTPAUTH", "NA");
			appSession.put("TPINAUTH", "NA");
			appSession.put("ErrorCode", "NA");
			appSession.put("CLI", appInfoProps.getProperty("ANI"));
			appSession.put("DNIS", DNIS);
			appSession.put("STARTTIME", new Date().getTime());
			appSession.put("ENDTIME", "NA");
			appSession.put(GlobalConstant.AUDIOLOCATION, state.getString("VOXFILEDIR") + "/en-US/");
			appSession.put("EXTENSION_WAVE", ".vox");
			appSession.put(GlobalConstant.LASTMENU, "NA");
			appSession.put(GlobalConstant.EXCEPTION, "NA");
			appSession.put("SESSION_ID", sessionID);
			appSession.put("OTP_DEST", "NA");
			appSession.put("cardHost", "NA");
			appSession.put("ACC_CARD_ID", "NA");
			appSession.put(GlobalConstant.ACCNUM, "NA");
			appSession.put("cardstatus", "NA");
			appSession.put("cardnum", "NA");
			appSession.put(GlobalConstant.SMSSENT, "NA");
			appSession.put("LASTMENU", "START");
			appSession.put("MENUTRAVERSE", "START");

			appSession.put("ERRORCOUNT", 0);
			appSession.put(GlobalConstant.SEGMENT, "NA");
			appSession.put(GlobalConstant.RELID, "NA");
			appSession.put(GlobalConstant.ISRMN, "N");
			appSession.put(GlobalConstant.LANGUAGECODE, "E");
			appSession.put(GlobalConstant.ONEFA, "TPIN|NA,OTP|NA");
			appSession.put(GlobalConstant.MOBILE, "NA");
			appSession.put(GlobalConstant.RMN, "NA");
			appSession.put(GlobalConstant.BANK_CARD_LOAN, "NA");
			appSession.put(GlobalConstant.TRANSFER_OR_DISCONNECT, "D");
			appSession.put(GlobalConstant.SEGMENTCODE, "NA");
			appSession.put(GlobalConstant.BLOCKCODE, "NA");
			appSession.put(GlobalConstant.LANGUAGE, "ENGLISH");
			appSession.put(GlobalConstant.CONTEXTID, "NA");
			appSession.put(GlobalConstant.TRANSATTRIBUTE, "NA");
			appSession.put(GlobalConstant.COUNTRY, "IN");
			appSession.put(GlobalConstant.ONEFA, appSession.getString("ONEFA"));
			appSession.put(GlobalConstant.TWOFA, "NA");
			appSession.put(GlobalConstant.VERIFIEDBY, "NA");
			appSession.put(GlobalConstant.IDENTIFIED_BY, "NA");
			appSession.put(GlobalConstant.CHANNEL, "IVR");
			appSession.put(GlobalConstant.INVOLUNTARYREASON, "NA");
			appSession.put(GlobalConstant.AGENTID, "NA");
			appSession.put(GlobalConstant.DISCONNECTREASON, "SUCCESS");
			appSession.put(GlobalConstant.MOBILE, "NA");
			appSession.put(GlobalConstant.MENUTRAVERSE, "START");
			debugLogger.debug(loggingCommonFormat + "AppSession End Value : " + appSession);

			debugLogger.debug(loggingCommonFormat + "****************Init Properties Exit **************************");
		} catch (Exception e) {
			System.out.println(e);
		}

		result.put("appSession", appSession);
		return result;

	};%>
<%-- GENERATED: DO NOT REMOVE --%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="com.scb.util.GlobalConstant"%>
<%@page import="java.util.*"%>
<%@page import="com.util.Logging"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.Map"%>
<%@page import="com.scb.ivr.spring.appcontext.SpringApplicationContext"%>

<%@page import="com.scb.ivr.controller.ConfigController"%>
<%@include file="../include/backend.jspf"%>