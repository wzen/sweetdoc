// Generated by CoffeeScript 1.9.2
var EventPageValueBase;

EventPageValueBase = (function() {
  var constant;

  function EventPageValueBase() {}

  constant = gon["const"];

  EventPageValueBase.NO_METHOD = constant.EventPageValue.NO_METHOD;

  EventPageValueBase.NO_JUMPPAGE = constant.EventPageValue.NO_JUMPPAGE;

  EventPageValueBase.PageValueKey = (function() {
    function PageValueKey() {}

    PageValueKey.DIST_ID = constant.EventPageValueKey.DIST_ID;

    PageValueKey.ID = constant.EventPageValueKey.ID;

    PageValueKey.CLASS_DIST_TOKEN = constant.EventPageValueKey.CLASS_DIST_TOKEN;

    PageValueKey.ITEM_SIZE_DIFF = constant.EventPageValueKey.ITEM_SIZE_DIFF;

    PageValueKey.DO_FOCUS = constant.EventPageValueKey.DO_FOCUS;

    PageValueKey.SPECIFIC_METHOD_VALUES = constant.EventPageValueKey.SPECIFIC_METHOD_VALUES;

    PageValueKey.IS_COMMON_EVENT = constant.EventPageValueKey.IS_COMMON_EVENT;

    PageValueKey.ORDER = constant.EventPageValueKey.ORDER;

    PageValueKey.METHODNAME = constant.EventPageValueKey.METHODNAME;

    PageValueKey.ACTIONTYPE = constant.EventPageValueKey.ACTIONTYPE;

    PageValueKey.FINISH_PAGE = constant.EventPageValueKey.FINISH_PAGE;

    PageValueKey.JUMPPAGE_NUM = constant.EventPageValueKey.JUMPPAGE_NUM;

    PageValueKey.IS_SYNC = constant.EventPageValueKey.IS_SYNC;

    PageValueKey.SCROLL_POINT_START = constant.EventPageValueKey.SCROLL_POINT_START;

    PageValueKey.SCROLL_POINT_END = constant.EventPageValueKey.SCROLL_POINT_END;

    PageValueKey.SCROLL_ENABLED_DIRECTIONS = constant.EventPageValueKey.SCROLL_ENABLED_DIRECTIONS;

    PageValueKey.SCROLL_FORWARD_DIRECTIONS = constant.EventPageValueKey.SCROLL_FORWARD_DIRECTIONS;

    PageValueKey.CHANGE_FORKNUM = constant.EventPageValueKey.CHANGE_FORKNUM;

    PageValueKey.MODIFIABLE_VARS = constant.EventPageValueKey.MODIFIABLE_VARS;

    PageValueKey.EVENT_DURATION = constant.EventPageValueKey.EVENT_DURATION;

    return PageValueKey;

  })();

  EventPageValueBase.initConfigValue = function(eventConfig) {
    var _scrollLength, duration, end, endDiv, eventDuration, handlerDiv, item, s, start, startDiv;
    _scrollLength = function(eventConfig) {
      var end, start, writeValue;
      writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum));
      if (writeValue != null) {
        start = writeValue[this.PageValueKey.SCROLL_POINT_START];
        end = writeValue[this.PageValueKey.SCROLL_POINT_END];
        if ((start != null) && $.isNumeric(start) && (end != null) && $.isNumeric(end)) {
          return parseInt(end) - parseInt(start);
        }
      }
      return 0;
    };
    handlerDiv = $(".handler_div", eventConfig.emt);
    if (eventConfig[this.PageValueKey.ACTIONTYPE] === Constant.ActionType.SCROLL) {
      startDiv = handlerDiv.find('.scroll_point_start:first');
      start = startDiv.val();
      s = null;
      if (start.length === 0) {
        s = EventPageValueBase.getAllScrollLength();
        startDiv.val(s);
        if (s === 0) {
          startDiv.prop("disabled", true);
        }
      }
      endDiv = handlerDiv.find('.scroll_point_end:first');
      end = endDiv.val();
      if (end.length === 0) {
        return endDiv.val(parseInt(s) + _scrollLength.call(this, eventConfig));
      }
    } else if (eventConfig[this.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
      eventDuration = handlerDiv.find('.click_duration:first');
      item = window.instanceMap[eventConfig[this.PageValueKey.ID]];
      if (item != null) {
        duration = item.constructor.actionProperties.methods[eventConfig[this.PageValueKey.METHODNAME]][item.constructor.ActionPropertiesKey.EVENT_DURATION];
        if (duration == null) {
          duration = 0;
        }
        return eventDuration.val(duration);
      }
    }
  };

  EventPageValueBase.writeToPageValue = function(eventConfig) {
    var errorMes, k, ref, v, writeValue;
    errorMes = '';
    writeValue = {};
    ref = this.PageValueKey;
    for (k in ref) {
      v = ref[k];
      if (eventConfig[v] != null) {
        writeValue[v] = eventConfig[v];
      }
    }
    if (errorMes.length === 0) {
      PageValue.setEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum), writeValue);
      if (parseInt(PageValue.getEventPageValue(PageValue.Key.eventCount())) < eventConfig.teNum) {
        PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum);
      }
    }
    return errorMes;
  };

  EventPageValueBase.readFromPageValue = function(eventConfig) {
    var actionFormName, bottomEmt, className, duration, enabled, eventDuration, fn, handlerDiv, item, k, leftEmt, parallel, ref, rightEmt, selectItemValue, specificRoot, specificValues, topEmt, v, value, writeValue;
    writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum));
    if (writeValue != null) {
      ref = this.PageValueKey;
      for (k in ref) {
        v = ref[k];
        if (writeValue[v] != null) {
          eventConfig[v] = writeValue[v];
        }
      }
      eventConfig.constructor.addEventConfigContents(eventConfig[EventPageValueBase.PageValueKey.CLASS_DIST_TOKEN]);
      selectItemValue = "" + eventConfig[this.PageValueKey.ID] + EventConfig.EVENT_ITEM_SEPERATOR + eventConfig[this.PageValueKey.CLASS_DIST_TOKEN];
      eventConfig.constructor.setSelectItemValue($('.dropdown:first', eventConfig.emt), selectItemValue);
      actionFormName = EventConfig.ITEM_ACTION_CLASS.replace('@classdisttoken', eventConfig[this.PageValueKey.CLASS_DIST_TOKEN]);
      $("." + actionFormName + " .radio", eventConfig.emt).each(function(e) {
        var methodName;
        methodName = $(this).find('input.method_name').val();
        if (methodName === eventConfig[EventPageValueBase.PageValueKey.METHODNAME]) {
          return $(this).find('input[type=radio]').prop('checked', true);
        }
      });
      if ((eventConfig[this.PageValueKey.FINISH_PAGE] != null) && eventConfig[this.PageValueKey.FINISH_PAGE]) {
        $('.finish_page', eventConfig.emt).attr('checked', true);
      } else {
        $('.finish_page', eventConfig.emt).removeAttr('checked');
      }
      if (eventConfig[this.PageValueKey.JUMPPAGE_NUM] != null) {
        $('.finish_page_select', eventConfig.emt).val(eventConfig[this.PageValueKey.JUMPPAGE_NUM]);
      } else {
        $('.finish_page_select', eventConfig.emt).val(EventPageValueBase.NO_JUMPPAGE);
      }
      if (!eventConfig[this.PageValueKey.IS_COMMON_EVENT]) {
        if (eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].x) {
          $('.item_position_diff_x', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].x);
        }
        if (eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].y) {
          $('.item_position_diff_y', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].y);
        }
        if (eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].w) {
          $('.item_diff_width', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].w);
        }
        if (eventConfig[this.PageValueKey.ITEM_SIZE_DIFF] && eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].h) {
          $('.item_diff_height', eventConfig.emt).val(eventConfig[this.PageValueKey.ITEM_SIZE_DIFF].h);
        }
        if (eventConfig[this.PageValueKey.DO_FOCUS]) {
          $('.do_focus', eventConfig.emt).prop('checked', true);
        } else {
          $('.do_focus', eventConfig.emt).removeAttr('checked');
        }
      }
      parallel = $(".parallel_div .parallel", eventConfig.emt);
      if ((parallel != null) && eventConfig[this.PageValueKey.IS_SYNC]) {
        parallel.prop("checked", true);
      }
      handlerDiv = $(".handler_div", eventConfig.emt);
      if (eventConfig[this.PageValueKey.ACTIONTYPE] === Constant.ActionType.SCROLL) {
        handlerDiv.find('input[type=radio][value=scroll]').prop('checked', true);
        if ((eventConfig[this.PageValueKey.SCROLL_POINT_START] != null) && (eventConfig[this.PageValueKey.SCROLL_POINT_END] != null)) {
          handlerDiv.find('.scroll_point_start:first').val(eventConfig[this.PageValueKey.SCROLL_POINT_START]);
          handlerDiv.find('.scroll_point_end:first').val(eventConfig[this.PageValueKey.SCROLL_POINT_END]);
        }
        topEmt = handlerDiv.find('.scroll_enabled_top:first');
        if (topEmt != null) {
          topEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].top);
          if (eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].top) {
            topEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].top);
          } else {
            topEmt.children('.scroll_forward:first').prop("checked", false);
            topEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }
        bottomEmt = handlerDiv.find('scroll_enabled_bottom:first');
        if (bottomEmt != null) {
          bottomEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].bottom);
          if (eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].bottom) {
            bottomEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].bottom);
          } else {
            bottomEmt.children('.scroll_forward:first').prop("checked", false);
            bottomEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }
        leftEmt = handlerDiv.find('scroll_enabled_left:first');
        if (leftEmt != null) {
          leftEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].left);
          if (eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].left) {
            leftEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].left);
          } else {
            leftEmt.children('.scroll_forward:first').prop("checked", false);
            leftEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }
        rightEmt = handlerDiv.find('scroll_enabled_right:first');
        if (rightEmt != null) {
          rightEmt.children('.scroll_enabled:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].right);
          if (eventConfig[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS].right) {
            rightEmt.children('.scroll_forward:first').prop("checked", eventConfig[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS].right);
          } else {
            rightEmt.children('.scroll_forward:first').prop("checked", false);
            rightEmt.children('.scroll_forward:first').parent('label').hide();
          }
        }
      } else if (eventConfig[this.PageValueKey.ACTIONTYPE] === Constant.ActionType.CLICK) {
        handlerDiv.find('input[type=radio][value=click]').prop('checked', true);
        eventDuration = handlerDiv.find('.click_duration:first');
        if (eventConfig[this.PageValueKey.EVENT_DURATION] != null) {
          eventDuration.val(eventConfig[this.PageValueKey.EVENT_DURATION]);
        } else {
          item = window.instanceMap[eventConfig[this.PageValueKey.ID]];
          if (item != null) {
            duration = eventConfig[this.PageValueKey.EVENT_DURATION];
            if (duration == null) {
              duration = 0;
            }
            eventDuration.val(duration);
          }
        }
        enabled = (eventConfig[this.PageValueKey.CHANGE_FORKNUM] != null) && eventConfig[this.PageValueKey.CHANGE_FORKNUM] > 0;
        $('.enable_fork:first', handlerDiv).prop('checked', enabled);
        fn = enabled ? eventConfig[this.PageValueKey.CHANGE_FORKNUM] : 1;
        $('.fork_select:first', handlerDiv).val(Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', fn));
        $('.fork_select:first', handlerDiv).parent('div').css('display', enabled ? 'block' : 'none');
      }
      specificValues = eventConfig[this.PageValueKey.SPECIFIC_METHOD_VALUES];
      specificRoot = $(eventConfig.emt).find("." + (eventConfig.methodClassName()) + " ." + eventConfig.constructor.METHOD_VALUE_SPECIFIC_ROOT);
      if (specificValues != null) {
        for (className in specificValues) {
          value = specificValues[className];
          specificRoot.find("." + className + ":first").val(value);
        }
      }
      return true;
    } else {
      return false;
    }
  };

  EventPageValueBase.getAllScrollLength = function() {
    var maxTeNum, ret;
    maxTeNum = 0;
    ret = null;
    $("#" + PageValue.Key.E_ROOT + " ." + PageValue.Key.E_SUB_ROOT + " ." + (PageValue.Key.pageRoot())).children('div').each((function(_this) {
      return function(i, e) {
        var end, start, teNum;
        teNum = parseInt($(e).attr('class'));
        if (teNum > maxTeNum) {
          start = $(e).find("." + _this.PageValueKey.SCROLL_POINT_START + ":first").val();
          end = $(e).find("." + _this.PageValueKey.SCROLL_POINT_END + ":first").val();
          if ((start != null) && start !== "null" && (end != null) && end !== "null") {
            maxTeNum = teNum;
            return ret = end;
          }
        }
      };
    })(this));
    if (ret == null) {
      return 0;
    }
    return parseInt(ret);
  };

  return EventPageValueBase;

})();

//# sourceMappingURL=base.js.map
