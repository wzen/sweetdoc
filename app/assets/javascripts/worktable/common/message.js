// Generated by CoffeeScript 1.9.2
var Message;

Message = (function() {
  function Message() {}

  Message.showWarn = function(message) {
    var bottom, css, errorFooter, exist_mes, isBeforeWarnDisplay, isErrorDisplay, mes, warnDisplay, warnFooter;
    warnFooter = $('.warn-message');
    errorFooter = $('.error-message');
    warnDisplay = $('.footer-message-display', warnFooter);
    isBeforeWarnDisplay = warnDisplay.val() === "1";
    isErrorDisplay = $('.footer-message-display', errorFooter).val() === "1";
    mes = $('> div > p', warnFooter);
    if (message === void 0) {
      return;
    }
    warnDisplay.val("1");
    exist_mes = mes.html();
    if (exist_mes === null || exist_mes === "") {
      mes.html(message);
    } else {
      mes.html(exist_mes + '<br/>' + message);
    }
    if (messageTimer !== null) {
      clearTimeout(messageTimer);
    }
    if (isBeforeWarnDisplay) {
      css = {};
    } else {
      if (isErrorDisplay) {
        bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10;
        css = {
          bottom: bottom + 'px'
        };
      } else {
        css = {
          bottom: '20px'
        };
      }
    }
    return warnFooter.animate(css, 'fast', function(e) {
      return window.messageTimer = setTimeout(function(e) {
        var footer;
        footer = $('.footer-message');
        $('.footer-message-display', footer).val("0");
        return footer.stop().animate({
          bottom: '-30px'
        }, 'fast', function(e) {
          window.messageTimer = null;
          return $('> div > p', $(this)).html('');
        });
      }, 3000);
    });
  };

  Message.showError = function(message) {
    var css, errorDisplay, errorFooter, exist_mes, isBeforeErrorDisplay, isWarnDisplay, mes, warnFooter;
    warnFooter = $('.warn-message');
    errorFooter = $('.error-message');
    errorDisplay = $('.footer-message-display', errorFooter);
    isBeforeErrorDisplay = errorDisplay.val() === "1";
    isWarnDisplay = $('.footer-message-display', warnFooter).val() === "1";
    mes = $('> div > p', errorFooter);
    if (message === void 0) {
      return;
    }
    errorDisplay.val("1");
    exist_mes = mes.html();
    if (exist_mes === null || exist_mes === "") {
      mes.html(message);
    } else {
      mes.html(exist_mes + '<br/>' + message);
    }
    if (messageTimer !== null) {
      clearTimeout(messageTimer);
    }
    if (isBeforeErrorDisplay) {
      css = {};
    } else {
      css = {
        bottom: '20px'
      };
    }
    return errorFooter.animate(css, 'fast', function(e) {
      var bottom;
      if (isWarnDisplay) {
        bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10;
        css = {
          bottom: bottom + 'px'
        };
        warnFooter.stop().animate(css, 'fast');
      }
      return window.messageTimer = setTimeout(function(e) {
        var footer;
        footer = $('.footer-message');
        $('.footer-message-display', footer).val("0");
        return footer.stop().animate({
          bottom: '-30px'
        }, 'fast', function(e) {
          window.messageTimer = null;
          return $('> div > p', $(this)).html('');
        });
      }, 3000);
    });
  };

  Message.flushWarn = function(message) {
    var fw, mes;
    if (window.messageTimer !== null) {
      return;
    }
    if (window.flushMessageTimer !== null) {
      clearTimeout(flushMessageTimer);
    }
    fw = $('#flush_warn');
    mes = $('> div > p', fw);
    mes.html(message);
    fw.show();
    return window.flushMessageTimer = setTimeout(function(e) {
      return fw.hide();
    }, 100);
  };

  return Message;

})();

//# sourceMappingURL=message.js.map
