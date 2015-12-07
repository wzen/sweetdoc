// Generated by CoffeeScript 1.9.2
var ItemPreviewTemp,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemPreviewTemp = (function(superClass) {
  extend(ItemPreviewTemp, superClass);

  function ItemPreviewTemp() {
    return ItemPreviewTemp.__super__.constructor.apply(this, arguments);
  }

  ItemPreviewTemp.IDENTITY = "ItemPreviewTemp";

  ItemPreviewTemp.ITEM_ACCESS_TOKEN = 'default';

  if (window.loadedItemToken != null) {
    ItemPreviewTemp.ITEM_ACCESS_TOKEN = window.loadedItemToken;
  }

  ItemPreviewTemp.actionProperties = {
    defaultMethod: 'defaultClick',
    designConfig: true,
    designConfigDefaultValues: {
      values: {
        design_slider_font_size_value: 14,
        design_font_color_value: 'ffffff',
        design_slider_padding_top_value: 10,
        design_slider_padding_left_value: 20,
        design_slider_gradient_deg_value: 0,
        design_slider_gradient_deg_value_webkit_value: 'left top, left bottom',
        design_bg_color1_value: 'ffbdf5',
        design_bg_color2_value: 'ff82ec',
        design_bg_color2_position_value: 25,
        design_bg_color3_value: 'fc46e1',
        design_bg_color3_position_value: 50,
        design_bg_color4_value: 'fc46e1',
        design_bg_color4_position_value: 75,
        design_bg_color5_value: 'fc46e1',
        design_border_color_value: 'ffffff',
        design_slider_border_radius_value: 30,
        design_slider_border_width_value: 3,
        design_slider_shadow_left_value: 0,
        design_slider_shadow_top_value: 3,
        design_slider_shadow_size_value: 11,
        design_shadow_color_value: '000,000,000',
        design_slider_shadow_opacity_value: 0.5,
        design_slider_shadowinset_left_value: 0,
        design_slider_shadowinset_top_value: 0,
        design_slider_shadowinset_size_value: 1,
        design_shadowinset_color_value: '255,000,217',
        design_slider_shadowinset_opacity_value: 1,
        design_slider_text_shadow1_left_value: 0,
        design_slider_text_shadow1_top_value: -1,
        design_slider_text_shadow1_size_value: 0,
        design_text_shadow1_color_value: '000,000,000',
        design_slider_text_shadow1_opacity_value: 0.2,
        design_slider_text_shadow2_left_value: 0,
        design_slider_text_shadow2_top_value: 1,
        design_slider_text_shadow2_size_value: 0,
        design_text_shadow2_color_value: '255,255,255',
        design_slider_text_shadow2_opacity_value: 0.3
      },
      flags: {
        design_bg_color2_moz_flag: false,
        design_bg_color2_webkit_flag: false,
        design_bg_color3_moz_flag: false,
        design_bg_color3_webkit_flag: false,
        design_bg_color4_moz_flag: false,
        design_bg_color4_webkit_flag: false
      }
    },
    modifiables: {
      backgroundColor: {
        name: "Background Color",
        "default": 'ffffff',
        type: 'color',
        ja: {
          name: "背景色"
        }
      }
    },
    methods: {
      defaultClick: {
        actionType: 'click',
        isDrawByAnimation: true,
        eventDuration: 0.5,
        options: {
          id: 'defaultClick',
          name: 'Default click action',
          desc: "Click push action",
          ja: {
            name: '通常クリック',
            desc: 'デフォルトのボタンクリック'
          }
        }
      },
      changeColorScroll: {
        actionType: 'scroll',
        scrollEnabledDirection: {
          top: true,
          bottom: true,
          left: false,
          right: false
        },
        scrollForwardDirection: {
          top: false,
          bottom: true,
          left: false,
          right: false
        },
        options: {
          id: 'changeColorScroll_Design',
          name: 'Changing color by scroll'
        },
        modifiables: {
          backgroundColor: {
            name: "Background Color",
            type: 'color',
            varAutoChange: true,
            ja: {
              name: "背景色"
            }
          }
        }
      },
      changeColorClick: {
        actionType: 'click',
        eventDuration: 0.5,
        options: {
          id: 'changeColorClick_Design',
          name: 'Changing color by click',
          ja: {
            name: 'クリックで色変更'
          }
        },
        modifiables: {
          backgroundColor: {
            name: "Background Color",
            type: 'color',
            varAutoChange: true,
            ja: {
              name: "背景色"
            }
          }
        }
      }
    }
  };

  ItemPreviewTemp.prototype.reDraw = function(show) {
    if (show == null) {
      show = true;
    }
    return ItemPreviewTemp.__super__.reDraw.call(this, show);
  };

  ItemPreviewTemp.prototype.updateEventBefore = function() {
    var methodName;
    ItemPreviewTemp.__super__.updateEventBefore.call(this);
    this.getJQueryElement().css('opacity', 0);
    methodName = this.getEventMethodName();
    if (methodName === 'defaultClick') {
      return this.getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration');
    } else if (methodName === 'changeColorClick' || methodName === 'changeColorScroll') {
      return this.backgroundColor = 'ffffff';
    }
  };

  ItemPreviewTemp.prototype.updateEventAfter = function() {
    var methodName;
    ItemPreviewTemp.__super__.updateEventAfter.call(this);
    this.getJQueryElement().css('opacity', 1);
    methodName = this.getEventMethodName();
    if (methodName === 'defaultClick') {
      return this.getJQueryElement().css({
        '-webkit-animation-duration': '0',
        '-moz-animation-duration': '-moz-animation-duration',
        '0': '0'
      });
    }
  };

  ItemPreviewTemp.prototype.defaultClick = function(opt) {
    this.getJQueryElement().find('.css_item:first').addClass('defaultClick_' + this.id);
    this.getJQueryElement().off('webkitAnimationEnd animationend');
    return this.getJQueryElement().on('webkitAnimationEnd animationend', (function(_this) {
      return function(e) {
        _this.getJQueryElement().find('.css_item:first').removeClass('defaultClick_' + _this.id);
        if (opt.complete != null) {
          return opt.complete();
        }
      };
    })(this));
  };

  ItemPreviewTemp.prototype.changeColorScroll = function(opt) {
    this.getJQueryElement().find('.css3button').css('background', "#" + this.backgroundColor);
    if (opt.complete != null) {
      return opt.complete();
    }
  };

  ItemPreviewTemp.prototype.changeColorClick = function(opt) {
    this.getJQueryElement().find('.css3button').css('background', "#" + this.backgroundColor);
    if (opt.complete != null) {
      return opt.complete();
    }
  };

  ItemPreviewTemp.prototype.cssAnimationKeyframe = function() {
    var emt, funcName, height, keyFrameName, keyframe, left, methodName, top, width;
    methodName = this.getEventMethodName();
    funcName = methodName + "_" + this.id;
    keyFrameName = this.id + "_frame";
    emt = this.getJQueryElement().find('.css_item:first');
    top = emt.css('top');
    left = emt.css('left');
    width = emt.css('width');
    height = emt.css('height');
    keyframe = keyFrameName + " {\n  0% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n  40% {\n    top: " + (parseInt(top) + 10) + "px;\n    left: " + (parseInt(left) + 10) + "px;\n    width: " + (parseInt(width) - 20) + "px;\n    height: " + (parseInt(height) - 20) + "px;\n  }\n  80% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n  90% {\n    top: " + (parseInt(top) + 5) + "px;\n    left: " + (parseInt(left) + 5) + "px;\n    width: " + (parseInt(width) - 10) + "px;\n    height: " + (parseInt(height) - 10) + "px;\n  }\n  100% {\n    top: " + (parseInt(top)) + "px;\n    left: " + (parseInt(left)) + "px;\n    width: " + (parseInt(width)) + "px;\n    height: " + (parseInt(height)) + "px;\n  }\n}";
    return keyframe;
  };

  ItemPreviewTemp.prototype.willChapter = function() {
    ItemPreviewTemp.__super__.willChapter.call(this);
    if (this.getEventMethodName() === 'defaultClick') {
      return this.getJQueryElement().css('opacity', 1);
    } else if (this.getEventMethodName() === 'changeColorClick' || this.getEventMethodName() === 'changeColorScroll') {
      return this.getJQueryElement().css('opacity', 1);
    }
  };

  return ItemPreviewTemp;

})(CssItemBase);

Common.setClassToMap(false, ItemPreviewTemp.ITEM_ACCESS_TOKEN, ItemPreviewTemp);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[ItemPreviewTemp.ITEM_ACCESS_TOKEN] == null)) {
  console.log('ItemPreviewTemp loaded');
  window.itemInitFuncList[ItemPreviewTemp.ITEM_ACCESS_TOKEN] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.isWorkTable && (ItemPreviewTemp.jsLoaded != null)) {
      ItemPreviewTemp.jsLoaded(option);
    }
    if (window.debug) {
      return console.log('ItemPreviewTemp init finished');
    }
  };
}

//# sourceMappingURL=coffeescript_css.js.map
