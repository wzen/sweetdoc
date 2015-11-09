// Generated by CoffeeScript 1.9.2
var EventConfig;

EventConfig = (function() {
  var _getEventPageValueClass, _setApplyClickEvent, _setForkSelect, _setMethodActionEvent, _setScrollDirectionEvent, _setupFromPageValues, constant;

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    EventConfig.ITEM_ROOT_ID = 'event_@te_num';
    EventConfig.EVENT_ITEM_SEPERATOR = "&";
    EventConfig.COMMON_ACTION_CLASS = constant.EventConfig.COMMON_ACTION_CLASS;
    EventConfig.ITEM_ACTION_CLASS = constant.EventConfig.ITEM_ACTION_CLASS;
    EventConfig.COMMON_VALUES_CLASS = constant.EventConfig.COMMON_VALUES_CLASS;
    EventConfig.ITEM_VALUES_CLASS = constant.EventConfig.ITEM_VALUES_CLASS;
    EventConfig.EVENT_COMMON_PREFIX = constant.EventConfig.EVENT_COMMON_PREFIX;
  }

  function EventConfig(emt1, teNum) {
    this.emt = emt1;
    this.teNum = teNum;
    _setupFromPageValues.call(this);
  }

  EventConfig.prototype.setupConfigValues = function() {
    var actionFormName, selectItemValue, self;
    self = this;
    selectItemValue = '';
    if (this.isCommonEvent) {
      selectItemValue = "" + EventConfig.EVENT_COMMON_PREFIX + this.commonEventId;
    } else {
      selectItemValue = "" + this.id + EventConfig.EVENT_ITEM_SEPERATOR + this.itemId;
    }
    $('.te_item_select', this.emt).val(selectItemValue);
    actionFormName = '';
    if (this.isCommonEvent) {
      actionFormName = EventConfig.EVENT_COMMON_PREFIX + this.commonEventId;
    } else {
      actionFormName = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', this.itemId);
    }
    return $("." + actionFormName + " .radio", this.emt).each(function(e) {
      var actionType, methodName;
      actionType = $(this).find('input.action_type').val();
      methodName = $(this).find('input.method_name').val();
      if (parseInt(actionType) === self.actionType && methodName === self.methodName) {
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
      this.isCommonEvent = value.indexOf(EventConfig.EVENT_COMMON_PREFIX) === 0;
      if (this.isCommonEvent) {
        this.commonEventId = parseInt(value.substring(EventConfig.EVENT_COMMON_PREFIX.length));
      } else {
        splitValues = value.split(EventConfig.EVENT_ITEM_SEPERATOR);
        this.id = splitValues[0];
        this.itemId = splitValues[1];
      }
    }
    WorktableCommon.clearSelectedBorder();
    if (!this.isCommonEvent) {
      vEmt = $('#' + this.id);
      WorktableCommon.setSelectedBorder(vEmt, 'timeline');
      Common.focusToTarget(vEmt);
    }
    $(".config.te_div", this.emt).hide();
    $(".action_div .forms", this.emt).children("div").hide();
    displayClassName = '';
    if (this.isCommonEvent) {
      displayClassName = this.constructor.COMMON_ACTION_CLASS.replace('@commoneventid', this.commonEventId);
    } else {
      displayClassName = this.constructor.ITEM_ACTION_CLASS.replace('@itemid', this.itemId);
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
    var beforeActionType, handlerClassName, parent, tle, valueClassName;
    if (e == null) {
      e = null;
    }
    if (e != null) {
      parent = $(e).closest('.radio');
      this.actionType = parseInt(parent.find('input.action_type:first').val());
      this.methodName = parent.find('input.method_name:first').val();
    }
    handlerClassName = this.methodClassName();
    valueClassName = this.methodClassName();
    if (this.teNum > 1) {
      beforeActionType = PageValue.getEventPageValue(PageValue.Key.eventNumber(this.teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE];
      if (this.actionType === beforeActionType) {
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
    if (this.actionType === Constant.ActionType.SCROLL) {
      _setScrollDirectionEvent.call(this);
    } else if (this.actionType === Constant.ActionType.CLICK) {
      _setForkSelect.call(this);
    }
    return _setApplyClickEvent.call(this);
  };

  EventConfig.prototype.resetAction = function() {
    return _setupFromPageValues.call(this);
  };

  EventConfig.prototype.applyAction = function() {
    var bottomEmt, checked, commonEvent, commonEventClass, errorMes, handlerDiv, item, leftEmt, parallel, prefix, rightEmt, topEmt;
    this.itemSizeDiff = {
      x: parseInt($('.item_position_diff_x:first', this.emt).val()),
      y: parseInt($('.item_position_diff_y:first', this.emt).val()),
      w: parseInt($('.item_diff_width:first', this.emt).val()),
      h: parseInt($('.item_diff_height:first', this.emt).val())
    };
    this.isParallel = false;
    parallel = $(".parallel_div .parallel", this.emt);
    if (parallel != null) {
      this.isParallel = parallel.is(":checked");
    }
    if (this.actionType === Constant.ActionType.SCROLL) {
      this.scrollPointStart = '';
      this.scrollPointEnd = "";
      handlerDiv = $(".handler_div ." + (this.methodClassName()), this.emt);
      if (handlerDiv != null) {
        this.scrollPointStart = handlerDiv.find('.scroll_point_start:first').val();
        this.scrollPointEnd = handlerDiv.find('.scroll_point_end:first').val();
        topEmt = handlerDiv.find('.scroll_enabled_top:first');
        bottomEmt = handlerDiv.find('.scroll_enabled_bottom:first');
        leftEmt = handlerDiv.find('.scroll_enabled_left:first');
        rightEmt = handlerDiv.find('.scroll_enabled_right:first');
        this.scrollEnabledDirection = {
          top: topEmt.find('.scroll_enabled:first').is(":checked"),
          bottom: bottomEmt.find('.scroll_enabled:first').is(":checked"),
          left: leftEmt.find('.scroll_enabled:first').is(":checked"),
          right: rightEmt.find('.scroll_enabled:first').is(":checked")
        };
        this.scrollForwardDirection = {
          top: topEmt.find('.scroll_forward:first').is(":checked"),
          bottom: bottomEmt.find('.scroll_forward:first').is(":checked"),
          left: leftEmt.find('.scroll_forward:first').is(":checked"),
          right: rightEmt.find('.scroll_forward:first').is(":checked")
        };
      }
    } else if (this.actionType === Constant.ActionType.CLICK) {
      handlerDiv = $(".handler_div ." + (this.methodClassName()), this.emt);
      if (handlerDiv != null) {
        this.forkNum = 0;
        checked = handlerDiv.find('.enable_fork:first').is(':checked');
        if ((checked != null) && checked) {
          prefix = Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', '');
          this.forkNum = parseInt(handlerDiv.find('.fork_select:first').val().replace(prefix, ''));
        }
      }
    }
    if (this.isCommonEvent) {
      commonEventClass = Common.getClassFromMap(true, this.commonEventId);
      commonEvent = new commonEventClass();
      instanceMap[commonEvent.id] = commonEvent;
      commonEvent.setItemAllPropToPageValue();
      this.id = commonEvent.id;
    }
    errorMes = this.writeToPageValue();
    if ((errorMes != null) && errorMes.length > 0) {
      this.showError(errorMes);
      return;
    }
    Timeline.changeTimelineColor(this.teNum, this.actionType);
    LocalStorage.saveAllPageValues();
    item = instanceMap[this.id];
    if ((item != null) && (item.preview != null)) {
      return item.preview(PageValue.getEventPageValue(PageValue.Key.eventNumber(this.teNum)));
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
    if (this.isCommonEvent) {
      return this.constructor.COMMON_VALUES_CLASS.replace('@commoneventid', this.commonEventId).replace('@methodname', this.methodName);
    } else {
      return this.constructor.ITEM_VALUES_CLASS.replace('@itemid', this.itemId).replace('@methodname', this.methodName);
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
    if (this.isCommonEvent === null) {
      return null;
    }
    if (this.isCommonEvent) {
      if (this.commonEventId === Constant.CommonActionEventChangeType.BACKGROUND) {
        return EPVBackgroundColor;
      } else if (this.commonEventId === Constant.CommonActionEventChangeType.SCREEN) {
        return EPVScreenPosition;
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

  return EventConfig;

})();

//# sourceMappingURL=event_config.js.map
