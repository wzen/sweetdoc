// Generated by CoffeeScript 1.9.2
var ItemPreviewHandwrite,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

ItemPreviewHandwrite = (function(superClass) {
  extend(ItemPreviewHandwrite, superClass);

  function ItemPreviewHandwrite() {
    return ItemPreviewHandwrite.__super__.constructor.apply(this, arguments);
  }

  ItemPreviewHandwrite.mouseUpDrawing = function() {
    if (window.handwritingItem != null) {
      if (window.scrollInside.find('.item').length === 0) {
        window.handwritingItem.restoreAllDrawingSurface();
        window.handwritingItem.endDraw(this.zindex, true, (function(_this) {
          return function() {
            window.handwritingItem.setupItemEvents();
            window.handwritingItem.saveObj(true);
            _this.zindex += 1;
            Sidebar.initItemEditConfig(window.handwritingItem);
            ItemPreviewEventConfig.addEventConfigContents(window.handwritingItem.classDistToken);
            Sidebar.initEventConfig(Common.generateId());
            return window.handwritingItem = null;
          };
        })(this));
      }
    }
    return WorktableCommon.changeMode(constant.Mode.EDIT);
  };

  return ItemPreviewHandwrite;

})(Handwrite);

//# sourceMappingURL=item_preview_handwrite.js.map