/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Message {

  // 警告表示
  // @param [String] message メッセージ内容
  static showWarn(message) {
    let bottom, css;
    const warnFooter = $('.warn-message');
    const errorFooter = $('.error-message');
    const warnDisplay = $('.footer-message-display', warnFooter);
    const isBeforeWarnDisplay = warnDisplay.val() === "1";
    const isErrorDisplay = $('.footer-message-display', errorFooter).val() === "1";
    const mes = $('> div > p', warnFooter);

    if(message === undefined) {
      return;
    }

    warnDisplay.val("1");
    const exist_mes = mes.html();
    if((exist_mes === null) || (exist_mes === "")) {
      mes.html(message);
    } else {
      mes.html(exist_mes + '<br/>' + message);
    }

    if(messageTimer !== null) {
      clearTimeout(messageTimer);
    }

    if(isBeforeWarnDisplay) {
      css = {};
    } else {
      if(isErrorDisplay) {
        bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10;
        css = {bottom: bottom + 'px'};
      } else {
        css = {bottom: '20px'};
      }
    }

    return warnFooter.animate(css, 'fast', e =>
      window.messageTimer = setTimeout(function(e) {
          const footer = $('.footer-message');
          $('.footer-message-display', footer).val("0");
          return footer.stop().animate({bottom: '-30px'}, 'fast', function(e) {
            window.messageTimer = null;
            return $('> div > p', $(this)).html('');
          });
        }
        , 3000)
    );
  }

  // エラー表示
  // @param [String] message メッセージ内容
  static showError(message) {
    let css;
    const warnFooter = $('.warn-message');
    const errorFooter = $('.error-message');
    const errorDisplay = $('.footer-message-display', errorFooter);
    const isBeforeErrorDisplay = errorDisplay.val() === "1";
    const isWarnDisplay = $('.footer-message-display', warnFooter).val() === "1";
    const mes = $('> div > p', errorFooter);

    if(message === undefined) {
      return;
    }

    errorDisplay.val("1");
    const exist_mes = mes.html();
    if((exist_mes === null) || (exist_mes === "")) {
      mes.html(message);
    } else {
      mes.html(exist_mes + '<br/>' + message);
    }

    if(messageTimer !== null) {
      clearTimeout(messageTimer);
    }

    if(isBeforeErrorDisplay) {
      css = {};
    } else {
      css = {bottom: '20px'};
    }

    return errorFooter.animate(css, 'fast', function(e) {
      let bottom;
      if(isWarnDisplay) {
        bottom = parseInt(errorFooter.css('bottom'), 10) + errorFooter.height() + 10;
        css = {bottom: bottom + 'px'};
        warnFooter.stop().animate(css, 'fast');
      }

      return window.messageTimer = setTimeout(function(e) {
          const footer = $('.footer-message');
          $('.footer-message-display', footer).val("0");
          return footer.stop().animate({bottom: '-30px'}, 'fast', function(e) {
            window.messageTimer = null;
            return $('> div > p', $(this)).html('');
          });
        }
        , 3000);
    });
  }

  // 警告表示(フラッシュ)
  // @param [String] message メッセージ内容
  static flushWarn(message) {
    // 他のメッセージが表示されているときは表示しない
    if(window.messageTimer !== null) {
      return;
    }

    if(window.flushMessageTimer !== null) {
      clearTimeout(flushMessageTimer);
    }

    const fw = $('#flush_warn');
    const mes = $('> div > p', fw);
    mes.html(message);
    fw.show();
    return window.flushMessageTimer = setTimeout(e => fw.hide()
      , 100);
  }
}