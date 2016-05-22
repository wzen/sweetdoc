// Generated by CoffeeScript 1.10.0
var MotionCheckCommon;

MotionCheckCommon = (function() {
  function MotionCheckCommon() {}

  MotionCheckCommon.run = function(newWindow) {
    var left, navbarHeight, size, target, top;
    if (newWindow == null) {
      newWindow = false;
    }
    window.lStorage.clearRun();
    target = '';
    if (newWindow) {
      size = Common.getScreenSize();
      navbarHeight = $("#" + Navbar.NAVBAR_ROOT).outerHeight(true);
      left = Number((window.screen.width - size.width) / 2);
      top = Number((window.screen.height - (size.height + navbarHeight)) / 2);
      target = "_runwindow";
      window.open("about:blank", target, "top=" + top + ",left=" + left + ",width=" + size.width + ",height=" + (size.height + navbarHeight) + ",menubar=no,toolbar=no,location=no,status=no,resizable=no,scrollbars=no");
      document.run_form.action = '/motion_check/new_window';
    } else {
      target = "_runtab";
      if (window.name === target) {
        target = "_runtab2";
      }
      window.open("about:blank", target);
      document.run_form.action = '/motion_check';
    }
    document.run_form.target = target;
    if (window.isWorkTable && !Project.isSampleProject()) {
      return ServerStorage.save(function(data) {
        if (data.resultSuccess) {
          PageValue.setGeneralPageValue(PageValue.Key.RUNNING_USER_PAGEVALUE_ID, data.updated_user_pagevalue_id);
          return document.run_form.submit();
        } else {
          return console.log('ServerStorage save error');
        }
      });
    } else {
      return document.run_form.submit();
    }
  };

  return MotionCheckCommon;

})();

//# sourceMappingURL=motion_check_common.js.map
