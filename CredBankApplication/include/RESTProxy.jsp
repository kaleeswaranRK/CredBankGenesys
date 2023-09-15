<%@page trimDirectiveWhitespaces="true"%>
<%@page contentType="application/json;charset=UTF-8"%>
<%@page import="com.genesyslab.studio.backendlogic.RESTProxyBackendHandler"%>
<%
RESTProxyBackendHandler proxy = new RESTProxyBackendHandler(); 
out.print(proxy.handleRequest(request));
%>
