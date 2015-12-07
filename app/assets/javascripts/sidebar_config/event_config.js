// Generated by CoffeeScript 1.9.2
var EventConfig;

EventConfig = (function() {
  var _getEventPageValueClass, _setApplyClickEvent, _setEventDuration, _setForkSelect, _setMethodActionEvent, _setScrollDirectionEvent, _setupFromPageValues, constant;

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    EventConfig.ITEM_ROOT_ID = 'event_@distId';
    EventConfig.EVENT_ITEM_SEPERATOR = "&";
    EventConfig.COMMON_ACTION_CLASS = constant.EventConfig.COMMON_ACTION_CLASS;
    EventConfig.ITEM_ACTION_CLASS = constant.EventConfig.ITEM_ACTION_CLASS;
    EventConfig.COMMON_VALUES_CLASS = constant.EventConfig.COMMON_VALUES_CLASS;
    EventConfig.ITEM_VALUES_CLASS = constant.EventConfig.ITEM_VALUES_CLASS;
    EventConfig.EVENT_COMMON_PREFIX = constant.EventConfig.EVENT_COMMON_PREFIX;
  }

  function EventConfig(emt1, teNum1, distId1) {
    this.emt = emt1;
    this.teNum = teNum1;
    this.distId = distId1;
    _setupFromPageValues.call(this);
  }

  EventConfig.prototype.setupConfigValues = function() {
    var actionFormName, selectItemValue, self;
    self = this;
    selectItemValue = '';
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      selectItemValue = "" + EventConfig.EVENT_COMMON_PREFIX + this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID];
    } else {
      selectItemValue = "" + this[EventPageValueBase.PageValueKey.ID] + EventConfig.EVENT_ITEM_SEPERATOR + this[EventPageValueBase.PageValueKey.ITEM_ID];
    }
    $('.te_item_select', this.emt).val(selectItemValue);
    actionFormName = '';
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      actionFormName = EventConfig.EVENT_COMMON_PREFIX + this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID];
    } else {
      actionFormName = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', this[EventPageValueBase.PageValueKey.ITEM_ID]);
    }
    return $("." + actionFormName + " .radio", this.emt).each(function(e) {
      var actionType, methodName;
      actionType = $(this).find('input.action_type').val();
      methodName = $(this).find('input.method_name').val();
      if (parseInt(actionType) === self[EventPageValueBase.PageValueKey.ACTIONTYPE] && methodName === self[EventPageValueBase.PageValueKey.METHODNAME]) {
        $(this).find('input:radio').prop('checked', true);
        return false;
      }
    });
  };

  EventConfig.prototype.selectItem = function(e) {
    var checkedRadioButton, displayClassName, splitValues, vEmt, value;
    if (e == null) {
      e = null;
    }
    if (e != null) {
      value = $(e).val();
      if (value === "") {
        $(".config.te_div", this.emt).hide();
        return;
      }
      this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] = value.indexOf(EventConfig.EVENT_COMMON_PREFIX) === 0;
      if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
        this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] = parseInt(value.substring(EventConfig.EVENT_COMMON_PREFIX.length));
      } else {
        splitValues = value.split(EventConfig.EVENT_ITEM_SEPERATOR);
        this[EventPageValueBase.PageValueKey.ID] = splitValues[0];
        this[EventPageValueBase.PageValueKey.ITEM_ID] = splitValues[1];
      }
    }
    if (window.isWorkTable) {
      WorktableCommon.clearSelectedBorder();
    }
    if (!this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      vEmt = $('#' + this[EventPageValueBase.PageValueKey.ID]);
      if (window.isWorkTable) {
        WorktableCommon.setSelectedBorder(vEmt, 'timeline');
        Common.focusToTarget(vEmt);
      }
    }
    $(".config.te_div", this.emt).hide();
    $(".action_div .forms", this.emt).children("div").hide();
    displayClassName = '';
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      displayClassName = this.constructor.COMMON_ACTION_CLASS.replace('@commoneventid', this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]);
    } else {
      displayClassName = this.constructor.ITEM_ACTION_CLASS.replace('@itemid', this[EventPageValueBase.PageValueKey.ITEM_ID]);
      $('.item_common_div', this.emt).show();
    }
    $("." + displayClassName, this.emt).show();
    $(".action_div", this.emt).show();
    _setMethodActionEvent.call(this);
    if (e != null) {
      checkedRadioButton = $(".action_forms input:radio[name='" + displayClassName + "']:checked", this.emt);
      if (checkedRadioButton.val()) {
        return this.clickMethod(checkedRadioButton);
      }
    }
  };

  EventConfig.prototype.clickMethod = function(e) {
    var _callback, item, objClass, parent;
    if (e == null) {
      e = null;
    }
    if (e != null) {
      parent = $(e).closest('.radio');
      this[EventPageValueBase.PageValueKey.ACTIONTYPE] = parseInt(parent.find('input.action_type:first').val());
      this[EventPageValueBase.PageValueKey.METHODNAME] = parent.find('input.method_name:first').val();
    }
    _callback = function() {
      var beforeActionType, handlerClassName, tle, valueClassName;
      handlerClassName = this.methodClassName();
      valueClassName = this.methodClassName();
      if (this.teNum > 1) {
        beforeActionType = PageValue.getEventPageValue(PageValue.Key.eventNumber(this.teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE];
        if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] === beforeActionType) {
          $(".config.parallel_div", this.emt).show();
        }
      }
      $(".handler_div .configBox", this.emt).children("div").hide();
      $(".handler_div ." + handlerClassName, this.emt).show();
      $(".config.handler_div", this.emt).show();
      $(".value_forms", this.emt).children("div").hide();
      $(".value_forms ." + valueClassName, this.emt).show();
      $(".config.values_div", this.emt).show();
      if (e != null) {
        tle = _getEventPageValueClass.call(this);
        if ((tle != null) && (tle.initConfigValue != null)) {
          tle.initConfigValue(this);
        }
      }
      if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.SCROLL) {
        _setScrollDirectionEvent.call(this);
      } else if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
        _setEventDuration.call(this);
        _setForkSelect.call(this);
      }
      return _setApplyClickEvent.call(this);
    };
    if (!this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]) {
      item = window.instanceMap[this[EventPageValueBase.PageValueKey.ID]];
      if (item != null) {
        return this.addEventVarModifyConfig(item.constructor, (function(_this) {
          return function() {
            return _callback.call(_this);
          };
        })(this));
      } else {
        return _callback.call(this);
      }
    } else {
      objClass = Common.getClassFromMap(true, this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]);
      if (objClass) {
        return this.addEventVarModifyConfig(objClass, (function(_this) {
          return function() {
            return _callback.call(_this);
          };
        })(this));
      } else {
        return _callback.call(this);
      }
    }
  };

  EventConfig.prototype.resetAction = function() {
    return _setupFromPageValues.call(this);
  };

  EventConfig.prototype.applyAction = function() {
    var bottomEmt, checked, commonEvent, commonEventClass, errorMes, handlerDiv, item, leftEmt, parallel, prefix, rightEmt, te, topEmt;
    if (this[EventPageValueBase.PageValueKey.DIST_ID] == null) {
      this[EventPageValueBase.PageValueKey.DIST_ID] = Common.generateId();
    }
    this[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF] = {
      x: parseInt($('.item_position_diff_x:first', this.emt).val()),
      y: parseInt($('.item_position_diff_y:first', this.emt).val()),
      w: parseInt($('.item_diff_width:first', this.emt).val()),
      h: parseInt($('.item_diff_height:first', this.emt).val())
    };
    this[EventPageValueBase.PageValueKey.IS_SYNC] = false;
    parallel = $(".parallel_div .parallel", this.emt);
    if (parallel != null) {
      this[EventPageValueBase.PageValueKey.IS_SYNC] = parallel.is(":checked");
    }
    if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.SCROLL) {
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = '';
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = "";
      handlerDiv = $(".handler_div ." + (this.methodClassName()), this.emt);
      if (handlerDiv != null) {
        this[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = handlerDiv.find('.scroll_point_start:first').val();
        this[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = handlerDiv.find('.scroll_point_end:first').val();
        topEmt = handlerDiv.find('.scroll_enabled_top:first');
        bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first');
        leftEmt = handlerDiv.find('.scroll_enabled_left:first');
        rightEmt = handlerDiv.find('.scroll_enabled_right:first');
        this[EventPageValueBase.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = {
          top: topEmt.find('.scroll_enabled:first').is(":checked"),
          bottom: bottomEmt.find('.scroll_enabled:first').is(":checked"),
          left: leftEmt.find('.scroll_enabled:first').is(":checked"),
          right: rightEmt.find('.scroll_enabled:first').is(":checked")
        };
        this[EventPageValueBase.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = {
          top: topEmt.find('.scroll_forward:first').is(":checked"),
          bottom: bottomEmt.find('.scroll_forward:first').is(":checked"),
          left: leftEmt.find('.scroll_forward:first').is(":checked"),
          right: rightEmt.find('.scroll_forward:first').is(":checked")
        };
      }
    } else if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
      handlerDiv = $(".handler_div ." + (this.methodClassName()), this.emt);
      if (handlerDiv != null) {
        this[EventPageValueBase.PageValueKey.EVENT_DURATION] = handlerDiv.find('.click_duration:first').val();
        this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = 0;
        checked = handlerDiv.find('.enable_fork:first').is(':checked');
        if ((checked != null) && checked) {
          prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
          this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''));
        }
      }
    }
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      commonEventClass = Common.getClassFromMap(true, this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]);
      commonEvent = new commonEventClass();
      if (instanceMap[commonEvent.id] == null) {
        instanceMap[commonEvent.id] = commonEvent;
        commonEvent.setItemAllPropToPageValue();
      }
      this[EventPageValueBase.PageValueKey.ID] = commonEvent.id;
    }
    errorMes = this.writeToPageValue();
    if ((errorMes != null) && errorMes.length > 0) {
      this.showError(errorMes);
      return;
    }
    Timeline.changeTimelineColor(this.teNum, this[EventPageValueBase.PageValueKey.ACTIONTYPE]);
    LocalStorage.saveAllPageValues();
    item = instanceMap[this[EventPageValueBase.PageValueKey.ID]];
    if ((item != null) && (item.preview != null)) {
      te = PageValue.getEventPageValue(PageValue.Key.eventNumber(this.teNum));
      item.initEvent(te);
      PageValue.saveInstanceObjectToFootprint(item.id, true, item.event[EventPageValueBase.PageValueKey.DIST_ID]);
      return item.preview(te);
    }
  };

  EventConfig.prototype.writeToPageValue = function() {
    var errorMes, tle, writeValue;
    errorMes = "Not implemented";
    writeValue = null;
    tle = _getEventPageValueClass.call(this);
    if (tle != null) {
      errorMes = tle.writeToPageValue(this);
    }
    return errorMes;
  };

  EventConfig.prototype.readFromPageValue = function() {
    var tle;
    if (EventPageValueBase.readFromPageValue(this)) {
      tle = _getEventPageValueClass.call(this);
      if (tle != null) {
        return tle.readFromPageValue(this);
      }
    }
    return false;
  };

  EventConfig.prototype.methodClassName = function() {
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      return this.constructor.COMMON_VALUES_CLASS.replace('@commoneventid', this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]).replace('@methodname', this[EventPageValueBase.PageValueKey.METHODNAME]);
    } else {
      return this.constructor.ITEM_VALUES_CLASS.replace('@itemid', this[EventPageValueBase.PageValueKey.ITEM_ID]).replace('@methodname', this[EventPageValueBase.PageValueKey.METHODNAME]);
    }
  };

  EventConfig.prototype.showError = function(message) {
    var eventConfigError;
    eventConfigError = $('.event_config_error', this.emt);
    eventConfigError.find('p').html(message);
    return eventConfigError.show();
  };

  EventConfig.prototype.clearError = function() {
    var eventConfigError;
    eventConfigError = $('.event_config_error', this.emt);
    eventConfigError.find('p').html('');
    return eventConfigError.hide();
  };

  _getEventPageValueClass = function() {
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === null) {
      return null;
    }
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      if (this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] === Constant.CommonActionEventChangeType.SCREEN) {
        return EPVScreenPosition;
      } else {
        return EventPageValueBase;
      }
    } else {
      return EPVItem;
    }
  };

  _setMethodActionEvent = function() {
    var em, self;
    self = this;
    em = $('.action_forms input:radio', this.emt);
    em.off('change');
    return em.on('change', function(e) {
      self.clearError();
      return self.clickMethod(this);
    });
  };

  _setScrollDirectionEvent = function() {
    var handler, self;
    self = 0;
    handler = $('.handler_div', this.emt);
    $('.scroll_enabled', handler).off('click');
    return $('.scroll_enabled', handler).on('click', function(e) {
      var emt;
      if ($(this).is(':checked')) {
        return $(this).closest('.scroll_enabled_wrapper').find('.scroll_forward:first').parent('label').show();
      } else {
        emt = $(this).closest('.scroll_enabled_wrapper').find('.scroll_forward:first');
        emt.parent('label').hide();
        return emt.prop('checked', false);
      }
    });
  };

  _setEventDuration = function() {
    var eventDuration, handler, item, self;
    self = 0;
    handler = $('.handler_div', this.emt);
    eventDuration = handler.find('.click_duration:first');
    if (this[EventPageValueBase.PageValueKey.EVENT_DURATION] != null) {
      return eventDuration.val(this[EventPageValueBase.PageValueKey.EVENT_DURATION]);
    } else {
      item = window.instanceMap[this[EventPageValueBase.PageValueKey.ID]];
      if (item != null) {
        return eventDuration.val(item.constructor.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION]);
      }
    }
  };

  _setForkSelect = function() {
    var forkCount, forkNum, handler, i, j, name, ref, selectOptions, self, value;
    self = 0;
    handler = $('.handler_div', this.emt);
    $('.enable_fork', handler).off('click');
    $('.enable_fork', handler).on('click', function(e) {
      return $('.fork_select', handler).parent('div').css('display', $(this).is(':checked') ? 'block' : 'none');
    });
    forkCount = PageValue.getForkCount();
    if (forkCount > 0) {
      forkNum = PageValue.getForkNum();
      selectOptions = '';
      for (i = j = 1, ref = forkCount; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
        if (i !== forkNum) {
          name = Constant.Paging.NAV_MENU_FORK_NAME.replace('@forknum', i);
          value = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', i);
          selectOptions += "<option value='" + value + "'>" + name + "</option>";
        }
      }
      if (selectOptions.length > 0) {
        $('.fork_select', handler).children().remove();
        $('.fork_select', handler).append($(selectOptions));
        return $('.fork_handler_wrapper', handler).show();
      } else {
        return $('.fork_handler_wrapper', handler).hide();
      }
    } else {
      return $('.fork_handler_wrapper', handler).hide();
    }
  };

  _setApplyClickEvent = function() {
    var em, self;
    self = this;
    em = $('.push.button.reset', this.emt);
    em.off('click');
    em.on('click', function(e) {
      self.clearError();
      return self.resetAction();
    });
    em = $('.push.button.apply', this.emt);
    em.off('click');
    em.on('click', function(e) {
      self.clearError();
      self.applyAction();
      return Timeline.refreshAllTimeline();
    });
    em = $('.push.button.cancel', this.emt);
    em.off('click');
    return em.on('click', function(e) {
      self.clearError();
      e = $(this).closest('.event');
      $('.values', e).html('');
      return Sidebar.closeSidebar(function() {
        return $(".config.te_div", e).hide();
      });
    });
  };

  _setupFromPageValues = function() {
    if (this.readFromPageValue()) {
      this.setupConfigValues();
      this.selectItem();
      return this.clickMethod();
    }
  };

  EventConfig.removeAllConfig = function() {
    return $('#event-config').children('.event').remove();
  };

  EventConfig.addEventConfigContents = function(item_id) {
    var actionParent, actionType, actionTypeClassName, action_forms, className, handlerClone, handlerParent, handler_forms, itemClass, methodClone, methodName, methods, prop, props, span, valueClassName;
    itemClass = Common.getClassFromMap(false, item_id);
    if ((itemClass != null) && (itemClass.actionProperties != null)) {
      className = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', item_id);
      handler_forms = $('#event-config .handler_div .configBox');
      action_forms = $('#event-config .action_forms');
      if (action_forms.find("." + className).length === 0) {
        actionParent = $("<div class='" + className + "' style='display:none'></div>");
        props = itemClass.actionProperties;
        if (props == null) {
          console.log('Not declaration actionProperties');
          return;
        }
        methods = props[ItemBase.ActionPropertiesKey.METHODS];
        if (methods == null) {
          console.log("Not Found " + ItemBase.ActionPropertiesKey.METHODS + " key in actionProperties");
          return;
        }
        for (methodName in methods) {
          prop = methods[methodName];
          actionType = Common.getActionTypeByCodingActionType(prop.actionType);
          actionTypeClassName = Common.getActionTypeClassNameByActionType(actionType);
          methodClone = $('#event-config .method_temp').children(':first').clone(true);
          span = methodClone.find('label:first').children('span:first');
          span.attr('class', actionTypeClassName);
          span.html(prop[ItemBase.ActionPropertiesKey.OPTIONS]['name']);
          methodClone.find('input.action_type:first').val(actionType);
          methodClone.find('input.method_name:first').val(methodName);
          valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@itemid', item_id).replace('@methodname', methodName);
          methodClone.find('input:radio').attr('name', className);
          methodClone.find('input.value_class_name:first').val(valueClassName);
          actionParent.append(methodClone);
          handlerClone = null;
          if (actionType === Constant.ActionType.SCROLL) {
            handlerClone = $('#event-config .handler_scroll_temp').children().clone(true);
          } else if (actionType === Constant.ActionType.CLICK) {
            handlerClone = $('#event-config .handler_click_temp').children().clone(true);
          }
          handlerParent = $("<div class='" + valueClassName + "' style='display:none'></div>");
          handlerParent.append(handlerClone);
          handlerParent.appendTo(handler_forms);
        }
        return actionParent.appendTo(action_forms);
      }
    }
  };

  EventConfig.prototype.addEventVarModifyConfig = function(objClass, successCallback, errorCallback) {
    var emt, valueClassName;
    if (successCallback == null) {
      successCallback = null;
    }
    if (errorCallback == null) {
      errorCallback = null;
    }
    valueClassName = this.methodClassName();
    emt = $(".value_forms ." + valueClassName, this.emt);
    if (emt.length > 0) {
      this.initEventVarModifyConfig(objClass);
      if (successCallback != null) {
        successCallback();
      }
      return;
    }
    return $.ajax({
      url: "/config_menu/event_var_modify_config",
      type: "POST",
      data: {
        modifiables: objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]].modifiables
      },
      dataType: "json",
      success: (function(_this) {
        return function(data) {
          if (data.resultSuccess) {
            $(".value_forms", _this.emt).append($("<div class='" + valueClassName + "'>" + data.html + "</div>"));
            _this.initEventVarModifyConfig(objClass);
            if (successCallback != null) {
              return successCallback(data);
            }
          } else {
            if (errorCallback != null) {
              errorCallback(data);
            }
            return console.log('/config_menu/event_var_modify_config server error');
          }
        };
      })(this),
      error: function(data) {
        if (errorCallback != null) {
          errorCallback(data);
        }
        return console.log('/config_menu/event_var_modify_config ajax error');
      }
    });
  };

  EventConfig.prototype.initEventVarModifyConfig = function(objClass) {
    var defaultValue, mod, results, v, varName;
    mod = objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]].modifiables;
    if (mod != null) {
      results = [];
      for (varName in mod) {
        v = mod[varName];
        defaultValue = null;
        if (this.hasModifiableVar(varName)) {
          defaultValue = this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
        } else {
          objClass = null;
          if (this[EventPageValueBase.PageValueKey.ITEM_ID] != null) {
            objClass = Common.getClassFromMap(false, this[EventPageValueBase.PageValueKey.ITEM_ID]);
          } else if (this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] != null) {
            objClass = Common.getClassFromMap(true, this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]);
          }
          defaultValue = objClass.actionProperties.modifiables[varName]["default"];
        }
        if (v.type === Constant.ItemDesignOptionType.NUMBER) {
          results.push(this.settingModifiableVarSlider(varName, defaultValue, v.min, v.max, v.stepValue));
        } else if (v.type === Constant.ItemDesignOptionType.STRING) {
          results.push(this.settingModifiableString(varName, defaultValue));
        } else if (v.type === Constant.ItemDesignOptionType.COLOR) {
          results.push(this.settingModifiableColor(varName, defaultValue));
        } else {
          results.push(void 0);
        }
      }
      return results;
    }
  };

  EventConfig.prototype.hasModifiableVar = function(varName) {
    var ret;
    if (varName == null) {
      varName = null;
    }
    ret = (this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) && (this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] != null) !== 'undefined';
    if (varName != null) {
      return ret && (this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] != null);
    } else {
      return ret;
    }
  };

  EventConfig.prototype.settingModifiableVarSlider = function(varName, defaultValue, min, max, stepValue) {
    var meterClassName, meterElement, valueElement;
    if (min == null) {
      min = 0;
    }
    if (max == null) {
      max = 100;
    }
    if (stepValue == null) {
      stepValue = 0;
    }
    meterClassName = varName + "_meter";
    meterElement = $("." + meterClassName, this.emt);
    valueElement = meterElement.prev('input:first');
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
          if (!_this.hasModifiableVar(varName)) {
            _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
          }
          return _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = ui.value;
        };
      })(this)
    });
  };

  EventConfig.prototype.settingModifiableString = function(varName, defaultValue) {
    $("." + varName + "_text", this.emt).val(defaultValue);
    return $("." + varName + "_text", this.emt).off('change').on('change', (function(_this) {
      return function() {
        if (!_this.hasModifiableVar(varName)) {
          _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        return _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = $(_this).val();
      };
    })(this));
  };

  EventConfig.prototype.settingModifiableColor = function(varName, defaultValue) {
    var emt;
    emt = $("." + varName + "_color", this.emt);
    return ColorPickerUtil.initColorPicker($(emt), defaultValue, (function(_this) {
      return function(a, b, d, e) {
        if (!_this.hasModifiableVar(varName)) {
          _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        return _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = "#" + b;
      };
    })(this));
  };

  EventConfig.updateSelectItemMenu = function() {
    var itemOptgroupClassName, items, selectOptions, teItemSelect, teItemSelects;
    teItemSelects = $('#event-config .te_item_select');
    teItemSelect = teItemSelects[0];
    selectOptions = '';
    items = $("#" + PageValue.Key.IS_ROOT + " ." + PageValue.Key.INSTANCE_PREFIX + " ." + (PageValue.Key.pageRoot()));
    items.children().each(function() {
      var id, itemId, name;
      id = $(this).find('input.id').val();
      name = $(this).find('input.name').val();
      itemId = $(this).find('input.itemId').val();
      if (itemId != null) {
        return selectOptions += "<option value='" + id + EventConfig.EVENT_ITEM_SEPERATOR + itemId + "'>\n  " + name + "\n</option>";
      }
    });
    itemOptgroupClassName = 'item_optgroup_class_name';
    selectOptions = ("<optgroup class='" + itemOptgroupClassName + "' label='" + (I18n.t("config.select_opt_group.item")) + "'>") + selectOptions + '</optgroup>';
    return teItemSelects.each(function() {
      $(this).find("." + itemOptgroupClassName).remove();
      return $(this).append($(selectOptions));
    });
  };

  EventConfig.setupTimelineEventHandler = function(distId, teNum) {
    var eId, emt, te;
    eId = EventConfig.ITEM_ROOT_ID.replace('@distid', distId);
    emt = $('#' + eId);
    te = new this(emt, teNum, distId);
    return (function(_this) {
      return function() {
        var em;
        em = $('.te_item_select', emt);
        em.off('change');
        return em.on('change', function(e) {
          te.clearError();
          return te.selectItem(this);
        });
      };
    })(this)();
  };

  return EventConfig;

})();

//# sourceMappingURL=event_config.js.map
