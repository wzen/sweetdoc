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

      PageValueKey.SCROLL_POINT = 'scroll_point';

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
    var clickParallel, end, isClickParallel, scrollPoint, scrollPointDiv, start, writeValue;
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
      scrollPoint = "";
      scrollPointDiv = $('.scroll_point_div', timelineConfig.emt);
      if (scrollPointDiv != null) {
        start = scrollPointDiv.find('.scroll_point_start:first').val();
        end = scrollPointDiv.find('.scroll_point_end:first').val();
        scrollPoint = start + this.PageValueKey.SCROLL_POINT_SEP + end;
      }
      writeValue[this.PageValueKey.SCROLL_POINT] = scrollPoint;
    } else if (timelineConfig.actionType === Constant.ActionEventHandleType.CLICK) {
      isClickParallel = false;
      clickParallel = $('.click_parallel_div .click_parallel', timelineConfig.emt);
      if (clickParallel != null) {
        isClickParallel = clickParallel.is(":checked");
      }
      writeValue[this.PageValueKey.IS_CLICK_PARALLEL] = isClickParallel;
    }
    return writeValue;
  };

  TimelineEvent.readFromPageValue = function(timelineConfig) {
    var clickParallel, end, isClickParallel, s, scrollPoint, scrollPointDiv, start, writeValue;
    writeValue = getTimelinePageValue(this.PageValueKey.te(timelineConfig.teNum));
    if (writeValue != null) {
      timelineConfig.id = writeValue[this.PageValueKey.ID];
      timelineConfig.itemId = writeValue[this.PageValueKey.ITEM_ID];
      timelineConfig.commonEventId = writeValue[this.PageValueKey.COMMON_EVENT_ID];
      timelineConfig.isCommonEvent = writeValue[this.PageValueKey.IS_COMMON_EVENT];
      timelineConfig.methodName = writeValue[this.PageValueKey.METHODNAME];
      timelineConfig.actionType = writeValue[this.PageValueKey.ACTIONTYPE];
      if (timelineConfig.actionType === Constant.ActionEventHandleType.SCROLL) {
        scrollPointDiv = $('.scroll_point_div', timelineConfig.emt);
        scrollPoint = writeValue[this.PageValueKey.SCROLL_POINT];
        if ((scrollPointDiv != null) && (scrollPoint != null)) {
          s = scrollPoint.split(this.PageValueKey.SCROLL_POINT_SEP);
          start = s[0];
          end = s[1];
          scrollPointDiv.find('.scroll_point_start:first').val(start);
          scrollPointDiv.find('.scroll_point_end:first').val(end);
        }
      } else if (timelineConfig.actionType === Constant.ActionEventHandleType.CLICK) {
        clickParallel = $('.click_parallel_div .click_parallel', timelineConfig.emt);
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
    var end, s, scrollPoint, scrollPointDiv, start, writeValue;
    scrollPointDiv = $('.scroll_point_div', timelineConfig.emt);
    writeValue = getTimelinePageValue(this.PageValueKey.te(timelineConfig.teNum));
    if (writeValue != null) {
      scrollPoint = writeValue[this.PageValueKey.SCROLL_POINT];
      if ((scrollPointDiv != null) && (scrollPoint != null)) {
        s = scrollPoint.split(this.PageValueKey.SCROLL_POINT_SEP);
        start = s[0];
        end = s[1];
        return parseInt(end) - parseInt(start);
      }
    }
    return null;
  };

  TimelineEvent.getAllScrollLength = function() {
    var maxTeNum, s, scrollEnd, scrollPoint, self;
    self = this;
    maxTeNum = 0;
    scrollPoint = null;
    $("#" + Constant.PageValueKey.TE_ROOT + " ." + Constant.PageValueKey.TE_PREFIX).children('div').each(function(e) {
      var sp, teNum;
      teNum = parseInt($(this).attr('class'));
      if (teNum > maxTeNum) {
        sp = $(this).find("." + self.PageValueKey.SCROLL_POINT + ":first").val();
        if ((sp != null) && sp !== "null") {
          maxTeNum = teNum;
          return scrollPoint = sp;
        }
      }
    });
    if (scrollPoint == null) {
      return 0;
    }
    s = scrollPoint.split(this.PageValueKey.SCROLL_POINT_SEP);
    scrollEnd = parseInt(s[1]);
    return scrollEnd;
  };

  return TimelineEvent;

})();

//# sourceMappingURL=timeline_event.js.map
