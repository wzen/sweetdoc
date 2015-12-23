// Generated by CoffeeScript 1.9.2
var itemBaseWorktableExtend;

itemBaseWorktableExtend = {
  getDesignConfigId: function() {
    return this.constructor.DESIGN_CONFIG_ROOT_ID.replace('@id', this.id);
  },
  mouseDownDrawing: function(callback) {
    if (callback == null) {
      callback = null;
    }
    this.saveDrawingSurface();
    WorktableCommon.changeMode(Constant.Mode.DRAW);
    this.startDraw();
    if (callback != null) {
      return callback();
    }
  },
  mouseUpDrawing: function(zindex, callback) {
    if (callback == null) {
      callback = null;
    }
    this.restoreAllDrawingSurface();
    return this.endDraw(zindex, true, (function(_this) {
      return function() {
        _this.setupDragAndResizeEvents();
        WorktableCommon.changeMode(Constant.Mode.DRAW);
        _this.saveObj(true);
        _this.firstFocus = Common.firstFocusItemObj() === null;
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  },
  startDraw: function() {},
  draw: function(cood) {
    if (this.itemSize !== null) {
      this.restoreDrawingSurface(this.itemSize);
    }
    this.itemSize = {
      x: null,
      y: null,
      w: null,
      h: null
    };
    this.itemSize.w = Math.abs(cood.x - this._moveLoc.x);
    this.itemSize.h = Math.abs(cood.y - this._moveLoc.y);
    if (cood.x > this._moveLoc.x) {
      this.itemSize.x = this._moveLoc.x;
    } else {
      this.itemSize.x = cood.x;
    }
    if (cood.y > this._moveLoc.y) {
      this.itemSize.y = this._moveLoc.y;
    } else {
      this.itemSize.y = cood.y;
    }
    return drawingContext.strokeRect(this.itemSize.x, this.itemSize.y, this.itemSize.w, this.itemSize.h);
  },
  endDraw: function(zindex, show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    this.zindex = zindex;
    this.itemSize.x += scrollContents.scrollLeft();
    this.itemSize.y += scrollContents.scrollTop();
    return this.createItemElement((function(_this) {
      return function(createdElement) {
        _this.itemDraw(show);
        if (_this.setupDragAndResizeEvents != null) {
          _this.setupDragAndResizeEvents();
        }
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  },
  changeMode: function(changeMode) {},
  drawAndMakeConfigsAndWritePageValue: function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('ItemBase drawAndMakeConfigsAndWritePageValue');
    }
    return this.drawAndMakeConfigs(show, (function(_this) {
      return function() {
        var blank, distId, teNum;
        if (_this.constructor.defaultMethodName() != null) {
          blank = $('#timeline_events > .timeline_event.blank:first');
          teNum = blank.find('.te_num').val();
          distId = blank.find('.dist_id').val();
          EPVItem.writeDefaultToPageValue(_this, teNum, distId);
          Timeline.refreshAllTimeline();
        }
        if (callback != null) {
          return callback();
        }
      };
    })(this));
  },
  drawAndMakeConfigs: function(show, callback) {
    if (show == null) {
      show = true;
    }
    if (callback == null) {
      callback = null;
    }
    if (window.runDebug) {
      console.log('ItemBase drawAndMakeConfigs');
    }
    this.reDraw(show);
    return ConfigMenu.getDesignConfig(this, function() {
      if (callback != null) {
        return callback();
      }
    });
  },
  showOptionMenu: function() {
    var sc;
    sc = $('.sidebar-config');
    sc.hide();
    $("." + Constant.DesignConfig.DESIGN_ROOT_CLASSNAME, sc).hide();
    $('#design-config').show();
    return $('#' + this.getDesignConfigId()).show();
  },
  setupDragAndResizeEvents: function() {
    var self;
    self = this;
    (function() {
      var contextSelector, menu;
      menu = [];
      contextSelector = ".context_base";
      menu.push({
        title: "Edit",
        cmd: "edit",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          return Sidebar.openItemEditConfig(event.target);
        }
      });
      menu.push({
        title: I18n.t('context_menu.copy'),
        cmd: "copy",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          WorktableCommon.copyItem();
          return WorktableCommon.setMainContainerContext();
        }
      });
      menu.push({
        title: I18n.t('context_menu.cut'),
        cmd: "cut",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          WorktableCommon.cutItem();
          return WorktableCommon.setMainContainerContext();
        }
      });
      menu.push({
        title: I18n.t('context_menu.float'),
        cmd: "float",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          var objId;
          objId = $(event.target).attr('id');
          WorktableCommon.floatItem(objId);
          LocalStorage.saveAllPageValues();
          return OperationHistory.add();
        }
      });
      menu.push({
        title: I18n.t('context_menu.rear'),
        cmd: "rear",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          var objId;
          objId = $(event.target).attr('id');
          WorktableCommon.rearItem(objId);
          LocalStorage.saveAllPageValues();
          return OperationHistory.add();
        }
      });
      menu.push({
        title: I18n.t('context_menu.delete'),
        cmd: "delete",
        uiIcon: "ui-icon-scissors",
        func: function(event, ui) {
          if (window.confirm(I18n.t('message.dialog.delete_item'))) {
            return WorktableCommon.removeSingleItem(event.target);
          }
        }
      });
      return WorktableCommon.setupContextMenu(self.getJQueryElement(), contextSelector, menu);
    })();
    (function() {
      return self.getJQueryElement().mousedown(function(e) {
        if (e.which === 1) {
          e.stopPropagation();
          WorktableCommon.clearSelectedBorder();
          return WorktableCommon.setSelectedBorder(this, "edit");
        }
      });
    })();
    return (function() {
      self.getJQueryElement().draggable({
        containment: scrollInside,
        drag: function(event, ui) {
          if (self.drag != null) {
            return self.drag();
          }
        },
        stop: function(event, ui) {
          if (self.dragComplete != null) {
            return self.dragComplete();
          }
        }
      });
      return self.getJQueryElement().resizable({
        containment: scrollInside,
        resize: function(event, ui) {
          if (self.resize != null) {
            return self.resize();
          }
        },
        stop: function(event, ui) {
          if (self.resizeComplete != null) {
            return self.resizeComplete();
          }
        }
      });
    })();
  },
  drag: function() {
    var element;
    element = $('#' + this.id);
    this.updateItemPosition(element.position().left, element.position().top);
    if (window.debug) {
      return console.log("drag: itemSize: " + (JSON.stringify(this.itemSize)));
    }
  },
  resize: function() {
    var element;
    element = $('#' + this.id);
    return this.updateItemSize(element.width(), element.height());
  },
  dragComplete: function() {
    return this.saveObj();
  },
  resizeComplete: function() {
    return this.saveObj();
  },
  setupOptionMenu: function() {
    return ConfigMenu.getDesignConfig(this, (function(_this) {
      return function(designConfigRoot) {
        var _existFocusSetItem, focusEmt, h, name, visibleEmt, w, x, y;
        name = $('.item-name', designConfigRoot);
        name.val(_this.name);
        name.off('change').on('change', function() {
          _this.name = $(_this).val();
          return _this.setItemPropToPageValue('name', _this.name);
        });
        _existFocusSetItem = function() {
          var focusExist, j, len, obj, objs;
          objs = Common.itemInstancesInPage();
          focusExist = false;
          for (j = 0, len = objs.length; j < len; j++) {
            obj = objs[j];
            if ((obj.firstFocus != null) && obj.firstFocus) {
              focusExist = true;
            }
          }
          return focusExist;
        };
        focusEmt = $('.focus_at_launch', designConfigRoot);
        if (_this.firstFocus) {
          focusEmt.prop('checked', true);
        } else {
          focusEmt.removeAttr('checked');
        }
        if (!_this.firstFocus && _existFocusSetItem.call(_this)) {
          focusEmt.removeAttr('checked');
          focusEmt.attr('disabled', true);
        } else {
          focusEmt.removeAttr('disabled');
        }
        focusEmt.off('change').on('change', function(e) {
          _this.firstFocus = $(e.target).prop('checked');
          return _this.saveObj();
        });
        visibleEmt = $('.visible_at_launch', designConfigRoot);
        if (_this.visible) {
          visibleEmt.prop('checked', true);
        } else {
          visibleEmt.removeAttr('checked');
          focusEmt.removeAttr('checked');
          focusEmt.attr('disabled', true);
        }
        visibleEmt.off('change').on('change', function(e) {
          _this.visible = $(e.target).prop('checked');
          if (_this.visible && !_existFocusSetItem.call(_this)) {
            focusEmt.removeAttr('disabled');
          } else {
            focusEmt.removeAttr('checked');
            focusEmt.attr('disabled', true);
          }
          focusEmt.trigger('change');
          return _this.saveObj();
        });
        x = _this.getJQueryElement().position().left;
        y = _this.getJQueryElement().position().top;
        w = _this.getJQueryElement().width();
        h = _this.getJQueryElement().height();
        $('.item_position_x:first', designConfigRoot).val(x);
        $('.item_position_y:first', designConfigRoot).val(y);
        $('.item_width:first', designConfigRoot).val(w);
        $('.item_height:first', designConfigRoot).val(h);
        $('.item_position_x:first, .item_position_y:first, .item_width:first, .item_height:first', designConfigRoot).off('change').on('change', function() {
          var itemSize;
          itemSize = {
            x: parseInt($('.item_position_x:first', designConfigRoot).val()),
            y: parseInt($('.item_position_y:first', designConfigRoot).val()),
            w: parseInt($('.item_width:first', designConfigRoot).val()),
            h: parseInt($('.item_height:first', designConfigRoot).val())
          };
          return _this.updatePositionAndItemSize(itemSize);
        });
        if ((_this.constructor.actionProperties.designConfig != null) && _this.constructor.actionProperties.designConfig) {
          _this.setupDesignToolOptionMenu();
        }
        return _this.settingModifiableChangeEvent();
      };
    })(this));
  },
  settingDesignSlider: function(className, min, max, stepValue) {
    var defaultValue, designConfigRoot, meterElement, valueElement;
    if (stepValue == null) {
      stepValue = 1;
    }
    designConfigRoot = $('#' + this.getDesignConfigId());
    meterElement = $("." + className, designConfigRoot);
    valueElement = meterElement.prev('input:first');
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(this.id, className + "_value"));
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    try {
      meterElement.slider('destroy');
    } catch (_error) {

    }
    return meterElement.slider({
      min: min,
      max: max,
      step: stepValue,
      value: defaultValue,
      slide: (function(_this) {
        return function(event, ui) {
          var classNames, n;
          valueElement.val(ui.value);
          valueElement.html(ui.value);
          classNames = $(event.target).attr('class').split(' ');
          n = $.grep(classNames, function(s) {
            return s.indexOf('design_') >= 0;
          })[0];
          _this.designs.values[n + "_value"] = ui.value;
          return _this.applyDesignStyleChange(n, ui.value);
        };
      })(this)
    });
  },
  settingGradientSliderByElement: function(element, values) {
    var handleElement;
    try {
      element.slider('destroy');
    } catch (_error) {

    }
    element.slider({
      min: 1,
      max: 99,
      values: values,
      slide: (function(_this) {
        return function(event, ui) {
          var classNames, index, n;
          index = $(ui.handle).index();
          classNames = $(event.target).attr('class').split(' ');
          n = $.grep(classNames, function(s) {
            return s.indexOf('design_') >= 0;
          })[0];
          _this.designs.values["design_bg_color" + (index + 2) + "_position_value"] = ("0" + ui.value).slice(-2);
          return _this.applyGradientStyleChange(index, n, ui.value);
        };
      })(this)
    });
    handleElement = element.children('.ui-slider-handle');
    if (values === null) {
      return handleElement.hide();
    } else {
      return handleElement.show();
    }
  },
  settingGradientSlider: function(className, values) {
    var designConfigRoot, meterElement;
    designConfigRoot = $('#' + this.getDesignConfigId());
    meterElement = $("." + className, designConfigRoot);
    return this.settingGradientSliderByElement(meterElement, values);
  },
  settingGradientDegSlider: function(className, min, max, each45Degrees) {
    var defaultValue, designConfigRoot, meterElement, step, valueElement;
    if (each45Degrees == null) {
      each45Degrees = true;
    }
    designConfigRoot = $('#' + this.getDesignConfigId());
    meterElement = $('.' + className, designConfigRoot);
    valueElement = $('.' + className + '_value', designConfigRoot);
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceDesign(this.id, className + "_value"));
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    step = 1;
    if (each45Degrees) {
      step = 45;
    }
    try {
      meterElement.slider('destroy');
    } catch (_error) {

    }
    return meterElement.slider({
      min: min,
      max: max,
      step: step,
      value: defaultValue,
      slide: (function(_this) {
        return function(event, ui) {
          var classNames, n;
          valueElement.val(ui.value);
          valueElement.html(ui.value);
          classNames = $(event.target).attr('class').split(' ');
          n = $.grep(classNames, function(s) {
            return s.indexOf('design_') >= 0;
          })[0];
          _this.designs.values[n + "_value"] = ui.value;
          return _this.applyGradientDegChange(n, ui.value);
        };
      })(this)
    });
  },
  changeGradientShow: function(targetElement) {
    var designConfigRoot, meterElement, value, values;
    designConfigRoot = $('#' + this.getDesignConfigId());
    value = parseInt(targetElement.value);
    if (value >= 2 && value <= 5) {
      meterElement = $(targetElement).siblings('.ui-slider:first');
      values = null;
      if (value === 3) {
        values = [50];
      } else if (value === 4) {
        values = [30, 70];
      } else if (value === 5) {
        values = [25, 50, 75];
      }
      this.settingGradientSliderByElement(meterElement, values);
      return this.switchGradientColorSelectorVisible(value, designConfigRoot);
    }
  },
  switchGradientColorSelectorVisible: function(gradientStepValue) {
    var designConfigRoot, element, i, j, results;
    designConfigRoot = $('#' + this.getDesignConfigId());
    results = [];
    for (i = j = 2; j <= 4; i = ++j) {
      element = $('.design_bg_color' + i, designConfigRoot);
      if (i > gradientStepValue - 1) {
        results.push(element.hide());
      } else {
        results.push(element.show());
      }
    }
    return results;
  },
  saveDesign: function() {
    if (this.saveDesignReflectTimer != null) {
      clearTimeout(this.saveDesignReflectTimer);
      this.saveDesignReflectTimer = null;
    }
    return this.saveDesignReflectTimer = setTimeout((function(_this) {
      return function() {
        _this.setItemAllPropToPageValue();
        LocalStorage.saveAllPageValues();
        return _this.saveDesignReflectTimer = setTimeout(function() {
          return OperationHistory.add();
        }, 1000);
      };
    })(this), 500);
  },
  settingModifiableChangeEvent: function() {
    var designConfigRoot, ref, results, value, varName;
    designConfigRoot = $('#' + this.getDesignConfigId());
    if (this.constructor.actionProperties[this.constructor.ActionPropertiesKey.MODIFIABLE_VARS] != null) {
      ref = this.constructor.actionProperties[this.constructor.ActionPropertiesKey.MODIFIABLE_VARS];
      results = [];
      for (varName in ref) {
        value = ref[varName];
        if (value.type === Constant.ItemDesignOptionType.NUMBER) {
          results.push(this.settingModifiableVarSlider(designConfigRoot, varName, value.min, value.max));
        } else if (value.type === Constant.ItemDesignOptionType.STRING) {
          results.push(this.settingModifiableString(designConfigRoot, varName));
        } else if (value.type === Constant.ItemDesignOptionType.COLOR) {
          results.push(this.settingModifiableColor(designConfigRoot, varName));
        } else if (value.type === Constant.ItemDesignOptionType.SELECT_FILE) {
          results.push(this.settingModifiableSelectFile(designConfigRoot, varName));
        } else if (value.type === Constant.ItemDesignOptionType.SELECT) {
          results.push(this.settingModifiableSelect(designConfigRoot, varName, value['options[]']));
        } else {
          results.push(void 0);
        }
      }
      return results;
    }
  },
  settingModifiableVarSlider: function(configRoot, varName, min, max, stepValue) {
    var defaultValue, meterElement, valueElement;
    if (min == null) {
      min = 0;
    }
    if (max == null) {
      max = 100;
    }
    if (stepValue == null) {
      stepValue = 1;
    }
    meterElement = $("." + varName + "_meter", configRoot);
    valueElement = meterElement.prev('input:first');
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    valueElement.val(defaultValue);
    valueElement.html(defaultValue);
    try {
      meterElement.slider('destroy');
    } catch (_error) {

    }
    return meterElement.slider({
      min: min,
      max: max,
      step: stepValue,
      value: defaultValue,
      slide: (function(_this) {
        return function(event, ui) {
          valueElement.val(ui.value);
          valueElement.html(ui.value);
          _this[varName] = ui.value;
          return _this.applyDesignChange();
        };
      })(this)
    });
  },
  settingModifiableString: function(configRoot, varName) {
    var defaultValue;
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    $("." + varName + "_text", configRoot).val(defaultValue);
    return $("." + varName + "_text", configRoot).off('change').on('change', (function(_this) {
      return function() {
        _this[varName] = $(_this).val();
        return _this.applyDesignChange();
      };
    })(this));
  },
  settingModifiableColor: function(configRoot, varName) {
    var defaultValue, emt;
    emt = $("." + varName + "_color", configRoot);
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    return ColorPickerUtil.initColorPicker($(emt), defaultValue, (function(_this) {
      return function(a, b, d, e) {
        _this[varName] = "#" + b;
        return _this.applyDesignChange();
      };
    })(this));
  },
  settingModifiableSelectFile: function(configRoot, varName) {
    var form;
    form = $("form.item_image_form_" + varName, configRoot);
    this.initModifiableSelectFile(form);
    return form.off().on('ajax:complete', (function(_this) {
      return function(e, data, status, error) {
        var d;
        d = JSON.parse(data.responseText);
        _this[varName] = d.image_url;
        _this.saveObj();
        return _this.applyDesignChange();
      };
    })(this));
  },
  settingModifiableSelect: function(configRoot, varName, selectOptions) {
    var _joinArray, _splitArray, defaultValue, j, len, option, selectEmt, v;
    _joinArray = function(value) {
      if ($.isArray(value)) {
        return value.join(',');
      } else {
        return value;
      }
    };
    _splitArray = function(value) {
      if ($.isArray(value)) {
        return value.split(',');
      } else {
        return value;
      }
    };
    selectEmt = $("." + varName + "_select", configRoot);
    if (selectEmt.children('option').length === 0) {
      for (j = 0, len = selectOptions.length; j < len; j++) {
        option = selectOptions[j];
        v = _joinArray.call(this, option);
        selectEmt.append("<option value='" + v + "'>" + v + "</option>");
      }
    }
    defaultValue = PageValue.getInstancePageValue(PageValue.Key.instanceValue(this.id))[varName];
    if (defaultValue != null) {
      selectEmt.val(_joinArray.call(this, defaultValue));
    }
    return selectEmt.off('change').on('change', (function(_this) {
      return function(e) {
        _this[varName] = _splitArray.call(_this, $(e.target).val());
        return _this.applyDesignChange();
      };
    })(this));
  },
  initModifiableSelectFile: function(emt) {
    $(emt).find("." + this.constructor.ImageKey.PROJECT_ID).val(PageValue.getGeneralPageValue(PageValue.Key.PROJECT_ID));
    $(emt).find("." + this.constructor.ImageKey.ITEM_OBJ_ID).val(this.id);
    $(emt).find("." + this.constructor.ImageKey.SELECT_FILE + ":first").off().on('change', (function(_this) {
      return function(e) {
        var del, el, target;
        target = e.target;
        if (target.value && target.value.length > 0) {
          el = $(emt).find("." + _this.constructor.ImageKey.URL + ":first");
          el.attr('disabled', true);
          el.css('backgroundColor', 'gray');
          del = $(emt).find("." + _this.constructor.ImageKey.SELECT_FILE_DELETE + ":first");
          del.off('click').on('click', function() {
            $(target).val('');
            return $(target).trigger('change');
          });
          return del.show();
        } else {
          el = $(emt).find("." + _this.constructor.ImageKey.URL + ":first");
          el.removeAttr('disabled');
          el.css('backgroundColor', 'white');
          return $(emt).find("." + _this.constructor.ImageKey.SELECT_FILE_DELETE + ":first").hide();
        }
      };
    })(this));
    return $(emt).find("." + this.constructor.ImageKey.URL + ":first").off().on('change', (function(_this) {
      return function(e) {
        var target;
        target = e.target;
        if ($(target).val().length > 0) {
          return $(emt).find("." + _this.constructor.ImageKey.SELECT_FILE + ":first").attr('disabled', true);
        } else {
          return $(emt).find("." + _this.constructor.ImageKey.SELECT_FILE + ":first").removeAttr('disabled');
        }
      };
    })(this));
  }
};

//# sourceMappingURL=item_base_worktable_extend.js.map
