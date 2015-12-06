// Generated by CoffeeScript 1.9.2
var MyPageCommon;

MyPageCommon = (function() {
  function MyPageCommon() {}

  MyPageCommon.adjustContentsSize = function() {
    var height;
    height = $('.tabview_wrapper:first').height() - $('.nav-tabs:first').height();
    $('#myTabContent').height(height);
    return $('#user_wrapper').height(height - 2);
  };

  MyPageCommon.initResize = function() {
    return $(window).resize((function(_this) {
      return function() {
        return _this.adjustContentsSize();
      };
    })(this));
  };

  return MyPageCommon;

})();

//# sourceMappingURL=my_page_common.js.map