// Generated by CoffeeScript 1.9.2
var EventConfig;

EventConfig = (function() {
  var _setApplyClickEvent, _setCommonStateEvent, _setForkSelect, _setHandlerRadioEvent, _setMethodActionEvent, _setScrollDirectionEvent, _setupFromPageValues, constant;

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    EventConfig.ITEM_ROOT_ID = 'event_@distId';
    EventConfig.EVENT_ITEM_SEPERATOR = "&";
    EventConfig.ITEM_ACTION_CLASS = constant.EventConfig.ITEM_ACTION_CLASS;
    EventConfig.ITEM_VALUES_CLASS = constant.EventConfig.ITEM_VALUES_CLASS;
    EventConfig.EVENT_COMMON_PREFIX = constant.EventConfig.EVENT_COMMON_PREFIX;
    EventConfig.METHOD_VALUE_MODIFY_ROOT = 'modify';
    EventConfig.METHOD_VALUE_SPECIFIC_ROOT = 'specific';
  }

  function EventConfig(emt1, teNum1, distId1) {
    this.emt = emt1;
    this.teNum = teNum1;
    this.distId = distId1;
    _setupFromPageValues.call(this);
  }

  EventConfig.initEventConfig = function(distId, teNum) {
    if (teNum == null) {
      teNum = 1;
    }
    this.updateSelectItemMenu();
    return this.setupTimelineEventHandler(distId, teNum);
  };

  EventConfig.prototype.clearAllChange = function() {
    WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging();
    this.emt.find('.button_preview_wrapper').show();
    return this.emt.find('.button_stop_preview_wrapper').hide();
  };

  EventConfig.prototype.selectItem = function(e) {
    var actionClassName, objId, splitValues, vEmt, value;
    if (e == null) {
      e = null;
    }
    if (e != null) {
      value = $(e).val();
      if (value === "") {
        $(".config.te_div", this.emt).hide();
        return;
      }
      splitValues = value.split(EventConfig.EVENT_ITEM_SEPERATOR);
      objId = splitValues[0];
      this[EventPageValueBase.PageValueKey.ID] = objId;
      this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN] = splitValues[1];
      this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] = window.instanceMap[objId] instanceof CommonEventBase;
      this.constructor.addEventConfigContents(this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
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
    $('.common_state_div', this.emt).show();
    if (!this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      $('.item_common_div, .item_state_div', this.emt).show();
    }
    $(".config.handler_div", this.emt).show();
    $('.action_div .action_forms > div').hide();
    $(".action_div", this.emt).show();
    actionClassName = this.actionClassName();
    $(".action_div ." + actionClassName, this.emt).show();
    _setCommonStateEvent.call(this);
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
      $(".value_forms", this.emt).children("div").hide();
      if (this[EventPageValueBase.PageValueKey.METHODNAME] != null) {
        valueClassName = this.methodClassName();
        $(".value_forms ." + valueClassName, this.emt).show();
        $(".config.values_div", this.emt).show();
      }
      return _setApplyClickEvent.call(this);
    };
    if (!this[EventPageValueBase.PageValueKey.IS_COMMON_EVENT]) {
      item = window.instanceMap[this[EventPageValueBase.PageValueKey.ID]];
      if ((item != null) && (this[EventPageValueBase.PageValueKey.METHODNAME] != null)) {
        return ConfigMenu.loadEventMethodValueConfig(this, item.constructor, (function(_this) {
          return function() {
            return _callback.call(_this);
          };
        })(this));
      } else {
        return _callback.call(this);
      }
    } else {
      objClass = Common.getContentClass(this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
      if (objClass) {
        return ConfigMenu.loadEventMethodValueConfig(this, objClass, (function(_this) {
          return function() {
            return _callback.call(_this);
          };
        })(this));
      } else {
        return _callback.call(this);
      }
    }
  };

  EventConfig.prototype.writeToEventPageValue = function() {
    var bottomEmt, checked, errorMes, handlerDiv, leftEmt, parallel, prefix, rightEmt, specificRoot, specificValues, topEmt;
    if (this[EventPageValueBase.PageValueKey.ACTIONTYPE] == null) {
      if (window.debug) {
        console.log('validation error');
      }
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
    specificValues = {};
    specificRoot = this.emt.find("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_SPECIFIC_ROOT);
    specificRoot.find('input').each(function() {
      var className, classNames;
      if (!$(this).hasClass('fixed_value')) {
        classNames = $(this).get(0).className.split(' ');
        className = $.grep(classNames, function(n) {
          return n !== 'fixed_value';
        })[0];
        return specificValues[className] = $(this).val();
      }
    });
    this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES] = specificValues;
    errorMes = EventPageValueBase.writeToPageValue(this);
    if ((errorMes != null) && errorMes.length > 0) {
      this.showError(errorMes);
      return false;
    }
    return true;
  };

  EventConfig.prototype.applyAction = function() {
    return this.stopPreview((function(_this) {
      return function() {
        if (_this.writeToEventPageValue()) {
          LocalStorage.saveAllPageValues();
          FloatView.show('Applied', FloatView.Type.APPLY, 3.0);
          return Timeline.refreshAllTimeline();
        }
      };
    })(this));
  };

  EventConfig.prototype.preview = function(keepDispMag) {
    if (WorktableCommon.isConnectedEventProgressRoute(this.teNum)) {
      return WorktableCommon.stashEventPageValueForPreview(this.teNum, (function(_this) {
        return function() {
          _this.writeToEventPageValue();
          return WorktableCommon.runPreview(_this.teNum, keepDispMag);
        };
      })(this));
    }
  };

  EventConfig.prototype.stopPreview = function(callback) {
    if (callback == null) {
      callback = null;
    }
    return WorktableCommon.stopAllEventPreview(function() {
      WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging();
      if (callback != null) {
        return callback();
      }
    });
  };

  EventConfig.prototype.actionClassName = function() {
    return this.constructor.ITEM_ACTION_CLASS.replace('@classdisttoken', this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
  };

  EventConfig.prototype.methodClassName = function() {
    return this.constructor.ITEM_VALUES_CLASS.replace('@classdisttoken', this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]).replace('@methodname', this[EventPageValueBase.PageValueKey.METHODNAME]);
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

  _setMethodActionEvent = function() {
    var actionClassName, em;
    actionClassName = this.actionClassName();
    em = $(".action_forms ." + actionClassName + " input[type=radio]", this.emt);
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

  _setCommonStateEvent = function() {
    return $('.finish_page', this.emt).off('change').on('change', (function(_this) {
      return function(e) {
        var i, j, options, pageCount, ref, select;
        if ($(e.target).is(':checked')) {
          select = $('.finish_page_select', _this.emt);
          select.empty();
          options = "<option value=" + EventPageValueBase.NO_JUMPPAGE + ">" + (I18n.t('config.state.page_select_option_none')) + "</option>";
          pageCount = PageValue.getPageCount();
          for (i = j = 1, ref = pageCount; 1 <= ref ? j <= ref : j >= ref; i = 1 <= ref ? ++j : --j) {
            options += "<option value=" + i + ">" + (I18n.t('config.state.page_select_option') + ' ' + i) + "</option>";
          }
          select.append(options);
          return $('.finish_page_wrappper', _this.emt).show();
        } else {
          $('.finish_page_select', _this.emt).val(EventPageValueBase.NO_JUMPPAGE);
          return $('.finish_page_wrappper', _this.emt).hide();
        }
      };
    })(this));
  };

  _setHandlerRadioEvent = function() {
    $('.handler_div input[type=radio]', this.emt).off('click').on('click', (function(_this) {
      return function(e) {
        var beforeActionType;
        if ($(".action_forms ." + (_this.actionClassName()) + " input[type=radio]:checked", _this.emt).length > 0) {
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
    return $('.scroll_enabled', handler).off('click').on('click', function(e) {
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
    $('.enable_fork', handler).off('click').on('click', function(e) {
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
    if (WorktableCommon.isConnectedEventProgressRoute(this.teNum)) {
      $('.push.button.preview', this.emt).removeAttr('disabled');
      $('.push.button.preview', this.emt).off('click').on('click', (function(_this) {
        return function(e) {
          var keepDispMag;
          _this.clearError();
          keepDispMag = $(e.target).closest('div').find('.keep_disp_mag').is(':checked');
          return _this.preview(keepDispMag);
        };
      })(this));
    } else {
      $('.push.button.preview', this.emt).attr('disabled', true);
    }
    $('.push.button.apply', this.emt).off('click').on('click', (function(_this) {
      return function(e) {
        _this.clearError();
        return _this.applyAction();
      };
    })(this));
    return $('.push.button.preview_stop', this.emt).off('click').on('click', (function(_this) {
      return function(e) {
        _this.clearError();
        return _this.stopPreview();
      };
    })(this));
  };

  _setupFromPageValues = function() {
    if (EventPageValueBase.readFromPageValue(this)) {
      return this.selectItem();
    }
  };

  EventConfig.switchPreviewButton = function(enabled) {
    if (enabled) {
      $("#event-config").find('.event .button_div .button_preview_wrapper').show();
      return $("#event-config").find('.event .button_div .button_stop_preview_wrapper').hide();
    } else {
      $("#event-config").find('.event .button_div .button_preview_wrapper').hide();
      return $("#event-config").find('.event .button_div .button_stop_preview_wrapper').show();
    }
  };

  EventConfig.removeAllConfig = function() {
    return $('#event-config').children('.event').remove();
  };

  EventConfig.addEventConfigContents = function(distToken) {
    var actionParent, action_forms, className, itemClass, methodClone, methodName, methods, prop, props, span, valueClassName;
    itemClass = Common.getContentClass(distToken);
    if ((itemClass != null) && (itemClass.actionProperties != null)) {
      className = EventConfig.ITEM_ACTION_CLASS.replace('@classdisttoken', distToken);
      action_forms = $('#event-config .action_forms');
      if (action_forms.find("." + className).length === 0) {
        actionParent = $("<div class='" + className + "' style='display:none'></div>");
        props = itemClass.actionProperties;
        if (props == null) {
          if (window.debug) {
            console.log('Not declaration actionProperties');
          }
          return;
        }
        methodClone = $('#event-config .method_none_temp').children(':first').clone(true);
        methodClone.find('input[type=radio]').attr('name', className);
        actionParent.append(methodClone);
        methods = props[ItemBase.ActionPropertiesKey.METHODS];
        if (methods != null) {
          for (methodName in methods) {
            prop = methods[methodName];
            methodClone = $('#event-config .method_temp').children(':first').clone(true);
            span = methodClone.find('label:first').children('span:first');
            span.html(prop[ItemBase.ActionPropertiesKey.OPTIONS]['name']);
            methodClone.find('input.method_name:first').val(methodName);
            valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@classdisttoken', distToken).replace('@methodname', methodName);
            methodClone.find('input[type=radio]').attr('name', className);
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
    if ((objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]] == null) || (objClass.actionPropertiesModifiableVars(this[EventPageValueBase.PageValueKey.METHODNAME]) == null)) {
      return;
    }
    mod = objClass.actionPropertiesModifiableVars(this[EventPageValueBase.PageValueKey.METHODNAME]);
    if (mod != null) {
      results = [];
      for (varName in mod) {
        v = mod[varName];
        defaultValue = null;
        if (this.hasModifiableVar(varName)) {
          defaultValue = this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName];
        } else {
          objClass = null;
          if (this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN] != null) {
            objClass = Common.getContentClass(this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
          }
          if (objClass.actionPropertiesModifiableVars()[varName] != null) {
            defaultValue = objClass.actionPropertiesModifiableVars()[varName]["default"];
          }
        }
        if (v[objClass.ActionPropertiesKey.TYPE] === Constant.ItemDesignOptionType.INTEGER) {
          results.push(this.settingModifiableVarSlider(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], v.min, v.max, v.stepValue));
        } else if (v[objClass.ActionPropertiesKey.TYPE] === Constant.ItemDesignOptionType.STRING) {
          results.push(this.settingModifiableString(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
        } else if (v[objClass.ActionPropertiesKey.TYPE] === Constant.ItemDesignOptionType.BOOLEAN) {
          results.push(this.settingModifiableCheckbox(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
        } else if (v[objClass.ActionPropertiesKey.TYPE] === Constant.ItemDesignOptionType.COLOR) {
          results.push(this.settingModifiableColor(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE]));
        } else if (v[objClass.ActionPropertiesKey.TYPE] === Constant.ItemDesignOptionType.SELECT) {
          results.push(this.settingModifiableSelect(varName, defaultValue, v[objClass.ActionPropertiesKey.MODIFIABLE_CHILDREN_OPENVALUE], v['options[]']));
        } else {
          results.push(void 0);
        }
      }
      return results;
    }
  };

  EventConfig.prototype.initEventSpecificConfig = function(objClass) {
    var e, initSpecificConfigParam, methodClassName, methodName, ref, sp, v, varName;
    if ((objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]] == null) || (objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]][objClass.ActionPropertiesKey.SPECIFIC_METHOD_VALUES] == null)) {
      return;
    }
    sp = objClass.actionProperties.methods[this[EventPageValueBase.PageValueKey.METHODNAME]][objClass.ActionPropertiesKey.SPECIFIC_METHOD_VALUES];
    for (varName in sp) {
      v = sp[varName];
      e = this.emt.find("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_SPECIFIC_ROOT + " ." + varName + ":not('.fixed_value')");
      if (e.length > 0) {
        if (this.hasSpecificVar(varName)) {
          e.val(this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES][varName]);
        } else {
          e.val(v);
        }
      }
    }
    initSpecificConfigParam = {};
    ref = objClass.actionProperties.methods;
    for (methodName in ref) {
      v = ref[methodName];
      methodClassName = this.constructor.ITEM_VALUES_CLASS.replace('@classdisttoken', this[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]).replace('@methodname', methodName);
      initSpecificConfigParam[methodName] = this.emt.find("." + methodClassName + " ." + EventConfig.METHOD_VALUE_SPECIFIC_ROOT + ":first");
    }
    return objClass.initSpecificConfig(initSpecificConfigParam);
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

  EventConfig.prototype.hasSpecificVar = function(varName) {
    var ret;
    if (varName == null) {
      varName = null;
    }
    ret = (this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES] != null) && (this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES] != null) !== 'undefined';
    if (varName != null) {
      return ret && (this[EventPageValueBase.PageValueKey.SPECIFIC_METHOD_VALUES][varName] != null);
    } else {
      return ret;
    }
  };

  EventConfig.prototype.settingModifiableVarSlider = function(varName, defaultValue, openChildrenValue, min, max, stepValue) {
    var meterClassName, meterElement, valueElement;
    if (min == null) {
      min = 0;
    }
    if (max == null) {
      max = 100;
    }
    if (stepValue == null) {
      stepValue = 1;
    }
    meterClassName = varName + "_meter";
    meterElement = $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + meterClassName, this.emt);
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
          var value;
          valueElement.val(ui.value);
          valueElement.html(ui.value);
          if (!_this.hasModifiableVar(varName)) {
            _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
          }
          value = ui.value;
          _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
          return _this.constructor.switchChildrenConfig(event.target, varName, openChildrenValue, value);
        };
      })(this)
    }).trigger('slide');
  };

  EventConfig.prototype.settingModifiableString = function(varName, defaultValue, openChildrenValue) {
    $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + varName + "_text", this.emt).val(defaultValue);
    return $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + varName + "_text", this.emt).off('change').on('change', (function(_this) {
      return function(e) {
        var value;
        if (!_this.hasModifiableVar(varName)) {
          _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        value = $(e.target).val();
        _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
        return _this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
      };
    })(this)).trigger('change');
  };

  EventConfig.prototype.settingModifiableCheckbox = function(varName, defaultValue, openChildrenValue) {
    if (defaultValue) {
      $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + varName + "_checkbox", this.emt).attr('checked', true);
    } else {
      $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + varName + "_checkbox", this.emt).removeAttr('checked');
    }
    return $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + varName + "_checkbox", this.emt).off('change').on('change', (function(_this) {
      return function(e) {
        var value;
        if (!_this.hasModifiableVar(varName)) {
          _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        value = $(e.target).is(':checked');
        _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
        return _this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
      };
    })(this)).trigger('change');
  };

  EventConfig.prototype.settingModifiableColor = function(varName, defaultValue, openChildrenValue) {
    var emt;
    emt = $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + varName + "_color", this.emt);
    ColorPickerUtil.initColorPicker($(emt), defaultValue, (function(_this) {
      return function(a, b, d, e) {
        var value;
        if (!_this.hasModifiableVar(varName)) {
          _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        value = "#" + b;
        _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
        return _this.constructor.switchChildrenConfig(emt, varName, openChildrenValue, value);
      };
    })(this));
    return this.constructor.switchChildrenConfig(emt, varName, openChildrenValue, defaultValue);
  };

  EventConfig.prototype.settingModifiableSelect = function(varName, defaultValue, openChildrenValue, selectOptions) {
    var _joinArray, _splitArray, j, len, option, selectEmt, v;
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
    selectEmt = $("." + (this.methodClassName()) + " ." + EventConfig.METHOD_VALUE_MODIFY_ROOT + " ." + varName + "_select", this.emt);
    if (selectEmt.children('option').length === 0) {
      for (j = 0, len = selectOptions.length; j < len; j++) {
        option = selectOptions[j];
        v = _joinArray.call(this, option);
        selectEmt.append("<option value='" + v + "'>" + v + "</option>");
      }
    }
    selectEmt.val(_joinArray.call(this, defaultValue));
    return selectEmt.off('change').on('change', (function(_this) {
      return function(e) {
        var value;
        if (!_this.hasModifiableVar(varName)) {
          _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS] = {};
        }
        value = _splitArray.call(_this, $(e.target).val());
        _this[EventPageValueBase.PageValueKey.MODIFIABLE_VARS][varName] = value;
        return _this.constructor.switchChildrenConfig(e.target, varName, openChildrenValue, value);
      };
    })(this)).trigger('change');
  };

  EventConfig.updateSelectItemMenu = function() {
    var classDistToken, commonOptgroupClassName, commonSelectOptions, id, item, itemOptgroupClassName, itemSelectOptions, items, k, name, option, teItemSelect, teItemSelects;
    teItemSelects = $('#event-config .te_item_select');
    teItemSelect = teItemSelects[0];
    itemSelectOptions = '';
    commonSelectOptions = '';
    items = PageValue.getInstancePageValue(PageValue.Key.instancePagePrefix());
    for (k in items) {
      item = items[k];
      id = item.value.id;
      name = item.value.name;
      classDistToken = item.value.classDistToken;
      option = "<option value='" + id + EventConfig.EVENT_ITEM_SEPERATOR + classDistToken + "'>\n  " + name + "\n</option>";
      if (window.instanceMap[id] instanceof ItemBase) {
        itemSelectOptions += option;
      } else {
        commonSelectOptions += option;
      }
    }
    commonOptgroupClassName = 'common_optgroup_class_name';
    if (commonSelectOptions.length > 0) {
      commonSelectOptions = ("<optgroup class='" + commonOptgroupClassName + "' label='" + (I18n.t("config.select_opt_group.common")) + "'>") + commonSelectOptions + '</optgroup>';
    }
    itemOptgroupClassName = 'item_optgroup_class_name';
    if (itemSelectOptions.length > 0) {
      itemSelectOptions = ("<optgroup class='" + itemOptgroupClassName + "' label='" + (I18n.t("config.select_opt_group.item")) + "'>") + itemSelectOptions + '</optgroup>';
    }
    return teItemSelects.each(function() {
      $(this).find("." + commonOptgroupClassName).remove();
      $(this).find("." + itemOptgroupClassName).remove();
      if (commonSelectOptions.length > 0) {
        $(this).append($(commonSelectOptions));
      }
      if (itemSelectOptions.length > 0) {
        return $(this).append($(itemSelectOptions));
      }
    });
  };

  EventConfig.setupTimelineEventHandler = function(distId, teNum) {
    var config, eId, emt;
    eId = EventConfig.ITEM_ROOT_ID.replace('@distId', distId);
    emt = $('#' + eId);
    config = new this(emt, teNum, distId);
    config.clearAllChange();
    $('.update_event_after', emt).removeAttr('checked');
    if (WorktableCommon.isConnectedEventProgressRoute(teNum)) {
      $('.update_event_after', emt).removeAttr('disabled');
      $('.update_event_after', emt).off('change').on('change', (function(_this) {
        return function(e) {
          var blankDistId, configDistId, fromBlankEventConfig;
          if ($(e.target).is(':checked')) {
            $(e.target).attr('disabled', true);
            blankDistId = $('#timeline_events > .timeline_event.blank:first').find('.dist_id:first').val();
            configDistId = $(e.target).closest('.event').attr('id').replace(EventConfig.ITEM_ROOT_ID.replace('@distId', ''), '');
            fromBlankEventConfig = blankDistId === configDistId;
            return WorktableCommon.updatePrevEventsToAfter(teNum, true, fromBlankEventConfig, function() {
              return $(e.target).removeAttr('disabled');
            });
          } else {
            $(e.target).attr('disabled', true);
            return WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging(PageValue.getPageNum(), function() {
              return $(e.target).removeAttr('disabled');
            });
          }
        };
      })(this));
    } else {
      $('.update_event_after', emt).attr('disabled', true);
    }
    $('.te_item_select', emt).off('change').on('change', function(e) {
      config.clearError();
      return config.selectItem(this);
    });
    return $(window.drawingCanvas).one('click.setupTimelineEventHandler', (function(_this) {
      return function(e) {
        return WorktableCommon.refreshAllItemsFromInstancePageValueIfChanging();
      };
    })(this));
  };

  EventConfig.switchChildrenConfig = function(e, varName, openValue, targetValue) {
    var openClassName, root;
    if (openValue == null) {
      return;
    }
    if (typeof openValue === 'string' && (openValue === 'true' || openValue === 'false')) {
      openValue = openValue === 'true';
    }
    if (typeof targetValue === 'string' && (targetValue === 'true' || targetValue === 'false')) {
      targetValue = targetValue === 'true';
    }
    root = e.closest('.event');
    openClassName = ConfigMenu.Modifiable.CHILDREN_WRAPPER_CLASS.replace('@parentvarname', varName);
    if (openValue === targetValue) {
      return $(root).find("." + openClassName).show();
    } else {
      return $(root).find("." + openClassName).hide();
    }
  };

  return EventConfig;

})();

//# sourceMappingURL=event_config.js.map
