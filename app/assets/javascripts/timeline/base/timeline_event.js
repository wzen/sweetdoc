// Generated by CoffeeScript 1.9.2
var TimelineEvent;

TimelineEvent = (function() {
  var _scrollLength, constant;

  function TimelineEvent() {}

  if (typeof gon !== "undefined" && gon !== null) {
    constant = gon["const"];
    TimelineEvent.PageValueKey = (function() {
      function PageValueKey() {}

      PageValueKey.te = function(teNum) {
        return constant.PageValueKey.TE_PREFIX + constant.PageValueKey.PAGE_VALUES_SEPERATOR + Constant.PageValueKey.TE_NUM_PREFIX + teNum;
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

      PageValueKey.IS_CLICK_PARALLEL = 'is_click_parallel';

      PageValueKey.SCROLL_POINT_START = 'scroll_point_start';

      PageValueKey.SCROLL_POINT_END = 'scroll_point_end';

      PageValueKey.SCROLL_POINT_SEP = '-';

      return PageValueKey;

    })();
  }

  TimelineEvent.initCommonConfigValue = function(timelineConfig) {
    var end, endDiv, handlerDiv, s, start, startDiv;
    if (timelineConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
      handlerDiv = $('.handler_div', timelineConfig.emt);
      if (handlerDiv != null) {
        startDiv = handlerDiv.find('.scroll_point_start:first');
        start = startDiv.val();
        s = null;
        if (start.length === 0) {
          s = TimelineEvent.getAllScrollLength();
          startDiv.val(s);
          if (s === 0) {
            startDiv.prop("disabled", true);
          }
        }
        endDiv = handlerDiv.find('.scroll_point_end:first');
        end = endDiv.val();
        if (end.length === 0) {
          return endDiv.val(parseInt(s) + _scrollLength.call(this, timelineConfig));
        }
      }
    }
  };

  TimelineEvent.checkConfigValue = function(timelineConfig) {};

  TimelineEvent.writeToPageValue = function(timelineConfig) {
    var clickParallel, end, handlerDiv, isClickParallel, start, writeValue;
    writeValue = {};
    writeValue[this.PageValueKey.ID] = timelineConfig.id;
    writeValue[this.PageValueKey.ITEM_ID] = timelineConfig.itemId;
    writeValue[this.PageValueKey.COMMON_EVENT_ID] = timelineConfig.commonEventId;
    writeValue[this.PageValueKey.CHAPTER] = 1;
    writeValue[this.PageValueKey.SCREEN] = 1;
    writeValue[this.PageValueKey.IS_COMMON_EVENT] = timelineConfig.isCommonEvent;
    writeValue[this.PageValueKey.METHODNAME] = timelineConfig.methodName;
    writeValue[this.PageValueKey.ACTIONTYPE] = timelineConfig.actionType;
    if (timelineConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
      start = "";
      end = "";
      handlerDiv = $('.handler_div', timelineConfig.emt);
      if (handlerDiv != null) {
        start = handlerDiv.find('.scroll_point_start:first').val();
        end = handlerDiv.find('.scroll_point_end:first').val();
      }
      writeValue[this.PageValueKey.SCROLL_POINT_START] = start;
      writeValue[this.PageValueKey.SCROLL_POINT_END] = end;
    } else if (timelineConfig.actionType === Constant.ActionEventHandleType.CLICK) {
      isClickParallel = false;
      clickParallel = $('.handler_div .click_parallel', timelineConfig.emt);
      if (clickParallel != null) {
        isClickParallel = clickParallel.is(":checked");
      }
      writeValue[this.PageValueKey.IS_CLICK_PARALLEL] = isClickParallel;
    }
    return writeValue;
  };

  TimelineEvent.readFromPageValue = function(timelineConfig) {
    var clickParallel, end, handlerDiv, isClickParallel, start, writeValue;
    writeValue = getTimelinePageValue(this.PageValueKey.te(timelineConfig.teNum));
    if (writeValue != null) {
      timelineConfig.id = writeValue[this.PageValueKey.ID];
      timelineConfig.itemId = writeValue[this.PageValueKey.ITEM_ID];
      timelineConfig.commonEventId = writeValue[this.PageValueKey.COMMON_EVENT_ID];
      timelineConfig.isCommonEvent = writeValue[this.PageValueKey.IS_COMMON_EVENT];
      timelineConfig.methodName = writeValue[this.PageValueKey.METHODNAME];
      timelineConfig.actionType = writeValue[this.PageValueKey.ACTIONTYPE];
      if (timelineConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
        handlerDiv = $('.handler_div', timelineConfig.emt);
        start = writeValue[this.PageValueKey.SCROLL_POINT_START];
        end = writeValue[this.PageValueKey.SCROLL_POINT_END];
        if ((handlerDiv != null) && (start != null) && (end != null)) {
          handlerDiv.find('.scroll_point_start:first').val(start);
          handlerDiv.find('.scroll_point_end:first').val(end);
        }
      } else if (timelineConfig.actionType === Constant.ActionEventHandleType.CLICK) {
        clickParallel = $('.handler_div .click_parallel', timelineConfig.emt);
        isClickParallel = writeValue[this.PageValueKey.IS_CLICK_PARALLEL];
        if ((clickParallel != null) && isClickParallel) {
          clickParallel.prop("checked", true);
        }
      }
      return true;
    } else {
      return false;
    }
  };

  _scrollLength = function(timelineConfig) {
    var end, scrollPointDiv, start, writeValue;
    scrollPointDiv = $('.scroll_point_div', timelineConfig.emt);
    writeValue = getTimelinePageValue(this.PageValueKey.te(timelineConfig.teNum));
    if (writeValue != null) {
      start = writeValue[this.PageValueKey.SCROLL_POINT_START];
      end = writeValue[this.PageValueKey.SCROLL_POINT_END];
      if ((scrollPointDiv != null) && (start != null) && (end != null)) {
        return parseInt(end) - parseInt(start);
      }
    }
    return null;
  };

  TimelineEvent.getAllScrollLength = function() {
    var maxTeNum, ret, self;
    self = this;
    maxTeNum = 0;
    ret = null;
    $("#" + Constant.PageValueKey.TE_ROOT + " ." + Constant.PageValueKey.TE_PREFIX).children('div').each(function(e) {
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

  return TimelineEvent;

})();

//# sourceMappingURL=timeline_event.js.map
