// Generated by CoffeeScript 1.9.2
var CssCode, ElementCode;

CssCode = (function() {
  var Temp, instance;

  function CssCode() {}

  instance = null;

  Temp = (function() {
    function Temp() {}

    return Temp;

  })();

  CssCode.get = function() {
    if (instance == null) {
      instance = new Temp();
    }
    return instance;
  };

  return CssCode;

})();

ElementCode = (function() {
  var Temp, instance;

  function ElementCode() {}

  instance = null;

  Temp = (function() {
    function Temp() {}

    Temp.prototype.createItemElement = function(obj) {
      if (obj.constructor.ITEM_ID === Constant.ItemId.ARROW) {
        return "<div id=\"" + obj.id + "\" class=\"item draggable resizable\" style=\"position: absolute;top:" + obj.itemSize.y + "px;left:" + obj.itemSize.x + "px;width:" + obj.itemSize.w + "px;height:" + obj.itemSize.h + "px;z-index:" + obj.zindex + "\"><canvas id=\"" + (obj.canvasElementId()) + "\" class=\"arrow canvas\" ></canvas></div>";
      } else if (obj.constructor.ITEM_ID === Constant.ItemId.BUTTON) {
        return "<div id=\"" + obj.id + "\" class=\"item draggable resizable\" style=\"position: absolute;top:" + obj.itemSize.y + "px;left:" + obj.itemSize.x + "px;width:" + obj.itemSize.w + "px;height:" + obj.itemSize.h + "px;z-index:" + obj.zindex + "\"><div type=\"button\" class=\"css3button\"><div></div></div></div>";
      }
    };

    Temp.prototype.createGridElement = function() {
      return "<canvas id=\"" + Setting.SETTING_GRID_CANVAS_ID + "\" class=\"canvas\"></canvas>";
    };

    return Temp;

  })();

  ElementCode.get = function() {
    if (instance == null) {
      instance = new Temp();
    }
    return instance;
  };

  return ElementCode;

})();

//# sourceMappingURL=code_template.js.map
