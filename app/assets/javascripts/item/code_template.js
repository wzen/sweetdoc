// Generated by CoffeeScript 1.10.0
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

    Temp.prototype.createItemElement = function(item) {
      if (item instanceof CanvasItemBase) {
        return "<div id=\"" + item.id + "\" class=\"item draggable resizable\" style=\"position: absolute;top:" + item.itemSize.y + "px;left:" + item.itemSize.x + "px;width:" + item.itemSize.w + "px;height:" + item.itemSize.h + "px;z-index:" + (Common.plusPagingZindex(item.zindex)) + "\"><canvas id=\"" + (item.canvasElementId()) + "\" class=\"arrow canvas\" ></canvas></div>";
      } else if (item instanceof CssItemBase) {
        return "<div id=\"" + item.id + "\" class=\"item draggable resizable\" style=\"position: absolute;top:" + item.itemSize.y + "px;left:" + item.itemSize.x + "px;width:" + item.itemSize.w + "px;height:" + item.itemSize.h + "px;z-index:" + (Common.plusPagingZindex(item.zindex)) + "\"><div type=\"button\" class=\"css3button\"><div></div></div></div>";
      }
    };

    Temp.prototype.createGridElement = function(top, left) {
      return "<div class=\"" + WorktableSetting.Grid.SETTING_GRID_ELEMENT_CLASS + "\" style=\"position: absolute;top:" + top + "px;left:" + left + "px;width:" + WorktableSetting.Grid.GRIDVIEW_SIZE + "px;height:" + WorktableSetting.Grid.GRIDVIEW_SIZE + "px;z-index:" + (Common.plusPagingZindex(Constant.Zindex.GRID)) + "\"><canvas class=\"" + WorktableSetting.Grid.SETTING_GRID_CANVAS_CLASS + "\" class=\"canvas\" width=\"" + WorktableSetting.Grid.GRIDVIEW_SIZE + "\" height=\"" + WorktableSetting.Grid.GRIDVIEW_SIZE + "\"></canvas></div>";
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
