// Generated by CoffeeScript 1.9.2
var WorkTableCommonExtend;

WorkTableCommonExtend = {
  startDraw: function() {},
  draw: function(cood) {},
  endDraw: function(zindex, show) {
    if (show == null) {
      show = true;
    }
  },
  showOptionMenu: function() {
    var sc;
    sc = $('.sidebar-config');
    sc.css('display', 'none');
    $('.dc', sc).css('display', 'none');
    $('#design-config').css('display', '');
    return $('#' + this.getDesignConfigId()).css('display', '');
  }
};

//# sourceMappingURL=common_extend.js.map