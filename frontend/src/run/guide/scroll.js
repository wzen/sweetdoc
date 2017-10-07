/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var ScrollGuide = (function() {
  let constant = undefined;
  ScrollGuide = class ScrollGuide extends GuideBase {
    static initClass() {
      // 定数
      constant = gon.const;
      this.TOP_ROOT_ID = constant.RunGuide.TOP_ROOT_ID;
      this.BOTTOM_ROOT_ID = constant.RunGuide.BOTTOM_ROOT_ID;
      this.LEFT_ROOT_ID = constant.RunGuide.LEFT_ROOT_ID;
      this.RIGHT_ROOT_ID = constant.RunGuide.RIGHT_ROOT_ID;
    }

    // ガイド表示
    static showGuide(enableDirection, forwardDirection, canForward, canReverse) {
      let base, emt;
      this.hideGuide();
      if(enableDirection.top) {
        base = $(`#${this.TOP_ROOT_ID}`);
        emt = base.find('.guide_scroll_image_mac:first');
        if(forwardDirection.top && canForward) {
          emt.removeClass('reverse').addClass('forward');
          base.show();
        } else if(!forwardDirection.top && canReverse) {
          emt.removeClass('forward').addClass('reverse');
          base.show();
        }
      }
      if(enableDirection.bottom) {
        base = $(`#${this.BOTTOM_ROOT_ID}`);
        emt = base.find('.guide_scroll_image_mac:first');
        if(forwardDirection.bottom && canForward) {
          emt.removeClass('reverse').addClass('forward');
          base.show();
        } else if(!forwardDirection.bottom && canReverse) {
          emt.removeClass('forward').addClass('reverse');
          base.show();
        }
      }
      if(enableDirection.left) {
        base = $(`#${this.LEFT_ROOT_ID}`);
        emt = base.find('.guide_scroll_image_mac:first');
        if(forwardDirection.left && canForward) {
          emt.removeClass('reverse').addClass('forward');
          base.show();
        } else if(!forwardDirection.left && canReverse) {
          emt.removeClass('forward').addClass('reverse');
          base.show();
        }
      }
      if(enableDirection.right) {
        base = $(`#${this.RIGHT_ROOT_ID}`);
        emt = base.find('.guide_scroll_image_mac:first');
        if(forwardDirection.right && canForward) {
          emt.removeClass('reverse').addClass('forward');
          return base.show();
        } else if(!forwardDirection.right && canReverse) {
          emt.removeClass('forward').addClass('reverse');
          return base.show();
        }
      }
    }

    // ガイド非表示
    static hideGuide() {
      $(`#${this.TOP_ROOT_ID}`).hide();
      $(`#${this.BOTTOM_ROOT_ID}`).hide();
      $(`#${this.LEFT_ROOT_ID}`).hide();
      return $(`#${this.RIGHT_ROOT_ID}`).hide();
    }
  };
  ScrollGuide.initClass();
  return ScrollGuide;
})();
