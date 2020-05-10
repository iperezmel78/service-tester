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
        <style>
            .hidden {display: none}
            .visible {display: block}
            .ui-state-highlight {
                border: 1px solid #CEF199;
                background: #F3FDDF;
                color: #545F3F;
            }
            .ui-widget-overlay {
                background: #AAA;
                opacity: .30;
                filter: Alpha(Opacity=30);
            }
            .ui-dialog-titlebar-close {display: none}
        </style>
        <script src="js/jquery-1.12.4.min.js"></script>
        <script src="js/jquery-ui-1.12.1.min.js"></script>
        <script>
            var counter = 0;
            $(function () {
                $("#type").selectmenu();
                $("button").button();
                $("button").click(function (event) {
                    openDialog(true);
                    if ($(event.target).text() === "Call") {
                        $("#info").removeClass("visible");
                        $("#error").removeClass("visible");
                        $("#cant").val("");
                        doAjax($("#type").val(), true);
                    } else {
                        var max = 999;
                        $("#aDiv").html("");
                        $("#cant").val($("#cant").val() > max ? max : $("#cant").val() === "" ? 10 : $("#cant").val());
                        counter = 0;
                        var calls = [];
                        for (var i = 0; i < $("#cant").val(); i++) {
                            calls.push(function () {
                                doAjax($("#type").children("option").eq(Math.floor(Math.random() * ($("#type").children("option").length))).val(), false);
                            });
                        }
                        setTimeout(function () {
                            $(calls).each(function (i) {
                                calls[i]();
                            });
                        }, 10);
                    }
                });
                $("#cant").on("copy cut paste drop", function () {
                    return false;
                });
            });

            function openDialog(flag) {
                $("#dialog").dialog(flag ? {modal: true, draggable: false} : "close");
            }

            function doAjax(url, flag) {
                $.ajax({
                    type: "GET",
                    url: url,
                    success: function (data) {
                        if (flag) {
                            setContent(true, JSON.stringify(data));
                            openDialog(false);
                        } else {
                            $("#aDiv").append(getInfoHTML(true, JSON.stringify(data)));
                            closeDialog('' + ++counter === $("#cant").val());
                        }
                    },
                    error: function (xhr) {
                        if (flag) {
                            setContent(false, getErrorMsg(xhr));
                            openDialog(false);
                        } else {
                            $("#aDiv").append(getInfoHTML(false, getErrorMsg(xhr)));
                            closeDialog('' + ++counter === $("#cant").val());
                        }
                    }
                });
            }

            function closeDialog(flag) {
                if (flag) {
                    openDialog(false);
                }
            }

            function setContent(flag, msg) {
                var elem = $("#" + (flag ? "iContent" : "eContent"));
                elem.text("").append(getInfoMsg(flag, msg));
                $("#" + (flag ? "info" : "error")).addClass("visible");
            }

            function getInfoHTML(flag, msg) {
                return "<div class=\"ui-widget\">"
                        + "<div class=\"ui-state-" + (flag ? "highlight" : "error")
                        + " ui-corner-all\" style=\"padding: 0 .7em; word-wrap: break-word;\">"
                        + "<p>" + getInfoMsg(flag, msg) + "</p></div></div><br />";
            }

            function getInfoMsg(flag, msg) {
                return "<span class=\"ui-icon ui-icon-"
                        + (flag ? "info" : "alert")
                        + "\" style=\"float: left; margin-right: .3em\"></span>"
                        + "<strong>" + (flag ? "Response: " : "Error:")
                        + " </strong>" + msg;
            }

            function getErrorMsg(xhr) {
                var msg = "Status code " + xhr.status + " -> ";
                switch (xhr.status) {
                    case 0:
                        msg += "request not initialized";
                        break;
                        // Add more error status codes
                }
                return msg;
            }

            function isNumber(e, v) {
                var c = String.fromCharCode(e.which || e.keyCode);
                return /[0-9]/.test(c) && (v === "" ? /[1-9]/.test(c) : true);
            }

        </script>
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
