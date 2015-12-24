// Generated by CoffeeScript 1.9.2
var FloatView;

FloatView = (function() {
  function FloatView() {}

  FloatView.Type = (function() {
    function Type() {}

    Type.PREVIEW = 'preview';

    Type.DISPLAY_POSITION = 'display_position';

    Type.INFO = 'info';

    Type.WARN = 'warn';

    Type.ERROR = 'error';

    return Type;

  })();

  FloatView.show = function(message, type) {
    var root, screenWrapper;
    if (!window.initDone) {
      return;
    }
    screenWrapper = $('#screen_wrapper');
    root = $(".float_view." + type + ":first", screenWrapper);
    if (root.length === 0) {
      $(".float_view", screenWrapper).remove();
      $('.float_view_temp', screenWrapper).clone(true).attr('class', 'float_view').appendTo(screenWrapper);
      root = $('.float_view:first', screenWrapper);
      root.removeClass(function(index, className) {
        return className !== 'float_view';
      }).addClass(type);
      $('.message', root).removeClass(function(index, className) {
        return className !== 'message';
      }).addClass(type);
    }
    root.show();
    return $('.message', root).html(message);
  };

  FloatView.hide = function() {
    return $(".float_view:not('.fixed')").fadeOut('fast');
  };

  FloatView.showFixed = function(message, type, closeFunc) {
    var root, screenWrapper;
    if (closeFunc == null) {
      closeFunc = null;
    }
    if (!window.initDone) {
      return;
    }
    screenWrapper = $('#screen_wrapper');
    root = $(".float_view.fixed." + type + ":first", screenWrapper);
    if (root.length > 0) {
      return;
    }
    $(".float_view", screenWrapper).remove();
    $('.float_view_fixed_temp', screenWrapper).clone(true).attr('class', 'float_view fixed').appendTo(screenWrapper);
    root = $('.float_view.fixed:first', screenWrapper);
    root.find('.close_button').off('click').on('click', (function(_this) {
      return function(e) {
        if (closeFunc != null) {
          closeFunc();
        }
        return _this.hideFixed();
      };
    })(this));
    root.removeClass(function(index, className) {
      return className !== 'float_view' && className !== 'fixed';
    }).addClass(type);
    $('.message', root).removeClass(function(index, className) {
      return className !== 'message';
    }).addClass(type);
    root.show();
    return $('.message', root).html(message);
  };

  FloatView.hideFixed = function() {
    return $(".float_view.fixed").fadeOut('fast');
  };

  FloatView.scrollMessage = function(top, left) {
    var l, screenSize, t;
    if (!window.initDone) {
      return '';
    }
    screenSize = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
    if (screenSize != null) {
      t = (window.scrollInsideWrapper.height() + screenSize.height) * 0.5 - top;
      l = (window.scrollInsideWrapper.width() + screenSize.width) * 0.5 - left;
      return "X: " + l + "  Y:" + t;
    }
    return '';
  };

  FloatView.displayPositionMessage = function() {
    return 'Running Preview';
  };

  return FloatView;

})();

//# sourceMappingURL=float_view.js.map
