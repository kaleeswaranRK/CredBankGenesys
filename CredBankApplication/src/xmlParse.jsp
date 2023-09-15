<%@page language="java" contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%!
// Implement this method to execute some server-side logic.
public JSONObject performLogic(JSONObject state, Map<String, String> additionalParams) throws Exception {
    
    
	 JSONObject appSession = state.getJSONObject("appSession");    
	    String sessionID = state.getString("GVPSessionID").split(";")[0];
	    String callID = state.getString("CallUUID").trim();
	   String loggerName = appSession.getString("loggerName");
	   Date timeStamp = new Date();
	   Logger debugLogger = null;;
		String className = new Object(){}.getClass().getEnclosingClass().getName();
		className = className.split("[.]")[4];
		String loggingCommonFormat =  "{" + sessionID + "}," + callID + "," + className + ","; 
		debugLogger=Logging.LoggerConfiguration(sessionID);
    JSONObject result = new JSONObject();
    File inputFile = new File("D:/Genesys/config/menu.xml"); // Replace with the path to your XML file
	DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
	DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
	Document doc = dBuilder.parse(inputFile);
	doc.getDocumentElement().normalize();
	String initialPromptValue="";
	NodeList dialogStateList = doc.getElementsByTagName("dialogState");
	for (int temp = 0; temp < dialogStateList.getLength(); temp++) {
		Node dialogStateNode = dialogStateList.item(temp);
		if (dialogStateNode.getNodeType() == Node.ELEMENT_NODE) {
			Element dialogStateElement = (Element) dialogStateNode;
			NodeList initialPromptListNodes = dialogStateElement.getElementsByTagName("initialPromptList");
			for (int i = 0; i < initialPromptListNodes.getLength(); i++) {
				Node initialPromptNode = initialPromptListNodes.item(i);
				if (initialPromptNode.getNodeType() == Node.ELEMENT_NODE) {
					initialPromptValue = initialPromptNode.getTextContent();
				}
			}
		}
	}
	debugLogger.debug("xml parse value : "+initialPromptValue);
	result.put("initialPromptList",initialPromptValue);
    return result;
};
%>
<%-- GENERATED: DO NOT REMOVE --%>
<%@page import="com.util.Logging"%>
<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@page import="javax.xml.parsers.*"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="org.w3c.dom.NodeList"%>
<%@page import="java.util.Map"%>
<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@page import="org.w3c.dom.Element"%>
<%@include file="../include/backend.jspf"%>