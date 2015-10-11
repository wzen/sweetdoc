// Generated by CoffeeScript 1.10.0
var RunSetting;

RunSetting = (function() {
  var constant;

  function RunSetting() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    RunSetting.ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME;
    RunSetting.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.SHOW_GUIDE = PageValue.Key.ST_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + 'show_guide';

      return PageValueKey;

    })();
  }

  RunSetting.isShowGuide = function() {
    var ret;
    ret = PageValue.getSettingPageValue(this.PageValueKey.SHOW_GUIDE);
    ret = (ret == null) || ret === 'true';
    return ret;
  };

  RunSetting.toggleShowGuide = function() {
    PageValue.setSettingPageValue(this.PageValueKey.SHOW_GUIDE, !this.isShowGuide());
    if (window.eventAction != null) {
      if (this.isShowGuide()) {
        return window.eventAction.thisPage().thisChapter().showGuide();
      } else {
        return window.eventAction.thisPage().thisChapter().hideGuide();
      }
    }
  };

  return RunSetting;

})();

//# sourceMappingURL=run_setting.js.map
