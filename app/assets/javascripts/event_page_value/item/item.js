// Generated by CoffeeScript 1.9.2
var EPVItem,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

EPVItem = (function(superClass) {
  extend(EPVItem, superClass);

  function EPVItem() {
    return EPVItem.__super__.constructor.apply(this, arguments);
  }

  EPVItem.itemSize = 'item_size';

  EPVItem.initConfigValue = function(eventConfig, item) {
    return EPVItem.__super__.constructor.initConfigValue.call(this, eventConfig);
  };

  EPVItem.writeDefaultToPageValue = function(item) {
    var actionType, end, errorMes, start, teNum, writeValue;
    errorMes = "";
    writeValue = {};
    writeValue[this.PageValueKey.DIST_ID] = Common.generateId();
    writeValue[this.PageValueKey.ID] = item.id;
    writeValue[this.PageValueKey.ITEM_ID] = item.constructor.ITEM_ID;
    writeValue[this.PageValueKey.ITEM_SIZE_DIFF] = item.itemSizeDiff;
    writeValue[this.PageValueKey.COMMON_EVENT_ID] = null;
    writeValue[this.PageValueKey.IS_COMMON_EVENT] = false;
    writeValue[this.PageValueKey.METHODNAME] = item.constructor.defaultMethodName();
    actionType = item.constructor.defaultActionType();
    writeValue[this.PageValueKey.ACTIONTYPE] = actionType;
    start = this.getAllScrollLength();
    end = start + item.coodRegist.length;
    if (start > end) {
      start = null;
      end = null;
    }
    writeValue[this.PageValueKey.SCROLL_POINT_START] = start;
    writeValue[this.PageValueKey.SCROLL_POINT_END] = end;
    writeValue[this.PageValueKey.IS_SYNC] = false;
    writeValue[this.PageValueKey.SCROLL_ENABLED_DIRECTIONS] = item.constructor.defaultScrollEnabledDirection();
    writeValue[this.PageValueKey.SCROLL_FORWARD_DIRECTIONS] = item.constructor.defaultScrollForwardDirection();
    writeValue[this.PageValueKey.EVENT_DURATION] = item.constructor.defaultClickDuration();
    writeValue[this.PageValueKey.VALUE] = item.constructor.defaultEventConfigValue();
    writeValue[this.PageValueKey.MODIFIABLE_VARS] = {};
    if (errorMes.length === 0) {
      teNum = PageValue.getEventPageValue(PageValue.Key.eventCount());
      if (teNum != null) {
        teNum = parseInt(teNum) + 1;
      } else {
        teNum = 1;
      }
      PageValue.setEventPageValue(PageValue.Key.eventNumber(teNum), writeValue);
      PageValue.setEventPageValue(PageValue.Key.eventCount(), teNum);
      LocalStorage.saveAllPageValues();
    }
    return errorMes;
  };

  EPVItem.writeToPageValue = function(eventConfig) {
    var errorMes, item, value, writeValue;
    errorMes = "";
    writeValue = EPVItem.__super__.constructor.writeToPageValue.call(this, eventConfig);
    if (errorMes.length === 0) {
      item = instanceMap[eventConfig.id];
      value = item.eventConfigValue();
      writeValue[this.PageValueKey.VALUE] = value;
      PageValue.setEventPageValue(PageValue.Key.eventNumber(eventConfig.teNum), writeValue);
      if (parseInt(PageValue.getEventPageValue(PageValue.Key.eventCount())) < eventConfig.teNum) {
        PageValue.setEventPageValue(PageValue.Key.eventCount(), eventConfig.teNum);
      }
      LocalStorage.saveAllPageValues();
    }
    return errorMes;
  };

  EPVItem.readFromPageValue = function(eventConfig, item) {
    var ret;
    ret = EPVItem.__super__.constructor.readFromPageValue.call(this, eventConfig);
    return ret;
  };

  return EPVItem;

})(EventPageValueBase);

//# sourceMappingURL=item.js.map
