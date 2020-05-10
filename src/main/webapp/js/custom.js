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
