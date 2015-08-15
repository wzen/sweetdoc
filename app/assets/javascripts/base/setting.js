// Generated by CoffeeScript 1.9.2
var Setting;

Setting = (function() {
  var constant;

  function Setting() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    Setting.ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME;
    Setting.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.ROOT = constant.PageValueKey.ST_ROOT;

      PageValueKey.PREFIX = constant.PageValueKey.ST_PREFIX;

      return PageValueKey;

    })();
  }

  Setting.initConfig = function() {
    return this.Grid.initConfig();
  };

  Setting.Grid = (function() {
    function Grid() {}

    Grid.GRID_CLASS_NAME = constant.Setting.GRID_CLASS_NAME;

    Grid.GRID_STEP_CLASS_NAME = constant.Setting.GRID_STEP_CLASS_NAME;

    Grid.GRID_STEP_DIV_CLASS_NAME = constant.Setting.GRID_STEP_DIV_CLASS_NAME;

    Grid.SETTING_GRID_ELEMENT_ID = 'setting_grid_element';

    Grid.SETTING_GRID_CANVAS_ID = 'setting_grid';

    Grid.GRIDVIEW_SIZE = 10000;

    Grid.STEP_DEFAULT_VALUE = 12;

    Grid.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.GRID = 'grid';

      PageValueKey.GRID_STEP = 'grid_step';

      return PageValueKey;

    })();

    Grid.initConfig = function() {
      var grid, gridStep, gridStepDiv, gridStepValue, gridValue, key, root;
      root = $("#" + Setting.ROOT_ID_NAME);
      grid = $("." + this.GRID_CLASS_NAME, root);
      key = "" + Setting.PageValueKey.PREFIX + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + this.PageValueKey.GRID;
      gridValue = PageValue.getSettingPageValue(key);
      gridStep = $("." + this.GRID_STEP_CLASS_NAME, root);
      key = "" + Setting.PageValueKey.PREFIX + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + this.PageValueKey.GRID_STEP;
      gridStepValue = PageValue.getSettingPageValue(key);
      gridStepDiv = $("." + this.GRID_STEP_DIV_CLASS_NAME, root);
      grid.prop('clicked', gridValue);
      grid.off('click');
      grid.on('click', (function(_this) {
        return function() {
          key = "" + Setting.PageValueKey.PREFIX + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + _this.PageValueKey.GRID;
          gridValue = PageValue.getSettingPageValue(key);
          if (gridValue != null) {
            gridValue = gridValue === 'true';
          }
          if (!gridValue) {
            gridStepDiv.css('display', '');
          } else {
            gridStepDiv.css('display', 'none');
          }
          return _this.drawGrid(!gridValue);
        };
      })(this));
      if (gridValue) {
        gridStepDiv.css('display', '');
      } else {
        gridStepDiv.css('display', 'none');
      }
      if (gridStepValue == null) {
        gridStepValue = this.STEP_DEFAULT_VALUE;
      }
      $("." + this.GRID_STEP_CLASS_NAME, root).val(gridStepValue);
      return gridStep.change((function(_this) {
        return function() {
          var value;
          key = "" + Setting.PageValueKey.PREFIX + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + _this.PageValueKey.GRID;
          value = PageValue.getSettingPageValue(key);
          if (value != null) {
            value = value === 'true';
          }
          if (value) {
            return _this.drawGrid(true);
          }
        };
      })(this));
    };

    Grid.drawGrid = function(doDraw) {
      var canvas, context, i, j, k, key, left, max, min, ref, ref1, ref2, ref3, ref4, ref5, root, step, stepInput, stepx, stepy, top;
      canvas = document.getElementById("" + this.SETTING_GRID_CANVAS_ID);
      context = null;
      key = "" + Setting.PageValueKey.PREFIX + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + this.PageValueKey.GRID;
      if (canvas != null) {
        context = canvas.getContext('2d');
      }
      if ((context != null) && doDraw === false) {
        $("#" + this.SETTING_GRID_ELEMENT_ID).remove();
        return PageValue.setSettingPageValue(key, false);
      } else if (doDraw) {
        root = $("#" + Setting.ROOT_ID_NAME);
        stepInput = $("." + this.GRID_STEP_CLASS_NAME, root);
        step = stepInput.val();
        step = parseInt(step);
        min = parseInt(stepInput.attr('min'));
        max = parseInt(stepInput.attr('max'));
        if (step < min || step > max) {
          return;
        }
        stepx = step;
        stepy = step;
        if (context == null) {
          top = window.scrollContents.scrollTop() - this.GRIDVIEW_SIZE * 0.5;
          top -= top % stepy;
          if (top < 0) {
            top = 0;
          }
          left = window.scrollContents.scrollLeft() - this.GRIDVIEW_SIZE * 0.5;
          left -= left % stepx;
          if (left < 0) {
            left = 0;
          }
          $(ElementCode.get().createGridElement(top, left)).appendTo('#scroll_inside');
          context = document.getElementById("" + this.SETTING_GRID_CANVAS_ID).getContext('2d');
        } else {
          context.clearRect(0, 0, canvas.width, canvas.height);
        }
        context.strokeStyle = 'black';
        context.lineWidth = 0.5;
        for (i = j = ref = stepx + 0.5, ref1 = context.canvas.width, ref2 = stepx; ref2 > 0 ? j <= ref1 : j >= ref1; i = j += ref2) {
          context.beginPath();
          context.moveTo(i, 0);
          context.lineTo(i, context.canvas.height);
          context.stroke();
        }
        for (i = k = ref3 = stepy + 0.5, ref4 = context.canvas.height, ref5 = stepy; ref5 > 0 ? k <= ref4 : k >= ref4; i = k += ref5) {
          context.beginPath();
          context.moveTo(0, i);
          context.lineTo(context.canvas.width, i);
          context.stroke();
        }
        return PageValue.setSettingPageValue(key, true);
      }
    };

    return Grid;

  })();

  return Setting;

})();

//# sourceMappingURL=setting.js.map
