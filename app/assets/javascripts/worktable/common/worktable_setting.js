// Generated by CoffeeScript 1.9.2
var WorktableSetting;

WorktableSetting = (function() {
  var constant;

  function WorktableSetting() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    WorktableSetting.ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME;
  }

  WorktableSetting.initConfig = function() {
    this.Grid.initConfig();
    return this.IdleSaveTimer.initConfig();
  };

  WorktableSetting.Grid = (function() {
    function Grid() {}

    Grid.GRID_CLASS_NAME = constant.Setting.GRID_CLASS_NAME;

    Grid.GRID_STEP_CLASS_NAME = constant.Setting.GRID_STEP_CLASS_NAME;

    Grid.GRID_STEP_DIV_CLASS_NAME = constant.Setting.GRID_STEP_DIV_CLASS_NAME;

    Grid.SETTING_GRID_ELEMENT_CLASS = 'setting_grid_element';

    Grid.SETTING_GRID_CANVAS_CLASS = 'setting_grid';

    Grid.GRIDVIEW_SIZE = 10000;

    Grid.STEP_DEFAULT_VALUE = 12;

    Grid.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.GRID = "" + PageValue.Key.ST_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + constant.Setting.Key.GRID_ENABLE;

      PageValueKey.GRID_STEP = "" + PageValue.Key.ST_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + constant.Setting.Key.GRID_STEP;

      return PageValueKey;

    })();

    Grid.initConfig = function() {
      var grid, gridStep, gridStepDiv, gridStepValue, gridValue, root, self;
      root = $("#" + WorktableSetting.ROOT_ID_NAME);
      grid = $("." + this.GRID_CLASS_NAME, root);
      gridValue = PageValue.getSettingPageValue(this.PageValueKey.GRID);
      gridValue = (gridValue != null) && gridValue === 'true';
      gridStepDiv = $("." + this.GRID_STEP_DIV_CLASS_NAME, root);
      grid.prop('checked', gridValue ? 'checked' : false);
      grid.off('click');
      grid.on('click', (function(_this) {
        return function() {
          gridValue = PageValue.getSettingPageValue(_this.PageValueKey.GRID);
          if (gridValue != null) {
            gridValue = gridValue === 'true';
          }
          if (!gridValue) {
            gridStepDiv.show();
          } else {
            gridStepDiv.hide();
          }
          return _this.drawGrid(!gridValue);
        };
      })(this));
      if (gridValue) {
        gridStepDiv.show();
      } else {
        gridStepDiv.hide();
      }
      gridStepValue = PageValue.getSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID_STEP);
      if (gridStepValue == null) {
        gridStepValue = this.STEP_DEFAULT_VALUE;
      }
      gridStep = $("." + this.GRID_STEP_CLASS_NAME, root);
      gridStep.val(gridStepValue);
      self = this;
      gridStep.change(function() {
        var step, value;
        value = PageValue.getSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID);
        if (value != null) {
          value = value === 'true';
        }
        if (value) {
          step = $(this).val();
          if (step != null) {
            step = parseInt(step);
            PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID_STEP, step);
            return self.drawGrid(true);
          }
        }
      });
      return this.drawGrid(gridValue);
    };

    Grid.drawGrid = function(doDraw) {
      var canvas, context, emt, i, j, k, left, max, min, page, ref, ref1, ref2, ref3, ref4, ref5, root, step, stepInput, stepx, stepy, top;
      page = Constant.Paging.MAIN_PAGING_SECTION_CLASS.replace('@pagenum', PageValue.getPageNum());
      canvas = $("#pages ." + page + " ." + this.SETTING_GRID_CANVAS_CLASS + ":first")[0];
      context = null;
      if (canvas != null) {
        context = canvas.getContext('2d');
      }
      if ((context != null) && doDraw === false) {
        $("." + this.SETTING_GRID_ELEMENT_CLASS).remove();
        PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID, false);
        return LocalStorage.saveSettingPageValue();
      } else if (doDraw) {
        root = $("#" + WorktableSetting.ROOT_ID_NAME);
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
        if (context == null) {
          $(ElementCode.get().createGridElement(top, left)).appendTo(window.scrollInside);
          canvas = $("#pages ." + page + " ." + this.SETTING_GRID_CANVAS_CLASS + ":first")[0];
          context = canvas.getContext('2d');
        } else {
          emt = $("#pages ." + page + " ." + this.SETTING_GRID_ELEMENT_CLASS + ":first");
          emt.css({
            top: top + "px",
            left: left + "px"
          });
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
        PageValue.setSettingPageValue(WorktableSetting.Grid.PageValueKey.GRID, true);
        return LocalStorage.saveSettingPageValue();
      }
    };

    return Grid;

  })();

  WorktableSetting.IdleSaveTimer = (function() {
    function IdleSaveTimer() {}

    IdleSaveTimer.AUTOSAVE_CLASS_NAME = constant.Setting.AUTOSAVE_CLASS_NAME;

    IdleSaveTimer.AUTOSAVE_TIME_CLASS_NAME = constant.Setting.AUTOSAVE_TIME_CLASS_NAME;

    IdleSaveTimer.AUTOSAVE_TIME_DIV_CLASS_NAME = constant.Setting.AUTOSAVE_TIME_DIV_CLASS_NAME;

    IdleSaveTimer.AUTOSAVE_TIME_DEFAULT = 10;

    IdleSaveTimer.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.AUTOSAVE = "" + PageValue.Key.ST_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + constant.Setting.Key.AUTOSAVE;

      PageValueKey.AUTOSAVE_TIME = "" + PageValue.Key.ST_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + constant.Setting.Key.AUTOSAVE_TIME;

      return PageValueKey;

    })();

    IdleSaveTimer.initConfig = function() {
      var autosaveTime, autosaveTimeDiv, autosaveTimeValue, enable, enableValue, root, self;
      root = $("#" + WorktableSetting.ROOT_ID_NAME);
      enable = $("." + this.AUTOSAVE_CLASS_NAME, root);
      enableValue = PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE);
      if (enableValue == null) {
        enableValue = 'true';
        PageValue.setSettingPageValue(this.PageValueKey.AUTOSAVE, enableValue);
      }
      enableValue = (enableValue != null) && enableValue === 'true';
      autosaveTimeDiv = $("." + this.AUTOSAVE_TIME_DIV_CLASS_NAME, root);
      enable.prop('checked', enableValue ? 'checked' : false);
      enable.off('click');
      enable.on('click', (function(_this) {
        return function() {
          enableValue = PageValue.getSettingPageValue(_this.PageValueKey.AUTOSAVE);
          if (enableValue != null) {
            enableValue = enableValue === 'true';
          }
          if (!enableValue) {
            autosaveTimeDiv.show();
          } else {
            autosaveTimeDiv.hide();
          }
          return PageValue.setSettingPageValue(_this.PageValueKey.AUTOSAVE, !enableValue);
        };
      })(this));
      if (enableValue) {
        autosaveTimeDiv.show();
      } else {
        autosaveTimeDiv.hide();
      }
      autosaveTimeValue = PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE_TIME);
      if (autosaveTimeValue == null) {
        autosaveTimeValue = this.AUTOSAVE_TIME_DEFAULT;
        PageValue.setSettingPageValue(this.PageValueKey.AUTOSAVE_TIME, autosaveTimeValue);
      }
      autosaveTime = $("." + this.AUTOSAVE_TIME_CLASS_NAME, root);
      autosaveTime.val(autosaveTimeValue);
      self = this;
      return autosaveTime.change(function() {
        var step, value;
        value = PageValue.getSettingPageValue(WorktableSetting.IdleSaveTimer.PageValueKey.AUTOSAVE);
        if (value != null) {
          value = value === 'true';
        }
        if (value) {
          step = $(this).val();
          if (step != null) {
            step = parseInt(step);
            return PageValue.setSettingPageValue(WorktableSetting.IdleSaveTimer.PageValueKey.AUTOSAVE_TIME, step);
          }
        }
      });
    };

    IdleSaveTimer.isEnabled = function() {
      var enableValue;
      enableValue = PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE);
      if (enableValue != null) {
        return enableValue === 'true';
      } else {
        return false;
      }
    };

    IdleSaveTimer.idleTime = function() {
      return PageValue.getSettingPageValue(this.PageValueKey.AUTOSAVE_TIME);
    };

    return IdleSaveTimer;

  })();

  return WorktableSetting;

})();

//# sourceMappingURL=worktable_setting.js.map
