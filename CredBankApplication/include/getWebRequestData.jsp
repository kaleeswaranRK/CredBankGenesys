<%@page trimDirectiveWhitespaces="true"%>
<%@page contentType="application/json;charset=UTF-8"%>
<%@page import="com.genesyslab.studio.backendlogic.WebRequestBackendHandler"%>
<%
WebRequestBackendHandler webReqHandler = new WebRequestBackendHandler(); 
out.print(webReqHandler.handleRequest(request));
%>
