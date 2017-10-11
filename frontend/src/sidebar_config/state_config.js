/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
var StateConfig = (function() {
  let constant = undefined;
  StateConfig = class StateConfig {
    static initClass() {
      // 定数
      constant = gon.const;
      this.ROOT_ID_NAME = constant.StateConfig.ROOT_ID_NAME;
    }

    // 設定値初期化
    static initConfig() {
      let emt;
      (() => {
        // Background Color
        emt = $(`#${this.ROOT_ID_NAME} .configBox.background`);
        let be = new BackgroundEvent();
        return ColorPickerUtil.initColorPicker(
          emt.find('.colorPicker:first'),
          be.backgroundColor,
          (a, b, d, e) => {
            be = new BackgroundEvent();
            return be.backgroundColor = `#${b}`;
          });
      })();

      return (() => {
        // Screen
        let h, screenSize, w;
        emt = $(`#${this.ROOT_ID_NAME} .configBox.screen_event`);
        let se = new ScreenEvent();
        let size = null;
        if(se.hasInitConfig()) {
          const center = Common.calcScrollCenterPosition(se.initConfigY, se.initConfigX);
          $('.initConfigX:first', emt).attr('disabled', '').removeClass('empty').val(center.left);
          $('.initConfigY:first', emt).attr('disabled', '').removeClass('empty').val(center.top);
          $('.initConfigScale:first', emt).attr('disabled', '').removeClass('empty').val(se.initConfigScale);
          $('.clear_pointing:first', emt).show();
          $('input', emt).off('change').on('change', e => {
            se = new ScreenEvent();
            const {target} = e;
            se[$(target).attr('class')] = Common.calcScrollTopLeftPosition($(target).val());
            return se.setItemAllPropToPageValue();
          });
          screenSize = Common.getScreenSize();
          w = screenSize.width / se.initConfigScale;
          h = screenSize.height / se.initConfigScale;
          size = {
            x: se.initConfigX - (w * 0.5),
            y: se.initConfigY - (h * 0.5),
            w,
            h
          };
          EventDragPointingRect.draw(size);
        } else {
          $('.initConfigX:first', emt).val('');
          $('.initConfigY:first', emt).val('');
          $('.initConfigScale:first', emt).val('');
          $('.clear_pointing:first', emt).hide();
        }

        const _updateConfigInput = function(emt, pointingSize) {
          const x = pointingSize.x + (pointingSize.w * 0.5);
          const y = pointingSize.y + (pointingSize.h * 0.5);
          let z = null;
          screenSize = Common.getScreenSize();
          if(pointingSize.w > pointingSize.h) {
            z = screenSize.width / pointingSize.w;
          } else {
            z = screenSize.height / pointingSize.h;
          }
          $('.clear_pointing:first', emt).show();
          se = new ScreenEvent();
          return se.setInitConfig(x, y, z);
        };
        return emt.find('.event_pointing:first').eventDragPointingRect({
          applyDrawCallback: pointingSize => {
            if(window.debug) {
              console.log('applyDrawCallback');
              console.log(pointingSize);
            }
            return _updateConfigInput.call(this, emt, pointingSize);
          },
          closeCallback: () => {
            return EventDragPointingRect.draw(size);
          }
        });
      })();
    }

    static clearScreenConfig(withInitParams) {
      if(withInitParams === null) {
        withInitParams = false;
      }
      const emt = $(`#${this.ROOT_ID_NAME} .configBox.screen_event`);
      $('.initConfigX:first', emt).attr('disabled', 'disabled').addClass('empty').val('');
      $('.initConfigY:first', emt).attr('disabled', 'disabled').addClass('empty').val('');
      $('.initConfigScale:first', emt).attr('disabled', 'disabled').addClass('empty').val('');
      $('.clear_pointing:first', emt).hide();
      if(withInitParams) {
        const se = new ScreenEvent();
        se.clearInitConfig();
      }
      return EventDragPointingRect.clear();
    }
  };
  StateConfig.initClass();
  return StateConfig;
})();
