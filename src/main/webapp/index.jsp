<%-- 
    Document   : index
    Created on : 7/05/2020, 02:45:22 PM
    Author     : admin
--%><%@page contentType="text/html" pageEncoding="UTF-8"%><%@page import="java.util.Map, com.sidc.service.tester.utils.PropertyLoader"%><!doctype html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Service Tester</title>
        <link rel="stylesheet" href="css/jquery-ui-1.12.1.min.css">
        <link rel="stylesheet" href="css/custom.css">
        <script src="js/jquery-1.12.4.min.js"></script>
        <script src="js/jquery-ui-1.12.1.min.js"></script>
        <script src="js/custom.js"></script>
    </head>
    <body>
        <h1>Microservices test application!</h1>
        <!-- ui-dialog -->
        <div id="dialog" title="Information" class="hidden">
            <p style="margin: 30px auto"><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 12px 20px 0;"></span>Processing requests. Wait...</p>
        </div>
        <div id="info" class="hidden">
            <div class="ui-widget">
                <div class="ui-state-highlight ui-corner-all" 
                     style="margin-top: 20px; padding: 0 .7em; word-wrap: break-word;">
                    <p id="iContent"></p>
                </div>
            </div>
        </div>
        <div id="error" class="hidden">
            <div class="ui-widget">
                <div class="ui-state-error ui-corner-all" style="padding: 0 .7em; word-wrap: break-word;">
                    <p id="eContent"></p>
                </div>
            </div>
        </div>
        <br />
        <select id="type"><%
            for (Map.Entry<String, String> entry : PropertyLoader.getServicesKeyValues(new String[]{"wildfly", "vertx", "springboot", "nodejs", "discovery", "unknown"}).entrySet()) {%>
            <option value="<%= entry.getKey()%>"><%= entry.getValue()%></option><% }%>
        </select>
        <button>Call</button>
        <p />
        <input id="cant" type="text" placeholder="Quantity" style="width: 60px; height: 26px" maxlength="3" onkeypress="return isNumber(event, this.value)" autocomplete="off"/> 
        <button>Make</button>
        <div id="aDiv"></div>
    </body>
</html>
