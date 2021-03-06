// Generated by CoffeeScript 1.9.2
var Indicator;

Indicator = (function() {
  function Indicator() {}

  Indicator.Type = (function() {
    function Type() {}

    Type.TIMELINE = 0;

    return Type;

  })();

  Indicator.showIndicator = function(type) {
    var rootEmt, temp;
    this.hideIndicator(type);
    rootEmt = null;
    if (type === this.Type.TIMELINE) {
      rootEmt = $('#timeline_events_container');
    }
    if (rootEmt != null) {
      temp = $('.indicator_overlay_temp').clone(true).attr('class', 'indicator_overlay').show();
      rootEmt.append(temp);
      return $('.indicator_overlay', rootEmt).off('click').on('click', function() {
        return false;
      });
    }
  };

  Indicator.hideIndicator = function(type) {
    var rootEmt;
    rootEmt = null;
    if (type === this.Type.TIMELINE) {
      rootEmt = $('#timeline_events_container');
    }
    if (rootEmt != null) {
      return $('.indicator_overlay', rootEmt).remove();
    }
  };

  return Indicator;

})();

//# sourceMappingURL=indicator.js.map
