// Generated by CoffeeScript 1.9.2
var TimelineConfig;

TimelineConfig = (function() {
  var _setApplyClickEvent, _setMethodActionEvent, _setupFromPageValues, _timelineEvent;

  if (typeof gon !== "undefined" && gon !== null) {
    TimelineConfig.ITEM_ROOT_ID = 'timeline_event_@te_num';
    TimelineConfig.COMMON_ACTION_CLASS = constant.ElementAttribute.COMMON_ACTION_CLASS;
    TimelineConfig.ITEM_ACTION_CLASS = constant.ElementAttribute.ITEM_ACTION_CLASS;
    TimelineConfig.COMMON_VALUES_CLASS = constant.ElementAttribute.COMMON_VALUES_CLASS;
    TimelineConfig.ITEM_VALUES_CLASS = constant.ElementAttribute.ITEM_VALUES_CLASS;
  }

  function TimelineConfig(emt, teNum) {
    this.emt = emt;
    this.teNum = teNum;
    _setupFromPageValues.call(this);
  }

  TimelineConfig.prototype.setupConfigValues = function() {
    var actionFormName, selectItemValue, self;
    self = this;
    selectItemValue = '';
    if (this.isCommonEvent) {
      selectItemValue = "" + Constant.TIMELINE_COMMON_PREFIX + this.commonEventId;
    } else {
      selectItemValue = "" + this.id + Constant.TIMELINE_ITEM_SEPERATOR + this.itemId;
    }
    $('.te_item_select', this.emt).val(selectItemValue);
    actionFormName = '';
    if (this.isCommonEvent) {
      actionFormName = Constant.TIMELINE_COMMON_PREFIX + this.commonEventId;
    } else {
      actionFormName = TimelineConfig.ITEM_ACTION_CLASS.replace('@itemid', this.itemId);
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

  TimelineConfig.prototype.selectItem = function(e) {
    var checkedRadioButton, commonEvent, displayClassName, splitValues, vEmt, value;
    if (e == null) {
      e = null;
    }
    if (e != null) {
      value = $(e).val();
      if (value === "") {
        $(".config.te_div", this.emt).css('display', 'none');
        return;
      }
      this.isCommonEvent = value.indexOf(Constant.TIMELINE_COMMON_PREFIX) === 0;
      if (this.isCommonEvent) {
        this.commonEventId = parseInt(value.substring(Constant.TIMELINE_COMMON_PREFIX.length));
        commonEvent = getClassFromMap(true, this.commonEventId);
        this.id = (new commonEvent()).id;
      } else {
        splitValues = value.split(Constant.TIMELINE_ITEM_SEPERATOR);
        this.id = splitValues[0];
        this.itemId = splitValues[1];
      }
    }
    clearSelectedBorder();
    if (!this.isCommonEvent) {
      vEmt = $('#' + this.id);
      setSelectedBorder(vEmt, 'timeline');
      focusToTarget(vEmt);
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

  TimelineConfig.prototype.clickMethod = function(e) {
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
      beforeActionType = getTimelinePageValue(TimelineEvent.PageValueKey.te(this.teNum - 1))[TimelineEvent.PageValueKey.ACTIONTYPE];
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
      tle = _timelineEvent.call(this);
      if ((tle != null) && (tle.initConfigValue != null)) {
        tle.initConfigValue(this);
      }
    }
    return _setApplyClickEvent.call(this);
  };

  TimelineConfig.prototype.resetAction = function() {
    return _setupFromPageValues.call(this);
  };

  TimelineConfig.prototype.applyAction = function() {
    var errorMes, handlerDiv, item, parallel;
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
    errorMes = this.writeToPageValue();
    if ((errorMes != null) && errorMes.length > 0) {
      this.showError(errorMes);
      return;
    }
    changeTimelineColor(this.teNum, this.actionType);
    item = createdObject[this.id];
    if ((item != null) && (item.preview != null)) {
      return item.preview(getTimelinePageValue(TimelineEvent.PageValueKey.te(this.teNum)));
    }
  };

  TimelineConfig.prototype.writeToPageValue = function() {
    var errorMes, tle, writeValue;
    errorMes = "Not implemented";
    writeValue = null;
    tle = _timelineEvent.call(this);
    if (tle != null) {
      errorMes = tle.writeToPageValue(this);
    }
    return errorMes;
  };

  TimelineConfig.prototype.readFromPageValue = function() {
    var tle;
    if (TimelineEvent.readFromPageValue(this)) {
      tle = _timelineEvent.call(this);
      if (tle != null) {
        return tle.readFromPageValue(this);
      }
    }
    return false;
  };

  TimelineConfig.prototype.methodClassName = function() {
    if (this.isCommonEvent) {
      return this.constructor.COMMON_VALUES_CLASS.replace('@commoneventid', this.commonEventId).replace('@methodname', this.methodName);
    } else {
      return this.constructor.ITEM_VALUES_CLASS.replace('@itemid', this.itemId).replace('@methodname', this.methodName);
    }
  };

  TimelineConfig.prototype.showError = function(message) {
    var timelineConfigError;
    timelineConfigError = $('.timeline_config_error', this.emt);
    timelineConfigError.find('p').html(message);
    return timelineConfigError.css('display', '');
  };

  TimelineConfig.prototype.clearError = function() {
    var timelineConfigError;
    timelineConfigError = $('.timeline_config_error', this.emt);
    timelineConfigError.find('p').html('');
    return timelineConfigError.css('display', 'none');
  };

  _timelineEvent = function() {
    if (this.isCommonEvent === null) {
      return null;
    }
    if (this.isCommonEvent) {
      if (this.commonEventId === Constant.CommonActionEventChangeType.BACKGROUND) {
        return TLEBackgroundColorChange;
      } else if (this.commonEventId === Constant.CommonActionEventChangeType.SCREEN) {
        return TLEScreenPositionChange;
      }
    } else {
      return TLEItemChange;
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
      return setupTimelineEventConfig();
    });
    em = $('.push.button.cancel', this.emt);
    em.off('click');
    return em.on('click', function(e) {
      self.clearError();
      e = $(this).closest('.event');
      $('.values', e).html('');
      return closeSidebar(function() {
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

  return TimelineConfig;

})();

//# sourceMappingURL=timeline_config.js.map