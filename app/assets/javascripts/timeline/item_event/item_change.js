// Generated by CoffeeScript 1.9.2
var TLEItemChange,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

TLEItemChange = (function(superClass) {
  extend(TLEItemChange, superClass);

  function TLEItemChange() {
    return TLEItemChange.__super__.constructor.apply(this, arguments);
  }

  TLEItemChange.minObj = 'item_minobj';

  TLEItemChange.itemSize = 'item_size';

  TLEItemChange.initConfigValue = function(timelineConfig, item) {
    return TLEItemChange.__super__.constructor.initConfigValue.call(this, timelineConfig);
  };

  TLEItemChange.writeDefaultToPageValue = function(item) {
    var actionType, end, errorMes, itemWriteValue, start, teNum, value, writeValue;
    errorMes = "";
    writeValue = {};
    writeValue[this.PageValueKey.ID] = item.id;
    writeValue[this.PageValueKey.ITEM_ID] = item.constructor.ITEM_ID;
    writeValue[this.PageValueKey.COMMON_EVENT_ID] = null;
    writeValue[this.PageValueKey.CHAPTER] = 1;
    writeValue[this.PageValueKey.CHAPTER] = 1;
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
    writeValue[this.PageValueKey.IS_PARALLEL] = false;
    itemWriteValue = item.objWriteTimeline();
    $.extend(writeValue, itemWriteValue);
    if (errorMes.length === 0) {
      value = item.constructor.timelineDefaultConfigValue();
      writeValue[this.PageValueKey.VALUE] = value;
      teNum = getTimelinePageValue(Constant.PageValueKey.TE_COUNT);
      if (teNum != null) {
        teNum = parseInt(teNum) + 1;
      } else {
        teNum = 1;
      }
      setTimelinePageValue(this.PageValueKey.te(teNum), writeValue, teNum);
      setTimelinePageValue(Constant.PageValueKey.TE_COUNT, teNum);
      changeTimelineColor(teNum, actionType);
    }
    return errorMes;
  };

  TLEItemChange.writeToPageValue = function(timelineConfig) {
    var errorMes, item, itemWriteValue, value, writeValue;
    errorMes = "";
    writeValue = TLEItemChange.__super__.constructor.writeToPageValue.call(this, timelineConfig);
    item = createdObject[timelineConfig.id];
    itemWriteValue = item.objWriteTimeline();
    $.extend(writeValue, itemWriteValue);
    if (errorMes.length === 0) {
      value = item.timelineConfigValue();
      writeValue[this.PageValueKey.VALUE] = value;
      setTimelinePageValue(this.PageValueKey.te(timelineConfig.teNum), writeValue, timelineConfig.teNum);
      if (parseInt(getTimelinePageValue(Constant.PageValueKey.TE_COUNT)) < timelineConfig.teNum) {
        setTimelinePageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum);
      }
    }
    return errorMes;
  };

  TLEItemChange.writeItemValueToPageValue = function(item) {
    var idx, key, results, te, tes;
    tes = getTimelinePageValue(Constant.PageValueKey.TE_PREFIX);
    results = [];
    for (idx in tes) {
      te = tes[idx];
      if (te.id === item.id) {
        key = "" + Constant.PageValueKey.TE_PREFIX + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + idx + Constant.PageValueKey.PAGE_VALUES_SEPERATOR + this.minObj;
        results.push(setTimelinePageValue(key, item.getMinimumObject()));
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  TLEItemChange.readFromPageValue = function(timelineConfig, item) {
    var ret;
    ret = TLEItemChange.__super__.constructor.readFromPageValue.call(this, timelineConfig);
    return ret;
  };

  return TLEItemChange;

})(TimelineEvent);

//# sourceMappingURL=item_change.js.map
