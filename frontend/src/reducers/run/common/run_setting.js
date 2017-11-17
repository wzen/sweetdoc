import PageValue from '../../../base/page_value';

let constant = undefined;
export default class RunSetting {
  static initClass() {
    // 定数
    constant = gon.const;
    this.ROOT_ID_NAME = constant.Setting.ROOT_ID_NAME;
    const Cls = (this.PageValueKey = class PageValueKey {
      static initClass() {
        this.SHOW_GUIDE = PageValue.Key.ST_PREFIX + PageValue.Key.PAGE_VALUES_SEPERATOR + 'show_guide';
      }
    });
    Cls.initClass();
  }

  // ガイド表示
  static isShowGuide() {
    let ret = PageValue.getSettingPageValue(this.PageValueKey.SHOW_GUIDE);
    ret = (ret === null) || (ret === 'true');
    return ret;
  }

  // ガイド切り替え
  static toggleShowGuide() {
    PageValue.setSettingPageValue(this.PageValueKey.SHOW_GUIDE, !this.isShowGuide());
    if(window.eventAction !== null) {
      if(this.isShowGuide()) {
        return window.eventAction.thisPage().thisChapter().showGuide();
      } else {
        return window.eventAction.thisPage().thisChapter().hideGuide();
      }
    }
  }
};
RunSetting.initClass();


