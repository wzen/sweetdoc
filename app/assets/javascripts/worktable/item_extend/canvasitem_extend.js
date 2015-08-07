// Generated by CoffeeScript 1.9.2
var WorkTableCanvasItemExtend;

WorkTableCanvasItemExtend = {
  makeDesignConfig: function() {
    this.designConfigRoot = $('#' + this.getDesignConfigId());
    if ((this.designConfigRoot == null) || this.designConfigRoot.length === 0) {
      this.designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', this.getDesignConfigId());
      this.designConfigRoot.removeClass('design_temp');
      this.designConfigRoot.find('.canvas-config').css('display', '');
      this.designConfigRoot.find('.css-config').remove();
      return $('#design-config').append(this.designConfigRoot);
    }
  },
  drag: function() {
    var element;
    element = $('#' + this.id);
    this.itemSize.x = element.position().left;
    this.itemSize.y = element.position().top;
    return console.log("drag: itemSize: " + (JSON.stringify(this.itemSize)));
  },
  dragComplete: function() {
    this.saveObj(Constant.ItemActionType.MOVE);
    return TLEItemChange.writeItemValueToPageValue(this);
  },
  resize: function() {
    var canvas, drawingCanvas, drawingContext, element;
    canvas = $('#' + this.canvasElementId());
    element = $('#' + this.id);
    this.scale.w = element.width() / this.itemSize.w;
    this.scale.h = element.height() / this.itemSize.h;
    canvas.attr('width', element.width());
    canvas.attr('height', element.height());
    drawingCanvas = document.getElementById(this.canvasElementId());
    drawingContext = drawingCanvas.getContext('2d');
    drawingContext.scale(this.scale.w, this.scale.h);
    this.drawNewCanvas();
    return console.log("resize: itemSize: " + (JSON.stringify(this.itemSize)));
  },
  resizeComplete: function() {
    this.saveObj(Constant.ItemActionType.MOVE);
    return TLEItemChange.writeItemValueToPageValue(this);
  },
  getHistoryObj: function(action) {
    var obj;
    obj = {
      obj: this,
      action: action,
      itemSize: makeClone(this.itemSize),
      scale: makeClone(this.scale)
    };
    console.log("getHistory: scale:" + this.scale.w + "," + this.scale.h);
    return obj;
  },
  setHistoryObj: function(historyObj) {
    this.itemSize = makeClone(historyObj.itemSize);
    this.scale = makeClone(historyObj.scale);
    return console.log("setHistoryObj: itemSize: " + (JSON.stringify(this.itemSize)));
  }
};

//# sourceMappingURL=canvasitem_extend.js.map
