// Generated by CoffeeScript 1.9.2
var ItemPreviewCommon;

ItemPreviewCommon = (function() {
  function ItemPreviewCommon() {}

  ItemPreviewCommon.initMainContainerAsWorktable = function() {
    CommonVar.itemPreviewVar();
    Common.updateCanvasSize();
    $(window.drawingCanvas).css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
    window.scrollInsideWrapper.width(window.scrollViewSize);
    window.scrollInsideWrapper.height(window.scrollViewSize);
    window.scrollInsideWrapper.css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + 1));
    window.scrollContents.off('scroll');
    window.scrollContents.on('scroll', function(e) {
      var left, top;
      e.preventDefault();
      top = window.scrollContents.scrollTop();
      left = window.scrollContents.scrollLeft();
      FloatView.show(FloatView.scrollMessage(top, left), FloatView.Type.DISPLAY_POSITION);
      if (window.scrollContentsScrollTimer != null) {
        clearTimeout(window.scrollContentsScrollTimer);
      }
      return window.scrollContentsScrollTimer = setTimeout(function() {
        PageValue.setDisplayPosition(top, left);
        FloatView.hide();
        return window.scrollContentsScrollTimer = null;
      }, 500);
    });
    ItemPreviewHandwrite.initHandwrite();
    Common.applyEnvironmentFromPagevalue();
    return WorktableCommon.updateMainViewSize();
  };

  ItemPreviewCommon.initAfterLoadItem = function() {
    window.selectItemMenu = ItemPreviewTemp.ITEM_ID;
    return WorktableCommon.changeMode(Constant.Mode.DRAW);
  };

  return ItemPreviewCommon;

})();

//# sourceMappingURL=item_preview_common.js.map
