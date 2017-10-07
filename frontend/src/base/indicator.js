/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Indicator {
  static initClass() {
    const Cls = (this.Type = class Type {
      static initClass() {
        this.TIMELINE = 0;
      }
    });
    Cls.initClass();
  }

  // インジケータ表示
  // @param [Integer] type 設定するインジケータのタイプ
  static showIndicator(type) {
    this.hideIndicator(type);

    let rootEmt = null;
    if(type === this.Type.TIMELINE) {
      rootEmt = $('#timeline_events_container');
    }

    if(rootEmt != null) {
      const temp = $('.indicator_overlay_temp').clone(true).attr('class', 'indicator_overlay').show();
      rootEmt.append(temp);
      return $('.indicator_overlay', rootEmt).off('click').on('click', () => false);
    }
  }

  // インジケータ非表示
  // @param [Integer] type 設定するインジケータのタイプ
  static hideIndicator(type) {
    let rootEmt = null;
    if(type === this.Type.TIMELINE) {
      rootEmt = $('#timeline_events_container');
    }

    if(rootEmt != null) {
      return $('.indicator_overlay', rootEmt).remove();
    }
  }
}

Indicator.initClass();
