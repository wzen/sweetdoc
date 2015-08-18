// Generated by CoffeeScript 1.9.2
var EventConfig;

EventConfig = (function() {
  var _getEventClass, _setApplyClickEvent, _setMethodActionEvent, _setupFromPageValues;

  if (typeof gon !== "undefined" && gon !== null) {
    EventConfig.ITEM_ROOT_ID = 'event_@te_num';
    EventConfig.COMMON_ACTION_CLASS = constant.ElementAttribute.COMMON_ACTION_CLASS;
    EventConfig.ITEM_ACTION_CLASS = constant.ElementAttribute.ITEM_ACTION_CLASS;
    EventConfig.COMMON_VALUES_CLASS = constant.ElementAttribute.COMMON_VALUES_CLASS;
    EventConfig.ITEM_VALUES_CLASS = constant.ElementAttribute.ITEM_VALUES_CLASS;
  }

  function EventConfig(emt, teNum) {
    this.emt = emt;
    this.teNum = teNum;
    _setupFromPageValues.call(this);
  }

  EventConfig.prototype.setupConfigValues = function() {
    var actionFormName, selectItemValue, self;
    self = this;
    selectItemValue = '';
    if (this.isCommonEvent) {
      selectItemValue = "" + Constant.EVENT_COMMON_PREFIX + this.commonEventId;
    } else {
      selectItemValue = "" + this.id + Constant.EVENT_ITEM_SEPERATOR + this.itemId;
    }
    $('.te_item_select', this.emt).val(selectItemValue);
    actionFormName = '';
    if (this.isCommonEvent) {
      actionFormName = Constant.EVENT_COMMON_PREFIX + this.commonEventId;
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
        $(".config.te_div", this.emt).css('display', 'none');
        return;
      }
      this.isCommonEvent = value.indexOf(Constant.EVENT_COMMON_PREFIX) === 0;
      if (this.isCommonEvent) {
        this.commonEventId = parseInt(value.substring(Constant.EVENT_COMMON_PREFIX.length));
      } else {
        splitValues = value.split(Constant.EVENT_ITEM_SEPERATOR);
        this.id = splitValues[0];
        this.itemId = splitValues[1];
      }
    }
    clearSelectedBorder();
    if (!this.isCommonEvent) {
      vEmt = $('#' + this.id);
      setSelectedBorder(vEmt, 'timeline');
      Common.focusToTarget(vEmt);
    }
    $(".config.te_div", this.emt).css('display', 'none');
    $(".action_div .forms", this.emt).children("div").css('display', 'none');
    displayClassName = '';
    if (this.isCommonEvent) {
      displayClassName = this.constructor.COMMON_ACTION_CLASS.replace('@commoneventid', this.commonEventId);
    } else {
      displayClassName = this.constructor.ITEM_ACTION_CLASS.replace('@itemid', this.itemId);
    }
    $("." + displayClassName, this.emt).css('display', '');
    $(".action_div", this.emt).css('display', '');
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
      this.animationType = parent.find('input.animation_type:first').val();
    }
    handlerClassName = this.methodClassName();
    valueClassName = this.methodClassName();
    if (this.teNum > 1) {
      beforeActionType = PageValue.getEventPageValue(EventPageValueBase.PageValueKey.te(this.teNum - 1))[EventPageValueBase.PageValueKey.ACTIONTYPE];
      if (this.actionType === beforeActionType) {
        $(".config.parallel_div", this.emt).css('display', '');
      }
    }
    $(".handler_div .configBox", this.emt).children("div").css('display', 'none');
    $(".handler_div ." + handlerClassName, this.emt).css('display', '');
    $(".config.handler_div", this.emt).css('display', '');
    $(".value_forms", this.emt).children("div").css('display', 'none');
    $(".value_forms ." + valueClassName, this.emt).css('display', '');
    $(".config.values_div", this.emt).css('display', '');
    if (e != null) {
      tle = _getEventClass.call(this);
      if ((tle != null) && (tle.initConfigValue != null)) {
        tle.initConfigValue(this);
      }
    }
    return _setApplyClickEvent.call(this);
  };

  EventConfig.prototype.resetAction = function() {
    return _setupFromPageValues.call(this);
  };

  EventConfig.prototype.applyAction = function() {
    var commonEvent, errorMes, handlerDiv, item, parallel;
    this.isParallel = false;
    parallel = $(".parallel_div .parallel", this.emt);
    if (parallel != null) {
      this.isParallel = parallel.is(":checked");
    }
    if (this.actionType === Constant.ActionEventHandleType.SCROLL) {
      this.scrollPointStart = '';
      this.scrollPointEnd = "";
      handlerDiv = $(".handler_div ." + (this.methodClassName()), this.emt);
      if (handlerDiv != null) {
        this.scrollPointStart = handlerDiv.find('.scroll_point_start:first').val();
        this.scrollPointEnd = handlerDiv.find('.scroll_point_end:first').val();
      }
    }
    if (this.isCommonEvent) {
      commonEvent = Common.getClassFromMap(true, this.commonEventId);
      this.id = (new commonEvent()).id;
    }
    errorMes = this.writeToPageValue();
    if ((errorMes != null) && errorMes.length > 0) {
      this.showError(errorMes);
      return;
    }
    Timeline.changeTimelineColor(this.teNum, this.actionType);
    item = createdObject[this.id];
    if ((item != null) && (item.preview != null)) {
      return item.preview(PageValue.getEventPageValue(EventPageValueBase.PageValueKey.te(this.teNum)));
    }
  };

  EventConfig.prototype.writeToPageValue = function() {
    var errorMes, tle, writeValue;
    errorMes = "Not implemented";
    writeValue = null;
    tle = _getEventClass.call(this);
    if (tle != null) {
      errorMes = tle.writeToPageValue(this);
    }
    return errorMes;
  };

  EventConfig.prototype.readFromPageValue = function() {
    var tle;
    if (EventPageValueBase.readFromPageValue(this)) {
      tle = _getEventClass.call(this);
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
    return eventConfigError.css('display', '');
  };

  EventConfig.prototype.clearError = function() {
    var eventConfigError;
    eventConfigError = $('.event_config_error', this.emt);
    eventConfigError.find('p').html('');
    return eventConfigError.css('display', 'none');
  };

  _getEventClass = function() {
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
      return Timeline.setupTimelineEventConfig();
    });
    em = $('.push.button.cancel', this.emt);
    em.off('click');
    return em.on('click', function(e) {
      self.clearError();
      e = $(this).closest('.event');
      $('.values', e).html('');
      return Sidebar.closeSidebar(function() {
        return $(".config.te_div", e).css('display', 'none');
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

  EventConfig.addEventConfigContents = function(item_id, te_actions, te_values) {
    var actionParent, action_forms, className, handler_forms;
    if ((te_actions != null) && te_actions.length > 0) {
      className = EventConfig.ITEM_ACTION_CLASS.replace('@itemid', item_id);
      handler_forms = $('#event-config .handler_div .configBox');
      action_forms = $('#event-config .action_forms');
      if (action_forms.find("." + className).length === 0) {
        actionParent = $("<div class='" + className + "' style='display:none'></div>");
        te_actions.forEach(function(a) {
          var actionType, handlerClone, handlerParent, methodClone, span, valueClassName;
          actionType = Common.getActionTypeClassNameByActionType(a.action_event_type_id);
          methodClone = $('#event-config .method_temp').children(':first').clone(true);
          span = methodClone.find('label:first').children('span:first');
          span.attr('class', actionType);
          span.html(a.options['name']);
          methodClone.find('input.action_type:first').val(a.action_event_type_id);
          methodClone.find('input.method_name:first').val(a.method_name);
          methodClone.find('input.animation_type:first').val(a.action_animation_type_id);
          valueClassName = EventConfig.ITEM_VALUES_CLASS.replace('@itemid', item_id).replace('@methodname', a.method_name);
          methodClone.find('input:radio').attr('name', className);
          methodClone.find('input.value_class_name:first').val(valueClassName);
          actionParent.append(methodClone);
          handlerClone = null;
          if (a.action_event_type_id === Constant.ActionEventHandleType.SCROLL) {
            handlerClone = $('#event-config .handler_scroll_temp').children().clone(true);
          } else if (a.action_event_type_id === Constant.ActionEventHandleType.CLICK) {
            handlerClone = $('#event-config .handler_click_temp').children().clone(true);
          }
          handlerParent = $("<div class='" + valueClassName + "' style='display:none'></div>");
          handlerParent.append(handlerClone);
          return handlerParent.appendTo(handler_forms);
        });
        actionParent.appendTo(action_forms);
      }
    }
    if (te_values != null) {
      return $(te_values).appendTo($('#event-config .value_forms'));
    }
  };

  return EventConfig;

})();

//# sourceMappingURL=event_config.js.map
