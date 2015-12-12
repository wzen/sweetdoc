// Generated by CoffeeScript 1.9.2
var EventConfig;

EventConfig = (function() {
  var _getEventPageValueClass, _setApplyClickEvent, _setForkSelect, _setHandlerRadioEvent, _setMethodActionEvent, _setScrollDirectionEvent, _setupFromPageValues, constant;

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

  EventConfig.prototype.selectItem = function(e) {
    var actionClassName, splitValues, vEmt, value;
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
        this[EventPageValueBase.PageValueKey.ITEM_ACCESS_TOKEN] = splitValues[1];
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
    if (!this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      $('.item_common_div', this.emt).show();
    }
    $(".config.handler_div", this.emt).show();
    $(".action_div", this.emt).show();
    actionClassName = this.actionClassName();
    $(".action_div ." + actionClassName, this.emt).show();
    _setHandlerRadioEvent.call(this);
    _setScrollDirectionEvent.call(this);
    _setForkSelect.call(this);
    return _setMethodActionEvent.call(this);
  };

  EventConfig.prototype.clickMethod = function(e) {
    var _callback, item, objClass;
    if (e == null) {
      e = null;
    }
    _callback = function() {
      var valueClassName;
      if (this[EventPageValueBase.PageValueKey.METHODNAME] != null) {
        valueClassName = this.methodClassName();
        $(".value_forms", this.emt).children("div").hide();
        $(".value_forms ." + valueClassName, this.emt).show();
        $(".config.values_div", this.emt).show();
      }
      return _setApplyClickEvent.call(this);
    };
    if (!this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]) {
      item = window.instanceMap[this[EventPageValueBase.PageValueKey.ID]];
      if ((item != null) && (this[EventPageValueBase.PageValueKey.METHODNAME] != null)) {
        return ConfigMenu.eventVarModifyConfig(this, item.constructor, (function(_this) {
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
        return ConfigMenu.eventVarModifyConfig(this, objClass, (function(_this) {
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
    if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] == null) {
      console.log('validation error');
      return false;
    }
    if (this[EventPageValueBase.PageValueKey.DIST_ID] == null) {
      this[EventPageValueBase.PageValueKey.DIST_ID] = Common.generateId();
    }
    this[EventPageValueBase.PageValueKey.ITEM_SIZE_DIFF] = {
      x: parseInt($('.item_position_diff_x:first', this.emt).val()),
      y: parseInt($('.item_position_diff_y:first', this.emt).val()),
      w: parseInt($('.item_diff_width:first', this.emt).val()),
      h: parseInt($('.item_diff_height:first', this.emt).val())
    };
    this[EventPageValueBase.PageValueKey.DO_FOCUS] = $('.do_focus', this.emt).prop('checked');
    this[EventPageValueBase.PageValueKey.IS_SYNC] = false;
    parallel = $(".parallel_div .parallel", this.emt);
    if (parallel != null) {
      this[EventPageValueBase.PageValueKey.IS_SYNC] = parallel.is(":checked");
    }
    handlerDiv = $(".handler_div", this.emt);
    if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.SCROLL) {
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_START] = '';
      this[EventPageValueBase.PageValueKey.SCROLL_POINT_END] = "";
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
    } else if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
      this[EventPageValueBase.PageValueKey.EVENT_DURATION] = handlerDiv.find('.click_duration:first').val();
      this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = 0;
      checked = handlerDiv.find('.enable_fork:first').is(':checked');
      if ((checked != null) && checked) {
        prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
        this[EventPageValueBase.PageValueKey.CHANGE_FORKNUM] = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''));
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
      return false;
    }
    Timeline.changeTimelineColor(this.teNum, this[EventPageValueBase.PageValueKey.ACTIONTYPE]);
    LocalStorage.saveAllPageValues();
    item = instanceMap[this[EventPageValueBase.PageValueKey.ID]];
    if ((item != null) && (item.preview != null)) {
      te = PageValue.getEventPageValue(PageValue.Key.eventNumber(this.teNum));
      item.initEvent(te);
      PageValue.saveInstanceObjectToFootprint(item.id, true, item.event[EventPageValueBase.PageValueKey.DIST_ID]);
      item.preview(te);
    }
    return true;
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
    tle = _getEventPageValueClass.call(this);
    if (tle != null) {
      return tle.readFromPageValue(this);
    } else {
      return false;
    }
  };

  EventConfig.prototype.actionClassName = function() {
    var name;
    name = '';
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      name = this.constructor.COMMON_ACTION_CLASS.replace('@commoneventid', this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]);
    } else {
      name = this.constructor.ITEM_ACTION_CLASS.replace('@itemtoken', this[EventPageValueBase.PageValueKey.ITEM_ACCESS_TOKEN]);
    }
    return name;
  };

  EventConfig.prototype.methodClassName = function() {
    if (this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      return this.constructor.COMMON_VALUES_CLASS.replace('@commoneventid', this[EventPageValueBase.PageValueKey.COMMON_EVENT_ID]).replace('@methodname', this[EventPageValueBase.PageValueKey.METHODNAME]);
    } else {
      return this.constructor.ITEM_VALUES_CLASS.replace('@itemtoken', this[EventPageValueBase.PageValueKey.ITEM_ACCESS_TOKEN]).replace('@methodname', this[EventPageValueBase.PageValueKey.METHODNAME]);
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
    var actionClassName, em;
    actionClassName = this.actionClassName();
    em = $(".action_forms ." + actionClassName + " input:radio", this.emt);
    em.off('click').on('click', (function(_this) {
      return function(e) {
        var parent;
        _this.clearError();
        parent = $(e.target).closest('.radio');
        _this[EventPageValueBase.PageValueKey.METHODNAME] = parent.find('input.method_name:first').val();
        _this.clickMethod(e.target);
        if (_this[EventPageValueBase.PageValueKey.ACTIONTYPE] != null) {
          return $('.button_div', _this.emt).show();
        }
      };
    })(this));
    return $(".action_forms ." + actionClassName + " input[type=radio]:checked", this.emt).trigger('click');
  };

  _setHandlerRadioEvent = function() {
    $('.handler_div input[type=radio]', this.emt).off('click').on('click', (function(_this) {
      return function(e) {
        var beforeActionType;
        if ($(".action_forms ." + (_this.actionClassName()) + " input:radio:checked", _this.emt).length > 0) {
          $('.button_div', _this.emt).show();
        }
        $('.handler_form', _this.emt).hide();
        if ($(e.target).val() === 'scroll') {
          _this[EventPageValueBase.PageValueKey.ACTIONTYPE] = Constant.ActionType.SCROLL;
          $('.scroll_form', _this.emt).show();
        } else if ($(e.target).val() === 'click') {
          _this[EventPageValueBase.PageValueKey.ACTIONTYPE] = Constant.ActionType.CLICK;
          $('.click_form', _this.emt).show();
        }
        if (_this.teNum > 1) {
          beforeActionType = PageValue.getEventPageValue(PageValue.Key.eventNumber(_this.teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE];
          if (_this[EventPageValueBase.PageValueKey.ACTIONTYPE] === beforeActionType) {
            return $(".config.parallel_div", _this.emt).show();
          } else {
            return $(".config.parallel_div", _this.emt).hide();
          }
        }
      };
    })(this));
    return $('.handler_div input[type=radio]:checked', this.emt).trigger('click');
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
      if (self.applyAction()) {
        return Timeline.refreshAllTimeline();
      }
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
      return this.selectItem();
    }
  };

  EventConfig.removeAllConfig = function() {
    return $('#event-config').children('.event').remove();
  };

  EventConfig.addEventConfigContents = function(item_access_token) {
    var actionParent, action_forms, className, itemClass, methodClone, methodName, methods, prop, props, span, valueClassName;
    itemClass = Common.getClassFromMap(false, item_access_token);
    if ((itemClass != null) && (itemClass.actionProperties != null)) {
      className = EventConfig.ITEM_ACTION_CLASS.replace('@itemtoken', item_access_token);
      action_forms = $('#event-config .action_forms');
      if (action_forms.find("." + className).length === 0) {
        actionParent = $("<div class='" + className + "' style='display:none'></div>");
        props = itemClass.actionProperties;
        if (props == null) {
          console.log('Not declaration actionProperties');
          return;
        }
        methodClone = $('#event-config .method_none_temp').children(':first').clone(true);
        methodClone.find('input:radio').attr('name', className);
        actionParent.append(methodClone);
        methods = props[ItemBase.ActionPropertiesKey.METHODS];
        if (methods != null) {
          for (methodName in methods) {
            prop = methods[methodName];
            methodClone = $('#event-config .method_temp').children(':first').clone(true);
            span = methodClone.find('label:first').children('span:first');
            span.html(prop[ItemBase.ActionPropertiesKey.OPTIONS]['name']);
            methodClone.find('input.method_name:first').val(methodName);
            valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@itemtoken', item_access_token).replace('@methodname', methodName);
            methodClone.find('input:radio').attr('name', className);
            methodClone.find('input.value_class_name:first').val(valueClassName);
            actionParent.append(methodClone);
          }
        }
        return actionParent.appendTo(action_forms);
      }
    }
  };

  EventConfig.prototype.initEventVarModifyConfig = function(objClass) {
    var defaultValue, mod, results, v, varName;
    if ((objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]] == null) || (objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]].modifiables == null)) {
      return;
    }
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
          if (this[EventPageValueBase.PageValueKey.ITEM_ACCESS_TOKEN] != null) {
            objClass = Common.getClassFromMap(false, this[EventPageValueBase.PageValueKey.ITEM_ACCESS_TOKEN]);
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
    var id, item, itemOptgroupClassName, itemToken, items, k, name, selectOptions, teItemSelect, teItemSelects;
    teItemSelects = $('#event-config .te_item_select');
    teItemSelect = teItemSelects[0];
    selectOptions = '';
    items = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix());
    for (k in items) {
      item = items[k];
      id = item.value.id;
      name = item.value.name;
      itemToken = item.value.itemToken;
      if (itemToken != null) {
        selectOptions += "<option value='" + id + EventConfig.EVENT_ITEM_SEPERATOR + itemToken + "'>\n  " + name + "\n</option>";
      }
    }
    itemOptgroupClassName = 'item_optgroup_class_name';
    selectOptions = ("<optgroup class='" + itemOptgroupClassName + "' label='" + (I18n.t("config.select_opt_group.item")) + "'>") + selectOptions + '</optgroup>';
    return teItemSelects.each(function() {
      $(this).find("." + itemOptgroupClassName).remove();
      return $(this).append($(selectOptions));
    });
  };

  EventConfig.setupTimelineEventHandler = function(distId, teNum) {
    var eId, emt, te;
    eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId);
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
