// Generated by CoffeeScript 1.9.2
var WorkTableCssItemExtend;

WorkTableCssItemExtend = {
  makeDesignConfig: function() {
    var cssConfig;
    this.designConfigRoot = $('#' + this.getDesignConfigId());
    if ((this.designConfigRoot == null) || this.designConfigRoot.length === 0) {
      this.designConfigRoot = $('#design-config .design_temp').clone(true).attr('id', this.getDesignConfigId());
      this.designConfigRoot.removeClass('design_temp');
      cssConfig = this.designConfigRoot.find('.css-config');
      this.designConfigRoot.find('.css-config').css('display', '');
      this.designConfigRoot.find('.canvas-config').remove();
      return $('#design-config').append(this.designConfigRoot);
    }
  },
  drag: function() {
    var element;
    element = $('#' + this.id);
    this.itemSize.x = element.position().left;
    return this.itemSize.y = element.position().top;
  },
  resize: function() {
    var element;
    element = $('#' + this.id);
    this.itemSize.w = element.width();
    return this.itemSize.h = element.height();
  },
  getHistoryObj: function(action) {
    var obj;
    obj = {
      obj: this,
      action: action,
      itemSize: makeClone(this.itemSize)
    };
    return obj;
  },
  setHistoryObj: function(historyObj) {
    return this.itemSize = makeClone(historyObj.itemSize);
  }
};

//# sourceMappingURL=cssitem_extend.js.map