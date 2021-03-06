// Generated by CoffeeScript 1.9.2
var ScrollGuide,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ScrollGuide = (function(superClass) {
  var constant;

  extend(ScrollGuide, superClass);

  function ScrollGuide() {
    return ScrollGuide.__super__.constructor.apply(this, arguments);
  }

  constant = gon["const"];

  ScrollGuide.TOP_ROOT_ID = constant.RunGuide.TOP_ROOT_ID;

  ScrollGuide.BOTTOM_ROOT_ID = constant.RunGuide.BOTTOM_ROOT_ID;

  ScrollGuide.LEFT_ROOT_ID = constant.RunGuide.LEFT_ROOT_ID;

  ScrollGuide.RIGHT_ROOT_ID = constant.RunGuide.RIGHT_ROOT_ID;

  ScrollGuide.showGuide = function(enableDirection, forwardDirection, canForward, canReverse) {
    var base, emt;
    this.hideGuide();
    if (enableDirection.top) {
      base = $("#" + this.TOP_ROOT_ID);
      emt = base.find('.guide_scroll_image_mac:first');
      if (forwardDirection.top && canForward) {
        emt.removeClass('reverse').addClass('forward');
        base.show();
      } else if (!forwardDirection.top && canReverse) {
        emt.removeClass('forward').addClass('reverse');
        base.show();
      }
    }
    if (enableDirection.bottom) {
      base = $("#" + this.BOTTOM_ROOT_ID);
      emt = base.find('.guide_scroll_image_mac:first');
      if (forwardDirection.bottom && canForward) {
        emt.removeClass('reverse').addClass('forward');
        base.show();
      } else if (!forwardDirection.bottom && canReverse) {
        emt.removeClass('forward').addClass('reverse');
        base.show();
      }
    }
    if (enableDirection.left) {
      base = $("#" + this.LEFT_ROOT_ID);
      emt = base.find('.guide_scroll_image_mac:first');
      if (forwardDirection.left && canForward) {
        emt.removeClass('reverse').addClass('forward');
        base.show();
      } else if (!forwardDirection.left && canReverse) {
        emt.removeClass('forward').addClass('reverse');
        base.show();
      }
    }
    if (enableDirection.right) {
      base = $("#" + this.RIGHT_ROOT_ID);
      emt = base.find('.guide_scroll_image_mac:first');
      if (forwardDirection.right && canForward) {
        emt.removeClass('reverse').addClass('forward');
        return base.show();
      } else if (!forwardDirection.right && canReverse) {
        emt.removeClass('forward').addClass('reverse');
        return base.show();
      }
    }
  };

  ScrollGuide.hideGuide = function() {
    $("#" + this.TOP_ROOT_ID).hide();
    $("#" + this.BOTTOM_ROOT_ID).hide();
    $("#" + this.LEFT_ROOT_ID).hide();
    return $("#" + this.RIGHT_ROOT_ID).hide();
  };

  return ScrollGuide;

})(GuideBase);

//# sourceMappingURL=scroll.js.map
