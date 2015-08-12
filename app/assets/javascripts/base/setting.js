// Generated by CoffeeScript 1.9.2
var Setting;

Setting = (function() {
  var constant;

  function Setting() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    Setting.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.ROOT = 'setting';

      PageValueKey.grid = 'grid';

      return PageValueKey;

    })();
  }

  Setting.SETTING_GRID_ID = 'setting_grid';

  Setting.drawGrid = function(doDraw) {
    var color, context, emt, i, j, k, ref, ref1, ref2, ref3, ref4, ref5, results, stepx, stepy;
    color = 'black';
    stepx = 50;
    stepy = 50;
    context = document.getElementById("" + this.SETTING_GRID_ID).getContext('2d');
    if ((context != null) && doDraw === false) {
      return $("#" + this.SETTING_GRID_ID).remove();
    } else if ((context == null) && doDraw) {
      $(ElementCode.get().createGridElement()).appendTo('#scroll_inside');
      context = document.getElementById("" + this.SETTING_GRID_ID).getContext('2d');
      context.strokeStyle = color;
      context.lineWidth = 0.5;
      emt = $("#" + this.SETTING_GRID_ID);
      emt.css('z-index', Constant.Zindex.GRID);
      for (i = j = ref = stepx + 0.5, ref1 = context.canvas.width, ref2 = stepx; ref2 > 0 ? j <= ref1 : j >= ref1; i = j += ref2) {
        context.beginPath();
        context.moveTo(i, 0);
        context.lineTo(i, context.canvas.height);
        context.stroke();
      }
      results = [];
      for (i = k = ref3 = stepy + 0.5, ref4 = context.canvas.height, ref5 = stepy; ref5 > 0 ? k <= ref4 : k >= ref4; i = k += ref5) {
        context.beginPath();
        context.moveTo(0, i);
        context.lineTo(context.canvas.width, i);
        results.push(context.stroke());
      }
      return results;
    }
  };

  return Setting;

})();

//# sourceMappingURL=setting.js.map
