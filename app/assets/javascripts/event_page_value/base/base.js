// Generated by CoffeeScript 1.9.2
var EventPageValueBase;

EventPageValueBase = (function() {
  var _scrollLength, constant;

  function EventPageValueBase() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    EventPageValueBase.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.te = function(teNum) {
        return constant.PageValueKey.E_PREFIX + constant.PageValueKey.PAGE_VALUES_SEPERATOR + PageValue.Key.E_NUM_PREFIX + teNum;
      };

      PageValueKey.ID = 'id';

      PageValueKey.ITEM_ID = 'item_id';

      PageValueKey.COMMON_EVENT_ID = 'common_event_id';

      PageValueKey.VALUE = 'value';

      PageValueKey.CHAPTER = 'chapter';

      PageValueKey.SCREEN = 'screen';

      PageValueKey.IS_COMMON_EVENT = 'is_common_event';

      PageValueKey.ORDER = 'order';

      PageValueKey.METHODNAME = 'methodname';

      PageValueKey.ACTIONTYPE = 'actiontype';

      PageValueKey.ANIAMTIONTYPE = 'animationtype';

      PageValueKey.IS_PARALLEL = 'is_parallel';

      PageValueKey.SCROLL_POINT_START = 'scroll_point_start';

      PageValueKey.SCROLL_POINT_END = 'scroll_point_end';

      return PageValueKey;

    })();
  }

  EventPageValueBase.initConfigValue = function(eventConfig) {
    var end, endDiv, handlerDiv, s, start, startDiv;
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

  EventPageValueBase.checkConfigValue = function(eventConfig) {};

  EventPageValueBase.writeToPageValue = function(eventConfig) {
    var writeValue;
    writeValue = {};
    writeValue[this.PageValueKey.ID] = eventConfig.id;
    writeValue[this.PageValueKey.ITEM_ID] = eventConfig.itemId;
    writeValue[this.PageValueKey.COMMON_EVENT_ID] = eventConfig.commonEventId;
    writeValue[this.PageValueKey.CHAPTER] = 1;
    writeValue[this.PageValueKey.SCREEN] = 1;
    writeValue[this.PageValueKey.IS_COMMON_EVENT] = eventConfig.isCommonEvent;
    writeValue[this.PageValueKey.METHODNAME] = eventConfig.methodName;
    writeValue[this.PageValueKey.ACTIONTYPE] = eventConfig.actionType;
    writeValue[this.PageValueKey.ANIAMTIONTYPE] = eventConfig.animationType;
    writeValue[this.PageValueKey.IS_PARALLEL] = eventConfig.isParallel;
    if (eventConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
      writeValue[this.PageValueKey.SCROLL_POINT_START] = eventConfig.scrollPointStart;
      writeValue[this.PageValueKey.SCROLL_POINT_END] = eventConfig.scrollPointEnd;
    }
    return writeValue;
  };

  EventPageValueBase.readFromPageValue = function(eventConfig) {
    var end, handlerDiv, isParallel, parallel, start, writeValue;
    writeValue = PageValue.getEventPageValue(this.PageValueKey.te(eventConfig.teNum));
    if (writeValue != null) {
      eventConfig.id = writeValue[this.PageValueKey.ID];
      eventConfig.itemId = writeValue[this.PageValueKey.ITEM_ID];
      eventConfig.commonEventId = writeValue[this.PageValueKey.COMMON_EVENT_ID];
      eventConfig.isCommonEvent = writeValue[this.PageValueKey.IS_COMMON_EVENT];
      eventConfig.methodName = writeValue[this.PageValueKey.METHODNAME];
      eventConfig.actionType = writeValue[this.PageValueKey.ACTIONTYPE];
      eventConfig.animationType = writeValue[this.PageValueKey.ANIAMTIONTYPE];
      parallel = $(".parallel_div .parallel", eventConfig.emt);
      isParallel = writeValue[this.PageValueKey.IS_PARALLEL];
      if ((parallel != null) && isParallel) {
        parallel.prop("checked", true);
      }
      if (eventConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
        handlerDiv = $(".handler_div ." + (eventConfig.methodClassName()), eventConfig.emt);
        start = writeValue[this.PageValueKey.SCROLL_POINT_START];
        end = writeValue[this.PageValueKey.SCROLL_POINT_END];
        if ((handlerDiv != null) && (start != null) && (end != null)) {
          handlerDiv.find('.scroll_point_start:first').val(start);
          handlerDiv.find('.scroll_point_end:first').val(end);
        }
      }
      return true;
    } else {
      return false;
    }
  };

  _scrollLength = function(eventConfig) {
    var end, start, writeValue;
    writeValue = PageValue.getEventPageValue(this.PageValueKey.te(eventConfig.teNum));
    if (writeValue != null) {
      start = writeValue[this.PageValueKey.SCROLL_POINT_START];
      end = writeValue[this.PageValueKey.SCROLL_POINT_END];
      if ((start != null) && $.isNumeric(start) && (end != null) && $.isNumeric(end)) {
        return parseInt(end) - parseInt(start);
      }
    }
    return 0;
  };

  EventPageValueBase.getAllScrollLength = function() {
    var maxTeNum, ret, self;
    self = this;
    maxTeNum = 0;
    ret = null;
    $("#" + PageValue.Key.E_ROOT + " ." + PageValue.Key.E_PREFIX).children('div').each(function(e) {
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
    return ret;
  };

  return EventPageValueBase;

})();

//# sourceMappingURL=base.js.map
