// Generated by CoffeeScript 1.9.2
var TLEScreenPositionChange,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

TLEScreenPositionChange = (function(superClass) {
  extend(TLEScreenPositionChange, superClass);

  function TLEScreenPositionChange() {
    return TLEScreenPositionChange.__super__.constructor.apply(this, arguments);
  }

  TLEScreenPositionChange.X = 'x';

  TLEScreenPositionChange.Y = 'y';

  TLEScreenPositionChange.Z = 'z';

  TLEScreenPositionChange.writeToPageValue = function(timelineConfig) {
    var emt, errorMes, value, writeValue;
    errorMes = "";
    emt = timelineConfig.emt;
    writeValue = TLEScreenPositionChange.__super__.constructor.writeToPageValue.call(this, timelineConfig);
    value = {};
    value[this.X] = $('.screenposition_change_x:first', emt).val();
    value[this.Y] = $('.screenposition_change_y:first', emt).val();
    value[this.Z] = $('.screenposition_change_z:first', emt).val();
    if (errorMes.length === 0) {
      writeValue[this.PageValueKey.VALUE] = value;
      setTimelinePageValue(this.PageValueKey.te(timelineConfig.teNum), writeValue, timelineConfig.teNum);
      setTimelinePageValue(Constant.PageValueKey.TE_COUNT, timelineConfig.teNum);
    }
    return errorMes;
  };

  TLEScreenPositionChange.readFromPageValue = function(timelineConfig) {
    var emt, ret, value, writeValue;
    ret = TLEScreenPositionChange.__super__.constructor.readFromPageValue.call(this, timelineConfig);
    if (!ret) {
      return false;
    }
    emt = timelineConfig.emt;
    writeValue = getTimelinePageValue(this.PageValueKey.te(timelineConfig.teNum));
    value = writeValue[this.PageValueKey.VALUE];
    $('.screenposition_change_x:first', emt).val(value[this.X]);
    $('.screenposition_change_y:first', emt).val(value[this.Y]);
    $('.screenposition_change_z:first', emt).val(value[this.Z]);
    return true;
  };

  return TLEScreenPositionChange;

})(TimelineEvent);

//# sourceMappingURL=screenposition_change.js.map
