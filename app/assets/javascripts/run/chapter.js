// Generated by CoffeeScript 1.9.2
var Chapter;

Chapter = (function() {
  Chapter.guideTimer = null;

  function Chapter(list) {
    var classMapId, event, i, id, isCommonEvent, len, obj, ref;
    this.eventList = list.eventList;
    this.num = list.num;
    this.eventObjList = [];
    ref = this.eventList;
    for (i = 0, len = ref.length; i < len; i++) {
      obj = ref[i];
      isCommonEvent = obj[EventPageValueBase.PageValueKey.IS_COMMON_EVENT];
      id = obj[EventPageValueBase.PageValueKey.ID];
      classMapId = isCommonEvent ? obj[EventPageValueBase.PageValueKey.COMMON_EVENT_ID] : obj[EventPageValueBase.PageValueKey.ITEM_ID];
      event = Common.getInstanceFromMap(isCommonEvent, id, classMapId);
      this.eventObjList.push(event);
    }
    this.doMoveChapter = false;
  }

  Chapter.prototype.willChapter = function() {
    var event, i, idx, len, ref;
    ref = this.eventObjList;
    for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
      event = ref[idx];
      event.initEvent(this.eventList[idx]);
      event.willChapter();
      this.doMoveChapter = false;
    }
    this.floatScrollHandleCanvas();
    return this.focusToActorIfNeed(false);
  };

  Chapter.prototype.didChapter = function() {
    return this.eventObjList.forEach(function(event) {
      return event.didChapter();
    });
  };

  Chapter.prototype.focusToActorIfNeed = function(isImmediate, type) {
    var item;
    if (type == null) {
      type = "center";
    }
    window.disabledEventHandler = true;
    item = null;
    this.eventObjList.forEach((function(_this) {
      return function(e, idx) {
        if (_this.eventList[idx][EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false) {
          item = e;
          return false;
        }
      };
    })(this));
    if (item != null) {
      if (type === 'center') {
        return Common.focusToTarget(item.getJQueryElement(), function() {
          return window.disabledEventHandler = false;
        }, isImmediate);
      }
    } else {
      return window.disabledEventHandler = false;
    }
  };

  Chapter.prototype.floatAllChapterEvents = function() {
    window.scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.off);
    window.scrollContents.css('z-index', scrollViewSwitchZindex.on);
    return this.eventObjList.forEach(function(e) {
      if (e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false) {
        return e.getJQueryElement().css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTFLOAT));
      }
    });
  };

  Chapter.prototype.floatScrollHandleCanvas = function() {
    window.scrollHandleWrapper.css('z-index', scrollViewSwitchZindex.on);
    window.scrollContents.css('z-index', scrollViewSwitchZindex.off);
    return this.eventObjList.forEach((function(_this) {
      return function(e) {
        if (e.event[EventPageValueBase.PageValueKey.IS_COMMON_EVENT] === false) {
          return e.getJQueryElement().css('z-index', Common.plusPagingZindex(Constant.Zindex.EVENTBOTTOM + _this.num));
        }
      };
    })(this));
  };

  Chapter.prototype.resetAllEvents = function(takeStateCapture) {
    if (takeStateCapture == null) {
      takeStateCapture = false;
    }
    return this.eventObjList.forEach((function(_this) {
      return function(e) {
        if (takeStateCapture && e instanceof ItemBase) {
          e.takeCaptureInstanceState(false);
        }
        return e.resetEvent();
      };
    })(this));
  };

  Chapter.prototype.forwardAllEvents = function() {
    return this.eventObjList.forEach((function(_this) {
      return function(e) {
        return e.forwardEvent();
      };
    })(this));
  };

  Chapter.prototype.showGuide = function(calledByWillChapter) {
    if (calledByWillChapter == null) {
      calledByWillChapter = false;
    }
    return RunSetting.isShowGuide();
  };

  return Chapter;

})();

//# sourceMappingURL=chapter.js.map
