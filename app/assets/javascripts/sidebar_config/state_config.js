// Generated by CoffeeScript 1.9.2
var StateConfig;

StateConfig = (function() {
  var constant;

  function StateConfig() {}

  constant = gon["const"];

  StateConfig.ROOT_ID_NAME = constant.StateConfig.ROOT_ID_NAME;

  StateConfig.initConfig = function() {
    (function(_this) {
      return (function() {
        var be, emt;
        emt = $("#" + _this.ROOT_ID_NAME + " .configBox.background");
        be = new BackgroundEvent();
        return ColorPickerUtil.initColorPicker(emt.find('.colorPicker:first'), be.backgroundColor, function(a, b, d, e) {
          be = new BackgroundEvent();
          return be.backgroundColor = "#" + b;
        });
      });
    })(this)();
    return (function(_this) {
      return function() {
        var _updateConfigInput, center, emt, h, screenSize, se, size, w;
        emt = $("#" + _this.ROOT_ID_NAME + " .configBox.screen_event");
        se = new ScreenEvent();
        size = null;
        if (se.hasInitConfig()) {
          center = Common.calcScrollCenterPosition(se.initConfigY, se.initConfigX);
          $('.initConfigX:first', emt).attr('disabled', '').removeClass('empty').val(center.left);
          $('.initConfigY:first', emt).attr('disabled', '').removeClass('empty').val(center.top);
          $('.initConfigScale:first', emt).attr('disabled', '').removeClass('empty').val(se.initConfigScale);
          $('.clear_pointing:first', emt).show();
          $('input', emt).off('change').on('change', function(e) {
            var target;
            se = new ScreenEvent();
            target = e.target;
            se[$(target).attr('class')] = Common.calcScrollTopLeftPosition($(target).val());
            return se.setItemAllPropToPageValue();
          });
          screenSize = Common.getScreenSize();
          w = screenSize.width / se.initConfigScale;
          h = screenSize.height / se.initConfigScale;
          size = {
            x: se.initConfigX - w * 0.5,
            y: se.initConfigY - h * 0.5,
            w: w,
            h: h
          };
          EventDragPointingRect.draw(size);
        } else {
          $('.initConfigX:first', emt).val('');
          $('.initConfigY:first', emt).val('');
          $('.initConfigScale:first', emt).val('');
          $('.clear_pointing:first', emt).hide();
        }
        _updateConfigInput = function(emt, pointingSize) {
          var x, y, z;
          x = pointingSize.x + pointingSize.w * 0.5;
          y = pointingSize.y + pointingSize.h * 0.5;
          z = null;
          screenSize = Common.getScreenSize();
          if (pointingSize.w > pointingSize.h) {
            z = screenSize.width / pointingSize.w;
          } else {
            z = screenSize.height / pointingSize.h;
          }
          $('.clear_pointing:first', emt).show();
          se = new ScreenEvent();
          return se.setInitConfig(x, y, z);
        };
        return emt.find('.event_pointing:first').eventDragPointingRect({
          applyDrawCallback: function(pointingSize) {
            if (window.debug) {
              console.log('applyDrawCallback');
              console.log(pointingSize);
            }
            return _updateConfigInput.call(_this, emt, pointingSize);
          },
          closeCallback: function() {
            return EventDragPointingRect.draw(size);
          }
        });
      };
    })(this)();
  };

  StateConfig.clearScreenConfig = function(withInitParams) {
    var emt, se;
    if (withInitParams == null) {
      withInitParams = false;
    }
    emt = $("#" + this.ROOT_ID_NAME + " .configBox.screen_event");
    $('.initConfigX:first', emt).attr('disabled', 'disabled').addClass('empty').val('');
    $('.initConfigY:first', emt).attr('disabled', 'disabled').addClass('empty').val('');
    $('.initConfigScale:first', emt).attr('disabled', 'disabled').addClass('empty').val('');
    $('.clear_pointing:first', emt).hide();
    if (withInitParams) {
      se = new ScreenEvent();
      se.clearInitConfig();
    }
    return EventDragPointingRect.clear();
  };

  return StateConfig;

})();

//# sourceMappingURL=state_config.js.map
