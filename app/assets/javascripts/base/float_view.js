// Generated by CoffeeScript 1.9.2
var FloatView;

FloatView = (function() {
  function FloatView() {}

  FloatView.Type = (function() {
    function Type() {}

    Type.PREVIEW = 'preview';

    Type.DISPLAY_POSITION = 'display_position';

    return Type;

  })();

  FloatView.show = function(message, type) {
    var messageCss, root, rootCss, screenWrapper;
    if (!window.initDone) {
      return;
    }
    screenWrapper = $('#screen_wrapper');
    root = $('.float_view:first', screenWrapper);
    if (root.length === 0) {
      $('.float_view_temp', screenWrapper).clone(true).attr('class', 'float_view').appendTo(screenWrapper);
      root = $('.float_view:first', screenWrapper);
      if (type === this.Type.PREVIEW) {
        rootCss = {
          'background-color': 'black',
          opacity: '0.3',
          'z-index': '1999999999'
        };
        messageCss = {
          color: 'white',
          'font-size': '24px'
        };
      } else if (type === this.Type.DISPLAY_POSITION) {
        rootCss = {
          'background-color': 'black',
          opacity: '0.3',
          'z-index': '1999999999'
        };
        messageCss = {
          color: 'white',
          'font-size': '24px'
        };
      }
      root.css(rootCss);
      $('.message', root).css(messageCss);
    } else {
      root.show();
    }
    return $('.message', root).html(message);
  };

  FloatView.hide = function() {
    return $(".float_view").fadeOut('fast');
  };

  FloatView.scrollMessage = function(top, left) {
    var l, screenSize, t;
    if (!window.initDone) {
      return '';
    }
    screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
    if (screenSize != null) {
      t = (window.scrollInside.height() + screenSize.height) * 0.5 - top;
      l = (window.scrollInside.width() + screenSize.width) * 0.5 - left;
      return "X: " + l + "  Y:" + t;
    }
    return '';
  };

  FloatView.displayPositionMessage = function() {
    return 'Motion Preview';
  };

  return FloatView;

})();

//# sourceMappingURL=float_view.js.map