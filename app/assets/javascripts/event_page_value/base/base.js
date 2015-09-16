// Generated by CoffeeScript 1.9.2
var EventPageValueBase;

EventPageValueBase = (function() {
  var constant;

  function EventPageValueBase() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    EventPageValueBase.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.ID = constant.EventPageValueKey.ID;

      PageValueKey.ITEM_ID = constant.EventPageValueKey.ITEM_ID;

      PageValueKey.COMMON_EVENT_ID = constant.EventPageValueKey.COMMON_EVENT_ID;

      PageValueKey.VALUE = constant.EventPageValueKey.VALUE;

      PageValueKey.IS_COMMON_EVENT = constant.EventPageValueKey.IS_COMMON_EVENT;

      PageValueKey.ORDER = constant.EventPageValueKey.ORDER;

      PageValueKey.METHODNAME = constant.EventPageValueKey.METHODNAME;

      PageValueKey.ACTIONTYPE = constant.EventPageValueKey.ACTIONTYPE;

      PageValueKey.ANIAMTIONTYPE = constant.EventPageValueKey.ANIAMTIONTYPE;

      PageValueKey.IS_SYNC = constant.EventPageValueKey.IS_SYNC;

      PageValueKey.SCROLL_POINT_START = constant.EventPageValueKey.SCROLL_POINT_START;

      PageValueKey.SCROLL_POINT_END = constant.EventPageValueKey.SCROLL_POINT_END;

      PageValueKey.SCROLL_ENABLED_DIRECTIONS = constant.EventPageValueKey.SCROLL_ENABLED_DIRECTIONS;

      PageValueKey.SCROLL_FORWARD_DIRECTIONS = constant.EventPageValueKey.SCROLL_FORWARD_DIRECTIONS;

      PageValueKey.FORKNUM = constant.EventPageValueKey.FORKNUM;

      return PageValueKey;

    })();
  }

  EventPageValueBase.initConfigValue = function(eventConfig) {
    var _scrollLength, end, endDiv, handlerDiv, s, start, startDiv;
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
    if (eventConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
      handlerDiv = $(".handler_div ." + (eventConfig.methodClassName()), eventConfig.emt);
      if (handlerDiv != null) {
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
      }
    }
  };

  EventPageValueBase.writeToPageValue = function(eventConfig) {
    var writeValue;
    writeValue = {};
    writeValue[this.PageValueKey.ID] = eventConfig.id;
    writeValue[this.PageValueKey.ITEM_ID] = eventConfig.itemId;
    writeValue[this.PageValueKey.COMMON_EVENT_ID] = eventConfig.commonEventId;
    writeValue[this.PageValueKey.IS_COMMON_EVENT] = eventConfig.isCommonEvent;
    writeValue[this.PageValueKey.METHODNAME] = eventConfig.methodName;
    writeValue[this.PageValueKey.ACTIONTYPE] = eventConfig.actionType;
    writeValue[this.PageValueKey.ANIAMTIONTYPE] = eventConfig.animationType;
    writeValue[this.PageValueKey.IS_SYNC] = eventConfig.isParallel;
    if (eventConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
      writeValue[this.PageValueKey.SCROLL_POINT_START] = eventConfig.scrollPointStart;
      writeValue[this.PageValueKey.SCROLL_POINT_END] = eventConfig.scrollPointEnd;
      writeValue[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = eventConfig.scrollEnabledDirection;
      writeValue[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = eventConfig.scrollForwardDirection;
    } else if (eventConfig.actionType === Constant.ActionEventHandleType.CLICK) {
      writeValue[this.PageValueKey.FORKNUM] = eventConfig.forkNum;
    }
    return writeValue;
  };

  EventPageValueBase.readFromPageValue = function(eventConfig) {
    var bottomEmt, enabled, enabledDirection, end, fn, forkNum, forwardDirection, handlerDiv, isParallel, leftEmt, parallel, rightEmt, start, topEmt, writeValue;
    writeValue = PageValue.getEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum));
    if (writeValue != null) {
      eventConfig.id = writeValue[this.PageValueKey.ID];
      eventConfig.itemId = writeValue[this.PageValueKey.ITEM_ID];
      eventConfig.commonEventId = writeValue[this.PageValueKey.COMMON_EVENT_ID];
      eventConfig.isCommonEvent = writeValue[this.PageValueKey.IS_COMMON_EVENT];
      eventConfig.methodName = writeValue[this.PageValueKey.METHODNAME];
      eventConfig.actionType = writeValue[this.PageValueKey.ACTIONTYPE];
      eventConfig.animationType = writeValue[this.PageValueKey.ANIAMTIONTYPE];
      parallel = $(".parallel_div .parallel", eventConfig.emt);
      isParallel = writeValue[this.PageValueKey.IS_SYNC];
      if ((parallel != null) && isParallel) {
        parallel.prop("checked", true);
      }
      if (eventConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
        handlerDiv = $(".handler_div ." + (eventConfig.methodClassName()), eventConfig.emt);
        if (handlerDiv != null) {
          start = writeValue[this.PageValueKey.SCROLL_POINT_START];
          end = writeValue[this.PageValueKey.SCROLL_POINT_END];
          if ((start != null) && (end != null)) {
            handlerDiv.find('.scroll_point_start:first').val(start);
            handlerDiv.find('.scroll_point_end:first').val(end);
          }
          enabledDirection = writeValue[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS];
          forwardDirection = writeValue[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS];
          topEmt = handlerDiv.find('.scroll_enabled_top:first');
          if (topEmt != null) {
            topEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.top);
            if (enabledDirection.top) {
              topEmt.children('.scroll_forward:first').prop("checked", forwardDirection.top);
            } else {
              topEmt.children('.scroll_forward:first').prop("checked", false);
              topEmt.children('.scroll_forward:first').parent('label').css('display', 'none');
            }
          }
          bottomEmt = handlerDiv.find('scroll_enabled_bottom:first');
          if (bottomEmt != null) {
            bottomEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.bottom);
            if (enabledDirection.bottom) {
              bottomEmt.children('.scroll_forward:first').prop("checked", forwardDirection.bottom);
            } else {
              bottomEmt.children('.scroll_forward:first').prop("checked", false);
              bottomEmt.children('.scroll_forward:first').parent('label').css('display', 'none');
            }
          }
          leftEmt = handlerDiv.find('scroll_enabled_left:first');
          if (leftEmt != null) {
            leftEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.left);
            if (enabledDirection.left) {
              leftEmt.children('.scroll_forward:first').prop("checked", forwardDirection.left);
            } else {
              leftEmt.children('.scroll_forward:first').prop("checked", false);
              leftEmt.children('.scroll_forward:first').parent('label').css('display', 'none');
            }
          }
          rightEmt = handlerDiv.find('scroll_enabled_right:first');
          if (rightEmt != null) {
            rightEmt.children('.scroll_enabled:first').prop("checked", enabledDirection.right);
            if (enabledDirection.right) {
              rightEmt.children('.scroll_forward:first').prop("checked", forwardDirection.right);
            } else {
              rightEmt.children('.scroll_forward:first').prop("checked", false);
              rightEmt.children('.scroll_forward:first').parent('label').css('display', 'none');
            }
          }
        }
      } else if (eventConfig.actionType === Constant.ActionEventHandleType.CLICK) {
        handlerDiv = $(".handler_div ." + (eventConfig.methodClassName()), eventConfig.emt);
        if (handlerDiv != null) {
          forkNum = writeValue[this.PageValueKey.FORKNUM];
          enabled = (forkNum != null) && forkNum > 0;
          $('.enable_fork:first', handlerDiv).prop('checked', enabled);
          fn = enabled ? forkNum : 1;
          $('.fork_select:first', handlerDiv).val(Constant.Paging.NAV_MENU_FORK_CLASS.replace('@forknum', fn));
          $('.fork_select:first', handlerDiv).parent('div').css('display', enabled ? 'block' : 'none');
        }
      }
      return true;
    } else {
      return false;
    }
  };

  EventPageValueBase.getAllScrollLength = function() {
    var maxTeNum, ret, self;
    self = this;
    maxTeNum = 0;
    ret = null;
    $("#" + PageValue.Key.E_ROOT + " ." + PageValue.Key.E_SUB_ROOT + " ." + (PageValue.Key.pageRoot())).children('div').each(function(e) {
      var end, start, teNum;
      teNum = parseInt($(this).attr('class'));
      if (teNum > maxTeNum) {
        start = $(this).find("." + self.PageValueKey.SCROLL_POINT_START + ":first").val();
        end = $(this).find("." + self.PageValueKey.SCROLL_POINT_END + ":first").val();
        if ((start != null) && start !== "null" && (end != null) && end !== "null") {
          maxTeNum = teNum;
          return ret = end;
        }
      }
    });
    if (ret == null) {
      return 0;
    }
    return parseInt(ret);
  };

  return EventPageValueBase;

})();

//# sourceMappingURL=base.js.map
