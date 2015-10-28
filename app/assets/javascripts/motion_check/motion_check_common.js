// Generated by CoffeeScript 1.9.2
var MotionCheckCommon;

MotionCheckCommon = (function() {
  function MotionCheckCommon() {}

  MotionCheckCommon.run = function(newWindow) {
    var _operation;
    if (newWindow == null) {
      newWindow = false;
    }
    _operation = function() {
      var h, left, navbarHeight, size, target, top;
      h = PageValue.getEventPageValue(PageValue.Key.E_SUB_ROOT);
      if ((h != null) && Object.keys(h).length > 0) {
        LocalStorage.clearRun();
        target = '';
        if (newWindow) {
          size = PageValue.getGeneralPageValue(PageValue.Key.SCREEN_SIZE);
          navbarHeight = $("#" + Navbar.NAVBAR_ROOT).outerHeight(true);
          left = Number((window.screen.width - size.width) / 2);
          top = Number((window.screen.height - (size.height + navbarHeight)) / 2);
          target = "_runwindow";
          window.open("about:blank", target, "top=" + top + ",left=" + left + ",width=" + size.width + ",height=" + (size.height + navbarHeight) + ",menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no");
          document.run_form.action = '/motion_check/new_window';
        } else {
          target = "_runtab";
          window.open("about:blank", target);
          document.run_form.action = '/motion_check';
        }
        document.run_form.target = target;
        if (window.isWorkTable) {
          return ServerStorage.save(function() {
            return document.run_form.submit();
          });
        } else {
          return document.run_form.submit();
        }
      } else {
        return Message.showWarn('No event');
      }
    };
    if (window.isWorkTable) {
      return WorktableCommon.stopAllEventPreview(_operation);
    } else {
      return _operation.call(this);
    }
  };

  return MotionCheckCommon;

})();

//# sourceMappingURL=motion_check_common.js.map
