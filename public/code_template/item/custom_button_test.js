// Generated by CoffeeScript 1.9.2
var ItemXxx,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemXxx = (function(superClass) {
  var MyItem, clickEvent, cssAnimationElement, didChapter, draw, init, scrollEvent, updateEventAfter, updateEventBefore, variables, willChapter;

  extend(ItemXxx, superClass);

  function ItemXxx() {
    return ItemXxx.__super__.constructor.apply(this, arguments);
  }

  MyItem = ItemXxx;

  ItemXxx.CSSTEMPID = '';

  ItemXxx.IDENTITY = "ItemXxx";

  if (window.loadedItemId != null) {
    ItemXxx.ITEM_ID = window.loadedItemId;
  }

  ItemXxx.elementId = '';

  init = function() {};

  ItemXxx.actionProperties = function() {
    return {
      defaultMethod: 'defaultClick',
      methods: {
        defaultClick: {
          actionType: Constant.ActionType.CLICK,
          actionAnimationType: Constant.ActionAnimationType.CSS3_ANIMATION,
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
          actionType: Constant.ActionType.SCROLL,
          actionAnimationType: Constant.ActionAnimationType.JQUERY_ANIMATION,
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
            name: 'Changing color by click'
          }
        }
      }
    };
  };

  variables = {};

  updateEventBefore = function() {
    var item, methodName;
    item = $("#" + MyItem.elementId);
    this.getJQueryElement().css('opacity', 0);
    methodName = this.getEventMethodName();
    if (methodName === 'defaultClick') {
      return this.getJQueryElement().removeClass('-webkit-animation-duration').removeClass('-moz-animation-duration');
    }
  };

  updateEventAfter = function() {};

  draw = function() {};

  scrollEvent = function() {};

  clickEvent = function() {};

  cssAnimationElement = function() {};

  willChapter = function() {};

  didChapter = function() {};

  return ItemXxx;

})(CssItemBase);

if ((window.itemInitFuncList != null) && (window.itemInitFuncList[ItemXxx.ITEM_ID] == null)) {
  window.itemInitFuncList[ItemXxx.ITEM_ID] = function(option) {
    if (option == null) {
      option = {};
    }
    if (window.isWorkTable && (ItemXxx.jsLoaded != null)) {
      ItemXxx.jsLoaded(option);
    }
    if (window.debug) {
      return console.log('button loaded');
    }
  };
}

//# sourceMappingURL=custom_button_test.js.map
